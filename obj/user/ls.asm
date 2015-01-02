
obj/user/ls.debug:     file format elf64-x86-64


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
  80003c:	e8 e3 04 00 00       	callq  800524 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004f:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800056:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005d:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800064:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006b:	48 89 d6             	mov    %rdx,%rsi
  80006e:	48 89 c7             	mov    %rax,%rdi
  800071:	48 b8 44 2c 80 00 00 	movabs $0x802c44,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
  80007d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800080:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800084:	79 3b                	jns    8000c1 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800086:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800089:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800090:	41 89 d0             	mov    %edx,%r8d
  800093:	48 89 c1             	mov    %rax,%rcx
  800096:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  80009d:	00 00 00 
  8000a0:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a5:	48 bf 8c 46 80 00 00 	movabs $0x80468c,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	49 b9 ec 05 80 00 00 	movabs $0x8005ec,%r9
  8000bb:	00 00 00 
  8000be:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c4:	85 c0                	test   %eax,%eax
  8000c6:	74 36                	je     8000fe <ls+0xba>
  8000c8:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8000cf:	00 00 00 
  8000d2:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d8:	85 c0                	test   %eax,%eax
  8000da:	75 22                	jne    8000fe <ls+0xba>
		lsdir(path, prefix);
  8000dc:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000ea:	48 89 d6             	mov    %rdx,%rsi
  8000ed:	48 89 c7             	mov    %rax,%rdi
  8000f0:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	callq  *%rax
  8000fc:	eb 28                	jmp    800126 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fe:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800101:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800104:	85 c0                	test   %eax,%eax
  800106:	0f 95 c0             	setne  %al
  800109:	0f b6 c0             	movzbl %al,%eax
  80010c:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800113:	89 c6                	mov    %eax,%esi
  800115:	bf 00 00 00 00       	mov    $0x0,%edi
  80011a:	48 b8 8a 02 80 00 00 	movabs $0x80028a,%rax
  800121:	00 00 00 
  800124:	ff d0                	callq  *%rax
}
  800126:	c9                   	leaveq 
  800127:	c3                   	retq   

0000000000800128 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800128:	55                   	push   %rbp
  800129:	48 89 e5             	mov    %rsp,%rbp
  80012c:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800133:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  80013a:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800141:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800148:	be 00 00 00 00       	mov    $0x0,%esi
  80014d:	48 89 c7             	mov    %rax,%rdi
  800150:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 7a                	jns    8001df <lsdir+0xb7>
		panic("open %s: %e", path, fd);
  800165:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800168:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016f:	41 89 d0             	mov    %edx,%r8d
  800172:	48 89 c1             	mov    %rax,%rcx
  800175:	48 ba 96 46 80 00 00 	movabs $0x804696,%rdx
  80017c:	00 00 00 
  80017f:	be 1d 00 00 00       	mov    $0x1d,%esi
  800184:	48 bf 8c 46 80 00 00 	movabs $0x80468c,%rdi
  80018b:	00 00 00 
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b9 ec 05 80 00 00 	movabs $0x8005ec,%r9
  80019a:	00 00 00 
  80019d:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  8001a0:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a7:	84 c0                	test   %al,%al
  8001a9:	74 35                	je     8001e0 <lsdir+0xb8>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ab:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b1:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b7:	83 f8 01             	cmp    $0x1,%eax
  8001ba:	0f 94 c0             	sete   %al
  8001bd:	0f b6 f0             	movzbl %al,%esi
  8001c0:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c7:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001ce:	48 89 c7             	mov    %rax,%rdi
  8001d1:	48 b8 8a 02 80 00 00 	movabs $0x80028a,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	callq  *%rax
  8001dd:	eb 01                	jmp    8001e0 <lsdir+0xb8>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001df:	90                   	nop
  8001e0:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ea:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ef:	48 89 ce             	mov    %rcx,%rsi
  8001f2:	89 c7                	mov    %eax,%edi
  8001f4:	48 b8 2d 29 80 00 00 	movabs $0x80292d,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
  800200:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800203:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  80020a:	74 94                	je     8001a0 <lsdir+0x78>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800210:	7e 35                	jle    800247 <lsdir+0x11f>
		panic("short read in directory %s", path);
  800212:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800219:	48 89 c1             	mov    %rax,%rcx
  80021c:	48 ba a2 46 80 00 00 	movabs $0x8046a2,%rdx
  800223:	00 00 00 
  800226:	be 22 00 00 00       	mov    $0x22,%esi
  80022b:	48 bf 8c 46 80 00 00 	movabs $0x80468c,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	49 b8 ec 05 80 00 00 	movabs $0x8005ec,%r8
  800241:	00 00 00 
  800244:	41 ff d0             	callq  *%r8
	if (n < 0)
  800247:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80024b:	79 3b                	jns    800288 <lsdir+0x160>
		panic("error reading directory %s: %e", path, n);
  80024d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800250:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800257:	41 89 d0             	mov    %edx,%r8d
  80025a:	48 89 c1             	mov    %rax,%rcx
  80025d:	48 ba c0 46 80 00 00 	movabs $0x8046c0,%rdx
  800264:	00 00 00 
  800267:	be 24 00 00 00       	mov    $0x24,%esi
  80026c:	48 bf 8c 46 80 00 00 	movabs $0x80468c,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	49 b9 ec 05 80 00 00 	movabs $0x8005ec,%r9
  800282:	00 00 00 
  800285:	41 ff d1             	callq  *%r9
}
  800288:	c9                   	leaveq 
  800289:	c3                   	retq   

000000000080028a <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  80028a:	55                   	push   %rbp
  80028b:	48 89 e5             	mov    %rsp,%rbp
  80028e:	48 83 ec 30          	sub    $0x30,%rsp
  800292:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800296:	89 f0                	mov    %esi,%eax
  800298:	89 55 e0             	mov    %edx,-0x20(%rbp)
  80029b:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029f:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a2:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8002a9:	00 00 00 
  8002ac:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b2:	85 c0                	test   %eax,%eax
  8002b4:	74 34                	je     8002ea <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b6:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002ba:	74 07                	je     8002c3 <ls1+0x39>
  8002bc:	b8 64 00 00 00       	mov    $0x64,%eax
  8002c1:	eb 05                	jmp    8002c8 <ls1+0x3e>
  8002c3:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c8:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002cb:	89 c2                	mov    %eax,%edx
  8002cd:	89 ce                	mov    %ecx,%esi
  8002cf:	48 bf df 46 80 00 00 	movabs $0x8046df,%rdi
  8002d6:	00 00 00 
  8002d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002de:	48 b9 94 32 80 00 00 	movabs $0x803294,%rcx
  8002e5:	00 00 00 
  8002e8:	ff d1                	callq  *%rcx
	if(prefix) {
  8002ea:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ef:	74 73                	je     800364 <ls1+0xda>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f5:	0f b6 00             	movzbl (%rax),%eax
  8002f8:	84 c0                	test   %al,%al
  8002fa:	74 34                	je     800330 <ls1+0xa6>
  8002fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800300:	48 89 c7             	mov    %rax,%rdi
  800303:	48 b8 78 13 80 00 00 	movabs $0x801378,%rax
  80030a:	00 00 00 
  80030d:	ff d0                	callq  *%rax
  80030f:	48 98                	cltq   
  800311:	48 83 e8 01          	sub    $0x1,%rax
  800315:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800319:	0f b6 00             	movzbl (%rax),%eax
  80031c:	3c 2f                	cmp    $0x2f,%al
  80031e:	74 10                	je     800330 <ls1+0xa6>
			sep = "/";
  800320:	48 b8 e8 46 80 00 00 	movabs $0x8046e8,%rax
  800327:	00 00 00 
  80032a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032e:	eb 0e                	jmp    80033e <ls1+0xb4>
		else
			sep = "";
  800330:	48 b8 ea 46 80 00 00 	movabs $0x8046ea,%rax
  800337:	00 00 00 
  80033a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800346:	48 89 c6             	mov    %rax,%rsi
  800349:	48 bf eb 46 80 00 00 	movabs $0x8046eb,%rdi
  800350:	00 00 00 
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	48 b9 94 32 80 00 00 	movabs $0x803294,%rcx
  80035f:	00 00 00 
  800362:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800364:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800368:	48 89 c6             	mov    %rax,%rsi
  80036b:	48 bf f0 46 80 00 00 	movabs $0x8046f0,%rdi
  800372:	00 00 00 
  800375:	b8 00 00 00 00       	mov    $0x0,%eax
  80037a:	48 ba 94 32 80 00 00 	movabs $0x803294,%rdx
  800381:	00 00 00 
  800384:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800386:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80038d:	00 00 00 
  800390:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800396:	85 c0                	test   %eax,%eax
  800398:	74 21                	je     8003bb <ls1+0x131>
  80039a:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039e:	74 1b                	je     8003bb <ls1+0x131>
		printf("/");
  8003a0:	48 bf e8 46 80 00 00 	movabs $0x8046e8,%rdi
  8003a7:	00 00 00 
  8003aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003af:	48 ba 94 32 80 00 00 	movabs $0x803294,%rdx
  8003b6:	00 00 00 
  8003b9:	ff d2                	callq  *%rdx
	printf("\n");
  8003bb:	48 bf f3 46 80 00 00 	movabs $0x8046f3,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 94 32 80 00 00 	movabs $0x803294,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
}
  8003d6:	c9                   	leaveq 
  8003d7:	c3                   	retq   

00000000008003d8 <usage>:

void
usage(void)
{
  8003d8:	55                   	push   %rbp
  8003d9:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dc:	48 bf f5 46 80 00 00 	movabs $0x8046f5,%rdi
  8003e3:	00 00 00 
  8003e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003eb:	48 ba 94 32 80 00 00 	movabs $0x803294,%rdx
  8003f2:	00 00 00 
  8003f5:	ff d2                	callq  *%rdx
	exit();
  8003f7:	48 b8 c8 05 80 00 00 	movabs $0x8005c8,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	callq  *%rax
}
  800403:	5d                   	pop    %rbp
  800404:	c3                   	retq   

0000000000800405 <umain>:

void
umain(int argc, char **argv)
{
  800405:	55                   	push   %rbp
  800406:	48 89 e5             	mov    %rsp,%rbp
  800409:	48 83 ec 40          	sub    $0x40,%rsp
  80040d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800410:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800414:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800418:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041c:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800420:	48 89 ce             	mov    %rcx,%rsi
  800423:	48 89 c7             	mov    %rax,%rdi
  800426:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  80042d:	00 00 00 
  800430:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800432:	eb 60                	jmp    800494 <umain+0x8f>
		switch (i) {
  800434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800437:	83 e8 46             	sub    $0x46,%eax
  80043a:	83 f8 26             	cmp    $0x26,%eax
  80043d:	77 49                	ja     800488 <umain+0x83>
  80043f:	48 98                	cltq   
  800441:	ba 01 00 00 00       	mov    $0x1,%edx
  800446:	89 c1                	mov    %eax,%ecx
  800448:	48 d3 e2             	shl    %cl,%rdx
  80044b:	48 b8 01 00 00 40 40 	movabs $0x4040000001,%rax
  800452:	00 00 00 
  800455:	48 21 d0             	and    %rdx,%rax
  800458:	48 85 c0             	test   %rax,%rax
  80045b:	74 2b                	je     800488 <umain+0x83>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  80045d:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  800470:	8d 48 01             	lea    0x1(%rax),%ecx
  800473:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80047a:	00 00 00 
  80047d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800480:	48 63 d2             	movslq %edx,%rdx
  800483:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800486:	eb 0c                	jmp    800494 <umain+0x8f>
		default:
			usage();
  800488:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800494:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800498:	48 89 c7             	mov    %rax,%rdi
  80049b:	48 b8 c0 20 80 00 00 	movabs $0x8020c0,%rax
  8004a2:	00 00 00 
  8004a5:	ff d0                	callq  *%rax
  8004a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004ae:	79 84                	jns    800434 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8004b0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004b3:	83 f8 01             	cmp    $0x1,%eax
  8004b6:	75 22                	jne    8004da <umain+0xd5>
		ls("/", "");
  8004b8:	48 be ea 46 80 00 00 	movabs $0x8046ea,%rsi
  8004bf:	00 00 00 
  8004c2:	48 bf e8 46 80 00 00 	movabs $0x8046e8,%rdi
  8004c9:	00 00 00 
  8004cc:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8004d3:	00 00 00 
  8004d6:	ff d0                	callq  *%rax
  8004d8:	eb 47                	jmp    800521 <umain+0x11c>
	else {
		for (i = 1; i < argc; i++)
  8004da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004e1:	eb 36                	jmp    800519 <umain+0x114>
			ls(argv[i], argv[i]);
  8004e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e6:	48 98                	cltq   
  8004e8:	48 c1 e0 03          	shl    $0x3,%rax
  8004ec:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8004f0:	48 8b 10             	mov    (%rax),%rdx
  8004f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f6:	48 98                	cltq   
  8004f8:	48 c1 e0 03          	shl    $0x3,%rax
  8004fc:	48 03 45 c0          	add    -0x40(%rbp),%rax
  800500:	48 8b 00             	mov    (%rax),%rax
  800503:	48 89 d6             	mov    %rdx,%rsi
  800506:	48 89 c7             	mov    %rax,%rdi
  800509:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800510:	00 00 00 
  800513:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800515:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800519:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80051c:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  80051f:	7c c2                	jl     8004e3 <umain+0xde>
			ls(argv[i], argv[i]);
	}
}
  800521:	c9                   	leaveq 
  800522:	c3                   	retq   
	...

0000000000800524 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800524:	55                   	push   %rbp
  800525:	48 89 e5             	mov    %rsp,%rbp
  800528:	48 83 ec 10          	sub    $0x10,%rsp
  80052c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80052f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800533:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  80053a:	00 00 00 
  80053d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800544:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  80054b:	00 00 00 
  80054e:	ff d0                	callq  *%rax
  800550:	48 98                	cltq   
  800552:	48 89 c2             	mov    %rax,%rdx
  800555:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80055b:	48 89 d0             	mov    %rdx,%rax
  80055e:	48 c1 e0 03          	shl    $0x3,%rax
  800562:	48 01 d0             	add    %rdx,%rax
  800565:	48 c1 e0 05          	shl    $0x5,%rax
  800569:	48 89 c2             	mov    %rax,%rdx
  80056c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800573:	00 00 00 
  800576:	48 01 c2             	add    %rax,%rdx
  800579:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  800580:	00 00 00 
  800583:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80058a:	7e 14                	jle    8005a0 <libmain+0x7c>
		binaryname = argv[0];
  80058c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800590:	48 8b 10             	mov    (%rax),%rdx
  800593:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80059a:	00 00 00 
  80059d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005a7:	48 89 d6             	mov    %rdx,%rsi
  8005aa:	89 c7                	mov    %eax,%edi
  8005ac:	48 b8 05 04 80 00 00 	movabs $0x800405,%rax
  8005b3:	00 00 00 
  8005b6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8005b8:	48 b8 c8 05 80 00 00 	movabs $0x8005c8,%rax
  8005bf:	00 00 00 
  8005c2:	ff d0                	callq  *%rax
}
  8005c4:	c9                   	leaveq 
  8005c5:	c3                   	retq   
	...

00000000008005c8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005c8:	55                   	push   %rbp
  8005c9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005cc:	48 b8 7d 26 80 00 00 	movabs $0x80267d,%rax
  8005d3:	00 00 00 
  8005d6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8005dd:	48 b8 5c 1c 80 00 00 	movabs $0x801c5c,%rax
  8005e4:	00 00 00 
  8005e7:	ff d0                	callq  *%rax
}
  8005e9:	5d                   	pop    %rbp
  8005ea:	c3                   	retq   
	...

00000000008005ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ec:	55                   	push   %rbp
  8005ed:	48 89 e5             	mov    %rsp,%rbp
  8005f0:	53                   	push   %rbx
  8005f1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005f8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005ff:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800605:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80060c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800613:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80061a:	84 c0                	test   %al,%al
  80061c:	74 23                	je     800641 <_panic+0x55>
  80061e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800625:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800629:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80062d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800631:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800635:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800639:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80063d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800641:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800648:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80064f:	00 00 00 
  800652:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800659:	00 00 00 
  80065c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800660:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800667:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80066e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800675:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80067c:	00 00 00 
  80067f:	48 8b 18             	mov    (%rax),%rbx
  800682:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  800689:	00 00 00 
  80068c:	ff d0                	callq  *%rax
  80068e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800694:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80069b:	41 89 c8             	mov    %ecx,%r8d
  80069e:	48 89 d1             	mov    %rdx,%rcx
  8006a1:	48 89 da             	mov    %rbx,%rdx
  8006a4:	89 c6                	mov    %eax,%esi
  8006a6:	48 bf 20 47 80 00 00 	movabs $0x804720,%rdi
  8006ad:	00 00 00 
  8006b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b5:	49 b9 27 08 80 00 00 	movabs $0x800827,%r9
  8006bc:	00 00 00 
  8006bf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006c2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006c9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d0:	48 89 d6             	mov    %rdx,%rsi
  8006d3:	48 89 c7             	mov    %rax,%rdi
  8006d6:	48 b8 7b 07 80 00 00 	movabs $0x80077b,%rax
  8006dd:	00 00 00 
  8006e0:	ff d0                	callq  *%rax
	cprintf("\n");
  8006e2:	48 bf 43 47 80 00 00 	movabs $0x804743,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	48 ba 27 08 80 00 00 	movabs $0x800827,%rdx
  8006f8:	00 00 00 
  8006fb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006fd:	cc                   	int3   
  8006fe:	eb fd                	jmp    8006fd <_panic+0x111>

0000000000800700 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800700:	55                   	push   %rbp
  800701:	48 89 e5             	mov    %rsp,%rbp
  800704:	48 83 ec 10          	sub    $0x10,%rsp
  800708:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80070b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80070f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800713:	8b 00                	mov    (%rax),%eax
  800715:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800718:	89 d6                	mov    %edx,%esi
  80071a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80071e:	48 63 d0             	movslq %eax,%rdx
  800721:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800726:	8d 50 01             	lea    0x1(%rax),%edx
  800729:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072d:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80072f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800733:	8b 00                	mov    (%rax),%eax
  800735:	3d ff 00 00 00       	cmp    $0xff,%eax
  80073a:	75 2c                	jne    800768 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  80073c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	48 98                	cltq   
  800744:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800748:	48 83 c2 08          	add    $0x8,%rdx
  80074c:	48 89 c6             	mov    %rax,%rsi
  80074f:	48 89 d7             	mov    %rdx,%rdi
  800752:	48 b8 d4 1b 80 00 00 	movabs $0x801bd4,%rax
  800759:	00 00 00 
  80075c:	ff d0                	callq  *%rax
		b->idx = 0;
  80075e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800762:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800768:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80076c:	8b 40 04             	mov    0x4(%rax),%eax
  80076f:	8d 50 01             	lea    0x1(%rax),%edx
  800772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800776:	89 50 04             	mov    %edx,0x4(%rax)
}
  800779:	c9                   	leaveq 
  80077a:	c3                   	retq   

000000000080077b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80077b:	55                   	push   %rbp
  80077c:	48 89 e5             	mov    %rsp,%rbp
  80077f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800786:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80078d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800794:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80079b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007a2:	48 8b 0a             	mov    (%rdx),%rcx
  8007a5:	48 89 08             	mov    %rcx,(%rax)
  8007a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8007b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007bf:	00 00 00 
	b.cnt = 0;
  8007c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007c9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8007cc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007d3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007da:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007e1:	48 89 c6             	mov    %rax,%rsi
  8007e4:	48 bf 00 07 80 00 00 	movabs $0x800700,%rdi
  8007eb:	00 00 00 
  8007ee:	48 b8 d8 0b 80 00 00 	movabs $0x800bd8,%rax
  8007f5:	00 00 00 
  8007f8:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8007fa:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800800:	48 98                	cltq   
  800802:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800809:	48 83 c2 08          	add    $0x8,%rdx
  80080d:	48 89 c6             	mov    %rax,%rsi
  800810:	48 89 d7             	mov    %rdx,%rdi
  800813:	48 b8 d4 1b 80 00 00 	movabs $0x801bd4,%rax
  80081a:	00 00 00 
  80081d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80081f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800825:	c9                   	leaveq 
  800826:	c3                   	retq   

0000000000800827 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800827:	55                   	push   %rbp
  800828:	48 89 e5             	mov    %rsp,%rbp
  80082b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800832:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800839:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800840:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800847:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80084e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800855:	84 c0                	test   %al,%al
  800857:	74 20                	je     800879 <cprintf+0x52>
  800859:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80085d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800861:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800865:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800869:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80086d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800871:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800875:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800879:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800880:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800887:	00 00 00 
  80088a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800891:	00 00 00 
  800894:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800898:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80089f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8008a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8008ad:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008b4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008bb:	48 8b 0a             	mov    (%rdx),%rcx
  8008be:	48 89 08             	mov    %rcx,(%rax)
  8008c1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008c5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008c9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008cd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8008d1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008d8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008df:	48 89 d6             	mov    %rdx,%rsi
  8008e2:	48 89 c7             	mov    %rax,%rdi
  8008e5:	48 b8 7b 07 80 00 00 	movabs $0x80077b,%rax
  8008ec:	00 00 00 
  8008ef:	ff d0                	callq  *%rax
  8008f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8008f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008fd:	c9                   	leaveq 
  8008fe:	c3                   	retq   
	...

0000000000800900 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800900:	55                   	push   %rbp
  800901:	48 89 e5             	mov    %rsp,%rbp
  800904:	48 83 ec 30          	sub    $0x30,%rsp
  800908:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80090c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800910:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800914:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800917:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80091b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80091f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800922:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800926:	77 52                	ja     80097a <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800928:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80092b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80092f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800932:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800936:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
  80093f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800943:	48 89 c2             	mov    %rax,%rdx
  800946:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800949:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80094c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800950:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800954:	41 89 f9             	mov    %edi,%r9d
  800957:	48 89 c7             	mov    %rax,%rdi
  80095a:	48 b8 00 09 80 00 00 	movabs $0x800900,%rax
  800961:	00 00 00 
  800964:	ff d0                	callq  *%rax
  800966:	eb 1c                	jmp    800984 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800968:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80096c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80096f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800973:	48 89 d6             	mov    %rdx,%rsi
  800976:	89 c7                	mov    %eax,%edi
  800978:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80097a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80097e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800982:	7f e4                	jg     800968 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800984:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	ba 00 00 00 00       	mov    $0x0,%edx
  800990:	48 f7 f1             	div    %rcx
  800993:	48 89 d0             	mov    %rdx,%rax
  800996:	48 ba 28 49 80 00 00 	movabs $0x804928,%rdx
  80099d:	00 00 00 
  8009a0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8009a4:	0f be c0             	movsbl %al,%eax
  8009a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009ab:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8009af:	48 89 d6             	mov    %rdx,%rsi
  8009b2:	89 c7                	mov    %eax,%edi
  8009b4:	ff d1                	callq  *%rcx
}
  8009b6:	c9                   	leaveq 
  8009b7:	c3                   	retq   

00000000008009b8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009b8:	55                   	push   %rbp
  8009b9:	48 89 e5             	mov    %rsp,%rbp
  8009bc:	48 83 ec 20          	sub    $0x20,%rsp
  8009c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009c4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009c7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009cb:	7e 52                	jle    800a1f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d1:	8b 00                	mov    (%rax),%eax
  8009d3:	83 f8 30             	cmp    $0x30,%eax
  8009d6:	73 24                	jae    8009fc <getuint+0x44>
  8009d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e4:	8b 00                	mov    (%rax),%eax
  8009e6:	89 c0                	mov    %eax,%eax
  8009e8:	48 01 d0             	add    %rdx,%rax
  8009eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ef:	8b 12                	mov    (%rdx),%edx
  8009f1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f8:	89 0a                	mov    %ecx,(%rdx)
  8009fa:	eb 17                	jmp    800a13 <getuint+0x5b>
  8009fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a00:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a04:	48 89 d0             	mov    %rdx,%rax
  800a07:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a13:	48 8b 00             	mov    (%rax),%rax
  800a16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a1a:	e9 a3 00 00 00       	jmpq   800ac2 <getuint+0x10a>
	else if (lflag)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a23:	74 4f                	je     800a74 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a29:	8b 00                	mov    (%rax),%eax
  800a2b:	83 f8 30             	cmp    $0x30,%eax
  800a2e:	73 24                	jae    800a54 <getuint+0x9c>
  800a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a34:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3c:	8b 00                	mov    (%rax),%eax
  800a3e:	89 c0                	mov    %eax,%eax
  800a40:	48 01 d0             	add    %rdx,%rax
  800a43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a47:	8b 12                	mov    (%rdx),%edx
  800a49:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a50:	89 0a                	mov    %ecx,(%rdx)
  800a52:	eb 17                	jmp    800a6b <getuint+0xb3>
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a5c:	48 89 d0             	mov    %rdx,%rax
  800a5f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a67:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a6b:	48 8b 00             	mov    (%rax),%rax
  800a6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a72:	eb 4e                	jmp    800ac2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a78:	8b 00                	mov    (%rax),%eax
  800a7a:	83 f8 30             	cmp    $0x30,%eax
  800a7d:	73 24                	jae    800aa3 <getuint+0xeb>
  800a7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a83:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8b:	8b 00                	mov    (%rax),%eax
  800a8d:	89 c0                	mov    %eax,%eax
  800a8f:	48 01 d0             	add    %rdx,%rax
  800a92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a96:	8b 12                	mov    (%rdx),%edx
  800a98:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9f:	89 0a                	mov    %ecx,(%rdx)
  800aa1:	eb 17                	jmp    800aba <getuint+0x102>
  800aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aab:	48 89 d0             	mov    %rdx,%rax
  800aae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aba:	8b 00                	mov    (%rax),%eax
  800abc:	89 c0                	mov    %eax,%eax
  800abe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ac6:	c9                   	leaveq 
  800ac7:	c3                   	retq   

0000000000800ac8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac8:	55                   	push   %rbp
  800ac9:	48 89 e5             	mov    %rsp,%rbp
  800acc:	48 83 ec 20          	sub    $0x20,%rsp
  800ad0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ad4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ad7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800adb:	7e 52                	jle    800b2f <getint+0x67>
		x=va_arg(*ap, long long);
  800add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae1:	8b 00                	mov    (%rax),%eax
  800ae3:	83 f8 30             	cmp    $0x30,%eax
  800ae6:	73 24                	jae    800b0c <getint+0x44>
  800ae8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800af0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af4:	8b 00                	mov    (%rax),%eax
  800af6:	89 c0                	mov    %eax,%eax
  800af8:	48 01 d0             	add    %rdx,%rax
  800afb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aff:	8b 12                	mov    (%rdx),%edx
  800b01:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b08:	89 0a                	mov    %ecx,(%rdx)
  800b0a:	eb 17                	jmp    800b23 <getint+0x5b>
  800b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b10:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b14:	48 89 d0             	mov    %rdx,%rax
  800b17:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b1f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b23:	48 8b 00             	mov    (%rax),%rax
  800b26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b2a:	e9 a3 00 00 00       	jmpq   800bd2 <getint+0x10a>
	else if (lflag)
  800b2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b33:	74 4f                	je     800b84 <getint+0xbc>
		x=va_arg(*ap, long);
  800b35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b39:	8b 00                	mov    (%rax),%eax
  800b3b:	83 f8 30             	cmp    $0x30,%eax
  800b3e:	73 24                	jae    800b64 <getint+0x9c>
  800b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b44:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4c:	8b 00                	mov    (%rax),%eax
  800b4e:	89 c0                	mov    %eax,%eax
  800b50:	48 01 d0             	add    %rdx,%rax
  800b53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b57:	8b 12                	mov    (%rdx),%edx
  800b59:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b60:	89 0a                	mov    %ecx,(%rdx)
  800b62:	eb 17                	jmp    800b7b <getint+0xb3>
  800b64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b68:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b6c:	48 89 d0             	mov    %rdx,%rax
  800b6f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b73:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b77:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b7b:	48 8b 00             	mov    (%rax),%rax
  800b7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b82:	eb 4e                	jmp    800bd2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b88:	8b 00                	mov    (%rax),%eax
  800b8a:	83 f8 30             	cmp    $0x30,%eax
  800b8d:	73 24                	jae    800bb3 <getint+0xeb>
  800b8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b93:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9b:	8b 00                	mov    (%rax),%eax
  800b9d:	89 c0                	mov    %eax,%eax
  800b9f:	48 01 d0             	add    %rdx,%rax
  800ba2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba6:	8b 12                	mov    (%rdx),%edx
  800ba8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800baf:	89 0a                	mov    %ecx,(%rdx)
  800bb1:	eb 17                	jmp    800bca <getint+0x102>
  800bb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bbb:	48 89 d0             	mov    %rdx,%rax
  800bbe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bca:	8b 00                	mov    (%rax),%eax
  800bcc:	48 98                	cltq   
  800bce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bd6:	c9                   	leaveq 
  800bd7:	c3                   	retq   

0000000000800bd8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bd8:	55                   	push   %rbp
  800bd9:	48 89 e5             	mov    %rsp,%rbp
  800bdc:	41 54                	push   %r12
  800bde:	53                   	push   %rbx
  800bdf:	48 83 ec 60          	sub    $0x60,%rsp
  800be3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800be7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800beb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bef:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bf3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bfb:	48 8b 0a             	mov    (%rdx),%rcx
  800bfe:	48 89 08             	mov    %rcx,(%rax)
  800c01:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c05:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c09:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c0d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c11:	eb 17                	jmp    800c2a <vprintfmt+0x52>
			if (ch == '\0')
  800c13:	85 db                	test   %ebx,%ebx
  800c15:	0f 84 d7 04 00 00    	je     8010f2 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800c1b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c1f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c23:	48 89 c6             	mov    %rax,%rsi
  800c26:	89 df                	mov    %ebx,%edi
  800c28:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c2e:	0f b6 00             	movzbl (%rax),%eax
  800c31:	0f b6 d8             	movzbl %al,%ebx
  800c34:	83 fb 25             	cmp    $0x25,%ebx
  800c37:	0f 95 c0             	setne  %al
  800c3a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c3f:	84 c0                	test   %al,%al
  800c41:	75 d0                	jne    800c13 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c43:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c47:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c4e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c5c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800c63:	eb 04                	jmp    800c69 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800c65:	90                   	nop
  800c66:	eb 01                	jmp    800c69 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800c68:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c6d:	0f b6 00             	movzbl (%rax),%eax
  800c70:	0f b6 d8             	movzbl %al,%ebx
  800c73:	89 d8                	mov    %ebx,%eax
  800c75:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c7a:	83 e8 23             	sub    $0x23,%eax
  800c7d:	83 f8 55             	cmp    $0x55,%eax
  800c80:	0f 87 38 04 00 00    	ja     8010be <vprintfmt+0x4e6>
  800c86:	89 c0                	mov    %eax,%eax
  800c88:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c8f:	00 
  800c90:	48 b8 50 49 80 00 00 	movabs $0x804950,%rax
  800c97:	00 00 00 
  800c9a:	48 01 d0             	add    %rdx,%rax
  800c9d:	48 8b 00             	mov    (%rax),%rax
  800ca0:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ca6:	eb c1                	jmp    800c69 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800cac:	eb bb                	jmp    800c69 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cae:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cb5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cb8:	89 d0                	mov    %edx,%eax
  800cba:	c1 e0 02             	shl    $0x2,%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	01 c0                	add    %eax,%eax
  800cc1:	01 d8                	add    %ebx,%eax
  800cc3:	83 e8 30             	sub    $0x30,%eax
  800cc6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cc9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ccd:	0f b6 00             	movzbl (%rax),%eax
  800cd0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd3:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd6:	7e 63                	jle    800d3b <vprintfmt+0x163>
  800cd8:	83 fb 39             	cmp    $0x39,%ebx
  800cdb:	7f 5e                	jg     800d3b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cdd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce2:	eb d1                	jmp    800cb5 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800ce4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce7:	83 f8 30             	cmp    $0x30,%eax
  800cea:	73 17                	jae    800d03 <vprintfmt+0x12b>
  800cec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf3:	89 c0                	mov    %eax,%eax
  800cf5:	48 01 d0             	add    %rdx,%rax
  800cf8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cfb:	83 c2 08             	add    $0x8,%edx
  800cfe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d01:	eb 0f                	jmp    800d12 <vprintfmt+0x13a>
  800d03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d07:	48 89 d0             	mov    %rdx,%rax
  800d0a:	48 83 c2 08          	add    $0x8,%rdx
  800d0e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d12:	8b 00                	mov    (%rax),%eax
  800d14:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800d19:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d1d:	0f 89 42 ff ff ff    	jns    800c65 <vprintfmt+0x8d>
				width = 0;
  800d23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d2a:	e9 36 ff ff ff       	jmpq   800c65 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800d2f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d36:	e9 2e ff ff ff       	jmpq   800c69 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d3b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d40:	0f 89 22 ff ff ff    	jns    800c68 <vprintfmt+0x90>
				width = precision, precision = -1;
  800d46:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d49:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d4c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d53:	e9 10 ff ff ff       	jmpq   800c68 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d58:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d5c:	e9 08 ff ff ff       	jmpq   800c69 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d64:	83 f8 30             	cmp    $0x30,%eax
  800d67:	73 17                	jae    800d80 <vprintfmt+0x1a8>
  800d69:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d70:	89 c0                	mov    %eax,%eax
  800d72:	48 01 d0             	add    %rdx,%rax
  800d75:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d78:	83 c2 08             	add    $0x8,%edx
  800d7b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d7e:	eb 0f                	jmp    800d8f <vprintfmt+0x1b7>
  800d80:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d84:	48 89 d0             	mov    %rdx,%rax
  800d87:	48 83 c2 08          	add    $0x8,%rdx
  800d8b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d8f:	8b 00                	mov    (%rax),%eax
  800d91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d95:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800d99:	48 89 d6             	mov    %rdx,%rsi
  800d9c:	89 c7                	mov    %eax,%edi
  800d9e:	ff d1                	callq  *%rcx
			break;
  800da0:	e9 47 03 00 00       	jmpq   8010ec <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800da5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da8:	83 f8 30             	cmp    $0x30,%eax
  800dab:	73 17                	jae    800dc4 <vprintfmt+0x1ec>
  800dad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db4:	89 c0                	mov    %eax,%eax
  800db6:	48 01 d0             	add    %rdx,%rax
  800db9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dbc:	83 c2 08             	add    $0x8,%edx
  800dbf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dc2:	eb 0f                	jmp    800dd3 <vprintfmt+0x1fb>
  800dc4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc8:	48 89 d0             	mov    %rdx,%rax
  800dcb:	48 83 c2 08          	add    $0x8,%rdx
  800dcf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dd5:	85 db                	test   %ebx,%ebx
  800dd7:	79 02                	jns    800ddb <vprintfmt+0x203>
				err = -err;
  800dd9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ddb:	83 fb 10             	cmp    $0x10,%ebx
  800dde:	7f 16                	jg     800df6 <vprintfmt+0x21e>
  800de0:	48 b8 a0 48 80 00 00 	movabs $0x8048a0,%rax
  800de7:	00 00 00 
  800dea:	48 63 d3             	movslq %ebx,%rdx
  800ded:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800df1:	4d 85 e4             	test   %r12,%r12
  800df4:	75 2e                	jne    800e24 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800df6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfe:	89 d9                	mov    %ebx,%ecx
  800e00:	48 ba 39 49 80 00 00 	movabs $0x804939,%rdx
  800e07:	00 00 00 
  800e0a:	48 89 c7             	mov    %rax,%rdi
  800e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e12:	49 b8 fc 10 80 00 00 	movabs $0x8010fc,%r8
  800e19:	00 00 00 
  800e1c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e1f:	e9 c8 02 00 00       	jmpq   8010ec <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e24:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2c:	4c 89 e1             	mov    %r12,%rcx
  800e2f:	48 ba 42 49 80 00 00 	movabs $0x804942,%rdx
  800e36:	00 00 00 
  800e39:	48 89 c7             	mov    %rax,%rdi
  800e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e41:	49 b8 fc 10 80 00 00 	movabs $0x8010fc,%r8
  800e48:	00 00 00 
  800e4b:	41 ff d0             	callq  *%r8
			break;
  800e4e:	e9 99 02 00 00       	jmpq   8010ec <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e53:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e56:	83 f8 30             	cmp    $0x30,%eax
  800e59:	73 17                	jae    800e72 <vprintfmt+0x29a>
  800e5b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e62:	89 c0                	mov    %eax,%eax
  800e64:	48 01 d0             	add    %rdx,%rax
  800e67:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e6a:	83 c2 08             	add    $0x8,%edx
  800e6d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e70:	eb 0f                	jmp    800e81 <vprintfmt+0x2a9>
  800e72:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e76:	48 89 d0             	mov    %rdx,%rax
  800e79:	48 83 c2 08          	add    $0x8,%rdx
  800e7d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e81:	4c 8b 20             	mov    (%rax),%r12
  800e84:	4d 85 e4             	test   %r12,%r12
  800e87:	75 0a                	jne    800e93 <vprintfmt+0x2bb>
				p = "(null)";
  800e89:	49 bc 45 49 80 00 00 	movabs $0x804945,%r12
  800e90:	00 00 00 
			if (width > 0 && padc != '-')
  800e93:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e97:	7e 7a                	jle    800f13 <vprintfmt+0x33b>
  800e99:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e9d:	74 74                	je     800f13 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e9f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ea2:	48 98                	cltq   
  800ea4:	48 89 c6             	mov    %rax,%rsi
  800ea7:	4c 89 e7             	mov    %r12,%rdi
  800eaa:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	callq  *%rax
  800eb6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800eb9:	eb 17                	jmp    800ed2 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800ebb:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800ebf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec3:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800ec7:	48 89 d6             	mov    %rdx,%rsi
  800eca:	89 c7                	mov    %eax,%edi
  800ecc:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ece:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ed2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ed6:	7f e3                	jg     800ebb <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ed8:	eb 39                	jmp    800f13 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800eda:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ede:	74 1e                	je     800efe <vprintfmt+0x326>
  800ee0:	83 fb 1f             	cmp    $0x1f,%ebx
  800ee3:	7e 05                	jle    800eea <vprintfmt+0x312>
  800ee5:	83 fb 7e             	cmp    $0x7e,%ebx
  800ee8:	7e 14                	jle    800efe <vprintfmt+0x326>
					putch('?', putdat);
  800eea:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800eee:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ef2:	48 89 c6             	mov    %rax,%rsi
  800ef5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800efa:	ff d2                	callq  *%rdx
  800efc:	eb 0f                	jmp    800f0d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800efe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f02:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f06:	48 89 c6             	mov    %rax,%rsi
  800f09:	89 df                	mov    %ebx,%edi
  800f0b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f11:	eb 01                	jmp    800f14 <vprintfmt+0x33c>
  800f13:	90                   	nop
  800f14:	41 0f b6 04 24       	movzbl (%r12),%eax
  800f19:	0f be d8             	movsbl %al,%ebx
  800f1c:	85 db                	test   %ebx,%ebx
  800f1e:	0f 95 c0             	setne  %al
  800f21:	49 83 c4 01          	add    $0x1,%r12
  800f25:	84 c0                	test   %al,%al
  800f27:	74 28                	je     800f51 <vprintfmt+0x379>
  800f29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f2d:	78 ab                	js     800eda <vprintfmt+0x302>
  800f2f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f37:	79 a1                	jns    800eda <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f39:	eb 16                	jmp    800f51 <vprintfmt+0x379>
				putch(' ', putdat);
  800f3b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f3f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f43:	48 89 c6             	mov    %rax,%rsi
  800f46:	bf 20 00 00 00       	mov    $0x20,%edi
  800f4b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f55:	7f e4                	jg     800f3b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800f57:	e9 90 01 00 00       	jmpq   8010ec <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f60:	be 03 00 00 00       	mov    $0x3,%esi
  800f65:	48 89 c7             	mov    %rax,%rdi
  800f68:	48 b8 c8 0a 80 00 00 	movabs $0x800ac8,%rax
  800f6f:	00 00 00 
  800f72:	ff d0                	callq  *%rax
  800f74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7c:	48 85 c0             	test   %rax,%rax
  800f7f:	79 1d                	jns    800f9e <vprintfmt+0x3c6>
				putch('-', putdat);
  800f81:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f85:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f89:	48 89 c6             	mov    %rax,%rsi
  800f8c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f91:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800f93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f97:	48 f7 d8             	neg    %rax
  800f9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f9e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa5:	e9 d5 00 00 00       	jmpq   80107f <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800faa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fae:	be 03 00 00 00       	mov    $0x3,%esi
  800fb3:	48 89 c7             	mov    %rax,%rdi
  800fb6:	48 b8 b8 09 80 00 00 	movabs $0x8009b8,%rax
  800fbd:	00 00 00 
  800fc0:	ff d0                	callq  *%rax
  800fc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fc6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fcd:	e9 ad 00 00 00       	jmpq   80107f <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800fd2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fd6:	be 03 00 00 00       	mov    $0x3,%esi
  800fdb:	48 89 c7             	mov    %rax,%rdi
  800fde:	48 b8 b8 09 80 00 00 	movabs $0x8009b8,%rax
  800fe5:	00 00 00 
  800fe8:	ff d0                	callq  *%rax
  800fea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800fee:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ff5:	e9 85 00 00 00       	jmpq   80107f <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800ffa:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ffe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801002:	48 89 c6             	mov    %rax,%rsi
  801005:	bf 30 00 00 00       	mov    $0x30,%edi
  80100a:	ff d2                	callq  *%rdx
			putch('x', putdat);
  80100c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801010:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801014:	48 89 c6             	mov    %rax,%rsi
  801017:	bf 78 00 00 00       	mov    $0x78,%edi
  80101c:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80101e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801021:	83 f8 30             	cmp    $0x30,%eax
  801024:	73 17                	jae    80103d <vprintfmt+0x465>
  801026:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80102a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80102d:	89 c0                	mov    %eax,%eax
  80102f:	48 01 d0             	add    %rdx,%rax
  801032:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801035:	83 c2 08             	add    $0x8,%edx
  801038:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80103b:	eb 0f                	jmp    80104c <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  80103d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801041:	48 89 d0             	mov    %rdx,%rax
  801044:	48 83 c2 08          	add    $0x8,%rdx
  801048:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80104c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80104f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801053:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80105a:	eb 23                	jmp    80107f <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80105c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801060:	be 03 00 00 00       	mov    $0x3,%esi
  801065:	48 89 c7             	mov    %rax,%rdi
  801068:	48 b8 b8 09 80 00 00 	movabs $0x8009b8,%rax
  80106f:	00 00 00 
  801072:	ff d0                	callq  *%rax
  801074:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801078:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80107f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801084:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801087:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80108a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80108e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801092:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801096:	45 89 c1             	mov    %r8d,%r9d
  801099:	41 89 f8             	mov    %edi,%r8d
  80109c:	48 89 c7             	mov    %rax,%rdi
  80109f:	48 b8 00 09 80 00 00 	movabs $0x800900,%rax
  8010a6:	00 00 00 
  8010a9:	ff d0                	callq  *%rax
			break;
  8010ab:	eb 3f                	jmp    8010ec <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ad:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010b1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010b5:	48 89 c6             	mov    %rax,%rsi
  8010b8:	89 df                	mov    %ebx,%edi
  8010ba:	ff d2                	callq  *%rdx
			break;
  8010bc:	eb 2e                	jmp    8010ec <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010be:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010c2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010c6:	48 89 c6             	mov    %rax,%rsi
  8010c9:	bf 25 00 00 00       	mov    $0x25,%edi
  8010ce:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010d5:	eb 05                	jmp    8010dc <vprintfmt+0x504>
  8010d7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010dc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010e0:	48 83 e8 01          	sub    $0x1,%rax
  8010e4:	0f b6 00             	movzbl (%rax),%eax
  8010e7:	3c 25                	cmp    $0x25,%al
  8010e9:	75 ec                	jne    8010d7 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  8010eb:	90                   	nop
		}
	}
  8010ec:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010ed:	e9 38 fb ff ff       	jmpq   800c2a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  8010f2:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  8010f3:	48 83 c4 60          	add    $0x60,%rsp
  8010f7:	5b                   	pop    %rbx
  8010f8:	41 5c                	pop    %r12
  8010fa:	5d                   	pop    %rbp
  8010fb:	c3                   	retq   

00000000008010fc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010fc:	55                   	push   %rbp
  8010fd:	48 89 e5             	mov    %rsp,%rbp
  801100:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801107:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80110e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801115:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80111c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801123:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80112a:	84 c0                	test   %al,%al
  80112c:	74 20                	je     80114e <printfmt+0x52>
  80112e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801132:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801136:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80113a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80113e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801142:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801146:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80114a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80114e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801155:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80115c:	00 00 00 
  80115f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801166:	00 00 00 
  801169:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80116d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801174:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80117b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801182:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801189:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801190:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801197:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80119e:	48 89 c7             	mov    %rax,%rdi
  8011a1:	48 b8 d8 0b 80 00 00 	movabs $0x800bd8,%rax
  8011a8:	00 00 00 
  8011ab:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011ad:	c9                   	leaveq 
  8011ae:	c3                   	retq   

00000000008011af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	48 83 ec 10          	sub    $0x10,%rsp
  8011b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c2:	8b 40 10             	mov    0x10(%rax),%eax
  8011c5:	8d 50 01             	lea    0x1(%rax),%edx
  8011c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cc:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d3:	48 8b 10             	mov    (%rax),%rdx
  8011d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011da:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011de:	48 39 c2             	cmp    %rax,%rdx
  8011e1:	73 17                	jae    8011fa <sprintputch+0x4b>
		*b->buf++ = ch;
  8011e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e7:	48 8b 00             	mov    (%rax),%rax
  8011ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011ed:	88 10                	mov    %dl,(%rax)
  8011ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f7:	48 89 10             	mov    %rdx,(%rax)
}
  8011fa:	c9                   	leaveq 
  8011fb:	c3                   	retq   

00000000008011fc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011fc:	55                   	push   %rbp
  8011fd:	48 89 e5             	mov    %rsp,%rbp
  801200:	48 83 ec 50          	sub    $0x50,%rsp
  801204:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801208:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80120b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80120f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801213:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801217:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80121b:	48 8b 0a             	mov    (%rdx),%rcx
  80121e:	48 89 08             	mov    %rcx,(%rax)
  801221:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801225:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801229:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80122d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801231:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801235:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801239:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80123c:	48 98                	cltq   
  80123e:	48 83 e8 01          	sub    $0x1,%rax
  801242:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801246:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80124a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801251:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801256:	74 06                	je     80125e <vsnprintf+0x62>
  801258:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80125c:	7f 07                	jg     801265 <vsnprintf+0x69>
		return -E_INVAL;
  80125e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801263:	eb 2f                	jmp    801294 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801265:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801269:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80126d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801271:	48 89 c6             	mov    %rax,%rsi
  801274:	48 bf af 11 80 00 00 	movabs $0x8011af,%rdi
  80127b:	00 00 00 
  80127e:	48 b8 d8 0b 80 00 00 	movabs $0x800bd8,%rax
  801285:	00 00 00 
  801288:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80128a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80128e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801291:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801294:	c9                   	leaveq 
  801295:	c3                   	retq   

0000000000801296 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801296:	55                   	push   %rbp
  801297:	48 89 e5             	mov    %rsp,%rbp
  80129a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012a1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012a8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012ae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012b5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012bc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012c3:	84 c0                	test   %al,%al
  8012c5:	74 20                	je     8012e7 <snprintf+0x51>
  8012c7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012cb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012cf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012d3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012d7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012db:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012df:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012e3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012e7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012ee:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012f5:	00 00 00 
  8012f8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012ff:	00 00 00 
  801302:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801306:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80130d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801314:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80131b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801322:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801329:	48 8b 0a             	mov    (%rdx),%rcx
  80132c:	48 89 08             	mov    %rcx,(%rax)
  80132f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801333:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801337:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80133b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80133f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801346:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80134d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801353:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80135a:	48 89 c7             	mov    %rax,%rdi
  80135d:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  801364:	00 00 00 
  801367:	ff d0                	callq  *%rax
  801369:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80136f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801375:	c9                   	leaveq 
  801376:	c3                   	retq   
	...

0000000000801378 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801378:	55                   	push   %rbp
  801379:	48 89 e5             	mov    %rsp,%rbp
  80137c:	48 83 ec 18          	sub    $0x18,%rsp
  801380:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801384:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80138b:	eb 09                	jmp    801396 <strlen+0x1e>
		n++;
  80138d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801391:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	84 c0                	test   %al,%al
  80139f:	75 ec                	jne    80138d <strlen+0x15>
		n++;
	return n;
  8013a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013a4:	c9                   	leaveq 
  8013a5:	c3                   	retq   

00000000008013a6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013a6:	55                   	push   %rbp
  8013a7:	48 89 e5             	mov    %rsp,%rbp
  8013aa:	48 83 ec 20          	sub    $0x20,%rsp
  8013ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013bd:	eb 0e                	jmp    8013cd <strnlen+0x27>
		n++;
  8013bf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013c3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013cd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013d2:	74 0b                	je     8013df <strnlen+0x39>
  8013d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d8:	0f b6 00             	movzbl (%rax),%eax
  8013db:	84 c0                	test   %al,%al
  8013dd:	75 e0                	jne    8013bf <strnlen+0x19>
		n++;
	return n;
  8013df:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013e2:	c9                   	leaveq 
  8013e3:	c3                   	retq   

00000000008013e4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013e4:	55                   	push   %rbp
  8013e5:	48 89 e5             	mov    %rsp,%rbp
  8013e8:	48 83 ec 20          	sub    $0x20,%rsp
  8013ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013fc:	90                   	nop
  8013fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801401:	0f b6 10             	movzbl (%rax),%edx
  801404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801408:	88 10                	mov    %dl,(%rax)
  80140a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	84 c0                	test   %al,%al
  801413:	0f 95 c0             	setne  %al
  801416:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80141b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801420:	84 c0                	test   %al,%al
  801422:	75 d9                	jne    8013fd <strcpy+0x19>
		/* do nothing */;
	return ret;
  801424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801428:	c9                   	leaveq 
  801429:	c3                   	retq   

000000000080142a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80142a:	55                   	push   %rbp
  80142b:	48 89 e5             	mov    %rsp,%rbp
  80142e:	48 83 ec 20          	sub    $0x20,%rsp
  801432:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801436:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80143a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143e:	48 89 c7             	mov    %rax,%rdi
  801441:	48 b8 78 13 80 00 00 	movabs $0x801378,%rax
  801448:	00 00 00 
  80144b:	ff d0                	callq  *%rax
  80144d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801453:	48 98                	cltq   
  801455:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801459:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80145d:	48 89 d6             	mov    %rdx,%rsi
  801460:	48 89 c7             	mov    %rax,%rdi
  801463:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  80146a:	00 00 00 
  80146d:	ff d0                	callq  *%rax
	return dst;
  80146f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801473:	c9                   	leaveq 
  801474:	c3                   	retq   

0000000000801475 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801475:	55                   	push   %rbp
  801476:	48 89 e5             	mov    %rsp,%rbp
  801479:	48 83 ec 28          	sub    $0x28,%rsp
  80147d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801481:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801485:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801489:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801491:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801498:	00 
  801499:	eb 27                	jmp    8014c2 <strncpy+0x4d>
		*dst++ = *src;
  80149b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80149f:	0f b6 10             	movzbl (%rax),%edx
  8014a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a6:	88 10                	mov    %dl,(%rax)
  8014a8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b1:	0f b6 00             	movzbl (%rax),%eax
  8014b4:	84 c0                	test   %al,%al
  8014b6:	74 05                	je     8014bd <strncpy+0x48>
			src++;
  8014b8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014ca:	72 cf                	jb     80149b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014d0:	c9                   	leaveq 
  8014d1:	c3                   	retq   

00000000008014d2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014d2:	55                   	push   %rbp
  8014d3:	48 89 e5             	mov    %rsp,%rbp
  8014d6:	48 83 ec 28          	sub    $0x28,%rsp
  8014da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014f3:	74 37                	je     80152c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8014f5:	eb 17                	jmp    80150e <strlcpy+0x3c>
			*dst++ = *src++;
  8014f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014fb:	0f b6 10             	movzbl (%rax),%edx
  8014fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801502:	88 10                	mov    %dl,(%rax)
  801504:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801509:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80150e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801513:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801518:	74 0b                	je     801525 <strlcpy+0x53>
  80151a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80151e:	0f b6 00             	movzbl (%rax),%eax
  801521:	84 c0                	test   %al,%al
  801523:	75 d2                	jne    8014f7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801529:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80152c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801534:	48 89 d1             	mov    %rdx,%rcx
  801537:	48 29 c1             	sub    %rax,%rcx
  80153a:	48 89 c8             	mov    %rcx,%rax
}
  80153d:	c9                   	leaveq 
  80153e:	c3                   	retq   

000000000080153f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80153f:	55                   	push   %rbp
  801540:	48 89 e5             	mov    %rsp,%rbp
  801543:	48 83 ec 10          	sub    $0x10,%rsp
  801547:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80154f:	eb 0a                	jmp    80155b <strcmp+0x1c>
		p++, q++;
  801551:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801556:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80155b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155f:	0f b6 00             	movzbl (%rax),%eax
  801562:	84 c0                	test   %al,%al
  801564:	74 12                	je     801578 <strcmp+0x39>
  801566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156a:	0f b6 10             	movzbl (%rax),%edx
  80156d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801571:	0f b6 00             	movzbl (%rax),%eax
  801574:	38 c2                	cmp    %al,%dl
  801576:	74 d9                	je     801551 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157c:	0f b6 00             	movzbl (%rax),%eax
  80157f:	0f b6 d0             	movzbl %al,%edx
  801582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	0f b6 c0             	movzbl %al,%eax
  80158c:	89 d1                	mov    %edx,%ecx
  80158e:	29 c1                	sub    %eax,%ecx
  801590:	89 c8                	mov    %ecx,%eax
}
  801592:	c9                   	leaveq 
  801593:	c3                   	retq   

0000000000801594 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801594:	55                   	push   %rbp
  801595:	48 89 e5             	mov    %rsp,%rbp
  801598:	48 83 ec 18          	sub    $0x18,%rsp
  80159c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015a8:	eb 0f                	jmp    8015b9 <strncmp+0x25>
		n--, p++, q++;
  8015aa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015b4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015b9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015be:	74 1d                	je     8015dd <strncmp+0x49>
  8015c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c4:	0f b6 00             	movzbl (%rax),%eax
  8015c7:	84 c0                	test   %al,%al
  8015c9:	74 12                	je     8015dd <strncmp+0x49>
  8015cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cf:	0f b6 10             	movzbl (%rax),%edx
  8015d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d6:	0f b6 00             	movzbl (%rax),%eax
  8015d9:	38 c2                	cmp    %al,%dl
  8015db:	74 cd                	je     8015aa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015dd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015e2:	75 07                	jne    8015eb <strncmp+0x57>
		return 0;
  8015e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e9:	eb 1a                	jmp    801605 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ef:	0f b6 00             	movzbl (%rax),%eax
  8015f2:	0f b6 d0             	movzbl %al,%edx
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	0f b6 c0             	movzbl %al,%eax
  8015ff:	89 d1                	mov    %edx,%ecx
  801601:	29 c1                	sub    %eax,%ecx
  801603:	89 c8                	mov    %ecx,%eax
}
  801605:	c9                   	leaveq 
  801606:	c3                   	retq   

0000000000801607 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801607:	55                   	push   %rbp
  801608:	48 89 e5             	mov    %rsp,%rbp
  80160b:	48 83 ec 10          	sub    $0x10,%rsp
  80160f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801613:	89 f0                	mov    %esi,%eax
  801615:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801618:	eb 17                	jmp    801631 <strchr+0x2a>
		if (*s == c)
  80161a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161e:	0f b6 00             	movzbl (%rax),%eax
  801621:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801624:	75 06                	jne    80162c <strchr+0x25>
			return (char *) s;
  801626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162a:	eb 15                	jmp    801641 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80162c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	84 c0                	test   %al,%al
  80163a:	75 de                	jne    80161a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80163c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801641:	c9                   	leaveq 
  801642:	c3                   	retq   

0000000000801643 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	48 83 ec 10          	sub    $0x10,%rsp
  80164b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80164f:	89 f0                	mov    %esi,%eax
  801651:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801654:	eb 11                	jmp    801667 <strfind+0x24>
		if (*s == c)
  801656:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801660:	74 12                	je     801674 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801662:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	84 c0                	test   %al,%al
  801670:	75 e4                	jne    801656 <strfind+0x13>
  801672:	eb 01                	jmp    801675 <strfind+0x32>
		if (*s == c)
			break;
  801674:	90                   	nop
	return (char *) s;
  801675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801679:	c9                   	leaveq 
  80167a:	c3                   	retq   

000000000080167b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80167b:	55                   	push   %rbp
  80167c:	48 89 e5             	mov    %rsp,%rbp
  80167f:	48 83 ec 18          	sub    $0x18,%rsp
  801683:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801687:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80168a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80168e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801693:	75 06                	jne    80169b <memset+0x20>
		return v;
  801695:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801699:	eb 69                	jmp    801704 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80169b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169f:	83 e0 03             	and    $0x3,%eax
  8016a2:	48 85 c0             	test   %rax,%rax
  8016a5:	75 48                	jne    8016ef <memset+0x74>
  8016a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ab:	83 e0 03             	and    $0x3,%eax
  8016ae:	48 85 c0             	test   %rax,%rax
  8016b1:	75 3c                	jne    8016ef <memset+0x74>
		c &= 0xFF;
  8016b3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016bd:	89 c2                	mov    %eax,%edx
  8016bf:	c1 e2 18             	shl    $0x18,%edx
  8016c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016c5:	c1 e0 10             	shl    $0x10,%eax
  8016c8:	09 c2                	or     %eax,%edx
  8016ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016cd:	c1 e0 08             	shl    $0x8,%eax
  8016d0:	09 d0                	or     %edx,%eax
  8016d2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8016d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d9:	48 89 c1             	mov    %rax,%rcx
  8016dc:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e7:	48 89 d7             	mov    %rdx,%rdi
  8016ea:	fc                   	cld    
  8016eb:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016ed:	eb 11                	jmp    801700 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016fa:	48 89 d7             	mov    %rdx,%rdi
  8016fd:	fc                   	cld    
  8016fe:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801704:	c9                   	leaveq 
  801705:	c3                   	retq   

0000000000801706 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801706:	55                   	push   %rbp
  801707:	48 89 e5             	mov    %rsp,%rbp
  80170a:	48 83 ec 28          	sub    $0x28,%rsp
  80170e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801712:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801716:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80171a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80171e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801726:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80172a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801732:	0f 83 88 00 00 00    	jae    8017c0 <memmove+0xba>
  801738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801740:	48 01 d0             	add    %rdx,%rax
  801743:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801747:	76 77                	jbe    8017c0 <memmove+0xba>
		s += n;
  801749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801755:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175d:	83 e0 03             	and    $0x3,%eax
  801760:	48 85 c0             	test   %rax,%rax
  801763:	75 3b                	jne    8017a0 <memmove+0x9a>
  801765:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801769:	83 e0 03             	and    $0x3,%eax
  80176c:	48 85 c0             	test   %rax,%rax
  80176f:	75 2f                	jne    8017a0 <memmove+0x9a>
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	83 e0 03             	and    $0x3,%eax
  801778:	48 85 c0             	test   %rax,%rax
  80177b:	75 23                	jne    8017a0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80177d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801781:	48 83 e8 04          	sub    $0x4,%rax
  801785:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801789:	48 83 ea 04          	sub    $0x4,%rdx
  80178d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801791:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801795:	48 89 c7             	mov    %rax,%rdi
  801798:	48 89 d6             	mov    %rdx,%rsi
  80179b:	fd                   	std    
  80179c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80179e:	eb 1d                	jmp    8017bd <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ac:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b4:	48 89 d7             	mov    %rdx,%rdi
  8017b7:	48 89 c1             	mov    %rax,%rcx
  8017ba:	fd                   	std    
  8017bb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017bd:	fc                   	cld    
  8017be:	eb 57                	jmp    801817 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c4:	83 e0 03             	and    $0x3,%eax
  8017c7:	48 85 c0             	test   %rax,%rax
  8017ca:	75 36                	jne    801802 <memmove+0xfc>
  8017cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d0:	83 e0 03             	and    $0x3,%eax
  8017d3:	48 85 c0             	test   %rax,%rax
  8017d6:	75 2a                	jne    801802 <memmove+0xfc>
  8017d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dc:	83 e0 03             	and    $0x3,%eax
  8017df:	48 85 c0             	test   %rax,%rax
  8017e2:	75 1e                	jne    801802 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	48 89 c1             	mov    %rax,%rcx
  8017eb:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017f7:	48 89 c7             	mov    %rax,%rdi
  8017fa:	48 89 d6             	mov    %rdx,%rsi
  8017fd:	fc                   	cld    
  8017fe:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801800:	eb 15                	jmp    801817 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801802:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801806:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80180a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80180e:	48 89 c7             	mov    %rax,%rdi
  801811:	48 89 d6             	mov    %rdx,%rsi
  801814:	fc                   	cld    
  801815:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80181b:	c9                   	leaveq 
  80181c:	c3                   	retq   

000000000080181d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80181d:	55                   	push   %rbp
  80181e:	48 89 e5             	mov    %rsp,%rbp
  801821:	48 83 ec 18          	sub    $0x18,%rsp
  801825:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801829:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80182d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801831:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801835:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801839:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183d:	48 89 ce             	mov    %rcx,%rsi
  801840:	48 89 c7             	mov    %rax,%rdi
  801843:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  80184a:	00 00 00 
  80184d:	ff d0                	callq  *%rax
}
  80184f:	c9                   	leaveq 
  801850:	c3                   	retq   

0000000000801851 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
  801855:	48 83 ec 28          	sub    $0x28,%rsp
  801859:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80185d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801861:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801869:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80186d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801871:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801875:	eb 38                	jmp    8018af <memcmp+0x5e>
		if (*s1 != *s2)
  801877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187b:	0f b6 10             	movzbl (%rax),%edx
  80187e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801882:	0f b6 00             	movzbl (%rax),%eax
  801885:	38 c2                	cmp    %al,%dl
  801887:	74 1c                	je     8018a5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188d:	0f b6 00             	movzbl (%rax),%eax
  801890:	0f b6 d0             	movzbl %al,%edx
  801893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801897:	0f b6 00             	movzbl (%rax),%eax
  80189a:	0f b6 c0             	movzbl %al,%eax
  80189d:	89 d1                	mov    %edx,%ecx
  80189f:	29 c1                	sub    %eax,%ecx
  8018a1:	89 c8                	mov    %ecx,%eax
  8018a3:	eb 20                	jmp    8018c5 <memcmp+0x74>
		s1++, s2++;
  8018a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018aa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018af:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018b4:	0f 95 c0             	setne  %al
  8018b7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8018bc:	84 c0                	test   %al,%al
  8018be:	75 b7                	jne    801877 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c5:	c9                   	leaveq 
  8018c6:	c3                   	retq   

00000000008018c7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	48 83 ec 28          	sub    $0x28,%rsp
  8018cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018d3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e2:	48 01 d0             	add    %rdx,%rax
  8018e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018e9:	eb 13                	jmp    8018fe <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ef:	0f b6 10             	movzbl (%rax),%edx
  8018f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018f5:	38 c2                	cmp    %al,%dl
  8018f7:	74 11                	je     80190a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018f9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801902:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801906:	72 e3                	jb     8018eb <memfind+0x24>
  801908:	eb 01                	jmp    80190b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80190a:	90                   	nop
	return (void *) s;
  80190b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 38          	sub    $0x38,%rsp
  801919:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80191d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801921:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80192b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801932:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801933:	eb 05                	jmp    80193a <strtol+0x29>
		s++;
  801935:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80193a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193e:	0f b6 00             	movzbl (%rax),%eax
  801941:	3c 20                	cmp    $0x20,%al
  801943:	74 f0                	je     801935 <strtol+0x24>
  801945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801949:	0f b6 00             	movzbl (%rax),%eax
  80194c:	3c 09                	cmp    $0x9,%al
  80194e:	74 e5                	je     801935 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801954:	0f b6 00             	movzbl (%rax),%eax
  801957:	3c 2b                	cmp    $0x2b,%al
  801959:	75 07                	jne    801962 <strtol+0x51>
		s++;
  80195b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801960:	eb 17                	jmp    801979 <strtol+0x68>
	else if (*s == '-')
  801962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801966:	0f b6 00             	movzbl (%rax),%eax
  801969:	3c 2d                	cmp    $0x2d,%al
  80196b:	75 0c                	jne    801979 <strtol+0x68>
		s++, neg = 1;
  80196d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801972:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801979:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80197d:	74 06                	je     801985 <strtol+0x74>
  80197f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801983:	75 28                	jne    8019ad <strtol+0x9c>
  801985:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801989:	0f b6 00             	movzbl (%rax),%eax
  80198c:	3c 30                	cmp    $0x30,%al
  80198e:	75 1d                	jne    8019ad <strtol+0x9c>
  801990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801994:	48 83 c0 01          	add    $0x1,%rax
  801998:	0f b6 00             	movzbl (%rax),%eax
  80199b:	3c 78                	cmp    $0x78,%al
  80199d:	75 0e                	jne    8019ad <strtol+0x9c>
		s += 2, base = 16;
  80199f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019a4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019ab:	eb 2c                	jmp    8019d9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019b1:	75 19                	jne    8019cc <strtol+0xbb>
  8019b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b7:	0f b6 00             	movzbl (%rax),%eax
  8019ba:	3c 30                	cmp    $0x30,%al
  8019bc:	75 0e                	jne    8019cc <strtol+0xbb>
		s++, base = 8;
  8019be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019c3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019ca:	eb 0d                	jmp    8019d9 <strtol+0xc8>
	else if (base == 0)
  8019cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019d0:	75 07                	jne    8019d9 <strtol+0xc8>
		base = 10;
  8019d2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dd:	0f b6 00             	movzbl (%rax),%eax
  8019e0:	3c 2f                	cmp    $0x2f,%al
  8019e2:	7e 1d                	jle    801a01 <strtol+0xf0>
  8019e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e8:	0f b6 00             	movzbl (%rax),%eax
  8019eb:	3c 39                	cmp    $0x39,%al
  8019ed:	7f 12                	jg     801a01 <strtol+0xf0>
			dig = *s - '0';
  8019ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f3:	0f b6 00             	movzbl (%rax),%eax
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 30             	sub    $0x30,%eax
  8019fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019ff:	eb 4e                	jmp    801a4f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a05:	0f b6 00             	movzbl (%rax),%eax
  801a08:	3c 60                	cmp    $0x60,%al
  801a0a:	7e 1d                	jle    801a29 <strtol+0x118>
  801a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a10:	0f b6 00             	movzbl (%rax),%eax
  801a13:	3c 7a                	cmp    $0x7a,%al
  801a15:	7f 12                	jg     801a29 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1b:	0f b6 00             	movzbl (%rax),%eax
  801a1e:	0f be c0             	movsbl %al,%eax
  801a21:	83 e8 57             	sub    $0x57,%eax
  801a24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a27:	eb 26                	jmp    801a4f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2d:	0f b6 00             	movzbl (%rax),%eax
  801a30:	3c 40                	cmp    $0x40,%al
  801a32:	7e 47                	jle    801a7b <strtol+0x16a>
  801a34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a38:	0f b6 00             	movzbl (%rax),%eax
  801a3b:	3c 5a                	cmp    $0x5a,%al
  801a3d:	7f 3c                	jg     801a7b <strtol+0x16a>
			dig = *s - 'A' + 10;
  801a3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a43:	0f b6 00             	movzbl (%rax),%eax
  801a46:	0f be c0             	movsbl %al,%eax
  801a49:	83 e8 37             	sub    $0x37,%eax
  801a4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a4f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a52:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a55:	7d 23                	jge    801a7a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801a57:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a5c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a5f:	48 98                	cltq   
  801a61:	48 89 c2             	mov    %rax,%rdx
  801a64:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801a69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a6c:	48 98                	cltq   
  801a6e:	48 01 d0             	add    %rdx,%rax
  801a71:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a75:	e9 5f ff ff ff       	jmpq   8019d9 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a7a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a7b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a80:	74 0b                	je     801a8d <strtol+0x17c>
		*endptr = (char *) s;
  801a82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a86:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a8a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a91:	74 09                	je     801a9c <strtol+0x18b>
  801a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a97:	48 f7 d8             	neg    %rax
  801a9a:	eb 04                	jmp    801aa0 <strtol+0x18f>
  801a9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801aa0:	c9                   	leaveq 
  801aa1:	c3                   	retq   

0000000000801aa2 <strstr>:

char * strstr(const char *in, const char *str)
{
  801aa2:	55                   	push   %rbp
  801aa3:	48 89 e5             	mov    %rsp,%rbp
  801aa6:	48 83 ec 30          	sub    $0x30,%rsp
  801aaa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801aae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801ab2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ab6:	0f b6 00             	movzbl (%rax),%eax
  801ab9:	88 45 ff             	mov    %al,-0x1(%rbp)
  801abc:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801ac1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ac5:	75 06                	jne    801acd <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801ac7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801acb:	eb 68                	jmp    801b35 <strstr+0x93>

    len = strlen(str);
  801acd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ad1:	48 89 c7             	mov    %rax,%rdi
  801ad4:	48 b8 78 13 80 00 00 	movabs $0x801378,%rax
  801adb:	00 00 00 
  801ade:	ff d0                	callq  *%rax
  801ae0:	48 98                	cltq   
  801ae2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801ae6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aea:	0f b6 00             	movzbl (%rax),%eax
  801aed:	88 45 ef             	mov    %al,-0x11(%rbp)
  801af0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801af5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801af9:	75 07                	jne    801b02 <strstr+0x60>
                return (char *) 0;
  801afb:	b8 00 00 00 00       	mov    $0x0,%eax
  801b00:	eb 33                	jmp    801b35 <strstr+0x93>
        } while (sc != c);
  801b02:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b06:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b09:	75 db                	jne    801ae6 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801b0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b17:	48 89 ce             	mov    %rcx,%rsi
  801b1a:	48 89 c7             	mov    %rax,%rdi
  801b1d:	48 b8 94 15 80 00 00 	movabs $0x801594,%rax
  801b24:	00 00 00 
  801b27:	ff d0                	callq  *%rax
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	75 b9                	jne    801ae6 <strstr+0x44>

    return (char *) (in - 1);
  801b2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b31:	48 83 e8 01          	sub    $0x1,%rax
}
  801b35:	c9                   	leaveq 
  801b36:	c3                   	retq   
	...

0000000000801b38 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	53                   	push   %rbx
  801b3d:	48 83 ec 58          	sub    $0x58,%rsp
  801b41:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b44:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b47:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b4b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b4f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b53:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b57:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b5a:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801b5d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b61:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b65:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b69:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b6d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b71:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801b74:	4c 89 c3             	mov    %r8,%rbx
  801b77:	cd 30                	int    $0x30
  801b79:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801b7d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801b81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801b85:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b89:	74 3e                	je     801bc9 <syscall+0x91>
  801b8b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b90:	7e 37                	jle    801bc9 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b96:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b99:	49 89 d0             	mov    %rdx,%r8
  801b9c:	89 c1                	mov    %eax,%ecx
  801b9e:	48 ba 00 4c 80 00 00 	movabs $0x804c00,%rdx
  801ba5:	00 00 00 
  801ba8:	be 23 00 00 00       	mov    $0x23,%esi
  801bad:	48 bf 1d 4c 80 00 00 	movabs $0x804c1d,%rdi
  801bb4:	00 00 00 
  801bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbc:	49 b9 ec 05 80 00 00 	movabs $0x8005ec,%r9
  801bc3:	00 00 00 
  801bc6:	41 ff d1             	callq  *%r9

	return ret;
  801bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bcd:	48 83 c4 58          	add    $0x58,%rsp
  801bd1:	5b                   	pop    %rbx
  801bd2:	5d                   	pop    %rbp
  801bd3:	c3                   	retq   

0000000000801bd4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bd4:	55                   	push   %rbp
  801bd5:	48 89 e5             	mov    %rsp,%rbp
  801bd8:	48 83 ec 20          	sub    $0x20,%rsp
  801bdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf3:	00 
  801bf4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c00:	48 89 d1             	mov    %rdx,%rcx
  801c03:	48 89 c2             	mov    %rax,%rdx
  801c06:	be 00 00 00 00       	mov    $0x0,%esi
  801c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c10:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801c17:	00 00 00 
  801c1a:	ff d0                	callq  *%rax
}
  801c1c:	c9                   	leaveq 
  801c1d:	c3                   	retq   

0000000000801c1e <sys_cgetc>:

int
sys_cgetc(void)
{
  801c1e:	55                   	push   %rbp
  801c1f:	48 89 e5             	mov    %rsp,%rbp
  801c22:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2d:	00 
  801c2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c44:	be 00 00 00 00       	mov    $0x0,%esi
  801c49:	bf 01 00 00 00       	mov    $0x1,%edi
  801c4e:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801c55:	00 00 00 
  801c58:	ff d0                	callq  *%rax
}
  801c5a:	c9                   	leaveq 
  801c5b:	c3                   	retq   

0000000000801c5c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c5c:	55                   	push   %rbp
  801c5d:	48 89 e5             	mov    %rsp,%rbp
  801c60:	48 83 ec 20          	sub    $0x20,%rsp
  801c64:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6a:	48 98                	cltq   
  801c6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c73:	00 
  801c74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c80:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c85:	48 89 c2             	mov    %rax,%rdx
  801c88:	be 01 00 00 00       	mov    $0x1,%esi
  801c8d:	bf 03 00 00 00       	mov    $0x3,%edi
  801c92:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801c99:	00 00 00 
  801c9c:	ff d0                	callq  *%rax
}
  801c9e:	c9                   	leaveq 
  801c9f:	c3                   	retq   

0000000000801ca0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ca0:	55                   	push   %rbp
  801ca1:	48 89 e5             	mov    %rsp,%rbp
  801ca4:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ca8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801caf:	00 
  801cb0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc6:	be 00 00 00 00       	mov    $0x0,%esi
  801ccb:	bf 02 00 00 00       	mov    $0x2,%edi
  801cd0:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	callq  *%rax
}
  801cdc:	c9                   	leaveq 
  801cdd:	c3                   	retq   

0000000000801cde <sys_yield>:

void
sys_yield(void)
{
  801cde:	55                   	push   %rbp
  801cdf:	48 89 e5             	mov    %rsp,%rbp
  801ce2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ce6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ced:	00 
  801cee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cff:	ba 00 00 00 00       	mov    $0x0,%edx
  801d04:	be 00 00 00 00       	mov    $0x0,%esi
  801d09:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d0e:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801d15:	00 00 00 
  801d18:	ff d0                	callq  *%rax
}
  801d1a:	c9                   	leaveq 
  801d1b:	c3                   	retq   

0000000000801d1c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d1c:	55                   	push   %rbp
  801d1d:	48 89 e5             	mov    %rsp,%rbp
  801d20:	48 83 ec 20          	sub    $0x20,%rsp
  801d24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d31:	48 63 c8             	movslq %eax,%rcx
  801d34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3b:	48 98                	cltq   
  801d3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d44:	00 
  801d45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4b:	49 89 c8             	mov    %rcx,%r8
  801d4e:	48 89 d1             	mov    %rdx,%rcx
  801d51:	48 89 c2             	mov    %rax,%rdx
  801d54:	be 01 00 00 00       	mov    $0x1,%esi
  801d59:	bf 04 00 00 00       	mov    $0x4,%edi
  801d5e:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	callq  *%rax
}
  801d6a:	c9                   	leaveq 
  801d6b:	c3                   	retq   

0000000000801d6c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d6c:	55                   	push   %rbp
  801d6d:	48 89 e5             	mov    %rsp,%rbp
  801d70:	48 83 ec 30          	sub    $0x30,%rsp
  801d74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d7b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d7e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d82:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d86:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d89:	48 63 c8             	movslq %eax,%rcx
  801d8c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d93:	48 63 f0             	movslq %eax,%rsi
  801d96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9d:	48 98                	cltq   
  801d9f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801da3:	49 89 f9             	mov    %rdi,%r9
  801da6:	49 89 f0             	mov    %rsi,%r8
  801da9:	48 89 d1             	mov    %rdx,%rcx
  801dac:	48 89 c2             	mov    %rax,%rdx
  801daf:	be 01 00 00 00       	mov    $0x1,%esi
  801db4:	bf 05 00 00 00       	mov    $0x5,%edi
  801db9:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801dc0:	00 00 00 
  801dc3:	ff d0                	callq  *%rax
}
  801dc5:	c9                   	leaveq 
  801dc6:	c3                   	retq   

0000000000801dc7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dc7:	55                   	push   %rbp
  801dc8:	48 89 e5             	mov    %rsp,%rbp
  801dcb:	48 83 ec 20          	sub    $0x20,%rsp
  801dcf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ddd:	48 98                	cltq   
  801ddf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de6:	00 
  801de7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ded:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df3:	48 89 d1             	mov    %rdx,%rcx
  801df6:	48 89 c2             	mov    %rax,%rdx
  801df9:	be 01 00 00 00       	mov    $0x1,%esi
  801dfe:	bf 06 00 00 00       	mov    $0x6,%edi
  801e03:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801e0a:	00 00 00 
  801e0d:	ff d0                	callq  *%rax
}
  801e0f:	c9                   	leaveq 
  801e10:	c3                   	retq   

0000000000801e11 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e11:	55                   	push   %rbp
  801e12:	48 89 e5             	mov    %rsp,%rbp
  801e15:	48 83 ec 20          	sub    $0x20,%rsp
  801e19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e1c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e22:	48 63 d0             	movslq %eax,%rdx
  801e25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e28:	48 98                	cltq   
  801e2a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e31:	00 
  801e32:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e38:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e3e:	48 89 d1             	mov    %rdx,%rcx
  801e41:	48 89 c2             	mov    %rax,%rdx
  801e44:	be 01 00 00 00       	mov    $0x1,%esi
  801e49:	bf 08 00 00 00       	mov    $0x8,%edi
  801e4e:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801e55:	00 00 00 
  801e58:	ff d0                	callq  *%rax
}
  801e5a:	c9                   	leaveq 
  801e5b:	c3                   	retq   

0000000000801e5c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e5c:	55                   	push   %rbp
  801e5d:	48 89 e5             	mov    %rsp,%rbp
  801e60:	48 83 ec 20          	sub    $0x20,%rsp
  801e64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e72:	48 98                	cltq   
  801e74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e7b:	00 
  801e7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e88:	48 89 d1             	mov    %rdx,%rcx
  801e8b:	48 89 c2             	mov    %rax,%rdx
  801e8e:	be 01 00 00 00       	mov    $0x1,%esi
  801e93:	bf 09 00 00 00       	mov    $0x9,%edi
  801e98:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801e9f:	00 00 00 
  801ea2:	ff d0                	callq  *%rax
}
  801ea4:	c9                   	leaveq 
  801ea5:	c3                   	retq   

0000000000801ea6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ea6:	55                   	push   %rbp
  801ea7:	48 89 e5             	mov    %rsp,%rbp
  801eaa:	48 83 ec 20          	sub    $0x20,%rsp
  801eae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801eb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ebc:	48 98                	cltq   
  801ebe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ec5:	00 
  801ec6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ecc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed2:	48 89 d1             	mov    %rdx,%rcx
  801ed5:	48 89 c2             	mov    %rax,%rdx
  801ed8:	be 01 00 00 00       	mov    $0x1,%esi
  801edd:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ee2:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	callq  *%rax
}
  801eee:	c9                   	leaveq 
  801eef:	c3                   	retq   

0000000000801ef0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ef0:	55                   	push   %rbp
  801ef1:	48 89 e5             	mov    %rsp,%rbp
  801ef4:	48 83 ec 30          	sub    $0x30,%rsp
  801ef8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801efb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801eff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f03:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f09:	48 63 f0             	movslq %eax,%rsi
  801f0c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f13:	48 98                	cltq   
  801f15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f20:	00 
  801f21:	49 89 f1             	mov    %rsi,%r9
  801f24:	49 89 c8             	mov    %rcx,%r8
  801f27:	48 89 d1             	mov    %rdx,%rcx
  801f2a:	48 89 c2             	mov    %rax,%rdx
  801f2d:	be 00 00 00 00       	mov    $0x0,%esi
  801f32:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f37:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801f3e:	00 00 00 
  801f41:	ff d0                	callq  *%rax
}
  801f43:	c9                   	leaveq 
  801f44:	c3                   	retq   

0000000000801f45 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f45:	55                   	push   %rbp
  801f46:	48 89 e5             	mov    %rsp,%rbp
  801f49:	48 83 ec 20          	sub    $0x20,%rsp
  801f4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f5c:	00 
  801f5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6e:	48 89 c2             	mov    %rax,%rdx
  801f71:	be 01 00 00 00       	mov    $0x1,%esi
  801f76:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f7b:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
}
  801f87:	c9                   	leaveq 
  801f88:	c3                   	retq   

0000000000801f89 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801f89:	55                   	push   %rbp
  801f8a:	48 89 e5             	mov    %rsp,%rbp
  801f8d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f98:	00 
  801f99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801faa:	ba 00 00 00 00       	mov    $0x0,%edx
  801faf:	be 00 00 00 00       	mov    $0x0,%esi
  801fb4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801fb9:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801fc0:	00 00 00 
  801fc3:	ff d0                	callq  *%rax
}
  801fc5:	c9                   	leaveq 
  801fc6:	c3                   	retq   

0000000000801fc7 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801fc7:	55                   	push   %rbp
  801fc8:	48 89 e5             	mov    %rsp,%rbp
  801fcb:	48 83 ec 20          	sub    $0x20,%rsp
  801fcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801fd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fdf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fe6:	00 
  801fe7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff3:	48 89 d1             	mov    %rdx,%rcx
  801ff6:	48 89 c2             	mov    %rax,%rdx
  801ff9:	be 00 00 00 00       	mov    $0x0,%esi
  801ffe:	bf 0f 00 00 00       	mov    $0xf,%edi
  802003:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
}
  80200f:	c9                   	leaveq 
  802010:	c3                   	retq   

0000000000802011 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802011:	55                   	push   %rbp
  802012:	48 89 e5             	mov    %rsp,%rbp
  802015:	48 83 ec 20          	sub    $0x20,%rsp
  802019:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80201d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802025:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802029:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802030:	00 
  802031:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802037:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80203d:	48 89 d1             	mov    %rdx,%rcx
  802040:	48 89 c2             	mov    %rax,%rdx
  802043:	be 00 00 00 00       	mov    $0x0,%esi
  802048:	bf 10 00 00 00       	mov    $0x10,%edi
  80204d:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  802054:	00 00 00 
  802057:	ff d0                	callq  *%rax
}
  802059:	c9                   	leaveq 
  80205a:	c3                   	retq   
	...

000000000080205c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80205c:	55                   	push   %rbp
  80205d:	48 89 e5             	mov    %rsp,%rbp
  802060:	48 83 ec 18          	sub    $0x18,%rsp
  802064:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802068:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80206c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  802070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802074:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802078:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  80207b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802083:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  802087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80208b:	8b 00                	mov    (%rax),%eax
  80208d:	83 f8 01             	cmp    $0x1,%eax
  802090:	7e 13                	jle    8020a5 <argstart+0x49>
  802092:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  802097:	74 0c                	je     8020a5 <argstart+0x49>
  802099:	48 b8 2b 4c 80 00 00 	movabs $0x804c2b,%rax
  8020a0:	00 00 00 
  8020a3:	eb 05                	jmp    8020aa <argstart+0x4e>
  8020a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020ae:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8020b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b6:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8020bd:	00 
}
  8020be:	c9                   	leaveq 
  8020bf:	c3                   	retq   

00000000008020c0 <argnext>:

int
argnext(struct Argstate *args)
{
  8020c0:	55                   	push   %rbp
  8020c1:	48 89 e5             	mov    %rsp,%rbp
  8020c4:	48 83 ec 20          	sub    $0x20,%rsp
  8020c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8020cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d0:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8020d7:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8020d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020dc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020e0:	48 85 c0             	test   %rax,%rax
  8020e3:	75 0a                	jne    8020ef <argnext+0x2f>
		return -1;
  8020e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020ea:	e9 24 01 00 00       	jmpq   802213 <argnext+0x153>

	if (!*args->curarg) {
  8020ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020f7:	0f b6 00             	movzbl (%rax),%eax
  8020fa:	84 c0                	test   %al,%al
  8020fc:	0f 85 d5 00 00 00    	jne    8021d7 <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802106:	48 8b 00             	mov    (%rax),%rax
  802109:	8b 00                	mov    (%rax),%eax
  80210b:	83 f8 01             	cmp    $0x1,%eax
  80210e:	0f 84 ee 00 00 00    	je     802202 <argnext+0x142>
		    || args->argv[1][0] != '-'
  802114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802118:	48 8b 40 08          	mov    0x8(%rax),%rax
  80211c:	48 83 c0 08          	add    $0x8,%rax
  802120:	48 8b 00             	mov    (%rax),%rax
  802123:	0f b6 00             	movzbl (%rax),%eax
  802126:	3c 2d                	cmp    $0x2d,%al
  802128:	0f 85 d4 00 00 00    	jne    802202 <argnext+0x142>
		    || args->argv[1][1] == '\0')
  80212e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802132:	48 8b 40 08          	mov    0x8(%rax),%rax
  802136:	48 83 c0 08          	add    $0x8,%rax
  80213a:	48 8b 00             	mov    (%rax),%rax
  80213d:	48 83 c0 01          	add    $0x1,%rax
  802141:	0f b6 00             	movzbl (%rax),%eax
  802144:	84 c0                	test   %al,%al
  802146:	0f 84 b6 00 00 00    	je     802202 <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80214c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802150:	48 8b 40 08          	mov    0x8(%rax),%rax
  802154:	48 83 c0 08          	add    $0x8,%rax
  802158:	48 8b 00             	mov    (%rax),%rax
  80215b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80215f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802163:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216b:	48 8b 00             	mov    (%rax),%rax
  80216e:	8b 00                	mov    (%rax),%eax
  802170:	83 e8 01             	sub    $0x1,%eax
  802173:	48 98                	cltq   
  802175:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80217c:	00 
  80217d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802181:	48 8b 40 08          	mov    0x8(%rax),%rax
  802185:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802191:	48 83 c0 08          	add    $0x8,%rax
  802195:	48 89 ce             	mov    %rcx,%rsi
  802198:	48 89 c7             	mov    %rax,%rdi
  80219b:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  8021a2:	00 00 00 
  8021a5:	ff d0                	callq  *%rax
		(*args->argc)--;
  8021a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ab:	48 8b 00             	mov    (%rax),%rax
  8021ae:	8b 10                	mov    (%rax),%edx
  8021b0:	83 ea 01             	sub    $0x1,%edx
  8021b3:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8021b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021bd:	0f b6 00             	movzbl (%rax),%eax
  8021c0:	3c 2d                	cmp    $0x2d,%al
  8021c2:	75 13                	jne    8021d7 <argnext+0x117>
  8021c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021cc:	48 83 c0 01          	add    $0x1,%rax
  8021d0:	0f b6 00             	movzbl (%rax),%eax
  8021d3:	84 c0                	test   %al,%al
  8021d5:	74 2a                	je     802201 <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8021d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021db:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021df:	0f b6 00             	movzbl (%rax),%eax
  8021e2:	0f b6 c0             	movzbl %al,%eax
  8021e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8021e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ec:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8021fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ff:	eb 12                	jmp    802213 <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  802201:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

    endofargs:
	args->curarg = 0;
  802202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802206:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80220d:	00 
	return -1;
  80220e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  802213:	c9                   	leaveq 
  802214:	c3                   	retq   

0000000000802215 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  802215:	55                   	push   %rbp
  802216:	48 89 e5             	mov    %rsp,%rbp
  802219:	48 83 ec 10          	sub    $0x10,%rsp
  80221d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802225:	48 8b 40 18          	mov    0x18(%rax),%rax
  802229:	48 85 c0             	test   %rax,%rax
  80222c:	74 0a                	je     802238 <argvalue+0x23>
  80222e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802232:	48 8b 40 18          	mov    0x18(%rax),%rax
  802236:	eb 13                	jmp    80224b <argvalue+0x36>
  802238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223c:	48 89 c7             	mov    %rax,%rdi
  80223f:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  802246:	00 00 00 
  802249:	ff d0                	callq  *%rax
}
  80224b:	c9                   	leaveq 
  80224c:	c3                   	retq   

000000000080224d <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80224d:	55                   	push   %rbp
  80224e:	48 89 e5             	mov    %rsp,%rbp
  802251:	48 83 ec 10          	sub    $0x10,%rsp
  802255:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  802259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802261:	48 85 c0             	test   %rax,%rax
  802264:	75 0a                	jne    802270 <argnextvalue+0x23>
		return 0;
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
  80226b:	e9 c8 00 00 00       	jmpq   802338 <argnextvalue+0xeb>
	if (*args->curarg) {
  802270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802274:	48 8b 40 10          	mov    0x10(%rax),%rax
  802278:	0f b6 00             	movzbl (%rax),%eax
  80227b:	84 c0                	test   %al,%al
  80227d:	74 27                	je     8022a6 <argnextvalue+0x59>
		args->argvalue = args->curarg;
  80227f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802283:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228b:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  80228f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802293:	48 ba 2b 4c 80 00 00 	movabs $0x804c2b,%rdx
  80229a:	00 00 00 
  80229d:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8022a1:	e9 8a 00 00 00       	jmpq   802330 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  8022a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022aa:	48 8b 00             	mov    (%rax),%rax
  8022ad:	8b 00                	mov    (%rax),%eax
  8022af:	83 f8 01             	cmp    $0x1,%eax
  8022b2:	7e 64                	jle    802318 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  8022b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022bc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c4:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8022c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cc:	48 8b 00             	mov    (%rax),%rax
  8022cf:	8b 00                	mov    (%rax),%eax
  8022d1:	83 e8 01             	sub    $0x1,%eax
  8022d4:	48 98                	cltq   
  8022d6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8022dd:	00 
  8022de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022e6:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8022ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022f2:	48 83 c0 08          	add    $0x8,%rax
  8022f6:	48 89 ce             	mov    %rcx,%rsi
  8022f9:	48 89 c7             	mov    %rax,%rdi
  8022fc:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  802303:	00 00 00 
  802306:	ff d0                	callq  *%rax
		(*args->argc)--;
  802308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230c:	48 8b 00             	mov    (%rax),%rax
  80230f:	8b 10                	mov    (%rax),%edx
  802311:	83 ea 01             	sub    $0x1,%edx
  802314:	89 10                	mov    %edx,(%rax)
  802316:	eb 18                	jmp    802330 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  802318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80231c:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802323:	00 
		args->curarg = 0;
  802324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802328:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80232f:	00 
	}
	return (char*) args->argvalue;
  802330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802334:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  802338:	c9                   	leaveq 
  802339:	c3                   	retq   
	...

000000000080233c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80233c:	55                   	push   %rbp
  80233d:	48 89 e5             	mov    %rsp,%rbp
  802340:	48 83 ec 08          	sub    $0x8,%rsp
  802344:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802348:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80234c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802353:	ff ff ff 
  802356:	48 01 d0             	add    %rdx,%rax
  802359:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80235d:	c9                   	leaveq 
  80235e:	c3                   	retq   

000000000080235f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80235f:	55                   	push   %rbp
  802360:	48 89 e5             	mov    %rsp,%rbp
  802363:	48 83 ec 08          	sub    $0x8,%rsp
  802367:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80236b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80236f:	48 89 c7             	mov    %rax,%rdi
  802372:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
  80237e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802384:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802388:	c9                   	leaveq 
  802389:	c3                   	retq   

000000000080238a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80238a:	55                   	push   %rbp
  80238b:	48 89 e5             	mov    %rsp,%rbp
  80238e:	48 83 ec 18          	sub    $0x18,%rsp
  802392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80239d:	eb 6b                	jmp    80240a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80239f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a2:	48 98                	cltq   
  8023a4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8023ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b6:	48 89 c2             	mov    %rax,%rdx
  8023b9:	48 c1 ea 15          	shr    $0x15,%rdx
  8023bd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023c4:	01 00 00 
  8023c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023cb:	83 e0 01             	and    $0x1,%eax
  8023ce:	48 85 c0             	test   %rax,%rax
  8023d1:	74 21                	je     8023f4 <fd_alloc+0x6a>
  8023d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d7:	48 89 c2             	mov    %rax,%rdx
  8023da:	48 c1 ea 0c          	shr    $0xc,%rdx
  8023de:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023e5:	01 00 00 
  8023e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ec:	83 e0 01             	and    $0x1,%eax
  8023ef:	48 85 c0             	test   %rax,%rax
  8023f2:	75 12                	jne    802406 <fd_alloc+0x7c>
			*fd_store = fd;
  8023f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023fc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802404:	eb 1a                	jmp    802420 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802406:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80240a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80240e:	7e 8f                	jle    80239f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802414:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80241b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802420:	c9                   	leaveq 
  802421:	c3                   	retq   

0000000000802422 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802422:	55                   	push   %rbp
  802423:	48 89 e5             	mov    %rsp,%rbp
  802426:	48 83 ec 20          	sub    $0x20,%rsp
  80242a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80242d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802431:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802435:	78 06                	js     80243d <fd_lookup+0x1b>
  802437:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80243b:	7e 07                	jle    802444 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80243d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802442:	eb 6c                	jmp    8024b0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802444:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802447:	48 98                	cltq   
  802449:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80244f:	48 c1 e0 0c          	shl    $0xc,%rax
  802453:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245b:	48 89 c2             	mov    %rax,%rdx
  80245e:	48 c1 ea 15          	shr    $0x15,%rdx
  802462:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802469:	01 00 00 
  80246c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802470:	83 e0 01             	and    $0x1,%eax
  802473:	48 85 c0             	test   %rax,%rax
  802476:	74 21                	je     802499 <fd_lookup+0x77>
  802478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247c:	48 89 c2             	mov    %rax,%rdx
  80247f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802483:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80248a:	01 00 00 
  80248d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802491:	83 e0 01             	and    $0x1,%eax
  802494:	48 85 c0             	test   %rax,%rax
  802497:	75 07                	jne    8024a0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249e:	eb 10                	jmp    8024b0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024a8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b0:	c9                   	leaveq 
  8024b1:	c3                   	retq   

00000000008024b2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024b2:	55                   	push   %rbp
  8024b3:	48 89 e5             	mov    %rsp,%rbp
  8024b6:	48 83 ec 30          	sub    $0x30,%rsp
  8024ba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024be:	89 f0                	mov    %esi,%eax
  8024c0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c7:	48 89 c7             	mov    %rax,%rdi
  8024ca:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	callq  *%rax
  8024d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024da:	48 89 d6             	mov    %rdx,%rsi
  8024dd:	89 c7                	mov    %eax,%edi
  8024df:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	callq  *%rax
  8024eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f2:	78 0a                	js     8024fe <fd_close+0x4c>
	    || fd != fd2)
  8024f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024fc:	74 12                	je     802510 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024fe:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802502:	74 05                	je     802509 <fd_close+0x57>
  802504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802507:	eb 05                	jmp    80250e <fd_close+0x5c>
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
  80250e:	eb 69                	jmp    802579 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802510:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802514:	8b 00                	mov    (%rax),%eax
  802516:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80251a:	48 89 d6             	mov    %rdx,%rsi
  80251d:	89 c7                	mov    %eax,%edi
  80251f:	48 b8 7b 25 80 00 00 	movabs $0x80257b,%rax
  802526:	00 00 00 
  802529:	ff d0                	callq  *%rax
  80252b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802532:	78 2a                	js     80255e <fd_close+0xac>
		if (dev->dev_close)
  802534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802538:	48 8b 40 20          	mov    0x20(%rax),%rax
  80253c:	48 85 c0             	test   %rax,%rax
  80253f:	74 16                	je     802557 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802545:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80254d:	48 89 c7             	mov    %rax,%rdi
  802550:	ff d2                	callq  *%rdx
  802552:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802555:	eb 07                	jmp    80255e <fd_close+0xac>
		else
			r = 0;
  802557:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80255e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802562:	48 89 c6             	mov    %rax,%rsi
  802565:	bf 00 00 00 00       	mov    $0x0,%edi
  80256a:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  802571:	00 00 00 
  802574:	ff d0                	callq  *%rax
	return r;
  802576:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802579:	c9                   	leaveq 
  80257a:	c3                   	retq   

000000000080257b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80257b:	55                   	push   %rbp
  80257c:	48 89 e5             	mov    %rsp,%rbp
  80257f:	48 83 ec 20          	sub    $0x20,%rsp
  802583:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802586:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80258a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802591:	eb 41                	jmp    8025d4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802593:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80259a:	00 00 00 
  80259d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025a0:	48 63 d2             	movslq %edx,%rdx
  8025a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a7:	8b 00                	mov    (%rax),%eax
  8025a9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025ac:	75 22                	jne    8025d0 <dev_lookup+0x55>
			*dev = devtab[i];
  8025ae:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025b5:	00 00 00 
  8025b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025bb:	48 63 d2             	movslq %edx,%rdx
  8025be:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8025c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	eb 60                	jmp    802630 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025d4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025db:	00 00 00 
  8025de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025e1:	48 63 d2             	movslq %edx,%rdx
  8025e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e8:	48 85 c0             	test   %rax,%rax
  8025eb:	75 a6                	jne    802593 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025ed:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  8025f4:	00 00 00 
  8025f7:	48 8b 00             	mov    (%rax),%rax
  8025fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802600:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802603:	89 c6                	mov    %eax,%esi
  802605:	48 bf 30 4c 80 00 00 	movabs $0x804c30,%rdi
  80260c:	00 00 00 
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	48 b9 27 08 80 00 00 	movabs $0x800827,%rcx
  80261b:	00 00 00 
  80261e:	ff d1                	callq  *%rcx
	*dev = 0;
  802620:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802624:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80262b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802630:	c9                   	leaveq 
  802631:	c3                   	retq   

0000000000802632 <close>:

int
close(int fdnum)
{
  802632:	55                   	push   %rbp
  802633:	48 89 e5             	mov    %rsp,%rbp
  802636:	48 83 ec 20          	sub    $0x20,%rsp
  80263a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80263d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802641:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802644:	48 89 d6             	mov    %rdx,%rsi
  802647:	89 c7                	mov    %eax,%edi
  802649:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  802650:	00 00 00 
  802653:	ff d0                	callq  *%rax
  802655:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802658:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265c:	79 05                	jns    802663 <close+0x31>
		return r;
  80265e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802661:	eb 18                	jmp    80267b <close+0x49>
	else
		return fd_close(fd, 1);
  802663:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802667:	be 01 00 00 00       	mov    $0x1,%esi
  80266c:	48 89 c7             	mov    %rax,%rdi
  80266f:	48 b8 b2 24 80 00 00 	movabs $0x8024b2,%rax
  802676:	00 00 00 
  802679:	ff d0                	callq  *%rax
}
  80267b:	c9                   	leaveq 
  80267c:	c3                   	retq   

000000000080267d <close_all>:

void
close_all(void)
{
  80267d:	55                   	push   %rbp
  80267e:	48 89 e5             	mov    %rsp,%rbp
  802681:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802685:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80268c:	eb 15                	jmp    8026a3 <close_all+0x26>
		close(i);
  80268e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802691:	89 c7                	mov    %eax,%edi
  802693:	48 b8 32 26 80 00 00 	movabs $0x802632,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80269f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026a3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026a7:	7e e5                	jle    80268e <close_all+0x11>
		close(i);
}
  8026a9:	c9                   	leaveq 
  8026aa:	c3                   	retq   

00000000008026ab <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026ab:	55                   	push   %rbp
  8026ac:	48 89 e5             	mov    %rsp,%rbp
  8026af:	48 83 ec 40          	sub    $0x40,%rsp
  8026b3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8026b6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8026b9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8026bd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026c0:	48 89 d6             	mov    %rdx,%rsi
  8026c3:	89 c7                	mov    %eax,%edi
  8026c5:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  8026cc:	00 00 00 
  8026cf:	ff d0                	callq  *%rax
  8026d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d8:	79 08                	jns    8026e2 <dup+0x37>
		return r;
  8026da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026dd:	e9 70 01 00 00       	jmpq   802852 <dup+0x1a7>
	close(newfdnum);
  8026e2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026e5:	89 c7                	mov    %eax,%edi
  8026e7:	48 b8 32 26 80 00 00 	movabs $0x802632,%rax
  8026ee:	00 00 00 
  8026f1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026f3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026f6:	48 98                	cltq   
  8026f8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026fe:	48 c1 e0 0c          	shl    $0xc,%rax
  802702:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802706:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80270a:	48 89 c7             	mov    %rax,%rdi
  80270d:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  802714:	00 00 00 
  802717:	ff d0                	callq  *%rax
  802719:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80271d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802721:	48 89 c7             	mov    %rax,%rdi
  802724:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  80272b:	00 00 00 
  80272e:	ff d0                	callq  *%rax
  802730:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802738:	48 89 c2             	mov    %rax,%rdx
  80273b:	48 c1 ea 15          	shr    $0x15,%rdx
  80273f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802746:	01 00 00 
  802749:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274d:	83 e0 01             	and    $0x1,%eax
  802750:	84 c0                	test   %al,%al
  802752:	74 71                	je     8027c5 <dup+0x11a>
  802754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802758:	48 89 c2             	mov    %rax,%rdx
  80275b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80275f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802766:	01 00 00 
  802769:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80276d:	83 e0 01             	and    $0x1,%eax
  802770:	84 c0                	test   %al,%al
  802772:	74 51                	je     8027c5 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802778:	48 89 c2             	mov    %rax,%rdx
  80277b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80277f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802786:	01 00 00 
  802789:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278d:	89 c1                	mov    %eax,%ecx
  80278f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802795:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279d:	41 89 c8             	mov    %ecx,%r8d
  8027a0:	48 89 d1             	mov    %rdx,%rcx
  8027a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a8:	48 89 c6             	mov    %rax,%rsi
  8027ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b0:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8027b7:	00 00 00 
  8027ba:	ff d0                	callq  *%rax
  8027bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c3:	78 56                	js     80281b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c9:	48 89 c2             	mov    %rax,%rdx
  8027cc:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027d7:	01 00 00 
  8027da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027de:	89 c1                	mov    %eax,%ecx
  8027e0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8027e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027ee:	41 89 c8             	mov    %ecx,%r8d
  8027f1:	48 89 d1             	mov    %rdx,%rcx
  8027f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f9:	48 89 c6             	mov    %rax,%rsi
  8027fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802801:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  802808:	00 00 00 
  80280b:	ff d0                	callq  *%rax
  80280d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802810:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802814:	78 08                	js     80281e <dup+0x173>
		goto err;

	return newfdnum;
  802816:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802819:	eb 37                	jmp    802852 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80281b:	90                   	nop
  80281c:	eb 01                	jmp    80281f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80281e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80281f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802823:	48 89 c6             	mov    %rax,%rsi
  802826:	bf 00 00 00 00       	mov    $0x0,%edi
  80282b:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  802832:	00 00 00 
  802835:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802837:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80283b:	48 89 c6             	mov    %rax,%rsi
  80283e:	bf 00 00 00 00       	mov    $0x0,%edi
  802843:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  80284a:	00 00 00 
  80284d:	ff d0                	callq  *%rax
	return r;
  80284f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802852:	c9                   	leaveq 
  802853:	c3                   	retq   

0000000000802854 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802854:	55                   	push   %rbp
  802855:	48 89 e5             	mov    %rsp,%rbp
  802858:	48 83 ec 40          	sub    $0x40,%rsp
  80285c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80285f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802863:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802867:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80286b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80286e:	48 89 d6             	mov    %rdx,%rsi
  802871:	89 c7                	mov    %eax,%edi
  802873:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  80287a:	00 00 00 
  80287d:	ff d0                	callq  *%rax
  80287f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802882:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802886:	78 24                	js     8028ac <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288c:	8b 00                	mov    (%rax),%eax
  80288e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802892:	48 89 d6             	mov    %rdx,%rsi
  802895:	89 c7                	mov    %eax,%edi
  802897:	48 b8 7b 25 80 00 00 	movabs $0x80257b,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax
  8028a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028aa:	79 05                	jns    8028b1 <read+0x5d>
		return r;
  8028ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028af:	eb 7a                	jmp    80292b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b5:	8b 40 08             	mov    0x8(%rax),%eax
  8028b8:	83 e0 03             	and    $0x3,%eax
  8028bb:	83 f8 01             	cmp    $0x1,%eax
  8028be:	75 3a                	jne    8028fa <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028c0:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  8028c7:	00 00 00 
  8028ca:	48 8b 00             	mov    (%rax),%rax
  8028cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028d6:	89 c6                	mov    %eax,%esi
  8028d8:	48 bf 4f 4c 80 00 00 	movabs $0x804c4f,%rdi
  8028df:	00 00 00 
  8028e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e7:	48 b9 27 08 80 00 00 	movabs $0x800827,%rcx
  8028ee:	00 00 00 
  8028f1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028f8:	eb 31                	jmp    80292b <read+0xd7>
	}
	if (!dev->dev_read)
  8028fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fe:	48 8b 40 10          	mov    0x10(%rax),%rax
  802902:	48 85 c0             	test   %rax,%rax
  802905:	75 07                	jne    80290e <read+0xba>
		return -E_NOT_SUPP;
  802907:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80290c:	eb 1d                	jmp    80292b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80290e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802912:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80291e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802922:	48 89 ce             	mov    %rcx,%rsi
  802925:	48 89 c7             	mov    %rax,%rdi
  802928:	41 ff d0             	callq  *%r8
}
  80292b:	c9                   	leaveq 
  80292c:	c3                   	retq   

000000000080292d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80292d:	55                   	push   %rbp
  80292e:	48 89 e5             	mov    %rsp,%rbp
  802931:	48 83 ec 30          	sub    $0x30,%rsp
  802935:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802938:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80293c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802940:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802947:	eb 46                	jmp    80298f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802949:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294c:	48 98                	cltq   
  80294e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802952:	48 29 c2             	sub    %rax,%rdx
  802955:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802958:	48 98                	cltq   
  80295a:	48 89 c1             	mov    %rax,%rcx
  80295d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802961:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802964:	48 89 ce             	mov    %rcx,%rsi
  802967:	89 c7                	mov    %eax,%edi
  802969:	48 b8 54 28 80 00 00 	movabs $0x802854,%rax
  802970:	00 00 00 
  802973:	ff d0                	callq  *%rax
  802975:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802978:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80297c:	79 05                	jns    802983 <readn+0x56>
			return m;
  80297e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802981:	eb 1d                	jmp    8029a0 <readn+0x73>
		if (m == 0)
  802983:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802987:	74 13                	je     80299c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802989:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80298c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80298f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802992:	48 98                	cltq   
  802994:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802998:	72 af                	jb     802949 <readn+0x1c>
  80299a:	eb 01                	jmp    80299d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80299c:	90                   	nop
	}
	return tot;
  80299d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029a0:	c9                   	leaveq 
  8029a1:	c3                   	retq   

00000000008029a2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029a2:	55                   	push   %rbp
  8029a3:	48 89 e5             	mov    %rsp,%rbp
  8029a6:	48 83 ec 40          	sub    $0x40,%rsp
  8029aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029b1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029bc:	48 89 d6             	mov    %rdx,%rsi
  8029bf:	89 c7                	mov    %eax,%edi
  8029c1:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	callq  *%rax
  8029cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d4:	78 24                	js     8029fa <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029da:	8b 00                	mov    (%rax),%eax
  8029dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e0:	48 89 d6             	mov    %rdx,%rsi
  8029e3:	89 c7                	mov    %eax,%edi
  8029e5:	48 b8 7b 25 80 00 00 	movabs $0x80257b,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
  8029f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f8:	79 05                	jns    8029ff <write+0x5d>
		return r;
  8029fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fd:	eb 79                	jmp    802a78 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a03:	8b 40 08             	mov    0x8(%rax),%eax
  802a06:	83 e0 03             	and    $0x3,%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	75 3a                	jne    802a47 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a0d:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  802a14:	00 00 00 
  802a17:	48 8b 00             	mov    (%rax),%rax
  802a1a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a20:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a23:	89 c6                	mov    %eax,%esi
  802a25:	48 bf 6b 4c 80 00 00 	movabs $0x804c6b,%rdi
  802a2c:	00 00 00 
  802a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a34:	48 b9 27 08 80 00 00 	movabs $0x800827,%rcx
  802a3b:	00 00 00 
  802a3e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a45:	eb 31                	jmp    802a78 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a4f:	48 85 c0             	test   %rax,%rax
  802a52:	75 07                	jne    802a5b <write+0xb9>
		return -E_NOT_SUPP;
  802a54:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a59:	eb 1d                	jmp    802a78 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802a63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a67:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a6b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a6f:	48 89 ce             	mov    %rcx,%rsi
  802a72:	48 89 c7             	mov    %rax,%rdi
  802a75:	41 ff d0             	callq  *%r8
}
  802a78:	c9                   	leaveq 
  802a79:	c3                   	retq   

0000000000802a7a <seek>:

int
seek(int fdnum, off_t offset)
{
  802a7a:	55                   	push   %rbp
  802a7b:	48 89 e5             	mov    %rsp,%rbp
  802a7e:	48 83 ec 18          	sub    $0x18,%rsp
  802a82:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a85:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a8f:	48 89 d6             	mov    %rdx,%rsi
  802a92:	89 c7                	mov    %eax,%edi
  802a94:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	callq  *%rax
  802aa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa7:	79 05                	jns    802aae <seek+0x34>
		return r;
  802aa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aac:	eb 0f                	jmp    802abd <seek+0x43>
	fd->fd_offset = offset;
  802aae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ab5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802abd:	c9                   	leaveq 
  802abe:	c3                   	retq   

0000000000802abf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802abf:	55                   	push   %rbp
  802ac0:	48 89 e5             	mov    %rsp,%rbp
  802ac3:	48 83 ec 30          	sub    $0x30,%rsp
  802ac7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aca:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802acd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ad1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ad4:	48 89 d6             	mov    %rdx,%rsi
  802ad7:	89 c7                	mov    %eax,%edi
  802ad9:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  802ae0:	00 00 00 
  802ae3:	ff d0                	callq  *%rax
  802ae5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aec:	78 24                	js     802b12 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af2:	8b 00                	mov    (%rax),%eax
  802af4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802af8:	48 89 d6             	mov    %rdx,%rsi
  802afb:	89 c7                	mov    %eax,%edi
  802afd:	48 b8 7b 25 80 00 00 	movabs $0x80257b,%rax
  802b04:	00 00 00 
  802b07:	ff d0                	callq  *%rax
  802b09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b10:	79 05                	jns    802b17 <ftruncate+0x58>
		return r;
  802b12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b15:	eb 72                	jmp    802b89 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b1b:	8b 40 08             	mov    0x8(%rax),%eax
  802b1e:	83 e0 03             	and    $0x3,%eax
  802b21:	85 c0                	test   %eax,%eax
  802b23:	75 3a                	jne    802b5f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b25:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  802b2c:	00 00 00 
  802b2f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b32:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b38:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b3b:	89 c6                	mov    %eax,%esi
  802b3d:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  802b44:	00 00 00 
  802b47:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4c:	48 b9 27 08 80 00 00 	movabs $0x800827,%rcx
  802b53:	00 00 00 
  802b56:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b5d:	eb 2a                	jmp    802b89 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b63:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b67:	48 85 c0             	test   %rax,%rax
  802b6a:	75 07                	jne    802b73 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b6c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b71:	eb 16                	jmp    802b89 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b77:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802b82:	89 d6                	mov    %edx,%esi
  802b84:	48 89 c7             	mov    %rax,%rdi
  802b87:	ff d1                	callq  *%rcx
}
  802b89:	c9                   	leaveq 
  802b8a:	c3                   	retq   

0000000000802b8b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b8b:	55                   	push   %rbp
  802b8c:	48 89 e5             	mov    %rsp,%rbp
  802b8f:	48 83 ec 30          	sub    $0x30,%rsp
  802b93:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b96:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b9a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ba1:	48 89 d6             	mov    %rdx,%rsi
  802ba4:	89 c7                	mov    %eax,%edi
  802ba6:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  802bad:	00 00 00 
  802bb0:	ff d0                	callq  *%rax
  802bb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb9:	78 24                	js     802bdf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbf:	8b 00                	mov    (%rax),%eax
  802bc1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bc5:	48 89 d6             	mov    %rdx,%rsi
  802bc8:	89 c7                	mov    %eax,%edi
  802bca:	48 b8 7b 25 80 00 00 	movabs $0x80257b,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	callq  *%rax
  802bd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdd:	79 05                	jns    802be4 <fstat+0x59>
		return r;
  802bdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be2:	eb 5e                	jmp    802c42 <fstat+0xb7>
	if (!dev->dev_stat)
  802be4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be8:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bec:	48 85 c0             	test   %rax,%rax
  802bef:	75 07                	jne    802bf8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802bf1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bf6:	eb 4a                	jmp    802c42 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bf8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bfc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c03:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c0a:	00 00 00 
	stat->st_isdir = 0;
  802c0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c11:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c18:	00 00 00 
	stat->st_dev = dev;
  802c1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c23:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c2e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802c32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c36:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802c3a:	48 89 d6             	mov    %rdx,%rsi
  802c3d:	48 89 c7             	mov    %rax,%rdi
  802c40:	ff d1                	callq  *%rcx
}
  802c42:	c9                   	leaveq 
  802c43:	c3                   	retq   

0000000000802c44 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c44:	55                   	push   %rbp
  802c45:	48 89 e5             	mov    %rsp,%rbp
  802c48:	48 83 ec 20          	sub    $0x20,%rsp
  802c4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c50:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c58:	be 00 00 00 00       	mov    $0x0,%esi
  802c5d:	48 89 c7             	mov    %rax,%rdi
  802c60:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  802c67:	00 00 00 
  802c6a:	ff d0                	callq  *%rax
  802c6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c73:	79 05                	jns    802c7a <stat+0x36>
		return fd;
  802c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c78:	eb 2f                	jmp    802ca9 <stat+0x65>
	r = fstat(fd, stat);
  802c7a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c81:	48 89 d6             	mov    %rdx,%rsi
  802c84:	89 c7                	mov    %eax,%edi
  802c86:	48 b8 8b 2b 80 00 00 	movabs $0x802b8b,%rax
  802c8d:	00 00 00 
  802c90:	ff d0                	callq  *%rax
  802c92:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c98:	89 c7                	mov    %eax,%edi
  802c9a:	48 b8 32 26 80 00 00 	movabs $0x802632,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
	return r;
  802ca6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ca9:	c9                   	leaveq 
  802caa:	c3                   	retq   
	...

0000000000802cac <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802cac:	55                   	push   %rbp
  802cad:	48 89 e5             	mov    %rsp,%rbp
  802cb0:	48 83 ec 10          	sub    $0x10,%rsp
  802cb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802cbb:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802cc2:	00 00 00 
  802cc5:	8b 00                	mov    (%rax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	75 1d                	jne    802ce8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ccb:	bf 01 00 00 00       	mov    $0x1,%edi
  802cd0:	48 b8 57 45 80 00 00 	movabs $0x804557,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
  802cdc:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  802ce3:	00 00 00 
  802ce6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ce8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802cef:	00 00 00 
  802cf2:	8b 00                	mov    (%rax),%eax
  802cf4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802cf7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cfc:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d03:	00 00 00 
  802d06:	89 c7                	mov    %eax,%edi
  802d08:	48 b8 94 44 80 00 00 	movabs $0x804494,%rax
  802d0f:	00 00 00 
  802d12:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d18:	ba 00 00 00 00       	mov    $0x0,%edx
  802d1d:	48 89 c6             	mov    %rax,%rsi
  802d20:	bf 00 00 00 00       	mov    $0x0,%edi
  802d25:	48 b8 d4 43 80 00 00 	movabs $0x8043d4,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	callq  *%rax
}
  802d31:	c9                   	leaveq 
  802d32:	c3                   	retq   

0000000000802d33 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d33:	55                   	push   %rbp
  802d34:	48 89 e5             	mov    %rsp,%rbp
  802d37:	48 83 ec 20          	sub    $0x20,%rsp
  802d3b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d3f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802d42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d46:	48 89 c7             	mov    %rax,%rdi
  802d49:	48 b8 78 13 80 00 00 	movabs $0x801378,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
  802d55:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d5a:	7e 0a                	jle    802d66 <open+0x33>
                return -E_BAD_PATH;
  802d5c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d61:	e9 a5 00 00 00       	jmpq   802e0b <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802d66:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d6a:	48 89 c7             	mov    %rax,%rdi
  802d6d:	48 b8 8a 23 80 00 00 	movabs $0x80238a,%rax
  802d74:	00 00 00 
  802d77:	ff d0                	callq  *%rax
  802d79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d80:	79 08                	jns    802d8a <open+0x57>
		return r;
  802d82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d85:	e9 81 00 00 00       	jmpq   802e0b <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8e:	48 89 c6             	mov    %rax,%rsi
  802d91:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d98:	00 00 00 
  802d9b:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802da7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dae:	00 00 00 
  802db1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802db4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802dba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbe:	48 89 c6             	mov    %rax,%rsi
  802dc1:	bf 01 00 00 00       	mov    $0x1,%edi
  802dc6:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
  802dd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802dd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd9:	79 1d                	jns    802df8 <open+0xc5>
	{
		fd_close(fd,0);
  802ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddf:	be 00 00 00 00       	mov    $0x0,%esi
  802de4:	48 89 c7             	mov    %rax,%rdi
  802de7:	48 b8 b2 24 80 00 00 	movabs $0x8024b2,%rax
  802dee:	00 00 00 
  802df1:	ff d0                	callq  *%rax
		return r;
  802df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df6:	eb 13                	jmp    802e0b <open+0xd8>
	}
	return fd2num(fd);
  802df8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfc:	48 89 c7             	mov    %rax,%rdi
  802dff:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  802e06:	00 00 00 
  802e09:	ff d0                	callq  *%rax
	


}
  802e0b:	c9                   	leaveq 
  802e0c:	c3                   	retq   

0000000000802e0d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e0d:	55                   	push   %rbp
  802e0e:	48 89 e5             	mov    %rsp,%rbp
  802e11:	48 83 ec 10          	sub    $0x10,%rsp
  802e15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1d:	8b 50 0c             	mov    0xc(%rax),%edx
  802e20:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e27:	00 00 00 
  802e2a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e2c:	be 00 00 00 00       	mov    $0x0,%esi
  802e31:	bf 06 00 00 00       	mov    $0x6,%edi
  802e36:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	callq  *%rax
}
  802e42:	c9                   	leaveq 
  802e43:	c3                   	retq   

0000000000802e44 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e44:	55                   	push   %rbp
  802e45:	48 89 e5             	mov    %rsp,%rbp
  802e48:	48 83 ec 30          	sub    $0x30,%rsp
  802e4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e50:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e54:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5c:	8b 50 0c             	mov    0xc(%rax),%edx
  802e5f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e66:	00 00 00 
  802e69:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e72:	00 00 00 
  802e75:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e79:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802e7d:	be 00 00 00 00       	mov    $0x0,%esi
  802e82:	bf 03 00 00 00       	mov    $0x3,%edi
  802e87:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  802e8e:	00 00 00 
  802e91:	ff d0                	callq  *%rax
  802e93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9a:	79 05                	jns    802ea1 <devfile_read+0x5d>
	{
		return r;
  802e9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9f:	eb 2c                	jmp    802ecd <devfile_read+0x89>
	}
	if(r > 0)
  802ea1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea5:	7e 23                	jle    802eca <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaa:	48 63 d0             	movslq %eax,%rdx
  802ead:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eb1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802eb8:	00 00 00 
  802ebb:	48 89 c7             	mov    %rax,%rdi
  802ebe:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  802ec5:	00 00 00 
  802ec8:	ff d0                	callq  *%rax
	return r;
  802eca:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802ecd:	c9                   	leaveq 
  802ece:	c3                   	retq   

0000000000802ecf <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ecf:	55                   	push   %rbp
  802ed0:	48 89 e5             	mov    %rsp,%rbp
  802ed3:	48 83 ec 30          	sub    $0x30,%rsp
  802ed7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802edb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802edf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee7:	8b 50 0c             	mov    0xc(%rax),%edx
  802eea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ef1:	00 00 00 
  802ef4:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802ef6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802efd:	00 
  802efe:	76 08                	jbe    802f08 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802f00:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f07:	00 
	fsipcbuf.write.req_n=n;
  802f08:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f0f:	00 00 00 
  802f12:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f16:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802f1a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f22:	48 89 c6             	mov    %rax,%rsi
  802f25:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802f2c:	00 00 00 
  802f2f:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  802f36:	00 00 00 
  802f39:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802f3b:	be 00 00 00 00       	mov    $0x0,%esi
  802f40:	bf 04 00 00 00       	mov    $0x4,%edi
  802f45:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  802f4c:	00 00 00 
  802f4f:	ff d0                	callq  *%rax
  802f51:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802f54:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f57:	c9                   	leaveq 
  802f58:	c3                   	retq   

0000000000802f59 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802f59:	55                   	push   %rbp
  802f5a:	48 89 e5             	mov    %rsp,%rbp
  802f5d:	48 83 ec 10          	sub    $0x10,%rsp
  802f61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f65:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6c:	8b 50 0c             	mov    0xc(%rax),%edx
  802f6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f76:	00 00 00 
  802f79:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802f7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f82:	00 00 00 
  802f85:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f88:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f8b:	be 00 00 00 00       	mov    $0x0,%esi
  802f90:	bf 02 00 00 00       	mov    $0x2,%edi
  802f95:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	callq  *%rax
}
  802fa1:	c9                   	leaveq 
  802fa2:	c3                   	retq   

0000000000802fa3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802fa3:	55                   	push   %rbp
  802fa4:	48 89 e5             	mov    %rsp,%rbp
  802fa7:	48 83 ec 20          	sub    $0x20,%rsp
  802fab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802faf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb7:	8b 50 0c             	mov    0xc(%rax),%edx
  802fba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fc1:	00 00 00 
  802fc4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fc6:	be 00 00 00 00       	mov    $0x0,%esi
  802fcb:	bf 05 00 00 00       	mov    $0x5,%edi
  802fd0:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	callq  *%rax
  802fdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe3:	79 05                	jns    802fea <devfile_stat+0x47>
		return r;
  802fe5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe8:	eb 56                	jmp    803040 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802fea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fee:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ff5:	00 00 00 
  802ff8:	48 89 c7             	mov    %rax,%rdi
  802ffb:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  803002:	00 00 00 
  803005:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803007:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80300e:	00 00 00 
  803011:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803017:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803021:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803028:	00 00 00 
  80302b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803031:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803035:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80303b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803040:	c9                   	leaveq 
  803041:	c3                   	retq   
	...

0000000000803044 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  803044:	55                   	push   %rbp
  803045:	48 89 e5             	mov    %rsp,%rbp
  803048:	48 83 ec 20          	sub    $0x20,%rsp
  80304c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  803050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803054:	8b 40 0c             	mov    0xc(%rax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	7e 67                	jle    8030c2 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80305b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305f:	8b 40 04             	mov    0x4(%rax),%eax
  803062:	48 63 d0             	movslq %eax,%rdx
  803065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803069:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80306d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803071:	8b 00                	mov    (%rax),%eax
  803073:	48 89 ce             	mov    %rcx,%rsi
  803076:	89 c7                	mov    %eax,%edi
  803078:	48 b8 a2 29 80 00 00 	movabs $0x8029a2,%rax
  80307f:	00 00 00 
  803082:	ff d0                	callq  *%rax
  803084:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  803087:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308b:	7e 13                	jle    8030a0 <writebuf+0x5c>
			b->result += result;
  80308d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803091:	8b 40 08             	mov    0x8(%rax),%eax
  803094:	89 c2                	mov    %eax,%edx
  803096:	03 55 fc             	add    -0x4(%rbp),%edx
  803099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309d:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8030a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a4:	8b 40 04             	mov    0x4(%rax),%eax
  8030a7:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8030aa:	74 16                	je     8030c2 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8030ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b5:	89 c2                	mov    %eax,%edx
  8030b7:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  8030bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bf:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8030c2:	c9                   	leaveq 
  8030c3:	c3                   	retq   

00000000008030c4 <putch>:

static void
putch(int ch, void *thunk)
{
  8030c4:	55                   	push   %rbp
  8030c5:	48 89 e5             	mov    %rsp,%rbp
  8030c8:	48 83 ec 20          	sub    $0x20,%rsp
  8030cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8030d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8030db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030df:	8b 40 04             	mov    0x4(%rax),%eax
  8030e2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030e5:	89 d6                	mov    %edx,%esi
  8030e7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8030eb:	48 63 d0             	movslq %eax,%rdx
  8030ee:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  8030f3:	8d 50 01             	lea    0x1(%rax),%edx
  8030f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fa:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  8030fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803101:	8b 40 04             	mov    0x4(%rax),%eax
  803104:	3d 00 01 00 00       	cmp    $0x100,%eax
  803109:	75 1e                	jne    803129 <putch+0x65>
		writebuf(b);
  80310b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80310f:	48 89 c7             	mov    %rax,%rdi
  803112:	48 b8 44 30 80 00 00 	movabs $0x803044,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
		b->idx = 0;
  80311e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803122:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803129:	c9                   	leaveq 
  80312a:	c3                   	retq   

000000000080312b <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80312b:	55                   	push   %rbp
  80312c:	48 89 e5             	mov    %rsp,%rbp
  80312f:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803136:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80313c:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803143:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80314a:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  803150:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803156:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80315d:	00 00 00 
	b.result = 0;
  803160:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803167:	00 00 00 
	b.error = 1;
  80316a:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  803171:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803174:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  80317b:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803182:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803189:	48 89 c6             	mov    %rax,%rsi
  80318c:	48 bf c4 30 80 00 00 	movabs $0x8030c4,%rdi
  803193:	00 00 00 
  803196:	48 b8 d8 0b 80 00 00 	movabs $0x800bd8,%rax
  80319d:	00 00 00 
  8031a0:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8031a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	7e 16                	jle    8031c2 <vfprintf+0x97>
		writebuf(&b);
  8031ac:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8031b3:	48 89 c7             	mov    %rax,%rdi
  8031b6:	48 b8 44 30 80 00 00 	movabs $0x803044,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8031c2:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 08                	je     8031d4 <vfprintf+0xa9>
  8031cc:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8031d2:	eb 06                	jmp    8031da <vfprintf+0xaf>
  8031d4:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8031da:	c9                   	leaveq 
  8031db:	c3                   	retq   

00000000008031dc <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8031dc:	55                   	push   %rbp
  8031dd:	48 89 e5             	mov    %rsp,%rbp
  8031e0:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8031e7:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8031ed:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8031f4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031fb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803202:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803209:	84 c0                	test   %al,%al
  80320b:	74 20                	je     80322d <fprintf+0x51>
  80320d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803211:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803215:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803219:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80321d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803221:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803225:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803229:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80322d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803234:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80323b:	00 00 00 
  80323e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803245:	00 00 00 
  803248:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80324c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803253:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80325a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  803261:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803268:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80326f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803275:	48 89 ce             	mov    %rcx,%rsi
  803278:	89 c7                	mov    %eax,%edi
  80327a:	48 b8 2b 31 80 00 00 	movabs $0x80312b,%rax
  803281:	00 00 00 
  803284:	ff d0                	callq  *%rax
  803286:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80328c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803292:	c9                   	leaveq 
  803293:	c3                   	retq   

0000000000803294 <printf>:

int
printf(const char *fmt, ...)
{
  803294:	55                   	push   %rbp
  803295:	48 89 e5             	mov    %rsp,%rbp
  803298:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80329f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8032a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8032ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8032b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8032bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8032c2:	84 c0                	test   %al,%al
  8032c4:	74 20                	je     8032e6 <printf+0x52>
  8032c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8032ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8032ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8032d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032e6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8032ed:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8032f4:	00 00 00 
  8032f7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8032fe:	00 00 00 
  803301:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803305:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80330c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803313:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80331a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803321:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803328:	48 89 c6             	mov    %rax,%rsi
  80332b:	bf 01 00 00 00       	mov    $0x1,%edi
  803330:	48 b8 2b 31 80 00 00 	movabs $0x80312b,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
  80333c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803342:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803348:	c9                   	leaveq 
  803349:	c3                   	retq   
	...

000000000080334c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80334c:	55                   	push   %rbp
  80334d:	48 89 e5             	mov    %rsp,%rbp
  803350:	48 83 ec 20          	sub    $0x20,%rsp
  803354:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803357:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80335b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80335e:	48 89 d6             	mov    %rdx,%rsi
  803361:	89 c7                	mov    %eax,%edi
  803363:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  80336a:	00 00 00 
  80336d:	ff d0                	callq  *%rax
  80336f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803372:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803376:	79 05                	jns    80337d <fd2sockid+0x31>
		return r;
  803378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337b:	eb 24                	jmp    8033a1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80337d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803381:	8b 10                	mov    (%rax),%edx
  803383:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80338a:	00 00 00 
  80338d:	8b 00                	mov    (%rax),%eax
  80338f:	39 c2                	cmp    %eax,%edx
  803391:	74 07                	je     80339a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803393:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803398:	eb 07                	jmp    8033a1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80339a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80339e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 20          	sub    $0x20,%rsp
  8033ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8033ae:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033b2:	48 89 c7             	mov    %rax,%rdi
  8033b5:	48 b8 8a 23 80 00 00 	movabs $0x80238a,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
  8033c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c8:	78 26                	js     8033f0 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8033ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ce:	ba 07 04 00 00       	mov    $0x407,%edx
  8033d3:	48 89 c6             	mov    %rax,%rsi
  8033d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8033db:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
  8033e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ee:	79 16                	jns    803406 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8033f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033f3:	89 c7                	mov    %eax,%edi
  8033f5:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  8033fc:	00 00 00 
  8033ff:	ff d0                	callq  *%rax
		return r;
  803401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803404:	eb 3a                	jmp    803440 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803411:	00 00 00 
  803414:	8b 12                	mov    (%rdx),%edx
  803416:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803427:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80342a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80342d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803431:	48 89 c7             	mov    %rax,%rdi
  803434:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  80343b:	00 00 00 
  80343e:	ff d0                	callq  *%rax
}
  803440:	c9                   	leaveq 
  803441:	c3                   	retq   

0000000000803442 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803442:	55                   	push   %rbp
  803443:	48 89 e5             	mov    %rsp,%rbp
  803446:	48 83 ec 30          	sub    $0x30,%rsp
  80344a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80344d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803451:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803455:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803458:	89 c7                	mov    %eax,%edi
  80345a:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
  803466:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803469:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80346d:	79 05                	jns    803474 <accept+0x32>
		return r;
  80346f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803472:	eb 3b                	jmp    8034af <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803474:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803478:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80347c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347f:	48 89 ce             	mov    %rcx,%rsi
  803482:	89 c7                	mov    %eax,%edi
  803484:	48 b8 8d 37 80 00 00 	movabs $0x80378d,%rax
  80348b:	00 00 00 
  80348e:	ff d0                	callq  *%rax
  803490:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803493:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803497:	79 05                	jns    80349e <accept+0x5c>
		return r;
  803499:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349c:	eb 11                	jmp    8034af <accept+0x6d>
	return alloc_sockfd(r);
  80349e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a1:	89 c7                	mov    %eax,%edi
  8034a3:	48 b8 a3 33 80 00 00 	movabs $0x8033a3,%rax
  8034aa:	00 00 00 
  8034ad:	ff d0                	callq  *%rax
}
  8034af:	c9                   	leaveq 
  8034b0:	c3                   	retq   

00000000008034b1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034b1:	55                   	push   %rbp
  8034b2:	48 89 e5             	mov    %rsp,%rbp
  8034b5:	48 83 ec 20          	sub    $0x20,%rsp
  8034b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034c0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c6:	89 c7                	mov    %eax,%edi
  8034c8:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  8034cf:	00 00 00 
  8034d2:	ff d0                	callq  *%rax
  8034d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034db:	79 05                	jns    8034e2 <bind+0x31>
		return r;
  8034dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e0:	eb 1b                	jmp    8034fd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8034e2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034e5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ec:	48 89 ce             	mov    %rcx,%rsi
  8034ef:	89 c7                	mov    %eax,%edi
  8034f1:	48 b8 0c 38 80 00 00 	movabs $0x80380c,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	callq  *%rax
}
  8034fd:	c9                   	leaveq 
  8034fe:	c3                   	retq   

00000000008034ff <shutdown>:

int
shutdown(int s, int how)
{
  8034ff:	55                   	push   %rbp
  803500:	48 89 e5             	mov    %rsp,%rbp
  803503:	48 83 ec 20          	sub    $0x20,%rsp
  803507:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80350a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80350d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803510:	89 c7                	mov    %eax,%edi
  803512:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  803519:	00 00 00 
  80351c:	ff d0                	callq  *%rax
  80351e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803521:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803525:	79 05                	jns    80352c <shutdown+0x2d>
		return r;
  803527:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352a:	eb 16                	jmp    803542 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80352c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80352f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803532:	89 d6                	mov    %edx,%esi
  803534:	89 c7                	mov    %eax,%edi
  803536:	48 b8 70 38 80 00 00 	movabs $0x803870,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
}
  803542:	c9                   	leaveq 
  803543:	c3                   	retq   

0000000000803544 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803544:	55                   	push   %rbp
  803545:	48 89 e5             	mov    %rsp,%rbp
  803548:	48 83 ec 10          	sub    $0x10,%rsp
  80354c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803554:	48 89 c7             	mov    %rax,%rdi
  803557:	48 b8 dc 45 80 00 00 	movabs $0x8045dc,%rax
  80355e:	00 00 00 
  803561:	ff d0                	callq  *%rax
  803563:	83 f8 01             	cmp    $0x1,%eax
  803566:	75 17                	jne    80357f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356c:	8b 40 0c             	mov    0xc(%rax),%eax
  80356f:	89 c7                	mov    %eax,%edi
  803571:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
  80357d:	eb 05                	jmp    803584 <devsock_close+0x40>
	else
		return 0;
  80357f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803584:	c9                   	leaveq 
  803585:	c3                   	retq   

0000000000803586 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803586:	55                   	push   %rbp
  803587:	48 89 e5             	mov    %rsp,%rbp
  80358a:	48 83 ec 20          	sub    $0x20,%rsp
  80358e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803591:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803595:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803598:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80359b:	89 c7                	mov    %eax,%edi
  80359d:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  8035a4:	00 00 00 
  8035a7:	ff d0                	callq  *%rax
  8035a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b0:	79 05                	jns    8035b7 <connect+0x31>
		return r;
  8035b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b5:	eb 1b                	jmp    8035d2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8035b7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035ba:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c1:	48 89 ce             	mov    %rcx,%rsi
  8035c4:	89 c7                	mov    %eax,%edi
  8035c6:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  8035cd:	00 00 00 
  8035d0:	ff d0                	callq  *%rax
}
  8035d2:	c9                   	leaveq 
  8035d3:	c3                   	retq   

00000000008035d4 <listen>:

int
listen(int s, int backlog)
{
  8035d4:	55                   	push   %rbp
  8035d5:	48 89 e5             	mov    %rsp,%rbp
  8035d8:	48 83 ec 20          	sub    $0x20,%rsp
  8035dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035df:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035e5:	89 c7                	mov    %eax,%edi
  8035e7:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
  8035f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035fa:	79 05                	jns    803601 <listen+0x2d>
		return r;
  8035fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ff:	eb 16                	jmp    803617 <listen+0x43>
	return nsipc_listen(r, backlog);
  803601:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803604:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803607:	89 d6                	mov    %edx,%esi
  803609:	89 c7                	mov    %eax,%edi
  80360b:	48 b8 41 39 80 00 00 	movabs $0x803941,%rax
  803612:	00 00 00 
  803615:	ff d0                	callq  *%rax
}
  803617:	c9                   	leaveq 
  803618:	c3                   	retq   

0000000000803619 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803619:	55                   	push   %rbp
  80361a:	48 89 e5             	mov    %rsp,%rbp
  80361d:	48 83 ec 20          	sub    $0x20,%rsp
  803621:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803625:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803629:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80362d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803631:	89 c2                	mov    %eax,%edx
  803633:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803637:	8b 40 0c             	mov    0xc(%rax),%eax
  80363a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80363e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803643:	89 c7                	mov    %eax,%edi
  803645:	48 b8 81 39 80 00 00 	movabs $0x803981,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
}
  803651:	c9                   	leaveq 
  803652:	c3                   	retq   

0000000000803653 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803653:	55                   	push   %rbp
  803654:	48 89 e5             	mov    %rsp,%rbp
  803657:	48 83 ec 20          	sub    $0x20,%rsp
  80365b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80365f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803663:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366b:	89 c2                	mov    %eax,%edx
  80366d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803671:	8b 40 0c             	mov    0xc(%rax),%eax
  803674:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803678:	b9 00 00 00 00       	mov    $0x0,%ecx
  80367d:	89 c7                	mov    %eax,%edi
  80367f:	48 b8 4d 3a 80 00 00 	movabs $0x803a4d,%rax
  803686:	00 00 00 
  803689:	ff d0                	callq  *%rax
}
  80368b:	c9                   	leaveq 
  80368c:	c3                   	retq   

000000000080368d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80368d:	55                   	push   %rbp
  80368e:	48 89 e5             	mov    %rsp,%rbp
  803691:	48 83 ec 10          	sub    $0x10,%rsp
  803695:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803699:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80369d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a1:	48 be b3 4c 80 00 00 	movabs $0x804cb3,%rsi
  8036a8:	00 00 00 
  8036ab:	48 89 c7             	mov    %rax,%rdi
  8036ae:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  8036b5:	00 00 00 
  8036b8:	ff d0                	callq  *%rax
	return 0;
  8036ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036bf:	c9                   	leaveq 
  8036c0:	c3                   	retq   

00000000008036c1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8036c1:	55                   	push   %rbp
  8036c2:	48 89 e5             	mov    %rsp,%rbp
  8036c5:	48 83 ec 20          	sub    $0x20,%rsp
  8036c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036cc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8036cf:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8036d2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8036d5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036db:	89 ce                	mov    %ecx,%esi
  8036dd:	89 c7                	mov    %eax,%edi
  8036df:	48 b8 05 3b 80 00 00 	movabs $0x803b05,%rax
  8036e6:	00 00 00 
  8036e9:	ff d0                	callq  *%rax
  8036eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f2:	79 05                	jns    8036f9 <socket+0x38>
		return r;
  8036f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f7:	eb 11                	jmp    80370a <socket+0x49>
	return alloc_sockfd(r);
  8036f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fc:	89 c7                	mov    %eax,%edi
  8036fe:	48 b8 a3 33 80 00 00 	movabs $0x8033a3,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
}
  80370a:	c9                   	leaveq 
  80370b:	c3                   	retq   

000000000080370c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80370c:	55                   	push   %rbp
  80370d:	48 89 e5             	mov    %rsp,%rbp
  803710:	48 83 ec 10          	sub    $0x10,%rsp
  803714:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803717:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80371e:	00 00 00 
  803721:	8b 00                	mov    (%rax),%eax
  803723:	85 c0                	test   %eax,%eax
  803725:	75 1d                	jne    803744 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803727:	bf 02 00 00 00       	mov    $0x2,%edi
  80372c:	48 b8 57 45 80 00 00 	movabs $0x804557,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
  803738:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  80373f:	00 00 00 
  803742:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803744:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80374b:	00 00 00 
  80374e:	8b 00                	mov    (%rax),%eax
  803750:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803753:	b9 07 00 00 00       	mov    $0x7,%ecx
  803758:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80375f:	00 00 00 
  803762:	89 c7                	mov    %eax,%edi
  803764:	48 b8 94 44 80 00 00 	movabs $0x804494,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803770:	ba 00 00 00 00       	mov    $0x0,%edx
  803775:	be 00 00 00 00       	mov    $0x0,%esi
  80377a:	bf 00 00 00 00       	mov    $0x0,%edi
  80377f:	48 b8 d4 43 80 00 00 	movabs $0x8043d4,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
}
  80378b:	c9                   	leaveq 
  80378c:	c3                   	retq   

000000000080378d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80378d:	55                   	push   %rbp
  80378e:	48 89 e5             	mov    %rsp,%rbp
  803791:	48 83 ec 30          	sub    $0x30,%rsp
  803795:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803798:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80379c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8037a0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037a7:	00 00 00 
  8037aa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037ad:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8037af:	bf 01 00 00 00       	mov    $0x1,%edi
  8037b4:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  8037bb:	00 00 00 
  8037be:	ff d0                	callq  *%rax
  8037c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c7:	78 3e                	js     803807 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8037c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037d0:	00 00 00 
  8037d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8037d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037db:	8b 40 10             	mov    0x10(%rax),%eax
  8037de:	89 c2                	mov    %eax,%edx
  8037e0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8037e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e8:	48 89 ce             	mov    %rcx,%rsi
  8037eb:	48 89 c7             	mov    %rax,%rdi
  8037ee:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8037fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037fe:	8b 50 10             	mov    0x10(%rax),%edx
  803801:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803805:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803807:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80380a:	c9                   	leaveq 
  80380b:	c3                   	retq   

000000000080380c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80380c:	55                   	push   %rbp
  80380d:	48 89 e5             	mov    %rsp,%rbp
  803810:	48 83 ec 10          	sub    $0x10,%rsp
  803814:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803817:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80381b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80381e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803825:	00 00 00 
  803828:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80382b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80382d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803834:	48 89 c6             	mov    %rax,%rsi
  803837:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80383e:	00 00 00 
  803841:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  803848:	00 00 00 
  80384b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80384d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803854:	00 00 00 
  803857:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80385a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80385d:	bf 02 00 00 00       	mov    $0x2,%edi
  803862:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  803869:	00 00 00 
  80386c:	ff d0                	callq  *%rax
}
  80386e:	c9                   	leaveq 
  80386f:	c3                   	retq   

0000000000803870 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803870:	55                   	push   %rbp
  803871:	48 89 e5             	mov    %rsp,%rbp
  803874:	48 83 ec 10          	sub    $0x10,%rsp
  803878:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80387b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80387e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803885:	00 00 00 
  803888:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80388b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80388d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803894:	00 00 00 
  803897:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80389a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80389d:	bf 03 00 00 00       	mov    $0x3,%edi
  8038a2:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  8038a9:	00 00 00 
  8038ac:	ff d0                	callq  *%rax
}
  8038ae:	c9                   	leaveq 
  8038af:	c3                   	retq   

00000000008038b0 <nsipc_close>:

int
nsipc_close(int s)
{
  8038b0:	55                   	push   %rbp
  8038b1:	48 89 e5             	mov    %rsp,%rbp
  8038b4:	48 83 ec 10          	sub    $0x10,%rsp
  8038b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8038bb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038c2:	00 00 00 
  8038c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038c8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8038ca:	bf 04 00 00 00       	mov    $0x4,%edi
  8038cf:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
}
  8038db:	c9                   	leaveq 
  8038dc:	c3                   	retq   

00000000008038dd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038dd:	55                   	push   %rbp
  8038de:	48 89 e5             	mov    %rsp,%rbp
  8038e1:	48 83 ec 10          	sub    $0x10,%rsp
  8038e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038ec:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8038ef:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f6:	00 00 00 
  8038f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038fc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8038fe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803905:	48 89 c6             	mov    %rax,%rsi
  803908:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80390f:	00 00 00 
  803912:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  803919:	00 00 00 
  80391c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80391e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803925:	00 00 00 
  803928:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80392b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80392e:	bf 05 00 00 00       	mov    $0x5,%edi
  803933:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  80393a:	00 00 00 
  80393d:	ff d0                	callq  *%rax
}
  80393f:	c9                   	leaveq 
  803940:	c3                   	retq   

0000000000803941 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803941:	55                   	push   %rbp
  803942:	48 89 e5             	mov    %rsp,%rbp
  803945:	48 83 ec 10          	sub    $0x10,%rsp
  803949:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80394c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80394f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803956:	00 00 00 
  803959:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80395c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80395e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803965:	00 00 00 
  803968:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80396b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80396e:	bf 06 00 00 00       	mov    $0x6,%edi
  803973:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  80397a:	00 00 00 
  80397d:	ff d0                	callq  *%rax
}
  80397f:	c9                   	leaveq 
  803980:	c3                   	retq   

0000000000803981 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803981:	55                   	push   %rbp
  803982:	48 89 e5             	mov    %rsp,%rbp
  803985:	48 83 ec 30          	sub    $0x30,%rsp
  803989:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80398c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803990:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803993:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803996:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80399d:	00 00 00 
  8039a0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039a3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8039a5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ac:	00 00 00 
  8039af:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039b2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8039b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039bc:	00 00 00 
  8039bf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8039c2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8039c5:	bf 07 00 00 00       	mov    $0x7,%edi
  8039ca:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
  8039d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039dd:	78 69                	js     803a48 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8039df:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8039e6:	7f 08                	jg     8039f0 <nsipc_recv+0x6f>
  8039e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039eb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8039ee:	7e 35                	jle    803a25 <nsipc_recv+0xa4>
  8039f0:	48 b9 ba 4c 80 00 00 	movabs $0x804cba,%rcx
  8039f7:	00 00 00 
  8039fa:	48 ba cf 4c 80 00 00 	movabs $0x804ccf,%rdx
  803a01:	00 00 00 
  803a04:	be 61 00 00 00       	mov    $0x61,%esi
  803a09:	48 bf e4 4c 80 00 00 	movabs $0x804ce4,%rdi
  803a10:	00 00 00 
  803a13:	b8 00 00 00 00       	mov    $0x0,%eax
  803a18:	49 b8 ec 05 80 00 00 	movabs $0x8005ec,%r8
  803a1f:	00 00 00 
  803a22:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a28:	48 63 d0             	movslq %eax,%rdx
  803a2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a2f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803a36:	00 00 00 
  803a39:	48 89 c7             	mov    %rax,%rdi
  803a3c:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  803a43:	00 00 00 
  803a46:	ff d0                	callq  *%rax
	}

	return r;
  803a48:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a4b:	c9                   	leaveq 
  803a4c:	c3                   	retq   

0000000000803a4d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a4d:	55                   	push   %rbp
  803a4e:	48 89 e5             	mov    %rsp,%rbp
  803a51:	48 83 ec 20          	sub    $0x20,%rsp
  803a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a5c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803a5f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803a62:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a69:	00 00 00 
  803a6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a6f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a71:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a78:	7e 35                	jle    803aaf <nsipc_send+0x62>
  803a7a:	48 b9 f0 4c 80 00 00 	movabs $0x804cf0,%rcx
  803a81:	00 00 00 
  803a84:	48 ba cf 4c 80 00 00 	movabs $0x804ccf,%rdx
  803a8b:	00 00 00 
  803a8e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803a93:	48 bf e4 4c 80 00 00 	movabs $0x804ce4,%rdi
  803a9a:	00 00 00 
  803a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa2:	49 b8 ec 05 80 00 00 	movabs $0x8005ec,%r8
  803aa9:	00 00 00 
  803aac:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803aaf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ab2:	48 63 d0             	movslq %eax,%rdx
  803ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab9:	48 89 c6             	mov    %rax,%rsi
  803abc:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803ac3:	00 00 00 
  803ac6:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  803acd:	00 00 00 
  803ad0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803ad2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ad9:	00 00 00 
  803adc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803adf:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803ae2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ae9:	00 00 00 
  803aec:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803aef:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803af2:	bf 08 00 00 00       	mov    $0x8,%edi
  803af7:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  803afe:	00 00 00 
  803b01:	ff d0                	callq  *%rax
}
  803b03:	c9                   	leaveq 
  803b04:	c3                   	retq   

0000000000803b05 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b05:	55                   	push   %rbp
  803b06:	48 89 e5             	mov    %rsp,%rbp
  803b09:	48 83 ec 10          	sub    $0x10,%rsp
  803b0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b10:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b13:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803b16:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b1d:	00 00 00 
  803b20:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b23:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803b25:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b2c:	00 00 00 
  803b2f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b32:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803b35:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b3c:	00 00 00 
  803b3f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b42:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803b45:	bf 09 00 00 00       	mov    $0x9,%edi
  803b4a:	48 b8 0c 37 80 00 00 	movabs $0x80370c,%rax
  803b51:	00 00 00 
  803b54:	ff d0                	callq  *%rax
}
  803b56:	c9                   	leaveq 
  803b57:	c3                   	retq   

0000000000803b58 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803b58:	55                   	push   %rbp
  803b59:	48 89 e5             	mov    %rsp,%rbp
  803b5c:	53                   	push   %rbx
  803b5d:	48 83 ec 38          	sub    $0x38,%rsp
  803b61:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803b65:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b69:	48 89 c7             	mov    %rax,%rdi
  803b6c:	48 b8 8a 23 80 00 00 	movabs $0x80238a,%rax
  803b73:	00 00 00 
  803b76:	ff d0                	callq  *%rax
  803b78:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b7f:	0f 88 bf 01 00 00    	js     803d44 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b89:	ba 07 04 00 00       	mov    $0x407,%edx
  803b8e:	48 89 c6             	mov    %rax,%rsi
  803b91:	bf 00 00 00 00       	mov    $0x0,%edi
  803b96:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  803b9d:	00 00 00 
  803ba0:	ff d0                	callq  *%rax
  803ba2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ba5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ba9:	0f 88 95 01 00 00    	js     803d44 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803baf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803bb3:	48 89 c7             	mov    %rax,%rdi
  803bb6:	48 b8 8a 23 80 00 00 	movabs $0x80238a,%rax
  803bbd:	00 00 00 
  803bc0:	ff d0                	callq  *%rax
  803bc2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bc9:	0f 88 5d 01 00 00    	js     803d2c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd3:	ba 07 04 00 00       	mov    $0x407,%edx
  803bd8:	48 89 c6             	mov    %rax,%rsi
  803bdb:	bf 00 00 00 00       	mov    $0x0,%edi
  803be0:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  803be7:	00 00 00 
  803bea:	ff d0                	callq  *%rax
  803bec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bf3:	0f 88 33 01 00 00    	js     803d2c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803bf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bfd:	48 89 c7             	mov    %rax,%rdi
  803c00:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  803c07:	00 00 00 
  803c0a:	ff d0                	callq  *%rax
  803c0c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c14:	ba 07 04 00 00       	mov    $0x407,%edx
  803c19:	48 89 c6             	mov    %rax,%rsi
  803c1c:	bf 00 00 00 00       	mov    $0x0,%edi
  803c21:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  803c28:	00 00 00 
  803c2b:	ff d0                	callq  *%rax
  803c2d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c30:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c34:	0f 88 d9 00 00 00    	js     803d13 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c3e:	48 89 c7             	mov    %rax,%rdi
  803c41:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  803c48:	00 00 00 
  803c4b:	ff d0                	callq  *%rax
  803c4d:	48 89 c2             	mov    %rax,%rdx
  803c50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c54:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803c5a:	48 89 d1             	mov    %rdx,%rcx
  803c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  803c62:	48 89 c6             	mov    %rax,%rsi
  803c65:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6a:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  803c71:	00 00 00 
  803c74:	ff d0                	callq  *%rax
  803c76:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c79:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c7d:	78 79                	js     803cf8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803c7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c83:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c8a:	00 00 00 
  803c8d:	8b 12                	mov    (%rdx),%edx
  803c8f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803c91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803c9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803ca7:	00 00 00 
  803caa:	8b 12                	mov    (%rdx),%edx
  803cac:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803cae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cb2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803cb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cbd:	48 89 c7             	mov    %rax,%rdi
  803cc0:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
  803ccc:	89 c2                	mov    %eax,%edx
  803cce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cd2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803cd4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cd8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803cdc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ce0:	48 89 c7             	mov    %rax,%rdi
  803ce3:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  803cea:	00 00 00 
  803ced:	ff d0                	callq  *%rax
  803cef:	89 03                	mov    %eax,(%rbx)
	return 0;
  803cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf6:	eb 4f                	jmp    803d47 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803cf8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803cf9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cfd:	48 89 c6             	mov    %rax,%rsi
  803d00:	bf 00 00 00 00       	mov    $0x0,%edi
  803d05:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  803d0c:	00 00 00 
  803d0f:	ff d0                	callq  *%rax
  803d11:	eb 01                	jmp    803d14 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803d13:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803d14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d18:	48 89 c6             	mov    %rax,%rsi
  803d1b:	bf 00 00 00 00       	mov    $0x0,%edi
  803d20:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  803d27:	00 00 00 
  803d2a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803d2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d30:	48 89 c6             	mov    %rax,%rsi
  803d33:	bf 00 00 00 00       	mov    $0x0,%edi
  803d38:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  803d3f:	00 00 00 
  803d42:	ff d0                	callq  *%rax
    err:
	return r;
  803d44:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d47:	48 83 c4 38          	add    $0x38,%rsp
  803d4b:	5b                   	pop    %rbx
  803d4c:	5d                   	pop    %rbp
  803d4d:	c3                   	retq   

0000000000803d4e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d4e:	55                   	push   %rbp
  803d4f:	48 89 e5             	mov    %rsp,%rbp
  803d52:	53                   	push   %rbx
  803d53:	48 83 ec 28          	sub    $0x28,%rsp
  803d57:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d5b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d5f:	eb 01                	jmp    803d62 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803d61:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d62:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  803d69:	00 00 00 
  803d6c:	48 8b 00             	mov    (%rax),%rax
  803d6f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d75:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7c:	48 89 c7             	mov    %rax,%rdi
  803d7f:	48 b8 dc 45 80 00 00 	movabs $0x8045dc,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
  803d8b:	89 c3                	mov    %eax,%ebx
  803d8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d91:	48 89 c7             	mov    %rax,%rdi
  803d94:	48 b8 dc 45 80 00 00 	movabs $0x8045dc,%rax
  803d9b:	00 00 00 
  803d9e:	ff d0                	callq  *%rax
  803da0:	39 c3                	cmp    %eax,%ebx
  803da2:	0f 94 c0             	sete   %al
  803da5:	0f b6 c0             	movzbl %al,%eax
  803da8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803dab:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  803db2:	00 00 00 
  803db5:	48 8b 00             	mov    (%rax),%rax
  803db8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803dbe:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803dc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dc4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803dc7:	75 0a                	jne    803dd3 <_pipeisclosed+0x85>
			return ret;
  803dc9:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803dcc:	48 83 c4 28          	add    $0x28,%rsp
  803dd0:	5b                   	pop    %rbx
  803dd1:	5d                   	pop    %rbp
  803dd2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803dd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803dd9:	74 86                	je     803d61 <_pipeisclosed+0x13>
  803ddb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ddf:	75 80                	jne    803d61 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803de1:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  803de8:	00 00 00 
  803deb:	48 8b 00             	mov    (%rax),%rax
  803dee:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803df4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803df7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dfa:	89 c6                	mov    %eax,%esi
  803dfc:	48 bf 01 4d 80 00 00 	movabs $0x804d01,%rdi
  803e03:	00 00 00 
  803e06:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0b:	49 b8 27 08 80 00 00 	movabs $0x800827,%r8
  803e12:	00 00 00 
  803e15:	41 ff d0             	callq  *%r8
	}
  803e18:	e9 44 ff ff ff       	jmpq   803d61 <_pipeisclosed+0x13>

0000000000803e1d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803e1d:	55                   	push   %rbp
  803e1e:	48 89 e5             	mov    %rsp,%rbp
  803e21:	48 83 ec 30          	sub    $0x30,%rsp
  803e25:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e2f:	48 89 d6             	mov    %rdx,%rsi
  803e32:	89 c7                	mov    %eax,%edi
  803e34:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  803e3b:	00 00 00 
  803e3e:	ff d0                	callq  *%rax
  803e40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e47:	79 05                	jns    803e4e <pipeisclosed+0x31>
		return r;
  803e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e4c:	eb 31                	jmp    803e7f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e52:	48 89 c7             	mov    %rax,%rdi
  803e55:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  803e5c:	00 00 00 
  803e5f:	ff d0                	callq  *%rax
  803e61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e6d:	48 89 d6             	mov    %rdx,%rsi
  803e70:	48 89 c7             	mov    %rax,%rdi
  803e73:	48 b8 4e 3d 80 00 00 	movabs $0x803d4e,%rax
  803e7a:	00 00 00 
  803e7d:	ff d0                	callq  *%rax
}
  803e7f:	c9                   	leaveq 
  803e80:	c3                   	retq   

0000000000803e81 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e81:	55                   	push   %rbp
  803e82:	48 89 e5             	mov    %rsp,%rbp
  803e85:	48 83 ec 40          	sub    $0x40,%rsp
  803e89:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e91:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e99:	48 89 c7             	mov    %rax,%rdi
  803e9c:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  803ea3:	00 00 00 
  803ea6:	ff d0                	callq  *%rax
  803ea8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803eac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803eb4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ebb:	00 
  803ebc:	e9 97 00 00 00       	jmpq   803f58 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ec1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ec6:	74 09                	je     803ed1 <devpipe_read+0x50>
				return i;
  803ec8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ecc:	e9 95 00 00 00       	jmpq   803f66 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ed1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ed5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ed9:	48 89 d6             	mov    %rdx,%rsi
  803edc:	48 89 c7             	mov    %rax,%rdi
  803edf:	48 b8 4e 3d 80 00 00 	movabs $0x803d4e,%rax
  803ee6:	00 00 00 
  803ee9:	ff d0                	callq  *%rax
  803eeb:	85 c0                	test   %eax,%eax
  803eed:	74 07                	je     803ef6 <devpipe_read+0x75>
				return 0;
  803eef:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef4:	eb 70                	jmp    803f66 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803ef6:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  803efd:	00 00 00 
  803f00:	ff d0                	callq  *%rax
  803f02:	eb 01                	jmp    803f05 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f04:	90                   	nop
  803f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f09:	8b 10                	mov    (%rax),%edx
  803f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f0f:	8b 40 04             	mov    0x4(%rax),%eax
  803f12:	39 c2                	cmp    %eax,%edx
  803f14:	74 ab                	je     803ec1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f1e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803f22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f26:	8b 00                	mov    (%rax),%eax
  803f28:	89 c2                	mov    %eax,%edx
  803f2a:	c1 fa 1f             	sar    $0x1f,%edx
  803f2d:	c1 ea 1b             	shr    $0x1b,%edx
  803f30:	01 d0                	add    %edx,%eax
  803f32:	83 e0 1f             	and    $0x1f,%eax
  803f35:	29 d0                	sub    %edx,%eax
  803f37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f3b:	48 98                	cltq   
  803f3d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803f42:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803f44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f48:	8b 00                	mov    (%rax),%eax
  803f4a:	8d 50 01             	lea    0x1(%rax),%edx
  803f4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f51:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f53:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f5c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f60:	72 a2                	jb     803f04 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803f62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f66:	c9                   	leaveq 
  803f67:	c3                   	retq   

0000000000803f68 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f68:	55                   	push   %rbp
  803f69:	48 89 e5             	mov    %rsp,%rbp
  803f6c:	48 83 ec 40          	sub    $0x40,%rsp
  803f70:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f74:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f78:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f80:	48 89 c7             	mov    %rax,%rdi
  803f83:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  803f8a:	00 00 00 
  803f8d:	ff d0                	callq  *%rax
  803f8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f9b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fa2:	00 
  803fa3:	e9 93 00 00 00       	jmpq   80403b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803fa8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb0:	48 89 d6             	mov    %rdx,%rsi
  803fb3:	48 89 c7             	mov    %rax,%rdi
  803fb6:	48 b8 4e 3d 80 00 00 	movabs $0x803d4e,%rax
  803fbd:	00 00 00 
  803fc0:	ff d0                	callq  *%rax
  803fc2:	85 c0                	test   %eax,%eax
  803fc4:	74 07                	je     803fcd <devpipe_write+0x65>
				return 0;
  803fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  803fcb:	eb 7c                	jmp    804049 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803fcd:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  803fd4:	00 00 00 
  803fd7:	ff d0                	callq  *%rax
  803fd9:	eb 01                	jmp    803fdc <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803fdb:	90                   	nop
  803fdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe0:	8b 40 04             	mov    0x4(%rax),%eax
  803fe3:	48 63 d0             	movslq %eax,%rdx
  803fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fea:	8b 00                	mov    (%rax),%eax
  803fec:	48 98                	cltq   
  803fee:	48 83 c0 20          	add    $0x20,%rax
  803ff2:	48 39 c2             	cmp    %rax,%rdx
  803ff5:	73 b1                	jae    803fa8 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ffb:	8b 40 04             	mov    0x4(%rax),%eax
  803ffe:	89 c2                	mov    %eax,%edx
  804000:	c1 fa 1f             	sar    $0x1f,%edx
  804003:	c1 ea 1b             	shr    $0x1b,%edx
  804006:	01 d0                	add    %edx,%eax
  804008:	83 e0 1f             	and    $0x1f,%eax
  80400b:	29 d0                	sub    %edx,%eax
  80400d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804011:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804015:	48 01 ca             	add    %rcx,%rdx
  804018:	0f b6 0a             	movzbl (%rdx),%ecx
  80401b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80401f:	48 98                	cltq   
  804021:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804025:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804029:	8b 40 04             	mov    0x4(%rax),%eax
  80402c:	8d 50 01             	lea    0x1(%rax),%edx
  80402f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804033:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804036:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80403b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80403f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804043:	72 96                	jb     803fdb <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804045:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804049:	c9                   	leaveq 
  80404a:	c3                   	retq   

000000000080404b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80404b:	55                   	push   %rbp
  80404c:	48 89 e5             	mov    %rsp,%rbp
  80404f:	48 83 ec 20          	sub    $0x20,%rsp
  804053:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804057:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80405b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80405f:	48 89 c7             	mov    %rax,%rdi
  804062:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  804069:	00 00 00 
  80406c:	ff d0                	callq  *%rax
  80406e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804072:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804076:	48 be 14 4d 80 00 00 	movabs $0x804d14,%rsi
  80407d:	00 00 00 
  804080:	48 89 c7             	mov    %rax,%rdi
  804083:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  80408a:	00 00 00 
  80408d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80408f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804093:	8b 50 04             	mov    0x4(%rax),%edx
  804096:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409a:	8b 00                	mov    (%rax),%eax
  80409c:	29 c2                	sub    %eax,%edx
  80409e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040a2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8040a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ac:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8040b3:	00 00 00 
	stat->st_dev = &devpipe;
  8040b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ba:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8040c1:	00 00 00 
  8040c4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8040cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040d0:	c9                   	leaveq 
  8040d1:	c3                   	retq   

00000000008040d2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8040d2:	55                   	push   %rbp
  8040d3:	48 89 e5             	mov    %rsp,%rbp
  8040d6:	48 83 ec 10          	sub    $0x10,%rsp
  8040da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8040de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e2:	48 89 c6             	mov    %rax,%rsi
  8040e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ea:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  8040f1:	00 00 00 
  8040f4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8040f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040fa:	48 89 c7             	mov    %rax,%rdi
  8040fd:	48 b8 5f 23 80 00 00 	movabs $0x80235f,%rax
  804104:	00 00 00 
  804107:	ff d0                	callq  *%rax
  804109:	48 89 c6             	mov    %rax,%rsi
  80410c:	bf 00 00 00 00       	mov    $0x0,%edi
  804111:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  804118:	00 00 00 
  80411b:	ff d0                	callq  *%rax
}
  80411d:	c9                   	leaveq 
  80411e:	c3                   	retq   
	...

0000000000804120 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804120:	55                   	push   %rbp
  804121:	48 89 e5             	mov    %rsp,%rbp
  804124:	48 83 ec 20          	sub    $0x20,%rsp
  804128:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80412b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80412e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804131:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804135:	be 01 00 00 00       	mov    $0x1,%esi
  80413a:	48 89 c7             	mov    %rax,%rdi
  80413d:	48 b8 d4 1b 80 00 00 	movabs $0x801bd4,%rax
  804144:	00 00 00 
  804147:	ff d0                	callq  *%rax
}
  804149:	c9                   	leaveq 
  80414a:	c3                   	retq   

000000000080414b <getchar>:

int
getchar(void)
{
  80414b:	55                   	push   %rbp
  80414c:	48 89 e5             	mov    %rsp,%rbp
  80414f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804153:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804157:	ba 01 00 00 00       	mov    $0x1,%edx
  80415c:	48 89 c6             	mov    %rax,%rsi
  80415f:	bf 00 00 00 00       	mov    $0x0,%edi
  804164:	48 b8 54 28 80 00 00 	movabs $0x802854,%rax
  80416b:	00 00 00 
  80416e:	ff d0                	callq  *%rax
  804170:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804173:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804177:	79 05                	jns    80417e <getchar+0x33>
		return r;
  804179:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80417c:	eb 14                	jmp    804192 <getchar+0x47>
	if (r < 1)
  80417e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804182:	7f 07                	jg     80418b <getchar+0x40>
		return -E_EOF;
  804184:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804189:	eb 07                	jmp    804192 <getchar+0x47>
	return c;
  80418b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80418f:	0f b6 c0             	movzbl %al,%eax
}
  804192:	c9                   	leaveq 
  804193:	c3                   	retq   

0000000000804194 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804194:	55                   	push   %rbp
  804195:	48 89 e5             	mov    %rsp,%rbp
  804198:	48 83 ec 20          	sub    $0x20,%rsp
  80419c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80419f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8041a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041a6:	48 89 d6             	mov    %rdx,%rsi
  8041a9:	89 c7                	mov    %eax,%edi
  8041ab:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  8041b2:	00 00 00 
  8041b5:	ff d0                	callq  *%rax
  8041b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041be:	79 05                	jns    8041c5 <iscons+0x31>
		return r;
  8041c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c3:	eb 1a                	jmp    8041df <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8041c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c9:	8b 10                	mov    (%rax),%edx
  8041cb:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8041d2:	00 00 00 
  8041d5:	8b 00                	mov    (%rax),%eax
  8041d7:	39 c2                	cmp    %eax,%edx
  8041d9:	0f 94 c0             	sete   %al
  8041dc:	0f b6 c0             	movzbl %al,%eax
}
  8041df:	c9                   	leaveq 
  8041e0:	c3                   	retq   

00000000008041e1 <opencons>:

int
opencons(void)
{
  8041e1:	55                   	push   %rbp
  8041e2:	48 89 e5             	mov    %rsp,%rbp
  8041e5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041e9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8041ed:	48 89 c7             	mov    %rax,%rdi
  8041f0:	48 b8 8a 23 80 00 00 	movabs $0x80238a,%rax
  8041f7:	00 00 00 
  8041fa:	ff d0                	callq  *%rax
  8041fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804203:	79 05                	jns    80420a <opencons+0x29>
		return r;
  804205:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804208:	eb 5b                	jmp    804265 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80420a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80420e:	ba 07 04 00 00       	mov    $0x407,%edx
  804213:	48 89 c6             	mov    %rax,%rsi
  804216:	bf 00 00 00 00       	mov    $0x0,%edi
  80421b:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  804222:	00 00 00 
  804225:	ff d0                	callq  *%rax
  804227:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80422a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80422e:	79 05                	jns    804235 <opencons+0x54>
		return r;
  804230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804233:	eb 30                	jmp    804265 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804239:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804240:	00 00 00 
  804243:	8b 12                	mov    (%rdx),%edx
  804245:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804256:	48 89 c7             	mov    %rax,%rdi
  804259:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  804260:	00 00 00 
  804263:	ff d0                	callq  *%rax
}
  804265:	c9                   	leaveq 
  804266:	c3                   	retq   

0000000000804267 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804267:	55                   	push   %rbp
  804268:	48 89 e5             	mov    %rsp,%rbp
  80426b:	48 83 ec 30          	sub    $0x30,%rsp
  80426f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804273:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804277:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80427b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804280:	75 13                	jne    804295 <devcons_read+0x2e>
		return 0;
  804282:	b8 00 00 00 00       	mov    $0x0,%eax
  804287:	eb 49                	jmp    8042d2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804289:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  804290:	00 00 00 
  804293:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804295:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  80429c:	00 00 00 
  80429f:	ff d0                	callq  *%rax
  8042a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042a8:	74 df                	je     804289 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8042aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ae:	79 05                	jns    8042b5 <devcons_read+0x4e>
		return c;
  8042b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b3:	eb 1d                	jmp    8042d2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8042b5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8042b9:	75 07                	jne    8042c2 <devcons_read+0x5b>
		return 0;
  8042bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8042c0:	eb 10                	jmp    8042d2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8042c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c5:	89 c2                	mov    %eax,%edx
  8042c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042cb:	88 10                	mov    %dl,(%rax)
	return 1;
  8042cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8042d2:	c9                   	leaveq 
  8042d3:	c3                   	retq   

00000000008042d4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042d4:	55                   	push   %rbp
  8042d5:	48 89 e5             	mov    %rsp,%rbp
  8042d8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8042df:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8042e6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8042ed:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042fb:	eb 77                	jmp    804374 <devcons_write+0xa0>
		m = n - tot;
  8042fd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804304:	89 c2                	mov    %eax,%edx
  804306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804309:	89 d1                	mov    %edx,%ecx
  80430b:	29 c1                	sub    %eax,%ecx
  80430d:	89 c8                	mov    %ecx,%eax
  80430f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804312:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804315:	83 f8 7f             	cmp    $0x7f,%eax
  804318:	76 07                	jbe    804321 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80431a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804321:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804324:	48 63 d0             	movslq %eax,%rdx
  804327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432a:	48 98                	cltq   
  80432c:	48 89 c1             	mov    %rax,%rcx
  80432f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804336:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80433d:	48 89 ce             	mov    %rcx,%rsi
  804340:	48 89 c7             	mov    %rax,%rdi
  804343:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  80434a:	00 00 00 
  80434d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80434f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804352:	48 63 d0             	movslq %eax,%rdx
  804355:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80435c:	48 89 d6             	mov    %rdx,%rsi
  80435f:	48 89 c7             	mov    %rax,%rdi
  804362:	48 b8 d4 1b 80 00 00 	movabs $0x801bd4,%rax
  804369:	00 00 00 
  80436c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80436e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804371:	01 45 fc             	add    %eax,-0x4(%rbp)
  804374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804377:	48 98                	cltq   
  804379:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804380:	0f 82 77 ff ff ff    	jb     8042fd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804386:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804389:	c9                   	leaveq 
  80438a:	c3                   	retq   

000000000080438b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80438b:	55                   	push   %rbp
  80438c:	48 89 e5             	mov    %rsp,%rbp
  80438f:	48 83 ec 08          	sub    $0x8,%rsp
  804393:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80439c:	c9                   	leaveq 
  80439d:	c3                   	retq   

000000000080439e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80439e:	55                   	push   %rbp
  80439f:	48 89 e5             	mov    %rsp,%rbp
  8043a2:	48 83 ec 10          	sub    $0x10,%rsp
  8043a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8043ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043b2:	48 be 20 4d 80 00 00 	movabs $0x804d20,%rsi
  8043b9:	00 00 00 
  8043bc:	48 89 c7             	mov    %rax,%rdi
  8043bf:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  8043c6:	00 00 00 
  8043c9:	ff d0                	callq  *%rax
	return 0;
  8043cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043d0:	c9                   	leaveq 
  8043d1:	c3                   	retq   
	...

00000000008043d4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8043d4:	55                   	push   %rbp
  8043d5:	48 89 e5             	mov    %rsp,%rbp
  8043d8:	48 83 ec 30          	sub    $0x30,%rsp
  8043dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8043e8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8043ed:	74 18                	je     804407 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8043ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043f3:	48 89 c7             	mov    %rax,%rdi
  8043f6:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  8043fd:	00 00 00 
  804400:	ff d0                	callq  *%rax
  804402:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804405:	eb 19                	jmp    804420 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  804407:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80440e:	00 00 00 
  804411:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  804418:	00 00 00 
  80441b:	ff d0                	callq  *%rax
  80441d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804420:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804424:	79 19                	jns    80443f <ipc_recv+0x6b>
	{
		*from_env_store=0;
  804426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80442a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  804430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804434:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  80443a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80443d:	eb 53                	jmp    804492 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  80443f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804444:	74 19                	je     80445f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  804446:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  80444d:	00 00 00 
  804450:	48 8b 00             	mov    (%rax),%rax
  804453:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80445d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80445f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804464:	74 19                	je     80447f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  804466:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  80446d:	00 00 00 
  804470:	48 8b 00             	mov    (%rax),%rax
  804473:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80447d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80447f:	48 b8 60 74 80 00 00 	movabs $0x807460,%rax
  804486:	00 00 00 
  804489:	48 8b 00             	mov    (%rax),%rax
  80448c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  804492:	c9                   	leaveq 
  804493:	c3                   	retq   

0000000000804494 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804494:	55                   	push   %rbp
  804495:	48 89 e5             	mov    %rsp,%rbp
  804498:	48 83 ec 30          	sub    $0x30,%rsp
  80449c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80449f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8044a2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8044a6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8044a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  8044b0:	e9 96 00 00 00       	jmpq   80454b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  8044b5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8044ba:	74 20                	je     8044dc <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8044bc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8044bf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8044c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8044c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044c9:	89 c7                	mov    %eax,%edi
  8044cb:	48 b8 f0 1e 80 00 00 	movabs $0x801ef0,%rax
  8044d2:	00 00 00 
  8044d5:	ff d0                	callq  *%rax
  8044d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044da:	eb 2d                	jmp    804509 <ipc_send+0x75>
		else if(pg==NULL)
  8044dc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8044e1:	75 26                	jne    804509 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  8044e3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8044e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8044ee:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8044f5:	00 00 00 
  8044f8:	89 c7                	mov    %eax,%edi
  8044fa:	48 b8 f0 1e 80 00 00 	movabs $0x801ef0,%rax
  804501:	00 00 00 
  804504:	ff d0                	callq  *%rax
  804506:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  804509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80450d:	79 30                	jns    80453f <ipc_send+0xab>
  80450f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804513:	74 2a                	je     80453f <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  804515:	48 ba 27 4d 80 00 00 	movabs $0x804d27,%rdx
  80451c:	00 00 00 
  80451f:	be 40 00 00 00       	mov    $0x40,%esi
  804524:	48 bf 3f 4d 80 00 00 	movabs $0x804d3f,%rdi
  80452b:	00 00 00 
  80452e:	b8 00 00 00 00       	mov    $0x0,%eax
  804533:	48 b9 ec 05 80 00 00 	movabs $0x8005ec,%rcx
  80453a:	00 00 00 
  80453d:	ff d1                	callq  *%rcx
		}
		sys_yield();
  80453f:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  804546:	00 00 00 
  804549:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  80454b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80454f:	0f 85 60 ff ff ff    	jne    8044b5 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  804555:	c9                   	leaveq 
  804556:	c3                   	retq   

0000000000804557 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804557:	55                   	push   %rbp
  804558:	48 89 e5             	mov    %rsp,%rbp
  80455b:	48 83 ec 18          	sub    $0x18,%rsp
  80455f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804562:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804569:	eb 5e                	jmp    8045c9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80456b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804572:	00 00 00 
  804575:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804578:	48 63 d0             	movslq %eax,%rdx
  80457b:	48 89 d0             	mov    %rdx,%rax
  80457e:	48 c1 e0 03          	shl    $0x3,%rax
  804582:	48 01 d0             	add    %rdx,%rax
  804585:	48 c1 e0 05          	shl    $0x5,%rax
  804589:	48 01 c8             	add    %rcx,%rax
  80458c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804592:	8b 00                	mov    (%rax),%eax
  804594:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804597:	75 2c                	jne    8045c5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804599:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8045a0:	00 00 00 
  8045a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a6:	48 63 d0             	movslq %eax,%rdx
  8045a9:	48 89 d0             	mov    %rdx,%rax
  8045ac:	48 c1 e0 03          	shl    $0x3,%rax
  8045b0:	48 01 d0             	add    %rdx,%rax
  8045b3:	48 c1 e0 05          	shl    $0x5,%rax
  8045b7:	48 01 c8             	add    %rcx,%rax
  8045ba:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8045c0:	8b 40 08             	mov    0x8(%rax),%eax
  8045c3:	eb 12                	jmp    8045d7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8045c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8045c9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8045d0:	7e 99                	jle    80456b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8045d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045d7:	c9                   	leaveq 
  8045d8:	c3                   	retq   
  8045d9:	00 00                	add    %al,(%rax)
	...

00000000008045dc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8045dc:	55                   	push   %rbp
  8045dd:	48 89 e5             	mov    %rsp,%rbp
  8045e0:	48 83 ec 18          	sub    $0x18,%rsp
  8045e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8045e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ec:	48 89 c2             	mov    %rax,%rdx
  8045ef:	48 c1 ea 15          	shr    $0x15,%rdx
  8045f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8045fa:	01 00 00 
  8045fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804601:	83 e0 01             	and    $0x1,%eax
  804604:	48 85 c0             	test   %rax,%rax
  804607:	75 07                	jne    804610 <pageref+0x34>
		return 0;
  804609:	b8 00 00 00 00       	mov    $0x0,%eax
  80460e:	eb 53                	jmp    804663 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804614:	48 89 c2             	mov    %rax,%rdx
  804617:	48 c1 ea 0c          	shr    $0xc,%rdx
  80461b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804622:	01 00 00 
  804625:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804629:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80462d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804631:	83 e0 01             	and    $0x1,%eax
  804634:	48 85 c0             	test   %rax,%rax
  804637:	75 07                	jne    804640 <pageref+0x64>
		return 0;
  804639:	b8 00 00 00 00       	mov    $0x0,%eax
  80463e:	eb 23                	jmp    804663 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804644:	48 89 c2             	mov    %rax,%rdx
  804647:	48 c1 ea 0c          	shr    $0xc,%rdx
  80464b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804652:	00 00 00 
  804655:	48 c1 e2 04          	shl    $0x4,%rdx
  804659:	48 01 d0             	add    %rdx,%rax
  80465c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804660:	0f b7 c0             	movzwl %ax,%eax
}
  804663:	c9                   	leaveq 
  804664:	c3                   	retq   
