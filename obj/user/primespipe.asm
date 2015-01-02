
obj/user/primespipe.debug:     file format elf64-x86-64


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
  80003c:	e8 df 03 00 00       	callq  800420 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 40          	sub    $0x40,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004f:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800053:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800056:	ba 04 00 00 00       	mov    $0x4,%edx
  80005b:	48 89 ce             	mov    %rcx,%rsi
  80005e:	89 c7                	mov    %eax,%edi
  800060:	48 b8 0d 2c 80 00 00 	movabs $0x802c0d,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800073:	74 42                	je     8000b7 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
  80007a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007e:	89 c2                	mov    %eax,%edx
  800080:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  800084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800087:	41 89 d0             	mov    %edx,%r8d
  80008a:	89 c1                	mov    %eax,%ecx
  80008c:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  800093:	00 00 00 
  800096:	be 15 00 00 00       	mov    $0x15,%esi
  80009b:	48 bf cf 47 80 00 00 	movabs $0x8047cf,%rdi
  8000a2:	00 00 00 
  8000a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000aa:	49 b9 e8 04 80 00 00 	movabs $0x8004e8,%r9
  8000b1:	00 00 00 
  8000b4:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000ba:	89 c6                	mov    %eax,%esi
  8000bc:	48 bf e1 47 80 00 00 	movabs $0x8047e1,%rdi
  8000c3:	00 00 00 
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	48 ba 23 07 80 00 00 	movabs $0x800723,%rdx
  8000d2:	00 00 00 
  8000d5:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d7:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000db:	48 89 c7             	mov    %rax,%rdi
  8000de:	48 b8 30 3b 80 00 00 	movabs $0x803b30,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
  8000ea:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ed:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	79 30                	jns    800124 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f7:	89 c1                	mov    %eax,%ecx
  8000f9:	48 ba e5 47 80 00 00 	movabs $0x8047e5,%rdx
  800100:	00 00 00 
  800103:	be 1b 00 00 00       	mov    $0x1b,%esi
  800108:	48 bf cf 47 80 00 00 	movabs $0x8047cf,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  80011e:	00 00 00 
  800121:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800124:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
  800130:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800133:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800137:	79 30                	jns    800169 <primeproc+0x125>
		panic("fork: %e", id);
  800139:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013c:	89 c1                	mov    %eax,%ecx
  80013e:	48 ba ee 47 80 00 00 	movabs $0x8047ee,%rdx
  800145:	00 00 00 
  800148:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014d:	48 bf cf 47 80 00 00 	movabs $0x8047cf,%rdi
  800154:	00 00 00 
  800157:	b8 00 00 00 00       	mov    $0x0,%eax
  80015c:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  800163:	00 00 00 
  800166:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800169:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016d:	75 2d                	jne    80019c <primeproc+0x158>
		close(fd);
  80016f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800172:	89 c7                	mov    %eax,%edi
  800174:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
		close(pfd[1]);
  800180:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800183:	89 c7                	mov    %eax,%edi
  800185:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  80018c:	00 00 00 
  80018f:	ff d0                	callq  *%rax
		fd = pfd[0];
  800191:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800194:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800197:	e9 b3 fe ff ff       	jmpq   80004f <primeproc+0xb>
	}

	close(pfd[0]);
  80019c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019f:	89 c7                	mov    %eax,%edi
  8001a1:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  8001a8:	00 00 00 
  8001ab:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001b0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b3:	eb 01                	jmp    8001b6 <primeproc+0x172>
		if ((r=readn(fd, &i, 4)) != 4)
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
			if ((r=write(wfd, &i, 4)) != 4)
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
	}
  8001b5:	90                   	nop
	close(pfd[0]);
	wfd = pfd[1];

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b6:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001bd:	ba 04 00 00 00       	mov    $0x4,%edx
  8001c2:	48 89 ce             	mov    %rcx,%rsi
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	48 b8 0d 2c 80 00 00 	movabs $0x802c0d,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
  8001d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001da:	74 4e                	je     80022a <primeproc+0x1e6>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  8001eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ee:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001f1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f4:	89 14 24             	mov    %edx,(%rsp)
  8001f7:	41 89 f1             	mov    %esi,%r9d
  8001fa:	41 89 c8             	mov    %ecx,%r8d
  8001fd:	89 c1                	mov    %eax,%ecx
  8001ff:	48 ba f7 47 80 00 00 	movabs $0x8047f7,%rdx
  800206:	00 00 00 
  800209:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020e:	48 bf cf 47 80 00 00 	movabs $0x8047cf,%rdi
  800215:	00 00 00 
  800218:	b8 00 00 00 00       	mov    $0x0,%eax
  80021d:	49 ba e8 04 80 00 00 	movabs $0x8004e8,%r10
  800224:	00 00 00 
  800227:	41 ff d2             	callq  *%r10
		if (i%p)
  80022a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80022d:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  800230:	89 c2                	mov    %eax,%edx
  800232:	c1 fa 1f             	sar    $0x1f,%edx
  800235:	f7 f9                	idiv   %ecx
  800237:	89 d0                	mov    %edx,%eax
  800239:	85 c0                	test   %eax,%eax
  80023b:	0f 84 74 ff ff ff    	je     8001b5 <primeproc+0x171>
			if ((r=write(wfd, &i, 4)) != 4)
  800241:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800245:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800248:	ba 04 00 00 00       	mov    $0x4,%edx
  80024d:	48 89 ce             	mov    %rcx,%rsi
  800250:	89 c7                	mov    %eax,%edi
  800252:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  800259:	00 00 00 
  80025c:	ff d0                	callq  *%rax
  80025e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800261:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800265:	0f 84 4a ff ff ff    	je     8001b5 <primeproc+0x171>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80026b:	b8 00 00 00 00       	mov    $0x0,%eax
  800270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800274:	89 c1                	mov    %eax,%ecx
  800276:	0f 4e 4d fc          	cmovle -0x4(%rbp),%ecx
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800280:	41 89 c9             	mov    %ecx,%r9d
  800283:	41 89 d0             	mov    %edx,%r8d
  800286:	89 c1                	mov    %eax,%ecx
  800288:	48 ba 13 48 80 00 00 	movabs $0x804813,%rdx
  80028f:	00 00 00 
  800292:	be 2e 00 00 00       	mov    $0x2e,%esi
  800297:	48 bf cf 47 80 00 00 	movabs $0x8047cf,%rdi
  80029e:	00 00 00 
  8002a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a6:	49 ba e8 04 80 00 00 	movabs $0x8004e8,%r10
  8002ad:	00 00 00 
  8002b0:	41 ff d2             	callq  *%r10

00000000008002b3 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8002b3:	55                   	push   %rbp
  8002b4:	48 89 e5             	mov    %rsp,%rbp
  8002b7:	48 83 ec 30          	sub    $0x30,%rsp
  8002bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8002be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002c2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002c9:	00 00 00 
  8002cc:	48 ba 2d 48 80 00 00 	movabs $0x80482d,%rdx
  8002d3:	00 00 00 
  8002d6:	48 89 10             	mov    %rdx,(%rax)

	if ((i=pipe(p)) < 0)
  8002d9:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002dd:	48 89 c7             	mov    %rax,%rdi
  8002e0:	48 b8 30 3b 80 00 00 	movabs $0x803b30,%rax
  8002e7:	00 00 00 
  8002ea:	ff d0                	callq  *%rax
  8002ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002f2:	85 c0                	test   %eax,%eax
  8002f4:	79 30                	jns    800326 <umain+0x73>
		panic("pipe: %e", i);
  8002f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002f9:	89 c1                	mov    %eax,%ecx
  8002fb:	48 ba e5 47 80 00 00 	movabs $0x8047e5,%rdx
  800302:	00 00 00 
  800305:	be 3a 00 00 00       	mov    $0x3a,%esi
  80030a:	48 bf cf 47 80 00 00 	movabs $0x8047cf,%rdi
  800311:	00 00 00 
  800314:	b8 00 00 00 00       	mov    $0x0,%eax
  800319:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  800320:	00 00 00 
  800323:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800326:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
  800332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800339:	79 30                	jns    80036b <umain+0xb8>
		panic("fork: %e", id);
  80033b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	48 ba ee 47 80 00 00 	movabs $0x8047ee,%rdx
  800347:	00 00 00 
  80034a:	be 3e 00 00 00       	mov    $0x3e,%esi
  80034f:	48 bf cf 47 80 00 00 	movabs $0x8047cf,%rdi
  800356:	00 00 00 
  800359:	b8 00 00 00 00       	mov    $0x0,%eax
  80035e:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  800365:	00 00 00 
  800368:	41 ff d0             	callq  *%r8

	if (id == 0) {
  80036b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80036f:	75 22                	jne    800393 <umain+0xe0>
		close(p[1]);
  800371:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800374:	89 c7                	mov    %eax,%edi
  800376:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  80037d:	00 00 00 
  800380:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800382:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800385:	89 c7                	mov    %eax,%edi
  800387:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80038e:	00 00 00 
  800391:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800393:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800396:	89 c7                	mov    %eax,%edi
  800398:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  8003a4:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003ae:	48 8d 4d f4          	lea    -0xc(%rbp),%rcx
  8003b2:	ba 04 00 00 00       	mov    $0x4,%edx
  8003b7:	48 89 ce             	mov    %rcx,%rsi
  8003ba:	89 c7                	mov    %eax,%edi
  8003bc:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  8003c3:	00 00 00 
  8003c6:	ff d0                	callq  *%rax
  8003c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003cb:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
  8003cf:	74 42                	je     800413 <umain+0x160>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8003da:	89 c2                	mov    %eax,%edx
  8003dc:	0f 4e 55 f8          	cmovle -0x8(%rbp),%edx
  8003e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003e3:	41 89 d0             	mov    %edx,%r8d
  8003e6:	89 c1                	mov    %eax,%ecx
  8003e8:	48 ba 38 48 80 00 00 	movabs $0x804838,%rdx
  8003ef:	00 00 00 
  8003f2:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003f7:	48 bf cf 47 80 00 00 	movabs $0x8047cf,%rdi
  8003fe:	00 00 00 
  800401:	b8 00 00 00 00       	mov    $0x0,%eax
  800406:	49 b9 e8 04 80 00 00 	movabs $0x8004e8,%r9
  80040d:	00 00 00 
  800410:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800413:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800416:	83 c0 01             	add    $0x1,%eax
  800419:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  80041c:	eb 8d                	jmp    8003ab <umain+0xf8>
	...

0000000000800420 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800420:	55                   	push   %rbp
  800421:	48 89 e5             	mov    %rsp,%rbp
  800424:	48 83 ec 10          	sub    $0x10,%rsp
  800428:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80042f:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800436:	00 00 00 
  800439:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800440:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  800447:	00 00 00 
  80044a:	ff d0                	callq  *%rax
  80044c:	48 98                	cltq   
  80044e:	48 89 c2             	mov    %rax,%rdx
  800451:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800457:	48 89 d0             	mov    %rdx,%rax
  80045a:	48 c1 e0 03          	shl    $0x3,%rax
  80045e:	48 01 d0             	add    %rdx,%rax
  800461:	48 c1 e0 05          	shl    $0x5,%rax
  800465:	48 89 c2             	mov    %rax,%rdx
  800468:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80046f:	00 00 00 
  800472:	48 01 c2             	add    %rax,%rdx
  800475:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80047c:	00 00 00 
  80047f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800482:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800486:	7e 14                	jle    80049c <libmain+0x7c>
		binaryname = argv[0];
  800488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80048c:	48 8b 10             	mov    (%rax),%rdx
  80048f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800496:	00 00 00 
  800499:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80049c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a3:	48 89 d6             	mov    %rdx,%rsi
  8004a6:	89 c7                	mov    %eax,%edi
  8004a8:	48 b8 b3 02 80 00 00 	movabs $0x8002b3,%rax
  8004af:	00 00 00 
  8004b2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004b4:	48 b8 c4 04 80 00 00 	movabs $0x8004c4,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax
}
  8004c0:	c9                   	leaveq 
  8004c1:	c3                   	retq   
	...

00000000008004c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004c4:	55                   	push   %rbp
  8004c5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004c8:	48 b8 5d 29 80 00 00 	movabs $0x80295d,%rax
  8004cf:	00 00 00 
  8004d2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8004d9:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  8004e0:	00 00 00 
  8004e3:	ff d0                	callq  *%rax
}
  8004e5:	5d                   	pop    %rbp
  8004e6:	c3                   	retq   
	...

00000000008004e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004e8:	55                   	push   %rbp
  8004e9:	48 89 e5             	mov    %rsp,%rbp
  8004ec:	53                   	push   %rbx
  8004ed:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004f4:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004fb:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800501:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800508:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80050f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800516:	84 c0                	test   %al,%al
  800518:	74 23                	je     80053d <_panic+0x55>
  80051a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800521:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800525:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800529:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80052d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800531:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800535:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800539:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80053d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800544:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80054b:	00 00 00 
  80054e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800555:	00 00 00 
  800558:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80055c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800563:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80056a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800571:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800578:	00 00 00 
  80057b:	48 8b 18             	mov    (%rax),%rbx
  80057e:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  800585:	00 00 00 
  800588:	ff d0                	callq  *%rax
  80058a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800590:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800597:	41 89 c8             	mov    %ecx,%r8d
  80059a:	48 89 d1             	mov    %rdx,%rcx
  80059d:	48 89 da             	mov    %rbx,%rdx
  8005a0:	89 c6                	mov    %eax,%esi
  8005a2:	48 bf 60 48 80 00 00 	movabs $0x804860,%rdi
  8005a9:	00 00 00 
  8005ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b1:	49 b9 23 07 80 00 00 	movabs $0x800723,%r9
  8005b8:	00 00 00 
  8005bb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005be:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005c5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005cc:	48 89 d6             	mov    %rdx,%rsi
  8005cf:	48 89 c7             	mov    %rax,%rdi
  8005d2:	48 b8 77 06 80 00 00 	movabs $0x800677,%rax
  8005d9:	00 00 00 
  8005dc:	ff d0                	callq  *%rax
	cprintf("\n");
  8005de:	48 bf 83 48 80 00 00 	movabs $0x804883,%rdi
  8005e5:	00 00 00 
  8005e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ed:	48 ba 23 07 80 00 00 	movabs $0x800723,%rdx
  8005f4:	00 00 00 
  8005f7:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005f9:	cc                   	int3   
  8005fa:	eb fd                	jmp    8005f9 <_panic+0x111>

00000000008005fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005fc:	55                   	push   %rbp
  8005fd:	48 89 e5             	mov    %rsp,%rbp
  800600:	48 83 ec 10          	sub    $0x10,%rsp
  800604:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800607:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80060b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060f:	8b 00                	mov    (%rax),%eax
  800611:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800614:	89 d6                	mov    %edx,%esi
  800616:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80061a:	48 63 d0             	movslq %eax,%rdx
  80061d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800622:	8d 50 01             	lea    0x1(%rax),%edx
  800625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800629:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80062b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062f:	8b 00                	mov    (%rax),%eax
  800631:	3d ff 00 00 00       	cmp    $0xff,%eax
  800636:	75 2c                	jne    800664 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	48 98                	cltq   
  800640:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800644:	48 83 c2 08          	add    $0x8,%rdx
  800648:	48 89 c6             	mov    %rax,%rsi
  80064b:	48 89 d7             	mov    %rdx,%rdi
  80064e:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  800655:	00 00 00 
  800658:	ff d0                	callq  *%rax
		b->idx = 0;
  80065a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800668:	8b 40 04             	mov    0x4(%rax),%eax
  80066b:	8d 50 01             	lea    0x1(%rax),%edx
  80066e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800672:	89 50 04             	mov    %edx,0x4(%rax)
}
  800675:	c9                   	leaveq 
  800676:	c3                   	retq   

0000000000800677 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800677:	55                   	push   %rbp
  800678:	48 89 e5             	mov    %rsp,%rbp
  80067b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800682:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800689:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800690:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800697:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80069e:	48 8b 0a             	mov    (%rdx),%rcx
  8006a1:	48 89 08             	mov    %rcx,(%rax)
  8006a4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006a8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006ac:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006b0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006b4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006bb:	00 00 00 
	b.cnt = 0;
  8006be:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006c5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8006c8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006cf:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006d6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006dd:	48 89 c6             	mov    %rax,%rsi
  8006e0:	48 bf fc 05 80 00 00 	movabs $0x8005fc,%rdi
  8006e7:	00 00 00 
  8006ea:	48 b8 d4 0a 80 00 00 	movabs $0x800ad4,%rax
  8006f1:	00 00 00 
  8006f4:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8006f6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006fc:	48 98                	cltq   
  8006fe:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800705:	48 83 c2 08          	add    $0x8,%rdx
  800709:	48 89 c6             	mov    %rax,%rsi
  80070c:	48 89 d7             	mov    %rdx,%rdi
  80070f:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  800716:	00 00 00 
  800719:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80071b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800721:	c9                   	leaveq 
  800722:	c3                   	retq   

0000000000800723 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800723:	55                   	push   %rbp
  800724:	48 89 e5             	mov    %rsp,%rbp
  800727:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80072e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800735:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80073c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800743:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80074a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800751:	84 c0                	test   %al,%al
  800753:	74 20                	je     800775 <cprintf+0x52>
  800755:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800759:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80075d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800761:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800765:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800769:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80076d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800771:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800775:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80077c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800783:	00 00 00 
  800786:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80078d:	00 00 00 
  800790:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800794:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80079b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007a2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007a9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007b0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007b7:	48 8b 0a             	mov    (%rdx),%rcx
  8007ba:	48 89 08             	mov    %rcx,(%rax)
  8007bd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007c1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007c5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007c9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8007cd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007db:	48 89 d6             	mov    %rdx,%rsi
  8007de:	48 89 c7             	mov    %rax,%rdi
  8007e1:	48 b8 77 06 80 00 00 	movabs $0x800677,%rax
  8007e8:	00 00 00 
  8007eb:	ff d0                	callq  *%rax
  8007ed:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8007f3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007f9:	c9                   	leaveq 
  8007fa:	c3                   	retq   
	...

00000000008007fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007fc:	55                   	push   %rbp
  8007fd:	48 89 e5             	mov    %rsp,%rbp
  800800:	48 83 ec 30          	sub    $0x30,%rsp
  800804:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800808:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80080c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800810:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800813:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800817:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80081e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800822:	77 52                	ja     800876 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800824:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800827:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80082b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80082e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	48 f7 75 d0          	divq   -0x30(%rbp)
  80083f:	48 89 c2             	mov    %rax,%rdx
  800842:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800845:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800848:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80084c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800850:	41 89 f9             	mov    %edi,%r9d
  800853:	48 89 c7             	mov    %rax,%rdi
  800856:	48 b8 fc 07 80 00 00 	movabs $0x8007fc,%rax
  80085d:	00 00 00 
  800860:	ff d0                	callq  *%rax
  800862:	eb 1c                	jmp    800880 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800864:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800868:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80086b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80086f:	48 89 d6             	mov    %rdx,%rsi
  800872:	89 c7                	mov    %eax,%edi
  800874:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800876:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80087a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80087e:	7f e4                	jg     800864 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800880:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800887:	ba 00 00 00 00       	mov    $0x0,%edx
  80088c:	48 f7 f1             	div    %rcx
  80088f:	48 89 d0             	mov    %rdx,%rax
  800892:	48 ba 68 4a 80 00 00 	movabs $0x804a68,%rdx
  800899:	00 00 00 
  80089c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008a0:	0f be c0             	movsbl %al,%eax
  8008a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008a7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8008ab:	48 89 d6             	mov    %rdx,%rsi
  8008ae:	89 c7                	mov    %eax,%edi
  8008b0:	ff d1                	callq  *%rcx
}
  8008b2:	c9                   	leaveq 
  8008b3:	c3                   	retq   

00000000008008b4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b4:	55                   	push   %rbp
  8008b5:	48 89 e5             	mov    %rsp,%rbp
  8008b8:	48 83 ec 20          	sub    $0x20,%rsp
  8008bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008c3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008c7:	7e 52                	jle    80091b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cd:	8b 00                	mov    (%rax),%eax
  8008cf:	83 f8 30             	cmp    $0x30,%eax
  8008d2:	73 24                	jae    8008f8 <getuint+0x44>
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e0:	8b 00                	mov    (%rax),%eax
  8008e2:	89 c0                	mov    %eax,%eax
  8008e4:	48 01 d0             	add    %rdx,%rax
  8008e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008eb:	8b 12                	mov    (%rdx),%edx
  8008ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f4:	89 0a                	mov    %ecx,(%rdx)
  8008f6:	eb 17                	jmp    80090f <getuint+0x5b>
  8008f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800900:	48 89 d0             	mov    %rdx,%rax
  800903:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800907:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090f:	48 8b 00             	mov    (%rax),%rax
  800912:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800916:	e9 a3 00 00 00       	jmpq   8009be <getuint+0x10a>
	else if (lflag)
  80091b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80091f:	74 4f                	je     800970 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	8b 00                	mov    (%rax),%eax
  800927:	83 f8 30             	cmp    $0x30,%eax
  80092a:	73 24                	jae    800950 <getuint+0x9c>
  80092c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800930:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800938:	8b 00                	mov    (%rax),%eax
  80093a:	89 c0                	mov    %eax,%eax
  80093c:	48 01 d0             	add    %rdx,%rax
  80093f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800943:	8b 12                	mov    (%rdx),%edx
  800945:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800948:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094c:	89 0a                	mov    %ecx,(%rdx)
  80094e:	eb 17                	jmp    800967 <getuint+0xb3>
  800950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800954:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800958:	48 89 d0             	mov    %rdx,%rax
  80095b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800963:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800967:	48 8b 00             	mov    (%rax),%rax
  80096a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80096e:	eb 4e                	jmp    8009be <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800974:	8b 00                	mov    (%rax),%eax
  800976:	83 f8 30             	cmp    $0x30,%eax
  800979:	73 24                	jae    80099f <getuint+0xeb>
  80097b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800987:	8b 00                	mov    (%rax),%eax
  800989:	89 c0                	mov    %eax,%eax
  80098b:	48 01 d0             	add    %rdx,%rax
  80098e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800992:	8b 12                	mov    (%rdx),%edx
  800994:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800997:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099b:	89 0a                	mov    %ecx,(%rdx)
  80099d:	eb 17                	jmp    8009b6 <getuint+0x102>
  80099f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009a7:	48 89 d0             	mov    %rdx,%rax
  8009aa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b6:	8b 00                	mov    (%rax),%eax
  8009b8:	89 c0                	mov    %eax,%eax
  8009ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009c2:	c9                   	leaveq 
  8009c3:	c3                   	retq   

00000000008009c4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009c4:	55                   	push   %rbp
  8009c5:	48 89 e5             	mov    %rsp,%rbp
  8009c8:	48 83 ec 20          	sub    $0x20,%rsp
  8009cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009d3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009d7:	7e 52                	jle    800a2b <getint+0x67>
		x=va_arg(*ap, long long);
  8009d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dd:	8b 00                	mov    (%rax),%eax
  8009df:	83 f8 30             	cmp    $0x30,%eax
  8009e2:	73 24                	jae    800a08 <getint+0x44>
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f0:	8b 00                	mov    (%rax),%eax
  8009f2:	89 c0                	mov    %eax,%eax
  8009f4:	48 01 d0             	add    %rdx,%rax
  8009f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fb:	8b 12                	mov    (%rdx),%edx
  8009fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a04:	89 0a                	mov    %ecx,(%rdx)
  800a06:	eb 17                	jmp    800a1f <getint+0x5b>
  800a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a10:	48 89 d0             	mov    %rdx,%rax
  800a13:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a1f:	48 8b 00             	mov    (%rax),%rax
  800a22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a26:	e9 a3 00 00 00       	jmpq   800ace <getint+0x10a>
	else if (lflag)
  800a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a2f:	74 4f                	je     800a80 <getint+0xbc>
		x=va_arg(*ap, long);
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	8b 00                	mov    (%rax),%eax
  800a37:	83 f8 30             	cmp    $0x30,%eax
  800a3a:	73 24                	jae    800a60 <getint+0x9c>
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a48:	8b 00                	mov    (%rax),%eax
  800a4a:	89 c0                	mov    %eax,%eax
  800a4c:	48 01 d0             	add    %rdx,%rax
  800a4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a53:	8b 12                	mov    (%rdx),%edx
  800a55:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a5c:	89 0a                	mov    %ecx,(%rdx)
  800a5e:	eb 17                	jmp    800a77 <getint+0xb3>
  800a60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a64:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a68:	48 89 d0             	mov    %rdx,%rax
  800a6b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a73:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a77:	48 8b 00             	mov    (%rax),%rax
  800a7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a7e:	eb 4e                	jmp    800ace <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	8b 00                	mov    (%rax),%eax
  800a86:	83 f8 30             	cmp    $0x30,%eax
  800a89:	73 24                	jae    800aaf <getint+0xeb>
  800a8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a97:	8b 00                	mov    (%rax),%eax
  800a99:	89 c0                	mov    %eax,%eax
  800a9b:	48 01 d0             	add    %rdx,%rax
  800a9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa2:	8b 12                	mov    (%rdx),%edx
  800aa4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aab:	89 0a                	mov    %ecx,(%rdx)
  800aad:	eb 17                	jmp    800ac6 <getint+0x102>
  800aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ab7:	48 89 d0             	mov    %rdx,%rax
  800aba:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800abe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ac6:	8b 00                	mov    (%rax),%eax
  800ac8:	48 98                	cltq   
  800aca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ace:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ad2:	c9                   	leaveq 
  800ad3:	c3                   	retq   

0000000000800ad4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ad4:	55                   	push   %rbp
  800ad5:	48 89 e5             	mov    %rsp,%rbp
  800ad8:	41 54                	push   %r12
  800ada:	53                   	push   %rbx
  800adb:	48 83 ec 60          	sub    $0x60,%rsp
  800adf:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ae3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ae7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aeb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800aef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800af3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800af7:	48 8b 0a             	mov    (%rdx),%rcx
  800afa:	48 89 08             	mov    %rcx,(%rax)
  800afd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b01:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b05:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b09:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b0d:	eb 17                	jmp    800b26 <vprintfmt+0x52>
			if (ch == '\0')
  800b0f:	85 db                	test   %ebx,%ebx
  800b11:	0f 84 d7 04 00 00    	je     800fee <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800b17:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b1b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b1f:	48 89 c6             	mov    %rax,%rsi
  800b22:	89 df                	mov    %ebx,%edi
  800b24:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b26:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b2a:	0f b6 00             	movzbl (%rax),%eax
  800b2d:	0f b6 d8             	movzbl %al,%ebx
  800b30:	83 fb 25             	cmp    $0x25,%ebx
  800b33:	0f 95 c0             	setne  %al
  800b36:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b3b:	84 c0                	test   %al,%al
  800b3d:	75 d0                	jne    800b0f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b3f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b43:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b4a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b51:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b58:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800b5f:	eb 04                	jmp    800b65 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800b61:	90                   	nop
  800b62:	eb 01                	jmp    800b65 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800b64:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b65:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b69:	0f b6 00             	movzbl (%rax),%eax
  800b6c:	0f b6 d8             	movzbl %al,%ebx
  800b6f:	89 d8                	mov    %ebx,%eax
  800b71:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b76:	83 e8 23             	sub    $0x23,%eax
  800b79:	83 f8 55             	cmp    $0x55,%eax
  800b7c:	0f 87 38 04 00 00    	ja     800fba <vprintfmt+0x4e6>
  800b82:	89 c0                	mov    %eax,%eax
  800b84:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b8b:	00 
  800b8c:	48 b8 90 4a 80 00 00 	movabs $0x804a90,%rax
  800b93:	00 00 00 
  800b96:	48 01 d0             	add    %rdx,%rax
  800b99:	48 8b 00             	mov    (%rax),%rax
  800b9c:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b9e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ba2:	eb c1                	jmp    800b65 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ba4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ba8:	eb bb                	jmp    800b65 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800baa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bb1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bb4:	89 d0                	mov    %edx,%eax
  800bb6:	c1 e0 02             	shl    $0x2,%eax
  800bb9:	01 d0                	add    %edx,%eax
  800bbb:	01 c0                	add    %eax,%eax
  800bbd:	01 d8                	add    %ebx,%eax
  800bbf:	83 e8 30             	sub    $0x30,%eax
  800bc2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bc5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bc9:	0f b6 00             	movzbl (%rax),%eax
  800bcc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bcf:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd2:	7e 63                	jle    800c37 <vprintfmt+0x163>
  800bd4:	83 fb 39             	cmp    $0x39,%ebx
  800bd7:	7f 5e                	jg     800c37 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bde:	eb d1                	jmp    800bb1 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800be0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be3:	83 f8 30             	cmp    $0x30,%eax
  800be6:	73 17                	jae    800bff <vprintfmt+0x12b>
  800be8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bef:	89 c0                	mov    %eax,%eax
  800bf1:	48 01 d0             	add    %rdx,%rax
  800bf4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf7:	83 c2 08             	add    $0x8,%edx
  800bfa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfd:	eb 0f                	jmp    800c0e <vprintfmt+0x13a>
  800bff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c03:	48 89 d0             	mov    %rdx,%rax
  800c06:	48 83 c2 08          	add    $0x8,%rdx
  800c0a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0e:	8b 00                	mov    (%rax),%eax
  800c10:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c13:	eb 23                	jmp    800c38 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800c15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c19:	0f 89 42 ff ff ff    	jns    800b61 <vprintfmt+0x8d>
				width = 0;
  800c1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c26:	e9 36 ff ff ff       	jmpq   800b61 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800c2b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c32:	e9 2e ff ff ff       	jmpq   800b65 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c37:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3c:	0f 89 22 ff ff ff    	jns    800b64 <vprintfmt+0x90>
				width = precision, precision = -1;
  800c42:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c45:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c48:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c4f:	e9 10 ff ff ff       	jmpq   800b64 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c54:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c58:	e9 08 ff ff ff       	jmpq   800b65 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c60:	83 f8 30             	cmp    $0x30,%eax
  800c63:	73 17                	jae    800c7c <vprintfmt+0x1a8>
  800c65:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6c:	89 c0                	mov    %eax,%eax
  800c6e:	48 01 d0             	add    %rdx,%rax
  800c71:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c74:	83 c2 08             	add    $0x8,%edx
  800c77:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c7a:	eb 0f                	jmp    800c8b <vprintfmt+0x1b7>
  800c7c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c80:	48 89 d0             	mov    %rdx,%rax
  800c83:	48 83 c2 08          	add    $0x8,%rdx
  800c87:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c8b:	8b 00                	mov    (%rax),%eax
  800c8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c91:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c95:	48 89 d6             	mov    %rdx,%rsi
  800c98:	89 c7                	mov    %eax,%edi
  800c9a:	ff d1                	callq  *%rcx
			break;
  800c9c:	e9 47 03 00 00       	jmpq   800fe8 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800ca1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca4:	83 f8 30             	cmp    $0x30,%eax
  800ca7:	73 17                	jae    800cc0 <vprintfmt+0x1ec>
  800ca9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb0:	89 c0                	mov    %eax,%eax
  800cb2:	48 01 d0             	add    %rdx,%rax
  800cb5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb8:	83 c2 08             	add    $0x8,%edx
  800cbb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cbe:	eb 0f                	jmp    800ccf <vprintfmt+0x1fb>
  800cc0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc4:	48 89 d0             	mov    %rdx,%rax
  800cc7:	48 83 c2 08          	add    $0x8,%rdx
  800ccb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccf:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cd1:	85 db                	test   %ebx,%ebx
  800cd3:	79 02                	jns    800cd7 <vprintfmt+0x203>
				err = -err;
  800cd5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cd7:	83 fb 10             	cmp    $0x10,%ebx
  800cda:	7f 16                	jg     800cf2 <vprintfmt+0x21e>
  800cdc:	48 b8 e0 49 80 00 00 	movabs $0x8049e0,%rax
  800ce3:	00 00 00 
  800ce6:	48 63 d3             	movslq %ebx,%rdx
  800ce9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ced:	4d 85 e4             	test   %r12,%r12
  800cf0:	75 2e                	jne    800d20 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800cf2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cf6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfa:	89 d9                	mov    %ebx,%ecx
  800cfc:	48 ba 79 4a 80 00 00 	movabs $0x804a79,%rdx
  800d03:	00 00 00 
  800d06:	48 89 c7             	mov    %rax,%rdi
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0e:	49 b8 f8 0f 80 00 00 	movabs $0x800ff8,%r8
  800d15:	00 00 00 
  800d18:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1b:	e9 c8 02 00 00       	jmpq   800fe8 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d20:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d28:	4c 89 e1             	mov    %r12,%rcx
  800d2b:	48 ba 82 4a 80 00 00 	movabs $0x804a82,%rdx
  800d32:	00 00 00 
  800d35:	48 89 c7             	mov    %rax,%rdi
  800d38:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3d:	49 b8 f8 0f 80 00 00 	movabs $0x800ff8,%r8
  800d44:	00 00 00 
  800d47:	41 ff d0             	callq  *%r8
			break;
  800d4a:	e9 99 02 00 00       	jmpq   800fe8 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d52:	83 f8 30             	cmp    $0x30,%eax
  800d55:	73 17                	jae    800d6e <vprintfmt+0x29a>
  800d57:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5e:	89 c0                	mov    %eax,%eax
  800d60:	48 01 d0             	add    %rdx,%rax
  800d63:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d66:	83 c2 08             	add    $0x8,%edx
  800d69:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d6c:	eb 0f                	jmp    800d7d <vprintfmt+0x2a9>
  800d6e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d72:	48 89 d0             	mov    %rdx,%rax
  800d75:	48 83 c2 08          	add    $0x8,%rdx
  800d79:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d7d:	4c 8b 20             	mov    (%rax),%r12
  800d80:	4d 85 e4             	test   %r12,%r12
  800d83:	75 0a                	jne    800d8f <vprintfmt+0x2bb>
				p = "(null)";
  800d85:	49 bc 85 4a 80 00 00 	movabs $0x804a85,%r12
  800d8c:	00 00 00 
			if (width > 0 && padc != '-')
  800d8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d93:	7e 7a                	jle    800e0f <vprintfmt+0x33b>
  800d95:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d99:	74 74                	je     800e0f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d9b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d9e:	48 98                	cltq   
  800da0:	48 89 c6             	mov    %rax,%rsi
  800da3:	4c 89 e7             	mov    %r12,%rdi
  800da6:	48 b8 a2 12 80 00 00 	movabs $0x8012a2,%rax
  800dad:	00 00 00 
  800db0:	ff d0                	callq  *%rax
  800db2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800db5:	eb 17                	jmp    800dce <vprintfmt+0x2fa>
					putch(padc, putdat);
  800db7:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800dbb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dbf:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800dc3:	48 89 d6             	mov    %rdx,%rsi
  800dc6:	89 c7                	mov    %eax,%edi
  800dc8:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dca:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd2:	7f e3                	jg     800db7 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd4:	eb 39                	jmp    800e0f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800dd6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dda:	74 1e                	je     800dfa <vprintfmt+0x326>
  800ddc:	83 fb 1f             	cmp    $0x1f,%ebx
  800ddf:	7e 05                	jle    800de6 <vprintfmt+0x312>
  800de1:	83 fb 7e             	cmp    $0x7e,%ebx
  800de4:	7e 14                	jle    800dfa <vprintfmt+0x326>
					putch('?', putdat);
  800de6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dea:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dee:	48 89 c6             	mov    %rax,%rsi
  800df1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800df6:	ff d2                	callq  *%rdx
  800df8:	eb 0f                	jmp    800e09 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800dfa:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dfe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e02:	48 89 c6             	mov    %rax,%rsi
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e09:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e0d:	eb 01                	jmp    800e10 <vprintfmt+0x33c>
  800e0f:	90                   	nop
  800e10:	41 0f b6 04 24       	movzbl (%r12),%eax
  800e15:	0f be d8             	movsbl %al,%ebx
  800e18:	85 db                	test   %ebx,%ebx
  800e1a:	0f 95 c0             	setne  %al
  800e1d:	49 83 c4 01          	add    $0x1,%r12
  800e21:	84 c0                	test   %al,%al
  800e23:	74 28                	je     800e4d <vprintfmt+0x379>
  800e25:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e29:	78 ab                	js     800dd6 <vprintfmt+0x302>
  800e2b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e2f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e33:	79 a1                	jns    800dd6 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e35:	eb 16                	jmp    800e4d <vprintfmt+0x379>
				putch(' ', putdat);
  800e37:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e3b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e3f:	48 89 c6             	mov    %rax,%rsi
  800e42:	bf 20 00 00 00       	mov    $0x20,%edi
  800e47:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e49:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e4d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e51:	7f e4                	jg     800e37 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800e53:	e9 90 01 00 00       	jmpq   800fe8 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e58:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e5c:	be 03 00 00 00       	mov    $0x3,%esi
  800e61:	48 89 c7             	mov    %rax,%rdi
  800e64:	48 b8 c4 09 80 00 00 	movabs $0x8009c4,%rax
  800e6b:	00 00 00 
  800e6e:	ff d0                	callq  *%rax
  800e70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e78:	48 85 c0             	test   %rax,%rax
  800e7b:	79 1d                	jns    800e9a <vprintfmt+0x3c6>
				putch('-', putdat);
  800e7d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e81:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e85:	48 89 c6             	mov    %rax,%rsi
  800e88:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e8d:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	48 f7 d8             	neg    %rax
  800e96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e9a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ea1:	e9 d5 00 00 00       	jmpq   800f7b <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ea6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eaa:	be 03 00 00 00       	mov    $0x3,%esi
  800eaf:	48 89 c7             	mov    %rax,%rdi
  800eb2:	48 b8 b4 08 80 00 00 	movabs $0x8008b4,%rax
  800eb9:	00 00 00 
  800ebc:	ff d0                	callq  *%rax
  800ebe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ec2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ec9:	e9 ad 00 00 00       	jmpq   800f7b <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800ece:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed2:	be 03 00 00 00       	mov    $0x3,%esi
  800ed7:	48 89 c7             	mov    %rax,%rdi
  800eda:	48 b8 b4 08 80 00 00 	movabs $0x8008b4,%rax
  800ee1:	00 00 00 
  800ee4:	ff d0                	callq  *%rax
  800ee6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800eea:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ef1:	e9 85 00 00 00       	jmpq   800f7b <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800ef6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800efa:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800efe:	48 89 c6             	mov    %rax,%rsi
  800f01:	bf 30 00 00 00       	mov    $0x30,%edi
  800f06:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800f08:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f0c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f10:	48 89 c6             	mov    %rax,%rsi
  800f13:	bf 78 00 00 00       	mov    $0x78,%edi
  800f18:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f1d:	83 f8 30             	cmp    $0x30,%eax
  800f20:	73 17                	jae    800f39 <vprintfmt+0x465>
  800f22:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f29:	89 c0                	mov    %eax,%eax
  800f2b:	48 01 d0             	add    %rdx,%rax
  800f2e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f31:	83 c2 08             	add    $0x8,%edx
  800f34:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f37:	eb 0f                	jmp    800f48 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800f39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f3d:	48 89 d0             	mov    %rdx,%rax
  800f40:	48 83 c2 08          	add    $0x8,%rdx
  800f44:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f48:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f4f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f56:	eb 23                	jmp    800f7b <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f58:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f5c:	be 03 00 00 00       	mov    $0x3,%esi
  800f61:	48 89 c7             	mov    %rax,%rdi
  800f64:	48 b8 b4 08 80 00 00 	movabs $0x8008b4,%rax
  800f6b:	00 00 00 
  800f6e:	ff d0                	callq  *%rax
  800f70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f74:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f7b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f80:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f83:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f92:	45 89 c1             	mov    %r8d,%r9d
  800f95:	41 89 f8             	mov    %edi,%r8d
  800f98:	48 89 c7             	mov    %rax,%rdi
  800f9b:	48 b8 fc 07 80 00 00 	movabs $0x8007fc,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax
			break;
  800fa7:	eb 3f                	jmp    800fe8 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fad:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fb1:	48 89 c6             	mov    %rax,%rsi
  800fb4:	89 df                	mov    %ebx,%edi
  800fb6:	ff d2                	callq  *%rdx
			break;
  800fb8:	eb 2e                	jmp    800fe8 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fba:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fbe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fc2:	48 89 c6             	mov    %rax,%rsi
  800fc5:	bf 25 00 00 00       	mov    $0x25,%edi
  800fca:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fcc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd1:	eb 05                	jmp    800fd8 <vprintfmt+0x504>
  800fd3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fdc:	48 83 e8 01          	sub    $0x1,%rax
  800fe0:	0f b6 00             	movzbl (%rax),%eax
  800fe3:	3c 25                	cmp    $0x25,%al
  800fe5:	75 ec                	jne    800fd3 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800fe7:	90                   	nop
		}
	}
  800fe8:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fe9:	e9 38 fb ff ff       	jmpq   800b26 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800fee:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800fef:	48 83 c4 60          	add    $0x60,%rsp
  800ff3:	5b                   	pop    %rbx
  800ff4:	41 5c                	pop    %r12
  800ff6:	5d                   	pop    %rbp
  800ff7:	c3                   	retq   

0000000000800ff8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff8:	55                   	push   %rbp
  800ff9:	48 89 e5             	mov    %rsp,%rbp
  800ffc:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801003:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80100a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801011:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801018:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80101f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801026:	84 c0                	test   %al,%al
  801028:	74 20                	je     80104a <printfmt+0x52>
  80102a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80102e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801032:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801036:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80103a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80103e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801042:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801046:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80104a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801051:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801058:	00 00 00 
  80105b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801062:	00 00 00 
  801065:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801069:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801070:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801077:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80107e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801085:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80108c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801093:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80109a:	48 89 c7             	mov    %rax,%rdi
  80109d:	48 b8 d4 0a 80 00 00 	movabs $0x800ad4,%rax
  8010a4:	00 00 00 
  8010a7:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010a9:	c9                   	leaveq 
  8010aa:	c3                   	retq   

00000000008010ab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	48 83 ec 10          	sub    $0x10,%rsp
  8010b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010be:	8b 40 10             	mov    0x10(%rax),%eax
  8010c1:	8d 50 01             	lea    0x1(%rax),%edx
  8010c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cf:	48 8b 10             	mov    (%rax),%rdx
  8010d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010da:	48 39 c2             	cmp    %rax,%rdx
  8010dd:	73 17                	jae    8010f6 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e3:	48 8b 00             	mov    (%rax),%rax
  8010e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010e9:	88 10                	mov    %dl,(%rax)
  8010eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f3:	48 89 10             	mov    %rdx,(%rax)
}
  8010f6:	c9                   	leaveq 
  8010f7:	c3                   	retq   

00000000008010f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f8:	55                   	push   %rbp
  8010f9:	48 89 e5             	mov    %rsp,%rbp
  8010fc:	48 83 ec 50          	sub    $0x50,%rsp
  801100:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801104:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801107:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80110b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80110f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801113:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801117:	48 8b 0a             	mov    (%rdx),%rcx
  80111a:	48 89 08             	mov    %rcx,(%rax)
  80111d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801121:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801125:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801129:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80112d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801131:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801135:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801138:	48 98                	cltq   
  80113a:	48 83 e8 01          	sub    $0x1,%rax
  80113e:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801142:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801146:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80114d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801152:	74 06                	je     80115a <vsnprintf+0x62>
  801154:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801158:	7f 07                	jg     801161 <vsnprintf+0x69>
		return -E_INVAL;
  80115a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115f:	eb 2f                	jmp    801190 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801161:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801165:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801169:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80116d:	48 89 c6             	mov    %rax,%rsi
  801170:	48 bf ab 10 80 00 00 	movabs $0x8010ab,%rdi
  801177:	00 00 00 
  80117a:	48 b8 d4 0a 80 00 00 	movabs $0x800ad4,%rax
  801181:	00 00 00 
  801184:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801186:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80118a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80118d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801190:	c9                   	leaveq 
  801191:	c3                   	retq   

0000000000801192 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801192:	55                   	push   %rbp
  801193:	48 89 e5             	mov    %rsp,%rbp
  801196:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80119d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011a4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011aa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011b1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011b8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011bf:	84 c0                	test   %al,%al
  8011c1:	74 20                	je     8011e3 <snprintf+0x51>
  8011c3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011c7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011cb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011cf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011d3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011d7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011db:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011df:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011e3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011ea:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011f1:	00 00 00 
  8011f4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011fb:	00 00 00 
  8011fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801202:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801209:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801210:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801217:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80121e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801225:	48 8b 0a             	mov    (%rdx),%rcx
  801228:	48 89 08             	mov    %rcx,(%rax)
  80122b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80122f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801233:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801237:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80123b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801242:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801249:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80124f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801256:	48 89 c7             	mov    %rax,%rdi
  801259:	48 b8 f8 10 80 00 00 	movabs $0x8010f8,%rax
  801260:	00 00 00 
  801263:	ff d0                	callq  *%rax
  801265:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80126b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801271:	c9                   	leaveq 
  801272:	c3                   	retq   
	...

0000000000801274 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801274:	55                   	push   %rbp
  801275:	48 89 e5             	mov    %rsp,%rbp
  801278:	48 83 ec 18          	sub    $0x18,%rsp
  80127c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801280:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801287:	eb 09                	jmp    801292 <strlen+0x1e>
		n++;
  801289:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80128d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801292:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801296:	0f b6 00             	movzbl (%rax),%eax
  801299:	84 c0                	test   %al,%al
  80129b:	75 ec                	jne    801289 <strlen+0x15>
		n++;
	return n;
  80129d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012a0:	c9                   	leaveq 
  8012a1:	c3                   	retq   

00000000008012a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012a2:	55                   	push   %rbp
  8012a3:	48 89 e5             	mov    %rsp,%rbp
  8012a6:	48 83 ec 20          	sub    $0x20,%rsp
  8012aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b9:	eb 0e                	jmp    8012c9 <strnlen+0x27>
		n++;
  8012bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012c9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012ce:	74 0b                	je     8012db <strnlen+0x39>
  8012d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d4:	0f b6 00             	movzbl (%rax),%eax
  8012d7:	84 c0                	test   %al,%al
  8012d9:	75 e0                	jne    8012bb <strnlen+0x19>
		n++;
	return n;
  8012db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012de:	c9                   	leaveq 
  8012df:	c3                   	retq   

00000000008012e0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012e0:	55                   	push   %rbp
  8012e1:	48 89 e5             	mov    %rsp,%rbp
  8012e4:	48 83 ec 20          	sub    $0x20,%rsp
  8012e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012f8:	90                   	nop
  8012f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fd:	0f b6 10             	movzbl (%rax),%edx
  801300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801304:	88 10                	mov    %dl,(%rax)
  801306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130a:	0f b6 00             	movzbl (%rax),%eax
  80130d:	84 c0                	test   %al,%al
  80130f:	0f 95 c0             	setne  %al
  801312:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801317:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80131c:	84 c0                	test   %al,%al
  80131e:	75 d9                	jne    8012f9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801324:	c9                   	leaveq 
  801325:	c3                   	retq   

0000000000801326 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801326:	55                   	push   %rbp
  801327:	48 89 e5             	mov    %rsp,%rbp
  80132a:	48 83 ec 20          	sub    $0x20,%rsp
  80132e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801332:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133a:	48 89 c7             	mov    %rax,%rdi
  80133d:	48 b8 74 12 80 00 00 	movabs $0x801274,%rax
  801344:	00 00 00 
  801347:	ff d0                	callq  *%rax
  801349:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80134c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80134f:	48 98                	cltq   
  801351:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801355:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801359:	48 89 d6             	mov    %rdx,%rsi
  80135c:	48 89 c7             	mov    %rax,%rdi
  80135f:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  801366:	00 00 00 
  801369:	ff d0                	callq  *%rax
	return dst;
  80136b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80136f:	c9                   	leaveq 
  801370:	c3                   	retq   

0000000000801371 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801371:	55                   	push   %rbp
  801372:	48 89 e5             	mov    %rsp,%rbp
  801375:	48 83 ec 28          	sub    $0x28,%rsp
  801379:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801381:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801389:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80138d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801394:	00 
  801395:	eb 27                	jmp    8013be <strncpy+0x4d>
		*dst++ = *src;
  801397:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80139b:	0f b6 10             	movzbl (%rax),%edx
  80139e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a2:	88 10                	mov    %dl,(%rax)
  8013a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ad:	0f b6 00             	movzbl (%rax),%eax
  8013b0:	84 c0                	test   %al,%al
  8013b2:	74 05                	je     8013b9 <strncpy+0x48>
			src++;
  8013b4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013c6:	72 cf                	jb     801397 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013cc:	c9                   	leaveq 
  8013cd:	c3                   	retq   

00000000008013ce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013ce:	55                   	push   %rbp
  8013cf:	48 89 e5             	mov    %rsp,%rbp
  8013d2:	48 83 ec 28          	sub    $0x28,%rsp
  8013d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013ea:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013ef:	74 37                	je     801428 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8013f1:	eb 17                	jmp    80140a <strlcpy+0x3c>
			*dst++ = *src++;
  8013f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f7:	0f b6 10             	movzbl (%rax),%edx
  8013fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fe:	88 10                	mov    %dl,(%rax)
  801400:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801405:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80140a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80140f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801414:	74 0b                	je     801421 <strlcpy+0x53>
  801416:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141a:	0f b6 00             	movzbl (%rax),%eax
  80141d:	84 c0                	test   %al,%al
  80141f:	75 d2                	jne    8013f3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801425:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801428:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80142c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801430:	48 89 d1             	mov    %rdx,%rcx
  801433:	48 29 c1             	sub    %rax,%rcx
  801436:	48 89 c8             	mov    %rcx,%rax
}
  801439:	c9                   	leaveq 
  80143a:	c3                   	retq   

000000000080143b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80143b:	55                   	push   %rbp
  80143c:	48 89 e5             	mov    %rsp,%rbp
  80143f:	48 83 ec 10          	sub    $0x10,%rsp
  801443:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801447:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80144b:	eb 0a                	jmp    801457 <strcmp+0x1c>
		p++, q++;
  80144d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801452:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145b:	0f b6 00             	movzbl (%rax),%eax
  80145e:	84 c0                	test   %al,%al
  801460:	74 12                	je     801474 <strcmp+0x39>
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801466:	0f b6 10             	movzbl (%rax),%edx
  801469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146d:	0f b6 00             	movzbl (%rax),%eax
  801470:	38 c2                	cmp    %al,%dl
  801472:	74 d9                	je     80144d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801474:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801478:	0f b6 00             	movzbl (%rax),%eax
  80147b:	0f b6 d0             	movzbl %al,%edx
  80147e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801482:	0f b6 00             	movzbl (%rax),%eax
  801485:	0f b6 c0             	movzbl %al,%eax
  801488:	89 d1                	mov    %edx,%ecx
  80148a:	29 c1                	sub    %eax,%ecx
  80148c:	89 c8                	mov    %ecx,%eax
}
  80148e:	c9                   	leaveq 
  80148f:	c3                   	retq   

0000000000801490 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801490:	55                   	push   %rbp
  801491:	48 89 e5             	mov    %rsp,%rbp
  801494:	48 83 ec 18          	sub    $0x18,%rsp
  801498:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 0f                	jmp    8014b5 <strncmp+0x25>
		n--, p++, q++;
  8014a6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ba:	74 1d                	je     8014d9 <strncmp+0x49>
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	0f b6 00             	movzbl (%rax),%eax
  8014c3:	84 c0                	test   %al,%al
  8014c5:	74 12                	je     8014d9 <strncmp+0x49>
  8014c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cb:	0f b6 10             	movzbl (%rax),%edx
  8014ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	38 c2                	cmp    %al,%dl
  8014d7:	74 cd                	je     8014a6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014de:	75 07                	jne    8014e7 <strncmp+0x57>
		return 0;
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e5:	eb 1a                	jmp    801501 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	0f b6 d0             	movzbl %al,%edx
  8014f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f5:	0f b6 00             	movzbl (%rax),%eax
  8014f8:	0f b6 c0             	movzbl %al,%eax
  8014fb:	89 d1                	mov    %edx,%ecx
  8014fd:	29 c1                	sub    %eax,%ecx
  8014ff:	89 c8                	mov    %ecx,%eax
}
  801501:	c9                   	leaveq 
  801502:	c3                   	retq   

0000000000801503 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801503:	55                   	push   %rbp
  801504:	48 89 e5             	mov    %rsp,%rbp
  801507:	48 83 ec 10          	sub    $0x10,%rsp
  80150b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80150f:	89 f0                	mov    %esi,%eax
  801511:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801514:	eb 17                	jmp    80152d <strchr+0x2a>
		if (*s == c)
  801516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801520:	75 06                	jne    801528 <strchr+0x25>
			return (char *) s;
  801522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801526:	eb 15                	jmp    80153d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801528:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80152d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	84 c0                	test   %al,%al
  801536:	75 de                	jne    801516 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153d:	c9                   	leaveq 
  80153e:	c3                   	retq   

000000000080153f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80153f:	55                   	push   %rbp
  801540:	48 89 e5             	mov    %rsp,%rbp
  801543:	48 83 ec 10          	sub    $0x10,%rsp
  801547:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154b:	89 f0                	mov    %esi,%eax
  80154d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801550:	eb 11                	jmp    801563 <strfind+0x24>
		if (*s == c)
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80155c:	74 12                	je     801570 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80155e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	84 c0                	test   %al,%al
  80156c:	75 e4                	jne    801552 <strfind+0x13>
  80156e:	eb 01                	jmp    801571 <strfind+0x32>
		if (*s == c)
			break;
  801570:	90                   	nop
	return (char *) s;
  801571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801575:	c9                   	leaveq 
  801576:	c3                   	retq   

0000000000801577 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801577:	55                   	push   %rbp
  801578:	48 89 e5             	mov    %rsp,%rbp
  80157b:	48 83 ec 18          	sub    $0x18,%rsp
  80157f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801583:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801586:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80158a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80158f:	75 06                	jne    801597 <memset+0x20>
		return v;
  801591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801595:	eb 69                	jmp    801600 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159b:	83 e0 03             	and    $0x3,%eax
  80159e:	48 85 c0             	test   %rax,%rax
  8015a1:	75 48                	jne    8015eb <memset+0x74>
  8015a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a7:	83 e0 03             	and    $0x3,%eax
  8015aa:	48 85 c0             	test   %rax,%rax
  8015ad:	75 3c                	jne    8015eb <memset+0x74>
		c &= 0xFF;
  8015af:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	c1 e2 18             	shl    $0x18,%edx
  8015be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c1:	c1 e0 10             	shl    $0x10,%eax
  8015c4:	09 c2                	or     %eax,%edx
  8015c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c9:	c1 e0 08             	shl    $0x8,%eax
  8015cc:	09 d0                	or     %edx,%eax
  8015ce:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d5:	48 89 c1             	mov    %rax,%rcx
  8015d8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e3:	48 89 d7             	mov    %rdx,%rdi
  8015e6:	fc                   	cld    
  8015e7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015e9:	eb 11                	jmp    8015fc <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015f6:	48 89 d7             	mov    %rdx,%rdi
  8015f9:	fc                   	cld    
  8015fa:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801600:	c9                   	leaveq 
  801601:	c3                   	retq   

0000000000801602 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801602:	55                   	push   %rbp
  801603:	48 89 e5             	mov    %rsp,%rbp
  801606:	48 83 ec 28          	sub    $0x28,%rsp
  80160a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80160e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801612:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80161a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80161e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801622:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80162e:	0f 83 88 00 00 00    	jae    8016bc <memmove+0xba>
  801634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801638:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163c:	48 01 d0             	add    %rdx,%rax
  80163f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801643:	76 77                	jbe    8016bc <memmove+0xba>
		s += n;
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80164d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801651:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801659:	83 e0 03             	and    $0x3,%eax
  80165c:	48 85 c0             	test   %rax,%rax
  80165f:	75 3b                	jne    80169c <memmove+0x9a>
  801661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801665:	83 e0 03             	and    $0x3,%eax
  801668:	48 85 c0             	test   %rax,%rax
  80166b:	75 2f                	jne    80169c <memmove+0x9a>
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	83 e0 03             	and    $0x3,%eax
  801674:	48 85 c0             	test   %rax,%rax
  801677:	75 23                	jne    80169c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167d:	48 83 e8 04          	sub    $0x4,%rax
  801681:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801685:	48 83 ea 04          	sub    $0x4,%rdx
  801689:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80168d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801691:	48 89 c7             	mov    %rax,%rdi
  801694:	48 89 d6             	mov    %rdx,%rsi
  801697:	fd                   	std    
  801698:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80169a:	eb 1d                	jmp    8016b9 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80169c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	48 89 d7             	mov    %rdx,%rdi
  8016b3:	48 89 c1             	mov    %rax,%rcx
  8016b6:	fd                   	std    
  8016b7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016b9:	fc                   	cld    
  8016ba:	eb 57                	jmp    801713 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c0:	83 e0 03             	and    $0x3,%eax
  8016c3:	48 85 c0             	test   %rax,%rax
  8016c6:	75 36                	jne    8016fe <memmove+0xfc>
  8016c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cc:	83 e0 03             	and    $0x3,%eax
  8016cf:	48 85 c0             	test   %rax,%rax
  8016d2:	75 2a                	jne    8016fe <memmove+0xfc>
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	83 e0 03             	and    $0x3,%eax
  8016db:	48 85 c0             	test   %rax,%rax
  8016de:	75 1e                	jne    8016fe <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e4:	48 89 c1             	mov    %rax,%rcx
  8016e7:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f3:	48 89 c7             	mov    %rax,%rdi
  8016f6:	48 89 d6             	mov    %rdx,%rsi
  8016f9:	fc                   	cld    
  8016fa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016fc:	eb 15                	jmp    801713 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801702:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801706:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80170a:	48 89 c7             	mov    %rax,%rdi
  80170d:	48 89 d6             	mov    %rdx,%rsi
  801710:	fc                   	cld    
  801711:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801717:	c9                   	leaveq 
  801718:	c3                   	retq   

0000000000801719 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801719:	55                   	push   %rbp
  80171a:	48 89 e5             	mov    %rsp,%rbp
  80171d:	48 83 ec 18          	sub    $0x18,%rsp
  801721:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801725:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801729:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80172d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801731:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801739:	48 89 ce             	mov    %rcx,%rsi
  80173c:	48 89 c7             	mov    %rax,%rdi
  80173f:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  801746:	00 00 00 
  801749:	ff d0                	callq  *%rax
}
  80174b:	c9                   	leaveq 
  80174c:	c3                   	retq   

000000000080174d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80174d:	55                   	push   %rbp
  80174e:	48 89 e5             	mov    %rsp,%rbp
  801751:	48 83 ec 28          	sub    $0x28,%rsp
  801755:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801759:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80175d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801765:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801769:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80176d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801771:	eb 38                	jmp    8017ab <memcmp+0x5e>
		if (*s1 != *s2)
  801773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801777:	0f b6 10             	movzbl (%rax),%edx
  80177a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	38 c2                	cmp    %al,%dl
  801783:	74 1c                	je     8017a1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	0f b6 d0             	movzbl %al,%edx
  80178f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801793:	0f b6 00             	movzbl (%rax),%eax
  801796:	0f b6 c0             	movzbl %al,%eax
  801799:	89 d1                	mov    %edx,%ecx
  80179b:	29 c1                	sub    %eax,%ecx
  80179d:	89 c8                	mov    %ecx,%eax
  80179f:	eb 20                	jmp    8017c1 <memcmp+0x74>
		s1++, s2++;
  8017a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017ab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017b0:	0f 95 c0             	setne  %al
  8017b3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8017b8:	84 c0                	test   %al,%al
  8017ba:	75 b7                	jne    801773 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c1:	c9                   	leaveq 
  8017c2:	c3                   	retq   

00000000008017c3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017c3:	55                   	push   %rbp
  8017c4:	48 89 e5             	mov    %rsp,%rbp
  8017c7:	48 83 ec 28          	sub    $0x28,%rsp
  8017cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017de:	48 01 d0             	add    %rdx,%rax
  8017e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017e5:	eb 13                	jmp    8017fa <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017eb:	0f b6 10             	movzbl (%rax),%edx
  8017ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017f1:	38 c2                	cmp    %al,%dl
  8017f3:	74 11                	je     801806 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017f5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fe:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801802:	72 e3                	jb     8017e7 <memfind+0x24>
  801804:	eb 01                	jmp    801807 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801806:	90                   	nop
	return (void *) s;
  801807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80180b:	c9                   	leaveq 
  80180c:	c3                   	retq   

000000000080180d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80180d:	55                   	push   %rbp
  80180e:	48 89 e5             	mov    %rsp,%rbp
  801811:	48 83 ec 38          	sub    $0x38,%rsp
  801815:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801819:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80181d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801820:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801827:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80182e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80182f:	eb 05                	jmp    801836 <strtol+0x29>
		s++;
  801831:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183a:	0f b6 00             	movzbl (%rax),%eax
  80183d:	3c 20                	cmp    $0x20,%al
  80183f:	74 f0                	je     801831 <strtol+0x24>
  801841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801845:	0f b6 00             	movzbl (%rax),%eax
  801848:	3c 09                	cmp    $0x9,%al
  80184a:	74 e5                	je     801831 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80184c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801850:	0f b6 00             	movzbl (%rax),%eax
  801853:	3c 2b                	cmp    $0x2b,%al
  801855:	75 07                	jne    80185e <strtol+0x51>
		s++;
  801857:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80185c:	eb 17                	jmp    801875 <strtol+0x68>
	else if (*s == '-')
  80185e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801862:	0f b6 00             	movzbl (%rax),%eax
  801865:	3c 2d                	cmp    $0x2d,%al
  801867:	75 0c                	jne    801875 <strtol+0x68>
		s++, neg = 1;
  801869:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80186e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801875:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801879:	74 06                	je     801881 <strtol+0x74>
  80187b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80187f:	75 28                	jne    8018a9 <strtol+0x9c>
  801881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801885:	0f b6 00             	movzbl (%rax),%eax
  801888:	3c 30                	cmp    $0x30,%al
  80188a:	75 1d                	jne    8018a9 <strtol+0x9c>
  80188c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801890:	48 83 c0 01          	add    $0x1,%rax
  801894:	0f b6 00             	movzbl (%rax),%eax
  801897:	3c 78                	cmp    $0x78,%al
  801899:	75 0e                	jne    8018a9 <strtol+0x9c>
		s += 2, base = 16;
  80189b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018a0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018a7:	eb 2c                	jmp    8018d5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018ad:	75 19                	jne    8018c8 <strtol+0xbb>
  8018af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b3:	0f b6 00             	movzbl (%rax),%eax
  8018b6:	3c 30                	cmp    $0x30,%al
  8018b8:	75 0e                	jne    8018c8 <strtol+0xbb>
		s++, base = 8;
  8018ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018bf:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018c6:	eb 0d                	jmp    8018d5 <strtol+0xc8>
	else if (base == 0)
  8018c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018cc:	75 07                	jne    8018d5 <strtol+0xc8>
		base = 10;
  8018ce:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d9:	0f b6 00             	movzbl (%rax),%eax
  8018dc:	3c 2f                	cmp    $0x2f,%al
  8018de:	7e 1d                	jle    8018fd <strtol+0xf0>
  8018e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e4:	0f b6 00             	movzbl (%rax),%eax
  8018e7:	3c 39                	cmp    $0x39,%al
  8018e9:	7f 12                	jg     8018fd <strtol+0xf0>
			dig = *s - '0';
  8018eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ef:	0f b6 00             	movzbl (%rax),%eax
  8018f2:	0f be c0             	movsbl %al,%eax
  8018f5:	83 e8 30             	sub    $0x30,%eax
  8018f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018fb:	eb 4e                	jmp    80194b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801901:	0f b6 00             	movzbl (%rax),%eax
  801904:	3c 60                	cmp    $0x60,%al
  801906:	7e 1d                	jle    801925 <strtol+0x118>
  801908:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190c:	0f b6 00             	movzbl (%rax),%eax
  80190f:	3c 7a                	cmp    $0x7a,%al
  801911:	7f 12                	jg     801925 <strtol+0x118>
			dig = *s - 'a' + 10;
  801913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801917:	0f b6 00             	movzbl (%rax),%eax
  80191a:	0f be c0             	movsbl %al,%eax
  80191d:	83 e8 57             	sub    $0x57,%eax
  801920:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801923:	eb 26                	jmp    80194b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801929:	0f b6 00             	movzbl (%rax),%eax
  80192c:	3c 40                	cmp    $0x40,%al
  80192e:	7e 47                	jle    801977 <strtol+0x16a>
  801930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801934:	0f b6 00             	movzbl (%rax),%eax
  801937:	3c 5a                	cmp    $0x5a,%al
  801939:	7f 3c                	jg     801977 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80193b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193f:	0f b6 00             	movzbl (%rax),%eax
  801942:	0f be c0             	movsbl %al,%eax
  801945:	83 e8 37             	sub    $0x37,%eax
  801948:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80194b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80194e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801951:	7d 23                	jge    801976 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801953:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801958:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80195b:	48 98                	cltq   
  80195d:	48 89 c2             	mov    %rax,%rdx
  801960:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801965:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801968:	48 98                	cltq   
  80196a:	48 01 d0             	add    %rdx,%rax
  80196d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801971:	e9 5f ff ff ff       	jmpq   8018d5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801976:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801977:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80197c:	74 0b                	je     801989 <strtol+0x17c>
		*endptr = (char *) s;
  80197e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801982:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801986:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801989:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80198d:	74 09                	je     801998 <strtol+0x18b>
  80198f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801993:	48 f7 d8             	neg    %rax
  801996:	eb 04                	jmp    80199c <strtol+0x18f>
  801998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80199c:	c9                   	leaveq 
  80199d:	c3                   	retq   

000000000080199e <strstr>:

char * strstr(const char *in, const char *str)
{
  80199e:	55                   	push   %rbp
  80199f:	48 89 e5             	mov    %rsp,%rbp
  8019a2:	48 83 ec 30          	sub    $0x30,%rsp
  8019a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	88 45 ff             	mov    %al,-0x1(%rbp)
  8019b8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8019bd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019c1:	75 06                	jne    8019c9 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8019c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c7:	eb 68                	jmp    801a31 <strstr+0x93>

    len = strlen(str);
  8019c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019cd:	48 89 c7             	mov    %rax,%rdi
  8019d0:	48 b8 74 12 80 00 00 	movabs $0x801274,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	callq  *%rax
  8019dc:	48 98                	cltq   
  8019de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8019e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e6:	0f b6 00             	movzbl (%rax),%eax
  8019e9:	88 45 ef             	mov    %al,-0x11(%rbp)
  8019ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8019f1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019f5:	75 07                	jne    8019fe <strstr+0x60>
                return (char *) 0;
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fc:	eb 33                	jmp    801a31 <strstr+0x93>
        } while (sc != c);
  8019fe:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a02:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a05:	75 db                	jne    8019e2 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801a07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a13:	48 89 ce             	mov    %rcx,%rsi
  801a16:	48 89 c7             	mov    %rax,%rdi
  801a19:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
  801a25:	85 c0                	test   %eax,%eax
  801a27:	75 b9                	jne    8019e2 <strstr+0x44>

    return (char *) (in - 1);
  801a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2d:	48 83 e8 01          	sub    $0x1,%rax
}
  801a31:	c9                   	leaveq 
  801a32:	c3                   	retq   
	...

0000000000801a34 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a34:	55                   	push   %rbp
  801a35:	48 89 e5             	mov    %rsp,%rbp
  801a38:	53                   	push   %rbx
  801a39:	48 83 ec 58          	sub    $0x58,%rsp
  801a3d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a40:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a43:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a47:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a4b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a4f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a53:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a56:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801a59:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a5d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a61:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a65:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a69:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a6d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801a70:	4c 89 c3             	mov    %r8,%rbx
  801a73:	cd 30                	int    $0x30
  801a75:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801a79:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801a7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a81:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a85:	74 3e                	je     801ac5 <syscall+0x91>
  801a87:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a8c:	7e 37                	jle    801ac5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a92:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a95:	49 89 d0             	mov    %rdx,%r8
  801a98:	89 c1                	mov    %eax,%ecx
  801a9a:	48 ba 40 4d 80 00 00 	movabs $0x804d40,%rdx
  801aa1:	00 00 00 
  801aa4:	be 23 00 00 00       	mov    $0x23,%esi
  801aa9:	48 bf 5d 4d 80 00 00 	movabs $0x804d5d,%rdi
  801ab0:	00 00 00 
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab8:	49 b9 e8 04 80 00 00 	movabs $0x8004e8,%r9
  801abf:	00 00 00 
  801ac2:	41 ff d1             	callq  *%r9

	return ret;
  801ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ac9:	48 83 c4 58          	add    $0x58,%rsp
  801acd:	5b                   	pop    %rbx
  801ace:	5d                   	pop    %rbp
  801acf:	c3                   	retq   

0000000000801ad0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 20          	sub    $0x20,%rsp
  801ad8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801adc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aef:	00 
  801af0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afc:	48 89 d1             	mov    %rdx,%rcx
  801aff:	48 89 c2             	mov    %rax,%rdx
  801b02:	be 00 00 00 00       	mov    $0x0,%esi
  801b07:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0c:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
}
  801b18:	c9                   	leaveq 
  801b19:	c3                   	retq   

0000000000801b1a <sys_cgetc>:

int
sys_cgetc(void)
{
  801b1a:	55                   	push   %rbp
  801b1b:	48 89 e5             	mov    %rsp,%rbp
  801b1e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b40:	be 00 00 00 00       	mov    $0x0,%esi
  801b45:	bf 01 00 00 00       	mov    $0x1,%edi
  801b4a:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801b51:	00 00 00 
  801b54:	ff d0                	callq  *%rax
}
  801b56:	c9                   	leaveq 
  801b57:	c3                   	retq   

0000000000801b58 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b58:	55                   	push   %rbp
  801b59:	48 89 e5             	mov    %rsp,%rbp
  801b5c:	48 83 ec 20          	sub    $0x20,%rsp
  801b60:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b66:	48 98                	cltq   
  801b68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6f:	00 
  801b70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b81:	48 89 c2             	mov    %rax,%rdx
  801b84:	be 01 00 00 00       	mov    $0x1,%esi
  801b89:	bf 03 00 00 00       	mov    $0x3,%edi
  801b8e:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
}
  801b9a:	c9                   	leaveq 
  801b9b:	c3                   	retq   

0000000000801b9c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b9c:	55                   	push   %rbp
  801b9d:	48 89 e5             	mov    %rsp,%rbp
  801ba0:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ba4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bab:	00 
  801bac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc2:	be 00 00 00 00       	mov    $0x0,%esi
  801bc7:	bf 02 00 00 00       	mov    $0x2,%edi
  801bcc:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801bd3:	00 00 00 
  801bd6:	ff d0                	callq  *%rax
}
  801bd8:	c9                   	leaveq 
  801bd9:	c3                   	retq   

0000000000801bda <sys_yield>:

void
sys_yield(void)
{
  801bda:	55                   	push   %rbp
  801bdb:	48 89 e5             	mov    %rsp,%rbp
  801bde:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801be2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be9:	00 
  801bea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801c00:	be 00 00 00 00       	mov    $0x0,%esi
  801c05:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c0a:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801c11:	00 00 00 
  801c14:	ff d0                	callq  *%rax
}
  801c16:	c9                   	leaveq 
  801c17:	c3                   	retq   

0000000000801c18 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c18:	55                   	push   %rbp
  801c19:	48 89 e5             	mov    %rsp,%rbp
  801c1c:	48 83 ec 20          	sub    $0x20,%rsp
  801c20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c27:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c2d:	48 63 c8             	movslq %eax,%rcx
  801c30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c37:	48 98                	cltq   
  801c39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c40:	00 
  801c41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c47:	49 89 c8             	mov    %rcx,%r8
  801c4a:	48 89 d1             	mov    %rdx,%rcx
  801c4d:	48 89 c2             	mov    %rax,%rdx
  801c50:	be 01 00 00 00       	mov    $0x1,%esi
  801c55:	bf 04 00 00 00       	mov    $0x4,%edi
  801c5a:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801c61:	00 00 00 
  801c64:	ff d0                	callq  *%rax
}
  801c66:	c9                   	leaveq 
  801c67:	c3                   	retq   

0000000000801c68 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c68:	55                   	push   %rbp
  801c69:	48 89 e5             	mov    %rsp,%rbp
  801c6c:	48 83 ec 30          	sub    $0x30,%rsp
  801c70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c77:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c7a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c7e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c82:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c85:	48 63 c8             	movslq %eax,%rcx
  801c88:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c8f:	48 63 f0             	movslq %eax,%rsi
  801c92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c99:	48 98                	cltq   
  801c9b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c9f:	49 89 f9             	mov    %rdi,%r9
  801ca2:	49 89 f0             	mov    %rsi,%r8
  801ca5:	48 89 d1             	mov    %rdx,%rcx
  801ca8:	48 89 c2             	mov    %rax,%rdx
  801cab:	be 01 00 00 00       	mov    $0x1,%esi
  801cb0:	bf 05 00 00 00       	mov    $0x5,%edi
  801cb5:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	callq  *%rax
}
  801cc1:	c9                   	leaveq 
  801cc2:	c3                   	retq   

0000000000801cc3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801cc3:	55                   	push   %rbp
  801cc4:	48 89 e5             	mov    %rsp,%rbp
  801cc7:	48 83 ec 20          	sub    $0x20,%rsp
  801ccb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801cd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd9:	48 98                	cltq   
  801cdb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce2:	00 
  801ce3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cef:	48 89 d1             	mov    %rdx,%rcx
  801cf2:	48 89 c2             	mov    %rax,%rdx
  801cf5:	be 01 00 00 00       	mov    $0x1,%esi
  801cfa:	bf 06 00 00 00       	mov    $0x6,%edi
  801cff:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801d06:	00 00 00 
  801d09:	ff d0                	callq  *%rax
}
  801d0b:	c9                   	leaveq 
  801d0c:	c3                   	retq   

0000000000801d0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d0d:	55                   	push   %rbp
  801d0e:	48 89 e5             	mov    %rsp,%rbp
  801d11:	48 83 ec 20          	sub    $0x20,%rsp
  801d15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d18:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d1e:	48 63 d0             	movslq %eax,%rdx
  801d21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d24:	48 98                	cltq   
  801d26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2d:	00 
  801d2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3a:	48 89 d1             	mov    %rdx,%rcx
  801d3d:	48 89 c2             	mov    %rax,%rdx
  801d40:	be 01 00 00 00       	mov    $0x1,%esi
  801d45:	bf 08 00 00 00       	mov    $0x8,%edi
  801d4a:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801d51:	00 00 00 
  801d54:	ff d0                	callq  *%rax
}
  801d56:	c9                   	leaveq 
  801d57:	c3                   	retq   

0000000000801d58 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d58:	55                   	push   %rbp
  801d59:	48 89 e5             	mov    %rsp,%rbp
  801d5c:	48 83 ec 20          	sub    $0x20,%rsp
  801d60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6e:	48 98                	cltq   
  801d70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d77:	00 
  801d78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d84:	48 89 d1             	mov    %rdx,%rcx
  801d87:	48 89 c2             	mov    %rax,%rdx
  801d8a:	be 01 00 00 00       	mov    $0x1,%esi
  801d8f:	bf 09 00 00 00       	mov    $0x9,%edi
  801d94:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	callq  *%rax
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 20          	sub    $0x20,%rsp
  801daa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801db1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db8:	48 98                	cltq   
  801dba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc1:	00 
  801dc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dce:	48 89 d1             	mov    %rdx,%rcx
  801dd1:	48 89 c2             	mov    %rax,%rdx
  801dd4:	be 01 00 00 00       	mov    $0x1,%esi
  801dd9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801dde:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
}
  801dea:	c9                   	leaveq 
  801deb:	c3                   	retq   

0000000000801dec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
  801df0:	48 83 ec 30          	sub    $0x30,%rsp
  801df4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801df7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dfb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dff:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e05:	48 63 f0             	movslq %eax,%rsi
  801e08:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0f:	48 98                	cltq   
  801e11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e1c:	00 
  801e1d:	49 89 f1             	mov    %rsi,%r9
  801e20:	49 89 c8             	mov    %rcx,%r8
  801e23:	48 89 d1             	mov    %rdx,%rcx
  801e26:	48 89 c2             	mov    %rax,%rdx
  801e29:	be 00 00 00 00       	mov    $0x0,%esi
  801e2e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e33:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801e3a:	00 00 00 
  801e3d:	ff d0                	callq  *%rax
}
  801e3f:	c9                   	leaveq 
  801e40:	c3                   	retq   

0000000000801e41 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e41:	55                   	push   %rbp
  801e42:	48 89 e5             	mov    %rsp,%rbp
  801e45:	48 83 ec 20          	sub    $0x20,%rsp
  801e49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e58:	00 
  801e59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e6a:	48 89 c2             	mov    %rax,%rdx
  801e6d:	be 01 00 00 00       	mov    $0x1,%esi
  801e72:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e77:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801e7e:	00 00 00 
  801e81:	ff d0                	callq  *%rax
}
  801e83:	c9                   	leaveq 
  801e84:	c3                   	retq   

0000000000801e85 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801e85:	55                   	push   %rbp
  801e86:	48 89 e5             	mov    %rsp,%rbp
  801e89:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e94:	00 
  801e95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eab:	be 00 00 00 00       	mov    $0x0,%esi
  801eb0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801eb5:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	callq  *%rax
}
  801ec1:	c9                   	leaveq 
  801ec2:	c3                   	retq   

0000000000801ec3 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801ec3:	55                   	push   %rbp
  801ec4:	48 89 e5             	mov    %rsp,%rbp
  801ec7:	48 83 ec 20          	sub    $0x20,%rsp
  801ecb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ecf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801ed3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801edb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ee2:	00 
  801ee3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eef:	48 89 d1             	mov    %rdx,%rcx
  801ef2:	48 89 c2             	mov    %rax,%rdx
  801ef5:	be 00 00 00 00       	mov    $0x0,%esi
  801efa:	bf 0f 00 00 00       	mov    $0xf,%edi
  801eff:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
}
  801f0b:	c9                   	leaveq 
  801f0c:	c3                   	retq   

0000000000801f0d <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801f0d:	55                   	push   %rbp
  801f0e:	48 89 e5             	mov    %rsp,%rbp
  801f11:	48 83 ec 20          	sub    $0x20,%rsp
  801f15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801f1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f2c:	00 
  801f2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f39:	48 89 d1             	mov    %rdx,%rcx
  801f3c:	48 89 c2             	mov    %rax,%rdx
  801f3f:	be 00 00 00 00       	mov    $0x0,%esi
  801f44:	bf 10 00 00 00       	mov    $0x10,%edi
  801f49:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801f50:	00 00 00 
  801f53:	ff d0                	callq  *%rax
}
  801f55:	c9                   	leaveq 
  801f56:	c3                   	retq   
	...

0000000000801f58 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f58:	55                   	push   %rbp
  801f59:	48 89 e5             	mov    %rsp,%rbp
  801f5c:	48 83 ec 30          	sub    $0x30,%rsp
  801f60:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f68:	48 8b 00             	mov    (%rax),%rax
  801f6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f73:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f77:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801f7a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f7d:	83 e0 02             	and    $0x2,%eax
  801f80:	85 c0                	test   %eax,%eax
  801f82:	74 23                	je     801fa7 <pgfault+0x4f>
  801f84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f88:	48 89 c2             	mov    %rax,%rdx
  801f8b:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f8f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f96:	01 00 00 
  801f99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9d:	25 00 08 00 00       	and    $0x800,%eax
  801fa2:	48 85 c0             	test   %rax,%rax
  801fa5:	75 2a                	jne    801fd1 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801fa7:	48 ba 70 4d 80 00 00 	movabs $0x804d70,%rdx
  801fae:	00 00 00 
  801fb1:	be 1c 00 00 00       	mov    $0x1c,%esi
  801fb6:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  801fbd:	00 00 00 
  801fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc5:	48 b9 e8 04 80 00 00 	movabs $0x8004e8,%rcx
  801fcc:	00 00 00 
  801fcf:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801fd1:	ba 07 00 00 00       	mov    $0x7,%edx
  801fd6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fdb:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe0:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  801fe7:	00 00 00 
  801fea:	ff d0                	callq  *%rax
  801fec:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801fef:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ff3:	79 30                	jns    802025 <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801ff5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801ff8:	89 c1                	mov    %eax,%ecx
  801ffa:	48 ba b0 4d 80 00 00 	movabs $0x804db0,%rdx
  802001:	00 00 00 
  802004:	be 26 00 00 00       	mov    $0x26,%esi
  802009:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  802010:	00 00 00 
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
  802018:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  80201f:	00 00 00 
  802022:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  802025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802029:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80202d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802031:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802037:	ba 00 10 00 00       	mov    $0x1000,%edx
  80203c:	48 89 c6             	mov    %rax,%rsi
  80203f:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802044:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  802050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802054:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  802058:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80205c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802062:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802068:	48 89 c1             	mov    %rax,%rcx
  80206b:	ba 00 00 00 00       	mov    $0x0,%edx
  802070:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802075:	bf 00 00 00 00       	mov    $0x0,%edi
  80207a:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802081:	00 00 00 
  802084:	ff d0                	callq  *%rax
  802086:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802089:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80208d:	79 30                	jns    8020bf <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  80208f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802092:	89 c1                	mov    %eax,%ecx
  802094:	48 ba d8 4d 80 00 00 	movabs $0x804dd8,%rdx
  80209b:	00 00 00 
  80209e:	be 2b 00 00 00       	mov    $0x2b,%esi
  8020a3:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  8020aa:	00 00 00 
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b2:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  8020b9:	00 00 00 
  8020bc:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  8020bf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c9:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	callq  *%rax
  8020d5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8020d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8020dc:	79 30                	jns    80210e <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  8020de:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8020e1:	89 c1                	mov    %eax,%ecx
  8020e3:	48 ba 00 4e 80 00 00 	movabs $0x804e00,%rdx
  8020ea:	00 00 00 
  8020ed:	be 2e 00 00 00       	mov    $0x2e,%esi
  8020f2:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  8020f9:	00 00 00 
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  802108:	00 00 00 
  80210b:	41 ff d0             	callq  *%r8
	
}
  80210e:	c9                   	leaveq 
  80210f:	c3                   	retq   

0000000000802110 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802110:	55                   	push   %rbp
  802111:	48 89 e5             	mov    %rsp,%rbp
  802114:	48 83 ec 30          	sub    $0x30,%rsp
  802118:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80211b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  80211e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802125:	01 00 00 
  802128:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80212b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  802133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802137:	25 07 0e 00 00       	and    $0xe07,%eax
  80213c:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  80213f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802142:	48 c1 e0 0c          	shl    $0xc,%rax
  802146:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  80214a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80214d:	25 00 04 00 00       	and    $0x400,%eax
  802152:	85 c0                	test   %eax,%eax
  802154:	74 5c                	je     8021b2 <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  802156:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802159:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80215d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802164:	41 89 f0             	mov    %esi,%r8d
  802167:	48 89 c6             	mov    %rax,%rsi
  80216a:	bf 00 00 00 00       	mov    $0x0,%edi
  80216f:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802176:	00 00 00 
  802179:	ff d0                	callq  *%rax
  80217b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  80217e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802182:	0f 89 60 01 00 00    	jns    8022e8 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  802188:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  80218f:	00 00 00 
  802192:	be 4d 00 00 00       	mov    $0x4d,%esi
  802197:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  80219e:	00 00 00 
  8021a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a6:	48 b9 e8 04 80 00 00 	movabs $0x8004e8,%rcx
  8021ad:	00 00 00 
  8021b0:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  8021b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021b5:	83 e0 02             	and    $0x2,%eax
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	75 10                	jne    8021cc <duppage+0xbc>
  8021bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021bf:	25 00 08 00 00       	and    $0x800,%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	0f 84 c4 00 00 00    	je     802290 <duppage+0x180>
	{
		perm |= PTE_COW;
  8021cc:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  8021d3:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  8021d7:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8021da:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021de:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e5:	41 89 f0             	mov    %esi,%r8d
  8021e8:	48 89 c6             	mov    %rax,%rsi
  8021eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f0:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8021f7:	00 00 00 
  8021fa:	ff d0                	callq  *%rax
  8021fc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  8021ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802203:	79 2a                	jns    80222f <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  802205:	48 ba 58 4e 80 00 00 	movabs $0x804e58,%rdx
  80220c:	00 00 00 
  80220f:	be 56 00 00 00       	mov    $0x56,%esi
  802214:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  80221b:	00 00 00 
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
  802223:	48 b9 e8 04 80 00 00 	movabs $0x8004e8,%rcx
  80222a:	00 00 00 
  80222d:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  80222f:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  802232:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223a:	41 89 c8             	mov    %ecx,%r8d
  80223d:	48 89 d1             	mov    %rdx,%rcx
  802240:	ba 00 00 00 00       	mov    $0x0,%edx
  802245:	48 89 c6             	mov    %rax,%rsi
  802248:	bf 00 00 00 00       	mov    $0x0,%edi
  80224d:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802254:	00 00 00 
  802257:	ff d0                	callq  *%rax
  802259:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  80225c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802260:	0f 89 82 00 00 00    	jns    8022e8 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  802266:	48 ba 58 4e 80 00 00 	movabs $0x804e58,%rdx
  80226d:	00 00 00 
  802270:	be 59 00 00 00       	mov    $0x59,%esi
  802275:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  80227c:	00 00 00 
  80227f:	b8 00 00 00 00       	mov    $0x0,%eax
  802284:	48 b9 e8 04 80 00 00 	movabs $0x8004e8,%rcx
  80228b:	00 00 00 
  80228e:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  802290:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802293:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802297:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80229a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229e:	41 89 f0             	mov    %esi,%r8d
  8022a1:	48 89 c6             	mov    %rax,%rsi
  8022a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a9:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8022b0:	00 00 00 
  8022b3:	ff d0                	callq  *%rax
  8022b5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8022b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022bc:	79 2a                	jns    8022e8 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  8022be:	48 ba 90 4e 80 00 00 	movabs $0x804e90,%rdx
  8022c5:	00 00 00 
  8022c8:	be 60 00 00 00       	mov    $0x60,%esi
  8022cd:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  8022d4:	00 00 00 
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dc:	48 b9 e8 04 80 00 00 	movabs $0x8004e8,%rcx
  8022e3:	00 00 00 
  8022e6:	ff d1                	callq  *%rcx
	}
	return 0;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ed:	c9                   	leaveq 
  8022ee:	c3                   	retq   

00000000008022ef <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8022ef:	55                   	push   %rbp
  8022f0:	48 89 e5             	mov    %rsp,%rbp
  8022f3:	53                   	push   %rbx
  8022f4:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8022f8:	48 bf 58 1f 80 00 00 	movabs $0x801f58,%rdi
  8022ff:	00 00 00 
  802302:	48 b8 ac 43 80 00 00 	movabs $0x8043ac,%rax
  802309:	00 00 00 
  80230c:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80230e:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  802315:	8b 45 bc             	mov    -0x44(%rbp),%eax
  802318:	cd 30                	int    $0x30
  80231a:	89 c3                	mov    %eax,%ebx
  80231c:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80231f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  802322:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  802325:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802329:	79 30                	jns    80235b <fork+0x6c>
                panic("sys_exofork: %e", envid);
  80232b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80232e:	89 c1                	mov    %eax,%ecx
  802330:	48 ba b4 4e 80 00 00 	movabs $0x804eb4,%rdx
  802337:	00 00 00 
  80233a:	be 7f 00 00 00       	mov    $0x7f,%esi
  80233f:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  802346:	00 00 00 
  802349:	b8 00 00 00 00       	mov    $0x0,%eax
  80234e:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  802355:	00 00 00 
  802358:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  80235b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80235f:	75 4c                	jne    8023ad <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  802361:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  802368:	00 00 00 
  80236b:	ff d0                	callq  *%rax
  80236d:	48 98                	cltq   
  80236f:	48 89 c2             	mov    %rax,%rdx
  802372:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802378:	48 89 d0             	mov    %rdx,%rax
  80237b:	48 c1 e0 03          	shl    $0x3,%rax
  80237f:	48 01 d0             	add    %rdx,%rax
  802382:	48 c1 e0 05          	shl    $0x5,%rax
  802386:	48 89 c2             	mov    %rax,%rdx
  802389:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802390:	00 00 00 
  802393:	48 01 c2             	add    %rax,%rdx
  802396:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80239d:	00 00 00 
  8023a0:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  8023a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a8:	e9 38 02 00 00       	jmpq   8025e5 <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  8023ad:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8023b0:	ba 07 00 00 00       	mov    $0x7,%edx
  8023b5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023ba:	89 c7                	mov    %eax,%edi
  8023bc:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  8023c3:	00 00 00 
  8023c6:	ff d0                	callq  *%rax
  8023c8:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  8023cb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8023cf:	79 30                	jns    802401 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  8023d1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8023d4:	89 c1                	mov    %eax,%ecx
  8023d6:	48 ba c8 4e 80 00 00 	movabs $0x804ec8,%rdx
  8023dd:	00 00 00 
  8023e0:	be 8b 00 00 00       	mov    $0x8b,%esi
  8023e5:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  8023ec:	00 00 00 
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f4:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  8023fb:	00 00 00 
  8023fe:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802401:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  802408:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  80240f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  802416:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  80241d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802424:	e9 0a 01 00 00       	jmpq   802533 <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  802429:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802430:	01 00 00 
  802433:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802436:	48 63 d2             	movslq %edx,%rdx
  802439:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243d:	83 e0 01             	and    $0x1,%eax
  802440:	84 c0                	test   %al,%al
  802442:	0f 84 e7 00 00 00    	je     80252f <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802448:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  80244f:	e9 cf 00 00 00       	jmpq   802523 <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  802454:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80245b:	01 00 00 
  80245e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802461:	48 63 d2             	movslq %edx,%rdx
  802464:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802468:	83 e0 01             	and    $0x1,%eax
  80246b:	84 c0                	test   %al,%al
  80246d:	0f 84 a0 00 00 00    	je     802513 <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802473:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  80247a:	e9 85 00 00 00       	jmpq   802504 <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  80247f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802486:	01 00 00 
  802489:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80248c:	48 63 d2             	movslq %edx,%rdx
  80248f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802493:	83 e0 01             	and    $0x1,%eax
  802496:	84 c0                	test   %al,%al
  802498:	74 56                	je     8024f0 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  80249a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  8024a1:	eb 42                	jmp    8024e5 <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  8024a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024aa:	01 00 00 
  8024ad:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024b0:	48 63 d2             	movslq %edx,%rdx
  8024b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b7:	83 e0 01             	and    $0x1,%eax
  8024ba:	84 c0                	test   %al,%al
  8024bc:	74 1f                	je     8024dd <fork+0x1ee>
  8024be:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  8024c5:	74 16                	je     8024dd <fork+0x1ee>
									 duppage(envid,d1);
  8024c7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024ca:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8024cd:	89 d6                	mov    %edx,%esi
  8024cf:	89 c7                	mov    %eax,%edi
  8024d1:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8024d8:	00 00 00 
  8024db:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8024dd:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  8024e1:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  8024e5:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  8024ec:	7e b5                	jle    8024a3 <fork+0x1b4>
  8024ee:	eb 0c                	jmp    8024fc <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  8024f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f3:	83 c0 01             	add    $0x1,%eax
  8024f6:	c1 e0 09             	shl    $0x9,%eax
  8024f9:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8024fc:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802500:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  802504:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  80250b:	0f 8e 6e ff ff ff    	jle    80247f <fork+0x190>
  802511:	eb 0c                	jmp    80251f <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  802513:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802516:	83 c0 01             	add    $0x1,%eax
  802519:	c1 e0 09             	shl    $0x9,%eax
  80251c:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  80251f:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  802523:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802526:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  802529:	0f 8c 25 ff ff ff    	jl     802454 <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  80252f:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802533:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802536:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802539:	0f 8c ea fe ff ff    	jl     802429 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80253f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802542:	48 be 70 44 80 00 00 	movabs $0x804470,%rsi
  802549:	00 00 00 
  80254c:	89 c7                	mov    %eax,%edi
  80254e:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  802555:	00 00 00 
  802558:	ff d0                	callq  *%rax
  80255a:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  80255d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802561:	79 30                	jns    802593 <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  802563:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802566:	89 c1                	mov    %eax,%ecx
  802568:	48 ba e8 4e 80 00 00 	movabs $0x804ee8,%rdx
  80256f:	00 00 00 
  802572:	be ad 00 00 00       	mov    $0xad,%esi
  802577:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  80257e:	00 00 00 
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  80258d:	00 00 00 
  802590:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  802593:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802596:	be 02 00 00 00       	mov    $0x2,%esi
  80259b:	89 c7                	mov    %eax,%edi
  80259d:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  8025a4:	00 00 00 
  8025a7:	ff d0                	callq  *%rax
  8025a9:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8025ac:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8025b0:	79 30                	jns    8025e2 <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  8025b2:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8025b5:	89 c1                	mov    %eax,%ecx
  8025b7:	48 ba 18 4f 80 00 00 	movabs $0x804f18,%rdx
  8025be:	00 00 00 
  8025c1:	be b0 00 00 00       	mov    $0xb0,%esi
  8025c6:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  8025cd:	00 00 00 
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  8025dc:	00 00 00 
  8025df:	41 ff d0             	callq  *%r8
	return envid;
  8025e2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  8025e5:	48 83 c4 48          	add    $0x48,%rsp
  8025e9:	5b                   	pop    %rbx
  8025ea:	5d                   	pop    %rbp
  8025eb:	c3                   	retq   

00000000008025ec <sfork>:

// Challenge!
int
sfork(void)
{
  8025ec:	55                   	push   %rbp
  8025ed:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025f0:	48 ba 3c 4f 80 00 00 	movabs $0x804f3c,%rdx
  8025f7:	00 00 00 
  8025fa:	be b8 00 00 00       	mov    $0xb8,%esi
  8025ff:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  802606:	00 00 00 
  802609:	b8 00 00 00 00       	mov    $0x0,%eax
  80260e:	48 b9 e8 04 80 00 00 	movabs $0x8004e8,%rcx
  802615:	00 00 00 
  802618:	ff d1                	callq  *%rcx
	...

000000000080261c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80261c:	55                   	push   %rbp
  80261d:	48 89 e5             	mov    %rsp,%rbp
  802620:	48 83 ec 08          	sub    $0x8,%rsp
  802624:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802628:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80262c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802633:	ff ff ff 
  802636:	48 01 d0             	add    %rdx,%rax
  802639:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80263d:	c9                   	leaveq 
  80263e:	c3                   	retq   

000000000080263f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80263f:	55                   	push   %rbp
  802640:	48 89 e5             	mov    %rsp,%rbp
  802643:	48 83 ec 08          	sub    $0x8,%rsp
  802647:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80264b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80264f:	48 89 c7             	mov    %rax,%rdi
  802652:	48 b8 1c 26 80 00 00 	movabs $0x80261c,%rax
  802659:	00 00 00 
  80265c:	ff d0                	callq  *%rax
  80265e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802664:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802668:	c9                   	leaveq 
  802669:	c3                   	retq   

000000000080266a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80266a:	55                   	push   %rbp
  80266b:	48 89 e5             	mov    %rsp,%rbp
  80266e:	48 83 ec 18          	sub    $0x18,%rsp
  802672:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802676:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80267d:	eb 6b                	jmp    8026ea <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80267f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802682:	48 98                	cltq   
  802684:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80268a:	48 c1 e0 0c          	shl    $0xc,%rax
  80268e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802696:	48 89 c2             	mov    %rax,%rdx
  802699:	48 c1 ea 15          	shr    $0x15,%rdx
  80269d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026a4:	01 00 00 
  8026a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ab:	83 e0 01             	and    $0x1,%eax
  8026ae:	48 85 c0             	test   %rax,%rax
  8026b1:	74 21                	je     8026d4 <fd_alloc+0x6a>
  8026b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b7:	48 89 c2             	mov    %rax,%rdx
  8026ba:	48 c1 ea 0c          	shr    $0xc,%rdx
  8026be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026c5:	01 00 00 
  8026c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026cc:	83 e0 01             	and    $0x1,%eax
  8026cf:	48 85 c0             	test   %rax,%rax
  8026d2:	75 12                	jne    8026e6 <fd_alloc+0x7c>
			*fd_store = fd;
  8026d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026dc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	eb 1a                	jmp    802700 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026ea:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026ee:	7e 8f                	jle    80267f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026fb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802700:	c9                   	leaveq 
  802701:	c3                   	retq   

0000000000802702 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802702:	55                   	push   %rbp
  802703:	48 89 e5             	mov    %rsp,%rbp
  802706:	48 83 ec 20          	sub    $0x20,%rsp
  80270a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80270d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802711:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802715:	78 06                	js     80271d <fd_lookup+0x1b>
  802717:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80271b:	7e 07                	jle    802724 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80271d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802722:	eb 6c                	jmp    802790 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802724:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802727:	48 98                	cltq   
  802729:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80272f:	48 c1 e0 0c          	shl    $0xc,%rax
  802733:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802737:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80273b:	48 89 c2             	mov    %rax,%rdx
  80273e:	48 c1 ea 15          	shr    $0x15,%rdx
  802742:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802749:	01 00 00 
  80274c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802750:	83 e0 01             	and    $0x1,%eax
  802753:	48 85 c0             	test   %rax,%rax
  802756:	74 21                	je     802779 <fd_lookup+0x77>
  802758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80275c:	48 89 c2             	mov    %rax,%rdx
  80275f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802763:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80276a:	01 00 00 
  80276d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802771:	83 e0 01             	and    $0x1,%eax
  802774:	48 85 c0             	test   %rax,%rax
  802777:	75 07                	jne    802780 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802779:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80277e:	eb 10                	jmp    802790 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802784:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802788:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802790:	c9                   	leaveq 
  802791:	c3                   	retq   

0000000000802792 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802792:	55                   	push   %rbp
  802793:	48 89 e5             	mov    %rsp,%rbp
  802796:	48 83 ec 30          	sub    $0x30,%rsp
  80279a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80279e:	89 f0                	mov    %esi,%eax
  8027a0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8027a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a7:	48 89 c7             	mov    %rax,%rdi
  8027aa:	48 b8 1c 26 80 00 00 	movabs $0x80261c,%rax
  8027b1:	00 00 00 
  8027b4:	ff d0                	callq  *%rax
  8027b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ba:	48 89 d6             	mov    %rdx,%rsi
  8027bd:	89 c7                	mov    %eax,%edi
  8027bf:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  8027c6:	00 00 00 
  8027c9:	ff d0                	callq  *%rax
  8027cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d2:	78 0a                	js     8027de <fd_close+0x4c>
	    || fd != fd2)
  8027d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8027dc:	74 12                	je     8027f0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8027de:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027e2:	74 05                	je     8027e9 <fd_close+0x57>
  8027e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e7:	eb 05                	jmp    8027ee <fd_close+0x5c>
  8027e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ee:	eb 69                	jmp    802859 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f4:	8b 00                	mov    (%rax),%eax
  8027f6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027fa:	48 89 d6             	mov    %rdx,%rsi
  8027fd:	89 c7                	mov    %eax,%edi
  8027ff:	48 b8 5b 28 80 00 00 	movabs $0x80285b,%rax
  802806:	00 00 00 
  802809:	ff d0                	callq  *%rax
  80280b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80280e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802812:	78 2a                	js     80283e <fd_close+0xac>
		if (dev->dev_close)
  802814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802818:	48 8b 40 20          	mov    0x20(%rax),%rax
  80281c:	48 85 c0             	test   %rax,%rax
  80281f:	74 16                	je     802837 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802825:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282d:	48 89 c7             	mov    %rax,%rdi
  802830:	ff d2                	callq  *%rdx
  802832:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802835:	eb 07                	jmp    80283e <fd_close+0xac>
		else
			r = 0;
  802837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80283e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802842:	48 89 c6             	mov    %rax,%rsi
  802845:	bf 00 00 00 00       	mov    $0x0,%edi
  80284a:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802851:	00 00 00 
  802854:	ff d0                	callq  *%rax
	return r;
  802856:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802859:	c9                   	leaveq 
  80285a:	c3                   	retq   

000000000080285b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80285b:	55                   	push   %rbp
  80285c:	48 89 e5             	mov    %rsp,%rbp
  80285f:	48 83 ec 20          	sub    $0x20,%rsp
  802863:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802866:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80286a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802871:	eb 41                	jmp    8028b4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802873:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80287a:	00 00 00 
  80287d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802880:	48 63 d2             	movslq %edx,%rdx
  802883:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802887:	8b 00                	mov    (%rax),%eax
  802889:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80288c:	75 22                	jne    8028b0 <dev_lookup+0x55>
			*dev = devtab[i];
  80288e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802895:	00 00 00 
  802898:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80289b:	48 63 d2             	movslq %edx,%rdx
  80289e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8028a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028a6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ae:	eb 60                	jmp    802910 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8028b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028b4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028bb:	00 00 00 
  8028be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028c1:	48 63 d2             	movslq %edx,%rdx
  8028c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028c8:	48 85 c0             	test   %rax,%rax
  8028cb:	75 a6                	jne    802873 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8028cd:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8028d4:	00 00 00 
  8028d7:	48 8b 00             	mov    (%rax),%rax
  8028da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028e3:	89 c6                	mov    %eax,%esi
  8028e5:	48 bf 58 4f 80 00 00 	movabs $0x804f58,%rdi
  8028ec:	00 00 00 
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	48 b9 23 07 80 00 00 	movabs $0x800723,%rcx
  8028fb:	00 00 00 
  8028fe:	ff d1                	callq  *%rcx
	*dev = 0;
  802900:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802904:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80290b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802910:	c9                   	leaveq 
  802911:	c3                   	retq   

0000000000802912 <close>:

int
close(int fdnum)
{
  802912:	55                   	push   %rbp
  802913:	48 89 e5             	mov    %rsp,%rbp
  802916:	48 83 ec 20          	sub    $0x20,%rsp
  80291a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80291d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802921:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802924:	48 89 d6             	mov    %rdx,%rsi
  802927:	89 c7                	mov    %eax,%edi
  802929:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  802930:	00 00 00 
  802933:	ff d0                	callq  *%rax
  802935:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802938:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293c:	79 05                	jns    802943 <close+0x31>
		return r;
  80293e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802941:	eb 18                	jmp    80295b <close+0x49>
	else
		return fd_close(fd, 1);
  802943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802947:	be 01 00 00 00       	mov    $0x1,%esi
  80294c:	48 89 c7             	mov    %rax,%rdi
  80294f:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  802956:	00 00 00 
  802959:	ff d0                	callq  *%rax
}
  80295b:	c9                   	leaveq 
  80295c:	c3                   	retq   

000000000080295d <close_all>:

void
close_all(void)
{
  80295d:	55                   	push   %rbp
  80295e:	48 89 e5             	mov    %rsp,%rbp
  802961:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802965:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80296c:	eb 15                	jmp    802983 <close_all+0x26>
		close(i);
  80296e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802971:	89 c7                	mov    %eax,%edi
  802973:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  80297a:	00 00 00 
  80297d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80297f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802983:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802987:	7e e5                	jle    80296e <close_all+0x11>
		close(i);
}
  802989:	c9                   	leaveq 
  80298a:	c3                   	retq   

000000000080298b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80298b:	55                   	push   %rbp
  80298c:	48 89 e5             	mov    %rsp,%rbp
  80298f:	48 83 ec 40          	sub    $0x40,%rsp
  802993:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802996:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802999:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80299d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029a0:	48 89 d6             	mov    %rdx,%rsi
  8029a3:	89 c7                	mov    %eax,%edi
  8029a5:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  8029ac:	00 00 00 
  8029af:	ff d0                	callq  *%rax
  8029b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b8:	79 08                	jns    8029c2 <dup+0x37>
		return r;
  8029ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029bd:	e9 70 01 00 00       	jmpq   802b32 <dup+0x1a7>
	close(newfdnum);
  8029c2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029c5:	89 c7                	mov    %eax,%edi
  8029c7:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  8029ce:	00 00 00 
  8029d1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8029d3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029d6:	48 98                	cltq   
  8029d8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029de:	48 c1 e0 0c          	shl    $0xc,%rax
  8029e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ea:	48 89 c7             	mov    %rax,%rdi
  8029ed:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  8029f4:	00 00 00 
  8029f7:	ff d0                	callq  *%rax
  8029f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a01:	48 89 c7             	mov    %rax,%rdi
  802a04:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  802a0b:	00 00 00 
  802a0e:	ff d0                	callq  *%rax
  802a10:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a18:	48 89 c2             	mov    %rax,%rdx
  802a1b:	48 c1 ea 15          	shr    $0x15,%rdx
  802a1f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a26:	01 00 00 
  802a29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a2d:	83 e0 01             	and    $0x1,%eax
  802a30:	84 c0                	test   %al,%al
  802a32:	74 71                	je     802aa5 <dup+0x11a>
  802a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a38:	48 89 c2             	mov    %rax,%rdx
  802a3b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a46:	01 00 00 
  802a49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a4d:	83 e0 01             	and    $0x1,%eax
  802a50:	84 c0                	test   %al,%al
  802a52:	74 51                	je     802aa5 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a58:	48 89 c2             	mov    %rax,%rdx
  802a5b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a5f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a66:	01 00 00 
  802a69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a6d:	89 c1                	mov    %eax,%ecx
  802a6f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a75:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7d:	41 89 c8             	mov    %ecx,%r8d
  802a80:	48 89 d1             	mov    %rdx,%rcx
  802a83:	ba 00 00 00 00       	mov    $0x0,%edx
  802a88:	48 89 c6             	mov    %rax,%rsi
  802a8b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a90:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802a97:	00 00 00 
  802a9a:	ff d0                	callq  *%rax
  802a9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa3:	78 56                	js     802afb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa9:	48 89 c2             	mov    %rax,%rdx
  802aac:	48 c1 ea 0c          	shr    $0xc,%rdx
  802ab0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ab7:	01 00 00 
  802aba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802abe:	89 c1                	mov    %eax,%ecx
  802ac0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ace:	41 89 c8             	mov    %ecx,%r8d
  802ad1:	48 89 d1             	mov    %rdx,%rcx
  802ad4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad9:	48 89 c6             	mov    %rax,%rsi
  802adc:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae1:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802ae8:	00 00 00 
  802aeb:	ff d0                	callq  *%rax
  802aed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af4:	78 08                	js     802afe <dup+0x173>
		goto err;

	return newfdnum;
  802af6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802af9:	eb 37                	jmp    802b32 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802afb:	90                   	nop
  802afc:	eb 01                	jmp    802aff <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802afe:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802aff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b03:	48 89 c6             	mov    %rax,%rsi
  802b06:	bf 00 00 00 00       	mov    $0x0,%edi
  802b0b:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b1b:	48 89 c6             	mov    %rax,%rsi
  802b1e:	bf 00 00 00 00       	mov    $0x0,%edi
  802b23:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802b2a:	00 00 00 
  802b2d:	ff d0                	callq  *%rax
	return r;
  802b2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b32:	c9                   	leaveq 
  802b33:	c3                   	retq   

0000000000802b34 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b34:	55                   	push   %rbp
  802b35:	48 89 e5             	mov    %rsp,%rbp
  802b38:	48 83 ec 40          	sub    $0x40,%rsp
  802b3c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b3f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b43:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b47:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b4e:	48 89 d6             	mov    %rdx,%rsi
  802b51:	89 c7                	mov    %eax,%edi
  802b53:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  802b5a:	00 00 00 
  802b5d:	ff d0                	callq  *%rax
  802b5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b66:	78 24                	js     802b8c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6c:	8b 00                	mov    (%rax),%eax
  802b6e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b72:	48 89 d6             	mov    %rdx,%rsi
  802b75:	89 c7                	mov    %eax,%edi
  802b77:	48 b8 5b 28 80 00 00 	movabs $0x80285b,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax
  802b83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8a:	79 05                	jns    802b91 <read+0x5d>
		return r;
  802b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8f:	eb 7a                	jmp    802c0b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b95:	8b 40 08             	mov    0x8(%rax),%eax
  802b98:	83 e0 03             	and    $0x3,%eax
  802b9b:	83 f8 01             	cmp    $0x1,%eax
  802b9e:	75 3a                	jne    802bda <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802ba0:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802ba7:	00 00 00 
  802baa:	48 8b 00             	mov    (%rax),%rax
  802bad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bb3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bb6:	89 c6                	mov    %eax,%esi
  802bb8:	48 bf 77 4f 80 00 00 	movabs $0x804f77,%rdi
  802bbf:	00 00 00 
  802bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc7:	48 b9 23 07 80 00 00 	movabs $0x800723,%rcx
  802bce:	00 00 00 
  802bd1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bd8:	eb 31                	jmp    802c0b <read+0xd7>
	}
	if (!dev->dev_read)
  802bda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bde:	48 8b 40 10          	mov    0x10(%rax),%rax
  802be2:	48 85 c0             	test   %rax,%rax
  802be5:	75 07                	jne    802bee <read+0xba>
		return -E_NOT_SUPP;
  802be7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bec:	eb 1d                	jmp    802c0b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802bee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802bf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bfe:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c02:	48 89 ce             	mov    %rcx,%rsi
  802c05:	48 89 c7             	mov    %rax,%rdi
  802c08:	41 ff d0             	callq  *%r8
}
  802c0b:	c9                   	leaveq 
  802c0c:	c3                   	retq   

0000000000802c0d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c0d:	55                   	push   %rbp
  802c0e:	48 89 e5             	mov    %rsp,%rbp
  802c11:	48 83 ec 30          	sub    $0x30,%rsp
  802c15:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c27:	eb 46                	jmp    802c6f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2c:	48 98                	cltq   
  802c2e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c32:	48 29 c2             	sub    %rax,%rdx
  802c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c38:	48 98                	cltq   
  802c3a:	48 89 c1             	mov    %rax,%rcx
  802c3d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802c41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c44:	48 89 ce             	mov    %rcx,%rsi
  802c47:	89 c7                	mov    %eax,%edi
  802c49:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  802c50:	00 00 00 
  802c53:	ff d0                	callq  *%rax
  802c55:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c58:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c5c:	79 05                	jns    802c63 <readn+0x56>
			return m;
  802c5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c61:	eb 1d                	jmp    802c80 <readn+0x73>
		if (m == 0)
  802c63:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c67:	74 13                	je     802c7c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c6c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c72:	48 98                	cltq   
  802c74:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c78:	72 af                	jb     802c29 <readn+0x1c>
  802c7a:	eb 01                	jmp    802c7d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802c7c:	90                   	nop
	}
	return tot;
  802c7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c80:	c9                   	leaveq 
  802c81:	c3                   	retq   

0000000000802c82 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c82:	55                   	push   %rbp
  802c83:	48 89 e5             	mov    %rsp,%rbp
  802c86:	48 83 ec 40          	sub    $0x40,%rsp
  802c8a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c91:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c95:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c99:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c9c:	48 89 d6             	mov    %rdx,%rsi
  802c9f:	89 c7                	mov    %eax,%edi
  802ca1:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  802ca8:	00 00 00 
  802cab:	ff d0                	callq  *%rax
  802cad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb4:	78 24                	js     802cda <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cba:	8b 00                	mov    (%rax),%eax
  802cbc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cc0:	48 89 d6             	mov    %rdx,%rsi
  802cc3:	89 c7                	mov    %eax,%edi
  802cc5:	48 b8 5b 28 80 00 00 	movabs $0x80285b,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	callq  *%rax
  802cd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd8:	79 05                	jns    802cdf <write+0x5d>
		return r;
  802cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdd:	eb 79                	jmp    802d58 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce3:	8b 40 08             	mov    0x8(%rax),%eax
  802ce6:	83 e0 03             	and    $0x3,%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	75 3a                	jne    802d27 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ced:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802cf4:	00 00 00 
  802cf7:	48 8b 00             	mov    (%rax),%rax
  802cfa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d00:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d03:	89 c6                	mov    %eax,%esi
  802d05:	48 bf 93 4f 80 00 00 	movabs $0x804f93,%rdi
  802d0c:	00 00 00 
  802d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d14:	48 b9 23 07 80 00 00 	movabs $0x800723,%rcx
  802d1b:	00 00 00 
  802d1e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d25:	eb 31                	jmp    802d58 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d2f:	48 85 c0             	test   %rax,%rax
  802d32:	75 07                	jne    802d3b <write+0xb9>
		return -E_NOT_SUPP;
  802d34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d39:	eb 1d                	jmp    802d58 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802d43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d4b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d4f:	48 89 ce             	mov    %rcx,%rsi
  802d52:	48 89 c7             	mov    %rax,%rdi
  802d55:	41 ff d0             	callq  *%r8
}
  802d58:	c9                   	leaveq 
  802d59:	c3                   	retq   

0000000000802d5a <seek>:

int
seek(int fdnum, off_t offset)
{
  802d5a:	55                   	push   %rbp
  802d5b:	48 89 e5             	mov    %rsp,%rbp
  802d5e:	48 83 ec 18          	sub    $0x18,%rsp
  802d62:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d65:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d68:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d6f:	48 89 d6             	mov    %rdx,%rsi
  802d72:	89 c7                	mov    %eax,%edi
  802d74:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  802d7b:	00 00 00 
  802d7e:	ff d0                	callq  *%rax
  802d80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d87:	79 05                	jns    802d8e <seek+0x34>
		return r;
  802d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8c:	eb 0f                	jmp    802d9d <seek+0x43>
	fd->fd_offset = offset;
  802d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d92:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d95:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9d:	c9                   	leaveq 
  802d9e:	c3                   	retq   

0000000000802d9f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d9f:	55                   	push   %rbp
  802da0:	48 89 e5             	mov    %rsp,%rbp
  802da3:	48 83 ec 30          	sub    $0x30,%rsp
  802da7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802daa:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802db1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802db4:	48 89 d6             	mov    %rdx,%rsi
  802db7:	89 c7                	mov    %eax,%edi
  802db9:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  802dc0:	00 00 00 
  802dc3:	ff d0                	callq  *%rax
  802dc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcc:	78 24                	js     802df2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd2:	8b 00                	mov    (%rax),%eax
  802dd4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dd8:	48 89 d6             	mov    %rdx,%rsi
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 5b 28 80 00 00 	movabs $0x80285b,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
  802de9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df0:	79 05                	jns    802df7 <ftruncate+0x58>
		return r;
  802df2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df5:	eb 72                	jmp    802e69 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802df7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfb:	8b 40 08             	mov    0x8(%rax),%eax
  802dfe:	83 e0 03             	and    $0x3,%eax
  802e01:	85 c0                	test   %eax,%eax
  802e03:	75 3a                	jne    802e3f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e05:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802e0c:	00 00 00 
  802e0f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e12:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e18:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e1b:	89 c6                	mov    %eax,%esi
  802e1d:	48 bf b0 4f 80 00 00 	movabs $0x804fb0,%rdi
  802e24:	00 00 00 
  802e27:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2c:	48 b9 23 07 80 00 00 	movabs $0x800723,%rcx
  802e33:	00 00 00 
  802e36:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e3d:	eb 2a                	jmp    802e69 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e43:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e47:	48 85 c0             	test   %rax,%rax
  802e4a:	75 07                	jne    802e53 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e4c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e51:	eb 16                	jmp    802e69 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e57:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802e62:	89 d6                	mov    %edx,%esi
  802e64:	48 89 c7             	mov    %rax,%rdi
  802e67:	ff d1                	callq  *%rcx
}
  802e69:	c9                   	leaveq 
  802e6a:	c3                   	retq   

0000000000802e6b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e6b:	55                   	push   %rbp
  802e6c:	48 89 e5             	mov    %rsp,%rbp
  802e6f:	48 83 ec 30          	sub    $0x30,%rsp
  802e73:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e7a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e7e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e81:	48 89 d6             	mov    %rdx,%rsi
  802e84:	89 c7                	mov    %eax,%edi
  802e86:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  802e8d:	00 00 00 
  802e90:	ff d0                	callq  *%rax
  802e92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e99:	78 24                	js     802ebf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9f:	8b 00                	mov    (%rax),%eax
  802ea1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ea5:	48 89 d6             	mov    %rdx,%rsi
  802ea8:	89 c7                	mov    %eax,%edi
  802eaa:	48 b8 5b 28 80 00 00 	movabs $0x80285b,%rax
  802eb1:	00 00 00 
  802eb4:	ff d0                	callq  *%rax
  802eb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebd:	79 05                	jns    802ec4 <fstat+0x59>
		return r;
  802ebf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec2:	eb 5e                	jmp    802f22 <fstat+0xb7>
	if (!dev->dev_stat)
  802ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec8:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ecc:	48 85 c0             	test   %rax,%rax
  802ecf:	75 07                	jne    802ed8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802ed1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ed6:	eb 4a                	jmp    802f22 <fstat+0xb7>
	stat->st_name[0] = 0;
  802ed8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802edc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802edf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ee3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802eea:	00 00 00 
	stat->st_isdir = 0;
  802eed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ef1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ef8:	00 00 00 
	stat->st_dev = dev;
  802efb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f03:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f16:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802f1a:	48 89 d6             	mov    %rdx,%rsi
  802f1d:	48 89 c7             	mov    %rax,%rdi
  802f20:	ff d1                	callq  *%rcx
}
  802f22:	c9                   	leaveq 
  802f23:	c3                   	retq   

0000000000802f24 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f24:	55                   	push   %rbp
  802f25:	48 89 e5             	mov    %rsp,%rbp
  802f28:	48 83 ec 20          	sub    $0x20,%rsp
  802f2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f38:	be 00 00 00 00       	mov    $0x0,%esi
  802f3d:	48 89 c7             	mov    %rax,%rdi
  802f40:	48 b8 13 30 80 00 00 	movabs $0x803013,%rax
  802f47:	00 00 00 
  802f4a:	ff d0                	callq  *%rax
  802f4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f53:	79 05                	jns    802f5a <stat+0x36>
		return fd;
  802f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f58:	eb 2f                	jmp    802f89 <stat+0x65>
	r = fstat(fd, stat);
  802f5a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f61:	48 89 d6             	mov    %rdx,%rsi
  802f64:	89 c7                	mov    %eax,%edi
  802f66:	48 b8 6b 2e 80 00 00 	movabs $0x802e6b,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
  802f72:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f78:	89 c7                	mov    %eax,%edi
  802f7a:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  802f81:	00 00 00 
  802f84:	ff d0                	callq  *%rax
	return r;
  802f86:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f89:	c9                   	leaveq 
  802f8a:	c3                   	retq   
	...

0000000000802f8c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f8c:	55                   	push   %rbp
  802f8d:	48 89 e5             	mov    %rsp,%rbp
  802f90:	48 83 ec 10          	sub    $0x10,%rsp
  802f94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f9b:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802fa2:	00 00 00 
  802fa5:	8b 00                	mov    (%rax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	75 1d                	jne    802fc8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802fab:	bf 01 00 00 00       	mov    $0x1,%edi
  802fb0:	48 b8 7f 46 80 00 00 	movabs $0x80467f,%rax
  802fb7:	00 00 00 
  802fba:	ff d0                	callq  *%rax
  802fbc:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  802fc3:	00 00 00 
  802fc6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802fc8:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802fcf:	00 00 00 
  802fd2:	8b 00                	mov    (%rax),%eax
  802fd4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fd7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802fdc:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802fe3:	00 00 00 
  802fe6:	89 c7                	mov    %eax,%edi
  802fe8:	48 b8 bc 45 80 00 00 	movabs $0x8045bc,%rax
  802fef:	00 00 00 
  802ff2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ffd:	48 89 c6             	mov    %rax,%rsi
  803000:	bf 00 00 00 00       	mov    $0x0,%edi
  803005:	48 b8 fc 44 80 00 00 	movabs $0x8044fc,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
}
  803011:	c9                   	leaveq 
  803012:	c3                   	retq   

0000000000803013 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803013:	55                   	push   %rbp
  803014:	48 89 e5             	mov    %rsp,%rbp
  803017:	48 83 ec 20          	sub    $0x20,%rsp
  80301b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80301f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  803022:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803026:	48 89 c7             	mov    %rax,%rdi
  803029:	48 b8 74 12 80 00 00 	movabs $0x801274,%rax
  803030:	00 00 00 
  803033:	ff d0                	callq  *%rax
  803035:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80303a:	7e 0a                	jle    803046 <open+0x33>
                return -E_BAD_PATH;
  80303c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803041:	e9 a5 00 00 00       	jmpq   8030eb <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  803046:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80304a:	48 89 c7             	mov    %rax,%rdi
  80304d:	48 b8 6a 26 80 00 00 	movabs $0x80266a,%rax
  803054:	00 00 00 
  803057:	ff d0                	callq  *%rax
  803059:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80305c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803060:	79 08                	jns    80306a <open+0x57>
		return r;
  803062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803065:	e9 81 00 00 00       	jmpq   8030eb <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80306a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306e:	48 89 c6             	mov    %rax,%rsi
  803071:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803078:	00 00 00 
  80307b:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  803087:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80308e:	00 00 00 
  803091:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803094:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  80309a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309e:	48 89 c6             	mov    %rax,%rsi
  8030a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8030a6:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
  8030b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8030b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b9:	79 1d                	jns    8030d8 <open+0xc5>
	{
		fd_close(fd,0);
  8030bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bf:	be 00 00 00 00       	mov    $0x0,%esi
  8030c4:	48 89 c7             	mov    %rax,%rdi
  8030c7:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	callq  *%rax
		return r;
  8030d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d6:	eb 13                	jmp    8030eb <open+0xd8>
	}
	return fd2num(fd);
  8030d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030dc:	48 89 c7             	mov    %rax,%rdi
  8030df:	48 b8 1c 26 80 00 00 	movabs $0x80261c,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
	


}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 10          	sub    $0x10,%rsp
  8030f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fd:	8b 50 0c             	mov    0xc(%rax),%edx
  803100:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803107:	00 00 00 
  80310a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80310c:	be 00 00 00 00       	mov    $0x0,%esi
  803111:	bf 06 00 00 00       	mov    $0x6,%edi
  803116:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
}
  803122:	c9                   	leaveq 
  803123:	c3                   	retq   

0000000000803124 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803124:	55                   	push   %rbp
  803125:	48 89 e5             	mov    %rsp,%rbp
  803128:	48 83 ec 30          	sub    $0x30,%rsp
  80312c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803130:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803134:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313c:	8b 50 0c             	mov    0xc(%rax),%edx
  80313f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803146:	00 00 00 
  803149:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80314b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803152:	00 00 00 
  803155:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803159:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80315d:	be 00 00 00 00       	mov    $0x0,%esi
  803162:	bf 03 00 00 00       	mov    $0x3,%edi
  803167:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
  803173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803176:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317a:	79 05                	jns    803181 <devfile_read+0x5d>
	{
		return r;
  80317c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317f:	eb 2c                	jmp    8031ad <devfile_read+0x89>
	}
	if(r > 0)
  803181:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803185:	7e 23                	jle    8031aa <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  803187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318a:	48 63 d0             	movslq %eax,%rdx
  80318d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803191:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803198:	00 00 00 
  80319b:	48 89 c7             	mov    %rax,%rdi
  80319e:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
	return r;
  8031aa:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8031ad:	c9                   	leaveq 
  8031ae:	c3                   	retq   

00000000008031af <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031af:	55                   	push   %rbp
  8031b0:	48 89 e5             	mov    %rsp,%rbp
  8031b3:	48 83 ec 30          	sub    $0x30,%rsp
  8031b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8031c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c7:	8b 50 0c             	mov    0xc(%rax),%edx
  8031ca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d1:	00 00 00 
  8031d4:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8031d6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8031dd:	00 
  8031de:	76 08                	jbe    8031e8 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8031e0:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8031e7:	00 
	fsipcbuf.write.req_n=n;
  8031e8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031ef:	00 00 00 
  8031f2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031f6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8031fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803202:	48 89 c6             	mov    %rax,%rsi
  803205:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80320c:	00 00 00 
  80320f:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  803216:	00 00 00 
  803219:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80321b:	be 00 00 00 00       	mov    $0x0,%esi
  803220:	bf 04 00 00 00       	mov    $0x4,%edi
  803225:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
  803231:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  803234:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803237:	c9                   	leaveq 
  803238:	c3                   	retq   

0000000000803239 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803239:	55                   	push   %rbp
  80323a:	48 89 e5             	mov    %rsp,%rbp
  80323d:	48 83 ec 10          	sub    $0x10,%rsp
  803241:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803245:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80324c:	8b 50 0c             	mov    0xc(%rax),%edx
  80324f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803256:	00 00 00 
  803259:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80325b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803262:	00 00 00 
  803265:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803268:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80326b:	be 00 00 00 00       	mov    $0x0,%esi
  803270:	bf 02 00 00 00       	mov    $0x2,%edi
  803275:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  80327c:	00 00 00 
  80327f:	ff d0                	callq  *%rax
}
  803281:	c9                   	leaveq 
  803282:	c3                   	retq   

0000000000803283 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803283:	55                   	push   %rbp
  803284:	48 89 e5             	mov    %rsp,%rbp
  803287:	48 83 ec 20          	sub    $0x20,%rsp
  80328b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80328f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803297:	8b 50 0c             	mov    0xc(%rax),%edx
  80329a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032a1:	00 00 00 
  8032a4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032a6:	be 00 00 00 00       	mov    $0x0,%esi
  8032ab:	bf 05 00 00 00       	mov    $0x5,%edi
  8032b0:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
  8032bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c3:	79 05                	jns    8032ca <devfile_stat+0x47>
		return r;
  8032c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c8:	eb 56                	jmp    803320 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ce:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8032d5:	00 00 00 
  8032d8:	48 89 c7             	mov    %rax,%rdi
  8032db:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032e7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032ee:	00 00 00 
  8032f1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032fb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803301:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803308:	00 00 00 
  80330b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803311:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803315:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80331b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803320:	c9                   	leaveq 
  803321:	c3                   	retq   
	...

0000000000803324 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803324:	55                   	push   %rbp
  803325:	48 89 e5             	mov    %rsp,%rbp
  803328:	48 83 ec 20          	sub    $0x20,%rsp
  80332c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80332f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803333:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803336:	48 89 d6             	mov    %rdx,%rsi
  803339:	89 c7                	mov    %eax,%edi
  80333b:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  803342:	00 00 00 
  803345:	ff d0                	callq  *%rax
  803347:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80334a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334e:	79 05                	jns    803355 <fd2sockid+0x31>
		return r;
  803350:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803353:	eb 24                	jmp    803379 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803359:	8b 10                	mov    (%rax),%edx
  80335b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803362:	00 00 00 
  803365:	8b 00                	mov    (%rax),%eax
  803367:	39 c2                	cmp    %eax,%edx
  803369:	74 07                	je     803372 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80336b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803370:	eb 07                	jmp    803379 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803376:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803379:	c9                   	leaveq 
  80337a:	c3                   	retq   

000000000080337b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80337b:	55                   	push   %rbp
  80337c:	48 89 e5             	mov    %rsp,%rbp
  80337f:	48 83 ec 20          	sub    $0x20,%rsp
  803383:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803386:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80338a:	48 89 c7             	mov    %rax,%rdi
  80338d:	48 b8 6a 26 80 00 00 	movabs $0x80266a,%rax
  803394:	00 00 00 
  803397:	ff d0                	callq  *%rax
  803399:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80339c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033a0:	78 26                	js     8033c8 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8033a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8033ab:	48 89 c6             	mov    %rax,%rsi
  8033ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b3:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  8033ba:	00 00 00 
  8033bd:	ff d0                	callq  *%rax
  8033bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c6:	79 16                	jns    8033de <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8033c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033cb:	89 c7                	mov    %eax,%edi
  8033cd:	48 b8 88 38 80 00 00 	movabs $0x803888,%rax
  8033d4:	00 00 00 
  8033d7:	ff d0                	callq  *%rax
		return r;
  8033d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033dc:	eb 3a                	jmp    803418 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8033de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8033e9:	00 00 00 
  8033ec:	8b 12                	mov    (%rdx),%edx
  8033ee:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8033f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8033fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ff:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803402:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803409:	48 89 c7             	mov    %rax,%rdi
  80340c:	48 b8 1c 26 80 00 00 	movabs $0x80261c,%rax
  803413:	00 00 00 
  803416:	ff d0                	callq  *%rax
}
  803418:	c9                   	leaveq 
  803419:	c3                   	retq   

000000000080341a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80341a:	55                   	push   %rbp
  80341b:	48 89 e5             	mov    %rsp,%rbp
  80341e:	48 83 ec 30          	sub    $0x30,%rsp
  803422:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803425:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803429:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80342d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803430:	89 c7                	mov    %eax,%edi
  803432:	48 b8 24 33 80 00 00 	movabs $0x803324,%rax
  803439:	00 00 00 
  80343c:	ff d0                	callq  *%rax
  80343e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803441:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803445:	79 05                	jns    80344c <accept+0x32>
		return r;
  803447:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344a:	eb 3b                	jmp    803487 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80344c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803450:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803457:	48 89 ce             	mov    %rcx,%rsi
  80345a:	89 c7                	mov    %eax,%edi
  80345c:	48 b8 65 37 80 00 00 	movabs $0x803765,%rax
  803463:	00 00 00 
  803466:	ff d0                	callq  *%rax
  803468:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80346f:	79 05                	jns    803476 <accept+0x5c>
		return r;
  803471:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803474:	eb 11                	jmp    803487 <accept+0x6d>
	return alloc_sockfd(r);
  803476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803479:	89 c7                	mov    %eax,%edi
  80347b:	48 b8 7b 33 80 00 00 	movabs $0x80337b,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
}
  803487:	c9                   	leaveq 
  803488:	c3                   	retq   

0000000000803489 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803489:	55                   	push   %rbp
  80348a:	48 89 e5             	mov    %rsp,%rbp
  80348d:	48 83 ec 20          	sub    $0x20,%rsp
  803491:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803494:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803498:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80349b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349e:	89 c7                	mov    %eax,%edi
  8034a0:	48 b8 24 33 80 00 00 	movabs $0x803324,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b3:	79 05                	jns    8034ba <bind+0x31>
		return r;
  8034b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b8:	eb 1b                	jmp    8034d5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8034ba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034bd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c4:	48 89 ce             	mov    %rcx,%rsi
  8034c7:	89 c7                	mov    %eax,%edi
  8034c9:	48 b8 e4 37 80 00 00 	movabs $0x8037e4,%rax
  8034d0:	00 00 00 
  8034d3:	ff d0                	callq  *%rax
}
  8034d5:	c9                   	leaveq 
  8034d6:	c3                   	retq   

00000000008034d7 <shutdown>:

int
shutdown(int s, int how)
{
  8034d7:	55                   	push   %rbp
  8034d8:	48 89 e5             	mov    %rsp,%rbp
  8034db:	48 83 ec 20          	sub    $0x20,%rsp
  8034df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034e2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e8:	89 c7                	mov    %eax,%edi
  8034ea:	48 b8 24 33 80 00 00 	movabs $0x803324,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
  8034f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034fd:	79 05                	jns    803504 <shutdown+0x2d>
		return r;
  8034ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803502:	eb 16                	jmp    80351a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803504:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803507:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350a:	89 d6                	mov    %edx,%esi
  80350c:	89 c7                	mov    %eax,%edi
  80350e:	48 b8 48 38 80 00 00 	movabs $0x803848,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
}
  80351a:	c9                   	leaveq 
  80351b:	c3                   	retq   

000000000080351c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80351c:	55                   	push   %rbp
  80351d:	48 89 e5             	mov    %rsp,%rbp
  803520:	48 83 ec 10          	sub    $0x10,%rsp
  803524:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352c:	48 89 c7             	mov    %rax,%rdi
  80352f:	48 b8 04 47 80 00 00 	movabs $0x804704,%rax
  803536:	00 00 00 
  803539:	ff d0                	callq  *%rax
  80353b:	83 f8 01             	cmp    $0x1,%eax
  80353e:	75 17                	jne    803557 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803544:	8b 40 0c             	mov    0xc(%rax),%eax
  803547:	89 c7                	mov    %eax,%edi
  803549:	48 b8 88 38 80 00 00 	movabs $0x803888,%rax
  803550:	00 00 00 
  803553:	ff d0                	callq  *%rax
  803555:	eb 05                	jmp    80355c <devsock_close+0x40>
	else
		return 0;
  803557:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80355c:	c9                   	leaveq 
  80355d:	c3                   	retq   

000000000080355e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80355e:	55                   	push   %rbp
  80355f:	48 89 e5             	mov    %rsp,%rbp
  803562:	48 83 ec 20          	sub    $0x20,%rsp
  803566:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803569:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80356d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803570:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803573:	89 c7                	mov    %eax,%edi
  803575:	48 b8 24 33 80 00 00 	movabs $0x803324,%rax
  80357c:	00 00 00 
  80357f:	ff d0                	callq  *%rax
  803581:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803584:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803588:	79 05                	jns    80358f <connect+0x31>
		return r;
  80358a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358d:	eb 1b                	jmp    8035aa <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80358f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803592:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803596:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803599:	48 89 ce             	mov    %rcx,%rsi
  80359c:	89 c7                	mov    %eax,%edi
  80359e:	48 b8 b5 38 80 00 00 	movabs $0x8038b5,%rax
  8035a5:	00 00 00 
  8035a8:	ff d0                	callq  *%rax
}
  8035aa:	c9                   	leaveq 
  8035ab:	c3                   	retq   

00000000008035ac <listen>:

int
listen(int s, int backlog)
{
  8035ac:	55                   	push   %rbp
  8035ad:	48 89 e5             	mov    %rsp,%rbp
  8035b0:	48 83 ec 20          	sub    $0x20,%rsp
  8035b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035b7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035bd:	89 c7                	mov    %eax,%edi
  8035bf:	48 b8 24 33 80 00 00 	movabs $0x803324,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
  8035cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d2:	79 05                	jns    8035d9 <listen+0x2d>
		return r;
  8035d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d7:	eb 16                	jmp    8035ef <listen+0x43>
	return nsipc_listen(r, backlog);
  8035d9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035df:	89 d6                	mov    %edx,%esi
  8035e1:	89 c7                	mov    %eax,%edi
  8035e3:	48 b8 19 39 80 00 00 	movabs $0x803919,%rax
  8035ea:	00 00 00 
  8035ed:	ff d0                	callq  *%rax
}
  8035ef:	c9                   	leaveq 
  8035f0:	c3                   	retq   

00000000008035f1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8035f1:	55                   	push   %rbp
  8035f2:	48 89 e5             	mov    %rsp,%rbp
  8035f5:	48 83 ec 20          	sub    $0x20,%rsp
  8035f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803601:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803609:	89 c2                	mov    %eax,%edx
  80360b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80360f:	8b 40 0c             	mov    0xc(%rax),%eax
  803612:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803616:	b9 00 00 00 00       	mov    $0x0,%ecx
  80361b:	89 c7                	mov    %eax,%edi
  80361d:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
}
  803629:	c9                   	leaveq 
  80362a:	c3                   	retq   

000000000080362b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80362b:	55                   	push   %rbp
  80362c:	48 89 e5             	mov    %rsp,%rbp
  80362f:	48 83 ec 20          	sub    $0x20,%rsp
  803633:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803637:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80363b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80363f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803643:	89 c2                	mov    %eax,%edx
  803645:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803649:	8b 40 0c             	mov    0xc(%rax),%eax
  80364c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803650:	b9 00 00 00 00       	mov    $0x0,%ecx
  803655:	89 c7                	mov    %eax,%edi
  803657:	48 b8 25 3a 80 00 00 	movabs $0x803a25,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
}
  803663:	c9                   	leaveq 
  803664:	c3                   	retq   

0000000000803665 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803665:	55                   	push   %rbp
  803666:	48 89 e5             	mov    %rsp,%rbp
  803669:	48 83 ec 10          	sub    $0x10,%rsp
  80366d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803671:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803679:	48 be db 4f 80 00 00 	movabs $0x804fdb,%rsi
  803680:	00 00 00 
  803683:	48 89 c7             	mov    %rax,%rdi
  803686:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
	return 0;
  803692:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803697:	c9                   	leaveq 
  803698:	c3                   	retq   

0000000000803699 <socket>:

int
socket(int domain, int type, int protocol)
{
  803699:	55                   	push   %rbp
  80369a:	48 89 e5             	mov    %rsp,%rbp
  80369d:	48 83 ec 20          	sub    $0x20,%rsp
  8036a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036a4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8036a7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8036aa:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8036ad:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b3:	89 ce                	mov    %ecx,%esi
  8036b5:	89 c7                	mov    %eax,%edi
  8036b7:	48 b8 dd 3a 80 00 00 	movabs $0x803add,%rax
  8036be:	00 00 00 
  8036c1:	ff d0                	callq  *%rax
  8036c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ca:	79 05                	jns    8036d1 <socket+0x38>
		return r;
  8036cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036cf:	eb 11                	jmp    8036e2 <socket+0x49>
	return alloc_sockfd(r);
  8036d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d4:	89 c7                	mov    %eax,%edi
  8036d6:	48 b8 7b 33 80 00 00 	movabs $0x80337b,%rax
  8036dd:	00 00 00 
  8036e0:	ff d0                	callq  *%rax
}
  8036e2:	c9                   	leaveq 
  8036e3:	c3                   	retq   

00000000008036e4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8036e4:	55                   	push   %rbp
  8036e5:	48 89 e5             	mov    %rsp,%rbp
  8036e8:	48 83 ec 10          	sub    $0x10,%rsp
  8036ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8036ef:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  8036f6:	00 00 00 
  8036f9:	8b 00                	mov    (%rax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	75 1d                	jne    80371c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8036ff:	bf 02 00 00 00       	mov    $0x2,%edi
  803704:	48 b8 7f 46 80 00 00 	movabs $0x80467f,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
  803710:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  803717:	00 00 00 
  80371a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80371c:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803723:	00 00 00 
  803726:	8b 00                	mov    (%rax),%eax
  803728:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80372b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803730:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803737:	00 00 00 
  80373a:	89 c7                	mov    %eax,%edi
  80373c:	48 b8 bc 45 80 00 00 	movabs $0x8045bc,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803748:	ba 00 00 00 00       	mov    $0x0,%edx
  80374d:	be 00 00 00 00       	mov    $0x0,%esi
  803752:	bf 00 00 00 00       	mov    $0x0,%edi
  803757:	48 b8 fc 44 80 00 00 	movabs $0x8044fc,%rax
  80375e:	00 00 00 
  803761:	ff d0                	callq  *%rax
}
  803763:	c9                   	leaveq 
  803764:	c3                   	retq   

0000000000803765 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803765:	55                   	push   %rbp
  803766:	48 89 e5             	mov    %rsp,%rbp
  803769:	48 83 ec 30          	sub    $0x30,%rsp
  80376d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803770:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803774:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803778:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80377f:	00 00 00 
  803782:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803785:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803787:	bf 01 00 00 00       	mov    $0x1,%edi
  80378c:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  803793:	00 00 00 
  803796:	ff d0                	callq  *%rax
  803798:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379f:	78 3e                	js     8037df <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8037a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037a8:	00 00 00 
  8037ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8037af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b3:	8b 40 10             	mov    0x10(%rax),%eax
  8037b6:	89 c2                	mov    %eax,%edx
  8037b8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8037bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c0:	48 89 ce             	mov    %rcx,%rsi
  8037c3:	48 89 c7             	mov    %rax,%rdi
  8037c6:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  8037cd:	00 00 00 
  8037d0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8037d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d6:	8b 50 10             	mov    0x10(%rax),%edx
  8037d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037dd:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8037df:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037e2:	c9                   	leaveq 
  8037e3:	c3                   	retq   

00000000008037e4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037e4:	55                   	push   %rbp
  8037e5:	48 89 e5             	mov    %rsp,%rbp
  8037e8:	48 83 ec 10          	sub    $0x10,%rsp
  8037ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8037f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fd:	00 00 00 
  803800:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803803:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803805:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380c:	48 89 c6             	mov    %rax,%rsi
  80380f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803816:	00 00 00 
  803819:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803825:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80382c:	00 00 00 
  80382f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803832:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803835:	bf 02 00 00 00       	mov    $0x2,%edi
  80383a:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  803841:	00 00 00 
  803844:	ff d0                	callq  *%rax
}
  803846:	c9                   	leaveq 
  803847:	c3                   	retq   

0000000000803848 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803848:	55                   	push   %rbp
  803849:	48 89 e5             	mov    %rsp,%rbp
  80384c:	48 83 ec 10          	sub    $0x10,%rsp
  803850:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803853:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803856:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80385d:	00 00 00 
  803860:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803863:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803865:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80386c:	00 00 00 
  80386f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803872:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803875:	bf 03 00 00 00       	mov    $0x3,%edi
  80387a:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  803881:	00 00 00 
  803884:	ff d0                	callq  *%rax
}
  803886:	c9                   	leaveq 
  803887:	c3                   	retq   

0000000000803888 <nsipc_close>:

int
nsipc_close(int s)
{
  803888:	55                   	push   %rbp
  803889:	48 89 e5             	mov    %rsp,%rbp
  80388c:	48 83 ec 10          	sub    $0x10,%rsp
  803890:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803893:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80389a:	00 00 00 
  80389d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038a0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8038a2:	bf 04 00 00 00       	mov    $0x4,%edi
  8038a7:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  8038ae:	00 00 00 
  8038b1:	ff d0                	callq  *%rax
}
  8038b3:	c9                   	leaveq 
  8038b4:	c3                   	retq   

00000000008038b5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038b5:	55                   	push   %rbp
  8038b6:	48 89 e5             	mov    %rsp,%rbp
  8038b9:	48 83 ec 10          	sub    $0x10,%rsp
  8038bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8038c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038ce:	00 00 00 
  8038d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038d4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8038d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038dd:	48 89 c6             	mov    %rax,%rsi
  8038e0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8038e7:	00 00 00 
  8038ea:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  8038f1:	00 00 00 
  8038f4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8038f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038fd:	00 00 00 
  803900:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803903:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803906:	bf 05 00 00 00       	mov    $0x5,%edi
  80390b:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
}
  803917:	c9                   	leaveq 
  803918:	c3                   	retq   

0000000000803919 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803919:	55                   	push   %rbp
  80391a:	48 89 e5             	mov    %rsp,%rbp
  80391d:	48 83 ec 10          	sub    $0x10,%rsp
  803921:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803924:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803927:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80392e:	00 00 00 
  803931:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803934:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803936:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80393d:	00 00 00 
  803940:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803943:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803946:	bf 06 00 00 00       	mov    $0x6,%edi
  80394b:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  803952:	00 00 00 
  803955:	ff d0                	callq  *%rax
}
  803957:	c9                   	leaveq 
  803958:	c3                   	retq   

0000000000803959 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803959:	55                   	push   %rbp
  80395a:	48 89 e5             	mov    %rsp,%rbp
  80395d:	48 83 ec 30          	sub    $0x30,%rsp
  803961:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803964:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803968:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80396b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80396e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803975:	00 00 00 
  803978:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80397b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80397d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803984:	00 00 00 
  803987:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80398a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80398d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803994:	00 00 00 
  803997:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80399a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80399d:	bf 07 00 00 00       	mov    $0x7,%edi
  8039a2:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  8039a9:	00 00 00 
  8039ac:	ff d0                	callq  *%rax
  8039ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b5:	78 69                	js     803a20 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8039b7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8039be:	7f 08                	jg     8039c8 <nsipc_recv+0x6f>
  8039c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8039c6:	7e 35                	jle    8039fd <nsipc_recv+0xa4>
  8039c8:	48 b9 e2 4f 80 00 00 	movabs $0x804fe2,%rcx
  8039cf:	00 00 00 
  8039d2:	48 ba f7 4f 80 00 00 	movabs $0x804ff7,%rdx
  8039d9:	00 00 00 
  8039dc:	be 61 00 00 00       	mov    $0x61,%esi
  8039e1:	48 bf 0c 50 80 00 00 	movabs $0x80500c,%rdi
  8039e8:	00 00 00 
  8039eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f0:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  8039f7:	00 00 00 
  8039fa:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8039fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a00:	48 63 d0             	movslq %eax,%rdx
  803a03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a07:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803a0e:	00 00 00 
  803a11:	48 89 c7             	mov    %rax,%rdi
  803a14:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  803a1b:	00 00 00 
  803a1e:	ff d0                	callq  *%rax
	}

	return r;
  803a20:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a23:	c9                   	leaveq 
  803a24:	c3                   	retq   

0000000000803a25 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a25:	55                   	push   %rbp
  803a26:	48 89 e5             	mov    %rsp,%rbp
  803a29:	48 83 ec 20          	sub    $0x20,%rsp
  803a2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a34:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803a37:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803a3a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a41:	00 00 00 
  803a44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a47:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a49:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a50:	7e 35                	jle    803a87 <nsipc_send+0x62>
  803a52:	48 b9 18 50 80 00 00 	movabs $0x805018,%rcx
  803a59:	00 00 00 
  803a5c:	48 ba f7 4f 80 00 00 	movabs $0x804ff7,%rdx
  803a63:	00 00 00 
  803a66:	be 6c 00 00 00       	mov    $0x6c,%esi
  803a6b:	48 bf 0c 50 80 00 00 	movabs $0x80500c,%rdi
  803a72:	00 00 00 
  803a75:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7a:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  803a81:	00 00 00 
  803a84:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a87:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a8a:	48 63 d0             	movslq %eax,%rdx
  803a8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a91:	48 89 c6             	mov    %rax,%rsi
  803a94:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803a9b:	00 00 00 
  803a9e:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  803aa5:	00 00 00 
  803aa8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803aaa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ab1:	00 00 00 
  803ab4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ab7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803aba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ac1:	00 00 00 
  803ac4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ac7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803aca:	bf 08 00 00 00       	mov    $0x8,%edi
  803acf:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  803ad6:	00 00 00 
  803ad9:	ff d0                	callq  *%rax
}
  803adb:	c9                   	leaveq 
  803adc:	c3                   	retq   

0000000000803add <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803add:	55                   	push   %rbp
  803ade:	48 89 e5             	mov    %rsp,%rbp
  803ae1:	48 83 ec 10          	sub    $0x10,%rsp
  803ae5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ae8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803aeb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803aee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803af5:	00 00 00 
  803af8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803afb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803afd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b04:	00 00 00 
  803b07:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b0a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803b0d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b14:	00 00 00 
  803b17:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b1a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803b1d:	bf 09 00 00 00       	mov    $0x9,%edi
  803b22:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	callq  *%rax
}
  803b2e:	c9                   	leaveq 
  803b2f:	c3                   	retq   

0000000000803b30 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803b30:	55                   	push   %rbp
  803b31:	48 89 e5             	mov    %rsp,%rbp
  803b34:	53                   	push   %rbx
  803b35:	48 83 ec 38          	sub    $0x38,%rsp
  803b39:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803b3d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b41:	48 89 c7             	mov    %rax,%rdi
  803b44:	48 b8 6a 26 80 00 00 	movabs $0x80266a,%rax
  803b4b:	00 00 00 
  803b4e:	ff d0                	callq  *%rax
  803b50:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b53:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b57:	0f 88 bf 01 00 00    	js     803d1c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b61:	ba 07 04 00 00       	mov    $0x407,%edx
  803b66:	48 89 c6             	mov    %rax,%rsi
  803b69:	bf 00 00 00 00       	mov    $0x0,%edi
  803b6e:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
  803b7a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b81:	0f 88 95 01 00 00    	js     803d1c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803b87:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803b8b:	48 89 c7             	mov    %rax,%rdi
  803b8e:	48 b8 6a 26 80 00 00 	movabs $0x80266a,%rax
  803b95:	00 00 00 
  803b98:	ff d0                	callq  *%rax
  803b9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ba1:	0f 88 5d 01 00 00    	js     803d04 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ba7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bab:	ba 07 04 00 00       	mov    $0x407,%edx
  803bb0:	48 89 c6             	mov    %rax,%rsi
  803bb3:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb8:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  803bbf:	00 00 00 
  803bc2:	ff d0                	callq  *%rax
  803bc4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bcb:	0f 88 33 01 00 00    	js     803d04 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd5:	48 89 c7             	mov    %rax,%rdi
  803bd8:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  803bdf:	00 00 00 
  803be2:	ff d0                	callq  *%rax
  803be4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803be8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bec:	ba 07 04 00 00       	mov    $0x407,%edx
  803bf1:	48 89 c6             	mov    %rax,%rsi
  803bf4:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf9:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  803c00:	00 00 00 
  803c03:	ff d0                	callq  *%rax
  803c05:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c0c:	0f 88 d9 00 00 00    	js     803ceb <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c16:	48 89 c7             	mov    %rax,%rdi
  803c19:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  803c20:	00 00 00 
  803c23:	ff d0                	callq  *%rax
  803c25:	48 89 c2             	mov    %rax,%rdx
  803c28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c2c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803c32:	48 89 d1             	mov    %rdx,%rcx
  803c35:	ba 00 00 00 00       	mov    $0x0,%edx
  803c3a:	48 89 c6             	mov    %rax,%rsi
  803c3d:	bf 00 00 00 00       	mov    $0x0,%edi
  803c42:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  803c49:	00 00 00 
  803c4c:	ff d0                	callq  *%rax
  803c4e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c51:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c55:	78 79                	js     803cd0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803c57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c5b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c62:	00 00 00 
  803c65:	8b 12                	mov    (%rdx),%edx
  803c67:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803c69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803c74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c78:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c7f:	00 00 00 
  803c82:	8b 12                	mov    (%rdx),%edx
  803c84:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803c86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c8a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c95:	48 89 c7             	mov    %rax,%rdi
  803c98:	48 b8 1c 26 80 00 00 	movabs $0x80261c,%rax
  803c9f:	00 00 00 
  803ca2:	ff d0                	callq  *%rax
  803ca4:	89 c2                	mov    %eax,%edx
  803ca6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803caa:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803cac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cb0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803cb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cb8:	48 89 c7             	mov    %rax,%rdi
  803cbb:	48 b8 1c 26 80 00 00 	movabs $0x80261c,%rax
  803cc2:	00 00 00 
  803cc5:	ff d0                	callq  *%rax
  803cc7:	89 03                	mov    %eax,(%rbx)
	return 0;
  803cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cce:	eb 4f                	jmp    803d1f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803cd0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803cd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd5:	48 89 c6             	mov    %rax,%rsi
  803cd8:	bf 00 00 00 00       	mov    $0x0,%edi
  803cdd:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  803ce4:	00 00 00 
  803ce7:	ff d0                	callq  *%rax
  803ce9:	eb 01                	jmp    803cec <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803ceb:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803cec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cf0:	48 89 c6             	mov    %rax,%rsi
  803cf3:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf8:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  803cff:	00 00 00 
  803d02:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803d04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d08:	48 89 c6             	mov    %rax,%rsi
  803d0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803d10:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
    err:
	return r;
  803d1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d1f:	48 83 c4 38          	add    $0x38,%rsp
  803d23:	5b                   	pop    %rbx
  803d24:	5d                   	pop    %rbp
  803d25:	c3                   	retq   

0000000000803d26 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d26:	55                   	push   %rbp
  803d27:	48 89 e5             	mov    %rsp,%rbp
  803d2a:	53                   	push   %rbx
  803d2b:	48 83 ec 28          	sub    $0x28,%rsp
  803d2f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d33:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d37:	eb 01                	jmp    803d3a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803d39:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d3a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803d41:	00 00 00 
  803d44:	48 8b 00             	mov    (%rax),%rax
  803d47:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d54:	48 89 c7             	mov    %rax,%rdi
  803d57:	48 b8 04 47 80 00 00 	movabs $0x804704,%rax
  803d5e:	00 00 00 
  803d61:	ff d0                	callq  *%rax
  803d63:	89 c3                	mov    %eax,%ebx
  803d65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d69:	48 89 c7             	mov    %rax,%rdi
  803d6c:	48 b8 04 47 80 00 00 	movabs $0x804704,%rax
  803d73:	00 00 00 
  803d76:	ff d0                	callq  *%rax
  803d78:	39 c3                	cmp    %eax,%ebx
  803d7a:	0f 94 c0             	sete   %al
  803d7d:	0f b6 c0             	movzbl %al,%eax
  803d80:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803d83:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803d8a:	00 00 00 
  803d8d:	48 8b 00             	mov    (%rax),%rax
  803d90:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d96:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803d99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d9c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d9f:	75 0a                	jne    803dab <_pipeisclosed+0x85>
			return ret;
  803da1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803da4:	48 83 c4 28          	add    $0x28,%rsp
  803da8:	5b                   	pop    %rbx
  803da9:	5d                   	pop    %rbp
  803daa:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803dab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dae:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803db1:	74 86                	je     803d39 <_pipeisclosed+0x13>
  803db3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803db7:	75 80                	jne    803d39 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803db9:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803dc0:	00 00 00 
  803dc3:	48 8b 00             	mov    (%rax),%rax
  803dc6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803dcc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803dcf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd2:	89 c6                	mov    %eax,%esi
  803dd4:	48 bf 29 50 80 00 00 	movabs $0x805029,%rdi
  803ddb:	00 00 00 
  803dde:	b8 00 00 00 00       	mov    $0x0,%eax
  803de3:	49 b8 23 07 80 00 00 	movabs $0x800723,%r8
  803dea:	00 00 00 
  803ded:	41 ff d0             	callq  *%r8
	}
  803df0:	e9 44 ff ff ff       	jmpq   803d39 <_pipeisclosed+0x13>

0000000000803df5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803df5:	55                   	push   %rbp
  803df6:	48 89 e5             	mov    %rsp,%rbp
  803df9:	48 83 ec 30          	sub    $0x30,%rsp
  803dfd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e00:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e04:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e07:	48 89 d6             	mov    %rdx,%rsi
  803e0a:	89 c7                	mov    %eax,%edi
  803e0c:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  803e13:	00 00 00 
  803e16:	ff d0                	callq  *%rax
  803e18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e1f:	79 05                	jns    803e26 <pipeisclosed+0x31>
		return r;
  803e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e24:	eb 31                	jmp    803e57 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e2a:	48 89 c7             	mov    %rax,%rdi
  803e2d:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  803e34:	00 00 00 
  803e37:	ff d0                	callq  *%rax
  803e39:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e45:	48 89 d6             	mov    %rdx,%rsi
  803e48:	48 89 c7             	mov    %rax,%rdi
  803e4b:	48 b8 26 3d 80 00 00 	movabs $0x803d26,%rax
  803e52:	00 00 00 
  803e55:	ff d0                	callq  *%rax
}
  803e57:	c9                   	leaveq 
  803e58:	c3                   	retq   

0000000000803e59 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e59:	55                   	push   %rbp
  803e5a:	48 89 e5             	mov    %rsp,%rbp
  803e5d:	48 83 ec 40          	sub    $0x40,%rsp
  803e61:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e65:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e69:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e71:	48 89 c7             	mov    %rax,%rdi
  803e74:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  803e7b:	00 00 00 
  803e7e:	ff d0                	callq  *%rax
  803e80:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e8c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e93:	00 
  803e94:	e9 97 00 00 00       	jmpq   803f30 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e99:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e9e:	74 09                	je     803ea9 <devpipe_read+0x50>
				return i;
  803ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ea4:	e9 95 00 00 00       	jmpq   803f3e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ea9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ead:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eb1:	48 89 d6             	mov    %rdx,%rsi
  803eb4:	48 89 c7             	mov    %rax,%rdi
  803eb7:	48 b8 26 3d 80 00 00 	movabs $0x803d26,%rax
  803ebe:	00 00 00 
  803ec1:	ff d0                	callq  *%rax
  803ec3:	85 c0                	test   %eax,%eax
  803ec5:	74 07                	je     803ece <devpipe_read+0x75>
				return 0;
  803ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  803ecc:	eb 70                	jmp    803f3e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803ece:	48 b8 da 1b 80 00 00 	movabs $0x801bda,%rax
  803ed5:	00 00 00 
  803ed8:	ff d0                	callq  *%rax
  803eda:	eb 01                	jmp    803edd <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803edc:	90                   	nop
  803edd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee1:	8b 10                	mov    (%rax),%edx
  803ee3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee7:	8b 40 04             	mov    0x4(%rax),%eax
  803eea:	39 c2                	cmp    %eax,%edx
  803eec:	74 ab                	je     803e99 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803eee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ef2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ef6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803efa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803efe:	8b 00                	mov    (%rax),%eax
  803f00:	89 c2                	mov    %eax,%edx
  803f02:	c1 fa 1f             	sar    $0x1f,%edx
  803f05:	c1 ea 1b             	shr    $0x1b,%edx
  803f08:	01 d0                	add    %edx,%eax
  803f0a:	83 e0 1f             	and    $0x1f,%eax
  803f0d:	29 d0                	sub    %edx,%eax
  803f0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f13:	48 98                	cltq   
  803f15:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803f1a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f20:	8b 00                	mov    (%rax),%eax
  803f22:	8d 50 01             	lea    0x1(%rax),%edx
  803f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f29:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f2b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f34:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f38:	72 a2                	jb     803edc <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803f3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f3e:	c9                   	leaveq 
  803f3f:	c3                   	retq   

0000000000803f40 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f40:	55                   	push   %rbp
  803f41:	48 89 e5             	mov    %rsp,%rbp
  803f44:	48 83 ec 40          	sub    $0x40,%rsp
  803f48:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f4c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f50:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f58:	48 89 c7             	mov    %rax,%rdi
  803f5b:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  803f62:	00 00 00 
  803f65:	ff d0                	callq  *%rax
  803f67:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f73:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f7a:	00 
  803f7b:	e9 93 00 00 00       	jmpq   804013 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803f80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f88:	48 89 d6             	mov    %rdx,%rsi
  803f8b:	48 89 c7             	mov    %rax,%rdi
  803f8e:	48 b8 26 3d 80 00 00 	movabs $0x803d26,%rax
  803f95:	00 00 00 
  803f98:	ff d0                	callq  *%rax
  803f9a:	85 c0                	test   %eax,%eax
  803f9c:	74 07                	je     803fa5 <devpipe_write+0x65>
				return 0;
  803f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa3:	eb 7c                	jmp    804021 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803fa5:	48 b8 da 1b 80 00 00 	movabs $0x801bda,%rax
  803fac:	00 00 00 
  803faf:	ff d0                	callq  *%rax
  803fb1:	eb 01                	jmp    803fb4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803fb3:	90                   	nop
  803fb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fb8:	8b 40 04             	mov    0x4(%rax),%eax
  803fbb:	48 63 d0             	movslq %eax,%rdx
  803fbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc2:	8b 00                	mov    (%rax),%eax
  803fc4:	48 98                	cltq   
  803fc6:	48 83 c0 20          	add    $0x20,%rax
  803fca:	48 39 c2             	cmp    %rax,%rdx
  803fcd:	73 b1                	jae    803f80 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd3:	8b 40 04             	mov    0x4(%rax),%eax
  803fd6:	89 c2                	mov    %eax,%edx
  803fd8:	c1 fa 1f             	sar    $0x1f,%edx
  803fdb:	c1 ea 1b             	shr    $0x1b,%edx
  803fde:	01 d0                	add    %edx,%eax
  803fe0:	83 e0 1f             	and    $0x1f,%eax
  803fe3:	29 d0                	sub    %edx,%eax
  803fe5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803fe9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803fed:	48 01 ca             	add    %rcx,%rdx
  803ff0:	0f b6 0a             	movzbl (%rdx),%ecx
  803ff3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ff7:	48 98                	cltq   
  803ff9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ffd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804001:	8b 40 04             	mov    0x4(%rax),%eax
  804004:	8d 50 01             	lea    0x1(%rax),%edx
  804007:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80400b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80400e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804017:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80401b:	72 96                	jb     803fb3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80401d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804021:	c9                   	leaveq 
  804022:	c3                   	retq   

0000000000804023 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804023:	55                   	push   %rbp
  804024:	48 89 e5             	mov    %rsp,%rbp
  804027:	48 83 ec 20          	sub    $0x20,%rsp
  80402b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80402f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804037:	48 89 c7             	mov    %rax,%rdi
  80403a:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  804041:	00 00 00 
  804044:	ff d0                	callq  *%rax
  804046:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80404a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80404e:	48 be 3c 50 80 00 00 	movabs $0x80503c,%rsi
  804055:	00 00 00 
  804058:	48 89 c7             	mov    %rax,%rdi
  80405b:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  804062:	00 00 00 
  804065:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804067:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80406b:	8b 50 04             	mov    0x4(%rax),%edx
  80406e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804072:	8b 00                	mov    (%rax),%eax
  804074:	29 c2                	sub    %eax,%edx
  804076:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80407a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804080:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804084:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80408b:	00 00 00 
	stat->st_dev = &devpipe;
  80408e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804092:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  804099:	00 00 00 
  80409c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8040a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040a8:	c9                   	leaveq 
  8040a9:	c3                   	retq   

00000000008040aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8040aa:	55                   	push   %rbp
  8040ab:	48 89 e5             	mov    %rsp,%rbp
  8040ae:	48 83 ec 10          	sub    $0x10,%rsp
  8040b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8040b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ba:	48 89 c6             	mov    %rax,%rsi
  8040bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c2:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  8040c9:	00 00 00 
  8040cc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8040ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d2:	48 89 c7             	mov    %rax,%rdi
  8040d5:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  8040dc:	00 00 00 
  8040df:	ff d0                	callq  *%rax
  8040e1:	48 89 c6             	mov    %rax,%rsi
  8040e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8040e9:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  8040f0:	00 00 00 
  8040f3:	ff d0                	callq  *%rax
}
  8040f5:	c9                   	leaveq 
  8040f6:	c3                   	retq   
	...

00000000008040f8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8040f8:	55                   	push   %rbp
  8040f9:	48 89 e5             	mov    %rsp,%rbp
  8040fc:	48 83 ec 20          	sub    $0x20,%rsp
  804100:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804103:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804106:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804109:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80410d:	be 01 00 00 00       	mov    $0x1,%esi
  804112:	48 89 c7             	mov    %rax,%rdi
  804115:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  80411c:	00 00 00 
  80411f:	ff d0                	callq  *%rax
}
  804121:	c9                   	leaveq 
  804122:	c3                   	retq   

0000000000804123 <getchar>:

int
getchar(void)
{
  804123:	55                   	push   %rbp
  804124:	48 89 e5             	mov    %rsp,%rbp
  804127:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80412b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80412f:	ba 01 00 00 00       	mov    $0x1,%edx
  804134:	48 89 c6             	mov    %rax,%rsi
  804137:	bf 00 00 00 00       	mov    $0x0,%edi
  80413c:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  804143:	00 00 00 
  804146:	ff d0                	callq  *%rax
  804148:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80414b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80414f:	79 05                	jns    804156 <getchar+0x33>
		return r;
  804151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804154:	eb 14                	jmp    80416a <getchar+0x47>
	if (r < 1)
  804156:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80415a:	7f 07                	jg     804163 <getchar+0x40>
		return -E_EOF;
  80415c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804161:	eb 07                	jmp    80416a <getchar+0x47>
	return c;
  804163:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804167:	0f b6 c0             	movzbl %al,%eax
}
  80416a:	c9                   	leaveq 
  80416b:	c3                   	retq   

000000000080416c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80416c:	55                   	push   %rbp
  80416d:	48 89 e5             	mov    %rsp,%rbp
  804170:	48 83 ec 20          	sub    $0x20,%rsp
  804174:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804177:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80417b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80417e:	48 89 d6             	mov    %rdx,%rsi
  804181:	89 c7                	mov    %eax,%edi
  804183:	48 b8 02 27 80 00 00 	movabs $0x802702,%rax
  80418a:	00 00 00 
  80418d:	ff d0                	callq  *%rax
  80418f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804192:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804196:	79 05                	jns    80419d <iscons+0x31>
		return r;
  804198:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80419b:	eb 1a                	jmp    8041b7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80419d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a1:	8b 10                	mov    (%rax),%edx
  8041a3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8041aa:	00 00 00 
  8041ad:	8b 00                	mov    (%rax),%eax
  8041af:	39 c2                	cmp    %eax,%edx
  8041b1:	0f 94 c0             	sete   %al
  8041b4:	0f b6 c0             	movzbl %al,%eax
}
  8041b7:	c9                   	leaveq 
  8041b8:	c3                   	retq   

00000000008041b9 <opencons>:

int
opencons(void)
{
  8041b9:	55                   	push   %rbp
  8041ba:	48 89 e5             	mov    %rsp,%rbp
  8041bd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041c1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8041c5:	48 89 c7             	mov    %rax,%rdi
  8041c8:	48 b8 6a 26 80 00 00 	movabs $0x80266a,%rax
  8041cf:	00 00 00 
  8041d2:	ff d0                	callq  *%rax
  8041d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041db:	79 05                	jns    8041e2 <opencons+0x29>
		return r;
  8041dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e0:	eb 5b                	jmp    80423d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e6:	ba 07 04 00 00       	mov    $0x407,%edx
  8041eb:	48 89 c6             	mov    %rax,%rsi
  8041ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8041f3:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  8041fa:	00 00 00 
  8041fd:	ff d0                	callq  *%rax
  8041ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804202:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804206:	79 05                	jns    80420d <opencons+0x54>
		return r;
  804208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80420b:	eb 30                	jmp    80423d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80420d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804211:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804218:	00 00 00 
  80421b:	8b 12                	mov    (%rdx),%edx
  80421d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80421f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804223:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80422a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80422e:	48 89 c7             	mov    %rax,%rdi
  804231:	48 b8 1c 26 80 00 00 	movabs $0x80261c,%rax
  804238:	00 00 00 
  80423b:	ff d0                	callq  *%rax
}
  80423d:	c9                   	leaveq 
  80423e:	c3                   	retq   

000000000080423f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80423f:	55                   	push   %rbp
  804240:	48 89 e5             	mov    %rsp,%rbp
  804243:	48 83 ec 30          	sub    $0x30,%rsp
  804247:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80424b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80424f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804253:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804258:	75 13                	jne    80426d <devcons_read+0x2e>
		return 0;
  80425a:	b8 00 00 00 00       	mov    $0x0,%eax
  80425f:	eb 49                	jmp    8042aa <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804261:	48 b8 da 1b 80 00 00 	movabs $0x801bda,%rax
  804268:	00 00 00 
  80426b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80426d:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  804274:	00 00 00 
  804277:	ff d0                	callq  *%rax
  804279:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80427c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804280:	74 df                	je     804261 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804282:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804286:	79 05                	jns    80428d <devcons_read+0x4e>
		return c;
  804288:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80428b:	eb 1d                	jmp    8042aa <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80428d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804291:	75 07                	jne    80429a <devcons_read+0x5b>
		return 0;
  804293:	b8 00 00 00 00       	mov    $0x0,%eax
  804298:	eb 10                	jmp    8042aa <devcons_read+0x6b>
	*(char*)vbuf = c;
  80429a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80429d:	89 c2                	mov    %eax,%edx
  80429f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042a3:	88 10                	mov    %dl,(%rax)
	return 1;
  8042a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8042aa:	c9                   	leaveq 
  8042ab:	c3                   	retq   

00000000008042ac <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042ac:	55                   	push   %rbp
  8042ad:	48 89 e5             	mov    %rsp,%rbp
  8042b0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8042b7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8042be:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8042c5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042d3:	eb 77                	jmp    80434c <devcons_write+0xa0>
		m = n - tot;
  8042d5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8042dc:	89 c2                	mov    %eax,%edx
  8042de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e1:	89 d1                	mov    %edx,%ecx
  8042e3:	29 c1                	sub    %eax,%ecx
  8042e5:	89 c8                	mov    %ecx,%eax
  8042e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8042ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042ed:	83 f8 7f             	cmp    $0x7f,%eax
  8042f0:	76 07                	jbe    8042f9 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8042f2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8042f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042fc:	48 63 d0             	movslq %eax,%rdx
  8042ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804302:	48 98                	cltq   
  804304:	48 89 c1             	mov    %rax,%rcx
  804307:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80430e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804315:	48 89 ce             	mov    %rcx,%rsi
  804318:	48 89 c7             	mov    %rax,%rdi
  80431b:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  804322:	00 00 00 
  804325:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804327:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80432a:	48 63 d0             	movslq %eax,%rdx
  80432d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804334:	48 89 d6             	mov    %rdx,%rsi
  804337:	48 89 c7             	mov    %rax,%rdi
  80433a:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  804341:	00 00 00 
  804344:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804346:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804349:	01 45 fc             	add    %eax,-0x4(%rbp)
  80434c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80434f:	48 98                	cltq   
  804351:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804358:	0f 82 77 ff ff ff    	jb     8042d5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80435e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804361:	c9                   	leaveq 
  804362:	c3                   	retq   

0000000000804363 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804363:	55                   	push   %rbp
  804364:	48 89 e5             	mov    %rsp,%rbp
  804367:	48 83 ec 08          	sub    $0x8,%rsp
  80436b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80436f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804374:	c9                   	leaveq 
  804375:	c3                   	retq   

0000000000804376 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804376:	55                   	push   %rbp
  804377:	48 89 e5             	mov    %rsp,%rbp
  80437a:	48 83 ec 10          	sub    $0x10,%rsp
  80437e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80438a:	48 be 48 50 80 00 00 	movabs $0x805048,%rsi
  804391:	00 00 00 
  804394:	48 89 c7             	mov    %rax,%rdi
  804397:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  80439e:	00 00 00 
  8043a1:	ff d0                	callq  *%rax
	return 0;
  8043a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043a8:	c9                   	leaveq 
  8043a9:	c3                   	retq   
	...

00000000008043ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8043ac:	55                   	push   %rbp
  8043ad:	48 89 e5             	mov    %rsp,%rbp
  8043b0:	48 83 ec 20          	sub    $0x20,%rsp
  8043b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  8043b8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043bf:	00 00 00 
  8043c2:	48 8b 00             	mov    (%rax),%rax
  8043c5:	48 85 c0             	test   %rax,%rax
  8043c8:	0f 85 8e 00 00 00    	jne    80445c <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  8043ce:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  8043d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  8043dc:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  8043e3:	00 00 00 
  8043e6:	ff d0                	callq  *%rax
  8043e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  8043eb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8043ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8043f7:	48 89 ce             	mov    %rcx,%rsi
  8043fa:	89 c7                	mov    %eax,%edi
  8043fc:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  804403:	00 00 00 
  804406:	ff d0                	callq  *%rax
  804408:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  80440b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80440f:	74 30                	je     804441 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  804411:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804414:	89 c1                	mov    %eax,%ecx
  804416:	48 ba 50 50 80 00 00 	movabs $0x805050,%rdx
  80441d:	00 00 00 
  804420:	be 24 00 00 00       	mov    $0x24,%esi
  804425:	48 bf 87 50 80 00 00 	movabs $0x805087,%rdi
  80442c:	00 00 00 
  80442f:	b8 00 00 00 00       	mov    $0x0,%eax
  804434:	49 b8 e8 04 80 00 00 	movabs $0x8004e8,%r8
  80443b:	00 00 00 
  80443e:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  804441:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804444:	48 be 70 44 80 00 00 	movabs $0x804470,%rsi
  80444b:	00 00 00 
  80444e:	89 c7                	mov    %eax,%edi
  804450:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  804457:	00 00 00 
  80445a:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80445c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804463:	00 00 00 
  804466:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80446a:	48 89 10             	mov    %rdx,(%rax)
}
  80446d:	c9                   	leaveq 
  80446e:	c3                   	retq   
	...

0000000000804470 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804470:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804473:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  80447a:	00 00 00 
	call *%rax
  80447d:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  80447f:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  804483:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  804487:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  80448a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804491:	00 
		movq 120(%rsp), %rcx				// trap time rip
  804492:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  804497:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  80449a:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  80449b:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  80449e:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8044a5:	00 08 
		POPA_						// copy the register contents to the registers
  8044a7:	4c 8b 3c 24          	mov    (%rsp),%r15
  8044ab:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8044b0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8044b5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8044ba:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8044bf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8044c4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8044c9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8044ce:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8044d3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8044d8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8044dd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8044e2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8044e7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8044ec:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8044f1:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  8044f5:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  8044f9:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  8044fa:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  8044fb:	c3                   	retq   

00000000008044fc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044fc:	55                   	push   %rbp
  8044fd:	48 89 e5             	mov    %rsp,%rbp
  804500:	48 83 ec 30          	sub    $0x30,%rsp
  804504:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804508:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80450c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  804510:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804515:	74 18                	je     80452f <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  804517:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80451b:	48 89 c7             	mov    %rax,%rdi
  80451e:	48 b8 41 1e 80 00 00 	movabs $0x801e41,%rax
  804525:	00 00 00 
  804528:	ff d0                	callq  *%rax
  80452a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80452d:	eb 19                	jmp    804548 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80452f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  804536:	00 00 00 
  804539:	48 b8 41 1e 80 00 00 	movabs $0x801e41,%rax
  804540:	00 00 00 
  804543:	ff d0                	callq  *%rax
  804545:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804548:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80454c:	79 19                	jns    804567 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  80454e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804552:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  804558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80455c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  804562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804565:	eb 53                	jmp    8045ba <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  804567:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80456c:	74 19                	je     804587 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  80456e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  804575:	00 00 00 
  804578:	48 8b 00             	mov    (%rax),%rax
  80457b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804585:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  804587:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80458c:	74 19                	je     8045a7 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  80458e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  804595:	00 00 00 
  804598:	48 8b 00             	mov    (%rax),%rax
  80459b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8045a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a5:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8045a7:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8045ae:	00 00 00 
  8045b1:	48 8b 00             	mov    (%rax),%rax
  8045b4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8045ba:	c9                   	leaveq 
  8045bb:	c3                   	retq   

00000000008045bc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8045bc:	55                   	push   %rbp
  8045bd:	48 89 e5             	mov    %rsp,%rbp
  8045c0:	48 83 ec 30          	sub    $0x30,%rsp
  8045c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8045ca:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8045ce:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8045d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  8045d8:	e9 96 00 00 00       	jmpq   804673 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  8045dd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045e2:	74 20                	je     804604 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8045e4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045e7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8045ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8045ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045f1:	89 c7                	mov    %eax,%edi
  8045f3:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  8045fa:	00 00 00 
  8045fd:	ff d0                	callq  *%rax
  8045ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804602:	eb 2d                	jmp    804631 <ipc_send+0x75>
		else if(pg==NULL)
  804604:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804609:	75 26                	jne    804631 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80460b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80460e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804611:	b9 00 00 00 00       	mov    $0x0,%ecx
  804616:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80461d:	00 00 00 
  804620:	89 c7                	mov    %eax,%edi
  804622:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  804629:	00 00 00 
  80462c:	ff d0                	callq  *%rax
  80462e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  804631:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804635:	79 30                	jns    804667 <ipc_send+0xab>
  804637:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80463b:	74 2a                	je     804667 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  80463d:	48 ba 95 50 80 00 00 	movabs $0x805095,%rdx
  804644:	00 00 00 
  804647:	be 40 00 00 00       	mov    $0x40,%esi
  80464c:	48 bf ad 50 80 00 00 	movabs $0x8050ad,%rdi
  804653:	00 00 00 
  804656:	b8 00 00 00 00       	mov    $0x0,%eax
  80465b:	48 b9 e8 04 80 00 00 	movabs $0x8004e8,%rcx
  804662:	00 00 00 
  804665:	ff d1                	callq  *%rcx
		}
		sys_yield();
  804667:	48 b8 da 1b 80 00 00 	movabs $0x801bda,%rax
  80466e:	00 00 00 
  804671:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  804673:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804677:	0f 85 60 ff ff ff    	jne    8045dd <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  80467d:	c9                   	leaveq 
  80467e:	c3                   	retq   

000000000080467f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80467f:	55                   	push   %rbp
  804680:	48 89 e5             	mov    %rsp,%rbp
  804683:	48 83 ec 18          	sub    $0x18,%rsp
  804687:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80468a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804691:	eb 5e                	jmp    8046f1 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804693:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80469a:	00 00 00 
  80469d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a0:	48 63 d0             	movslq %eax,%rdx
  8046a3:	48 89 d0             	mov    %rdx,%rax
  8046a6:	48 c1 e0 03          	shl    $0x3,%rax
  8046aa:	48 01 d0             	add    %rdx,%rax
  8046ad:	48 c1 e0 05          	shl    $0x5,%rax
  8046b1:	48 01 c8             	add    %rcx,%rax
  8046b4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8046ba:	8b 00                	mov    (%rax),%eax
  8046bc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8046bf:	75 2c                	jne    8046ed <ipc_find_env+0x6e>
			return envs[i].env_id;
  8046c1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8046c8:	00 00 00 
  8046cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ce:	48 63 d0             	movslq %eax,%rdx
  8046d1:	48 89 d0             	mov    %rdx,%rax
  8046d4:	48 c1 e0 03          	shl    $0x3,%rax
  8046d8:	48 01 d0             	add    %rdx,%rax
  8046db:	48 c1 e0 05          	shl    $0x5,%rax
  8046df:	48 01 c8             	add    %rcx,%rax
  8046e2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8046e8:	8b 40 08             	mov    0x8(%rax),%eax
  8046eb:	eb 12                	jmp    8046ff <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8046ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046f1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8046f8:	7e 99                	jle    804693 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8046fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046ff:	c9                   	leaveq 
  804700:	c3                   	retq   
  804701:	00 00                	add    %al,(%rax)
	...

0000000000804704 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804704:	55                   	push   %rbp
  804705:	48 89 e5             	mov    %rsp,%rbp
  804708:	48 83 ec 18          	sub    $0x18,%rsp
  80470c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804714:	48 89 c2             	mov    %rax,%rdx
  804717:	48 c1 ea 15          	shr    $0x15,%rdx
  80471b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804722:	01 00 00 
  804725:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804729:	83 e0 01             	and    $0x1,%eax
  80472c:	48 85 c0             	test   %rax,%rax
  80472f:	75 07                	jne    804738 <pageref+0x34>
		return 0;
  804731:	b8 00 00 00 00       	mov    $0x0,%eax
  804736:	eb 53                	jmp    80478b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80473c:	48 89 c2             	mov    %rax,%rdx
  80473f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804743:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80474a:	01 00 00 
  80474d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804751:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804759:	83 e0 01             	and    $0x1,%eax
  80475c:	48 85 c0             	test   %rax,%rax
  80475f:	75 07                	jne    804768 <pageref+0x64>
		return 0;
  804761:	b8 00 00 00 00       	mov    $0x0,%eax
  804766:	eb 23                	jmp    80478b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80476c:	48 89 c2             	mov    %rax,%rdx
  80476f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804773:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80477a:	00 00 00 
  80477d:	48 c1 e2 04          	shl    $0x4,%rdx
  804781:	48 01 d0             	add    %rdx,%rax
  804784:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804788:	0f b7 c0             	movzwl %ax,%eax
}
  80478b:	c9                   	leaveq 
  80478c:	c3                   	retq   
