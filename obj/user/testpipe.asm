
obj/user/testpipe.debug:     file format elf64-x86-64


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
  80003c:	e8 c7 04 00 00       	callq  800508 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  80004f:	89 bd 7c ff ff ff    	mov    %edi,-0x84(%rbp)
  800055:	48 89 b5 70 ff ff ff 	mov    %rsi,-0x90(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800063:	00 00 00 
  800066:	48 ba 64 49 80 00 00 	movabs $0x804964,%rdx
  80006d:	00 00 00 
  800070:	48 89 10             	mov    %rdx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800077:	48 89 c7             	mov    %rax,%rdi
  80007a:	48 b8 18 3c 80 00 00 	movabs $0x803c18,%rax
  800081:	00 00 00 
  800084:	ff d0                	callq  *%rax
  800086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80008d:	79 30                	jns    8000bf <umain+0x7b>
		panic("pipe: %e", i);
  80008f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800092:	89 c1                	mov    %eax,%ecx
  800094:	48 ba 70 49 80 00 00 	movabs $0x804970,%rdx
  80009b:	00 00 00 
  80009e:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a3:	48 bf 79 49 80 00 00 	movabs $0x804979,%rdi
  8000aa:	00 00 00 
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8000b9:	00 00 00 
  8000bc:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000bf:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  8000c6:	00 00 00 
  8000c9:	ff d0                	callq  *%rax
  8000cb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ce:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d2:	79 30                	jns    800104 <umain+0xc0>
		panic("fork: %e", i);
  8000d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d7:	89 c1                	mov    %eax,%ecx
  8000d9:	48 ba 89 49 80 00 00 	movabs $0x804989,%rdx
  8000e0:	00 00 00 
  8000e3:	be 11 00 00 00       	mov    $0x11,%esi
  8000e8:	48 bf 79 49 80 00 00 	movabs $0x804979,%rdi
  8000ef:	00 00 00 
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8000fe:	00 00 00 
  800101:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800104:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800108:	0f 85 50 01 00 00    	jne    80025e <umain+0x21a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  80010e:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800111:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  800118:	00 00 00 
  80011b:	48 8b 00             	mov    (%rax),%rax
  80011e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800124:	89 c6                	mov    %eax,%esi
  800126:	48 bf 92 49 80 00 00 	movabs $0x804992,%rdi
  80012d:	00 00 00 
  800130:	b8 00 00 00 00       	mov    $0x0,%eax
  800135:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  80013c:	00 00 00 
  80013f:	ff d1                	callq  *%rcx
		close(p[1]);
  800141:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800144:	89 c7                	mov    %eax,%edi
  800146:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  80014d:	00 00 00 
  800150:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800152:	8b 55 80             	mov    -0x80(%rbp),%edx
  800155:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  80015c:	00 00 00 
  80015f:	48 8b 00             	mov    (%rax),%rax
  800162:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800168:	89 c6                	mov    %eax,%esi
  80016a:	48 bf af 49 80 00 00 	movabs $0x8049af,%rdi
  800171:	00 00 00 
  800174:	b8 00 00 00 00       	mov    $0x0,%eax
  800179:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  800180:	00 00 00 
  800183:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800185:	8b 45 80             	mov    -0x80(%rbp),%eax
  800188:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  80018c:	ba 63 00 00 00       	mov    $0x63,%edx
  800191:	48 89 ce             	mov    %rcx,%rsi
  800194:	89 c7                	mov    %eax,%edi
  800196:	48 b8 f5 2c 80 00 00 	movabs $0x802cf5,%rax
  80019d:	00 00 00 
  8001a0:	ff d0                	callq  *%rax
  8001a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (i < 0)
  8001a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a9:	79 30                	jns    8001db <umain+0x197>
			panic("read: %e", i);
  8001ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ae:	89 c1                	mov    %eax,%ecx
  8001b0:	48 ba cc 49 80 00 00 	movabs $0x8049cc,%rdx
  8001b7:	00 00 00 
  8001ba:	be 19 00 00 00       	mov    $0x19,%esi
  8001bf:	48 bf 79 49 80 00 00 	movabs $0x804979,%rdi
  8001c6:	00 00 00 
  8001c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ce:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8001d5:	00 00 00 
  8001d8:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001de:	48 98                	cltq   
  8001e0:	c6 44 05 90 00       	movb   $0x0,-0x70(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001e5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001ec:	00 00 00 
  8001ef:	48 8b 10             	mov    (%rax),%rdx
  8001f2:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8001f6:	48 89 d6             	mov    %rdx,%rsi
  8001f9:	48 89 c7             	mov    %rax,%rdi
  8001fc:	48 b8 23 15 80 00 00 	movabs $0x801523,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	85 c0                	test   %eax,%eax
  80020a:	75 1d                	jne    800229 <umain+0x1e5>
			cprintf("\npipe read closed properly\n");
  80020c:	48 bf d5 49 80 00 00 	movabs $0x8049d5,%rdi
  800213:	00 00 00 
  800216:	b8 00 00 00 00       	mov    $0x0,%eax
  80021b:	48 ba 0b 08 80 00 00 	movabs $0x80080b,%rdx
  800222:	00 00 00 
  800225:	ff d2                	callq  *%rdx
  800227:	eb 24                	jmp    80024d <umain+0x209>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800229:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  80022d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800230:	89 c6                	mov    %eax,%esi
  800232:	48 bf f1 49 80 00 00 	movabs $0x8049f1,%rdi
  800239:	00 00 00 
  80023c:	b8 00 00 00 00       	mov    $0x0,%eax
  800241:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  800248:	00 00 00 
  80024b:	ff d1                	callq  *%rcx
		exit();
  80024d:	48 b8 ac 05 80 00 00 	movabs $0x8005ac,%rax
  800254:	00 00 00 
  800257:	ff d0                	callq  *%rax
  800259:	e9 1c 01 00 00       	jmpq   80037a <umain+0x336>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80025e:	8b 55 80             	mov    -0x80(%rbp),%edx
  800261:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  800268:	00 00 00 
  80026b:	48 8b 00             	mov    (%rax),%rax
  80026e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800274:	89 c6                	mov    %eax,%esi
  800276:	48 bf 92 49 80 00 00 	movabs $0x804992,%rdi
  80027d:	00 00 00 
  800280:	b8 00 00 00 00       	mov    $0x0,%eax
  800285:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  80028c:	00 00 00 
  80028f:	ff d1                	callq  *%rcx
		close(p[0]);
  800291:	8b 45 80             	mov    -0x80(%rbp),%eax
  800294:	89 c7                	mov    %eax,%edi
  800296:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  80029d:	00 00 00 
  8002a0:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002a2:	8b 55 84             	mov    -0x7c(%rbp),%edx
  8002a5:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  8002ac:	00 00 00 
  8002af:	48 8b 00             	mov    (%rax),%rax
  8002b2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002b8:	89 c6                	mov    %eax,%esi
  8002ba:	48 bf 04 4a 80 00 00 	movabs $0x804a04,%rdi
  8002c1:	00 00 00 
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c9:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  8002d0:	00 00 00 
  8002d3:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002dc:	00 00 00 
  8002df:	48 8b 00             	mov    (%rax),%rax
  8002e2:	48 89 c7             	mov    %rax,%rdi
  8002e5:	48 b8 5c 13 80 00 00 	movabs $0x80135c,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	callq  *%rax
  8002f1:	48 63 d0             	movslq %eax,%rdx
  8002f4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002fb:	00 00 00 
  8002fe:	48 8b 08             	mov    (%rax),%rcx
  800301:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800304:	48 89 ce             	mov    %rcx,%rsi
  800307:	89 c7                	mov    %eax,%edi
  800309:	48 b8 6a 2d 80 00 00 	movabs $0x802d6a,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
  800315:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800318:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80031f:	00 00 00 
  800322:	48 8b 00             	mov    (%rax),%rax
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	48 b8 5c 13 80 00 00 	movabs $0x80135c,%rax
  80032f:	00 00 00 
  800332:	ff d0                	callq  *%rax
  800334:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800337:	74 30                	je     800369 <umain+0x325>
			panic("write: %e", i);
  800339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033c:	89 c1                	mov    %eax,%ecx
  80033e:	48 ba 21 4a 80 00 00 	movabs $0x804a21,%rdx
  800345:	00 00 00 
  800348:	be 25 00 00 00       	mov    $0x25,%esi
  80034d:	48 bf 79 49 80 00 00 	movabs $0x804979,%rdi
  800354:	00 00 00 
  800357:	b8 00 00 00 00       	mov    $0x0,%eax
  80035c:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  800363:	00 00 00 
  800366:	41 ff d0             	callq  *%r8
		close(p[1]);
  800369:	8b 45 84             	mov    -0x7c(%rbp),%eax
  80036c:	89 c7                	mov    %eax,%edi
  80036e:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
	}
	wait(pid);
  80037a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037d:	89 c7                	mov    %eax,%edi
  80037f:	48 b8 e0 41 80 00 00 	movabs $0x8041e0,%rax
  800386:	00 00 00 
  800389:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  80038b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800392:	00 00 00 
  800395:	48 ba 2b 4a 80 00 00 	movabs $0x804a2b,%rdx
  80039c:	00 00 00 
  80039f:	48 89 10             	mov    %rdx,(%rax)
	if ((i = pipe(p)) < 0)
  8003a2:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003a6:	48 89 c7             	mov    %rax,%rdi
  8003a9:	48 b8 18 3c 80 00 00 	movabs $0x803c18,%rax
  8003b0:	00 00 00 
  8003b3:	ff d0                	callq  *%rax
  8003b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8003b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003bc:	79 30                	jns    8003ee <umain+0x3aa>
		panic("pipe: %e", i);
  8003be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c1:	89 c1                	mov    %eax,%ecx
  8003c3:	48 ba 70 49 80 00 00 	movabs $0x804970,%rdx
  8003ca:	00 00 00 
  8003cd:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003d2:	48 bf 79 49 80 00 00 	movabs $0x804979,%rdi
  8003d9:	00 00 00 
  8003dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e1:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8003e8:	00 00 00 
  8003eb:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8003ee:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax
  8003fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800401:	79 30                	jns    800433 <umain+0x3ef>
		panic("fork: %e", i);
  800403:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800406:	89 c1                	mov    %eax,%ecx
  800408:	48 ba 89 49 80 00 00 	movabs $0x804989,%rdx
  80040f:	00 00 00 
  800412:	be 2f 00 00 00       	mov    $0x2f,%esi
  800417:	48 bf 79 49 80 00 00 	movabs $0x804979,%rdi
  80041e:	00 00 00 
  800421:	b8 00 00 00 00       	mov    $0x0,%eax
  800426:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  80042d:	00 00 00 
  800430:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800433:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800437:	75 7c                	jne    8004b5 <umain+0x471>
		close(p[0]);
  800439:	8b 45 80             	mov    -0x80(%rbp),%eax
  80043c:	89 c7                	mov    %eax,%edi
  80043e:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  800445:	00 00 00 
  800448:	ff d0                	callq  *%rax
  80044a:	eb 01                	jmp    80044d <umain+0x409>
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
		}
  80044c:	90                   	nop
		panic("fork: %e", i);

	if (pid == 0) {
		close(p[0]);
		while (1) {
			cprintf(".");
  80044d:	48 bf 38 4a 80 00 00 	movabs $0x804a38,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	48 ba 0b 08 80 00 00 	movabs $0x80080b,%rdx
  800463:	00 00 00 
  800466:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  800468:	8b 45 84             	mov    -0x7c(%rbp),%eax
  80046b:	ba 01 00 00 00       	mov    $0x1,%edx
  800470:	48 be 3a 4a 80 00 00 	movabs $0x804a3a,%rsi
  800477:	00 00 00 
  80047a:	89 c7                	mov    %eax,%edi
  80047c:	48 b8 6a 2d 80 00 00 	movabs $0x802d6a,%rax
  800483:	00 00 00 
  800486:	ff d0                	callq  *%rax
  800488:	83 f8 01             	cmp    $0x1,%eax
  80048b:	74 bf                	je     80044c <umain+0x408>
				break;
  80048d:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  80048e:	48 bf 3c 4a 80 00 00 	movabs $0x804a3c,%rdi
  800495:	00 00 00 
  800498:	b8 00 00 00 00       	mov    $0x0,%eax
  80049d:	48 ba 0b 08 80 00 00 	movabs $0x80080b,%rdx
  8004a4:	00 00 00 
  8004a7:	ff d2                	callq  *%rdx
		exit();
  8004a9:	48 b8 ac 05 80 00 00 	movabs $0x8005ac,%rax
  8004b0:	00 00 00 
  8004b3:	ff d0                	callq  *%rax
	}
	close(p[0]);
  8004b5:	8b 45 80             	mov    -0x80(%rbp),%eax
  8004b8:	89 c7                	mov    %eax,%edi
  8004ba:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
	close(p[1]);
  8004c6:	8b 45 84             	mov    -0x7c(%rbp),%eax
  8004c9:	89 c7                	mov    %eax,%edi
  8004cb:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  8004d2:	00 00 00 
  8004d5:	ff d0                	callq  *%rax
	wait(pid);
  8004d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	48 b8 e0 41 80 00 00 	movabs $0x8041e0,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  8004e8:	48 bf 59 4a 80 00 00 	movabs $0x804a59,%rdi
  8004ef:	00 00 00 
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	48 ba 0b 08 80 00 00 	movabs $0x80080b,%rdx
  8004fe:	00 00 00 
  800501:	ff d2                	callq  *%rdx
}
  800503:	c9                   	leaveq 
  800504:	c3                   	retq   
  800505:	00 00                	add    %al,(%rax)
	...

0000000000800508 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800508:	55                   	push   %rbp
  800509:	48 89 e5             	mov    %rsp,%rbp
  80050c:	48 83 ec 10          	sub    $0x10,%rsp
  800510:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800513:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800517:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  80051e:	00 00 00 
  800521:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800528:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
  800534:	48 98                	cltq   
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80053f:	48 89 d0             	mov    %rdx,%rax
  800542:	48 c1 e0 03          	shl    $0x3,%rax
  800546:	48 01 d0             	add    %rdx,%rax
  800549:	48 c1 e0 05          	shl    $0x5,%rax
  80054d:	48 89 c2             	mov    %rax,%rdx
  800550:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800557:	00 00 00 
  80055a:	48 01 c2             	add    %rax,%rdx
  80055d:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  800564:	00 00 00 
  800567:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80056a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80056e:	7e 14                	jle    800584 <libmain+0x7c>
		binaryname = argv[0];
  800570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800574:	48 8b 10             	mov    (%rax),%rdx
  800577:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80057e:	00 00 00 
  800581:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800584:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058b:	48 89 d6             	mov    %rdx,%rsi
  80058e:	89 c7                	mov    %eax,%edi
  800590:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800597:	00 00 00 
  80059a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80059c:	48 b8 ac 05 80 00 00 	movabs $0x8005ac,%rax
  8005a3:	00 00 00 
  8005a6:	ff d0                	callq  *%rax
}
  8005a8:	c9                   	leaveq 
  8005a9:	c3                   	retq   
	...

00000000008005ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ac:	55                   	push   %rbp
  8005ad:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005b0:	48 b8 45 2a 80 00 00 	movabs $0x802a45,%rax
  8005b7:	00 00 00 
  8005ba:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c1:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  8005c8:	00 00 00 
  8005cb:	ff d0                	callq  *%rax
}
  8005cd:	5d                   	pop    %rbp
  8005ce:	c3                   	retq   
	...

00000000008005d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005d0:	55                   	push   %rbp
  8005d1:	48 89 e5             	mov    %rsp,%rbp
  8005d4:	53                   	push   %rbx
  8005d5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005dc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005e3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005e9:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005f0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005f7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005fe:	84 c0                	test   %al,%al
  800600:	74 23                	je     800625 <_panic+0x55>
  800602:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800609:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80060d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800611:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800615:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800619:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80061d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800621:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800625:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80062c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800633:	00 00 00 
  800636:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80063d:	00 00 00 
  800640:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800644:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80064b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800652:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800659:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800660:	00 00 00 
  800663:	48 8b 18             	mov    (%rax),%rbx
  800666:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  80066d:	00 00 00 
  800670:	ff d0                	callq  *%rax
  800672:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800678:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80067f:	41 89 c8             	mov    %ecx,%r8d
  800682:	48 89 d1             	mov    %rdx,%rcx
  800685:	48 89 da             	mov    %rbx,%rdx
  800688:	89 c6                	mov    %eax,%esi
  80068a:	48 bf 78 4a 80 00 00 	movabs $0x804a78,%rdi
  800691:	00 00 00 
  800694:	b8 00 00 00 00       	mov    $0x0,%eax
  800699:	49 b9 0b 08 80 00 00 	movabs $0x80080b,%r9
  8006a0:	00 00 00 
  8006a3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006a6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006ad:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006b4:	48 89 d6             	mov    %rdx,%rsi
  8006b7:	48 89 c7             	mov    %rax,%rdi
  8006ba:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  8006c1:	00 00 00 
  8006c4:	ff d0                	callq  *%rax
	cprintf("\n");
  8006c6:	48 bf 9b 4a 80 00 00 	movabs $0x804a9b,%rdi
  8006cd:	00 00 00 
  8006d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d5:	48 ba 0b 08 80 00 00 	movabs $0x80080b,%rdx
  8006dc:	00 00 00 
  8006df:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006e1:	cc                   	int3   
  8006e2:	eb fd                	jmp    8006e1 <_panic+0x111>

00000000008006e4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006e4:	55                   	push   %rbp
  8006e5:	48 89 e5             	mov    %rsp,%rbp
  8006e8:	48 83 ec 10          	sub    $0x10,%rsp
  8006ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8006f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f7:	8b 00                	mov    (%rax),%eax
  8006f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006fc:	89 d6                	mov    %edx,%esi
  8006fe:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800702:	48 63 d0             	movslq %eax,%rdx
  800705:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80070a:	8d 50 01             	lea    0x1(%rax),%edx
  80070d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800711:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800717:	8b 00                	mov    (%rax),%eax
  800719:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071e:	75 2c                	jne    80074c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800724:	8b 00                	mov    (%rax),%eax
  800726:	48 98                	cltq   
  800728:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80072c:	48 83 c2 08          	add    $0x8,%rdx
  800730:	48 89 c6             	mov    %rax,%rsi
  800733:	48 89 d7             	mov    %rdx,%rdi
  800736:	48 b8 b8 1b 80 00 00 	movabs $0x801bb8,%rax
  80073d:	00 00 00 
  800740:	ff d0                	callq  *%rax
		b->idx = 0;
  800742:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800746:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80074c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800750:	8b 40 04             	mov    0x4(%rax),%eax
  800753:	8d 50 01             	lea    0x1(%rax),%edx
  800756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80075a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80075d:	c9                   	leaveq 
  80075e:	c3                   	retq   

000000000080075f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80075f:	55                   	push   %rbp
  800760:	48 89 e5             	mov    %rsp,%rbp
  800763:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80076a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800771:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800778:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80077f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800786:	48 8b 0a             	mov    (%rdx),%rcx
  800789:	48 89 08             	mov    %rcx,(%rax)
  80078c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800790:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800794:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800798:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80079c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007a3:	00 00 00 
	b.cnt = 0;
  8007a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007ad:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8007b0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007b7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007be:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007c5:	48 89 c6             	mov    %rax,%rsi
  8007c8:	48 bf e4 06 80 00 00 	movabs $0x8006e4,%rdi
  8007cf:	00 00 00 
  8007d2:	48 b8 bc 0b 80 00 00 	movabs $0x800bbc,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8007de:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007e4:	48 98                	cltq   
  8007e6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007ed:	48 83 c2 08          	add    $0x8,%rdx
  8007f1:	48 89 c6             	mov    %rax,%rsi
  8007f4:	48 89 d7             	mov    %rdx,%rdi
  8007f7:	48 b8 b8 1b 80 00 00 	movabs $0x801bb8,%rax
  8007fe:	00 00 00 
  800801:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800803:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800809:	c9                   	leaveq 
  80080a:	c3                   	retq   

000000000080080b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80080b:	55                   	push   %rbp
  80080c:	48 89 e5             	mov    %rsp,%rbp
  80080f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800816:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80081d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800824:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80082b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800832:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800839:	84 c0                	test   %al,%al
  80083b:	74 20                	je     80085d <cprintf+0x52>
  80083d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800841:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800845:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800849:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80084d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800851:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800855:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800859:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80085d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800864:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80086b:	00 00 00 
  80086e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800875:	00 00 00 
  800878:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80087c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800883:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80088a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800891:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800898:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80089f:	48 8b 0a             	mov    (%rdx),%rcx
  8008a2:	48 89 08             	mov    %rcx,(%rax)
  8008a5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ad:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008b1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8008b5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008bc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008c3:	48 89 d6             	mov    %rdx,%rsi
  8008c6:	48 89 c7             	mov    %rax,%rdi
  8008c9:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  8008d0:	00 00 00 
  8008d3:	ff d0                	callq  *%rax
  8008d5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8008db:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008e1:	c9                   	leaveq 
  8008e2:	c3                   	retq   
	...

00000000008008e4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008e4:	55                   	push   %rbp
  8008e5:	48 89 e5             	mov    %rsp,%rbp
  8008e8:	48 83 ec 30          	sub    $0x30,%rsp
  8008ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8008f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8008f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008f8:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8008fb:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8008ff:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800903:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800906:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80090a:	77 52                	ja     80095e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80090c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80090f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800913:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800916:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80091a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091e:	ba 00 00 00 00       	mov    $0x0,%edx
  800923:	48 f7 75 d0          	divq   -0x30(%rbp)
  800927:	48 89 c2             	mov    %rax,%rdx
  80092a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80092d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800930:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800938:	41 89 f9             	mov    %edi,%r9d
  80093b:	48 89 c7             	mov    %rax,%rdi
  80093e:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  800945:	00 00 00 
  800948:	ff d0                	callq  *%rax
  80094a:	eb 1c                	jmp    800968 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80094c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800950:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800953:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800957:	48 89 d6             	mov    %rdx,%rsi
  80095a:	89 c7                	mov    %eax,%edi
  80095c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80095e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800962:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800966:	7f e4                	jg     80094c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800968:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80096b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096f:	ba 00 00 00 00       	mov    $0x0,%edx
  800974:	48 f7 f1             	div    %rcx
  800977:	48 89 d0             	mov    %rdx,%rax
  80097a:	48 ba 68 4c 80 00 00 	movabs $0x804c68,%rdx
  800981:	00 00 00 
  800984:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800988:	0f be c0             	movsbl %al,%eax
  80098b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80098f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800993:	48 89 d6             	mov    %rdx,%rsi
  800996:	89 c7                	mov    %eax,%edi
  800998:	ff d1                	callq  *%rcx
}
  80099a:	c9                   	leaveq 
  80099b:	c3                   	retq   

000000000080099c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80099c:	55                   	push   %rbp
  80099d:	48 89 e5             	mov    %rsp,%rbp
  8009a0:	48 83 ec 20          	sub    $0x20,%rsp
  8009a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009a8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009ab:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009af:	7e 52                	jle    800a03 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b5:	8b 00                	mov    (%rax),%eax
  8009b7:	83 f8 30             	cmp    $0x30,%eax
  8009ba:	73 24                	jae    8009e0 <getuint+0x44>
  8009bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c8:	8b 00                	mov    (%rax),%eax
  8009ca:	89 c0                	mov    %eax,%eax
  8009cc:	48 01 d0             	add    %rdx,%rax
  8009cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d3:	8b 12                	mov    (%rdx),%edx
  8009d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009dc:	89 0a                	mov    %ecx,(%rdx)
  8009de:	eb 17                	jmp    8009f7 <getuint+0x5b>
  8009e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e8:	48 89 d0             	mov    %rdx,%rax
  8009eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f7:	48 8b 00             	mov    (%rax),%rax
  8009fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009fe:	e9 a3 00 00 00       	jmpq   800aa6 <getuint+0x10a>
	else if (lflag)
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a07:	74 4f                	je     800a58 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0d:	8b 00                	mov    (%rax),%eax
  800a0f:	83 f8 30             	cmp    $0x30,%eax
  800a12:	73 24                	jae    800a38 <getuint+0x9c>
  800a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a18:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a20:	8b 00                	mov    (%rax),%eax
  800a22:	89 c0                	mov    %eax,%eax
  800a24:	48 01 d0             	add    %rdx,%rax
  800a27:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2b:	8b 12                	mov    (%rdx),%edx
  800a2d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a34:	89 0a                	mov    %ecx,(%rdx)
  800a36:	eb 17                	jmp    800a4f <getuint+0xb3>
  800a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a40:	48 89 d0             	mov    %rdx,%rax
  800a43:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4f:	48 8b 00             	mov    (%rax),%rax
  800a52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a56:	eb 4e                	jmp    800aa6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5c:	8b 00                	mov    (%rax),%eax
  800a5e:	83 f8 30             	cmp    $0x30,%eax
  800a61:	73 24                	jae    800a87 <getuint+0xeb>
  800a63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a67:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6f:	8b 00                	mov    (%rax),%eax
  800a71:	89 c0                	mov    %eax,%eax
  800a73:	48 01 d0             	add    %rdx,%rax
  800a76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7a:	8b 12                	mov    (%rdx),%edx
  800a7c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a83:	89 0a                	mov    %ecx,(%rdx)
  800a85:	eb 17                	jmp    800a9e <getuint+0x102>
  800a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a8f:	48 89 d0             	mov    %rdx,%rax
  800a92:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a9e:	8b 00                	mov    (%rax),%eax
  800aa0:	89 c0                	mov    %eax,%eax
  800aa2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aaa:	c9                   	leaveq 
  800aab:	c3                   	retq   

0000000000800aac <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aac:	55                   	push   %rbp
  800aad:	48 89 e5             	mov    %rsp,%rbp
  800ab0:	48 83 ec 20          	sub    $0x20,%rsp
  800ab4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ab8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800abb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800abf:	7e 52                	jle    800b13 <getint+0x67>
		x=va_arg(*ap, long long);
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	8b 00                	mov    (%rax),%eax
  800ac7:	83 f8 30             	cmp    $0x30,%eax
  800aca:	73 24                	jae    800af0 <getint+0x44>
  800acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad8:	8b 00                	mov    (%rax),%eax
  800ada:	89 c0                	mov    %eax,%eax
  800adc:	48 01 d0             	add    %rdx,%rax
  800adf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae3:	8b 12                	mov    (%rdx),%edx
  800ae5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aec:	89 0a                	mov    %ecx,(%rdx)
  800aee:	eb 17                	jmp    800b07 <getint+0x5b>
  800af0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af8:	48 89 d0             	mov    %rdx,%rax
  800afb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b03:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b07:	48 8b 00             	mov    (%rax),%rax
  800b0a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b0e:	e9 a3 00 00 00       	jmpq   800bb6 <getint+0x10a>
	else if (lflag)
  800b13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b17:	74 4f                	je     800b68 <getint+0xbc>
		x=va_arg(*ap, long);
  800b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1d:	8b 00                	mov    (%rax),%eax
  800b1f:	83 f8 30             	cmp    $0x30,%eax
  800b22:	73 24                	jae    800b48 <getint+0x9c>
  800b24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b28:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b30:	8b 00                	mov    (%rax),%eax
  800b32:	89 c0                	mov    %eax,%eax
  800b34:	48 01 d0             	add    %rdx,%rax
  800b37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3b:	8b 12                	mov    (%rdx),%edx
  800b3d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b44:	89 0a                	mov    %ecx,(%rdx)
  800b46:	eb 17                	jmp    800b5f <getint+0xb3>
  800b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b50:	48 89 d0             	mov    %rdx,%rax
  800b53:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b5f:	48 8b 00             	mov    (%rax),%rax
  800b62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b66:	eb 4e                	jmp    800bb6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6c:	8b 00                	mov    (%rax),%eax
  800b6e:	83 f8 30             	cmp    $0x30,%eax
  800b71:	73 24                	jae    800b97 <getint+0xeb>
  800b73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b77:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7f:	8b 00                	mov    (%rax),%eax
  800b81:	89 c0                	mov    %eax,%eax
  800b83:	48 01 d0             	add    %rdx,%rax
  800b86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b8a:	8b 12                	mov    (%rdx),%edx
  800b8c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b93:	89 0a                	mov    %ecx,(%rdx)
  800b95:	eb 17                	jmp    800bae <getint+0x102>
  800b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b9f:	48 89 d0             	mov    %rdx,%rax
  800ba2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ba6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800baa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bae:	8b 00                	mov    (%rax),%eax
  800bb0:	48 98                	cltq   
  800bb2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bba:	c9                   	leaveq 
  800bbb:	c3                   	retq   

0000000000800bbc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bbc:	55                   	push   %rbp
  800bbd:	48 89 e5             	mov    %rsp,%rbp
  800bc0:	41 54                	push   %r12
  800bc2:	53                   	push   %rbx
  800bc3:	48 83 ec 60          	sub    $0x60,%rsp
  800bc7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bcb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bcf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bd3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bd7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bdf:	48 8b 0a             	mov    (%rdx),%rcx
  800be2:	48 89 08             	mov    %rcx,(%rax)
  800be5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800be9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bf1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf5:	eb 17                	jmp    800c0e <vprintfmt+0x52>
			if (ch == '\0')
  800bf7:	85 db                	test   %ebx,%ebx
  800bf9:	0f 84 d7 04 00 00    	je     8010d6 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800bff:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c03:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c07:	48 89 c6             	mov    %rax,%rsi
  800c0a:	89 df                	mov    %ebx,%edi
  800c0c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c0e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c12:	0f b6 00             	movzbl (%rax),%eax
  800c15:	0f b6 d8             	movzbl %al,%ebx
  800c18:	83 fb 25             	cmp    $0x25,%ebx
  800c1b:	0f 95 c0             	setne  %al
  800c1e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c23:	84 c0                	test   %al,%al
  800c25:	75 d0                	jne    800bf7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c27:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c2b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c32:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c39:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c40:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800c47:	eb 04                	jmp    800c4d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800c49:	90                   	nop
  800c4a:	eb 01                	jmp    800c4d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800c4c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c4d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c51:	0f b6 00             	movzbl (%rax),%eax
  800c54:	0f b6 d8             	movzbl %al,%ebx
  800c57:	89 d8                	mov    %ebx,%eax
  800c59:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c5e:	83 e8 23             	sub    $0x23,%eax
  800c61:	83 f8 55             	cmp    $0x55,%eax
  800c64:	0f 87 38 04 00 00    	ja     8010a2 <vprintfmt+0x4e6>
  800c6a:	89 c0                	mov    %eax,%eax
  800c6c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c73:	00 
  800c74:	48 b8 90 4c 80 00 00 	movabs $0x804c90,%rax
  800c7b:	00 00 00 
  800c7e:	48 01 d0             	add    %rdx,%rax
  800c81:	48 8b 00             	mov    (%rax),%rax
  800c84:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c86:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c8a:	eb c1                	jmp    800c4d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c90:	eb bb                	jmp    800c4d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c92:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c99:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c9c:	89 d0                	mov    %edx,%eax
  800c9e:	c1 e0 02             	shl    $0x2,%eax
  800ca1:	01 d0                	add    %edx,%eax
  800ca3:	01 c0                	add    %eax,%eax
  800ca5:	01 d8                	add    %ebx,%eax
  800ca7:	83 e8 30             	sub    $0x30,%eax
  800caa:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cb1:	0f b6 00             	movzbl (%rax),%eax
  800cb4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb7:	83 fb 2f             	cmp    $0x2f,%ebx
  800cba:	7e 63                	jle    800d1f <vprintfmt+0x163>
  800cbc:	83 fb 39             	cmp    $0x39,%ebx
  800cbf:	7f 5e                	jg     800d1f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc6:	eb d1                	jmp    800c99 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800cc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccb:	83 f8 30             	cmp    $0x30,%eax
  800cce:	73 17                	jae    800ce7 <vprintfmt+0x12b>
  800cd0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd7:	89 c0                	mov    %eax,%eax
  800cd9:	48 01 d0             	add    %rdx,%rax
  800cdc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cdf:	83 c2 08             	add    $0x8,%edx
  800ce2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce5:	eb 0f                	jmp    800cf6 <vprintfmt+0x13a>
  800ce7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ceb:	48 89 d0             	mov    %rdx,%rax
  800cee:	48 83 c2 08          	add    $0x8,%rdx
  800cf2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf6:	8b 00                	mov    (%rax),%eax
  800cf8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800cfd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d01:	0f 89 42 ff ff ff    	jns    800c49 <vprintfmt+0x8d>
				width = 0;
  800d07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d0e:	e9 36 ff ff ff       	jmpq   800c49 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800d13:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d1a:	e9 2e ff ff ff       	jmpq   800c4d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d1f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d20:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d24:	0f 89 22 ff ff ff    	jns    800c4c <vprintfmt+0x90>
				width = precision, precision = -1;
  800d2a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d2d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d30:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d37:	e9 10 ff ff ff       	jmpq   800c4c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d3c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d40:	e9 08 ff ff ff       	jmpq   800c4d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d48:	83 f8 30             	cmp    $0x30,%eax
  800d4b:	73 17                	jae    800d64 <vprintfmt+0x1a8>
  800d4d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d54:	89 c0                	mov    %eax,%eax
  800d56:	48 01 d0             	add    %rdx,%rax
  800d59:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d5c:	83 c2 08             	add    $0x8,%edx
  800d5f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d62:	eb 0f                	jmp    800d73 <vprintfmt+0x1b7>
  800d64:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d68:	48 89 d0             	mov    %rdx,%rax
  800d6b:	48 83 c2 08          	add    $0x8,%rdx
  800d6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d73:	8b 00                	mov    (%rax),%eax
  800d75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d79:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800d7d:	48 89 d6             	mov    %rdx,%rsi
  800d80:	89 c7                	mov    %eax,%edi
  800d82:	ff d1                	callq  *%rcx
			break;
  800d84:	e9 47 03 00 00       	jmpq   8010d0 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800d89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8c:	83 f8 30             	cmp    $0x30,%eax
  800d8f:	73 17                	jae    800da8 <vprintfmt+0x1ec>
  800d91:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d98:	89 c0                	mov    %eax,%eax
  800d9a:	48 01 d0             	add    %rdx,%rax
  800d9d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800da0:	83 c2 08             	add    $0x8,%edx
  800da3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da6:	eb 0f                	jmp    800db7 <vprintfmt+0x1fb>
  800da8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dac:	48 89 d0             	mov    %rdx,%rax
  800daf:	48 83 c2 08          	add    $0x8,%rdx
  800db3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800db9:	85 db                	test   %ebx,%ebx
  800dbb:	79 02                	jns    800dbf <vprintfmt+0x203>
				err = -err;
  800dbd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dbf:	83 fb 10             	cmp    $0x10,%ebx
  800dc2:	7f 16                	jg     800dda <vprintfmt+0x21e>
  800dc4:	48 b8 e0 4b 80 00 00 	movabs $0x804be0,%rax
  800dcb:	00 00 00 
  800dce:	48 63 d3             	movslq %ebx,%rdx
  800dd1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dd5:	4d 85 e4             	test   %r12,%r12
  800dd8:	75 2e                	jne    800e08 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800dda:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de2:	89 d9                	mov    %ebx,%ecx
  800de4:	48 ba 79 4c 80 00 00 	movabs $0x804c79,%rdx
  800deb:	00 00 00 
  800dee:	48 89 c7             	mov    %rax,%rdi
  800df1:	b8 00 00 00 00       	mov    $0x0,%eax
  800df6:	49 b8 e0 10 80 00 00 	movabs $0x8010e0,%r8
  800dfd:	00 00 00 
  800e00:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e03:	e9 c8 02 00 00       	jmpq   8010d0 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e08:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e10:	4c 89 e1             	mov    %r12,%rcx
  800e13:	48 ba 82 4c 80 00 00 	movabs $0x804c82,%rdx
  800e1a:	00 00 00 
  800e1d:	48 89 c7             	mov    %rax,%rdi
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
  800e25:	49 b8 e0 10 80 00 00 	movabs $0x8010e0,%r8
  800e2c:	00 00 00 
  800e2f:	41 ff d0             	callq  *%r8
			break;
  800e32:	e9 99 02 00 00       	jmpq   8010d0 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e3a:	83 f8 30             	cmp    $0x30,%eax
  800e3d:	73 17                	jae    800e56 <vprintfmt+0x29a>
  800e3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e46:	89 c0                	mov    %eax,%eax
  800e48:	48 01 d0             	add    %rdx,%rax
  800e4b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e4e:	83 c2 08             	add    $0x8,%edx
  800e51:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e54:	eb 0f                	jmp    800e65 <vprintfmt+0x2a9>
  800e56:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e5a:	48 89 d0             	mov    %rdx,%rax
  800e5d:	48 83 c2 08          	add    $0x8,%rdx
  800e61:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e65:	4c 8b 20             	mov    (%rax),%r12
  800e68:	4d 85 e4             	test   %r12,%r12
  800e6b:	75 0a                	jne    800e77 <vprintfmt+0x2bb>
				p = "(null)";
  800e6d:	49 bc 85 4c 80 00 00 	movabs $0x804c85,%r12
  800e74:	00 00 00 
			if (width > 0 && padc != '-')
  800e77:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e7b:	7e 7a                	jle    800ef7 <vprintfmt+0x33b>
  800e7d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e81:	74 74                	je     800ef7 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e83:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e86:	48 98                	cltq   
  800e88:	48 89 c6             	mov    %rax,%rsi
  800e8b:	4c 89 e7             	mov    %r12,%rdi
  800e8e:	48 b8 8a 13 80 00 00 	movabs $0x80138a,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
  800e9a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e9d:	eb 17                	jmp    800eb6 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800e9f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800ea3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800eab:	48 89 d6             	mov    %rdx,%rsi
  800eae:	89 c7                	mov    %eax,%edi
  800eb0:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eb6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eba:	7f e3                	jg     800e9f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebc:	eb 39                	jmp    800ef7 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800ebe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ec2:	74 1e                	je     800ee2 <vprintfmt+0x326>
  800ec4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec7:	7e 05                	jle    800ece <vprintfmt+0x312>
  800ec9:	83 fb 7e             	cmp    $0x7e,%ebx
  800ecc:	7e 14                	jle    800ee2 <vprintfmt+0x326>
					putch('?', putdat);
  800ece:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ed2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ed6:	48 89 c6             	mov    %rax,%rsi
  800ed9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ede:	ff d2                	callq  *%rdx
  800ee0:	eb 0f                	jmp    800ef1 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800ee2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ee6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800eea:	48 89 c6             	mov    %rax,%rsi
  800eed:	89 df                	mov    %ebx,%edi
  800eef:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ef5:	eb 01                	jmp    800ef8 <vprintfmt+0x33c>
  800ef7:	90                   	nop
  800ef8:	41 0f b6 04 24       	movzbl (%r12),%eax
  800efd:	0f be d8             	movsbl %al,%ebx
  800f00:	85 db                	test   %ebx,%ebx
  800f02:	0f 95 c0             	setne  %al
  800f05:	49 83 c4 01          	add    $0x1,%r12
  800f09:	84 c0                	test   %al,%al
  800f0b:	74 28                	je     800f35 <vprintfmt+0x379>
  800f0d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f11:	78 ab                	js     800ebe <vprintfmt+0x302>
  800f13:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f17:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f1b:	79 a1                	jns    800ebe <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f1d:	eb 16                	jmp    800f35 <vprintfmt+0x379>
				putch(' ', putdat);
  800f1f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f23:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f27:	48 89 c6             	mov    %rax,%rsi
  800f2a:	bf 20 00 00 00       	mov    $0x20,%edi
  800f2f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f31:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f35:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f39:	7f e4                	jg     800f1f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800f3b:	e9 90 01 00 00       	jmpq   8010d0 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f40:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f44:	be 03 00 00 00       	mov    $0x3,%esi
  800f49:	48 89 c7             	mov    %rax,%rdi
  800f4c:	48 b8 ac 0a 80 00 00 	movabs $0x800aac,%rax
  800f53:	00 00 00 
  800f56:	ff d0                	callq  *%rax
  800f58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f60:	48 85 c0             	test   %rax,%rax
  800f63:	79 1d                	jns    800f82 <vprintfmt+0x3c6>
				putch('-', putdat);
  800f65:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f69:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f6d:	48 89 c6             	mov    %rax,%rsi
  800f70:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f75:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	48 f7 d8             	neg    %rax
  800f7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f82:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f89:	e9 d5 00 00 00       	jmpq   801063 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f92:	be 03 00 00 00       	mov    $0x3,%esi
  800f97:	48 89 c7             	mov    %rax,%rdi
  800f9a:	48 b8 9c 09 80 00 00 	movabs $0x80099c,%rax
  800fa1:	00 00 00 
  800fa4:	ff d0                	callq  *%rax
  800fa6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800faa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fb1:	e9 ad 00 00 00       	jmpq   801063 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800fb6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fba:	be 03 00 00 00       	mov    $0x3,%esi
  800fbf:	48 89 c7             	mov    %rax,%rdi
  800fc2:	48 b8 9c 09 80 00 00 	movabs $0x80099c,%rax
  800fc9:	00 00 00 
  800fcc:	ff d0                	callq  *%rax
  800fce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800fd2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fd9:	e9 85 00 00 00       	jmpq   801063 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800fde:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fe2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fe6:	48 89 c6             	mov    %rax,%rsi
  800fe9:	bf 30 00 00 00       	mov    $0x30,%edi
  800fee:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800ff0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ff4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ff8:	48 89 c6             	mov    %rax,%rsi
  800ffb:	bf 78 00 00 00       	mov    $0x78,%edi
  801000:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801002:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801005:	83 f8 30             	cmp    $0x30,%eax
  801008:	73 17                	jae    801021 <vprintfmt+0x465>
  80100a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80100e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801011:	89 c0                	mov    %eax,%eax
  801013:	48 01 d0             	add    %rdx,%rax
  801016:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801019:	83 c2 08             	add    $0x8,%edx
  80101c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80101f:	eb 0f                	jmp    801030 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  801021:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801025:	48 89 d0             	mov    %rdx,%rax
  801028:	48 83 c2 08          	add    $0x8,%rdx
  80102c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801030:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801033:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801037:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80103e:	eb 23                	jmp    801063 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801040:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801044:	be 03 00 00 00       	mov    $0x3,%esi
  801049:	48 89 c7             	mov    %rax,%rdi
  80104c:	48 b8 9c 09 80 00 00 	movabs $0x80099c,%rax
  801053:	00 00 00 
  801056:	ff d0                	callq  *%rax
  801058:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80105c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801063:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801068:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80106b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80106e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801072:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801076:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80107a:	45 89 c1             	mov    %r8d,%r9d
  80107d:	41 89 f8             	mov    %edi,%r8d
  801080:	48 89 c7             	mov    %rax,%rdi
  801083:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  80108a:	00 00 00 
  80108d:	ff d0                	callq  *%rax
			break;
  80108f:	eb 3f                	jmp    8010d0 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801091:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801095:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801099:	48 89 c6             	mov    %rax,%rsi
  80109c:	89 df                	mov    %ebx,%edi
  80109e:	ff d2                	callq  *%rdx
			break;
  8010a0:	eb 2e                	jmp    8010d0 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010a2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010a6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010aa:	48 89 c6             	mov    %rax,%rsi
  8010ad:	bf 25 00 00 00       	mov    $0x25,%edi
  8010b2:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010b4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010b9:	eb 05                	jmp    8010c0 <vprintfmt+0x504>
  8010bb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010c0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010c4:	48 83 e8 01          	sub    $0x1,%rax
  8010c8:	0f b6 00             	movzbl (%rax),%eax
  8010cb:	3c 25                	cmp    $0x25,%al
  8010cd:	75 ec                	jne    8010bb <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  8010cf:	90                   	nop
		}
	}
  8010d0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010d1:	e9 38 fb ff ff       	jmpq   800c0e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  8010d6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  8010d7:	48 83 c4 60          	add    $0x60,%rsp
  8010db:	5b                   	pop    %rbx
  8010dc:	41 5c                	pop    %r12
  8010de:	5d                   	pop    %rbp
  8010df:	c3                   	retq   

00000000008010e0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010eb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010f2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801100:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801107:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80110e:	84 c0                	test   %al,%al
  801110:	74 20                	je     801132 <printfmt+0x52>
  801112:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801116:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80111a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80111e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801122:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801126:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80112a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80112e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801132:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801139:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801140:	00 00 00 
  801143:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80114a:	00 00 00 
  80114d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801151:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801158:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80115f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801166:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80116d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801174:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80117b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801182:	48 89 c7             	mov    %rax,%rdi
  801185:	48 b8 bc 0b 80 00 00 	movabs $0x800bbc,%rax
  80118c:	00 00 00 
  80118f:	ff d0                	callq  *%rax
	va_end(ap);
}
  801191:	c9                   	leaveq 
  801192:	c3                   	retq   

0000000000801193 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801193:	55                   	push   %rbp
  801194:	48 89 e5             	mov    %rsp,%rbp
  801197:	48 83 ec 10          	sub    $0x10,%rsp
  80119b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80119e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a6:	8b 40 10             	mov    0x10(%rax),%eax
  8011a9:	8d 50 01             	lea    0x1(%rax),%edx
  8011ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b7:	48 8b 10             	mov    (%rax),%rdx
  8011ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011c2:	48 39 c2             	cmp    %rax,%rdx
  8011c5:	73 17                	jae    8011de <sprintputch+0x4b>
		*b->buf++ = ch;
  8011c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cb:	48 8b 00             	mov    (%rax),%rax
  8011ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011d1:	88 10                	mov    %dl,(%rax)
  8011d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011db:	48 89 10             	mov    %rdx,(%rax)
}
  8011de:	c9                   	leaveq 
  8011df:	c3                   	retq   

00000000008011e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011e0:	55                   	push   %rbp
  8011e1:	48 89 e5             	mov    %rsp,%rbp
  8011e4:	48 83 ec 50          	sub    $0x50,%rsp
  8011e8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011ec:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011ef:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011f3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011f7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011fb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011ff:	48 8b 0a             	mov    (%rdx),%rcx
  801202:	48 89 08             	mov    %rcx,(%rax)
  801205:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801209:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80120d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801211:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801215:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801219:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80121d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801220:	48 98                	cltq   
  801222:	48 83 e8 01          	sub    $0x1,%rax
  801226:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80122a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80122e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801235:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80123a:	74 06                	je     801242 <vsnprintf+0x62>
  80123c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801240:	7f 07                	jg     801249 <vsnprintf+0x69>
		return -E_INVAL;
  801242:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801247:	eb 2f                	jmp    801278 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801249:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80124d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801251:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801255:	48 89 c6             	mov    %rax,%rsi
  801258:	48 bf 93 11 80 00 00 	movabs $0x801193,%rdi
  80125f:	00 00 00 
  801262:	48 b8 bc 0b 80 00 00 	movabs $0x800bbc,%rax
  801269:	00 00 00 
  80126c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80126e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801272:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801275:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801278:	c9                   	leaveq 
  801279:	c3                   	retq   

000000000080127a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80127a:	55                   	push   %rbp
  80127b:	48 89 e5             	mov    %rsp,%rbp
  80127e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801285:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80128c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801292:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801299:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012a7:	84 c0                	test   %al,%al
  8012a9:	74 20                	je     8012cb <snprintf+0x51>
  8012ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012cb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012d2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012d9:	00 00 00 
  8012dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012e3:	00 00 00 
  8012e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801306:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80130d:	48 8b 0a             	mov    (%rdx),%rcx
  801310:	48 89 08             	mov    %rcx,(%rax)
  801313:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801317:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80131b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80131f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801323:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80132a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801331:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801337:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80133e:	48 89 c7             	mov    %rax,%rdi
  801341:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  801348:	00 00 00 
  80134b:	ff d0                	callq  *%rax
  80134d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801353:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801359:	c9                   	leaveq 
  80135a:	c3                   	retq   
	...

000000000080135c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80135c:	55                   	push   %rbp
  80135d:	48 89 e5             	mov    %rsp,%rbp
  801360:	48 83 ec 18          	sub    $0x18,%rsp
  801364:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801368:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80136f:	eb 09                	jmp    80137a <strlen+0x1e>
		n++;
  801371:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801375:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80137a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137e:	0f b6 00             	movzbl (%rax),%eax
  801381:	84 c0                	test   %al,%al
  801383:	75 ec                	jne    801371 <strlen+0x15>
		n++;
	return n;
  801385:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801388:	c9                   	leaveq 
  801389:	c3                   	retq   

000000000080138a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80138a:	55                   	push   %rbp
  80138b:	48 89 e5             	mov    %rsp,%rbp
  80138e:	48 83 ec 20          	sub    $0x20,%rsp
  801392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801396:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80139a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013a1:	eb 0e                	jmp    8013b1 <strnlen+0x27>
		n++;
  8013a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ac:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013b1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013b6:	74 0b                	je     8013c3 <strnlen+0x39>
  8013b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bc:	0f b6 00             	movzbl (%rax),%eax
  8013bf:	84 c0                	test   %al,%al
  8013c1:	75 e0                	jne    8013a3 <strnlen+0x19>
		n++;
	return n;
  8013c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013c6:	c9                   	leaveq 
  8013c7:	c3                   	retq   

00000000008013c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013c8:	55                   	push   %rbp
  8013c9:	48 89 e5             	mov    %rsp,%rbp
  8013cc:	48 83 ec 20          	sub    $0x20,%rsp
  8013d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013e0:	90                   	nop
  8013e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e5:	0f b6 10             	movzbl (%rax),%edx
  8013e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ec:	88 10                	mov    %dl,(%rax)
  8013ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	84 c0                	test   %al,%al
  8013f7:	0f 95 c0             	setne  %al
  8013fa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ff:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801404:	84 c0                	test   %al,%al
  801406:	75 d9                	jne    8013e1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80140c:	c9                   	leaveq 
  80140d:	c3                   	retq   

000000000080140e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80140e:	55                   	push   %rbp
  80140f:	48 89 e5             	mov    %rsp,%rbp
  801412:	48 83 ec 20          	sub    $0x20,%rsp
  801416:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80141a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80141e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801422:	48 89 c7             	mov    %rax,%rdi
  801425:	48 b8 5c 13 80 00 00 	movabs $0x80135c,%rax
  80142c:	00 00 00 
  80142f:	ff d0                	callq  *%rax
  801431:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801437:	48 98                	cltq   
  801439:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80143d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801441:	48 89 d6             	mov    %rdx,%rsi
  801444:	48 89 c7             	mov    %rax,%rdi
  801447:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  80144e:	00 00 00 
  801451:	ff d0                	callq  *%rax
	return dst;
  801453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801457:	c9                   	leaveq 
  801458:	c3                   	retq   

0000000000801459 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801459:	55                   	push   %rbp
  80145a:	48 89 e5             	mov    %rsp,%rbp
  80145d:	48 83 ec 28          	sub    $0x28,%rsp
  801461:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801465:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801469:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80146d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801471:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801475:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80147c:	00 
  80147d:	eb 27                	jmp    8014a6 <strncpy+0x4d>
		*dst++ = *src;
  80147f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801483:	0f b6 10             	movzbl (%rax),%edx
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	88 10                	mov    %dl,(%rax)
  80148c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801491:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	84 c0                	test   %al,%al
  80149a:	74 05                	je     8014a1 <strncpy+0x48>
			src++;
  80149c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014aa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014ae:	72 cf                	jb     80147f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014b4:	c9                   	leaveq 
  8014b5:	c3                   	retq   

00000000008014b6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014b6:	55                   	push   %rbp
  8014b7:	48 89 e5             	mov    %rsp,%rbp
  8014ba:	48 83 ec 28          	sub    $0x28,%rsp
  8014be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014d7:	74 37                	je     801510 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8014d9:	eb 17                	jmp    8014f2 <strlcpy+0x3c>
			*dst++ = *src++;
  8014db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014df:	0f b6 10             	movzbl (%rax),%edx
  8014e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e6:	88 10                	mov    %dl,(%rax)
  8014e8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014ed:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014f2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014f7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014fc:	74 0b                	je     801509 <strlcpy+0x53>
  8014fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801502:	0f b6 00             	movzbl (%rax),%eax
  801505:	84 c0                	test   %al,%al
  801507:	75 d2                	jne    8014db <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801510:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801518:	48 89 d1             	mov    %rdx,%rcx
  80151b:	48 29 c1             	sub    %rax,%rcx
  80151e:	48 89 c8             	mov    %rcx,%rax
}
  801521:	c9                   	leaveq 
  801522:	c3                   	retq   

0000000000801523 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801523:	55                   	push   %rbp
  801524:	48 89 e5             	mov    %rsp,%rbp
  801527:	48 83 ec 10          	sub    $0x10,%rsp
  80152b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801533:	eb 0a                	jmp    80153f <strcmp+0x1c>
		p++, q++;
  801535:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80153f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801543:	0f b6 00             	movzbl (%rax),%eax
  801546:	84 c0                	test   %al,%al
  801548:	74 12                	je     80155c <strcmp+0x39>
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	0f b6 10             	movzbl (%rax),%edx
  801551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801555:	0f b6 00             	movzbl (%rax),%eax
  801558:	38 c2                	cmp    %al,%dl
  80155a:	74 d9                	je     801535 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	0f b6 d0             	movzbl %al,%edx
  801566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156a:	0f b6 00             	movzbl (%rax),%eax
  80156d:	0f b6 c0             	movzbl %al,%eax
  801570:	89 d1                	mov    %edx,%ecx
  801572:	29 c1                	sub    %eax,%ecx
  801574:	89 c8                	mov    %ecx,%eax
}
  801576:	c9                   	leaveq 
  801577:	c3                   	retq   

0000000000801578 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801578:	55                   	push   %rbp
  801579:	48 89 e5             	mov    %rsp,%rbp
  80157c:	48 83 ec 18          	sub    $0x18,%rsp
  801580:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801584:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801588:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80158c:	eb 0f                	jmp    80159d <strncmp+0x25>
		n--, p++, q++;
  80158e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801593:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801598:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80159d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a2:	74 1d                	je     8015c1 <strncmp+0x49>
  8015a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a8:	0f b6 00             	movzbl (%rax),%eax
  8015ab:	84 c0                	test   %al,%al
  8015ad:	74 12                	je     8015c1 <strncmp+0x49>
  8015af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b3:	0f b6 10             	movzbl (%rax),%edx
  8015b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ba:	0f b6 00             	movzbl (%rax),%eax
  8015bd:	38 c2                	cmp    %al,%dl
  8015bf:	74 cd                	je     80158e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c6:	75 07                	jne    8015cf <strncmp+0x57>
		return 0;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cd:	eb 1a                	jmp    8015e9 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	0f b6 d0             	movzbl %al,%edx
  8015d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	0f b6 c0             	movzbl %al,%eax
  8015e3:	89 d1                	mov    %edx,%ecx
  8015e5:	29 c1                	sub    %eax,%ecx
  8015e7:	89 c8                	mov    %ecx,%eax
}
  8015e9:	c9                   	leaveq 
  8015ea:	c3                   	retq   

00000000008015eb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015eb:	55                   	push   %rbp
  8015ec:	48 89 e5             	mov    %rsp,%rbp
  8015ef:	48 83 ec 10          	sub    $0x10,%rsp
  8015f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f7:	89 f0                	mov    %esi,%eax
  8015f9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015fc:	eb 17                	jmp    801615 <strchr+0x2a>
		if (*s == c)
  8015fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801608:	75 06                	jne    801610 <strchr+0x25>
			return (char *) s;
  80160a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160e:	eb 15                	jmp    801625 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801610:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801619:	0f b6 00             	movzbl (%rax),%eax
  80161c:	84 c0                	test   %al,%al
  80161e:	75 de                	jne    8015fe <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801625:	c9                   	leaveq 
  801626:	c3                   	retq   

0000000000801627 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
  80162b:	48 83 ec 10          	sub    $0x10,%rsp
  80162f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801633:	89 f0                	mov    %esi,%eax
  801635:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801638:	eb 11                	jmp    80164b <strfind+0x24>
		if (*s == c)
  80163a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801644:	74 12                	je     801658 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801646:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80164b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164f:	0f b6 00             	movzbl (%rax),%eax
  801652:	84 c0                	test   %al,%al
  801654:	75 e4                	jne    80163a <strfind+0x13>
  801656:	eb 01                	jmp    801659 <strfind+0x32>
		if (*s == c)
			break;
  801658:	90                   	nop
	return (char *) s;
  801659:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80165d:	c9                   	leaveq 
  80165e:	c3                   	retq   

000000000080165f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80165f:	55                   	push   %rbp
  801660:	48 89 e5             	mov    %rsp,%rbp
  801663:	48 83 ec 18          	sub    $0x18,%rsp
  801667:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80166b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80166e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801672:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801677:	75 06                	jne    80167f <memset+0x20>
		return v;
  801679:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167d:	eb 69                	jmp    8016e8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80167f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801683:	83 e0 03             	and    $0x3,%eax
  801686:	48 85 c0             	test   %rax,%rax
  801689:	75 48                	jne    8016d3 <memset+0x74>
  80168b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168f:	83 e0 03             	and    $0x3,%eax
  801692:	48 85 c0             	test   %rax,%rax
  801695:	75 3c                	jne    8016d3 <memset+0x74>
		c &= 0xFF;
  801697:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80169e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a1:	89 c2                	mov    %eax,%edx
  8016a3:	c1 e2 18             	shl    $0x18,%edx
  8016a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a9:	c1 e0 10             	shl    $0x10,%eax
  8016ac:	09 c2                	or     %eax,%edx
  8016ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016b1:	c1 e0 08             	shl    $0x8,%eax
  8016b4:	09 d0                	or     %edx,%eax
  8016b6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8016b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bd:	48 89 c1             	mov    %rax,%rcx
  8016c0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016cb:	48 89 d7             	mov    %rdx,%rdi
  8016ce:	fc                   	cld    
  8016cf:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016d1:	eb 11                	jmp    8016e4 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016da:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016de:	48 89 d7             	mov    %rdx,%rdi
  8016e1:	fc                   	cld    
  8016e2:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8016e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016e8:	c9                   	leaveq 
  8016e9:	c3                   	retq   

00000000008016ea <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016ea:	55                   	push   %rbp
  8016eb:	48 89 e5             	mov    %rsp,%rbp
  8016ee:	48 83 ec 28          	sub    $0x28,%rsp
  8016f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801702:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80170e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801712:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801716:	0f 83 88 00 00 00    	jae    8017a4 <memmove+0xba>
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801724:	48 01 d0             	add    %rdx,%rax
  801727:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80172b:	76 77                	jbe    8017a4 <memmove+0xba>
		s += n;
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801739:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80173d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801741:	83 e0 03             	and    $0x3,%eax
  801744:	48 85 c0             	test   %rax,%rax
  801747:	75 3b                	jne    801784 <memmove+0x9a>
  801749:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174d:	83 e0 03             	and    $0x3,%eax
  801750:	48 85 c0             	test   %rax,%rax
  801753:	75 2f                	jne    801784 <memmove+0x9a>
  801755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801759:	83 e0 03             	and    $0x3,%eax
  80175c:	48 85 c0             	test   %rax,%rax
  80175f:	75 23                	jne    801784 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801765:	48 83 e8 04          	sub    $0x4,%rax
  801769:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80176d:	48 83 ea 04          	sub    $0x4,%rdx
  801771:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801775:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801779:	48 89 c7             	mov    %rax,%rdi
  80177c:	48 89 d6             	mov    %rdx,%rsi
  80177f:	fd                   	std    
  801780:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801782:	eb 1d                	jmp    8017a1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801784:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801788:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80178c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801790:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801798:	48 89 d7             	mov    %rdx,%rdi
  80179b:	48 89 c1             	mov    %rax,%rcx
  80179e:	fd                   	std    
  80179f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017a1:	fc                   	cld    
  8017a2:	eb 57                	jmp    8017fb <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a8:	83 e0 03             	and    $0x3,%eax
  8017ab:	48 85 c0             	test   %rax,%rax
  8017ae:	75 36                	jne    8017e6 <memmove+0xfc>
  8017b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b4:	83 e0 03             	and    $0x3,%eax
  8017b7:	48 85 c0             	test   %rax,%rax
  8017ba:	75 2a                	jne    8017e6 <memmove+0xfc>
  8017bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c0:	83 e0 03             	and    $0x3,%eax
  8017c3:	48 85 c0             	test   %rax,%rax
  8017c6:	75 1e                	jne    8017e6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cc:	48 89 c1             	mov    %rax,%rcx
  8017cf:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017db:	48 89 c7             	mov    %rax,%rdi
  8017de:	48 89 d6             	mov    %rdx,%rsi
  8017e1:	fc                   	cld    
  8017e2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017e4:	eb 15                	jmp    8017fb <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017ee:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017f2:	48 89 c7             	mov    %rax,%rdi
  8017f5:	48 89 d6             	mov    %rdx,%rsi
  8017f8:	fc                   	cld    
  8017f9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017ff:	c9                   	leaveq 
  801800:	c3                   	retq   

0000000000801801 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801801:	55                   	push   %rbp
  801802:	48 89 e5             	mov    %rsp,%rbp
  801805:	48 83 ec 18          	sub    $0x18,%rsp
  801809:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80180d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801811:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801815:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801819:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80181d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801821:	48 89 ce             	mov    %rcx,%rsi
  801824:	48 89 c7             	mov    %rax,%rdi
  801827:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  80182e:	00 00 00 
  801831:	ff d0                	callq  *%rax
}
  801833:	c9                   	leaveq 
  801834:	c3                   	retq   

0000000000801835 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801835:	55                   	push   %rbp
  801836:	48 89 e5             	mov    %rsp,%rbp
  801839:	48 83 ec 28          	sub    $0x28,%rsp
  80183d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801841:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801845:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80184d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801851:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801855:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801859:	eb 38                	jmp    801893 <memcmp+0x5e>
		if (*s1 != *s2)
  80185b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185f:	0f b6 10             	movzbl (%rax),%edx
  801862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	38 c2                	cmp    %al,%dl
  80186b:	74 1c                	je     801889 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80186d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	0f b6 d0             	movzbl %al,%edx
  801877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	0f b6 c0             	movzbl %al,%eax
  801881:	89 d1                	mov    %edx,%ecx
  801883:	29 c1                	sub    %eax,%ecx
  801885:	89 c8                	mov    %ecx,%eax
  801887:	eb 20                	jmp    8018a9 <memcmp+0x74>
		s1++, s2++;
  801889:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80188e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801893:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801898:	0f 95 c0             	setne  %al
  80189b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8018a0:	84 c0                	test   %al,%al
  8018a2:	75 b7                	jne    80185b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a9:	c9                   	leaveq 
  8018aa:	c3                   	retq   

00000000008018ab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018ab:	55                   	push   %rbp
  8018ac:	48 89 e5             	mov    %rsp,%rbp
  8018af:	48 83 ec 28          	sub    $0x28,%rsp
  8018b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018b7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018c6:	48 01 d0             	add    %rdx,%rax
  8018c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018cd:	eb 13                	jmp    8018e2 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d3:	0f b6 10             	movzbl (%rax),%edx
  8018d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018d9:	38 c2                	cmp    %al,%dl
  8018db:	74 11                	je     8018ee <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018dd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018ea:	72 e3                	jb     8018cf <memfind+0x24>
  8018ec:	eb 01                	jmp    8018ef <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018ee:	90                   	nop
	return (void *) s;
  8018ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018f3:	c9                   	leaveq 
  8018f4:	c3                   	retq   

00000000008018f5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018f5:	55                   	push   %rbp
  8018f6:	48 89 e5             	mov    %rsp,%rbp
  8018f9:	48 83 ec 38          	sub    $0x38,%rsp
  8018fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801901:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801905:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801908:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80190f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801916:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801917:	eb 05                	jmp    80191e <strtol+0x29>
		s++;
  801919:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80191e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801922:	0f b6 00             	movzbl (%rax),%eax
  801925:	3c 20                	cmp    $0x20,%al
  801927:	74 f0                	je     801919 <strtol+0x24>
  801929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192d:	0f b6 00             	movzbl (%rax),%eax
  801930:	3c 09                	cmp    $0x9,%al
  801932:	74 e5                	je     801919 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801934:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801938:	0f b6 00             	movzbl (%rax),%eax
  80193b:	3c 2b                	cmp    $0x2b,%al
  80193d:	75 07                	jne    801946 <strtol+0x51>
		s++;
  80193f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801944:	eb 17                	jmp    80195d <strtol+0x68>
	else if (*s == '-')
  801946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	3c 2d                	cmp    $0x2d,%al
  80194f:	75 0c                	jne    80195d <strtol+0x68>
		s++, neg = 1;
  801951:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801956:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80195d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801961:	74 06                	je     801969 <strtol+0x74>
  801963:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801967:	75 28                	jne    801991 <strtol+0x9c>
  801969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196d:	0f b6 00             	movzbl (%rax),%eax
  801970:	3c 30                	cmp    $0x30,%al
  801972:	75 1d                	jne    801991 <strtol+0x9c>
  801974:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801978:	48 83 c0 01          	add    $0x1,%rax
  80197c:	0f b6 00             	movzbl (%rax),%eax
  80197f:	3c 78                	cmp    $0x78,%al
  801981:	75 0e                	jne    801991 <strtol+0x9c>
		s += 2, base = 16;
  801983:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801988:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80198f:	eb 2c                	jmp    8019bd <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801991:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801995:	75 19                	jne    8019b0 <strtol+0xbb>
  801997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199b:	0f b6 00             	movzbl (%rax),%eax
  80199e:	3c 30                	cmp    $0x30,%al
  8019a0:	75 0e                	jne    8019b0 <strtol+0xbb>
		s++, base = 8;
  8019a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019a7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019ae:	eb 0d                	jmp    8019bd <strtol+0xc8>
	else if (base == 0)
  8019b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019b4:	75 07                	jne    8019bd <strtol+0xc8>
		base = 10;
  8019b6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c1:	0f b6 00             	movzbl (%rax),%eax
  8019c4:	3c 2f                	cmp    $0x2f,%al
  8019c6:	7e 1d                	jle    8019e5 <strtol+0xf0>
  8019c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cc:	0f b6 00             	movzbl (%rax),%eax
  8019cf:	3c 39                	cmp    $0x39,%al
  8019d1:	7f 12                	jg     8019e5 <strtol+0xf0>
			dig = *s - '0';
  8019d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d7:	0f b6 00             	movzbl (%rax),%eax
  8019da:	0f be c0             	movsbl %al,%eax
  8019dd:	83 e8 30             	sub    $0x30,%eax
  8019e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019e3:	eb 4e                	jmp    801a33 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e9:	0f b6 00             	movzbl (%rax),%eax
  8019ec:	3c 60                	cmp    $0x60,%al
  8019ee:	7e 1d                	jle    801a0d <strtol+0x118>
  8019f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f4:	0f b6 00             	movzbl (%rax),%eax
  8019f7:	3c 7a                	cmp    $0x7a,%al
  8019f9:	7f 12                	jg     801a0d <strtol+0x118>
			dig = *s - 'a' + 10;
  8019fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ff:	0f b6 00             	movzbl (%rax),%eax
  801a02:	0f be c0             	movsbl %al,%eax
  801a05:	83 e8 57             	sub    $0x57,%eax
  801a08:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a0b:	eb 26                	jmp    801a33 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a11:	0f b6 00             	movzbl (%rax),%eax
  801a14:	3c 40                	cmp    $0x40,%al
  801a16:	7e 47                	jle    801a5f <strtol+0x16a>
  801a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1c:	0f b6 00             	movzbl (%rax),%eax
  801a1f:	3c 5a                	cmp    $0x5a,%al
  801a21:	7f 3c                	jg     801a5f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a27:	0f b6 00             	movzbl (%rax),%eax
  801a2a:	0f be c0             	movsbl %al,%eax
  801a2d:	83 e8 37             	sub    $0x37,%eax
  801a30:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a36:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a39:	7d 23                	jge    801a5e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801a3b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a40:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a43:	48 98                	cltq   
  801a45:	48 89 c2             	mov    %rax,%rdx
  801a48:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801a4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a50:	48 98                	cltq   
  801a52:	48 01 d0             	add    %rdx,%rax
  801a55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a59:	e9 5f ff ff ff       	jmpq   8019bd <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a5e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a5f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a64:	74 0b                	je     801a71 <strtol+0x17c>
		*endptr = (char *) s;
  801a66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a6a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a6e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a75:	74 09                	je     801a80 <strtol+0x18b>
  801a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7b:	48 f7 d8             	neg    %rax
  801a7e:	eb 04                	jmp    801a84 <strtol+0x18f>
  801a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a84:	c9                   	leaveq 
  801a85:	c3                   	retq   

0000000000801a86 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a86:	55                   	push   %rbp
  801a87:	48 89 e5             	mov    %rsp,%rbp
  801a8a:	48 83 ec 30          	sub    $0x30,%rsp
  801a8e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a92:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801a96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a9a:	0f b6 00             	movzbl (%rax),%eax
  801a9d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801aa0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801aa5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801aa9:	75 06                	jne    801ab1 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801aab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aaf:	eb 68                	jmp    801b19 <strstr+0x93>

    len = strlen(str);
  801ab1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ab5:	48 89 c7             	mov    %rax,%rdi
  801ab8:	48 b8 5c 13 80 00 00 	movabs $0x80135c,%rax
  801abf:	00 00 00 
  801ac2:	ff d0                	callq  *%rax
  801ac4:	48 98                	cltq   
  801ac6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801aca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ace:	0f b6 00             	movzbl (%rax),%eax
  801ad1:	88 45 ef             	mov    %al,-0x11(%rbp)
  801ad4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801ad9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801add:	75 07                	jne    801ae6 <strstr+0x60>
                return (char *) 0;
  801adf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae4:	eb 33                	jmp    801b19 <strstr+0x93>
        } while (sc != c);
  801ae6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801aea:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801aed:	75 db                	jne    801aca <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801aef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801af7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afb:	48 89 ce             	mov    %rcx,%rsi
  801afe:	48 89 c7             	mov    %rax,%rdi
  801b01:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801b08:	00 00 00 
  801b0b:	ff d0                	callq  *%rax
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	75 b9                	jne    801aca <strstr+0x44>

    return (char *) (in - 1);
  801b11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b15:	48 83 e8 01          	sub    $0x1,%rax
}
  801b19:	c9                   	leaveq 
  801b1a:	c3                   	retq   
	...

0000000000801b1c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b1c:	55                   	push   %rbp
  801b1d:	48 89 e5             	mov    %rsp,%rbp
  801b20:	53                   	push   %rbx
  801b21:	48 83 ec 58          	sub    $0x58,%rsp
  801b25:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b28:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b2b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b2f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b33:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b37:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b3b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b3e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801b41:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b45:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b49:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b4d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b51:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b55:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801b58:	4c 89 c3             	mov    %r8,%rbx
  801b5b:	cd 30                	int    $0x30
  801b5d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801b61:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801b65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801b69:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b6d:	74 3e                	je     801bad <syscall+0x91>
  801b6f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b74:	7e 37                	jle    801bad <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b7a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b7d:	49 89 d0             	mov    %rdx,%r8
  801b80:	89 c1                	mov    %eax,%ecx
  801b82:	48 ba 40 4f 80 00 00 	movabs $0x804f40,%rdx
  801b89:	00 00 00 
  801b8c:	be 23 00 00 00       	mov    $0x23,%esi
  801b91:	48 bf 5d 4f 80 00 00 	movabs $0x804f5d,%rdi
  801b98:	00 00 00 
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba0:	49 b9 d0 05 80 00 00 	movabs $0x8005d0,%r9
  801ba7:	00 00 00 
  801baa:	41 ff d1             	callq  *%r9

	return ret;
  801bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bb1:	48 83 c4 58          	add    $0x58,%rsp
  801bb5:	5b                   	pop    %rbx
  801bb6:	5d                   	pop    %rbp
  801bb7:	c3                   	retq   

0000000000801bb8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bb8:	55                   	push   %rbp
  801bb9:	48 89 e5             	mov    %rsp,%rbp
  801bbc:	48 83 ec 20          	sub    $0x20,%rsp
  801bc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd7:	00 
  801bd8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be4:	48 89 d1             	mov    %rdx,%rcx
  801be7:	48 89 c2             	mov    %rax,%rdx
  801bea:	be 00 00 00 00       	mov    $0x0,%esi
  801bef:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf4:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801bfb:	00 00 00 
  801bfe:	ff d0                	callq  *%rax
}
  801c00:	c9                   	leaveq 
  801c01:	c3                   	retq   

0000000000801c02 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c02:	55                   	push   %rbp
  801c03:	48 89 e5             	mov    %rsp,%rbp
  801c06:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c11:	00 
  801c12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c23:	ba 00 00 00 00       	mov    $0x0,%edx
  801c28:	be 00 00 00 00       	mov    $0x0,%esi
  801c2d:	bf 01 00 00 00       	mov    $0x1,%edi
  801c32:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	callq  *%rax
}
  801c3e:	c9                   	leaveq 
  801c3f:	c3                   	retq   

0000000000801c40 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c40:	55                   	push   %rbp
  801c41:	48 89 e5             	mov    %rsp,%rbp
  801c44:	48 83 ec 20          	sub    $0x20,%rsp
  801c48:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4e:	48 98                	cltq   
  801c50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c57:	00 
  801c58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c64:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c69:	48 89 c2             	mov    %rax,%rdx
  801c6c:	be 01 00 00 00       	mov    $0x1,%esi
  801c71:	bf 03 00 00 00       	mov    $0x3,%edi
  801c76:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	callq  *%rax
}
  801c82:	c9                   	leaveq 
  801c83:	c3                   	retq   

0000000000801c84 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c84:	55                   	push   %rbp
  801c85:	48 89 e5             	mov    %rsp,%rbp
  801c88:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c8c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c93:	00 
  801c94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca5:	ba 00 00 00 00       	mov    $0x0,%edx
  801caa:	be 00 00 00 00       	mov    $0x0,%esi
  801caf:	bf 02 00 00 00       	mov    $0x2,%edi
  801cb4:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801cbb:	00 00 00 
  801cbe:	ff d0                	callq  *%rax
}
  801cc0:	c9                   	leaveq 
  801cc1:	c3                   	retq   

0000000000801cc2 <sys_yield>:

void
sys_yield(void)
{
  801cc2:	55                   	push   %rbp
  801cc3:	48 89 e5             	mov    %rsp,%rbp
  801cc6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd1:	00 
  801cd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cde:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce8:	be 00 00 00 00       	mov    $0x0,%esi
  801ced:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cf2:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	callq  *%rax
}
  801cfe:	c9                   	leaveq 
  801cff:	c3                   	retq   

0000000000801d00 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d00:	55                   	push   %rbp
  801d01:	48 89 e5             	mov    %rsp,%rbp
  801d04:	48 83 ec 20          	sub    $0x20,%rsp
  801d08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d15:	48 63 c8             	movslq %eax,%rcx
  801d18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1f:	48 98                	cltq   
  801d21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d28:	00 
  801d29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2f:	49 89 c8             	mov    %rcx,%r8
  801d32:	48 89 d1             	mov    %rdx,%rcx
  801d35:	48 89 c2             	mov    %rax,%rdx
  801d38:	be 01 00 00 00       	mov    $0x1,%esi
  801d3d:	bf 04 00 00 00       	mov    $0x4,%edi
  801d42:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801d49:	00 00 00 
  801d4c:	ff d0                	callq  *%rax
}
  801d4e:	c9                   	leaveq 
  801d4f:	c3                   	retq   

0000000000801d50 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d50:	55                   	push   %rbp
  801d51:	48 89 e5             	mov    %rsp,%rbp
  801d54:	48 83 ec 30          	sub    $0x30,%rsp
  801d58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d5f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d62:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d66:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d6a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d6d:	48 63 c8             	movslq %eax,%rcx
  801d70:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d77:	48 63 f0             	movslq %eax,%rsi
  801d7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d81:	48 98                	cltq   
  801d83:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d87:	49 89 f9             	mov    %rdi,%r9
  801d8a:	49 89 f0             	mov    %rsi,%r8
  801d8d:	48 89 d1             	mov    %rdx,%rcx
  801d90:	48 89 c2             	mov    %rax,%rdx
  801d93:	be 01 00 00 00       	mov    $0x1,%esi
  801d98:	bf 05 00 00 00       	mov    $0x5,%edi
  801d9d:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801da4:	00 00 00 
  801da7:	ff d0                	callq  *%rax
}
  801da9:	c9                   	leaveq 
  801daa:	c3                   	retq   

0000000000801dab <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 20          	sub    $0x20,%rsp
  801db3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc1:	48 98                	cltq   
  801dc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dca:	00 
  801dcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd7:	48 89 d1             	mov    %rdx,%rcx
  801dda:	48 89 c2             	mov    %rax,%rdx
  801ddd:	be 01 00 00 00       	mov    $0x1,%esi
  801de2:	bf 06 00 00 00       	mov    $0x6,%edi
  801de7:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801dee:	00 00 00 
  801df1:	ff d0                	callq  *%rax
}
  801df3:	c9                   	leaveq 
  801df4:	c3                   	retq   

0000000000801df5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801df5:	55                   	push   %rbp
  801df6:	48 89 e5             	mov    %rsp,%rbp
  801df9:	48 83 ec 20          	sub    $0x20,%rsp
  801dfd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e00:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e06:	48 63 d0             	movslq %eax,%rdx
  801e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0c:	48 98                	cltq   
  801e0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e15:	00 
  801e16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e22:	48 89 d1             	mov    %rdx,%rcx
  801e25:	48 89 c2             	mov    %rax,%rdx
  801e28:	be 01 00 00 00       	mov    $0x1,%esi
  801e2d:	bf 08 00 00 00       	mov    $0x8,%edi
  801e32:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801e39:	00 00 00 
  801e3c:	ff d0                	callq  *%rax
}
  801e3e:	c9                   	leaveq 
  801e3f:	c3                   	retq   

0000000000801e40 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e40:	55                   	push   %rbp
  801e41:	48 89 e5             	mov    %rsp,%rbp
  801e44:	48 83 ec 20          	sub    $0x20,%rsp
  801e48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e56:	48 98                	cltq   
  801e58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5f:	00 
  801e60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6c:	48 89 d1             	mov    %rdx,%rcx
  801e6f:	48 89 c2             	mov    %rax,%rdx
  801e72:	be 01 00 00 00       	mov    $0x1,%esi
  801e77:	bf 09 00 00 00       	mov    $0x9,%edi
  801e7c:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax
}
  801e88:	c9                   	leaveq 
  801e89:	c3                   	retq   

0000000000801e8a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e8a:	55                   	push   %rbp
  801e8b:	48 89 e5             	mov    %rsp,%rbp
  801e8e:	48 83 ec 20          	sub    $0x20,%rsp
  801e92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea0:	48 98                	cltq   
  801ea2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea9:	00 
  801eaa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb6:	48 89 d1             	mov    %rdx,%rcx
  801eb9:	48 89 c2             	mov    %rax,%rdx
  801ebc:	be 01 00 00 00       	mov    $0x1,%esi
  801ec1:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ec6:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801ecd:	00 00 00 
  801ed0:	ff d0                	callq  *%rax
}
  801ed2:	c9                   	leaveq 
  801ed3:	c3                   	retq   

0000000000801ed4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ed4:	55                   	push   %rbp
  801ed5:	48 89 e5             	mov    %rsp,%rbp
  801ed8:	48 83 ec 30          	sub    $0x30,%rsp
  801edc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801edf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ee3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ee7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801eea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eed:	48 63 f0             	movslq %eax,%rsi
  801ef0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ef4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef7:	48 98                	cltq   
  801ef9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f04:	00 
  801f05:	49 89 f1             	mov    %rsi,%r9
  801f08:	49 89 c8             	mov    %rcx,%r8
  801f0b:	48 89 d1             	mov    %rdx,%rcx
  801f0e:	48 89 c2             	mov    %rax,%rdx
  801f11:	be 00 00 00 00       	mov    $0x0,%esi
  801f16:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f1b:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
}
  801f27:	c9                   	leaveq 
  801f28:	c3                   	retq   

0000000000801f29 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f29:	55                   	push   %rbp
  801f2a:	48 89 e5             	mov    %rsp,%rbp
  801f2d:	48 83 ec 20          	sub    $0x20,%rsp
  801f31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f40:	00 
  801f41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f52:	48 89 c2             	mov    %rax,%rdx
  801f55:	be 01 00 00 00       	mov    $0x1,%esi
  801f5a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f5f:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
}
  801f6b:	c9                   	leaveq 
  801f6c:	c3                   	retq   

0000000000801f6d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801f6d:	55                   	push   %rbp
  801f6e:	48 89 e5             	mov    %rsp,%rbp
  801f71:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f7c:	00 
  801f7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f93:	be 00 00 00 00       	mov    $0x0,%esi
  801f98:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f9d:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801fa4:	00 00 00 
  801fa7:	ff d0                	callq  *%rax
}
  801fa9:	c9                   	leaveq 
  801faa:	c3                   	retq   

0000000000801fab <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801fab:	55                   	push   %rbp
  801fac:	48 89 e5             	mov    %rsp,%rbp
  801faf:	48 83 ec 20          	sub    $0x20,%rsp
  801fb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801fbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fca:	00 
  801fcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd7:	48 89 d1             	mov    %rdx,%rcx
  801fda:	48 89 c2             	mov    %rax,%rdx
  801fdd:	be 00 00 00 00       	mov    $0x0,%esi
  801fe2:	bf 0f 00 00 00       	mov    $0xf,%edi
  801fe7:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801fee:	00 00 00 
  801ff1:	ff d0                	callq  *%rax
}
  801ff3:	c9                   	leaveq 
  801ff4:	c3                   	retq   

0000000000801ff5 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801ff5:	55                   	push   %rbp
  801ff6:	48 89 e5             	mov    %rsp,%rbp
  801ff9:	48 83 ec 20          	sub    $0x20,%rsp
  801ffd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802001:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802005:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802009:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80200d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802014:	00 
  802015:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80201b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802021:	48 89 d1             	mov    %rdx,%rcx
  802024:	48 89 c2             	mov    %rax,%rdx
  802027:	be 00 00 00 00       	mov    $0x0,%esi
  80202c:	bf 10 00 00 00       	mov    $0x10,%edi
  802031:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  802038:	00 00 00 
  80203b:	ff d0                	callq  *%rax
}
  80203d:	c9                   	leaveq 
  80203e:	c3                   	retq   
	...

0000000000802040 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802040:	55                   	push   %rbp
  802041:	48 89 e5             	mov    %rsp,%rbp
  802044:	48 83 ec 30          	sub    $0x30,%rsp
  802048:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80204c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802050:	48 8b 00             	mov    (%rax),%rax
  802053:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802057:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80205b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80205f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  802062:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802065:	83 e0 02             	and    $0x2,%eax
  802068:	85 c0                	test   %eax,%eax
  80206a:	74 23                	je     80208f <pgfault+0x4f>
  80206c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802070:	48 89 c2             	mov    %rax,%rdx
  802073:	48 c1 ea 0c          	shr    $0xc,%rdx
  802077:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207e:	01 00 00 
  802081:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802085:	25 00 08 00 00       	and    $0x800,%eax
  80208a:	48 85 c0             	test   %rax,%rax
  80208d:	75 2a                	jne    8020b9 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  80208f:	48 ba 70 4f 80 00 00 	movabs $0x804f70,%rdx
  802096:	00 00 00 
  802099:	be 1c 00 00 00       	mov    $0x1c,%esi
  80209e:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8020a5:	00 00 00 
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ad:	48 b9 d0 05 80 00 00 	movabs $0x8005d0,%rcx
  8020b4:	00 00 00 
  8020b7:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  8020b9:	ba 07 00 00 00       	mov    $0x7,%edx
  8020be:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c8:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  8020cf:	00 00 00 
  8020d2:	ff d0                	callq  *%rax
  8020d4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8020d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8020db:	79 30                	jns    80210d <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  8020dd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8020e0:	89 c1                	mov    %eax,%ecx
  8020e2:	48 ba b0 4f 80 00 00 	movabs $0x804fb0,%rdx
  8020e9:	00 00 00 
  8020ec:	be 26 00 00 00       	mov    $0x26,%esi
  8020f1:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8020f8:	00 00 00 
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802100:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  802107:	00 00 00 
  80210a:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  80210d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802111:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802115:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802119:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80211f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802124:	48 89 c6             	mov    %rax,%rsi
  802127:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80212c:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  802133:	00 00 00 
  802136:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  802138:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  802140:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802144:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80214a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802150:	48 89 c1             	mov    %rax,%rcx
  802153:	ba 00 00 00 00       	mov    $0x0,%edx
  802158:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80215d:	bf 00 00 00 00       	mov    $0x0,%edi
  802162:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  802169:	00 00 00 
  80216c:	ff d0                	callq  *%rax
  80216e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802171:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802175:	79 30                	jns    8021a7 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  802177:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80217a:	89 c1                	mov    %eax,%ecx
  80217c:	48 ba d8 4f 80 00 00 	movabs $0x804fd8,%rdx
  802183:	00 00 00 
  802186:	be 2b 00 00 00       	mov    $0x2b,%esi
  80218b:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  802192:	00 00 00 
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
  80219a:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8021a1:	00 00 00 
  8021a4:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  8021a7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b1:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	callq  *%rax
  8021bd:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8021c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8021c4:	79 30                	jns    8021f6 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  8021c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8021c9:	89 c1                	mov    %eax,%ecx
  8021cb:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  8021d2:	00 00 00 
  8021d5:	be 2e 00 00 00       	mov    $0x2e,%esi
  8021da:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8021e1:	00 00 00 
  8021e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e9:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8021f0:	00 00 00 
  8021f3:	41 ff d0             	callq  *%r8
	
}
  8021f6:	c9                   	leaveq 
  8021f7:	c3                   	retq   

00000000008021f8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8021f8:	55                   	push   %rbp
  8021f9:	48 89 e5             	mov    %rsp,%rbp
  8021fc:	48 83 ec 30          	sub    $0x30,%rsp
  802200:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802203:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  802206:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80220d:	01 00 00 
  802210:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802213:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802217:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  80221b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80221f:	25 07 0e 00 00       	and    $0xe07,%eax
  802224:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  802227:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80222a:	48 c1 e0 0c          	shl    $0xc,%rax
  80222e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  802232:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802235:	25 00 04 00 00       	and    $0x400,%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	74 5c                	je     80229a <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  80223e:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802241:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802245:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224c:	41 89 f0             	mov    %esi,%r8d
  80224f:	48 89 c6             	mov    %rax,%rsi
  802252:	bf 00 00 00 00       	mov    $0x0,%edi
  802257:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax
  802263:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  802266:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80226a:	0f 89 60 01 00 00    	jns    8023d0 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  802270:	48 ba 28 50 80 00 00 	movabs $0x805028,%rdx
  802277:	00 00 00 
  80227a:	be 4d 00 00 00       	mov    $0x4d,%esi
  80227f:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  802286:	00 00 00 
  802289:	b8 00 00 00 00       	mov    $0x0,%eax
  80228e:	48 b9 d0 05 80 00 00 	movabs $0x8005d0,%rcx
  802295:	00 00 00 
  802298:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  80229a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80229d:	83 e0 02             	and    $0x2,%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	75 10                	jne    8022b4 <duppage+0xbc>
  8022a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022a7:	25 00 08 00 00       	and    $0x800,%eax
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	0f 84 c4 00 00 00    	je     802378 <duppage+0x180>
	{
		perm |= PTE_COW;
  8022b4:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  8022bb:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  8022bf:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8022c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022c6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cd:	41 89 f0             	mov    %esi,%r8d
  8022d0:	48 89 c6             	mov    %rax,%rsi
  8022d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d8:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  8022df:	00 00 00 
  8022e2:	ff d0                	callq  *%rax
  8022e4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  8022e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022eb:	79 2a                	jns    802317 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  8022ed:	48 ba 58 50 80 00 00 	movabs $0x805058,%rdx
  8022f4:	00 00 00 
  8022f7:	be 56 00 00 00       	mov    $0x56,%esi
  8022fc:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  802303:	00 00 00 
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
  80230b:	48 b9 d0 05 80 00 00 	movabs $0x8005d0,%rcx
  802312:	00 00 00 
  802315:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  802317:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  80231a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80231e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802322:	41 89 c8             	mov    %ecx,%r8d
  802325:	48 89 d1             	mov    %rdx,%rcx
  802328:	ba 00 00 00 00       	mov    $0x0,%edx
  80232d:	48 89 c6             	mov    %rax,%rsi
  802330:	bf 00 00 00 00       	mov    $0x0,%edi
  802335:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  80233c:	00 00 00 
  80233f:	ff d0                	callq  *%rax
  802341:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802344:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802348:	0f 89 82 00 00 00    	jns    8023d0 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  80234e:	48 ba 58 50 80 00 00 	movabs $0x805058,%rdx
  802355:	00 00 00 
  802358:	be 59 00 00 00       	mov    $0x59,%esi
  80235d:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  802364:	00 00 00 
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
  80236c:	48 b9 d0 05 80 00 00 	movabs $0x8005d0,%rcx
  802373:	00 00 00 
  802376:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  802378:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80237b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80237f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802386:	41 89 f0             	mov    %esi,%r8d
  802389:	48 89 c6             	mov    %rax,%rsi
  80238c:	bf 00 00 00 00       	mov    $0x0,%edi
  802391:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  802398:	00 00 00 
  80239b:	ff d0                	callq  *%rax
  80239d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8023a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023a4:	79 2a                	jns    8023d0 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  8023a6:	48 ba 90 50 80 00 00 	movabs $0x805090,%rdx
  8023ad:	00 00 00 
  8023b0:	be 60 00 00 00       	mov    $0x60,%esi
  8023b5:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8023bc:	00 00 00 
  8023bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c4:	48 b9 d0 05 80 00 00 	movabs $0x8005d0,%rcx
  8023cb:	00 00 00 
  8023ce:	ff d1                	callq  *%rcx
	}
	return 0;
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d5:	c9                   	leaveq 
  8023d6:	c3                   	retq   

00000000008023d7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8023d7:	55                   	push   %rbp
  8023d8:	48 89 e5             	mov    %rsp,%rbp
  8023db:	53                   	push   %rbx
  8023dc:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8023e0:	48 bf 40 20 80 00 00 	movabs $0x802040,%rdi
  8023e7:	00 00 00 
  8023ea:	48 b8 38 45 80 00 00 	movabs $0x804538,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8023f6:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  8023fd:	8b 45 bc             	mov    -0x44(%rbp),%eax
  802400:	cd 30                	int    $0x30
  802402:	89 c3                	mov    %eax,%ebx
  802404:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802407:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  80240a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  80240d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802411:	79 30                	jns    802443 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  802413:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802416:	89 c1                	mov    %eax,%ecx
  802418:	48 ba b4 50 80 00 00 	movabs $0x8050b4,%rdx
  80241f:	00 00 00 
  802422:	be 7f 00 00 00       	mov    $0x7f,%esi
  802427:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  80242e:	00 00 00 
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
  802436:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  80243d:	00 00 00 
  802440:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  802443:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802447:	75 4c                	jne    802495 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  802449:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  802450:	00 00 00 
  802453:	ff d0                	callq  *%rax
  802455:	48 98                	cltq   
  802457:	48 89 c2             	mov    %rax,%rdx
  80245a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802460:	48 89 d0             	mov    %rdx,%rax
  802463:	48 c1 e0 03          	shl    $0x3,%rax
  802467:	48 01 d0             	add    %rdx,%rax
  80246a:	48 c1 e0 05          	shl    $0x5,%rax
  80246e:	48 89 c2             	mov    %rax,%rdx
  802471:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802478:	00 00 00 
  80247b:	48 01 c2             	add    %rax,%rdx
  80247e:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802485:	00 00 00 
  802488:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
  802490:	e9 38 02 00 00       	jmpq   8026cd <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  802495:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802498:	ba 07 00 00 00       	mov    $0x7,%edx
  80249d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024a2:	89 c7                	mov    %eax,%edi
  8024a4:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  8024b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8024b7:	79 30                	jns    8024e9 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  8024b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8024bc:	89 c1                	mov    %eax,%ecx
  8024be:	48 ba c8 50 80 00 00 	movabs $0x8050c8,%rdx
  8024c5:	00 00 00 
  8024c8:	be 8b 00 00 00       	mov    $0x8b,%esi
  8024cd:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8024d4:	00 00 00 
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dc:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8024e3:	00 00 00 
  8024e6:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  8024e9:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  8024f0:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8024f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  8024fe:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802505:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80250c:	e9 0a 01 00 00       	jmpq   80261b <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  802511:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802518:	01 00 00 
  80251b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80251e:	48 63 d2             	movslq %edx,%rdx
  802521:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802525:	83 e0 01             	and    $0x1,%eax
  802528:	84 c0                	test   %al,%al
  80252a:	0f 84 e7 00 00 00    	je     802617 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802530:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802537:	e9 cf 00 00 00       	jmpq   80260b <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  80253c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802543:	01 00 00 
  802546:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802549:	48 63 d2             	movslq %edx,%rdx
  80254c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802550:	83 e0 01             	and    $0x1,%eax
  802553:	84 c0                	test   %al,%al
  802555:	0f 84 a0 00 00 00    	je     8025fb <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  80255b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802562:	e9 85 00 00 00       	jmpq   8025ec <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  802567:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80256e:	01 00 00 
  802571:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802574:	48 63 d2             	movslq %edx,%rdx
  802577:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80257b:	83 e0 01             	and    $0x1,%eax
  80257e:	84 c0                	test   %al,%al
  802580:	74 56                	je     8025d8 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802582:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  802589:	eb 42                	jmp    8025cd <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  80258b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802592:	01 00 00 
  802595:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802598:	48 63 d2             	movslq %edx,%rdx
  80259b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80259f:	83 e0 01             	and    $0x1,%eax
  8025a2:	84 c0                	test   %al,%al
  8025a4:	74 1f                	je     8025c5 <fork+0x1ee>
  8025a6:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  8025ad:	74 16                	je     8025c5 <fork+0x1ee>
									 duppage(envid,d1);
  8025af:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025b2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8025b5:	89 d6                	mov    %edx,%esi
  8025b7:	89 c7                	mov    %eax,%edi
  8025b9:	48 b8 f8 21 80 00 00 	movabs $0x8021f8,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8025c5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  8025c9:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  8025cd:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  8025d4:	7e b5                	jle    80258b <fork+0x1b4>
  8025d6:	eb 0c                	jmp    8025e4 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  8025d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025db:	83 c0 01             	add    $0x1,%eax
  8025de:	c1 e0 09             	shl    $0x9,%eax
  8025e1:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8025e4:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  8025e8:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  8025ec:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  8025f3:	0f 8e 6e ff ff ff    	jle    802567 <fork+0x190>
  8025f9:	eb 0c                	jmp    802607 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  8025fb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8025fe:	83 c0 01             	add    $0x1,%eax
  802601:	c1 e0 09             	shl    $0x9,%eax
  802604:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802607:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  80260b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80260e:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  802611:	0f 8c 25 ff ff ff    	jl     80253c <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802617:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80261b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80261e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802621:	0f 8c ea fe ff ff    	jl     802511 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802627:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80262a:	48 be fc 45 80 00 00 	movabs $0x8045fc,%rsi
  802631:	00 00 00 
  802634:	89 c7                	mov    %eax,%edi
  802636:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  80263d:	00 00 00 
  802640:	ff d0                	callq  *%rax
  802642:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802645:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802649:	79 30                	jns    80267b <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  80264b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80264e:	89 c1                	mov    %eax,%ecx
  802650:	48 ba e8 50 80 00 00 	movabs $0x8050e8,%rdx
  802657:	00 00 00 
  80265a:	be ad 00 00 00       	mov    $0xad,%esi
  80265f:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  802666:	00 00 00 
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
  80266e:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  802675:	00 00 00 
  802678:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  80267b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80267e:	be 02 00 00 00       	mov    $0x2,%esi
  802683:	89 c7                	mov    %eax,%edi
  802685:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802694:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802698:	79 30                	jns    8026ca <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  80269a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80269d:	89 c1                	mov    %eax,%ecx
  80269f:	48 ba 18 51 80 00 00 	movabs $0x805118,%rdx
  8026a6:	00 00 00 
  8026a9:	be b0 00 00 00       	mov    $0xb0,%esi
  8026ae:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8026b5:	00 00 00 
  8026b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bd:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8026c4:	00 00 00 
  8026c7:	41 ff d0             	callq  *%r8
	return envid;
  8026ca:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  8026cd:	48 83 c4 48          	add    $0x48,%rsp
  8026d1:	5b                   	pop    %rbx
  8026d2:	5d                   	pop    %rbp
  8026d3:	c3                   	retq   

00000000008026d4 <sfork>:

// Challenge!
int
sfork(void)
{
  8026d4:	55                   	push   %rbp
  8026d5:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8026d8:	48 ba 3c 51 80 00 00 	movabs $0x80513c,%rdx
  8026df:	00 00 00 
  8026e2:	be b8 00 00 00       	mov    $0xb8,%esi
  8026e7:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8026ee:	00 00 00 
  8026f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f6:	48 b9 d0 05 80 00 00 	movabs $0x8005d0,%rcx
  8026fd:	00 00 00 
  802700:	ff d1                	callq  *%rcx
	...

0000000000802704 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802704:	55                   	push   %rbp
  802705:	48 89 e5             	mov    %rsp,%rbp
  802708:	48 83 ec 08          	sub    $0x8,%rsp
  80270c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802710:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802714:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80271b:	ff ff ff 
  80271e:	48 01 d0             	add    %rdx,%rax
  802721:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802725:	c9                   	leaveq 
  802726:	c3                   	retq   

0000000000802727 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802727:	55                   	push   %rbp
  802728:	48 89 e5             	mov    %rsp,%rbp
  80272b:	48 83 ec 08          	sub    $0x8,%rsp
  80272f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802733:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802737:	48 89 c7             	mov    %rax,%rdi
  80273a:	48 b8 04 27 80 00 00 	movabs $0x802704,%rax
  802741:	00 00 00 
  802744:	ff d0                	callq  *%rax
  802746:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80274c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802750:	c9                   	leaveq 
  802751:	c3                   	retq   

0000000000802752 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802752:	55                   	push   %rbp
  802753:	48 89 e5             	mov    %rsp,%rbp
  802756:	48 83 ec 18          	sub    $0x18,%rsp
  80275a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80275e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802765:	eb 6b                	jmp    8027d2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80276a:	48 98                	cltq   
  80276c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802772:	48 c1 e0 0c          	shl    $0xc,%rax
  802776:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80277a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277e:	48 89 c2             	mov    %rax,%rdx
  802781:	48 c1 ea 15          	shr    $0x15,%rdx
  802785:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80278c:	01 00 00 
  80278f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802793:	83 e0 01             	and    $0x1,%eax
  802796:	48 85 c0             	test   %rax,%rax
  802799:	74 21                	je     8027bc <fd_alloc+0x6a>
  80279b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279f:	48 89 c2             	mov    %rax,%rdx
  8027a2:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027ad:	01 00 00 
  8027b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b4:	83 e0 01             	and    $0x1,%eax
  8027b7:	48 85 c0             	test   %rax,%rax
  8027ba:	75 12                	jne    8027ce <fd_alloc+0x7c>
			*fd_store = fd;
  8027bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027c4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	eb 1a                	jmp    8027e8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027d2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027d6:	7e 8f                	jle    802767 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027dc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027e3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027e8:	c9                   	leaveq 
  8027e9:	c3                   	retq   

00000000008027ea <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027ea:	55                   	push   %rbp
  8027eb:	48 89 e5             	mov    %rsp,%rbp
  8027ee:	48 83 ec 20          	sub    $0x20,%rsp
  8027f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027fd:	78 06                	js     802805 <fd_lookup+0x1b>
  8027ff:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802803:	7e 07                	jle    80280c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802805:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80280a:	eb 6c                	jmp    802878 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80280c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80280f:	48 98                	cltq   
  802811:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802817:	48 c1 e0 0c          	shl    $0xc,%rax
  80281b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80281f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802823:	48 89 c2             	mov    %rax,%rdx
  802826:	48 c1 ea 15          	shr    $0x15,%rdx
  80282a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802831:	01 00 00 
  802834:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802838:	83 e0 01             	and    $0x1,%eax
  80283b:	48 85 c0             	test   %rax,%rax
  80283e:	74 21                	je     802861 <fd_lookup+0x77>
  802840:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802844:	48 89 c2             	mov    %rax,%rdx
  802847:	48 c1 ea 0c          	shr    $0xc,%rdx
  80284b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802852:	01 00 00 
  802855:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802859:	83 e0 01             	and    $0x1,%eax
  80285c:	48 85 c0             	test   %rax,%rax
  80285f:	75 07                	jne    802868 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802861:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802866:	eb 10                	jmp    802878 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802868:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80286c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802870:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802873:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802878:	c9                   	leaveq 
  802879:	c3                   	retq   

000000000080287a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80287a:	55                   	push   %rbp
  80287b:	48 89 e5             	mov    %rsp,%rbp
  80287e:	48 83 ec 30          	sub    $0x30,%rsp
  802882:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802886:	89 f0                	mov    %esi,%eax
  802888:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80288b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80288f:	48 89 c7             	mov    %rax,%rdi
  802892:	48 b8 04 27 80 00 00 	movabs $0x802704,%rax
  802899:	00 00 00 
  80289c:	ff d0                	callq  *%rax
  80289e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028a2:	48 89 d6             	mov    %rdx,%rsi
  8028a5:	89 c7                	mov    %eax,%edi
  8028a7:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  8028ae:	00 00 00 
  8028b1:	ff d0                	callq  *%rax
  8028b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ba:	78 0a                	js     8028c6 <fd_close+0x4c>
	    || fd != fd2)
  8028bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8028c4:	74 12                	je     8028d8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8028c6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8028ca:	74 05                	je     8028d1 <fd_close+0x57>
  8028cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cf:	eb 05                	jmp    8028d6 <fd_close+0x5c>
  8028d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d6:	eb 69                	jmp    802941 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028dc:	8b 00                	mov    (%rax),%eax
  8028de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028e2:	48 89 d6             	mov    %rdx,%rsi
  8028e5:	89 c7                	mov    %eax,%edi
  8028e7:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  8028ee:	00 00 00 
  8028f1:	ff d0                	callq  *%rax
  8028f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fa:	78 2a                	js     802926 <fd_close+0xac>
		if (dev->dev_close)
  8028fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802900:	48 8b 40 20          	mov    0x20(%rax),%rax
  802904:	48 85 c0             	test   %rax,%rax
  802907:	74 16                	je     80291f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802909:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802915:	48 89 c7             	mov    %rax,%rdi
  802918:	ff d2                	callq  *%rdx
  80291a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291d:	eb 07                	jmp    802926 <fd_close+0xac>
		else
			r = 0;
  80291f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80292a:	48 89 c6             	mov    %rax,%rsi
  80292d:	bf 00 00 00 00       	mov    $0x0,%edi
  802932:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  802939:	00 00 00 
  80293c:	ff d0                	callq  *%rax
	return r;
  80293e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802941:	c9                   	leaveq 
  802942:	c3                   	retq   

0000000000802943 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802943:	55                   	push   %rbp
  802944:	48 89 e5             	mov    %rsp,%rbp
  802947:	48 83 ec 20          	sub    $0x20,%rsp
  80294b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80294e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802952:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802959:	eb 41                	jmp    80299c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80295b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802962:	00 00 00 
  802965:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802968:	48 63 d2             	movslq %edx,%rdx
  80296b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296f:	8b 00                	mov    (%rax),%eax
  802971:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802974:	75 22                	jne    802998 <dev_lookup+0x55>
			*dev = devtab[i];
  802976:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80297d:	00 00 00 
  802980:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802983:	48 63 d2             	movslq %edx,%rdx
  802986:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80298a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
  802996:	eb 60                	jmp    8029f8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802998:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80299c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8029a3:	00 00 00 
  8029a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029a9:	48 63 d2             	movslq %edx,%rdx
  8029ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029b0:	48 85 c0             	test   %rax,%rax
  8029b3:	75 a6                	jne    80295b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8029b5:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  8029bc:	00 00 00 
  8029bf:	48 8b 00             	mov    (%rax),%rax
  8029c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8029cb:	89 c6                	mov    %eax,%esi
  8029cd:	48 bf 58 51 80 00 00 	movabs $0x805158,%rdi
  8029d4:	00 00 00 
  8029d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029dc:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  8029e3:	00 00 00 
  8029e6:	ff d1                	callq  *%rcx
	*dev = 0;
  8029e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ec:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029f8:	c9                   	leaveq 
  8029f9:	c3                   	retq   

00000000008029fa <close>:

int
close(int fdnum)
{
  8029fa:	55                   	push   %rbp
  8029fb:	48 89 e5             	mov    %rsp,%rbp
  8029fe:	48 83 ec 20          	sub    $0x20,%rsp
  802a02:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a05:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a0c:	48 89 d6             	mov    %rdx,%rsi
  802a0f:	89 c7                	mov    %eax,%edi
  802a11:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  802a18:	00 00 00 
  802a1b:	ff d0                	callq  *%rax
  802a1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a24:	79 05                	jns    802a2b <close+0x31>
		return r;
  802a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a29:	eb 18                	jmp    802a43 <close+0x49>
	else
		return fd_close(fd, 1);
  802a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2f:	be 01 00 00 00       	mov    $0x1,%esi
  802a34:	48 89 c7             	mov    %rax,%rdi
  802a37:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
}
  802a43:	c9                   	leaveq 
  802a44:	c3                   	retq   

0000000000802a45 <close_all>:

void
close_all(void)
{
  802a45:	55                   	push   %rbp
  802a46:	48 89 e5             	mov    %rsp,%rbp
  802a49:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a54:	eb 15                	jmp    802a6b <close_all+0x26>
		close(i);
  802a56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a59:	89 c7                	mov    %eax,%edi
  802a5b:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  802a62:	00 00 00 
  802a65:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a67:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a6b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a6f:	7e e5                	jle    802a56 <close_all+0x11>
		close(i);
}
  802a71:	c9                   	leaveq 
  802a72:	c3                   	retq   

0000000000802a73 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a73:	55                   	push   %rbp
  802a74:	48 89 e5             	mov    %rsp,%rbp
  802a77:	48 83 ec 40          	sub    $0x40,%rsp
  802a7b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a7e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a81:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a85:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a88:	48 89 d6             	mov    %rdx,%rsi
  802a8b:	89 c7                	mov    %eax,%edi
  802a8d:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  802a94:	00 00 00 
  802a97:	ff d0                	callq  *%rax
  802a99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa0:	79 08                	jns    802aaa <dup+0x37>
		return r;
  802aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa5:	e9 70 01 00 00       	jmpq   802c1a <dup+0x1a7>
	close(newfdnum);
  802aaa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802aad:	89 c7                	mov    %eax,%edi
  802aaf:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  802ab6:	00 00 00 
  802ab9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802abb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802abe:	48 98                	cltq   
  802ac0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ac6:	48 c1 e0 0c          	shl    $0xc,%rax
  802aca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802ace:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ad2:	48 89 c7             	mov    %rax,%rdi
  802ad5:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  802adc:	00 00 00 
  802adf:	ff d0                	callq  *%rax
  802ae1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ae5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae9:	48 89 c7             	mov    %rax,%rdi
  802aec:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  802af3:	00 00 00 
  802af6:	ff d0                	callq  *%rax
  802af8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b00:	48 89 c2             	mov    %rax,%rdx
  802b03:	48 c1 ea 15          	shr    $0x15,%rdx
  802b07:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b0e:	01 00 00 
  802b11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b15:	83 e0 01             	and    $0x1,%eax
  802b18:	84 c0                	test   %al,%al
  802b1a:	74 71                	je     802b8d <dup+0x11a>
  802b1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b20:	48 89 c2             	mov    %rax,%rdx
  802b23:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b27:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b2e:	01 00 00 
  802b31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b35:	83 e0 01             	and    $0x1,%eax
  802b38:	84 c0                	test   %al,%al
  802b3a:	74 51                	je     802b8d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b40:	48 89 c2             	mov    %rax,%rdx
  802b43:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b4e:	01 00 00 
  802b51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b55:	89 c1                	mov    %eax,%ecx
  802b57:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802b5d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b65:	41 89 c8             	mov    %ecx,%r8d
  802b68:	48 89 d1             	mov    %rdx,%rcx
  802b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b70:	48 89 c6             	mov    %rax,%rsi
  802b73:	bf 00 00 00 00       	mov    $0x0,%edi
  802b78:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  802b7f:	00 00 00 
  802b82:	ff d0                	callq  *%rax
  802b84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8b:	78 56                	js     802be3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b91:	48 89 c2             	mov    %rax,%rdx
  802b94:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b98:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b9f:	01 00 00 
  802ba2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ba6:	89 c1                	mov    %eax,%ecx
  802ba8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802bae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bb6:	41 89 c8             	mov    %ecx,%r8d
  802bb9:	48 89 d1             	mov    %rdx,%rcx
  802bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc1:	48 89 c6             	mov    %rax,%rsi
  802bc4:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc9:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	callq  *%rax
  802bd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdc:	78 08                	js     802be6 <dup+0x173>
		goto err;

	return newfdnum;
  802bde:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802be1:	eb 37                	jmp    802c1a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802be3:	90                   	nop
  802be4:	eb 01                	jmp    802be7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802be6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802beb:	48 89 c6             	mov    %rax,%rsi
  802bee:	bf 00 00 00 00       	mov    $0x0,%edi
  802bf3:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c03:	48 89 c6             	mov    %rax,%rsi
  802c06:	bf 00 00 00 00       	mov    $0x0,%edi
  802c0b:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
	return r;
  802c17:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c1a:	c9                   	leaveq 
  802c1b:	c3                   	retq   

0000000000802c1c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802c1c:	55                   	push   %rbp
  802c1d:	48 89 e5             	mov    %rsp,%rbp
  802c20:	48 83 ec 40          	sub    $0x40,%rsp
  802c24:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c27:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c2b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c2f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c33:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c36:	48 89 d6             	mov    %rdx,%rsi
  802c39:	89 c7                	mov    %eax,%edi
  802c3b:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  802c42:	00 00 00 
  802c45:	ff d0                	callq  *%rax
  802c47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4e:	78 24                	js     802c74 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c54:	8b 00                	mov    (%rax),%eax
  802c56:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c5a:	48 89 d6             	mov    %rdx,%rsi
  802c5d:	89 c7                	mov    %eax,%edi
  802c5f:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802c66:	00 00 00 
  802c69:	ff d0                	callq  *%rax
  802c6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c72:	79 05                	jns    802c79 <read+0x5d>
		return r;
  802c74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c77:	eb 7a                	jmp    802cf3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7d:	8b 40 08             	mov    0x8(%rax),%eax
  802c80:	83 e0 03             	and    $0x3,%eax
  802c83:	83 f8 01             	cmp    $0x1,%eax
  802c86:	75 3a                	jne    802cc2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c88:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802c8f:	00 00 00 
  802c92:	48 8b 00             	mov    (%rax),%rax
  802c95:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c9b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c9e:	89 c6                	mov    %eax,%esi
  802ca0:	48 bf 77 51 80 00 00 	movabs $0x805177,%rdi
  802ca7:	00 00 00 
  802caa:	b8 00 00 00 00       	mov    $0x0,%eax
  802caf:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  802cb6:	00 00 00 
  802cb9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cc0:	eb 31                	jmp    802cf3 <read+0xd7>
	}
	if (!dev->dev_read)
  802cc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc6:	48 8b 40 10          	mov    0x10(%rax),%rax
  802cca:	48 85 c0             	test   %rax,%rax
  802ccd:	75 07                	jne    802cd6 <read+0xba>
		return -E_NOT_SUPP;
  802ccf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cd4:	eb 1d                	jmp    802cf3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cda:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802cde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ce6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cea:	48 89 ce             	mov    %rcx,%rsi
  802ced:	48 89 c7             	mov    %rax,%rdi
  802cf0:	41 ff d0             	callq  *%r8
}
  802cf3:	c9                   	leaveq 
  802cf4:	c3                   	retq   

0000000000802cf5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cf5:	55                   	push   %rbp
  802cf6:	48 89 e5             	mov    %rsp,%rbp
  802cf9:	48 83 ec 30          	sub    $0x30,%rsp
  802cfd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d0f:	eb 46                	jmp    802d57 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d14:	48 98                	cltq   
  802d16:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d1a:	48 29 c2             	sub    %rax,%rdx
  802d1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d20:	48 98                	cltq   
  802d22:	48 89 c1             	mov    %rax,%rcx
  802d25:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802d29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d2c:	48 89 ce             	mov    %rcx,%rsi
  802d2f:	89 c7                	mov    %eax,%edi
  802d31:	48 b8 1c 2c 80 00 00 	movabs $0x802c1c,%rax
  802d38:	00 00 00 
  802d3b:	ff d0                	callq  *%rax
  802d3d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d40:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d44:	79 05                	jns    802d4b <readn+0x56>
			return m;
  802d46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d49:	eb 1d                	jmp    802d68 <readn+0x73>
		if (m == 0)
  802d4b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d4f:	74 13                	je     802d64 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d54:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5a:	48 98                	cltq   
  802d5c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d60:	72 af                	jb     802d11 <readn+0x1c>
  802d62:	eb 01                	jmp    802d65 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802d64:	90                   	nop
	}
	return tot;
  802d65:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d68:	c9                   	leaveq 
  802d69:	c3                   	retq   

0000000000802d6a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d6a:	55                   	push   %rbp
  802d6b:	48 89 e5             	mov    %rsp,%rbp
  802d6e:	48 83 ec 40          	sub    $0x40,%rsp
  802d72:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d75:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d79:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d7d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d81:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d84:	48 89 d6             	mov    %rdx,%rsi
  802d87:	89 c7                	mov    %eax,%edi
  802d89:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  802d90:	00 00 00 
  802d93:	ff d0                	callq  *%rax
  802d95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9c:	78 24                	js     802dc2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da2:	8b 00                	mov    (%rax),%eax
  802da4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802da8:	48 89 d6             	mov    %rdx,%rsi
  802dab:	89 c7                	mov    %eax,%edi
  802dad:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802db4:	00 00 00 
  802db7:	ff d0                	callq  *%rax
  802db9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc0:	79 05                	jns    802dc7 <write+0x5d>
		return r;
  802dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc5:	eb 79                	jmp    802e40 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcb:	8b 40 08             	mov    0x8(%rax),%eax
  802dce:	83 e0 03             	and    $0x3,%eax
  802dd1:	85 c0                	test   %eax,%eax
  802dd3:	75 3a                	jne    802e0f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802dd5:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802ddc:	00 00 00 
  802ddf:	48 8b 00             	mov    (%rax),%rax
  802de2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802de8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802deb:	89 c6                	mov    %eax,%esi
  802ded:	48 bf 93 51 80 00 00 	movabs $0x805193,%rdi
  802df4:	00 00 00 
  802df7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfc:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  802e03:	00 00 00 
  802e06:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e0d:	eb 31                	jmp    802e40 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e13:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e17:	48 85 c0             	test   %rax,%rax
  802e1a:	75 07                	jne    802e23 <write+0xb9>
		return -E_NOT_SUPP;
  802e1c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e21:	eb 1d                	jmp    802e40 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e27:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802e2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e33:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e37:	48 89 ce             	mov    %rcx,%rsi
  802e3a:	48 89 c7             	mov    %rax,%rdi
  802e3d:	41 ff d0             	callq  *%r8
}
  802e40:	c9                   	leaveq 
  802e41:	c3                   	retq   

0000000000802e42 <seek>:

int
seek(int fdnum, off_t offset)
{
  802e42:	55                   	push   %rbp
  802e43:	48 89 e5             	mov    %rsp,%rbp
  802e46:	48 83 ec 18          	sub    $0x18,%rsp
  802e4a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e4d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e50:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e57:	48 89 d6             	mov    %rdx,%rsi
  802e5a:	89 c7                	mov    %eax,%edi
  802e5c:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
  802e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6f:	79 05                	jns    802e76 <seek+0x34>
		return r;
  802e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e74:	eb 0f                	jmp    802e85 <seek+0x43>
	fd->fd_offset = offset;
  802e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e7d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e85:	c9                   	leaveq 
  802e86:	c3                   	retq   

0000000000802e87 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e87:	55                   	push   %rbp
  802e88:	48 89 e5             	mov    %rsp,%rbp
  802e8b:	48 83 ec 30          	sub    $0x30,%rsp
  802e8f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e92:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e95:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e99:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e9c:	48 89 d6             	mov    %rdx,%rsi
  802e9f:	89 c7                	mov    %eax,%edi
  802ea1:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  802ea8:	00 00 00 
  802eab:	ff d0                	callq  *%rax
  802ead:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb4:	78 24                	js     802eda <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eba:	8b 00                	mov    (%rax),%eax
  802ebc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ec0:	48 89 d6             	mov    %rdx,%rsi
  802ec3:	89 c7                	mov    %eax,%edi
  802ec5:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
  802ed1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed8:	79 05                	jns    802edf <ftruncate+0x58>
		return r;
  802eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edd:	eb 72                	jmp    802f51 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee3:	8b 40 08             	mov    0x8(%rax),%eax
  802ee6:	83 e0 03             	and    $0x3,%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	75 3a                	jne    802f27 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802eed:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802ef4:	00 00 00 
  802ef7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802efa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f00:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f03:	89 c6                	mov    %eax,%esi
  802f05:	48 bf b0 51 80 00 00 	movabs $0x8051b0,%rdi
  802f0c:	00 00 00 
  802f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f14:	48 b9 0b 08 80 00 00 	movabs $0x80080b,%rcx
  802f1b:	00 00 00 
  802f1e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802f20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f25:	eb 2a                	jmp    802f51 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f2f:	48 85 c0             	test   %rax,%rax
  802f32:	75 07                	jne    802f3b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f39:	eb 16                	jmp    802f51 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f47:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802f4a:	89 d6                	mov    %edx,%esi
  802f4c:	48 89 c7             	mov    %rax,%rdi
  802f4f:	ff d1                	callq  *%rcx
}
  802f51:	c9                   	leaveq 
  802f52:	c3                   	retq   

0000000000802f53 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f53:	55                   	push   %rbp
  802f54:	48 89 e5             	mov    %rsp,%rbp
  802f57:	48 83 ec 30          	sub    $0x30,%rsp
  802f5b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f62:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f66:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f69:	48 89 d6             	mov    %rdx,%rsi
  802f6c:	89 c7                	mov    %eax,%edi
  802f6e:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  802f75:	00 00 00 
  802f78:	ff d0                	callq  *%rax
  802f7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f81:	78 24                	js     802fa7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f87:	8b 00                	mov    (%rax),%eax
  802f89:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f8d:	48 89 d6             	mov    %rdx,%rsi
  802f90:	89 c7                	mov    %eax,%edi
  802f92:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802f99:	00 00 00 
  802f9c:	ff d0                	callq  *%rax
  802f9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa5:	79 05                	jns    802fac <fstat+0x59>
		return r;
  802fa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802faa:	eb 5e                	jmp    80300a <fstat+0xb7>
	if (!dev->dev_stat)
  802fac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb0:	48 8b 40 28          	mov    0x28(%rax),%rax
  802fb4:	48 85 c0             	test   %rax,%rax
  802fb7:	75 07                	jne    802fc0 <fstat+0x6d>
		return -E_NOT_SUPP;
  802fb9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fbe:	eb 4a                	jmp    80300a <fstat+0xb7>
	stat->st_name[0] = 0;
  802fc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fc4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802fc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fcb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802fd2:	00 00 00 
	stat->st_isdir = 0;
  802fd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fd9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fe0:	00 00 00 
	stat->st_dev = dev;
  802fe3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fe7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802feb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ffe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803002:	48 89 d6             	mov    %rdx,%rsi
  803005:	48 89 c7             	mov    %rax,%rdi
  803008:	ff d1                	callq  *%rcx
}
  80300a:	c9                   	leaveq 
  80300b:	c3                   	retq   

000000000080300c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80300c:	55                   	push   %rbp
  80300d:	48 89 e5             	mov    %rsp,%rbp
  803010:	48 83 ec 20          	sub    $0x20,%rsp
  803014:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803018:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80301c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803020:	be 00 00 00 00       	mov    $0x0,%esi
  803025:	48 89 c7             	mov    %rax,%rdi
  803028:	48 b8 fb 30 80 00 00 	movabs $0x8030fb,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303b:	79 05                	jns    803042 <stat+0x36>
		return fd;
  80303d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803040:	eb 2f                	jmp    803071 <stat+0x65>
	r = fstat(fd, stat);
  803042:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803046:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803049:	48 89 d6             	mov    %rdx,%rsi
  80304c:	89 c7                	mov    %eax,%edi
  80304e:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  803055:	00 00 00 
  803058:	ff d0                	callq  *%rax
  80305a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80305d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803060:	89 c7                	mov    %eax,%edi
  803062:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
	return r;
  80306e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803071:	c9                   	leaveq 
  803072:	c3                   	retq   
	...

0000000000803074 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803074:	55                   	push   %rbp
  803075:	48 89 e5             	mov    %rsp,%rbp
  803078:	48 83 ec 10          	sub    $0x10,%rsp
  80307c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80307f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803083:	48 b8 24 80 80 00 00 	movabs $0x808024,%rax
  80308a:	00 00 00 
  80308d:	8b 00                	mov    (%rax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	75 1d                	jne    8030b0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803093:	bf 01 00 00 00       	mov    $0x1,%edi
  803098:	48 b8 0b 48 80 00 00 	movabs $0x80480b,%rax
  80309f:	00 00 00 
  8030a2:	ff d0                	callq  *%rax
  8030a4:	48 ba 24 80 80 00 00 	movabs $0x808024,%rdx
  8030ab:	00 00 00 
  8030ae:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8030b0:	48 b8 24 80 80 00 00 	movabs $0x808024,%rax
  8030b7:	00 00 00 
  8030ba:	8b 00                	mov    (%rax),%eax
  8030bc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030bf:	b9 07 00 00 00       	mov    $0x7,%ecx
  8030c4:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8030cb:	00 00 00 
  8030ce:	89 c7                	mov    %eax,%edi
  8030d0:	48 b8 48 47 80 00 00 	movabs $0x804748,%rax
  8030d7:	00 00 00 
  8030da:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8030dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e5:	48 89 c6             	mov    %rax,%rsi
  8030e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ed:	48 b8 88 46 80 00 00 	movabs $0x804688,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
}
  8030f9:	c9                   	leaveq 
  8030fa:	c3                   	retq   

00000000008030fb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030fb:	55                   	push   %rbp
  8030fc:	48 89 e5             	mov    %rsp,%rbp
  8030ff:	48 83 ec 20          	sub    $0x20,%rsp
  803103:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803107:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80310a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310e:	48 89 c7             	mov    %rax,%rdi
  803111:	48 b8 5c 13 80 00 00 	movabs $0x80135c,%rax
  803118:	00 00 00 
  80311b:	ff d0                	callq  *%rax
  80311d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803122:	7e 0a                	jle    80312e <open+0x33>
                return -E_BAD_PATH;
  803124:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803129:	e9 a5 00 00 00       	jmpq   8031d3 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80312e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803132:	48 89 c7             	mov    %rax,%rdi
  803135:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  80313c:	00 00 00 
  80313f:	ff d0                	callq  *%rax
  803141:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803144:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803148:	79 08                	jns    803152 <open+0x57>
		return r;
  80314a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314d:	e9 81 00 00 00       	jmpq   8031d3 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  803152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803156:	48 89 c6             	mov    %rax,%rsi
  803159:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803160:	00 00 00 
  803163:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80316f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803176:	00 00 00 
  803179:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80317c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  803182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803186:	48 89 c6             	mov    %rax,%rsi
  803189:	bf 01 00 00 00       	mov    $0x1,%edi
  80318e:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
  80319a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  80319d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a1:	79 1d                	jns    8031c0 <open+0xc5>
	{
		fd_close(fd,0);
  8031a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a7:	be 00 00 00 00       	mov    $0x0,%esi
  8031ac:	48 89 c7             	mov    %rax,%rdi
  8031af:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
		return r;
  8031bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031be:	eb 13                	jmp    8031d3 <open+0xd8>
	}
	return fd2num(fd);
  8031c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c4:	48 89 c7             	mov    %rax,%rdi
  8031c7:	48 b8 04 27 80 00 00 	movabs $0x802704,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
	


}
  8031d3:	c9                   	leaveq 
  8031d4:	c3                   	retq   

00000000008031d5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8031d5:	55                   	push   %rbp
  8031d6:	48 89 e5             	mov    %rsp,%rbp
  8031d9:	48 83 ec 10          	sub    $0x10,%rsp
  8031dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031e5:	8b 50 0c             	mov    0xc(%rax),%edx
  8031e8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031ef:	00 00 00 
  8031f2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031f4:	be 00 00 00 00       	mov    $0x0,%esi
  8031f9:	bf 06 00 00 00       	mov    $0x6,%edi
  8031fe:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  803205:	00 00 00 
  803208:	ff d0                	callq  *%rax
}
  80320a:	c9                   	leaveq 
  80320b:	c3                   	retq   

000000000080320c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80320c:	55                   	push   %rbp
  80320d:	48 89 e5             	mov    %rsp,%rbp
  803210:	48 83 ec 30          	sub    $0x30,%rsp
  803214:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803218:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80321c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803224:	8b 50 0c             	mov    0xc(%rax),%edx
  803227:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80322e:	00 00 00 
  803231:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803233:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80323a:	00 00 00 
  80323d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803241:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803245:	be 00 00 00 00       	mov    $0x0,%esi
  80324a:	bf 03 00 00 00       	mov    $0x3,%edi
  80324f:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  803256:	00 00 00 
  803259:	ff d0                	callq  *%rax
  80325b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80325e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803262:	79 05                	jns    803269 <devfile_read+0x5d>
	{
		return r;
  803264:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803267:	eb 2c                	jmp    803295 <devfile_read+0x89>
	}
	if(r > 0)
  803269:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326d:	7e 23                	jle    803292 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80326f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803272:	48 63 d0             	movslq %eax,%rdx
  803275:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803279:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803280:	00 00 00 
  803283:	48 89 c7             	mov    %rax,%rdi
  803286:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
	return r;
  803292:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
  80329b:	48 83 ec 30          	sub    $0x30,%rsp
  80329f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8032ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032af:	8b 50 0c             	mov    0xc(%rax),%edx
  8032b2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032b9:	00 00 00 
  8032bc:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8032be:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8032c5:	00 
  8032c6:	76 08                	jbe    8032d0 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8032c8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8032cf:	00 
	fsipcbuf.write.req_n=n;
  8032d0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032d7:	00 00 00 
  8032da:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032de:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8032e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ea:	48 89 c6             	mov    %rax,%rsi
  8032ed:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8032f4:	00 00 00 
  8032f7:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  803303:	be 00 00 00 00       	mov    $0x0,%esi
  803308:	bf 04 00 00 00       	mov    $0x4,%edi
  80330d:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  803314:	00 00 00 
  803317:	ff d0                	callq  *%rax
  803319:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  80331c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80331f:	c9                   	leaveq 
  803320:	c3                   	retq   

0000000000803321 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803321:	55                   	push   %rbp
  803322:	48 89 e5             	mov    %rsp,%rbp
  803325:	48 83 ec 10          	sub    $0x10,%rsp
  803329:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80332d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803334:	8b 50 0c             	mov    0xc(%rax),%edx
  803337:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80333e:	00 00 00 
  803341:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  803343:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80334a:	00 00 00 
  80334d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803350:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803353:	be 00 00 00 00       	mov    $0x0,%esi
  803358:	bf 02 00 00 00       	mov    $0x2,%edi
  80335d:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
}
  803369:	c9                   	leaveq 
  80336a:	c3                   	retq   

000000000080336b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80336b:	55                   	push   %rbp
  80336c:	48 89 e5             	mov    %rsp,%rbp
  80336f:	48 83 ec 20          	sub    $0x20,%rsp
  803373:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803377:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80337b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80337f:	8b 50 0c             	mov    0xc(%rax),%edx
  803382:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803389:	00 00 00 
  80338c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80338e:	be 00 00 00 00       	mov    $0x0,%esi
  803393:	bf 05 00 00 00       	mov    $0x5,%edi
  803398:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
  8033a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ab:	79 05                	jns    8033b2 <devfile_stat+0x47>
		return r;
  8033ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b0:	eb 56                	jmp    803408 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b6:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8033bd:	00 00 00 
  8033c0:	48 89 c7             	mov    %rax,%rdi
  8033c3:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8033cf:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033d6:	00 00 00 
  8033d9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033e3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033e9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033f0:	00 00 00 
  8033f3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8033f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033fd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803403:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803408:	c9                   	leaveq 
  803409:	c3                   	retq   
	...

000000000080340c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80340c:	55                   	push   %rbp
  80340d:	48 89 e5             	mov    %rsp,%rbp
  803410:	48 83 ec 20          	sub    $0x20,%rsp
  803414:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803417:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80341b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80341e:	48 89 d6             	mov    %rdx,%rsi
  803421:	89 c7                	mov    %eax,%edi
  803423:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  80342a:	00 00 00 
  80342d:	ff d0                	callq  *%rax
  80342f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803432:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803436:	79 05                	jns    80343d <fd2sockid+0x31>
		return r;
  803438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343b:	eb 24                	jmp    803461 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80343d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803441:	8b 10                	mov    (%rax),%edx
  803443:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80344a:	00 00 00 
  80344d:	8b 00                	mov    (%rax),%eax
  80344f:	39 c2                	cmp    %eax,%edx
  803451:	74 07                	je     80345a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803453:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803458:	eb 07                	jmp    803461 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80345a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80345e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803461:	c9                   	leaveq 
  803462:	c3                   	retq   

0000000000803463 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803463:	55                   	push   %rbp
  803464:	48 89 e5             	mov    %rsp,%rbp
  803467:	48 83 ec 20          	sub    $0x20,%rsp
  80346b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80346e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803472:	48 89 c7             	mov    %rax,%rdi
  803475:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
  803481:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803484:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803488:	78 26                	js     8034b0 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80348a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348e:	ba 07 04 00 00       	mov    $0x407,%edx
  803493:	48 89 c6             	mov    %rax,%rsi
  803496:	bf 00 00 00 00       	mov    $0x0,%edi
  80349b:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  8034a2:	00 00 00 
  8034a5:	ff d0                	callq  *%rax
  8034a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ae:	79 16                	jns    8034c6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8034b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b3:	89 c7                	mov    %eax,%edi
  8034b5:	48 b8 70 39 80 00 00 	movabs $0x803970,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
		return r;
  8034c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c4:	eb 3a                	jmp    803500 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8034c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ca:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8034d1:	00 00 00 
  8034d4:	8b 12                	mov    (%rdx),%edx
  8034d6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8034d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034dc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8034e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034ea:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8034ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f1:	48 89 c7             	mov    %rax,%rdi
  8034f4:	48 b8 04 27 80 00 00 	movabs $0x802704,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
}
  803500:	c9                   	leaveq 
  803501:	c3                   	retq   

0000000000803502 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803502:	55                   	push   %rbp
  803503:	48 89 e5             	mov    %rsp,%rbp
  803506:	48 83 ec 30          	sub    $0x30,%rsp
  80350a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80350d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803511:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803515:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803518:	89 c7                	mov    %eax,%edi
  80351a:	48 b8 0c 34 80 00 00 	movabs $0x80340c,%rax
  803521:	00 00 00 
  803524:	ff d0                	callq  *%rax
  803526:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803529:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80352d:	79 05                	jns    803534 <accept+0x32>
		return r;
  80352f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803532:	eb 3b                	jmp    80356f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803534:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803538:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80353c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353f:	48 89 ce             	mov    %rcx,%rsi
  803542:	89 c7                	mov    %eax,%edi
  803544:	48 b8 4d 38 80 00 00 	movabs $0x80384d,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax
  803550:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803553:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803557:	79 05                	jns    80355e <accept+0x5c>
		return r;
  803559:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355c:	eb 11                	jmp    80356f <accept+0x6d>
	return alloc_sockfd(r);
  80355e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803561:	89 c7                	mov    %eax,%edi
  803563:	48 b8 63 34 80 00 00 	movabs $0x803463,%rax
  80356a:	00 00 00 
  80356d:	ff d0                	callq  *%rax
}
  80356f:	c9                   	leaveq 
  803570:	c3                   	retq   

0000000000803571 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803571:	55                   	push   %rbp
  803572:	48 89 e5             	mov    %rsp,%rbp
  803575:	48 83 ec 20          	sub    $0x20,%rsp
  803579:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80357c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803580:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803583:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803586:	89 c7                	mov    %eax,%edi
  803588:	48 b8 0c 34 80 00 00 	movabs $0x80340c,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
  803594:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803597:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80359b:	79 05                	jns    8035a2 <bind+0x31>
		return r;
  80359d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a0:	eb 1b                	jmp    8035bd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8035a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ac:	48 89 ce             	mov    %rcx,%rsi
  8035af:	89 c7                	mov    %eax,%edi
  8035b1:	48 b8 cc 38 80 00 00 	movabs $0x8038cc,%rax
  8035b8:	00 00 00 
  8035bb:	ff d0                	callq  *%rax
}
  8035bd:	c9                   	leaveq 
  8035be:	c3                   	retq   

00000000008035bf <shutdown>:

int
shutdown(int s, int how)
{
  8035bf:	55                   	push   %rbp
  8035c0:	48 89 e5             	mov    %rsp,%rbp
  8035c3:	48 83 ec 20          	sub    $0x20,%rsp
  8035c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035ca:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d0:	89 c7                	mov    %eax,%edi
  8035d2:	48 b8 0c 34 80 00 00 	movabs $0x80340c,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
  8035de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e5:	79 05                	jns    8035ec <shutdown+0x2d>
		return r;
  8035e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ea:	eb 16                	jmp    803602 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8035ec:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f2:	89 d6                	mov    %edx,%esi
  8035f4:	89 c7                	mov    %eax,%edi
  8035f6:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
}
  803602:	c9                   	leaveq 
  803603:	c3                   	retq   

0000000000803604 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803604:	55                   	push   %rbp
  803605:	48 89 e5             	mov    %rsp,%rbp
  803608:	48 83 ec 10          	sub    $0x10,%rsp
  80360c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803614:	48 89 c7             	mov    %rax,%rdi
  803617:	48 b8 90 48 80 00 00 	movabs $0x804890,%rax
  80361e:	00 00 00 
  803621:	ff d0                	callq  *%rax
  803623:	83 f8 01             	cmp    $0x1,%eax
  803626:	75 17                	jne    80363f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362c:	8b 40 0c             	mov    0xc(%rax),%eax
  80362f:	89 c7                	mov    %eax,%edi
  803631:	48 b8 70 39 80 00 00 	movabs $0x803970,%rax
  803638:	00 00 00 
  80363b:	ff d0                	callq  *%rax
  80363d:	eb 05                	jmp    803644 <devsock_close+0x40>
	else
		return 0;
  80363f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803644:	c9                   	leaveq 
  803645:	c3                   	retq   

0000000000803646 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803646:	55                   	push   %rbp
  803647:	48 89 e5             	mov    %rsp,%rbp
  80364a:	48 83 ec 20          	sub    $0x20,%rsp
  80364e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803651:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803655:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803658:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80365b:	89 c7                	mov    %eax,%edi
  80365d:	48 b8 0c 34 80 00 00 	movabs $0x80340c,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
  803669:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80366c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803670:	79 05                	jns    803677 <connect+0x31>
		return r;
  803672:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803675:	eb 1b                	jmp    803692 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803677:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80367a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80367e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803681:	48 89 ce             	mov    %rcx,%rsi
  803684:	89 c7                	mov    %eax,%edi
  803686:	48 b8 9d 39 80 00 00 	movabs $0x80399d,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
}
  803692:	c9                   	leaveq 
  803693:	c3                   	retq   

0000000000803694 <listen>:

int
listen(int s, int backlog)
{
  803694:	55                   	push   %rbp
  803695:	48 89 e5             	mov    %rsp,%rbp
  803698:	48 83 ec 20          	sub    $0x20,%rsp
  80369c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80369f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a5:	89 c7                	mov    %eax,%edi
  8036a7:	48 b8 0c 34 80 00 00 	movabs $0x80340c,%rax
  8036ae:	00 00 00 
  8036b1:	ff d0                	callq  *%rax
  8036b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ba:	79 05                	jns    8036c1 <listen+0x2d>
		return r;
  8036bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bf:	eb 16                	jmp    8036d7 <listen+0x43>
	return nsipc_listen(r, backlog);
  8036c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c7:	89 d6                	mov    %edx,%esi
  8036c9:	89 c7                	mov    %eax,%edi
  8036cb:	48 b8 01 3a 80 00 00 	movabs $0x803a01,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
}
  8036d7:	c9                   	leaveq 
  8036d8:	c3                   	retq   

00000000008036d9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8036d9:	55                   	push   %rbp
  8036da:	48 89 e5             	mov    %rsp,%rbp
  8036dd:	48 83 ec 20          	sub    $0x20,%rsp
  8036e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f1:	89 c2                	mov    %eax,%edx
  8036f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f7:	8b 40 0c             	mov    0xc(%rax),%eax
  8036fa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  803703:	89 c7                	mov    %eax,%edi
  803705:	48 b8 41 3a 80 00 00 	movabs $0x803a41,%rax
  80370c:	00 00 00 
  80370f:	ff d0                	callq  *%rax
}
  803711:	c9                   	leaveq 
  803712:	c3                   	retq   

0000000000803713 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803713:	55                   	push   %rbp
  803714:	48 89 e5             	mov    %rsp,%rbp
  803717:	48 83 ec 20          	sub    $0x20,%rsp
  80371b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80371f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803723:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372b:	89 c2                	mov    %eax,%edx
  80372d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803731:	8b 40 0c             	mov    0xc(%rax),%eax
  803734:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803738:	b9 00 00 00 00       	mov    $0x0,%ecx
  80373d:	89 c7                	mov    %eax,%edi
  80373f:	48 b8 0d 3b 80 00 00 	movabs $0x803b0d,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
}
  80374b:	c9                   	leaveq 
  80374c:	c3                   	retq   

000000000080374d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80374d:	55                   	push   %rbp
  80374e:	48 89 e5             	mov    %rsp,%rbp
  803751:	48 83 ec 10          	sub    $0x10,%rsp
  803755:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803759:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80375d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803761:	48 be db 51 80 00 00 	movabs $0x8051db,%rsi
  803768:	00 00 00 
  80376b:	48 89 c7             	mov    %rax,%rdi
  80376e:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  803775:	00 00 00 
  803778:	ff d0                	callq  *%rax
	return 0;
  80377a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80377f:	c9                   	leaveq 
  803780:	c3                   	retq   

0000000000803781 <socket>:

int
socket(int domain, int type, int protocol)
{
  803781:	55                   	push   %rbp
  803782:	48 89 e5             	mov    %rsp,%rbp
  803785:	48 83 ec 20          	sub    $0x20,%rsp
  803789:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80378c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80378f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803792:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803795:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803798:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379b:	89 ce                	mov    %ecx,%esi
  80379d:	89 c7                	mov    %eax,%edi
  80379f:	48 b8 c5 3b 80 00 00 	movabs $0x803bc5,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	callq  *%rax
  8037ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b2:	79 05                	jns    8037b9 <socket+0x38>
		return r;
  8037b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b7:	eb 11                	jmp    8037ca <socket+0x49>
	return alloc_sockfd(r);
  8037b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037bc:	89 c7                	mov    %eax,%edi
  8037be:	48 b8 63 34 80 00 00 	movabs $0x803463,%rax
  8037c5:	00 00 00 
  8037c8:	ff d0                	callq  *%rax
}
  8037ca:	c9                   	leaveq 
  8037cb:	c3                   	retq   

00000000008037cc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8037cc:	55                   	push   %rbp
  8037cd:	48 89 e5             	mov    %rsp,%rbp
  8037d0:	48 83 ec 10          	sub    $0x10,%rsp
  8037d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8037d7:	48 b8 30 80 80 00 00 	movabs $0x808030,%rax
  8037de:	00 00 00 
  8037e1:	8b 00                	mov    (%rax),%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	75 1d                	jne    803804 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8037e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8037ec:	48 b8 0b 48 80 00 00 	movabs $0x80480b,%rax
  8037f3:	00 00 00 
  8037f6:	ff d0                	callq  *%rax
  8037f8:	48 ba 30 80 80 00 00 	movabs $0x808030,%rdx
  8037ff:	00 00 00 
  803802:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803804:	48 b8 30 80 80 00 00 	movabs $0x808030,%rax
  80380b:	00 00 00 
  80380e:	8b 00                	mov    (%rax),%eax
  803810:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803813:	b9 07 00 00 00       	mov    $0x7,%ecx
  803818:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80381f:	00 00 00 
  803822:	89 c7                	mov    %eax,%edi
  803824:	48 b8 48 47 80 00 00 	movabs $0x804748,%rax
  80382b:	00 00 00 
  80382e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803830:	ba 00 00 00 00       	mov    $0x0,%edx
  803835:	be 00 00 00 00       	mov    $0x0,%esi
  80383a:	bf 00 00 00 00       	mov    $0x0,%edi
  80383f:	48 b8 88 46 80 00 00 	movabs $0x804688,%rax
  803846:	00 00 00 
  803849:	ff d0                	callq  *%rax
}
  80384b:	c9                   	leaveq 
  80384c:	c3                   	retq   

000000000080384d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80384d:	55                   	push   %rbp
  80384e:	48 89 e5             	mov    %rsp,%rbp
  803851:	48 83 ec 30          	sub    $0x30,%rsp
  803855:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803858:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80385c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803860:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803867:	00 00 00 
  80386a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80386d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80386f:	bf 01 00 00 00       	mov    $0x1,%edi
  803874:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  80387b:	00 00 00 
  80387e:	ff d0                	callq  *%rax
  803880:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803883:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803887:	78 3e                	js     8038c7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803889:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803890:	00 00 00 
  803893:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389b:	8b 40 10             	mov    0x10(%rax),%eax
  80389e:	89 c2                	mov    %eax,%edx
  8038a0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8038a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a8:	48 89 ce             	mov    %rcx,%rsi
  8038ab:	48 89 c7             	mov    %rax,%rdi
  8038ae:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  8038b5:	00 00 00 
  8038b8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8038ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038be:	8b 50 10             	mov    0x10(%rax),%edx
  8038c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8038c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038ca:	c9                   	leaveq 
  8038cb:	c3                   	retq   

00000000008038cc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038cc:	55                   	push   %rbp
  8038cd:	48 89 e5             	mov    %rsp,%rbp
  8038d0:	48 83 ec 10          	sub    $0x10,%rsp
  8038d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038db:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8038de:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038e5:	00 00 00 
  8038e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038eb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f4:	48 89 c6             	mov    %rax,%rsi
  8038f7:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8038fe:	00 00 00 
  803901:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  803908:	00 00 00 
  80390b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80390d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803914:	00 00 00 
  803917:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80391a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80391d:	bf 02 00 00 00       	mov    $0x2,%edi
  803922:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
}
  80392e:	c9                   	leaveq 
  80392f:	c3                   	retq   

0000000000803930 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803930:	55                   	push   %rbp
  803931:	48 89 e5             	mov    %rsp,%rbp
  803934:	48 83 ec 10          	sub    $0x10,%rsp
  803938:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80393b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80393e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803945:	00 00 00 
  803948:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80394b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80394d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803954:	00 00 00 
  803957:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80395a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80395d:	bf 03 00 00 00       	mov    $0x3,%edi
  803962:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  803969:	00 00 00 
  80396c:	ff d0                	callq  *%rax
}
  80396e:	c9                   	leaveq 
  80396f:	c3                   	retq   

0000000000803970 <nsipc_close>:

int
nsipc_close(int s)
{
  803970:	55                   	push   %rbp
  803971:	48 89 e5             	mov    %rsp,%rbp
  803974:	48 83 ec 10          	sub    $0x10,%rsp
  803978:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80397b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803982:	00 00 00 
  803985:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803988:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80398a:	bf 04 00 00 00       	mov    $0x4,%edi
  80398f:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  803996:	00 00 00 
  803999:	ff d0                	callq  *%rax
}
  80399b:	c9                   	leaveq 
  80399c:	c3                   	retq   

000000000080399d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80399d:	55                   	push   %rbp
  80399e:	48 89 e5             	mov    %rsp,%rbp
  8039a1:	48 83 ec 10          	sub    $0x10,%rsp
  8039a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8039af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039b6:	00 00 00 
  8039b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039bc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8039be:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c5:	48 89 c6             	mov    %rax,%rsi
  8039c8:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8039cf:	00 00 00 
  8039d2:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  8039d9:	00 00 00 
  8039dc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8039de:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039e5:	00 00 00 
  8039e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039eb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8039ee:	bf 05 00 00 00       	mov    $0x5,%edi
  8039f3:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
}
  8039ff:	c9                   	leaveq 
  803a00:	c3                   	retq   

0000000000803a01 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a01:	55                   	push   %rbp
  803a02:	48 89 e5             	mov    %rsp,%rbp
  803a05:	48 83 ec 10          	sub    $0x10,%rsp
  803a09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a0f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a16:	00 00 00 
  803a19:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a1c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803a1e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a25:	00 00 00 
  803a28:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a2b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803a2e:	bf 06 00 00 00       	mov    $0x6,%edi
  803a33:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  803a3a:	00 00 00 
  803a3d:	ff d0                	callq  *%rax
}
  803a3f:	c9                   	leaveq 
  803a40:	c3                   	retq   

0000000000803a41 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a41:	55                   	push   %rbp
  803a42:	48 89 e5             	mov    %rsp,%rbp
  803a45:	48 83 ec 30          	sub    $0x30,%rsp
  803a49:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a50:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803a53:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803a56:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a5d:	00 00 00 
  803a60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a63:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803a65:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a6c:	00 00 00 
  803a6f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a72:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803a75:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a7c:	00 00 00 
  803a7f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a82:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a85:	bf 07 00 00 00       	mov    $0x7,%edi
  803a8a:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a9d:	78 69                	js     803b08 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803a9f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803aa6:	7f 08                	jg     803ab0 <nsipc_recv+0x6f>
  803aa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aab:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803aae:	7e 35                	jle    803ae5 <nsipc_recv+0xa4>
  803ab0:	48 b9 e2 51 80 00 00 	movabs $0x8051e2,%rcx
  803ab7:	00 00 00 
  803aba:	48 ba f7 51 80 00 00 	movabs $0x8051f7,%rdx
  803ac1:	00 00 00 
  803ac4:	be 61 00 00 00       	mov    $0x61,%esi
  803ac9:	48 bf 0c 52 80 00 00 	movabs $0x80520c,%rdi
  803ad0:	00 00 00 
  803ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad8:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  803adf:	00 00 00 
  803ae2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae8:	48 63 d0             	movslq %eax,%rdx
  803aeb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aef:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803af6:	00 00 00 
  803af9:	48 89 c7             	mov    %rax,%rdi
  803afc:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  803b03:	00 00 00 
  803b06:	ff d0                	callq  *%rax
	}

	return r;
  803b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b0b:	c9                   	leaveq 
  803b0c:	c3                   	retq   

0000000000803b0d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b0d:	55                   	push   %rbp
  803b0e:	48 89 e5             	mov    %rsp,%rbp
  803b11:	48 83 ec 20          	sub    $0x20,%rsp
  803b15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b1c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803b1f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803b22:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b29:	00 00 00 
  803b2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b2f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b31:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803b38:	7e 35                	jle    803b6f <nsipc_send+0x62>
  803b3a:	48 b9 18 52 80 00 00 	movabs $0x805218,%rcx
  803b41:	00 00 00 
  803b44:	48 ba f7 51 80 00 00 	movabs $0x8051f7,%rdx
  803b4b:	00 00 00 
  803b4e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803b53:	48 bf 0c 52 80 00 00 	movabs $0x80520c,%rdi
  803b5a:	00 00 00 
  803b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b62:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  803b69:	00 00 00 
  803b6c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b72:	48 63 d0             	movslq %eax,%rdx
  803b75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b79:	48 89 c6             	mov    %rax,%rsi
  803b7c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803b83:	00 00 00 
  803b86:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803b92:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b99:	00 00 00 
  803b9c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b9f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803ba2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ba9:	00 00 00 
  803bac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803baf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803bb2:	bf 08 00 00 00       	mov    $0x8,%edi
  803bb7:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  803bbe:	00 00 00 
  803bc1:	ff d0                	callq  *%rax
}
  803bc3:	c9                   	leaveq 
  803bc4:	c3                   	retq   

0000000000803bc5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803bc5:	55                   	push   %rbp
  803bc6:	48 89 e5             	mov    %rsp,%rbp
  803bc9:	48 83 ec 10          	sub    $0x10,%rsp
  803bcd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bd0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803bd3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803bd6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bdd:	00 00 00 
  803be0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803be3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803be5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bec:	00 00 00 
  803bef:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bf2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803bf5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bfc:	00 00 00 
  803bff:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c02:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c05:	bf 09 00 00 00       	mov    $0x9,%edi
  803c0a:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  803c11:	00 00 00 
  803c14:	ff d0                	callq  *%rax
}
  803c16:	c9                   	leaveq 
  803c17:	c3                   	retq   

0000000000803c18 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c18:	55                   	push   %rbp
  803c19:	48 89 e5             	mov    %rsp,%rbp
  803c1c:	53                   	push   %rbx
  803c1d:	48 83 ec 38          	sub    $0x38,%rsp
  803c21:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c25:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c29:	48 89 c7             	mov    %rax,%rdi
  803c2c:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  803c33:	00 00 00 
  803c36:	ff d0                	callq  *%rax
  803c38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c3f:	0f 88 bf 01 00 00    	js     803e04 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c49:	ba 07 04 00 00       	mov    $0x407,%edx
  803c4e:	48 89 c6             	mov    %rax,%rsi
  803c51:	bf 00 00 00 00       	mov    $0x0,%edi
  803c56:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  803c5d:	00 00 00 
  803c60:	ff d0                	callq  *%rax
  803c62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c65:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c69:	0f 88 95 01 00 00    	js     803e04 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c6f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c73:	48 89 c7             	mov    %rax,%rdi
  803c76:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  803c7d:	00 00 00 
  803c80:	ff d0                	callq  *%rax
  803c82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c89:	0f 88 5d 01 00 00    	js     803dec <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c93:	ba 07 04 00 00       	mov    $0x407,%edx
  803c98:	48 89 c6             	mov    %rax,%rsi
  803c9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca0:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  803ca7:	00 00 00 
  803caa:	ff d0                	callq  *%rax
  803cac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803caf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cb3:	0f 88 33 01 00 00    	js     803dec <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803cb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cbd:	48 89 c7             	mov    %rax,%rdi
  803cc0:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
  803ccc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd4:	ba 07 04 00 00       	mov    $0x407,%edx
  803cd9:	48 89 c6             	mov    %rax,%rsi
  803cdc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ce1:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  803ce8:	00 00 00 
  803ceb:	ff d0                	callq  *%rax
  803ced:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cf0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cf4:	0f 88 d9 00 00 00    	js     803dd3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cfa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cfe:	48 89 c7             	mov    %rax,%rdi
  803d01:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
  803d0d:	48 89 c2             	mov    %rax,%rdx
  803d10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d14:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d1a:	48 89 d1             	mov    %rdx,%rcx
  803d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  803d22:	48 89 c6             	mov    %rax,%rsi
  803d25:	bf 00 00 00 00       	mov    $0x0,%edi
  803d2a:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803d31:	00 00 00 
  803d34:	ff d0                	callq  *%rax
  803d36:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d3d:	78 79                	js     803db8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803d3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d43:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803d4a:	00 00 00 
  803d4d:	8b 12                	mov    (%rdx),%edx
  803d4f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d60:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803d67:	00 00 00 
  803d6a:	8b 12                	mov    (%rdx),%edx
  803d6c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d72:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803d79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7d:	48 89 c7             	mov    %rax,%rdi
  803d80:	48 b8 04 27 80 00 00 	movabs $0x802704,%rax
  803d87:	00 00 00 
  803d8a:	ff d0                	callq  *%rax
  803d8c:	89 c2                	mov    %eax,%edx
  803d8e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d92:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803d94:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d98:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da0:	48 89 c7             	mov    %rax,%rdi
  803da3:	48 b8 04 27 80 00 00 	movabs $0x802704,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
  803daf:	89 03                	mov    %eax,(%rbx)
	return 0;
  803db1:	b8 00 00 00 00       	mov    $0x0,%eax
  803db6:	eb 4f                	jmp    803e07 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803db8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803db9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dbd:	48 89 c6             	mov    %rax,%rsi
  803dc0:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc5:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  803dcc:	00 00 00 
  803dcf:	ff d0                	callq  *%rax
  803dd1:	eb 01                	jmp    803dd4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803dd3:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803dd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dd8:	48 89 c6             	mov    %rax,%rsi
  803ddb:	bf 00 00 00 00       	mov    $0x0,%edi
  803de0:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  803de7:	00 00 00 
  803dea:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803dec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803df0:	48 89 c6             	mov    %rax,%rsi
  803df3:	bf 00 00 00 00       	mov    $0x0,%edi
  803df8:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  803dff:	00 00 00 
  803e02:	ff d0                	callq  *%rax
    err:
	return r;
  803e04:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e07:	48 83 c4 38          	add    $0x38,%rsp
  803e0b:	5b                   	pop    %rbx
  803e0c:	5d                   	pop    %rbp
  803e0d:	c3                   	retq   

0000000000803e0e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e0e:	55                   	push   %rbp
  803e0f:	48 89 e5             	mov    %rsp,%rbp
  803e12:	53                   	push   %rbx
  803e13:	48 83 ec 28          	sub    $0x28,%rsp
  803e17:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e1f:	eb 01                	jmp    803e22 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803e21:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e22:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  803e29:	00 00 00 
  803e2c:	48 8b 00             	mov    (%rax),%rax
  803e2f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e35:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e3c:	48 89 c7             	mov    %rax,%rdi
  803e3f:	48 b8 90 48 80 00 00 	movabs $0x804890,%rax
  803e46:	00 00 00 
  803e49:	ff d0                	callq  *%rax
  803e4b:	89 c3                	mov    %eax,%ebx
  803e4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e51:	48 89 c7             	mov    %rax,%rdi
  803e54:	48 b8 90 48 80 00 00 	movabs $0x804890,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
  803e60:	39 c3                	cmp    %eax,%ebx
  803e62:	0f 94 c0             	sete   %al
  803e65:	0f b6 c0             	movzbl %al,%eax
  803e68:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e6b:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  803e72:	00 00 00 
  803e75:	48 8b 00             	mov    (%rax),%rax
  803e78:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e7e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e84:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e87:	75 0a                	jne    803e93 <_pipeisclosed+0x85>
			return ret;
  803e89:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803e8c:	48 83 c4 28          	add    $0x28,%rsp
  803e90:	5b                   	pop    %rbx
  803e91:	5d                   	pop    %rbp
  803e92:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803e93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e96:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e99:	74 86                	je     803e21 <_pipeisclosed+0x13>
  803e9b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803e9f:	75 80                	jne    803e21 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ea1:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  803ea8:	00 00 00 
  803eab:	48 8b 00             	mov    (%rax),%rax
  803eae:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803eb4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803eb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803eba:	89 c6                	mov    %eax,%esi
  803ebc:	48 bf 29 52 80 00 00 	movabs $0x805229,%rdi
  803ec3:	00 00 00 
  803ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  803ecb:	49 b8 0b 08 80 00 00 	movabs $0x80080b,%r8
  803ed2:	00 00 00 
  803ed5:	41 ff d0             	callq  *%r8
	}
  803ed8:	e9 44 ff ff ff       	jmpq   803e21 <_pipeisclosed+0x13>

0000000000803edd <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803edd:	55                   	push   %rbp
  803ede:	48 89 e5             	mov    %rsp,%rbp
  803ee1:	48 83 ec 30          	sub    $0x30,%rsp
  803ee5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ee8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803eec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803eef:	48 89 d6             	mov    %rdx,%rsi
  803ef2:	89 c7                	mov    %eax,%edi
  803ef4:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  803efb:	00 00 00 
  803efe:	ff d0                	callq  *%rax
  803f00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f07:	79 05                	jns    803f0e <pipeisclosed+0x31>
		return r;
  803f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f0c:	eb 31                	jmp    803f3f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f12:	48 89 c7             	mov    %rax,%rdi
  803f15:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  803f1c:	00 00 00 
  803f1f:	ff d0                	callq  *%rax
  803f21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f2d:	48 89 d6             	mov    %rdx,%rsi
  803f30:	48 89 c7             	mov    %rax,%rdi
  803f33:	48 b8 0e 3e 80 00 00 	movabs $0x803e0e,%rax
  803f3a:	00 00 00 
  803f3d:	ff d0                	callq  *%rax
}
  803f3f:	c9                   	leaveq 
  803f40:	c3                   	retq   

0000000000803f41 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f41:	55                   	push   %rbp
  803f42:	48 89 e5             	mov    %rsp,%rbp
  803f45:	48 83 ec 40          	sub    $0x40,%rsp
  803f49:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f4d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f51:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f59:	48 89 c7             	mov    %rax,%rdi
  803f5c:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  803f63:	00 00 00 
  803f66:	ff d0                	callq  *%rax
  803f68:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f74:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f7b:	00 
  803f7c:	e9 97 00 00 00       	jmpq   804018 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f81:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f86:	74 09                	je     803f91 <devpipe_read+0x50>
				return i;
  803f88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8c:	e9 95 00 00 00       	jmpq   804026 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803f91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f99:	48 89 d6             	mov    %rdx,%rsi
  803f9c:	48 89 c7             	mov    %rax,%rdi
  803f9f:	48 b8 0e 3e 80 00 00 	movabs $0x803e0e,%rax
  803fa6:	00 00 00 
  803fa9:	ff d0                	callq  *%rax
  803fab:	85 c0                	test   %eax,%eax
  803fad:	74 07                	je     803fb6 <devpipe_read+0x75>
				return 0;
  803faf:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb4:	eb 70                	jmp    804026 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803fb6:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  803fbd:	00 00 00 
  803fc0:	ff d0                	callq  *%rax
  803fc2:	eb 01                	jmp    803fc5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803fc4:	90                   	nop
  803fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc9:	8b 10                	mov    (%rax),%edx
  803fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fcf:	8b 40 04             	mov    0x4(%rax),%eax
  803fd2:	39 c2                	cmp    %eax,%edx
  803fd4:	74 ab                	je     803f81 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fde:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe6:	8b 00                	mov    (%rax),%eax
  803fe8:	89 c2                	mov    %eax,%edx
  803fea:	c1 fa 1f             	sar    $0x1f,%edx
  803fed:	c1 ea 1b             	shr    $0x1b,%edx
  803ff0:	01 d0                	add    %edx,%eax
  803ff2:	83 e0 1f             	and    $0x1f,%eax
  803ff5:	29 d0                	sub    %edx,%eax
  803ff7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ffb:	48 98                	cltq   
  803ffd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804002:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804008:	8b 00                	mov    (%rax),%eax
  80400a:	8d 50 01             	lea    0x1(%rax),%edx
  80400d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804011:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804013:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804018:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80401c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804020:	72 a2                	jb     803fc4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804022:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804026:	c9                   	leaveq 
  804027:	c3                   	retq   

0000000000804028 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804028:	55                   	push   %rbp
  804029:	48 89 e5             	mov    %rsp,%rbp
  80402c:	48 83 ec 40          	sub    $0x40,%rsp
  804030:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804034:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804038:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80403c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804040:	48 89 c7             	mov    %rax,%rdi
  804043:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  80404a:	00 00 00 
  80404d:	ff d0                	callq  *%rax
  80404f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804053:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804057:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80405b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804062:	00 
  804063:	e9 93 00 00 00       	jmpq   8040fb <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804068:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80406c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804070:	48 89 d6             	mov    %rdx,%rsi
  804073:	48 89 c7             	mov    %rax,%rdi
  804076:	48 b8 0e 3e 80 00 00 	movabs $0x803e0e,%rax
  80407d:	00 00 00 
  804080:	ff d0                	callq  *%rax
  804082:	85 c0                	test   %eax,%eax
  804084:	74 07                	je     80408d <devpipe_write+0x65>
				return 0;
  804086:	b8 00 00 00 00       	mov    $0x0,%eax
  80408b:	eb 7c                	jmp    804109 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80408d:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  804094:	00 00 00 
  804097:	ff d0                	callq  *%rax
  804099:	eb 01                	jmp    80409c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80409b:	90                   	nop
  80409c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a0:	8b 40 04             	mov    0x4(%rax),%eax
  8040a3:	48 63 d0             	movslq %eax,%rdx
  8040a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040aa:	8b 00                	mov    (%rax),%eax
  8040ac:	48 98                	cltq   
  8040ae:	48 83 c0 20          	add    $0x20,%rax
  8040b2:	48 39 c2             	cmp    %rax,%rdx
  8040b5:	73 b1                	jae    804068 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8040b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040bb:	8b 40 04             	mov    0x4(%rax),%eax
  8040be:	89 c2                	mov    %eax,%edx
  8040c0:	c1 fa 1f             	sar    $0x1f,%edx
  8040c3:	c1 ea 1b             	shr    $0x1b,%edx
  8040c6:	01 d0                	add    %edx,%eax
  8040c8:	83 e0 1f             	and    $0x1f,%eax
  8040cb:	29 d0                	sub    %edx,%eax
  8040cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8040d1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8040d5:	48 01 ca             	add    %rcx,%rdx
  8040d8:	0f b6 0a             	movzbl (%rdx),%ecx
  8040db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040df:	48 98                	cltq   
  8040e1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8040e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e9:	8b 40 04             	mov    0x4(%rax),%eax
  8040ec:	8d 50 01             	lea    0x1(%rax),%edx
  8040ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804103:	72 96                	jb     80409b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804109:	c9                   	leaveq 
  80410a:	c3                   	retq   

000000000080410b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80410b:	55                   	push   %rbp
  80410c:	48 89 e5             	mov    %rsp,%rbp
  80410f:	48 83 ec 20          	sub    $0x20,%rsp
  804113:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804117:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80411b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80411f:	48 89 c7             	mov    %rax,%rdi
  804122:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  804129:	00 00 00 
  80412c:	ff d0                	callq  *%rax
  80412e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804132:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804136:	48 be 3c 52 80 00 00 	movabs $0x80523c,%rsi
  80413d:	00 00 00 
  804140:	48 89 c7             	mov    %rax,%rdi
  804143:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  80414a:	00 00 00 
  80414d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80414f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804153:	8b 50 04             	mov    0x4(%rax),%edx
  804156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80415a:	8b 00                	mov    (%rax),%eax
  80415c:	29 c2                	sub    %eax,%edx
  80415e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804162:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804168:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80416c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804173:	00 00 00 
	stat->st_dev = &devpipe;
  804176:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80417a:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804181:	00 00 00 
  804184:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80418b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804190:	c9                   	leaveq 
  804191:	c3                   	retq   

0000000000804192 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804192:	55                   	push   %rbp
  804193:	48 89 e5             	mov    %rsp,%rbp
  804196:	48 83 ec 10          	sub    $0x10,%rsp
  80419a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80419e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a2:	48 89 c6             	mov    %rax,%rsi
  8041a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8041aa:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8041b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ba:	48 89 c7             	mov    %rax,%rdi
  8041bd:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  8041c4:	00 00 00 
  8041c7:	ff d0                	callq  *%rax
  8041c9:	48 89 c6             	mov    %rax,%rsi
  8041cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8041d1:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8041d8:	00 00 00 
  8041db:	ff d0                	callq  *%rax
}
  8041dd:	c9                   	leaveq 
  8041de:	c3                   	retq   
	...

00000000008041e0 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8041e0:	55                   	push   %rbp
  8041e1:	48 89 e5             	mov    %rsp,%rbp
  8041e4:	48 83 ec 20          	sub    $0x20,%rsp
  8041e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8041eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041ef:	75 35                	jne    804226 <wait+0x46>
  8041f1:	48 b9 43 52 80 00 00 	movabs $0x805243,%rcx
  8041f8:	00 00 00 
  8041fb:	48 ba 4e 52 80 00 00 	movabs $0x80524e,%rdx
  804202:	00 00 00 
  804205:	be 09 00 00 00       	mov    $0x9,%esi
  80420a:	48 bf 63 52 80 00 00 	movabs $0x805263,%rdi
  804211:	00 00 00 
  804214:	b8 00 00 00 00       	mov    $0x0,%eax
  804219:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  804220:	00 00 00 
  804223:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804226:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804229:	48 98                	cltq   
  80422b:	48 89 c2             	mov    %rax,%rdx
  80422e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  804234:	48 89 d0             	mov    %rdx,%rax
  804237:	48 c1 e0 03          	shl    $0x3,%rax
  80423b:	48 01 d0             	add    %rdx,%rax
  80423e:	48 c1 e0 05          	shl    $0x5,%rax
  804242:	48 89 c2             	mov    %rax,%rdx
  804245:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80424c:	00 00 00 
  80424f:	48 01 d0             	add    %rdx,%rax
  804252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804256:	eb 0c                	jmp    804264 <wait+0x84>
		sys_yield();
  804258:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  80425f:	00 00 00 
  804262:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804268:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80426e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804271:	75 0e                	jne    804281 <wait+0xa1>
  804273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804277:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80427d:	85 c0                	test   %eax,%eax
  80427f:	75 d7                	jne    804258 <wait+0x78>
		sys_yield();
}
  804281:	c9                   	leaveq 
  804282:	c3                   	retq   
	...

0000000000804284 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804284:	55                   	push   %rbp
  804285:	48 89 e5             	mov    %rsp,%rbp
  804288:	48 83 ec 20          	sub    $0x20,%rsp
  80428c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80428f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804292:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804295:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804299:	be 01 00 00 00       	mov    $0x1,%esi
  80429e:	48 89 c7             	mov    %rax,%rdi
  8042a1:	48 b8 b8 1b 80 00 00 	movabs $0x801bb8,%rax
  8042a8:	00 00 00 
  8042ab:	ff d0                	callq  *%rax
}
  8042ad:	c9                   	leaveq 
  8042ae:	c3                   	retq   

00000000008042af <getchar>:

int
getchar(void)
{
  8042af:	55                   	push   %rbp
  8042b0:	48 89 e5             	mov    %rsp,%rbp
  8042b3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8042b7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8042bb:	ba 01 00 00 00       	mov    $0x1,%edx
  8042c0:	48 89 c6             	mov    %rax,%rsi
  8042c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8042c8:	48 b8 1c 2c 80 00 00 	movabs $0x802c1c,%rax
  8042cf:	00 00 00 
  8042d2:	ff d0                	callq  *%rax
  8042d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8042d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042db:	79 05                	jns    8042e2 <getchar+0x33>
		return r;
  8042dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e0:	eb 14                	jmp    8042f6 <getchar+0x47>
	if (r < 1)
  8042e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042e6:	7f 07                	jg     8042ef <getchar+0x40>
		return -E_EOF;
  8042e8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8042ed:	eb 07                	jmp    8042f6 <getchar+0x47>
	return c;
  8042ef:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8042f3:	0f b6 c0             	movzbl %al,%eax
}
  8042f6:	c9                   	leaveq 
  8042f7:	c3                   	retq   

00000000008042f8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042f8:	55                   	push   %rbp
  8042f9:	48 89 e5             	mov    %rsp,%rbp
  8042fc:	48 83 ec 20          	sub    $0x20,%rsp
  804300:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804303:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804307:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80430a:	48 89 d6             	mov    %rdx,%rsi
  80430d:	89 c7                	mov    %eax,%edi
  80430f:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  804316:	00 00 00 
  804319:	ff d0                	callq  *%rax
  80431b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80431e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804322:	79 05                	jns    804329 <iscons+0x31>
		return r;
  804324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804327:	eb 1a                	jmp    804343 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80432d:	8b 10                	mov    (%rax),%edx
  80432f:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804336:	00 00 00 
  804339:	8b 00                	mov    (%rax),%eax
  80433b:	39 c2                	cmp    %eax,%edx
  80433d:	0f 94 c0             	sete   %al
  804340:	0f b6 c0             	movzbl %al,%eax
}
  804343:	c9                   	leaveq 
  804344:	c3                   	retq   

0000000000804345 <opencons>:

int
opencons(void)
{
  804345:	55                   	push   %rbp
  804346:	48 89 e5             	mov    %rsp,%rbp
  804349:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80434d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804351:	48 89 c7             	mov    %rax,%rdi
  804354:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  80435b:	00 00 00 
  80435e:	ff d0                	callq  *%rax
  804360:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804363:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804367:	79 05                	jns    80436e <opencons+0x29>
		return r;
  804369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80436c:	eb 5b                	jmp    8043c9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80436e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804372:	ba 07 04 00 00       	mov    $0x407,%edx
  804377:	48 89 c6             	mov    %rax,%rsi
  80437a:	bf 00 00 00 00       	mov    $0x0,%edi
  80437f:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  804386:	00 00 00 
  804389:	ff d0                	callq  *%rax
  80438b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80438e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804392:	79 05                	jns    804399 <opencons+0x54>
		return r;
  804394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804397:	eb 30                	jmp    8043c9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439d:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8043a4:	00 00 00 
  8043a7:	8b 12                	mov    (%rdx),%edx
  8043a9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8043ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8043b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ba:	48 89 c7             	mov    %rax,%rdi
  8043bd:	48 b8 04 27 80 00 00 	movabs $0x802704,%rax
  8043c4:	00 00 00 
  8043c7:	ff d0                	callq  *%rax
}
  8043c9:	c9                   	leaveq 
  8043ca:	c3                   	retq   

00000000008043cb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043cb:	55                   	push   %rbp
  8043cc:	48 89 e5             	mov    %rsp,%rbp
  8043cf:	48 83 ec 30          	sub    $0x30,%rsp
  8043d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043e4:	75 13                	jne    8043f9 <devcons_read+0x2e>
		return 0;
  8043e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8043eb:	eb 49                	jmp    804436 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8043ed:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  8043f4:	00 00 00 
  8043f7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8043f9:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  804400:	00 00 00 
  804403:	ff d0                	callq  *%rax
  804405:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804408:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80440c:	74 df                	je     8043ed <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80440e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804412:	79 05                	jns    804419 <devcons_read+0x4e>
		return c;
  804414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804417:	eb 1d                	jmp    804436 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804419:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80441d:	75 07                	jne    804426 <devcons_read+0x5b>
		return 0;
  80441f:	b8 00 00 00 00       	mov    $0x0,%eax
  804424:	eb 10                	jmp    804436 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804429:	89 c2                	mov    %eax,%edx
  80442b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80442f:	88 10                	mov    %dl,(%rax)
	return 1;
  804431:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804436:	c9                   	leaveq 
  804437:	c3                   	retq   

0000000000804438 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804438:	55                   	push   %rbp
  804439:	48 89 e5             	mov    %rsp,%rbp
  80443c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804443:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80444a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804451:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80445f:	eb 77                	jmp    8044d8 <devcons_write+0xa0>
		m = n - tot;
  804461:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804468:	89 c2                	mov    %eax,%edx
  80446a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80446d:	89 d1                	mov    %edx,%ecx
  80446f:	29 c1                	sub    %eax,%ecx
  804471:	89 c8                	mov    %ecx,%eax
  804473:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804476:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804479:	83 f8 7f             	cmp    $0x7f,%eax
  80447c:	76 07                	jbe    804485 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80447e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804485:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804488:	48 63 d0             	movslq %eax,%rdx
  80448b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80448e:	48 98                	cltq   
  804490:	48 89 c1             	mov    %rax,%rcx
  804493:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80449a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044a1:	48 89 ce             	mov    %rcx,%rsi
  8044a4:	48 89 c7             	mov    %rax,%rdi
  8044a7:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  8044ae:	00 00 00 
  8044b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8044b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044b6:	48 63 d0             	movslq %eax,%rdx
  8044b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044c0:	48 89 d6             	mov    %rdx,%rsi
  8044c3:	48 89 c7             	mov    %rax,%rdi
  8044c6:	48 b8 b8 1b 80 00 00 	movabs $0x801bb8,%rax
  8044cd:	00 00 00 
  8044d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044db:	48 98                	cltq   
  8044dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044e4:	0f 82 77 ff ff ff    	jb     804461 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8044ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044ed:	c9                   	leaveq 
  8044ee:	c3                   	retq   

00000000008044ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8044ef:	55                   	push   %rbp
  8044f0:	48 89 e5             	mov    %rsp,%rbp
  8044f3:	48 83 ec 08          	sub    $0x8,%rsp
  8044f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804500:	c9                   	leaveq 
  804501:	c3                   	retq   

0000000000804502 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804502:	55                   	push   %rbp
  804503:	48 89 e5             	mov    %rsp,%rbp
  804506:	48 83 ec 10          	sub    $0x10,%rsp
  80450a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80450e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804516:	48 be 73 52 80 00 00 	movabs $0x805273,%rsi
  80451d:	00 00 00 
  804520:	48 89 c7             	mov    %rax,%rdi
  804523:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  80452a:	00 00 00 
  80452d:	ff d0                	callq  *%rax
	return 0;
  80452f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804534:	c9                   	leaveq 
  804535:	c3                   	retq   
	...

0000000000804538 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804538:	55                   	push   %rbp
  804539:	48 89 e5             	mov    %rsp,%rbp
  80453c:	48 83 ec 20          	sub    $0x20,%rsp
  804540:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  804544:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80454b:	00 00 00 
  80454e:	48 8b 00             	mov    (%rax),%rax
  804551:	48 85 c0             	test   %rax,%rax
  804554:	0f 85 8e 00 00 00    	jne    8045e8 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  80455a:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804561:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  804568:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  80456f:	00 00 00 
  804572:	ff d0                	callq  *%rax
  804574:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  804577:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80457b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80457e:	ba 07 00 00 00       	mov    $0x7,%edx
  804583:	48 89 ce             	mov    %rcx,%rsi
  804586:	89 c7                	mov    %eax,%edi
  804588:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  80458f:	00 00 00 
  804592:	ff d0                	callq  *%rax
  804594:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  804597:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80459b:	74 30                	je     8045cd <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  80459d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8045a0:	89 c1                	mov    %eax,%ecx
  8045a2:	48 ba 80 52 80 00 00 	movabs $0x805280,%rdx
  8045a9:	00 00 00 
  8045ac:	be 24 00 00 00       	mov    $0x24,%esi
  8045b1:	48 bf b7 52 80 00 00 	movabs $0x8052b7,%rdi
  8045b8:	00 00 00 
  8045bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c0:	49 b8 d0 05 80 00 00 	movabs $0x8005d0,%r8
  8045c7:	00 00 00 
  8045ca:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8045cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8045d0:	48 be fc 45 80 00 00 	movabs $0x8045fc,%rsi
  8045d7:	00 00 00 
  8045da:	89 c7                	mov    %eax,%edi
  8045dc:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  8045e3:	00 00 00 
  8045e6:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8045e8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045ef:	00 00 00 
  8045f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8045f6:	48 89 10             	mov    %rdx,(%rax)
}
  8045f9:	c9                   	leaveq 
  8045fa:	c3                   	retq   
	...

00000000008045fc <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8045fc:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8045ff:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804606:	00 00 00 
	call *%rax
  804609:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  80460b:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  80460f:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  804613:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  804616:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80461d:	00 
		movq 120(%rsp), %rcx				// trap time rip
  80461e:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  804623:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  804626:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  804627:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  80462a:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  804631:	00 08 
		POPA_						// copy the register contents to the registers
  804633:	4c 8b 3c 24          	mov    (%rsp),%r15
  804637:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80463c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804641:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804646:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80464b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804650:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804655:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80465a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80465f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804664:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804669:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80466e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804673:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804678:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80467d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804681:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  804685:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  804686:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  804687:	c3                   	retq   

0000000000804688 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804688:	55                   	push   %rbp
  804689:	48 89 e5             	mov    %rsp,%rbp
  80468c:	48 83 ec 30          	sub    $0x30,%rsp
  804690:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804694:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804698:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  80469c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8046a1:	74 18                	je     8046bb <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8046a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046a7:	48 89 c7             	mov    %rax,%rdi
  8046aa:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  8046b1:	00 00 00 
  8046b4:	ff d0                	callq  *%rax
  8046b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046b9:	eb 19                	jmp    8046d4 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  8046bb:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8046c2:	00 00 00 
  8046c5:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  8046cc:	00 00 00 
  8046cf:	ff d0                	callq  *%rax
  8046d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8046d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046d8:	79 19                	jns    8046f3 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8046da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046de:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8046e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046e8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8046ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f1:	eb 53                	jmp    804746 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8046f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8046f8:	74 19                	je     804713 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8046fa:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  804701:	00 00 00 
  804704:	48 8b 00             	mov    (%rax),%rax
  804707:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80470d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804711:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  804713:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804718:	74 19                	je     804733 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  80471a:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  804721:	00 00 00 
  804724:	48 8b 00             	mov    (%rax),%rax
  804727:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80472d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804731:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804733:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  80473a:	00 00 00 
  80473d:	48 8b 00             	mov    (%rax),%rax
  804740:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  804746:	c9                   	leaveq 
  804747:	c3                   	retq   

0000000000804748 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804748:	55                   	push   %rbp
  804749:	48 89 e5             	mov    %rsp,%rbp
  80474c:	48 83 ec 30          	sub    $0x30,%rsp
  804750:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804753:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804756:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80475a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  80475d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804764:	e9 96 00 00 00       	jmpq   8047ff <ipc_send+0xb7>
	{
		if(pg!=NULL)
  804769:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80476e:	74 20                	je     804790 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  804770:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804773:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804776:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80477a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80477d:	89 c7                	mov    %eax,%edi
  80477f:	48 b8 d4 1e 80 00 00 	movabs $0x801ed4,%rax
  804786:	00 00 00 
  804789:	ff d0                	callq  *%rax
  80478b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80478e:	eb 2d                	jmp    8047bd <ipc_send+0x75>
		else if(pg==NULL)
  804790:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804795:	75 26                	jne    8047bd <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  804797:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80479a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80479d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8047a2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8047a9:	00 00 00 
  8047ac:	89 c7                	mov    %eax,%edi
  8047ae:	48 b8 d4 1e 80 00 00 	movabs $0x801ed4,%rax
  8047b5:	00 00 00 
  8047b8:	ff d0                	callq  *%rax
  8047ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8047bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047c1:	79 30                	jns    8047f3 <ipc_send+0xab>
  8047c3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047c7:	74 2a                	je     8047f3 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8047c9:	48 ba c5 52 80 00 00 	movabs $0x8052c5,%rdx
  8047d0:	00 00 00 
  8047d3:	be 40 00 00 00       	mov    $0x40,%esi
  8047d8:	48 bf dd 52 80 00 00 	movabs $0x8052dd,%rdi
  8047df:	00 00 00 
  8047e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8047e7:	48 b9 d0 05 80 00 00 	movabs $0x8005d0,%rcx
  8047ee:	00 00 00 
  8047f1:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8047f3:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  8047fa:	00 00 00 
  8047fd:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8047ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804803:	0f 85 60 ff ff ff    	jne    804769 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  804809:	c9                   	leaveq 
  80480a:	c3                   	retq   

000000000080480b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80480b:	55                   	push   %rbp
  80480c:	48 89 e5             	mov    %rsp,%rbp
  80480f:	48 83 ec 18          	sub    $0x18,%rsp
  804813:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804816:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80481d:	eb 5e                	jmp    80487d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80481f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804826:	00 00 00 
  804829:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80482c:	48 63 d0             	movslq %eax,%rdx
  80482f:	48 89 d0             	mov    %rdx,%rax
  804832:	48 c1 e0 03          	shl    $0x3,%rax
  804836:	48 01 d0             	add    %rdx,%rax
  804839:	48 c1 e0 05          	shl    $0x5,%rax
  80483d:	48 01 c8             	add    %rcx,%rax
  804840:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804846:	8b 00                	mov    (%rax),%eax
  804848:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80484b:	75 2c                	jne    804879 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80484d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804854:	00 00 00 
  804857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80485a:	48 63 d0             	movslq %eax,%rdx
  80485d:	48 89 d0             	mov    %rdx,%rax
  804860:	48 c1 e0 03          	shl    $0x3,%rax
  804864:	48 01 d0             	add    %rdx,%rax
  804867:	48 c1 e0 05          	shl    $0x5,%rax
  80486b:	48 01 c8             	add    %rcx,%rax
  80486e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804874:	8b 40 08             	mov    0x8(%rax),%eax
  804877:	eb 12                	jmp    80488b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804879:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80487d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804884:	7e 99                	jle    80481f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80488b:	c9                   	leaveq 
  80488c:	c3                   	retq   
  80488d:	00 00                	add    %al,(%rax)
	...

0000000000804890 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804890:	55                   	push   %rbp
  804891:	48 89 e5             	mov    %rsp,%rbp
  804894:	48 83 ec 18          	sub    $0x18,%rsp
  804898:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80489c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048a0:	48 89 c2             	mov    %rax,%rdx
  8048a3:	48 c1 ea 15          	shr    $0x15,%rdx
  8048a7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8048ae:	01 00 00 
  8048b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048b5:	83 e0 01             	and    $0x1,%eax
  8048b8:	48 85 c0             	test   %rax,%rax
  8048bb:	75 07                	jne    8048c4 <pageref+0x34>
		return 0;
  8048bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8048c2:	eb 53                	jmp    804917 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048c8:	48 89 c2             	mov    %rax,%rdx
  8048cb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8048cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048d6:	01 00 00 
  8048d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e5:	83 e0 01             	and    $0x1,%eax
  8048e8:	48 85 c0             	test   %rax,%rax
  8048eb:	75 07                	jne    8048f4 <pageref+0x64>
		return 0;
  8048ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8048f2:	eb 23                	jmp    804917 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048f8:	48 89 c2             	mov    %rax,%rdx
  8048fb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8048ff:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804906:	00 00 00 
  804909:	48 c1 e2 04          	shl    $0x4,%rdx
  80490d:	48 01 d0             	add    %rdx,%rax
  804910:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804914:	0f b7 c0             	movzwl %ax,%eax
}
  804917:	c9                   	leaveq 
  804918:	c3                   	retq   
