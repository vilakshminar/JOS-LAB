
obj/user/testjournal.debug:     file format elf64-x86-64


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
  80003c:	e8 13 04 00 00       	callq  800454 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800050:	89 75 e4             	mov    %esi,-0x1c(%rbp)
        extern union Fsipc fsipcbuf;
        envid_t fsenv;

        strcpy(fsipcbuf.open.req_path, path);
  800053:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800057:	48 89 c6             	mov    %rax,%rsi
  80005a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800061:	00 00 00 
  800064:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  80006b:	00 00 00 
  80006e:	ff d0                	callq  *%rax
        fsipcbuf.open.req_omode = mode;
  800070:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800077:	00 00 00 
  80007a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

        fsenv = ipc_find_env(ENV_TYPE_FS);
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
  800088:	48 b8 0f 21 80 00 00 	movabs $0x80210f,%rax
  80008f:	00 00 00 
  800092:	ff d0                	callq  *%rax
  800094:	89 45 fc             	mov    %eax,-0x4(%rbp)
        ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80009a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009f:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a6:	00 00 00 
  8000a9:	be 01 00 00 00       	mov    $0x1,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
        return ipc_recv(NULL, FVA, NULL);
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000cb:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  8000d2:	00 00 00 
  8000d5:	ff d0                	callq  *%rax
}
  8000d7:	c9                   	leaveq 
  8000d8:	c3                   	retq   

00000000008000d9 <umain>:

void
umain(int argc, char **argv)
{
  8000d9:	55                   	push   %rbp
  8000da:	48 89 e5             	mov    %rsp,%rbp
  8000dd:	53                   	push   %rbx
  8000de:	48 81 ec c8 04 00 00 	sub    $0x4c8,%rsp
  8000e5:	89 bd 3c fb ff ff    	mov    %edi,-0x4c4(%rbp)
  8000eb:	48 89 b5 30 fb ff ff 	mov    %rsi,-0x4d0(%rbp)
        struct Fd *fd;
        struct Fd fdcopy;
        struct Stat st;
        char buf[1024];
	
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  8000f2:	be 02 01 00 00       	mov    $0x102,%esi
  8000f7:	48 bf 6f 43 80 00 00 	movabs $0x80436f,%rdi
  8000fe:	00 00 00 
  800101:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax
  80010d:	48 98                	cltq   
  80010f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800113:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800118:	79 32                	jns    80014c <umain+0x73>
                panic("serve_open /new-file: %e", r);
  80011a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80011e:	48 89 c1             	mov    %rax,%rcx
  800121:	48 ba 79 43 80 00 00 	movabs $0x804379,%rdx
  800128:	00 00 00 
  80012b:	be 20 00 00 00       	mov    $0x20,%esi
  800130:	48 bf 92 43 80 00 00 	movabs $0x804392,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 1c 05 80 00 00 	movabs $0x80051c,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

        if ((r = devfile.dev_write(FVA, msg1, strlen(msg1))) != strlen(msg1))
  80014c:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  800153:	00 00 00 
  800156:	48 8b 58 18          	mov    0x18(%rax),%rbx
  80015a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800161:	00 00 00 
  800164:	48 8b 00             	mov    (%rax),%rax
  800167:	48 89 c7             	mov    %rax,%rdi
  80016a:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  800171:	00 00 00 
  800174:	ff d0                	callq  *%rax
  800176:	48 63 d0             	movslq %eax,%rdx
  800179:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800180:	00 00 00 
  800183:	48 8b 00             	mov    (%rax),%rax
  800186:	48 89 c6             	mov    %rax,%rsi
  800189:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80018e:	ff d3                	callq  *%rbx
  800190:	48 98                	cltq   
  800192:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800196:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80019d:	00 00 00 
  8001a0:	48 8b 00             	mov    (%rax),%rax
  8001a3:	48 89 c7             	mov    %rax,%rdi
  8001a6:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
  8001b2:	48 98                	cltq   
  8001b4:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8001b8:	74 32                	je     8001ec <umain+0x113>
                panic("file_write: %e", r);
  8001ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001be:	48 89 c1             	mov    %rax,%rcx
  8001c1:	48 ba a5 43 80 00 00 	movabs $0x8043a5,%rdx
  8001c8:	00 00 00 
  8001cb:	be 23 00 00 00       	mov    $0x23,%esi
  8001d0:	48 bf 92 43 80 00 00 	movabs $0x804392,%rdi
  8001d7:	00 00 00 
  8001da:	b8 00 00 00 00       	mov    $0x0,%eax
  8001df:	49 b8 1c 05 80 00 00 	movabs $0x80051c,%r8
  8001e6:	00 00 00 
  8001e9:	41 ff d0             	callq  *%r8
	if ((r = devfile.dev_write(FVA, msg2, strlen(msg2))) != strlen(msg2))
  8001ec:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8001f3:	00 00 00 
  8001f6:	48 8b 58 18          	mov    0x18(%rax),%rbx
  8001fa:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800201:	00 00 00 
  800204:	48 8b 00             	mov    (%rax),%rax
  800207:	48 89 c7             	mov    %rax,%rdi
  80020a:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  800211:	00 00 00 
  800214:	ff d0                	callq  *%rax
  800216:	48 63 d0             	movslq %eax,%rdx
  800219:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80022e:	ff d3                	callq  *%rbx
  800230:	48 98                	cltq   
  800232:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800236:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80023d:	00 00 00 
  800240:	48 8b 00             	mov    (%rax),%rax
  800243:	48 89 c7             	mov    %rax,%rdi
  800246:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	48 98                	cltq   
  800254:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  800258:	74 32                	je     80028c <umain+0x1b3>
                panic("file_write: %e", r);
  80025a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80025e:	48 89 c1             	mov    %rax,%rcx
  800261:	48 ba a5 43 80 00 00 	movabs $0x8043a5,%rdx
  800268:	00 00 00 
  80026b:	be 25 00 00 00       	mov    $0x25,%esi
  800270:	48 bf 92 43 80 00 00 	movabs $0x804392,%rdi
  800277:	00 00 00 
  80027a:	b8 00 00 00 00       	mov    $0x0,%eax
  80027f:	49 b8 1c 05 80 00 00 	movabs $0x80051c,%r8
  800286:	00 00 00 
  800289:	41 ff d0             	callq  *%r8
        cprintf("file_write is good\n");
  80028c:	48 bf b4 43 80 00 00 	movabs $0x8043b4,%rdi
  800293:	00 00 00 
  800296:	b8 00 00 00 00       	mov    $0x0,%eax
  80029b:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  8002a2:	00 00 00 
  8002a5:	ff d2                	callq  *%rdx

        FVA->fd_offset = 0;
  8002a7:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8002ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
        memset(buf, 0, sizeof buf);
  8002b3:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002ba:	ba 00 04 00 00       	mov    $0x400,%edx
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 89 c7             	mov    %rax,%rdi
  8002c7:	48 b8 ab 15 80 00 00 	movabs $0x8015ab,%rax
  8002ce:	00 00 00 
  8002d1:	ff d0                	callq  *%rax
        if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002d3:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8002da:	00 00 00 
  8002dd:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8002e1:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002e8:	ba 00 04 00 00       	mov    $0x400,%edx
  8002ed:	48 89 c6             	mov    %rax,%rsi
  8002f0:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  8002f5:	ff d1                	callq  *%rcx
  8002f7:	48 98                	cltq   
  8002f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8002fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800302:	79 32                	jns    800336 <umain+0x25d>
                panic("file_read after file_write: %e", r);
  800304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800308:	48 89 c1             	mov    %rax,%rcx
  80030b:	48 ba c8 43 80 00 00 	movabs $0x8043c8,%rdx
  800312:	00 00 00 
  800315:	be 2b 00 00 00       	mov    $0x2b,%esi
  80031a:	48 bf 92 43 80 00 00 	movabs $0x804392,%rdi
  800321:	00 00 00 
  800324:	b8 00 00 00 00       	mov    $0x0,%eax
  800329:	49 b8 1c 05 80 00 00 	movabs $0x80051c,%r8
  800330:	00 00 00 
  800333:	41 ff d0             	callq  *%r8
	//cprintf("result:%d\nstrlen sum:%d\n",r,strlen(msg1)+strlen(msg2));
        if (r != (strlen(msg1)+strlen(msg2)))
  800336:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80033d:	00 00 00 
  800340:	48 8b 00             	mov    (%rax),%rax
  800343:	48 89 c7             	mov    %rax,%rdi
  800346:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  80034d:	00 00 00 
  800350:	ff d0                	callq  *%rax
  800352:	89 c3                	mov    %eax,%ebx
  800354:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80035b:	00 00 00 
  80035e:	48 8b 00             	mov    (%rax),%rax
  800361:	48 89 c7             	mov    %rax,%rdi
  800364:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  80036b:	00 00 00 
  80036e:	ff d0                	callq  *%rax
  800370:	01 d8                	add    %ebx,%eax
  800372:	48 98                	cltq   
  800374:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800378:	74 32                	je     8003ac <umain+0x2d3>
                panic("file_read after file_write returned wrong length: %d", r);
  80037a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037e:	48 89 c1             	mov    %rax,%rcx
  800381:	48 ba e8 43 80 00 00 	movabs $0x8043e8,%rdx
  800388:	00 00 00 
  80038b:	be 2e 00 00 00       	mov    $0x2e,%esi
  800390:	48 bf 92 43 80 00 00 	movabs $0x804392,%rdi
  800397:	00 00 00 
  80039a:	b8 00 00 00 00       	mov    $0x0,%eax
  80039f:	49 b8 1c 05 80 00 00 	movabs $0x80051c,%r8
  8003a6:	00 00 00 
  8003a9:	41 ff d0             	callq  *%r8
	strcat(msg1, msg2);
  8003ac:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b3:	00 00 00 
  8003b6:	48 8b 10             	mov    (%rax),%rdx
  8003b9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003c0:	00 00 00 
  8003c3:	48 8b 00             	mov    (%rax),%rax
  8003c6:	48 89 d6             	mov    %rdx,%rsi
  8003c9:	48 89 c7             	mov    %rax,%rdi
  8003cc:	48 b8 5a 13 80 00 00 	movabs $0x80135a,%rax
  8003d3:	00 00 00 
  8003d6:	ff d0                	callq  *%rax
        if (strcmp(buf, msg1) != 0)
  8003d8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003df:	00 00 00 
  8003e2:	48 8b 10             	mov    (%rax),%rdx
  8003e5:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8003ec:	48 89 d6             	mov    %rdx,%rsi
  8003ef:	48 89 c7             	mov    %rax,%rdi
  8003f2:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
  8003fe:	85 c0                	test   %eax,%eax
  800400:	74 2a                	je     80042c <umain+0x353>
                panic("file_read after file_write returned wrong data");
  800402:	48 ba 20 44 80 00 00 	movabs $0x804420,%rdx
  800409:	00 00 00 
  80040c:	be 31 00 00 00       	mov    $0x31,%esi
  800411:	48 bf 92 43 80 00 00 	movabs $0x804392,%rdi
  800418:	00 00 00 
  80041b:	b8 00 00 00 00       	mov    $0x0,%eax
  800420:	48 b9 1c 05 80 00 00 	movabs $0x80051c,%rcx
  800427:	00 00 00 
  80042a:	ff d1                	callq  *%rcx
        cprintf("file_read after file_write is good\n");
  80042c:	48 bf 50 44 80 00 00 	movabs $0x804450,%rdi
  800433:	00 00 00 
  800436:	b8 00 00 00 00       	mov    $0x0,%eax
  80043b:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  800442:	00 00 00 
  800445:	ff d2                	callq  *%rdx

}
  800447:	48 81 c4 c8 04 00 00 	add    $0x4c8,%rsp
  80044e:	5b                   	pop    %rbx
  80044f:	5d                   	pop    %rbp
  800450:	c3                   	retq   
  800451:	00 00                	add    %al,(%rax)
	...

0000000000800454 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800454:	55                   	push   %rbp
  800455:	48 89 e5             	mov    %rsp,%rbp
  800458:	48 83 ec 10          	sub    $0x10,%rsp
  80045c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80045f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800463:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80046a:	00 00 00 
  80046d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800474:	48 b8 d0 1b 80 00 00 	movabs $0x801bd0,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
  800480:	48 98                	cltq   
  800482:	48 89 c2             	mov    %rax,%rdx
  800485:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80048b:	48 89 d0             	mov    %rdx,%rax
  80048e:	48 c1 e0 03          	shl    $0x3,%rax
  800492:	48 01 d0             	add    %rdx,%rax
  800495:	48 c1 e0 05          	shl    $0x5,%rax
  800499:	48 89 c2             	mov    %rax,%rdx
  80049c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8004a3:	00 00 00 
  8004a6:	48 01 c2             	add    %rax,%rdx
  8004a9:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8004b0:	00 00 00 
  8004b3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004ba:	7e 14                	jle    8004d0 <libmain+0x7c>
		binaryname = argv[0];
  8004bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c0:	48 8b 10             	mov    (%rax),%rdx
  8004c3:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8004ca:	00 00 00 
  8004cd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d7:	48 89 d6             	mov    %rdx,%rsi
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	48 b8 d9 00 80 00 00 	movabs $0x8000d9,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004e8:	48 b8 f8 04 80 00 00 	movabs $0x8004f8,%rax
  8004ef:	00 00 00 
  8004f2:	ff d0                	callq  *%rax
}
  8004f4:	c9                   	leaveq 
  8004f5:	c3                   	retq   
	...

00000000008004f8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004f8:	55                   	push   %rbp
  8004f9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004fc:	48 b8 d5 24 80 00 00 	movabs $0x8024d5,%rax
  800503:	00 00 00 
  800506:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800508:	bf 00 00 00 00       	mov    $0x0,%edi
  80050d:	48 b8 8c 1b 80 00 00 	movabs $0x801b8c,%rax
  800514:	00 00 00 
  800517:	ff d0                	callq  *%rax
}
  800519:	5d                   	pop    %rbp
  80051a:	c3                   	retq   
	...

000000000080051c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80051c:	55                   	push   %rbp
  80051d:	48 89 e5             	mov    %rsp,%rbp
  800520:	53                   	push   %rbx
  800521:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800528:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80052f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800535:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80053c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800543:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80054a:	84 c0                	test   %al,%al
  80054c:	74 23                	je     800571 <_panic+0x55>
  80054e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800555:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800559:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80055d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800561:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800565:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800569:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80056d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800571:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800578:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80057f:	00 00 00 
  800582:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800589:	00 00 00 
  80058c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800590:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800597:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80059e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a5:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8005ac:	00 00 00 
  8005af:	48 8b 18             	mov    (%rax),%rbx
  8005b2:	48 b8 d0 1b 80 00 00 	movabs $0x801bd0,%rax
  8005b9:	00 00 00 
  8005bc:	ff d0                	callq  *%rax
  8005be:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005c4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005cb:	41 89 c8             	mov    %ecx,%r8d
  8005ce:	48 89 d1             	mov    %rdx,%rcx
  8005d1:	48 89 da             	mov    %rbx,%rdx
  8005d4:	89 c6                	mov    %eax,%esi
  8005d6:	48 bf 80 44 80 00 00 	movabs $0x804480,%rdi
  8005dd:	00 00 00 
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	49 b9 57 07 80 00 00 	movabs $0x800757,%r9
  8005ec:	00 00 00 
  8005ef:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005f2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005f9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800600:	48 89 d6             	mov    %rdx,%rsi
  800603:	48 89 c7             	mov    %rax,%rdi
  800606:	48 b8 ab 06 80 00 00 	movabs $0x8006ab,%rax
  80060d:	00 00 00 
  800610:	ff d0                	callq  *%rax
	cprintf("\n");
  800612:	48 bf a3 44 80 00 00 	movabs $0x8044a3,%rdi
  800619:	00 00 00 
  80061c:	b8 00 00 00 00       	mov    $0x0,%eax
  800621:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  800628:	00 00 00 
  80062b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80062d:	cc                   	int3   
  80062e:	eb fd                	jmp    80062d <_panic+0x111>

0000000000800630 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800630:	55                   	push   %rbp
  800631:	48 89 e5             	mov    %rsp,%rbp
  800634:	48 83 ec 10          	sub    $0x10,%rsp
  800638:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80063b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80063f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800643:	8b 00                	mov    (%rax),%eax
  800645:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800648:	89 d6                	mov    %edx,%esi
  80064a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80064e:	48 63 d0             	movslq %eax,%rdx
  800651:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800656:	8d 50 01             	lea    0x1(%rax),%edx
  800659:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065d:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80065f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066a:	75 2c                	jne    800698 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  80066c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	48 98                	cltq   
  800674:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800678:	48 83 c2 08          	add    $0x8,%rdx
  80067c:	48 89 c6             	mov    %rax,%rsi
  80067f:	48 89 d7             	mov    %rdx,%rdi
  800682:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  800689:	00 00 00 
  80068c:	ff d0                	callq  *%rax
		b->idx = 0;
  80068e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800692:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	8b 40 04             	mov    0x4(%rax),%eax
  80069f:	8d 50 01             	lea    0x1(%rax),%edx
  8006a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006a9:	c9                   	leaveq 
  8006aa:	c3                   	retq   

00000000008006ab <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006ab:	55                   	push   %rbp
  8006ac:	48 89 e5             	mov    %rsp,%rbp
  8006af:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006bd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006c4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006cb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006d2:	48 8b 0a             	mov    (%rdx),%rcx
  8006d5:	48 89 08             	mov    %rcx,(%rax)
  8006d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006ef:	00 00 00 
	b.cnt = 0;
  8006f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006f9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8006fc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800703:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80070a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800711:	48 89 c6             	mov    %rax,%rsi
  800714:	48 bf 30 06 80 00 00 	movabs $0x800630,%rdi
  80071b:	00 00 00 
  80071e:	48 b8 08 0b 80 00 00 	movabs $0x800b08,%rax
  800725:	00 00 00 
  800728:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80072a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800730:	48 98                	cltq   
  800732:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800739:	48 83 c2 08          	add    $0x8,%rdx
  80073d:	48 89 c6             	mov    %rax,%rsi
  800740:	48 89 d7             	mov    %rdx,%rdi
  800743:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  80074a:	00 00 00 
  80074d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80074f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800755:	c9                   	leaveq 
  800756:	c3                   	retq   

0000000000800757 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800757:	55                   	push   %rbp
  800758:	48 89 e5             	mov    %rsp,%rbp
  80075b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800762:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800769:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800770:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800777:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80077e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800785:	84 c0                	test   %al,%al
  800787:	74 20                	je     8007a9 <cprintf+0x52>
  800789:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80078d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800791:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800795:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800799:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80079d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007a1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007a9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007b0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b7:	00 00 00 
  8007ba:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c1:	00 00 00 
  8007c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007cf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007dd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007e4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007eb:	48 8b 0a             	mov    (%rdx),%rcx
  8007ee:	48 89 08             	mov    %rcx,(%rax)
  8007f1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007f5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007f9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007fd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800801:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800808:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80080f:	48 89 d6             	mov    %rdx,%rsi
  800812:	48 89 c7             	mov    %rax,%rdi
  800815:	48 b8 ab 06 80 00 00 	movabs $0x8006ab,%rax
  80081c:	00 00 00 
  80081f:	ff d0                	callq  *%rax
  800821:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800827:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80082d:	c9                   	leaveq 
  80082e:	c3                   	retq   
	...

0000000000800830 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800830:	55                   	push   %rbp
  800831:	48 89 e5             	mov    %rsp,%rbp
  800834:	48 83 ec 30          	sub    $0x30,%rsp
  800838:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80083c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800840:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800844:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800847:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80084b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800852:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800856:	77 52                	ja     8008aa <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800858:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80085b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80085f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800862:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	ba 00 00 00 00       	mov    $0x0,%edx
  80086f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800873:	48 89 c2             	mov    %rax,%rdx
  800876:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800879:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80087c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800884:	41 89 f9             	mov    %edi,%r9d
  800887:	48 89 c7             	mov    %rax,%rdi
  80088a:	48 b8 30 08 80 00 00 	movabs $0x800830,%rax
  800891:	00 00 00 
  800894:	ff d0                	callq  *%rax
  800896:	eb 1c                	jmp    8008b4 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800898:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80089c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80089f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8008a3:	48 89 d6             	mov    %rdx,%rsi
  8008a6:	89 c7                	mov    %eax,%edi
  8008a8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008aa:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008b2:	7f e4                	jg     800898 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c0:	48 f7 f1             	div    %rcx
  8008c3:	48 89 d0             	mov    %rdx,%rax
  8008c6:	48 ba 88 46 80 00 00 	movabs $0x804688,%rdx
  8008cd:	00 00 00 
  8008d0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008d4:	0f be c0             	movsbl %al,%eax
  8008d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008db:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8008df:	48 89 d6             	mov    %rdx,%rsi
  8008e2:	89 c7                	mov    %eax,%edi
  8008e4:	ff d1                	callq  *%rcx
}
  8008e6:	c9                   	leaveq 
  8008e7:	c3                   	retq   

00000000008008e8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	48 83 ec 20          	sub    $0x20,%rsp
  8008f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008f7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008fb:	7e 52                	jle    80094f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800901:	8b 00                	mov    (%rax),%eax
  800903:	83 f8 30             	cmp    $0x30,%eax
  800906:	73 24                	jae    80092c <getuint+0x44>
  800908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800914:	8b 00                	mov    (%rax),%eax
  800916:	89 c0                	mov    %eax,%eax
  800918:	48 01 d0             	add    %rdx,%rax
  80091b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091f:	8b 12                	mov    (%rdx),%edx
  800921:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800928:	89 0a                	mov    %ecx,(%rdx)
  80092a:	eb 17                	jmp    800943 <getuint+0x5b>
  80092c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800930:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800934:	48 89 d0             	mov    %rdx,%rax
  800937:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800943:	48 8b 00             	mov    (%rax),%rax
  800946:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094a:	e9 a3 00 00 00       	jmpq   8009f2 <getuint+0x10a>
	else if (lflag)
  80094f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800953:	74 4f                	je     8009a4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800959:	8b 00                	mov    (%rax),%eax
  80095b:	83 f8 30             	cmp    $0x30,%eax
  80095e:	73 24                	jae    800984 <getuint+0x9c>
  800960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800964:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096c:	8b 00                	mov    (%rax),%eax
  80096e:	89 c0                	mov    %eax,%eax
  800970:	48 01 d0             	add    %rdx,%rax
  800973:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800977:	8b 12                	mov    (%rdx),%edx
  800979:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80097c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800980:	89 0a                	mov    %ecx,(%rdx)
  800982:	eb 17                	jmp    80099b <getuint+0xb3>
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80098c:	48 89 d0             	mov    %rdx,%rax
  80098f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800993:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800997:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099b:	48 8b 00             	mov    (%rax),%rax
  80099e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a2:	eb 4e                	jmp    8009f2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a8:	8b 00                	mov    (%rax),%eax
  8009aa:	83 f8 30             	cmp    $0x30,%eax
  8009ad:	73 24                	jae    8009d3 <getuint+0xeb>
  8009af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bb:	8b 00                	mov    (%rax),%eax
  8009bd:	89 c0                	mov    %eax,%eax
  8009bf:	48 01 d0             	add    %rdx,%rax
  8009c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c6:	8b 12                	mov    (%rdx),%edx
  8009c8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cf:	89 0a                	mov    %ecx,(%rdx)
  8009d1:	eb 17                	jmp    8009ea <getuint+0x102>
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009db:	48 89 d0             	mov    %rdx,%rax
  8009de:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ea:	8b 00                	mov    (%rax),%eax
  8009ec:	89 c0                	mov    %eax,%eax
  8009ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f6:	c9                   	leaveq 
  8009f7:	c3                   	retq   

00000000008009f8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f8:	55                   	push   %rbp
  8009f9:	48 89 e5             	mov    %rsp,%rbp
  8009fc:	48 83 ec 20          	sub    $0x20,%rsp
  800a00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a04:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a07:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a0b:	7e 52                	jle    800a5f <getint+0x67>
		x=va_arg(*ap, long long);
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	8b 00                	mov    (%rax),%eax
  800a13:	83 f8 30             	cmp    $0x30,%eax
  800a16:	73 24                	jae    800a3c <getint+0x44>
  800a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a24:	8b 00                	mov    (%rax),%eax
  800a26:	89 c0                	mov    %eax,%eax
  800a28:	48 01 d0             	add    %rdx,%rax
  800a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2f:	8b 12                	mov    (%rdx),%edx
  800a31:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a38:	89 0a                	mov    %ecx,(%rdx)
  800a3a:	eb 17                	jmp    800a53 <getint+0x5b>
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a44:	48 89 d0             	mov    %rdx,%rax
  800a47:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a53:	48 8b 00             	mov    (%rax),%rax
  800a56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5a:	e9 a3 00 00 00       	jmpq   800b02 <getint+0x10a>
	else if (lflag)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a63:	74 4f                	je     800ab4 <getint+0xbc>
		x=va_arg(*ap, long);
  800a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a69:	8b 00                	mov    (%rax),%eax
  800a6b:	83 f8 30             	cmp    $0x30,%eax
  800a6e:	73 24                	jae    800a94 <getint+0x9c>
  800a70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a74:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	8b 00                	mov    (%rax),%eax
  800a7e:	89 c0                	mov    %eax,%eax
  800a80:	48 01 d0             	add    %rdx,%rax
  800a83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a87:	8b 12                	mov    (%rdx),%edx
  800a89:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a90:	89 0a                	mov    %ecx,(%rdx)
  800a92:	eb 17                	jmp    800aab <getint+0xb3>
  800a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a98:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a9c:	48 89 d0             	mov    %rdx,%rax
  800a9f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aab:	48 8b 00             	mov    (%rax),%rax
  800aae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ab2:	eb 4e                	jmp    800b02 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	8b 00                	mov    (%rax),%eax
  800aba:	83 f8 30             	cmp    $0x30,%eax
  800abd:	73 24                	jae    800ae3 <getint+0xeb>
  800abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acb:	8b 00                	mov    (%rax),%eax
  800acd:	89 c0                	mov    %eax,%eax
  800acf:	48 01 d0             	add    %rdx,%rax
  800ad2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad6:	8b 12                	mov    (%rdx),%edx
  800ad8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adf:	89 0a                	mov    %ecx,(%rdx)
  800ae1:	eb 17                	jmp    800afa <getint+0x102>
  800ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aeb:	48 89 d0             	mov    %rdx,%rax
  800aee:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800afa:	8b 00                	mov    (%rax),%eax
  800afc:	48 98                	cltq   
  800afe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b06:	c9                   	leaveq 
  800b07:	c3                   	retq   

0000000000800b08 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b08:	55                   	push   %rbp
  800b09:	48 89 e5             	mov    %rsp,%rbp
  800b0c:	41 54                	push   %r12
  800b0e:	53                   	push   %rbx
  800b0f:	48 83 ec 60          	sub    $0x60,%rsp
  800b13:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b17:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b1b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b1f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b23:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b27:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b2b:	48 8b 0a             	mov    (%rdx),%rcx
  800b2e:	48 89 08             	mov    %rcx,(%rax)
  800b31:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b35:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b39:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b3d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b41:	eb 17                	jmp    800b5a <vprintfmt+0x52>
			if (ch == '\0')
  800b43:	85 db                	test   %ebx,%ebx
  800b45:	0f 84 d7 04 00 00    	je     801022 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800b4b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b4f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b53:	48 89 c6             	mov    %rax,%rsi
  800b56:	89 df                	mov    %ebx,%edi
  800b58:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b5a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b5e:	0f b6 00             	movzbl (%rax),%eax
  800b61:	0f b6 d8             	movzbl %al,%ebx
  800b64:	83 fb 25             	cmp    $0x25,%ebx
  800b67:	0f 95 c0             	setne  %al
  800b6a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b6f:	84 c0                	test   %al,%al
  800b71:	75 d0                	jne    800b43 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b73:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b77:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b7e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b8c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800b93:	eb 04                	jmp    800b99 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800b95:	90                   	nop
  800b96:	eb 01                	jmp    800b99 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800b98:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b99:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b9d:	0f b6 00             	movzbl (%rax),%eax
  800ba0:	0f b6 d8             	movzbl %al,%ebx
  800ba3:	89 d8                	mov    %ebx,%eax
  800ba5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800baa:	83 e8 23             	sub    $0x23,%eax
  800bad:	83 f8 55             	cmp    $0x55,%eax
  800bb0:	0f 87 38 04 00 00    	ja     800fee <vprintfmt+0x4e6>
  800bb6:	89 c0                	mov    %eax,%eax
  800bb8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bbf:	00 
  800bc0:	48 b8 b0 46 80 00 00 	movabs $0x8046b0,%rax
  800bc7:	00 00 00 
  800bca:	48 01 d0             	add    %rdx,%rax
  800bcd:	48 8b 00             	mov    (%rax),%rax
  800bd0:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bd6:	eb c1                	jmp    800b99 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bd8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bdc:	eb bb                	jmp    800b99 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bde:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800be5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800be8:	89 d0                	mov    %edx,%eax
  800bea:	c1 e0 02             	shl    $0x2,%eax
  800bed:	01 d0                	add    %edx,%eax
  800bef:	01 c0                	add    %eax,%eax
  800bf1:	01 d8                	add    %ebx,%eax
  800bf3:	83 e8 30             	sub    $0x30,%eax
  800bf6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bf9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bfd:	0f b6 00             	movzbl (%rax),%eax
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 63                	jle    800c6b <vprintfmt+0x163>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 5e                	jg     800c6b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c12:	eb d1                	jmp    800be5 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c17:	83 f8 30             	cmp    $0x30,%eax
  800c1a:	73 17                	jae    800c33 <vprintfmt+0x12b>
  800c1c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c23:	89 c0                	mov    %eax,%eax
  800c25:	48 01 d0             	add    %rdx,%rax
  800c28:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c2b:	83 c2 08             	add    $0x8,%edx
  800c2e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c31:	eb 0f                	jmp    800c42 <vprintfmt+0x13a>
  800c33:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c37:	48 89 d0             	mov    %rdx,%rax
  800c3a:	48 83 c2 08          	add    $0x8,%rdx
  800c3e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c42:	8b 00                	mov    (%rax),%eax
  800c44:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c47:	eb 23                	jmp    800c6c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800c49:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4d:	0f 89 42 ff ff ff    	jns    800b95 <vprintfmt+0x8d>
				width = 0;
  800c53:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c5a:	e9 36 ff ff ff       	jmpq   800b95 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800c5f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c66:	e9 2e ff ff ff       	jmpq   800b99 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c6b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c70:	0f 89 22 ff ff ff    	jns    800b98 <vprintfmt+0x90>
				width = precision, precision = -1;
  800c76:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c79:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c7c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c83:	e9 10 ff ff ff       	jmpq   800b98 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c88:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c8c:	e9 08 ff ff ff       	jmpq   800b99 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c94:	83 f8 30             	cmp    $0x30,%eax
  800c97:	73 17                	jae    800cb0 <vprintfmt+0x1a8>
  800c99:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca0:	89 c0                	mov    %eax,%eax
  800ca2:	48 01 d0             	add    %rdx,%rax
  800ca5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca8:	83 c2 08             	add    $0x8,%edx
  800cab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cae:	eb 0f                	jmp    800cbf <vprintfmt+0x1b7>
  800cb0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb4:	48 89 d0             	mov    %rdx,%rax
  800cb7:	48 83 c2 08          	add    $0x8,%rdx
  800cbb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbf:	8b 00                	mov    (%rax),%eax
  800cc1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc5:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800cc9:	48 89 d6             	mov    %rdx,%rsi
  800ccc:	89 c7                	mov    %eax,%edi
  800cce:	ff d1                	callq  *%rcx
			break;
  800cd0:	e9 47 03 00 00       	jmpq   80101c <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800cd5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd8:	83 f8 30             	cmp    $0x30,%eax
  800cdb:	73 17                	jae    800cf4 <vprintfmt+0x1ec>
  800cdd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce4:	89 c0                	mov    %eax,%eax
  800ce6:	48 01 d0             	add    %rdx,%rax
  800ce9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cec:	83 c2 08             	add    $0x8,%edx
  800cef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf2:	eb 0f                	jmp    800d03 <vprintfmt+0x1fb>
  800cf4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf8:	48 89 d0             	mov    %rdx,%rax
  800cfb:	48 83 c2 08          	add    $0x8,%rdx
  800cff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d03:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d05:	85 db                	test   %ebx,%ebx
  800d07:	79 02                	jns    800d0b <vprintfmt+0x203>
				err = -err;
  800d09:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d0b:	83 fb 10             	cmp    $0x10,%ebx
  800d0e:	7f 16                	jg     800d26 <vprintfmt+0x21e>
  800d10:	48 b8 00 46 80 00 00 	movabs $0x804600,%rax
  800d17:	00 00 00 
  800d1a:	48 63 d3             	movslq %ebx,%rdx
  800d1d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d21:	4d 85 e4             	test   %r12,%r12
  800d24:	75 2e                	jne    800d54 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800d26:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2e:	89 d9                	mov    %ebx,%ecx
  800d30:	48 ba 99 46 80 00 00 	movabs $0x804699,%rdx
  800d37:	00 00 00 
  800d3a:	48 89 c7             	mov    %rax,%rdi
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d42:	49 b8 2c 10 80 00 00 	movabs $0x80102c,%r8
  800d49:	00 00 00 
  800d4c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d4f:	e9 c8 02 00 00       	jmpq   80101c <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d54:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5c:	4c 89 e1             	mov    %r12,%rcx
  800d5f:	48 ba a2 46 80 00 00 	movabs $0x8046a2,%rdx
  800d66:	00 00 00 
  800d69:	48 89 c7             	mov    %rax,%rdi
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d71:	49 b8 2c 10 80 00 00 	movabs $0x80102c,%r8
  800d78:	00 00 00 
  800d7b:	41 ff d0             	callq  *%r8
			break;
  800d7e:	e9 99 02 00 00       	jmpq   80101c <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d86:	83 f8 30             	cmp    $0x30,%eax
  800d89:	73 17                	jae    800da2 <vprintfmt+0x29a>
  800d8b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d92:	89 c0                	mov    %eax,%eax
  800d94:	48 01 d0             	add    %rdx,%rax
  800d97:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9a:	83 c2 08             	add    $0x8,%edx
  800d9d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da0:	eb 0f                	jmp    800db1 <vprintfmt+0x2a9>
  800da2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da6:	48 89 d0             	mov    %rdx,%rax
  800da9:	48 83 c2 08          	add    $0x8,%rdx
  800dad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db1:	4c 8b 20             	mov    (%rax),%r12
  800db4:	4d 85 e4             	test   %r12,%r12
  800db7:	75 0a                	jne    800dc3 <vprintfmt+0x2bb>
				p = "(null)";
  800db9:	49 bc a5 46 80 00 00 	movabs $0x8046a5,%r12
  800dc0:	00 00 00 
			if (width > 0 && padc != '-')
  800dc3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc7:	7e 7a                	jle    800e43 <vprintfmt+0x33b>
  800dc9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dcd:	74 74                	je     800e43 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dcf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dd2:	48 98                	cltq   
  800dd4:	48 89 c6             	mov    %rax,%rsi
  800dd7:	4c 89 e7             	mov    %r12,%rdi
  800dda:	48 b8 d6 12 80 00 00 	movabs $0x8012d6,%rax
  800de1:	00 00 00 
  800de4:	ff d0                	callq  *%rax
  800de6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800de9:	eb 17                	jmp    800e02 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800deb:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800def:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df3:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800df7:	48 89 d6             	mov    %rdx,%rsi
  800dfa:	89 c7                	mov    %eax,%edi
  800dfc:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e06:	7f e3                	jg     800deb <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e08:	eb 39                	jmp    800e43 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e0e:	74 1e                	je     800e2e <vprintfmt+0x326>
  800e10:	83 fb 1f             	cmp    $0x1f,%ebx
  800e13:	7e 05                	jle    800e1a <vprintfmt+0x312>
  800e15:	83 fb 7e             	cmp    $0x7e,%ebx
  800e18:	7e 14                	jle    800e2e <vprintfmt+0x326>
					putch('?', putdat);
  800e1a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e1e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e22:	48 89 c6             	mov    %rax,%rsi
  800e25:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e2a:	ff d2                	callq  *%rdx
  800e2c:	eb 0f                	jmp    800e3d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800e2e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e32:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e36:	48 89 c6             	mov    %rax,%rsi
  800e39:	89 df                	mov    %ebx,%edi
  800e3b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e41:	eb 01                	jmp    800e44 <vprintfmt+0x33c>
  800e43:	90                   	nop
  800e44:	41 0f b6 04 24       	movzbl (%r12),%eax
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	0f 95 c0             	setne  %al
  800e51:	49 83 c4 01          	add    $0x1,%r12
  800e55:	84 c0                	test   %al,%al
  800e57:	74 28                	je     800e81 <vprintfmt+0x379>
  800e59:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e5d:	78 ab                	js     800e0a <vprintfmt+0x302>
  800e5f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e63:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e67:	79 a1                	jns    800e0a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e69:	eb 16                	jmp    800e81 <vprintfmt+0x379>
				putch(' ', putdat);
  800e6b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e6f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e73:	48 89 c6             	mov    %rax,%rsi
  800e76:	bf 20 00 00 00       	mov    $0x20,%edi
  800e7b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e7d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e81:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e85:	7f e4                	jg     800e6b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800e87:	e9 90 01 00 00       	jmpq   80101c <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e8c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e90:	be 03 00 00 00       	mov    $0x3,%esi
  800e95:	48 89 c7             	mov    %rax,%rdi
  800e98:	48 b8 f8 09 80 00 00 	movabs $0x8009f8,%rax
  800e9f:	00 00 00 
  800ea2:	ff d0                	callq  *%rax
  800ea4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ea8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eac:	48 85 c0             	test   %rax,%rax
  800eaf:	79 1d                	jns    800ece <vprintfmt+0x3c6>
				putch('-', putdat);
  800eb1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800eb5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800eb9:	48 89 c6             	mov    %rax,%rsi
  800ebc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ec1:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800ec3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec7:	48 f7 d8             	neg    %rax
  800eca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ece:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed5:	e9 d5 00 00 00       	jmpq   800faf <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800eda:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ede:	be 03 00 00 00       	mov    $0x3,%esi
  800ee3:	48 89 c7             	mov    %rax,%rdi
  800ee6:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800eed:	00 00 00 
  800ef0:	ff d0                	callq  *%rax
  800ef2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ef6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800efd:	e9 ad 00 00 00       	jmpq   800faf <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800f02:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f06:	be 03 00 00 00       	mov    $0x3,%esi
  800f0b:	48 89 c7             	mov    %rax,%rdi
  800f0e:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800f15:	00 00 00 
  800f18:	ff d0                	callq  *%rax
  800f1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800f1e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f25:	e9 85 00 00 00       	jmpq   800faf <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800f2a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f2e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f32:	48 89 c6             	mov    %rax,%rsi
  800f35:	bf 30 00 00 00       	mov    $0x30,%edi
  800f3a:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800f3c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f40:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f44:	48 89 c6             	mov    %rax,%rsi
  800f47:	bf 78 00 00 00       	mov    $0x78,%edi
  800f4c:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f51:	83 f8 30             	cmp    $0x30,%eax
  800f54:	73 17                	jae    800f6d <vprintfmt+0x465>
  800f56:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f5d:	89 c0                	mov    %eax,%eax
  800f5f:	48 01 d0             	add    %rdx,%rax
  800f62:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f65:	83 c2 08             	add    $0x8,%edx
  800f68:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f6b:	eb 0f                	jmp    800f7c <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800f6d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f71:	48 89 d0             	mov    %rdx,%rax
  800f74:	48 83 c2 08          	add    $0x8,%rdx
  800f78:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f7c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f83:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f8a:	eb 23                	jmp    800faf <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f8c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f90:	be 03 00 00 00       	mov    $0x3,%esi
  800f95:	48 89 c7             	mov    %rax,%rdi
  800f98:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800f9f:	00 00 00 
  800fa2:	ff d0                	callq  *%rax
  800fa4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fa8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800faf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fb4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fb7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fbe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc6:	45 89 c1             	mov    %r8d,%r9d
  800fc9:	41 89 f8             	mov    %edi,%r8d
  800fcc:	48 89 c7             	mov    %rax,%rdi
  800fcf:	48 b8 30 08 80 00 00 	movabs $0x800830,%rax
  800fd6:	00 00 00 
  800fd9:	ff d0                	callq  *%rax
			break;
  800fdb:	eb 3f                	jmp    80101c <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fdd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fe1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fe5:	48 89 c6             	mov    %rax,%rsi
  800fe8:	89 df                	mov    %ebx,%edi
  800fea:	ff d2                	callq  *%rdx
			break;
  800fec:	eb 2e                	jmp    80101c <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fee:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ff2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ff6:	48 89 c6             	mov    %rax,%rsi
  800ff9:	bf 25 00 00 00       	mov    $0x25,%edi
  800ffe:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801000:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801005:	eb 05                	jmp    80100c <vprintfmt+0x504>
  801007:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80100c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801010:	48 83 e8 01          	sub    $0x1,%rax
  801014:	0f b6 00             	movzbl (%rax),%eax
  801017:	3c 25                	cmp    $0x25,%al
  801019:	75 ec                	jne    801007 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  80101b:	90                   	nop
		}
	}
  80101c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80101d:	e9 38 fb ff ff       	jmpq   800b5a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801022:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  801023:	48 83 c4 60          	add    $0x60,%rsp
  801027:	5b                   	pop    %rbx
  801028:	41 5c                	pop    %r12
  80102a:	5d                   	pop    %rbp
  80102b:	c3                   	retq   

000000000080102c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80102c:	55                   	push   %rbp
  80102d:	48 89 e5             	mov    %rsp,%rbp
  801030:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801037:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80103e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801045:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80104c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801053:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80105a:	84 c0                	test   %al,%al
  80105c:	74 20                	je     80107e <printfmt+0x52>
  80105e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801062:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801066:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80106a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80106e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801072:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801076:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80107a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80107e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801085:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80108c:	00 00 00 
  80108f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801096:	00 00 00 
  801099:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80109d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010a4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010ab:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010b2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010b9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010c0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010c7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010ce:	48 89 c7             	mov    %rax,%rdi
  8010d1:	48 b8 08 0b 80 00 00 	movabs $0x800b08,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010dd:	c9                   	leaveq 
  8010de:	c3                   	retq   

00000000008010df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010df:	55                   	push   %rbp
  8010e0:	48 89 e5             	mov    %rsp,%rbp
  8010e3:	48 83 ec 10          	sub    $0x10,%rsp
  8010e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f2:	8b 40 10             	mov    0x10(%rax),%eax
  8010f5:	8d 50 01             	lea    0x1(%rax),%edx
  8010f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fc:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801103:	48 8b 10             	mov    (%rax),%rdx
  801106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80110e:	48 39 c2             	cmp    %rax,%rdx
  801111:	73 17                	jae    80112a <sprintputch+0x4b>
		*b->buf++ = ch;
  801113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801117:	48 8b 00             	mov    (%rax),%rax
  80111a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80111d:	88 10                	mov    %dl,(%rax)
  80111f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801127:	48 89 10             	mov    %rdx,(%rax)
}
  80112a:	c9                   	leaveq 
  80112b:	c3                   	retq   

000000000080112c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80112c:	55                   	push   %rbp
  80112d:	48 89 e5             	mov    %rsp,%rbp
  801130:	48 83 ec 50          	sub    $0x50,%rsp
  801134:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801138:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80113b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80113f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801143:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801147:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80114b:	48 8b 0a             	mov    (%rdx),%rcx
  80114e:	48 89 08             	mov    %rcx,(%rax)
  801151:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801155:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801159:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80115d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801161:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801165:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801169:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80116c:	48 98                	cltq   
  80116e:	48 83 e8 01          	sub    $0x1,%rax
  801172:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801176:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80117a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801181:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801186:	74 06                	je     80118e <vsnprintf+0x62>
  801188:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80118c:	7f 07                	jg     801195 <vsnprintf+0x69>
		return -E_INVAL;
  80118e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801193:	eb 2f                	jmp    8011c4 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801195:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801199:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80119d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011a1:	48 89 c6             	mov    %rax,%rsi
  8011a4:	48 bf df 10 80 00 00 	movabs $0x8010df,%rdi
  8011ab:	00 00 00 
  8011ae:	48 b8 08 0b 80 00 00 	movabs $0x800b08,%rax
  8011b5:	00 00 00 
  8011b8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011be:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011c1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011c4:	c9                   	leaveq 
  8011c5:	c3                   	retq   

00000000008011c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011c6:	55                   	push   %rbp
  8011c7:	48 89 e5             	mov    %rsp,%rbp
  8011ca:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011d1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011d8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011f3:	84 c0                	test   %al,%al
  8011f5:	74 20                	je     801217 <snprintf+0x51>
  8011f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801203:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801207:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80120b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80120f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801213:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801217:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80121e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801225:	00 00 00 
  801228:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80122f:	00 00 00 
  801232:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801236:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80123d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801244:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80124b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801252:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801259:	48 8b 0a             	mov    (%rdx),%rcx
  80125c:	48 89 08             	mov    %rcx,(%rax)
  80125f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801263:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801267:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80126b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80126f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801276:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80127d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801283:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80128a:	48 89 c7             	mov    %rax,%rdi
  80128d:	48 b8 2c 11 80 00 00 	movabs $0x80112c,%rax
  801294:	00 00 00 
  801297:	ff d0                	callq  *%rax
  801299:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80129f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012a5:	c9                   	leaveq 
  8012a6:	c3                   	retq   
	...

00000000008012a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012a8:	55                   	push   %rbp
  8012a9:	48 89 e5             	mov    %rsp,%rbp
  8012ac:	48 83 ec 18          	sub    $0x18,%rsp
  8012b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012bb:	eb 09                	jmp    8012c6 <strlen+0x1e>
		n++;
  8012bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	84 c0                	test   %al,%al
  8012cf:	75 ec                	jne    8012bd <strlen+0x15>
		n++;
	return n;
  8012d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d4:	c9                   	leaveq 
  8012d5:	c3                   	retq   

00000000008012d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012d6:	55                   	push   %rbp
  8012d7:	48 89 e5             	mov    %rsp,%rbp
  8012da:	48 83 ec 20          	sub    $0x20,%rsp
  8012de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012ed:	eb 0e                	jmp    8012fd <strnlen+0x27>
		n++;
  8012ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801302:	74 0b                	je     80130f <strnlen+0x39>
  801304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801308:	0f b6 00             	movzbl (%rax),%eax
  80130b:	84 c0                	test   %al,%al
  80130d:	75 e0                	jne    8012ef <strnlen+0x19>
		n++;
	return n;
  80130f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801312:	c9                   	leaveq 
  801313:	c3                   	retq   

0000000000801314 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801314:	55                   	push   %rbp
  801315:	48 89 e5             	mov    %rsp,%rbp
  801318:	48 83 ec 20          	sub    $0x20,%rsp
  80131c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801320:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801328:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80132c:	90                   	nop
  80132d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801331:	0f b6 10             	movzbl (%rax),%edx
  801334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801338:	88 10                	mov    %dl,(%rax)
  80133a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133e:	0f b6 00             	movzbl (%rax),%eax
  801341:	84 c0                	test   %al,%al
  801343:	0f 95 c0             	setne  %al
  801346:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80134b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801350:	84 c0                	test   %al,%al
  801352:	75 d9                	jne    80132d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801358:	c9                   	leaveq 
  801359:	c3                   	retq   

000000000080135a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80135a:	55                   	push   %rbp
  80135b:	48 89 e5             	mov    %rsp,%rbp
  80135e:	48 83 ec 20          	sub    $0x20,%rsp
  801362:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801366:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80136a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136e:	48 89 c7             	mov    %rax,%rdi
  801371:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  801378:	00 00 00 
  80137b:	ff d0                	callq  *%rax
  80137d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801383:	48 98                	cltq   
  801385:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801389:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80138d:	48 89 d6             	mov    %rdx,%rsi
  801390:	48 89 c7             	mov    %rax,%rdi
  801393:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  80139a:	00 00 00 
  80139d:	ff d0                	callq  *%rax
	return dst;
  80139f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013a3:	c9                   	leaveq 
  8013a4:	c3                   	retq   

00000000008013a5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013a5:	55                   	push   %rbp
  8013a6:	48 89 e5             	mov    %rsp,%rbp
  8013a9:	48 83 ec 28          	sub    $0x28,%rsp
  8013ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013c1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013c8:	00 
  8013c9:	eb 27                	jmp    8013f2 <strncpy+0x4d>
		*dst++ = *src;
  8013cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013cf:	0f b6 10             	movzbl (%rax),%edx
  8013d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d6:	88 10                	mov    %dl,(%rax)
  8013d8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	84 c0                	test   %al,%al
  8013e6:	74 05                	je     8013ed <strncpy+0x48>
			src++;
  8013e8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013fa:	72 cf                	jb     8013cb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801400:	c9                   	leaveq 
  801401:	c3                   	retq   

0000000000801402 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801402:	55                   	push   %rbp
  801403:	48 89 e5             	mov    %rsp,%rbp
  801406:	48 83 ec 28          	sub    $0x28,%rsp
  80140a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801412:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80141e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801423:	74 37                	je     80145c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801425:	eb 17                	jmp    80143e <strlcpy+0x3c>
			*dst++ = *src++;
  801427:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142b:	0f b6 10             	movzbl (%rax),%edx
  80142e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801432:	88 10                	mov    %dl,(%rax)
  801434:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801439:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80143e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801443:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801448:	74 0b                	je     801455 <strlcpy+0x53>
  80144a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	84 c0                	test   %al,%al
  801453:	75 d2                	jne    801427 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801459:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80145c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801464:	48 89 d1             	mov    %rdx,%rcx
  801467:	48 29 c1             	sub    %rax,%rcx
  80146a:	48 89 c8             	mov    %rcx,%rax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 10          	sub    $0x10,%rsp
  801477:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80147f:	eb 0a                	jmp    80148b <strcmp+0x1c>
		p++, q++;
  801481:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801486:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80148b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148f:	0f b6 00             	movzbl (%rax),%eax
  801492:	84 c0                	test   %al,%al
  801494:	74 12                	je     8014a8 <strcmp+0x39>
  801496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149a:	0f b6 10             	movzbl (%rax),%edx
  80149d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	38 c2                	cmp    %al,%dl
  8014a6:	74 d9                	je     801481 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ac:	0f b6 00             	movzbl (%rax),%eax
  8014af:	0f b6 d0             	movzbl %al,%edx
  8014b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	0f b6 c0             	movzbl %al,%eax
  8014bc:	89 d1                	mov    %edx,%ecx
  8014be:	29 c1                	sub    %eax,%ecx
  8014c0:	89 c8                	mov    %ecx,%eax
}
  8014c2:	c9                   	leaveq 
  8014c3:	c3                   	retq   

00000000008014c4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014c4:	55                   	push   %rbp
  8014c5:	48 89 e5             	mov    %rsp,%rbp
  8014c8:	48 83 ec 18          	sub    $0x18,%rsp
  8014cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014d8:	eb 0f                	jmp    8014e9 <strncmp+0x25>
		n--, p++, q++;
  8014da:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ee:	74 1d                	je     80150d <strncmp+0x49>
  8014f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	84 c0                	test   %al,%al
  8014f9:	74 12                	je     80150d <strncmp+0x49>
  8014fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ff:	0f b6 10             	movzbl (%rax),%edx
  801502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	38 c2                	cmp    %al,%dl
  80150b:	74 cd                	je     8014da <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80150d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801512:	75 07                	jne    80151b <strncmp+0x57>
		return 0;
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
  801519:	eb 1a                	jmp    801535 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80151b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	0f b6 d0             	movzbl %al,%edx
  801525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	0f b6 c0             	movzbl %al,%eax
  80152f:	89 d1                	mov    %edx,%ecx
  801531:	29 c1                	sub    %eax,%ecx
  801533:	89 c8                	mov    %ecx,%eax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 10          	sub    $0x10,%rsp
  80153f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801543:	89 f0                	mov    %esi,%eax
  801545:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801548:	eb 17                	jmp    801561 <strchr+0x2a>
		if (*s == c)
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801554:	75 06                	jne    80155c <strchr+0x25>
			return (char *) s;
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	eb 15                	jmp    801571 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80155c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	84 c0                	test   %al,%al
  80156a:	75 de                	jne    80154a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801571:	c9                   	leaveq 
  801572:	c3                   	retq   

0000000000801573 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801573:	55                   	push   %rbp
  801574:	48 89 e5             	mov    %rsp,%rbp
  801577:	48 83 ec 10          	sub    $0x10,%rsp
  80157b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157f:	89 f0                	mov    %esi,%eax
  801581:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801584:	eb 11                	jmp    801597 <strfind+0x24>
		if (*s == c)
  801586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158a:	0f b6 00             	movzbl (%rax),%eax
  80158d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801590:	74 12                	je     8015a4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801592:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	84 c0                	test   %al,%al
  8015a0:	75 e4                	jne    801586 <strfind+0x13>
  8015a2:	eb 01                	jmp    8015a5 <strfind+0x32>
		if (*s == c)
			break;
  8015a4:	90                   	nop
	return (char *) s;
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a9:	c9                   	leaveq 
  8015aa:	c3                   	retq   

00000000008015ab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	48 83 ec 18          	sub    $0x18,%rsp
  8015b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c3:	75 06                	jne    8015cb <memset+0x20>
		return v;
  8015c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c9:	eb 69                	jmp    801634 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cf:	83 e0 03             	and    $0x3,%eax
  8015d2:	48 85 c0             	test   %rax,%rax
  8015d5:	75 48                	jne    80161f <memset+0x74>
  8015d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015db:	83 e0 03             	and    $0x3,%eax
  8015de:	48 85 c0             	test   %rax,%rax
  8015e1:	75 3c                	jne    80161f <memset+0x74>
		c &= 0xFF;
  8015e3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ed:	89 c2                	mov    %eax,%edx
  8015ef:	c1 e2 18             	shl    $0x18,%edx
  8015f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f5:	c1 e0 10             	shl    $0x10,%eax
  8015f8:	09 c2                	or     %eax,%edx
  8015fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fd:	c1 e0 08             	shl    $0x8,%eax
  801600:	09 d0                	or     %edx,%eax
  801602:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801609:	48 89 c1             	mov    %rax,%rcx
  80160c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801610:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801614:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801617:	48 89 d7             	mov    %rdx,%rdi
  80161a:	fc                   	cld    
  80161b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80161d:	eb 11                	jmp    801630 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80161f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801623:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801626:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80162a:	48 89 d7             	mov    %rdx,%rdi
  80162d:	fc                   	cld    
  80162e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801634:	c9                   	leaveq 
  801635:	c3                   	retq   

0000000000801636 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	48 83 ec 28          	sub    $0x28,%rsp
  80163e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801642:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801646:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80164a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80164e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801656:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80165a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801662:	0f 83 88 00 00 00    	jae    8016f0 <memmove+0xba>
  801668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801670:	48 01 d0             	add    %rdx,%rax
  801673:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801677:	76 77                	jbe    8016f0 <memmove+0xba>
		s += n;
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168d:	83 e0 03             	and    $0x3,%eax
  801690:	48 85 c0             	test   %rax,%rax
  801693:	75 3b                	jne    8016d0 <memmove+0x9a>
  801695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801699:	83 e0 03             	and    $0x3,%eax
  80169c:	48 85 c0             	test   %rax,%rax
  80169f:	75 2f                	jne    8016d0 <memmove+0x9a>
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	83 e0 03             	and    $0x3,%eax
  8016a8:	48 85 c0             	test   %rax,%rax
  8016ab:	75 23                	jne    8016d0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b1:	48 83 e8 04          	sub    $0x4,%rax
  8016b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b9:	48 83 ea 04          	sub    $0x4,%rdx
  8016bd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016c1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016c5:	48 89 c7             	mov    %rax,%rdi
  8016c8:	48 89 d6             	mov    %rdx,%rsi
  8016cb:	fd                   	std    
  8016cc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016ce:	eb 1d                	jmp    8016ed <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016dc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e4:	48 89 d7             	mov    %rdx,%rdi
  8016e7:	48 89 c1             	mov    %rax,%rcx
  8016ea:	fd                   	std    
  8016eb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016ed:	fc                   	cld    
  8016ee:	eb 57                	jmp    801747 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f4:	83 e0 03             	and    $0x3,%eax
  8016f7:	48 85 c0             	test   %rax,%rax
  8016fa:	75 36                	jne    801732 <memmove+0xfc>
  8016fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801700:	83 e0 03             	and    $0x3,%eax
  801703:	48 85 c0             	test   %rax,%rax
  801706:	75 2a                	jne    801732 <memmove+0xfc>
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	83 e0 03             	and    $0x3,%eax
  80170f:	48 85 c0             	test   %rax,%rax
  801712:	75 1e                	jne    801732 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801718:	48 89 c1             	mov    %rax,%rcx
  80171b:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80171f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801723:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801727:	48 89 c7             	mov    %rax,%rdi
  80172a:	48 89 d6             	mov    %rdx,%rsi
  80172d:	fc                   	cld    
  80172e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801730:	eb 15                	jmp    801747 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801736:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80173a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80173e:	48 89 c7             	mov    %rax,%rdi
  801741:	48 89 d6             	mov    %rdx,%rsi
  801744:	fc                   	cld    
  801745:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80174b:	c9                   	leaveq 
  80174c:	c3                   	retq   

000000000080174d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80174d:	55                   	push   %rbp
  80174e:	48 89 e5             	mov    %rsp,%rbp
  801751:	48 83 ec 18          	sub    $0x18,%rsp
  801755:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801759:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80175d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801761:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801765:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176d:	48 89 ce             	mov    %rcx,%rsi
  801770:	48 89 c7             	mov    %rax,%rdi
  801773:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  80177a:	00 00 00 
  80177d:	ff d0                	callq  *%rax
}
  80177f:	c9                   	leaveq 
  801780:	c3                   	retq   

0000000000801781 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801781:	55                   	push   %rbp
  801782:	48 89 e5             	mov    %rsp,%rbp
  801785:	48 83 ec 28          	sub    $0x28,%rsp
  801789:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80178d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801791:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801799:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80179d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017a5:	eb 38                	jmp    8017df <memcmp+0x5e>
		if (*s1 != *s2)
  8017a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ab:	0f b6 10             	movzbl (%rax),%edx
  8017ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b2:	0f b6 00             	movzbl (%rax),%eax
  8017b5:	38 c2                	cmp    %al,%dl
  8017b7:	74 1c                	je     8017d5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8017b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bd:	0f b6 00             	movzbl (%rax),%eax
  8017c0:	0f b6 d0             	movzbl %al,%edx
  8017c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	0f b6 c0             	movzbl %al,%eax
  8017cd:	89 d1                	mov    %edx,%ecx
  8017cf:	29 c1                	sub    %eax,%ecx
  8017d1:	89 c8                	mov    %ecx,%eax
  8017d3:	eb 20                	jmp    8017f5 <memcmp+0x74>
		s1++, s2++;
  8017d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017da:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017e4:	0f 95 c0             	setne  %al
  8017e7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8017ec:	84 c0                	test   %al,%al
  8017ee:	75 b7                	jne    8017a7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f5:	c9                   	leaveq 
  8017f6:	c3                   	retq   

00000000008017f7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017f7:	55                   	push   %rbp
  8017f8:	48 89 e5             	mov    %rsp,%rbp
  8017fb:	48 83 ec 28          	sub    $0x28,%rsp
  8017ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801803:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801806:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80180a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801812:	48 01 d0             	add    %rdx,%rax
  801815:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801819:	eb 13                	jmp    80182e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80181b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80181f:	0f b6 10             	movzbl (%rax),%edx
  801822:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801825:	38 c2                	cmp    %al,%dl
  801827:	74 11                	je     80183a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801829:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80182e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801832:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801836:	72 e3                	jb     80181b <memfind+0x24>
  801838:	eb 01                	jmp    80183b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80183a:	90                   	nop
	return (void *) s;
  80183b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183f:	c9                   	leaveq 
  801840:	c3                   	retq   

0000000000801841 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801841:	55                   	push   %rbp
  801842:	48 89 e5             	mov    %rsp,%rbp
  801845:	48 83 ec 38          	sub    $0x38,%rsp
  801849:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80184d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801851:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801854:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80185b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801862:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801863:	eb 05                	jmp    80186a <strtol+0x29>
		s++;
  801865:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80186a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186e:	0f b6 00             	movzbl (%rax),%eax
  801871:	3c 20                	cmp    $0x20,%al
  801873:	74 f0                	je     801865 <strtol+0x24>
  801875:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801879:	0f b6 00             	movzbl (%rax),%eax
  80187c:	3c 09                	cmp    $0x9,%al
  80187e:	74 e5                	je     801865 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801884:	0f b6 00             	movzbl (%rax),%eax
  801887:	3c 2b                	cmp    $0x2b,%al
  801889:	75 07                	jne    801892 <strtol+0x51>
		s++;
  80188b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801890:	eb 17                	jmp    8018a9 <strtol+0x68>
	else if (*s == '-')
  801892:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801896:	0f b6 00             	movzbl (%rax),%eax
  801899:	3c 2d                	cmp    $0x2d,%al
  80189b:	75 0c                	jne    8018a9 <strtol+0x68>
		s++, neg = 1;
  80189d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018ad:	74 06                	je     8018b5 <strtol+0x74>
  8018af:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018b3:	75 28                	jne    8018dd <strtol+0x9c>
  8018b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b9:	0f b6 00             	movzbl (%rax),%eax
  8018bc:	3c 30                	cmp    $0x30,%al
  8018be:	75 1d                	jne    8018dd <strtol+0x9c>
  8018c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c4:	48 83 c0 01          	add    $0x1,%rax
  8018c8:	0f b6 00             	movzbl (%rax),%eax
  8018cb:	3c 78                	cmp    $0x78,%al
  8018cd:	75 0e                	jne    8018dd <strtol+0x9c>
		s += 2, base = 16;
  8018cf:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018d4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018db:	eb 2c                	jmp    801909 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018dd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e1:	75 19                	jne    8018fc <strtol+0xbb>
  8018e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e7:	0f b6 00             	movzbl (%rax),%eax
  8018ea:	3c 30                	cmp    $0x30,%al
  8018ec:	75 0e                	jne    8018fc <strtol+0xbb>
		s++, base = 8;
  8018ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018f3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018fa:	eb 0d                	jmp    801909 <strtol+0xc8>
	else if (base == 0)
  8018fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801900:	75 07                	jne    801909 <strtol+0xc8>
		base = 10;
  801902:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801909:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190d:	0f b6 00             	movzbl (%rax),%eax
  801910:	3c 2f                	cmp    $0x2f,%al
  801912:	7e 1d                	jle    801931 <strtol+0xf0>
  801914:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801918:	0f b6 00             	movzbl (%rax),%eax
  80191b:	3c 39                	cmp    $0x39,%al
  80191d:	7f 12                	jg     801931 <strtol+0xf0>
			dig = *s - '0';
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	0f be c0             	movsbl %al,%eax
  801929:	83 e8 30             	sub    $0x30,%eax
  80192c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80192f:	eb 4e                	jmp    80197f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801935:	0f b6 00             	movzbl (%rax),%eax
  801938:	3c 60                	cmp    $0x60,%al
  80193a:	7e 1d                	jle    801959 <strtol+0x118>
  80193c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801940:	0f b6 00             	movzbl (%rax),%eax
  801943:	3c 7a                	cmp    $0x7a,%al
  801945:	7f 12                	jg     801959 <strtol+0x118>
			dig = *s - 'a' + 10;
  801947:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194b:	0f b6 00             	movzbl (%rax),%eax
  80194e:	0f be c0             	movsbl %al,%eax
  801951:	83 e8 57             	sub    $0x57,%eax
  801954:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801957:	eb 26                	jmp    80197f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801959:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195d:	0f b6 00             	movzbl (%rax),%eax
  801960:	3c 40                	cmp    $0x40,%al
  801962:	7e 47                	jle    8019ab <strtol+0x16a>
  801964:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801968:	0f b6 00             	movzbl (%rax),%eax
  80196b:	3c 5a                	cmp    $0x5a,%al
  80196d:	7f 3c                	jg     8019ab <strtol+0x16a>
			dig = *s - 'A' + 10;
  80196f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801973:	0f b6 00             	movzbl (%rax),%eax
  801976:	0f be c0             	movsbl %al,%eax
  801979:	83 e8 37             	sub    $0x37,%eax
  80197c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80197f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801982:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801985:	7d 23                	jge    8019aa <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801987:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80198c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80198f:	48 98                	cltq   
  801991:	48 89 c2             	mov    %rax,%rdx
  801994:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801999:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80199c:	48 98                	cltq   
  80199e:	48 01 d0             	add    %rdx,%rax
  8019a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019a5:	e9 5f ff ff ff       	jmpq   801909 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019aa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019ab:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019b0:	74 0b                	je     8019bd <strtol+0x17c>
		*endptr = (char *) s;
  8019b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019ba:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019c1:	74 09                	je     8019cc <strtol+0x18b>
  8019c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c7:	48 f7 d8             	neg    %rax
  8019ca:	eb 04                	jmp    8019d0 <strtol+0x18f>
  8019cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019d0:	c9                   	leaveq 
  8019d1:	c3                   	retq   

00000000008019d2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019d2:	55                   	push   %rbp
  8019d3:	48 89 e5             	mov    %rsp,%rbp
  8019d6:	48 83 ec 30          	sub    $0x30,%rsp
  8019da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e6:	0f b6 00             	movzbl (%rax),%eax
  8019e9:	88 45 ff             	mov    %al,-0x1(%rbp)
  8019ec:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8019f1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019f5:	75 06                	jne    8019fd <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	eb 68                	jmp    801a65 <strstr+0x93>

    len = strlen(str);
  8019fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a01:	48 89 c7             	mov    %rax,%rdi
  801a04:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  801a0b:	00 00 00 
  801a0e:	ff d0                	callq  *%rax
  801a10:	48 98                	cltq   
  801a12:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1a:	0f b6 00             	movzbl (%rax),%eax
  801a1d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801a20:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801a25:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a29:	75 07                	jne    801a32 <strstr+0x60>
                return (char *) 0;
  801a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a30:	eb 33                	jmp    801a65 <strstr+0x93>
        } while (sc != c);
  801a32:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a36:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a39:	75 db                	jne    801a16 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801a3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a47:	48 89 ce             	mov    %rcx,%rsi
  801a4a:	48 89 c7             	mov    %rax,%rdi
  801a4d:	48 b8 c4 14 80 00 00 	movabs $0x8014c4,%rax
  801a54:	00 00 00 
  801a57:	ff d0                	callq  *%rax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	75 b9                	jne    801a16 <strstr+0x44>

    return (char *) (in - 1);
  801a5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a61:	48 83 e8 01          	sub    $0x1,%rax
}
  801a65:	c9                   	leaveq 
  801a66:	c3                   	retq   
	...

0000000000801a68 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a68:	55                   	push   %rbp
  801a69:	48 89 e5             	mov    %rsp,%rbp
  801a6c:	53                   	push   %rbx
  801a6d:	48 83 ec 58          	sub    $0x58,%rsp
  801a71:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a74:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a77:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a7b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a7f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a83:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a87:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a8a:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801a8d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a91:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a95:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a99:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a9d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801aa1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801aa4:	4c 89 c3             	mov    %r8,%rbx
  801aa7:	cd 30                	int    $0x30
  801aa9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801aad:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801ab1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801ab5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ab9:	74 3e                	je     801af9 <syscall+0x91>
  801abb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ac0:	7e 37                	jle    801af9 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ac2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ac6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ac9:	49 89 d0             	mov    %rdx,%r8
  801acc:	89 c1                	mov    %eax,%ecx
  801ace:	48 ba 60 49 80 00 00 	movabs $0x804960,%rdx
  801ad5:	00 00 00 
  801ad8:	be 23 00 00 00       	mov    $0x23,%esi
  801add:	48 bf 7d 49 80 00 00 	movabs $0x80497d,%rdi
  801ae4:	00 00 00 
  801ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aec:	49 b9 1c 05 80 00 00 	movabs $0x80051c,%r9
  801af3:	00 00 00 
  801af6:	41 ff d1             	callq  *%r9

	return ret;
  801af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801afd:	48 83 c4 58          	add    $0x58,%rsp
  801b01:	5b                   	pop    %rbx
  801b02:	5d                   	pop    %rbp
  801b03:	c3                   	retq   

0000000000801b04 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b04:	55                   	push   %rbp
  801b05:	48 89 e5             	mov    %rsp,%rbp
  801b08:	48 83 ec 20          	sub    $0x20,%rsp
  801b0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b23:	00 
  801b24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b30:	48 89 d1             	mov    %rdx,%rcx
  801b33:	48 89 c2             	mov    %rax,%rdx
  801b36:	be 00 00 00 00       	mov    $0x0,%esi
  801b3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b40:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	callq  *%rax
}
  801b4c:	c9                   	leaveq 
  801b4d:	c3                   	retq   

0000000000801b4e <sys_cgetc>:

int
sys_cgetc(void)
{
  801b4e:	55                   	push   %rbp
  801b4f:	48 89 e5             	mov    %rsp,%rbp
  801b52:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5d:	00 
  801b5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b74:	be 00 00 00 00       	mov    $0x0,%esi
  801b79:	bf 01 00 00 00       	mov    $0x1,%edi
  801b7e:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801b85:	00 00 00 
  801b88:	ff d0                	callq  *%rax
}
  801b8a:	c9                   	leaveq 
  801b8b:	c3                   	retq   

0000000000801b8c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b8c:	55                   	push   %rbp
  801b8d:	48 89 e5             	mov    %rsp,%rbp
  801b90:	48 83 ec 20          	sub    $0x20,%rsp
  801b94:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9a:	48 98                	cltq   
  801b9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba3:	00 
  801ba4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801baa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb5:	48 89 c2             	mov    %rax,%rdx
  801bb8:	be 01 00 00 00       	mov    $0x1,%esi
  801bbd:	bf 03 00 00 00       	mov    $0x3,%edi
  801bc2:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801bc9:	00 00 00 
  801bcc:	ff d0                	callq  *%rax
}
  801bce:	c9                   	leaveq 
  801bcf:	c3                   	retq   

0000000000801bd0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801bd0:	55                   	push   %rbp
  801bd1:	48 89 e5             	mov    %rsp,%rbp
  801bd4:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801bd8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bdf:	00 
  801be0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf6:	be 00 00 00 00       	mov    $0x0,%esi
  801bfb:	bf 02 00 00 00       	mov    $0x2,%edi
  801c00:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801c07:	00 00 00 
  801c0a:	ff d0                	callq  *%rax
}
  801c0c:	c9                   	leaveq 
  801c0d:	c3                   	retq   

0000000000801c0e <sys_yield>:

void
sys_yield(void)
{
  801c0e:	55                   	push   %rbp
  801c0f:	48 89 e5             	mov    %rsp,%rbp
  801c12:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1d:	00 
  801c1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c34:	be 00 00 00 00       	mov    $0x0,%esi
  801c39:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c3e:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801c45:	00 00 00 
  801c48:	ff d0                	callq  *%rax
}
  801c4a:	c9                   	leaveq 
  801c4b:	c3                   	retq   

0000000000801c4c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c4c:	55                   	push   %rbp
  801c4d:	48 89 e5             	mov    %rsp,%rbp
  801c50:	48 83 ec 20          	sub    $0x20,%rsp
  801c54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c5b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c61:	48 63 c8             	movslq %eax,%rcx
  801c64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6b:	48 98                	cltq   
  801c6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c74:	00 
  801c75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7b:	49 89 c8             	mov    %rcx,%r8
  801c7e:	48 89 d1             	mov    %rdx,%rcx
  801c81:	48 89 c2             	mov    %rax,%rdx
  801c84:	be 01 00 00 00       	mov    $0x1,%esi
  801c89:	bf 04 00 00 00       	mov    $0x4,%edi
  801c8e:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
}
  801c9a:	c9                   	leaveq 
  801c9b:	c3                   	retq   

0000000000801c9c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c9c:	55                   	push   %rbp
  801c9d:	48 89 e5             	mov    %rsp,%rbp
  801ca0:	48 83 ec 30          	sub    $0x30,%rsp
  801ca4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cab:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cae:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cb2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801cb6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cb9:	48 63 c8             	movslq %eax,%rcx
  801cbc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cc3:	48 63 f0             	movslq %eax,%rsi
  801cc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccd:	48 98                	cltq   
  801ccf:	48 89 0c 24          	mov    %rcx,(%rsp)
  801cd3:	49 89 f9             	mov    %rdi,%r9
  801cd6:	49 89 f0             	mov    %rsi,%r8
  801cd9:	48 89 d1             	mov    %rdx,%rcx
  801cdc:	48 89 c2             	mov    %rax,%rdx
  801cdf:	be 01 00 00 00       	mov    $0x1,%esi
  801ce4:	bf 05 00 00 00       	mov    $0x5,%edi
  801ce9:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801cf0:	00 00 00 
  801cf3:	ff d0                	callq  *%rax
}
  801cf5:	c9                   	leaveq 
  801cf6:	c3                   	retq   

0000000000801cf7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801cf7:	55                   	push   %rbp
  801cf8:	48 89 e5             	mov    %rsp,%rbp
  801cfb:	48 83 ec 20          	sub    $0x20,%rsp
  801cff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0d:	48 98                	cltq   
  801d0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d16:	00 
  801d17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d23:	48 89 d1             	mov    %rdx,%rcx
  801d26:	48 89 c2             	mov    %rax,%rdx
  801d29:	be 01 00 00 00       	mov    $0x1,%esi
  801d2e:	bf 06 00 00 00       	mov    $0x6,%edi
  801d33:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801d3a:	00 00 00 
  801d3d:	ff d0                	callq  *%rax
}
  801d3f:	c9                   	leaveq 
  801d40:	c3                   	retq   

0000000000801d41 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d41:	55                   	push   %rbp
  801d42:	48 89 e5             	mov    %rsp,%rbp
  801d45:	48 83 ec 20          	sub    $0x20,%rsp
  801d49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d4c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d52:	48 63 d0             	movslq %eax,%rdx
  801d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d58:	48 98                	cltq   
  801d5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d61:	00 
  801d62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6e:	48 89 d1             	mov    %rdx,%rcx
  801d71:	48 89 c2             	mov    %rax,%rdx
  801d74:	be 01 00 00 00       	mov    $0x1,%esi
  801d79:	bf 08 00 00 00       	mov    $0x8,%edi
  801d7e:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801d85:	00 00 00 
  801d88:	ff d0                	callq  *%rax
}
  801d8a:	c9                   	leaveq 
  801d8b:	c3                   	retq   

0000000000801d8c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d8c:	55                   	push   %rbp
  801d8d:	48 89 e5             	mov    %rsp,%rbp
  801d90:	48 83 ec 20          	sub    $0x20,%rsp
  801d94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da2:	48 98                	cltq   
  801da4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dab:	00 
  801dac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db8:	48 89 d1             	mov    %rdx,%rcx
  801dbb:	48 89 c2             	mov    %rax,%rdx
  801dbe:	be 01 00 00 00       	mov    $0x1,%esi
  801dc3:	bf 09 00 00 00       	mov    $0x9,%edi
  801dc8:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	callq  *%rax
}
  801dd4:	c9                   	leaveq 
  801dd5:	c3                   	retq   

0000000000801dd6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801dd6:	55                   	push   %rbp
  801dd7:	48 89 e5             	mov    %rsp,%rbp
  801dda:	48 83 ec 20          	sub    $0x20,%rsp
  801dde:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801de5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dec:	48 98                	cltq   
  801dee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df5:	00 
  801df6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e02:	48 89 d1             	mov    %rdx,%rcx
  801e05:	48 89 c2             	mov    %rax,%rdx
  801e08:	be 01 00 00 00       	mov    $0x1,%esi
  801e0d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e12:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
}
  801e1e:	c9                   	leaveq 
  801e1f:	c3                   	retq   

0000000000801e20 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e20:	55                   	push   %rbp
  801e21:	48 89 e5             	mov    %rsp,%rbp
  801e24:	48 83 ec 30          	sub    $0x30,%rsp
  801e28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e2f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e33:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e39:	48 63 f0             	movslq %eax,%rsi
  801e3c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e43:	48 98                	cltq   
  801e45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e50:	00 
  801e51:	49 89 f1             	mov    %rsi,%r9
  801e54:	49 89 c8             	mov    %rcx,%r8
  801e57:	48 89 d1             	mov    %rdx,%rcx
  801e5a:	48 89 c2             	mov    %rax,%rdx
  801e5d:	be 00 00 00 00       	mov    $0x0,%esi
  801e62:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e67:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801e6e:	00 00 00 
  801e71:	ff d0                	callq  *%rax
}
  801e73:	c9                   	leaveq 
  801e74:	c3                   	retq   

0000000000801e75 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e75:	55                   	push   %rbp
  801e76:	48 89 e5             	mov    %rsp,%rbp
  801e79:	48 83 ec 20          	sub    $0x20,%rsp
  801e7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e8c:	00 
  801e8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e9e:	48 89 c2             	mov    %rax,%rdx
  801ea1:	be 01 00 00 00       	mov    $0x1,%esi
  801ea6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801eab:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	callq  *%rax
}
  801eb7:	c9                   	leaveq 
  801eb8:	c3                   	retq   

0000000000801eb9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801eb9:	55                   	push   %rbp
  801eba:	48 89 e5             	mov    %rsp,%rbp
  801ebd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ec1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ec8:	00 
  801ec9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ecf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eda:	ba 00 00 00 00       	mov    $0x0,%edx
  801edf:	be 00 00 00 00       	mov    $0x0,%esi
  801ee4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ee9:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801ef0:	00 00 00 
  801ef3:	ff d0                	callq  *%rax
}
  801ef5:	c9                   	leaveq 
  801ef6:	c3                   	retq   

0000000000801ef7 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801ef7:	55                   	push   %rbp
  801ef8:	48 89 e5             	mov    %rsp,%rbp
  801efb:	48 83 ec 20          	sub    $0x20,%rsp
  801eff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f16:	00 
  801f17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f23:	48 89 d1             	mov    %rdx,%rcx
  801f26:	48 89 c2             	mov    %rax,%rdx
  801f29:	be 00 00 00 00       	mov    $0x0,%esi
  801f2e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801f33:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
}
  801f3f:	c9                   	leaveq 
  801f40:	c3                   	retq   

0000000000801f41 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801f41:	55                   	push   %rbp
  801f42:	48 89 e5             	mov    %rsp,%rbp
  801f45:	48 83 ec 20          	sub    $0x20,%rsp
  801f49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f60:	00 
  801f61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f6d:	48 89 d1             	mov    %rdx,%rcx
  801f70:	48 89 c2             	mov    %rax,%rdx
  801f73:	be 00 00 00 00       	mov    $0x0,%esi
  801f78:	bf 10 00 00 00       	mov    $0x10,%edi
  801f7d:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  801f84:	00 00 00 
  801f87:	ff d0                	callq  *%rax
}
  801f89:	c9                   	leaveq 
  801f8a:	c3                   	retq   
	...

0000000000801f8c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f8c:	55                   	push   %rbp
  801f8d:	48 89 e5             	mov    %rsp,%rbp
  801f90:	48 83 ec 30          	sub    $0x30,%rsp
  801f94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  801fa0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801fa5:	74 18                	je     801fbf <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  801fa7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fab:	48 89 c7             	mov    %rax,%rdi
  801fae:	48 b8 75 1e 80 00 00 	movabs $0x801e75,%rax
  801fb5:	00 00 00 
  801fb8:	ff d0                	callq  *%rax
  801fba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fbd:	eb 19                	jmp    801fd8 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  801fbf:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  801fc6:	00 00 00 
  801fc9:	48 b8 75 1e 80 00 00 	movabs $0x801e75,%rax
  801fd0:	00 00 00 
  801fd3:	ff d0                	callq  *%rax
  801fd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  801fd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fdc:	79 19                	jns    801ff7 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  801fde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  801fe8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fec:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  801ff2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff5:	eb 53                	jmp    80204a <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  801ff7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ffc:	74 19                	je     802017 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  801ffe:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802005:	00 00 00 
  802008:	48 8b 00             	mov    (%rax),%rax
  80200b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802015:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  802017:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80201c:	74 19                	je     802037 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  80201e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802025:	00 00 00 
  802028:	48 8b 00             	mov    (%rax),%rax
  80202b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802031:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802035:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802037:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80203e:	00 00 00 
  802041:	48 8b 00             	mov    (%rax),%rax
  802044:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80204a:	c9                   	leaveq 
  80204b:	c3                   	retq   

000000000080204c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80204c:	55                   	push   %rbp
  80204d:	48 89 e5             	mov    %rsp,%rbp
  802050:	48 83 ec 30          	sub    $0x30,%rsp
  802054:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802057:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80205a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80205e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  802061:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  802068:	e9 96 00 00 00       	jmpq   802103 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  80206d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802072:	74 20                	je     802094 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  802074:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802077:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80207a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80207e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802081:	89 c7                	mov    %eax,%edi
  802083:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  80208a:	00 00 00 
  80208d:	ff d0                	callq  *%rax
  80208f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802092:	eb 2d                	jmp    8020c1 <ipc_send+0x75>
		else if(pg==NULL)
  802094:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802099:	75 26                	jne    8020c1 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80209b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80209e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020a6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8020ad:	00 00 00 
  8020b0:	89 c7                	mov    %eax,%edi
  8020b2:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  8020b9:	00 00 00 
  8020bc:	ff d0                	callq  *%rax
  8020be:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8020c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020c5:	79 30                	jns    8020f7 <ipc_send+0xab>
  8020c7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8020cb:	74 2a                	je     8020f7 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8020cd:	48 ba 8b 49 80 00 00 	movabs $0x80498b,%rdx
  8020d4:	00 00 00 
  8020d7:	be 40 00 00 00       	mov    $0x40,%esi
  8020dc:	48 bf a3 49 80 00 00 	movabs $0x8049a3,%rdi
  8020e3:	00 00 00 
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	48 b9 1c 05 80 00 00 	movabs $0x80051c,%rcx
  8020f2:	00 00 00 
  8020f5:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8020f7:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  802103:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802107:	0f 85 60 ff ff ff    	jne    80206d <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  80210d:	c9                   	leaveq 
  80210e:	c3                   	retq   

000000000080210f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80210f:	55                   	push   %rbp
  802110:	48 89 e5             	mov    %rsp,%rbp
  802113:	48 83 ec 18          	sub    $0x18,%rsp
  802117:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80211a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802121:	eb 5e                	jmp    802181 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802123:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80212a:	00 00 00 
  80212d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802130:	48 63 d0             	movslq %eax,%rdx
  802133:	48 89 d0             	mov    %rdx,%rax
  802136:	48 c1 e0 03          	shl    $0x3,%rax
  80213a:	48 01 d0             	add    %rdx,%rax
  80213d:	48 c1 e0 05          	shl    $0x5,%rax
  802141:	48 01 c8             	add    %rcx,%rax
  802144:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80214a:	8b 00                	mov    (%rax),%eax
  80214c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80214f:	75 2c                	jne    80217d <ipc_find_env+0x6e>
			return envs[i].env_id;
  802151:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802158:	00 00 00 
  80215b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215e:	48 63 d0             	movslq %eax,%rdx
  802161:	48 89 d0             	mov    %rdx,%rax
  802164:	48 c1 e0 03          	shl    $0x3,%rax
  802168:	48 01 d0             	add    %rdx,%rax
  80216b:	48 c1 e0 05          	shl    $0x5,%rax
  80216f:	48 01 c8             	add    %rcx,%rax
  802172:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802178:	8b 40 08             	mov    0x8(%rax),%eax
  80217b:	eb 12                	jmp    80218f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80217d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802181:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802188:	7e 99                	jle    802123 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80218a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218f:	c9                   	leaveq 
  802190:	c3                   	retq   
  802191:	00 00                	add    %al,(%rax)
	...

0000000000802194 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802194:	55                   	push   %rbp
  802195:	48 89 e5             	mov    %rsp,%rbp
  802198:	48 83 ec 08          	sub    $0x8,%rsp
  80219c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021a4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021ab:	ff ff ff 
  8021ae:	48 01 d0             	add    %rdx,%rax
  8021b1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021b5:	c9                   	leaveq 
  8021b6:	c3                   	retq   

00000000008021b7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021b7:	55                   	push   %rbp
  8021b8:	48 89 e5             	mov    %rsp,%rbp
  8021bb:	48 83 ec 08          	sub    $0x8,%rsp
  8021bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c7:	48 89 c7             	mov    %rax,%rdi
  8021ca:	48 b8 94 21 80 00 00 	movabs $0x802194,%rax
  8021d1:	00 00 00 
  8021d4:	ff d0                	callq  *%rax
  8021d6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021dc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021e0:	c9                   	leaveq 
  8021e1:	c3                   	retq   

00000000008021e2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021e2:	55                   	push   %rbp
  8021e3:	48 89 e5             	mov    %rsp,%rbp
  8021e6:	48 83 ec 18          	sub    $0x18,%rsp
  8021ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f5:	eb 6b                	jmp    802262 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8021f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fa:	48 98                	cltq   
  8021fc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802202:	48 c1 e0 0c          	shl    $0xc,%rax
  802206:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80220a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220e:	48 89 c2             	mov    %rax,%rdx
  802211:	48 c1 ea 15          	shr    $0x15,%rdx
  802215:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80221c:	01 00 00 
  80221f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802223:	83 e0 01             	and    $0x1,%eax
  802226:	48 85 c0             	test   %rax,%rax
  802229:	74 21                	je     80224c <fd_alloc+0x6a>
  80222b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222f:	48 89 c2             	mov    %rax,%rdx
  802232:	48 c1 ea 0c          	shr    $0xc,%rdx
  802236:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80223d:	01 00 00 
  802240:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802244:	83 e0 01             	and    $0x1,%eax
  802247:	48 85 c0             	test   %rax,%rax
  80224a:	75 12                	jne    80225e <fd_alloc+0x7c>
			*fd_store = fd;
  80224c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802250:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802254:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
  80225c:	eb 1a                	jmp    802278 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80225e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802262:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802266:	7e 8f                	jle    8021f7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802273:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802278:	c9                   	leaveq 
  802279:	c3                   	retq   

000000000080227a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80227a:	55                   	push   %rbp
  80227b:	48 89 e5             	mov    %rsp,%rbp
  80227e:	48 83 ec 20          	sub    $0x20,%rsp
  802282:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802285:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802289:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80228d:	78 06                	js     802295 <fd_lookup+0x1b>
  80228f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802293:	7e 07                	jle    80229c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802295:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80229a:	eb 6c                	jmp    802308 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80229c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80229f:	48 98                	cltq   
  8022a1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022a7:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b3:	48 89 c2             	mov    %rax,%rdx
  8022b6:	48 c1 ea 15          	shr    $0x15,%rdx
  8022ba:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022c1:	01 00 00 
  8022c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c8:	83 e0 01             	and    $0x1,%eax
  8022cb:	48 85 c0             	test   %rax,%rax
  8022ce:	74 21                	je     8022f1 <fd_lookup+0x77>
  8022d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d4:	48 89 c2             	mov    %rax,%rdx
  8022d7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022e2:	01 00 00 
  8022e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e9:	83 e0 01             	and    $0x1,%eax
  8022ec:	48 85 c0             	test   %rax,%rax
  8022ef:	75 07                	jne    8022f8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022f6:	eb 10                	jmp    802308 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8022f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802300:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802308:	c9                   	leaveq 
  802309:	c3                   	retq   

000000000080230a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80230a:	55                   	push   %rbp
  80230b:	48 89 e5             	mov    %rsp,%rbp
  80230e:	48 83 ec 30          	sub    $0x30,%rsp
  802312:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802316:	89 f0                	mov    %esi,%eax
  802318:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80231b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80231f:	48 89 c7             	mov    %rax,%rdi
  802322:	48 b8 94 21 80 00 00 	movabs $0x802194,%rax
  802329:	00 00 00 
  80232c:	ff d0                	callq  *%rax
  80232e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802332:	48 89 d6             	mov    %rdx,%rsi
  802335:	89 c7                	mov    %eax,%edi
  802337:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  80233e:	00 00 00 
  802341:	ff d0                	callq  *%rax
  802343:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234a:	78 0a                	js     802356 <fd_close+0x4c>
	    || fd != fd2)
  80234c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802350:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802354:	74 12                	je     802368 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802356:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80235a:	74 05                	je     802361 <fd_close+0x57>
  80235c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235f:	eb 05                	jmp    802366 <fd_close+0x5c>
  802361:	b8 00 00 00 00       	mov    $0x0,%eax
  802366:	eb 69                	jmp    8023d1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802368:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80236c:	8b 00                	mov    (%rax),%eax
  80236e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802372:	48 89 d6             	mov    %rdx,%rsi
  802375:	89 c7                	mov    %eax,%edi
  802377:	48 b8 d3 23 80 00 00 	movabs $0x8023d3,%rax
  80237e:	00 00 00 
  802381:	ff d0                	callq  *%rax
  802383:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802386:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238a:	78 2a                	js     8023b6 <fd_close+0xac>
		if (dev->dev_close)
  80238c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802390:	48 8b 40 20          	mov    0x20(%rax),%rax
  802394:	48 85 c0             	test   %rax,%rax
  802397:	74 16                	je     8023af <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8023a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023a5:	48 89 c7             	mov    %rax,%rdi
  8023a8:	ff d2                	callq  *%rdx
  8023aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ad:	eb 07                	jmp    8023b6 <fd_close+0xac>
		else
			r = 0;
  8023af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ba:	48 89 c6             	mov    %rax,%rsi
  8023bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c2:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  8023c9:	00 00 00 
  8023cc:	ff d0                	callq  *%rax
	return r;
  8023ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023d1:	c9                   	leaveq 
  8023d2:	c3                   	retq   

00000000008023d3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023d3:	55                   	push   %rbp
  8023d4:	48 89 e5             	mov    %rsp,%rbp
  8023d7:	48 83 ec 20          	sub    $0x20,%rsp
  8023db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023e9:	eb 41                	jmp    80242c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8023eb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8023f2:	00 00 00 
  8023f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023f8:	48 63 d2             	movslq %edx,%rdx
  8023fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ff:	8b 00                	mov    (%rax),%eax
  802401:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802404:	75 22                	jne    802428 <dev_lookup+0x55>
			*dev = devtab[i];
  802406:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80240d:	00 00 00 
  802410:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802413:	48 63 d2             	movslq %edx,%rdx
  802416:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80241a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80241e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
  802426:	eb 60                	jmp    802488 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802428:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80242c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802433:	00 00 00 
  802436:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802439:	48 63 d2             	movslq %edx,%rdx
  80243c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802440:	48 85 c0             	test   %rax,%rax
  802443:	75 a6                	jne    8023eb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802445:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80244c:	00 00 00 
  80244f:	48 8b 00             	mov    (%rax),%rax
  802452:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802458:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80245b:	89 c6                	mov    %eax,%esi
  80245d:	48 bf b0 49 80 00 00 	movabs $0x8049b0,%rdi
  802464:	00 00 00 
  802467:	b8 00 00 00 00       	mov    $0x0,%eax
  80246c:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  802473:	00 00 00 
  802476:	ff d1                	callq  *%rcx
	*dev = 0;
  802478:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802483:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802488:	c9                   	leaveq 
  802489:	c3                   	retq   

000000000080248a <close>:

int
close(int fdnum)
{
  80248a:	55                   	push   %rbp
  80248b:	48 89 e5             	mov    %rsp,%rbp
  80248e:	48 83 ec 20          	sub    $0x20,%rsp
  802492:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802495:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802499:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249c:	48 89 d6             	mov    %rdx,%rsi
  80249f:	89 c7                	mov    %eax,%edi
  8024a1:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
  8024ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b4:	79 05                	jns    8024bb <close+0x31>
		return r;
  8024b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b9:	eb 18                	jmp    8024d3 <close+0x49>
	else
		return fd_close(fd, 1);
  8024bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bf:	be 01 00 00 00       	mov    $0x1,%esi
  8024c4:	48 89 c7             	mov    %rax,%rdi
  8024c7:	48 b8 0a 23 80 00 00 	movabs $0x80230a,%rax
  8024ce:	00 00 00 
  8024d1:	ff d0                	callq  *%rax
}
  8024d3:	c9                   	leaveq 
  8024d4:	c3                   	retq   

00000000008024d5 <close_all>:

void
close_all(void)
{
  8024d5:	55                   	push   %rbp
  8024d6:	48 89 e5             	mov    %rsp,%rbp
  8024d9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024e4:	eb 15                	jmp    8024fb <close_all+0x26>
		close(i);
  8024e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e9:	89 c7                	mov    %eax,%edi
  8024eb:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  8024f2:	00 00 00 
  8024f5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8024f7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024fb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024ff:	7e e5                	jle    8024e6 <close_all+0x11>
		close(i);
}
  802501:	c9                   	leaveq 
  802502:	c3                   	retq   

0000000000802503 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802503:	55                   	push   %rbp
  802504:	48 89 e5             	mov    %rsp,%rbp
  802507:	48 83 ec 40          	sub    $0x40,%rsp
  80250b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80250e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802511:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802515:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802518:	48 89 d6             	mov    %rdx,%rsi
  80251b:	89 c7                	mov    %eax,%edi
  80251d:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax
  802529:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802530:	79 08                	jns    80253a <dup+0x37>
		return r;
  802532:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802535:	e9 70 01 00 00       	jmpq   8026aa <dup+0x1a7>
	close(newfdnum);
  80253a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80253d:	89 c7                	mov    %eax,%edi
  80253f:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  802546:	00 00 00 
  802549:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80254b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80254e:	48 98                	cltq   
  802550:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802556:	48 c1 e0 0c          	shl    $0xc,%rax
  80255a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80255e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802562:	48 89 c7             	mov    %rax,%rdi
  802565:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  80256c:	00 00 00 
  80256f:	ff d0                	callq  *%rax
  802571:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802579:	48 89 c7             	mov    %rax,%rdi
  80257c:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  802583:	00 00 00 
  802586:	ff d0                	callq  *%rax
  802588:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80258c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802590:	48 89 c2             	mov    %rax,%rdx
  802593:	48 c1 ea 15          	shr    $0x15,%rdx
  802597:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80259e:	01 00 00 
  8025a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a5:	83 e0 01             	and    $0x1,%eax
  8025a8:	84 c0                	test   %al,%al
  8025aa:	74 71                	je     80261d <dup+0x11a>
  8025ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b0:	48 89 c2             	mov    %rax,%rdx
  8025b3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025be:	01 00 00 
  8025c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c5:	83 e0 01             	and    $0x1,%eax
  8025c8:	84 c0                	test   %al,%al
  8025ca:	74 51                	je     80261d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d0:	48 89 c2             	mov    %rax,%rdx
  8025d3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025de:	01 00 00 
  8025e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e5:	89 c1                	mov    %eax,%ecx
  8025e7:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8025ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f5:	41 89 c8             	mov    %ecx,%r8d
  8025f8:	48 89 d1             	mov    %rdx,%rcx
  8025fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802600:	48 89 c6             	mov    %rax,%rsi
  802603:	bf 00 00 00 00       	mov    $0x0,%edi
  802608:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  80260f:	00 00 00 
  802612:	ff d0                	callq  *%rax
  802614:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802617:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261b:	78 56                	js     802673 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80261d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802621:	48 89 c2             	mov    %rax,%rdx
  802624:	48 c1 ea 0c          	shr    $0xc,%rdx
  802628:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80262f:	01 00 00 
  802632:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802636:	89 c1                	mov    %eax,%ecx
  802638:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80263e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802642:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802646:	41 89 c8             	mov    %ecx,%r8d
  802649:	48 89 d1             	mov    %rdx,%rcx
  80264c:	ba 00 00 00 00       	mov    $0x0,%edx
  802651:	48 89 c6             	mov    %rax,%rsi
  802654:	bf 00 00 00 00       	mov    $0x0,%edi
  802659:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  802660:	00 00 00 
  802663:	ff d0                	callq  *%rax
  802665:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802668:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266c:	78 08                	js     802676 <dup+0x173>
		goto err;

	return newfdnum;
  80266e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802671:	eb 37                	jmp    8026aa <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802673:	90                   	nop
  802674:	eb 01                	jmp    802677 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802676:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267b:	48 89 c6             	mov    %rax,%rsi
  80267e:	bf 00 00 00 00       	mov    $0x0,%edi
  802683:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80268f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802693:	48 89 c6             	mov    %rax,%rsi
  802696:	bf 00 00 00 00       	mov    $0x0,%edi
  80269b:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  8026a2:	00 00 00 
  8026a5:	ff d0                	callq  *%rax
	return r;
  8026a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026aa:	c9                   	leaveq 
  8026ab:	c3                   	retq   

00000000008026ac <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026ac:	55                   	push   %rbp
  8026ad:	48 89 e5             	mov    %rsp,%rbp
  8026b0:	48 83 ec 40          	sub    $0x40,%rsp
  8026b4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026bb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026bf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026c3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026c6:	48 89 d6             	mov    %rdx,%rsi
  8026c9:	89 c7                	mov    %eax,%edi
  8026cb:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  8026d2:	00 00 00 
  8026d5:	ff d0                	callq  *%rax
  8026d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026de:	78 24                	js     802704 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e4:	8b 00                	mov    (%rax),%eax
  8026e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ea:	48 89 d6             	mov    %rdx,%rsi
  8026ed:	89 c7                	mov    %eax,%edi
  8026ef:	48 b8 d3 23 80 00 00 	movabs $0x8023d3,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	callq  *%rax
  8026fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802702:	79 05                	jns    802709 <read+0x5d>
		return r;
  802704:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802707:	eb 7a                	jmp    802783 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270d:	8b 40 08             	mov    0x8(%rax),%eax
  802710:	83 e0 03             	and    $0x3,%eax
  802713:	83 f8 01             	cmp    $0x1,%eax
  802716:	75 3a                	jne    802752 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802718:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80271f:	00 00 00 
  802722:	48 8b 00             	mov    (%rax),%rax
  802725:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80272b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80272e:	89 c6                	mov    %eax,%esi
  802730:	48 bf cf 49 80 00 00 	movabs $0x8049cf,%rdi
  802737:	00 00 00 
  80273a:	b8 00 00 00 00       	mov    $0x0,%eax
  80273f:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  802746:	00 00 00 
  802749:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80274b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802750:	eb 31                	jmp    802783 <read+0xd7>
	}
	if (!dev->dev_read)
  802752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802756:	48 8b 40 10          	mov    0x10(%rax),%rax
  80275a:	48 85 c0             	test   %rax,%rax
  80275d:	75 07                	jne    802766 <read+0xba>
		return -E_NOT_SUPP;
  80275f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802764:	eb 1d                	jmp    802783 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80276e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802772:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802776:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80277a:	48 89 ce             	mov    %rcx,%rsi
  80277d:	48 89 c7             	mov    %rax,%rdi
  802780:	41 ff d0             	callq  *%r8
}
  802783:	c9                   	leaveq 
  802784:	c3                   	retq   

0000000000802785 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802785:	55                   	push   %rbp
  802786:	48 89 e5             	mov    %rsp,%rbp
  802789:	48 83 ec 30          	sub    $0x30,%rsp
  80278d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802790:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802794:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802798:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80279f:	eb 46                	jmp    8027e7 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a4:	48 98                	cltq   
  8027a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027aa:	48 29 c2             	sub    %rax,%rdx
  8027ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b0:	48 98                	cltq   
  8027b2:	48 89 c1             	mov    %rax,%rcx
  8027b5:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8027b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027bc:	48 89 ce             	mov    %rcx,%rsi
  8027bf:	89 c7                	mov    %eax,%edi
  8027c1:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  8027c8:	00 00 00 
  8027cb:	ff d0                	callq  *%rax
  8027cd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027d4:	79 05                	jns    8027db <readn+0x56>
			return m;
  8027d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027d9:	eb 1d                	jmp    8027f8 <readn+0x73>
		if (m == 0)
  8027db:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027df:	74 13                	je     8027f4 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027e4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ea:	48 98                	cltq   
  8027ec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027f0:	72 af                	jb     8027a1 <readn+0x1c>
  8027f2:	eb 01                	jmp    8027f5 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8027f4:	90                   	nop
	}
	return tot;
  8027f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027f8:	c9                   	leaveq 
  8027f9:	c3                   	retq   

00000000008027fa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8027fa:	55                   	push   %rbp
  8027fb:	48 89 e5             	mov    %rsp,%rbp
  8027fe:	48 83 ec 40          	sub    $0x40,%rsp
  802802:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802805:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802809:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80280d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802811:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802814:	48 89 d6             	mov    %rdx,%rsi
  802817:	89 c7                	mov    %eax,%edi
  802819:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
  802825:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802828:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282c:	78 24                	js     802852 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80282e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802832:	8b 00                	mov    (%rax),%eax
  802834:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802838:	48 89 d6             	mov    %rdx,%rsi
  80283b:	89 c7                	mov    %eax,%edi
  80283d:	48 b8 d3 23 80 00 00 	movabs $0x8023d3,%rax
  802844:	00 00 00 
  802847:	ff d0                	callq  *%rax
  802849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802850:	79 05                	jns    802857 <write+0x5d>
		return r;
  802852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802855:	eb 79                	jmp    8028d0 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285b:	8b 40 08             	mov    0x8(%rax),%eax
  80285e:	83 e0 03             	and    $0x3,%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	75 3a                	jne    80289f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802865:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80286c:	00 00 00 
  80286f:	48 8b 00             	mov    (%rax),%rax
  802872:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802878:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80287b:	89 c6                	mov    %eax,%esi
  80287d:	48 bf eb 49 80 00 00 	movabs $0x8049eb,%rdi
  802884:	00 00 00 
  802887:	b8 00 00 00 00       	mov    $0x0,%eax
  80288c:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  802893:	00 00 00 
  802896:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802898:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80289d:	eb 31                	jmp    8028d0 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80289f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028a7:	48 85 c0             	test   %rax,%rax
  8028aa:	75 07                	jne    8028b3 <write+0xb9>
		return -E_NOT_SUPP;
  8028ac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028b1:	eb 1d                	jmp    8028d0 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8028b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b7:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8028bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028c3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028c7:	48 89 ce             	mov    %rcx,%rsi
  8028ca:	48 89 c7             	mov    %rax,%rdi
  8028cd:	41 ff d0             	callq  *%r8
}
  8028d0:	c9                   	leaveq 
  8028d1:	c3                   	retq   

00000000008028d2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028d2:	55                   	push   %rbp
  8028d3:	48 89 e5             	mov    %rsp,%rbp
  8028d6:	48 83 ec 18          	sub    $0x18,%rsp
  8028da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028dd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e7:	48 89 d6             	mov    %rdx,%rsi
  8028ea:	89 c7                	mov    %eax,%edi
  8028ec:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
  8028f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ff:	79 05                	jns    802906 <seek+0x34>
		return r;
  802901:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802904:	eb 0f                	jmp    802915 <seek+0x43>
	fd->fd_offset = offset;
  802906:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80290d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802910:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802915:	c9                   	leaveq 
  802916:	c3                   	retq   

0000000000802917 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802917:	55                   	push   %rbp
  802918:	48 89 e5             	mov    %rsp,%rbp
  80291b:	48 83 ec 30          	sub    $0x30,%rsp
  80291f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802922:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802925:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802929:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80292c:	48 89 d6             	mov    %rdx,%rsi
  80292f:	89 c7                	mov    %eax,%edi
  802931:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  802938:	00 00 00 
  80293b:	ff d0                	callq  *%rax
  80293d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802940:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802944:	78 24                	js     80296a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294a:	8b 00                	mov    (%rax),%eax
  80294c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802950:	48 89 d6             	mov    %rdx,%rsi
  802953:	89 c7                	mov    %eax,%edi
  802955:	48 b8 d3 23 80 00 00 	movabs $0x8023d3,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	callq  *%rax
  802961:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802964:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802968:	79 05                	jns    80296f <ftruncate+0x58>
		return r;
  80296a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296d:	eb 72                	jmp    8029e1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80296f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802973:	8b 40 08             	mov    0x8(%rax),%eax
  802976:	83 e0 03             	and    $0x3,%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	75 3a                	jne    8029b7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80297d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802984:	00 00 00 
  802987:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80298a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802990:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802993:	89 c6                	mov    %eax,%esi
  802995:	48 bf 08 4a 80 00 00 	movabs $0x804a08,%rdi
  80299c:	00 00 00 
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  8029ab:	00 00 00 
  8029ae:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8029b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b5:	eb 2a                	jmp    8029e1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029bf:	48 85 c0             	test   %rax,%rax
  8029c2:	75 07                	jne    8029cb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029c4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029c9:	eb 16                	jmp    8029e1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cf:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8029d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8029da:	89 d6                	mov    %edx,%esi
  8029dc:	48 89 c7             	mov    %rax,%rdi
  8029df:	ff d1                	callq  *%rcx
}
  8029e1:	c9                   	leaveq 
  8029e2:	c3                   	retq   

00000000008029e3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029e3:	55                   	push   %rbp
  8029e4:	48 89 e5             	mov    %rsp,%rbp
  8029e7:	48 83 ec 30          	sub    $0x30,%rsp
  8029eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f9:	48 89 d6             	mov    %rdx,%rsi
  8029fc:	89 c7                	mov    %eax,%edi
  8029fe:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  802a05:	00 00 00 
  802a08:	ff d0                	callq  *%rax
  802a0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a11:	78 24                	js     802a37 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a17:	8b 00                	mov    (%rax),%eax
  802a19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1d:	48 89 d6             	mov    %rdx,%rsi
  802a20:	89 c7                	mov    %eax,%edi
  802a22:	48 b8 d3 23 80 00 00 	movabs $0x8023d3,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
  802a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a35:	79 05                	jns    802a3c <fstat+0x59>
		return r;
  802a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3a:	eb 5e                	jmp    802a9a <fstat+0xb7>
	if (!dev->dev_stat)
  802a3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a40:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a44:	48 85 c0             	test   %rax,%rax
  802a47:	75 07                	jne    802a50 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a49:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a4e:	eb 4a                	jmp    802a9a <fstat+0xb7>
	stat->st_name[0] = 0;
  802a50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a54:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a62:	00 00 00 
	stat->st_isdir = 0;
  802a65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a69:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a70:	00 00 00 
	stat->st_dev = dev;
  802a73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a86:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802a8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802a92:	48 89 d6             	mov    %rdx,%rsi
  802a95:	48 89 c7             	mov    %rax,%rdi
  802a98:	ff d1                	callq  *%rcx
}
  802a9a:	c9                   	leaveq 
  802a9b:	c3                   	retq   

0000000000802a9c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a9c:	55                   	push   %rbp
  802a9d:	48 89 e5             	mov    %rsp,%rbp
  802aa0:	48 83 ec 20          	sub    $0x20,%rsp
  802aa4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aa8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab0:	be 00 00 00 00       	mov    $0x0,%esi
  802ab5:	48 89 c7             	mov    %rax,%rdi
  802ab8:	48 b8 8b 2b 80 00 00 	movabs $0x802b8b,%rax
  802abf:	00 00 00 
  802ac2:	ff d0                	callq  *%rax
  802ac4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acb:	79 05                	jns    802ad2 <stat+0x36>
		return fd;
  802acd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad0:	eb 2f                	jmp    802b01 <stat+0x65>
	r = fstat(fd, stat);
  802ad2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad9:	48 89 d6             	mov    %rdx,%rsi
  802adc:	89 c7                	mov    %eax,%edi
  802ade:	48 b8 e3 29 80 00 00 	movabs $0x8029e3,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
  802aea:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af0:	89 c7                	mov    %eax,%edi
  802af2:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  802af9:	00 00 00 
  802afc:	ff d0                	callq  *%rax
	return r;
  802afe:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b01:	c9                   	leaveq 
  802b02:	c3                   	retq   
	...

0000000000802b04 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b04:	55                   	push   %rbp
  802b05:	48 89 e5             	mov    %rsp,%rbp
  802b08:	48 83 ec 10          	sub    $0x10,%rsp
  802b0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b13:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802b1a:	00 00 00 
  802b1d:	8b 00                	mov    (%rax),%eax
  802b1f:	85 c0                	test   %eax,%eax
  802b21:	75 1d                	jne    802b40 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b23:	bf 01 00 00 00       	mov    $0x1,%edi
  802b28:	48 b8 0f 21 80 00 00 	movabs $0x80210f,%rax
  802b2f:	00 00 00 
  802b32:	ff d0                	callq  *%rax
  802b34:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  802b3b:	00 00 00 
  802b3e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b40:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802b47:	00 00 00 
  802b4a:	8b 00                	mov    (%rax),%eax
  802b4c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b4f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b54:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b5b:	00 00 00 
  802b5e:	89 c7                	mov    %eax,%edi
  802b60:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b70:	ba 00 00 00 00       	mov    $0x0,%edx
  802b75:	48 89 c6             	mov    %rax,%rsi
  802b78:	bf 00 00 00 00       	mov    $0x0,%edi
  802b7d:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  802b84:	00 00 00 
  802b87:	ff d0                	callq  *%rax
}
  802b89:	c9                   	leaveq 
  802b8a:	c3                   	retq   

0000000000802b8b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b8b:	55                   	push   %rbp
  802b8c:	48 89 e5             	mov    %rsp,%rbp
  802b8f:	48 83 ec 20          	sub    $0x20,%rsp
  802b93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b97:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9e:	48 89 c7             	mov    %rax,%rdi
  802ba1:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	callq  *%rax
  802bad:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bb2:	7e 0a                	jle    802bbe <open+0x33>
                return -E_BAD_PATH;
  802bb4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bb9:	e9 a5 00 00 00       	jmpq   802c63 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802bbe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802bc2:	48 89 c7             	mov    %rax,%rdi
  802bc5:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  802bcc:	00 00 00 
  802bcf:	ff d0                	callq  *%rax
  802bd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd8:	79 08                	jns    802be2 <open+0x57>
		return r;
  802bda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdd:	e9 81 00 00 00       	jmpq   802c63 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802be2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be6:	48 89 c6             	mov    %rax,%rsi
  802be9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bf0:	00 00 00 
  802bf3:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802bff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c06:	00 00 00 
  802c09:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802c0c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802c12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c16:	48 89 c6             	mov    %rax,%rsi
  802c19:	bf 01 00 00 00       	mov    $0x1,%edi
  802c1e:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802c25:	00 00 00 
  802c28:	ff d0                	callq  *%rax
  802c2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802c2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c31:	79 1d                	jns    802c50 <open+0xc5>
	{
		fd_close(fd,0);
  802c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c37:	be 00 00 00 00       	mov    $0x0,%esi
  802c3c:	48 89 c7             	mov    %rax,%rdi
  802c3f:	48 b8 0a 23 80 00 00 	movabs $0x80230a,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
		return r;
  802c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4e:	eb 13                	jmp    802c63 <open+0xd8>
	}
	return fd2num(fd);
  802c50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c54:	48 89 c7             	mov    %rax,%rdi
  802c57:	48 b8 94 21 80 00 00 	movabs $0x802194,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
	


}
  802c63:	c9                   	leaveq 
  802c64:	c3                   	retq   

0000000000802c65 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c65:	55                   	push   %rbp
  802c66:	48 89 e5             	mov    %rsp,%rbp
  802c69:	48 83 ec 10          	sub    $0x10,%rsp
  802c6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c75:	8b 50 0c             	mov    0xc(%rax),%edx
  802c78:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c7f:	00 00 00 
  802c82:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c84:	be 00 00 00 00       	mov    $0x0,%esi
  802c89:	bf 06 00 00 00       	mov    $0x6,%edi
  802c8e:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802c95:	00 00 00 
  802c98:	ff d0                	callq  *%rax
}
  802c9a:	c9                   	leaveq 
  802c9b:	c3                   	retq   

0000000000802c9c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c9c:	55                   	push   %rbp
  802c9d:	48 89 e5             	mov    %rsp,%rbp
  802ca0:	48 83 ec 30          	sub    $0x30,%rsp
  802ca4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802cb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb4:	8b 50 0c             	mov    0xc(%rax),%edx
  802cb7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cbe:	00 00 00 
  802cc1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802cc3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cca:	00 00 00 
  802ccd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cd1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802cd5:	be 00 00 00 00       	mov    $0x0,%esi
  802cda:	bf 03 00 00 00       	mov    $0x3,%edi
  802cdf:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
  802ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf2:	79 05                	jns    802cf9 <devfile_read+0x5d>
	{
		return r;
  802cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf7:	eb 2c                	jmp    802d25 <devfile_read+0x89>
	}
	if(r > 0)
  802cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfd:	7e 23                	jle    802d22 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d02:	48 63 d0             	movslq %eax,%rdx
  802d05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d09:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d10:	00 00 00 
  802d13:	48 89 c7             	mov    %rax,%rdi
  802d16:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
	return r;
  802d22:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802d25:	c9                   	leaveq 
  802d26:	c3                   	retq   

0000000000802d27 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d27:	55                   	push   %rbp
  802d28:	48 89 e5             	mov    %rsp,%rbp
  802d2b:	48 83 ec 30          	sub    $0x30,%rsp
  802d2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d37:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3f:	8b 50 0c             	mov    0xc(%rax),%edx
  802d42:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d49:	00 00 00 
  802d4c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802d4e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d55:	00 
  802d56:	76 08                	jbe    802d60 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802d58:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d5f:	00 
	fsipcbuf.write.req_n=n;
  802d60:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d67:	00 00 00 
  802d6a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d6e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802d72:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d7a:	48 89 c6             	mov    %rax,%rsi
  802d7d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d84:	00 00 00 
  802d87:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  802d8e:	00 00 00 
  802d91:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802d93:	be 00 00 00 00       	mov    $0x0,%esi
  802d98:	bf 04 00 00 00       	mov    $0x4,%edi
  802d9d:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
  802da9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802daf:	c9                   	leaveq 
  802db0:	c3                   	retq   

0000000000802db1 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802db1:	55                   	push   %rbp
  802db2:	48 89 e5             	mov    %rsp,%rbp
  802db5:	48 83 ec 10          	sub    $0x10,%rsp
  802db9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dbd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802dc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc4:	8b 50 0c             	mov    0xc(%rax),%edx
  802dc7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dce:	00 00 00 
  802dd1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802dd3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dda:	00 00 00 
  802ddd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802de0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802de3:	be 00 00 00 00       	mov    $0x0,%esi
  802de8:	bf 02 00 00 00       	mov    $0x2,%edi
  802ded:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
}
  802df9:	c9                   	leaveq 
  802dfa:	c3                   	retq   

0000000000802dfb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802dfb:	55                   	push   %rbp
  802dfc:	48 89 e5             	mov    %rsp,%rbp
  802dff:	48 83 ec 20          	sub    $0x20,%rsp
  802e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0f:	8b 50 0c             	mov    0xc(%rax),%edx
  802e12:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e19:	00 00 00 
  802e1c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e1e:	be 00 00 00 00       	mov    $0x0,%esi
  802e23:	bf 05 00 00 00       	mov    $0x5,%edi
  802e28:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
  802e34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3b:	79 05                	jns    802e42 <devfile_stat+0x47>
		return r;
  802e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e40:	eb 56                	jmp    802e98 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e46:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e4d:	00 00 00 
  802e50:	48 89 c7             	mov    %rax,%rdi
  802e53:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  802e5a:	00 00 00 
  802e5d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e5f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e66:	00 00 00 
  802e69:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e73:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e79:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e80:	00 00 00 
  802e83:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e8d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e98:	c9                   	leaveq 
  802e99:	c3                   	retq   
	...

0000000000802e9c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e9c:	55                   	push   %rbp
  802e9d:	48 89 e5             	mov    %rsp,%rbp
  802ea0:	48 83 ec 20          	sub    $0x20,%rsp
  802ea4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802ea7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802eab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eae:	48 89 d6             	mov    %rdx,%rsi
  802eb1:	89 c7                	mov    %eax,%edi
  802eb3:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
  802ebf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec6:	79 05                	jns    802ecd <fd2sockid+0x31>
		return r;
  802ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecb:	eb 24                	jmp    802ef1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed1:	8b 10                	mov    (%rax),%edx
  802ed3:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802eda:	00 00 00 
  802edd:	8b 00                	mov    (%rax),%eax
  802edf:	39 c2                	cmp    %eax,%edx
  802ee1:	74 07                	je     802eea <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802ee3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ee8:	eb 07                	jmp    802ef1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eee:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802ef1:	c9                   	leaveq 
  802ef2:	c3                   	retq   

0000000000802ef3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ef3:	55                   	push   %rbp
  802ef4:	48 89 e5             	mov    %rsp,%rbp
  802ef7:	48 83 ec 20          	sub    $0x20,%rsp
  802efb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802efe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f02:	48 89 c7             	mov    %rax,%rdi
  802f05:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
  802f11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f18:	78 26                	js     802f40 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802f1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1e:	ba 07 04 00 00       	mov    $0x407,%edx
  802f23:	48 89 c6             	mov    %rax,%rsi
  802f26:	bf 00 00 00 00       	mov    $0x0,%edi
  802f2b:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  802f32:	00 00 00 
  802f35:	ff d0                	callq  *%rax
  802f37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3e:	79 16                	jns    802f56 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f43:	89 c7                	mov    %eax,%edi
  802f45:	48 b8 00 34 80 00 00 	movabs $0x803400,%rax
  802f4c:	00 00 00 
  802f4f:	ff d0                	callq  *%rax
		return r;
  802f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f54:	eb 3a                	jmp    802f90 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802f61:	00 00 00 
  802f64:	8b 12                	mov    (%rdx),%edx
  802f66:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f77:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f7a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802f7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f81:	48 89 c7             	mov    %rax,%rdi
  802f84:	48 b8 94 21 80 00 00 	movabs $0x802194,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
}
  802f90:	c9                   	leaveq 
  802f91:	c3                   	retq   

0000000000802f92 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f92:	55                   	push   %rbp
  802f93:	48 89 e5             	mov    %rsp,%rbp
  802f96:	48 83 ec 30          	sub    $0x30,%rsp
  802f9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fa1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fa5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa8:	89 c7                	mov    %eax,%edi
  802faa:	48 b8 9c 2e 80 00 00 	movabs $0x802e9c,%rax
  802fb1:	00 00 00 
  802fb4:	ff d0                	callq  *%rax
  802fb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbd:	79 05                	jns    802fc4 <accept+0x32>
		return r;
  802fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc2:	eb 3b                	jmp    802fff <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802fc4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fc8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcf:	48 89 ce             	mov    %rcx,%rsi
  802fd2:	89 c7                	mov    %eax,%edi
  802fd4:	48 b8 dd 32 80 00 00 	movabs $0x8032dd,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
  802fe0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe7:	79 05                	jns    802fee <accept+0x5c>
		return r;
  802fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fec:	eb 11                	jmp    802fff <accept+0x6d>
	return alloc_sockfd(r);
  802fee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff1:	89 c7                	mov    %eax,%edi
  802ff3:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
}
  802fff:	c9                   	leaveq 
  803000:	c3                   	retq   

0000000000803001 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803001:	55                   	push   %rbp
  803002:	48 89 e5             	mov    %rsp,%rbp
  803005:	48 83 ec 20          	sub    $0x20,%rsp
  803009:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80300c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803010:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803013:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803016:	89 c7                	mov    %eax,%edi
  803018:	48 b8 9c 2e 80 00 00 	movabs $0x802e9c,%rax
  80301f:	00 00 00 
  803022:	ff d0                	callq  *%rax
  803024:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803027:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302b:	79 05                	jns    803032 <bind+0x31>
		return r;
  80302d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803030:	eb 1b                	jmp    80304d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803032:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803035:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803039:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303c:	48 89 ce             	mov    %rcx,%rsi
  80303f:	89 c7                	mov    %eax,%edi
  803041:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  803048:	00 00 00 
  80304b:	ff d0                	callq  *%rax
}
  80304d:	c9                   	leaveq 
  80304e:	c3                   	retq   

000000000080304f <shutdown>:

int
shutdown(int s, int how)
{
  80304f:	55                   	push   %rbp
  803050:	48 89 e5             	mov    %rsp,%rbp
  803053:	48 83 ec 20          	sub    $0x20,%rsp
  803057:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80305a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80305d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803060:	89 c7                	mov    %eax,%edi
  803062:	48 b8 9c 2e 80 00 00 	movabs $0x802e9c,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
  80306e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803075:	79 05                	jns    80307c <shutdown+0x2d>
		return r;
  803077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307a:	eb 16                	jmp    803092 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80307c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80307f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803082:	89 d6                	mov    %edx,%esi
  803084:	89 c7                	mov    %eax,%edi
  803086:	48 b8 c0 33 80 00 00 	movabs $0x8033c0,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
}
  803092:	c9                   	leaveq 
  803093:	c3                   	retq   

0000000000803094 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803094:	55                   	push   %rbp
  803095:	48 89 e5             	mov    %rsp,%rbp
  803098:	48 83 ec 10          	sub    $0x10,%rsp
  80309c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8030a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a4:	48 89 c7             	mov    %rax,%rdi
  8030a7:	48 b8 24 3f 80 00 00 	movabs $0x803f24,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
  8030b3:	83 f8 01             	cmp    $0x1,%eax
  8030b6:	75 17                	jne    8030cf <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8030b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030bc:	8b 40 0c             	mov    0xc(%rax),%eax
  8030bf:	89 c7                	mov    %eax,%edi
  8030c1:	48 b8 00 34 80 00 00 	movabs $0x803400,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	callq  *%rax
  8030cd:	eb 05                	jmp    8030d4 <devsock_close+0x40>
	else
		return 0;
  8030cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030d4:	c9                   	leaveq 
  8030d5:	c3                   	retq   

00000000008030d6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030d6:	55                   	push   %rbp
  8030d7:	48 89 e5             	mov    %rsp,%rbp
  8030da:	48 83 ec 20          	sub    $0x20,%rsp
  8030de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030e5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030eb:	89 c7                	mov    %eax,%edi
  8030ed:	48 b8 9c 2e 80 00 00 	movabs $0x802e9c,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
  8030f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803100:	79 05                	jns    803107 <connect+0x31>
		return r;
  803102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803105:	eb 1b                	jmp    803122 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803107:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80310a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80310e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803111:	48 89 ce             	mov    %rcx,%rsi
  803114:	89 c7                	mov    %eax,%edi
  803116:	48 b8 2d 34 80 00 00 	movabs $0x80342d,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
}
  803122:	c9                   	leaveq 
  803123:	c3                   	retq   

0000000000803124 <listen>:

int
listen(int s, int backlog)
{
  803124:	55                   	push   %rbp
  803125:	48 89 e5             	mov    %rsp,%rbp
  803128:	48 83 ec 20          	sub    $0x20,%rsp
  80312c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80312f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803132:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803135:	89 c7                	mov    %eax,%edi
  803137:	48 b8 9c 2e 80 00 00 	movabs $0x802e9c,%rax
  80313e:	00 00 00 
  803141:	ff d0                	callq  *%rax
  803143:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314a:	79 05                	jns    803151 <listen+0x2d>
		return r;
  80314c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314f:	eb 16                	jmp    803167 <listen+0x43>
	return nsipc_listen(r, backlog);
  803151:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803157:	89 d6                	mov    %edx,%esi
  803159:	89 c7                	mov    %eax,%edi
  80315b:	48 b8 91 34 80 00 00 	movabs $0x803491,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
}
  803167:	c9                   	leaveq 
  803168:	c3                   	retq   

0000000000803169 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803169:	55                   	push   %rbp
  80316a:	48 89 e5             	mov    %rsp,%rbp
  80316d:	48 83 ec 20          	sub    $0x20,%rsp
  803171:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803175:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803179:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80317d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803181:	89 c2                	mov    %eax,%edx
  803183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803187:	8b 40 0c             	mov    0xc(%rax),%eax
  80318a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80318e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803193:	89 c7                	mov    %eax,%edi
  803195:	48 b8 d1 34 80 00 00 	movabs $0x8034d1,%rax
  80319c:	00 00 00 
  80319f:	ff d0                	callq  *%rax
}
  8031a1:	c9                   	leaveq 
  8031a2:	c3                   	retq   

00000000008031a3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8031a3:	55                   	push   %rbp
  8031a4:	48 89 e5             	mov    %rsp,%rbp
  8031a7:	48 83 ec 20          	sub    $0x20,%rsp
  8031ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8031b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031bb:	89 c2                	mov    %eax,%edx
  8031bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c1:	8b 40 0c             	mov    0xc(%rax),%eax
  8031c4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031cd:	89 c7                	mov    %eax,%edi
  8031cf:	48 b8 9d 35 80 00 00 	movabs $0x80359d,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	callq  *%rax
}
  8031db:	c9                   	leaveq 
  8031dc:	c3                   	retq   

00000000008031dd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8031dd:	55                   	push   %rbp
  8031de:	48 89 e5             	mov    %rsp,%rbp
  8031e1:	48 83 ec 10          	sub    $0x10,%rsp
  8031e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8031ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f1:	48 be 33 4a 80 00 00 	movabs $0x804a33,%rsi
  8031f8:	00 00 00 
  8031fb:	48 89 c7             	mov    %rax,%rdi
  8031fe:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  803205:	00 00 00 
  803208:	ff d0                	callq  *%rax
	return 0;
  80320a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80320f:	c9                   	leaveq 
  803210:	c3                   	retq   

0000000000803211 <socket>:

int
socket(int domain, int type, int protocol)
{
  803211:	55                   	push   %rbp
  803212:	48 89 e5             	mov    %rsp,%rbp
  803215:	48 83 ec 20          	sub    $0x20,%rsp
  803219:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80321c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80321f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803222:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803225:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80322b:	89 ce                	mov    %ecx,%esi
  80322d:	89 c7                	mov    %eax,%edi
  80322f:	48 b8 55 36 80 00 00 	movabs $0x803655,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
  80323b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803242:	79 05                	jns    803249 <socket+0x38>
		return r;
  803244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803247:	eb 11                	jmp    80325a <socket+0x49>
	return alloc_sockfd(r);
  803249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324c:	89 c7                	mov    %eax,%edi
  80324e:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  803255:	00 00 00 
  803258:	ff d0                	callq  *%rax
}
  80325a:	c9                   	leaveq 
  80325b:	c3                   	retq   

000000000080325c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80325c:	55                   	push   %rbp
  80325d:	48 89 e5             	mov    %rsp,%rbp
  803260:	48 83 ec 10          	sub    $0x10,%rsp
  803264:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803267:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80326e:	00 00 00 
  803271:	8b 00                	mov    (%rax),%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	75 1d                	jne    803294 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803277:	bf 02 00 00 00       	mov    $0x2,%edi
  80327c:	48 b8 0f 21 80 00 00 	movabs $0x80210f,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
  803288:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  80328f:	00 00 00 
  803292:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803294:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80329b:	00 00 00 
  80329e:	8b 00                	mov    (%rax),%eax
  8032a0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032a3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032a8:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8032af:	00 00 00 
  8032b2:	89 c7                	mov    %eax,%edi
  8032b4:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  8032bb:	00 00 00 
  8032be:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8032c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8032c5:	be 00 00 00 00       	mov    $0x0,%esi
  8032ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8032cf:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
}
  8032db:	c9                   	leaveq 
  8032dc:	c3                   	retq   

00000000008032dd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032dd:	55                   	push   %rbp
  8032de:	48 89 e5             	mov    %rsp,%rbp
  8032e1:	48 83 ec 30          	sub    $0x30,%rsp
  8032e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8032f0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032f7:	00 00 00 
  8032fa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032fd:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032ff:	bf 01 00 00 00       	mov    $0x1,%edi
  803304:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  80330b:	00 00 00 
  80330e:	ff d0                	callq  *%rax
  803310:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803313:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803317:	78 3e                	js     803357 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803319:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803320:	00 00 00 
  803323:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332b:	8b 40 10             	mov    0x10(%rax),%eax
  80332e:	89 c2                	mov    %eax,%edx
  803330:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803334:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803338:	48 89 ce             	mov    %rcx,%rsi
  80333b:	48 89 c7             	mov    %rax,%rdi
  80333e:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80334a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80334e:	8b 50 10             	mov    0x10(%rax),%edx
  803351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803355:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803357:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80335a:	c9                   	leaveq 
  80335b:	c3                   	retq   

000000000080335c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80335c:	55                   	push   %rbp
  80335d:	48 89 e5             	mov    %rsp,%rbp
  803360:	48 83 ec 10          	sub    $0x10,%rsp
  803364:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803367:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80336b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80336e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803375:	00 00 00 
  803378:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80337b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80337d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803384:	48 89 c6             	mov    %rax,%rsi
  803387:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80338e:	00 00 00 
  803391:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  803398:	00 00 00 
  80339b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80339d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033a4:	00 00 00 
  8033a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033aa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8033ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8033b2:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  8033b9:	00 00 00 
  8033bc:	ff d0                	callq  *%rax
}
  8033be:	c9                   	leaveq 
  8033bf:	c3                   	retq   

00000000008033c0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8033c0:	55                   	push   %rbp
  8033c1:	48 89 e5             	mov    %rsp,%rbp
  8033c4:	48 83 ec 10          	sub    $0x10,%rsp
  8033c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033cb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8033ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033d5:	00 00 00 
  8033d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033db:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8033dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033e4:	00 00 00 
  8033e7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033ea:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8033ed:	bf 03 00 00 00       	mov    $0x3,%edi
  8033f2:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
}
  8033fe:	c9                   	leaveq 
  8033ff:	c3                   	retq   

0000000000803400 <nsipc_close>:

int
nsipc_close(int s)
{
  803400:	55                   	push   %rbp
  803401:	48 89 e5             	mov    %rsp,%rbp
  803404:	48 83 ec 10          	sub    $0x10,%rsp
  803408:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80340b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803412:	00 00 00 
  803415:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803418:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80341a:	bf 04 00 00 00       	mov    $0x4,%edi
  80341f:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  803426:	00 00 00 
  803429:	ff d0                	callq  *%rax
}
  80342b:	c9                   	leaveq 
  80342c:	c3                   	retq   

000000000080342d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80342d:	55                   	push   %rbp
  80342e:	48 89 e5             	mov    %rsp,%rbp
  803431:	48 83 ec 10          	sub    $0x10,%rsp
  803435:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803438:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80343c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80343f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803446:	00 00 00 
  803449:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80344c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80344e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803451:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803455:	48 89 c6             	mov    %rax,%rsi
  803458:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80345f:	00 00 00 
  803462:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  803469:	00 00 00 
  80346c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80346e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803475:	00 00 00 
  803478:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80347b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80347e:	bf 05 00 00 00       	mov    $0x5,%edi
  803483:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  80348a:	00 00 00 
  80348d:	ff d0                	callq  *%rax
}
  80348f:	c9                   	leaveq 
  803490:	c3                   	retq   

0000000000803491 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803491:	55                   	push   %rbp
  803492:	48 89 e5             	mov    %rsp,%rbp
  803495:	48 83 ec 10          	sub    $0x10,%rsp
  803499:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80349c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80349f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a6:	00 00 00 
  8034a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034ac:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8034ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034b5:	00 00 00 
  8034b8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034bb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8034be:	bf 06 00 00 00       	mov    $0x6,%edi
  8034c3:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  8034ca:	00 00 00 
  8034cd:	ff d0                	callq  *%rax
}
  8034cf:	c9                   	leaveq 
  8034d0:	c3                   	retq   

00000000008034d1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8034d1:	55                   	push   %rbp
  8034d2:	48 89 e5             	mov    %rsp,%rbp
  8034d5:	48 83 ec 30          	sub    $0x30,%rsp
  8034d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034e0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8034e3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8034e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ed:	00 00 00 
  8034f0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034f3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8034f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fc:	00 00 00 
  8034ff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803502:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803505:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80350c:	00 00 00 
  80350f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803512:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803515:	bf 07 00 00 00       	mov    $0x7,%edi
  80351a:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  803521:	00 00 00 
  803524:	ff d0                	callq  *%rax
  803526:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803529:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80352d:	78 69                	js     803598 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80352f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803536:	7f 08                	jg     803540 <nsipc_recv+0x6f>
  803538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80353e:	7e 35                	jle    803575 <nsipc_recv+0xa4>
  803540:	48 b9 3a 4a 80 00 00 	movabs $0x804a3a,%rcx
  803547:	00 00 00 
  80354a:	48 ba 4f 4a 80 00 00 	movabs $0x804a4f,%rdx
  803551:	00 00 00 
  803554:	be 61 00 00 00       	mov    $0x61,%esi
  803559:	48 bf 64 4a 80 00 00 	movabs $0x804a64,%rdi
  803560:	00 00 00 
  803563:	b8 00 00 00 00       	mov    $0x0,%eax
  803568:	49 b8 1c 05 80 00 00 	movabs $0x80051c,%r8
  80356f:	00 00 00 
  803572:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803575:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803578:	48 63 d0             	movslq %eax,%rdx
  80357b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80357f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803586:	00 00 00 
  803589:	48 89 c7             	mov    %rax,%rdi
  80358c:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  803593:	00 00 00 
  803596:	ff d0                	callq  *%rax
	}

	return r;
  803598:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80359b:	c9                   	leaveq 
  80359c:	c3                   	retq   

000000000080359d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80359d:	55                   	push   %rbp
  80359e:	48 89 e5             	mov    %rsp,%rbp
  8035a1:	48 83 ec 20          	sub    $0x20,%rsp
  8035a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8035af:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8035b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035b9:	00 00 00 
  8035bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035bf:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8035c1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8035c8:	7e 35                	jle    8035ff <nsipc_send+0x62>
  8035ca:	48 b9 70 4a 80 00 00 	movabs $0x804a70,%rcx
  8035d1:	00 00 00 
  8035d4:	48 ba 4f 4a 80 00 00 	movabs $0x804a4f,%rdx
  8035db:	00 00 00 
  8035de:	be 6c 00 00 00       	mov    $0x6c,%esi
  8035e3:	48 bf 64 4a 80 00 00 	movabs $0x804a64,%rdi
  8035ea:	00 00 00 
  8035ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f2:	49 b8 1c 05 80 00 00 	movabs $0x80051c,%r8
  8035f9:	00 00 00 
  8035fc:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8035ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803602:	48 63 d0             	movslq %eax,%rdx
  803605:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803609:	48 89 c6             	mov    %rax,%rsi
  80360c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803613:	00 00 00 
  803616:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  80361d:	00 00 00 
  803620:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803622:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803629:	00 00 00 
  80362c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80362f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803632:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803639:	00 00 00 
  80363c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80363f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803642:	bf 08 00 00 00       	mov    $0x8,%edi
  803647:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
}
  803653:	c9                   	leaveq 
  803654:	c3                   	retq   

0000000000803655 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803655:	55                   	push   %rbp
  803656:	48 89 e5             	mov    %rsp,%rbp
  803659:	48 83 ec 10          	sub    $0x10,%rsp
  80365d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803660:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803663:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803666:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80366d:	00 00 00 
  803670:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803673:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803675:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80367c:	00 00 00 
  80367f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803682:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803685:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80368c:	00 00 00 
  80368f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803692:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803695:	bf 09 00 00 00       	mov    $0x9,%edi
  80369a:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  8036a1:	00 00 00 
  8036a4:	ff d0                	callq  *%rax
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	53                   	push   %rbx
  8036ad:	48 83 ec 38          	sub    $0x38,%rsp
  8036b1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8036b5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8036b9:	48 89 c7             	mov    %rax,%rdi
  8036bc:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  8036c3:	00 00 00 
  8036c6:	ff d0                	callq  *%rax
  8036c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036cf:	0f 88 bf 01 00 00    	js     803894 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d9:	ba 07 04 00 00       	mov    $0x407,%edx
  8036de:	48 89 c6             	mov    %rax,%rsi
  8036e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e6:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  8036ed:	00 00 00 
  8036f0:	ff d0                	callq  *%rax
  8036f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036f9:	0f 88 95 01 00 00    	js     803894 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036ff:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803703:	48 89 c7             	mov    %rax,%rdi
  803706:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  80370d:	00 00 00 
  803710:	ff d0                	callq  *%rax
  803712:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803715:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803719:	0f 88 5d 01 00 00    	js     80387c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80371f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803723:	ba 07 04 00 00       	mov    $0x407,%edx
  803728:	48 89 c6             	mov    %rax,%rsi
  80372b:	bf 00 00 00 00       	mov    $0x0,%edi
  803730:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  803737:	00 00 00 
  80373a:	ff d0                	callq  *%rax
  80373c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80373f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803743:	0f 88 33 01 00 00    	js     80387c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80374d:	48 89 c7             	mov    %rax,%rdi
  803750:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
  80375c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803760:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803764:	ba 07 04 00 00       	mov    $0x407,%edx
  803769:	48 89 c6             	mov    %rax,%rsi
  80376c:	bf 00 00 00 00       	mov    $0x0,%edi
  803771:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
  80377d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803780:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803784:	0f 88 d9 00 00 00    	js     803863 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80378a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80378e:	48 89 c7             	mov    %rax,%rdi
  803791:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
  80379d:	48 89 c2             	mov    %rax,%rdx
  8037a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8037aa:	48 89 d1             	mov    %rdx,%rcx
  8037ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8037b2:	48 89 c6             	mov    %rax,%rsi
  8037b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ba:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
  8037c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037cd:	78 79                	js     803848 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d3:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037da:	00 00 00 
  8037dd:	8b 12                	mov    (%rdx),%edx
  8037df:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037f7:	00 00 00 
  8037fa:	8b 12                	mov    (%rdx),%edx
  8037fc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803802:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380d:	48 89 c7             	mov    %rax,%rdi
  803810:	48 b8 94 21 80 00 00 	movabs $0x802194,%rax
  803817:	00 00 00 
  80381a:	ff d0                	callq  *%rax
  80381c:	89 c2                	mov    %eax,%edx
  80381e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803822:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803824:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803828:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80382c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803830:	48 89 c7             	mov    %rax,%rdi
  803833:	48 b8 94 21 80 00 00 	movabs $0x802194,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
  80383f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803841:	b8 00 00 00 00       	mov    $0x0,%eax
  803846:	eb 4f                	jmp    803897 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803848:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803849:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80384d:	48 89 c6             	mov    %rax,%rsi
  803850:	bf 00 00 00 00       	mov    $0x0,%edi
  803855:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  80385c:	00 00 00 
  80385f:	ff d0                	callq  *%rax
  803861:	eb 01                	jmp    803864 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803863:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803864:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803868:	48 89 c6             	mov    %rax,%rsi
  80386b:	bf 00 00 00 00       	mov    $0x0,%edi
  803870:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  803877:	00 00 00 
  80387a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80387c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803880:	48 89 c6             	mov    %rax,%rsi
  803883:	bf 00 00 00 00       	mov    $0x0,%edi
  803888:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
    err:
	return r;
  803894:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803897:	48 83 c4 38          	add    $0x38,%rsp
  80389b:	5b                   	pop    %rbx
  80389c:	5d                   	pop    %rbp
  80389d:	c3                   	retq   

000000000080389e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80389e:	55                   	push   %rbp
  80389f:	48 89 e5             	mov    %rsp,%rbp
  8038a2:	53                   	push   %rbx
  8038a3:	48 83 ec 28          	sub    $0x28,%rsp
  8038a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038af:	eb 01                	jmp    8038b2 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8038b1:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8038b2:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8038b9:	00 00 00 
  8038bc:	48 8b 00             	mov    (%rax),%rax
  8038bf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038cc:	48 89 c7             	mov    %rax,%rdi
  8038cf:	48 b8 24 3f 80 00 00 	movabs $0x803f24,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
  8038db:	89 c3                	mov    %eax,%ebx
  8038dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038e1:	48 89 c7             	mov    %rax,%rdi
  8038e4:	48 b8 24 3f 80 00 00 	movabs $0x803f24,%rax
  8038eb:	00 00 00 
  8038ee:	ff d0                	callq  *%rax
  8038f0:	39 c3                	cmp    %eax,%ebx
  8038f2:	0f 94 c0             	sete   %al
  8038f5:	0f b6 c0             	movzbl %al,%eax
  8038f8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038fb:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803902:	00 00 00 
  803905:	48 8b 00             	mov    (%rax),%rax
  803908:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80390e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803911:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803914:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803917:	75 0a                	jne    803923 <_pipeisclosed+0x85>
			return ret;
  803919:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80391c:	48 83 c4 28          	add    $0x28,%rsp
  803920:	5b                   	pop    %rbx
  803921:	5d                   	pop    %rbp
  803922:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803923:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803926:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803929:	74 86                	je     8038b1 <_pipeisclosed+0x13>
  80392b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80392f:	75 80                	jne    8038b1 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803931:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803938:	00 00 00 
  80393b:	48 8b 00             	mov    (%rax),%rax
  80393e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803944:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803947:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80394a:	89 c6                	mov    %eax,%esi
  80394c:	48 bf 81 4a 80 00 00 	movabs $0x804a81,%rdi
  803953:	00 00 00 
  803956:	b8 00 00 00 00       	mov    $0x0,%eax
  80395b:	49 b8 57 07 80 00 00 	movabs $0x800757,%r8
  803962:	00 00 00 
  803965:	41 ff d0             	callq  *%r8
	}
  803968:	e9 44 ff ff ff       	jmpq   8038b1 <_pipeisclosed+0x13>

000000000080396d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  80396d:	55                   	push   %rbp
  80396e:	48 89 e5             	mov    %rsp,%rbp
  803971:	48 83 ec 30          	sub    $0x30,%rsp
  803975:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803978:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80397c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80397f:	48 89 d6             	mov    %rdx,%rsi
  803982:	89 c7                	mov    %eax,%edi
  803984:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  80398b:	00 00 00 
  80398e:	ff d0                	callq  *%rax
  803990:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803993:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803997:	79 05                	jns    80399e <pipeisclosed+0x31>
		return r;
  803999:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399c:	eb 31                	jmp    8039cf <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80399e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039a2:	48 89 c7             	mov    %rax,%rdi
  8039a5:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  8039ac:	00 00 00 
  8039af:	ff d0                	callq  *%rax
  8039b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8039b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039bd:	48 89 d6             	mov    %rdx,%rsi
  8039c0:	48 89 c7             	mov    %rax,%rdi
  8039c3:	48 b8 9e 38 80 00 00 	movabs $0x80389e,%rax
  8039ca:	00 00 00 
  8039cd:	ff d0                	callq  *%rax
}
  8039cf:	c9                   	leaveq 
  8039d0:	c3                   	retq   

00000000008039d1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039d1:	55                   	push   %rbp
  8039d2:	48 89 e5             	mov    %rsp,%rbp
  8039d5:	48 83 ec 40          	sub    $0x40,%rsp
  8039d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039e1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e9:	48 89 c7             	mov    %rax,%rdi
  8039ec:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  8039f3:	00 00 00 
  8039f6:	ff d0                	callq  *%rax
  8039f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a04:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a0b:	00 
  803a0c:	e9 97 00 00 00       	jmpq   803aa8 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a11:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a16:	74 09                	je     803a21 <devpipe_read+0x50>
				return i;
  803a18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a1c:	e9 95 00 00 00       	jmpq   803ab6 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a29:	48 89 d6             	mov    %rdx,%rsi
  803a2c:	48 89 c7             	mov    %rax,%rdi
  803a2f:	48 b8 9e 38 80 00 00 	movabs $0x80389e,%rax
  803a36:	00 00 00 
  803a39:	ff d0                	callq  *%rax
  803a3b:	85 c0                	test   %eax,%eax
  803a3d:	74 07                	je     803a46 <devpipe_read+0x75>
				return 0;
  803a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a44:	eb 70                	jmp    803ab6 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a46:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
  803a52:	eb 01                	jmp    803a55 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a54:	90                   	nop
  803a55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a59:	8b 10                	mov    (%rax),%edx
  803a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5f:	8b 40 04             	mov    0x4(%rax),%eax
  803a62:	39 c2                	cmp    %eax,%edx
  803a64:	74 ab                	je     803a11 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a6e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a76:	8b 00                	mov    (%rax),%eax
  803a78:	89 c2                	mov    %eax,%edx
  803a7a:	c1 fa 1f             	sar    $0x1f,%edx
  803a7d:	c1 ea 1b             	shr    $0x1b,%edx
  803a80:	01 d0                	add    %edx,%eax
  803a82:	83 e0 1f             	and    $0x1f,%eax
  803a85:	29 d0                	sub    %edx,%eax
  803a87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a8b:	48 98                	cltq   
  803a8d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a92:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a98:	8b 00                	mov    (%rax),%eax
  803a9a:	8d 50 01             	lea    0x1(%rax),%edx
  803a9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803aa3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803aa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aac:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ab0:	72 a2                	jb     803a54 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ab2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ab6:	c9                   	leaveq 
  803ab7:	c3                   	retq   

0000000000803ab8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ab8:	55                   	push   %rbp
  803ab9:	48 89 e5             	mov    %rsp,%rbp
  803abc:	48 83 ec 40          	sub    $0x40,%rsp
  803ac0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ac4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ac8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803acc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad0:	48 89 c7             	mov    %rax,%rdi
  803ad3:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  803ada:	00 00 00 
  803add:	ff d0                	callq  *%rax
  803adf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ae3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803aeb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803af2:	00 
  803af3:	e9 93 00 00 00       	jmpq   803b8b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803af8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803afc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b00:	48 89 d6             	mov    %rdx,%rsi
  803b03:	48 89 c7             	mov    %rax,%rdi
  803b06:	48 b8 9e 38 80 00 00 	movabs $0x80389e,%rax
  803b0d:	00 00 00 
  803b10:	ff d0                	callq  *%rax
  803b12:	85 c0                	test   %eax,%eax
  803b14:	74 07                	je     803b1d <devpipe_write+0x65>
				return 0;
  803b16:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1b:	eb 7c                	jmp    803b99 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b1d:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  803b24:	00 00 00 
  803b27:	ff d0                	callq  *%rax
  803b29:	eb 01                	jmp    803b2c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b2b:	90                   	nop
  803b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b30:	8b 40 04             	mov    0x4(%rax),%eax
  803b33:	48 63 d0             	movslq %eax,%rdx
  803b36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3a:	8b 00                	mov    (%rax),%eax
  803b3c:	48 98                	cltq   
  803b3e:	48 83 c0 20          	add    $0x20,%rax
  803b42:	48 39 c2             	cmp    %rax,%rdx
  803b45:	73 b1                	jae    803af8 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4b:	8b 40 04             	mov    0x4(%rax),%eax
  803b4e:	89 c2                	mov    %eax,%edx
  803b50:	c1 fa 1f             	sar    $0x1f,%edx
  803b53:	c1 ea 1b             	shr    $0x1b,%edx
  803b56:	01 d0                	add    %edx,%eax
  803b58:	83 e0 1f             	and    $0x1f,%eax
  803b5b:	29 d0                	sub    %edx,%eax
  803b5d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b65:	48 01 ca             	add    %rcx,%rdx
  803b68:	0f b6 0a             	movzbl (%rdx),%ecx
  803b6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b6f:	48 98                	cltq   
  803b71:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b79:	8b 40 04             	mov    0x4(%rax),%eax
  803b7c:	8d 50 01             	lea    0x1(%rax),%edx
  803b7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b83:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b86:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b8f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b93:	72 96                	jb     803b2b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b99:	c9                   	leaveq 
  803b9a:	c3                   	retq   

0000000000803b9b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b9b:	55                   	push   %rbp
  803b9c:	48 89 e5             	mov    %rsp,%rbp
  803b9f:	48 83 ec 20          	sub    $0x20,%rsp
  803ba3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ba7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803bab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803baf:	48 89 c7             	mov    %rax,%rdi
  803bb2:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  803bb9:	00 00 00 
  803bbc:	ff d0                	callq  *%rax
  803bbe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803bc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bc6:	48 be 94 4a 80 00 00 	movabs $0x804a94,%rsi
  803bcd:	00 00 00 
  803bd0:	48 89 c7             	mov    %rax,%rdi
  803bd3:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  803bda:	00 00 00 
  803bdd:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be3:	8b 50 04             	mov    0x4(%rax),%edx
  803be6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bea:	8b 00                	mov    (%rax),%eax
  803bec:	29 c2                	sub    %eax,%edx
  803bee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bf8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bfc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c03:	00 00 00 
	stat->st_dev = &devpipe;
  803c06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c0a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c11:	00 00 00 
  803c14:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c20:	c9                   	leaveq 
  803c21:	c3                   	retq   

0000000000803c22 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c22:	55                   	push   %rbp
  803c23:	48 89 e5             	mov    %rsp,%rbp
  803c26:	48 83 ec 10          	sub    $0x10,%rsp
  803c2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c32:	48 89 c6             	mov    %rax,%rsi
  803c35:	bf 00 00 00 00       	mov    $0x0,%edi
  803c3a:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  803c41:	00 00 00 
  803c44:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c4a:	48 89 c7             	mov    %rax,%rdi
  803c4d:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  803c54:	00 00 00 
  803c57:	ff d0                	callq  *%rax
  803c59:	48 89 c6             	mov    %rax,%rsi
  803c5c:	bf 00 00 00 00       	mov    $0x0,%edi
  803c61:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  803c68:	00 00 00 
  803c6b:	ff d0                	callq  *%rax
}
  803c6d:	c9                   	leaveq 
  803c6e:	c3                   	retq   
	...

0000000000803c70 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c70:	55                   	push   %rbp
  803c71:	48 89 e5             	mov    %rsp,%rbp
  803c74:	48 83 ec 20          	sub    $0x20,%rsp
  803c78:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c7e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c81:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c85:	be 01 00 00 00       	mov    $0x1,%esi
  803c8a:	48 89 c7             	mov    %rax,%rdi
  803c8d:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803c94:	00 00 00 
  803c97:	ff d0                	callq  *%rax
}
  803c99:	c9                   	leaveq 
  803c9a:	c3                   	retq   

0000000000803c9b <getchar>:

int
getchar(void)
{
  803c9b:	55                   	push   %rbp
  803c9c:	48 89 e5             	mov    %rsp,%rbp
  803c9f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ca3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ca7:	ba 01 00 00 00       	mov    $0x1,%edx
  803cac:	48 89 c6             	mov    %rax,%rsi
  803caf:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb4:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  803cbb:	00 00 00 
  803cbe:	ff d0                	callq  *%rax
  803cc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803cc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc7:	79 05                	jns    803cce <getchar+0x33>
		return r;
  803cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccc:	eb 14                	jmp    803ce2 <getchar+0x47>
	if (r < 1)
  803cce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd2:	7f 07                	jg     803cdb <getchar+0x40>
		return -E_EOF;
  803cd4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cd9:	eb 07                	jmp    803ce2 <getchar+0x47>
	return c;
  803cdb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803cdf:	0f b6 c0             	movzbl %al,%eax
}
  803ce2:	c9                   	leaveq 
  803ce3:	c3                   	retq   

0000000000803ce4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ce4:	55                   	push   %rbp
  803ce5:	48 89 e5             	mov    %rsp,%rbp
  803ce8:	48 83 ec 20          	sub    $0x20,%rsp
  803cec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cf3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cf6:	48 89 d6             	mov    %rdx,%rsi
  803cf9:	89 c7                	mov    %eax,%edi
  803cfb:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  803d02:	00 00 00 
  803d05:	ff d0                	callq  *%rax
  803d07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0e:	79 05                	jns    803d15 <iscons+0x31>
		return r;
  803d10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d13:	eb 1a                	jmp    803d2f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d19:	8b 10                	mov    (%rax),%edx
  803d1b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803d22:	00 00 00 
  803d25:	8b 00                	mov    (%rax),%eax
  803d27:	39 c2                	cmp    %eax,%edx
  803d29:	0f 94 c0             	sete   %al
  803d2c:	0f b6 c0             	movzbl %al,%eax
}
  803d2f:	c9                   	leaveq 
  803d30:	c3                   	retq   

0000000000803d31 <opencons>:

int
opencons(void)
{
  803d31:	55                   	push   %rbp
  803d32:	48 89 e5             	mov    %rsp,%rbp
  803d35:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d39:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d3d:	48 89 c7             	mov    %rax,%rdi
  803d40:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  803d47:	00 00 00 
  803d4a:	ff d0                	callq  *%rax
  803d4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d53:	79 05                	jns    803d5a <opencons+0x29>
		return r;
  803d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d58:	eb 5b                	jmp    803db5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5e:	ba 07 04 00 00       	mov    $0x407,%edx
  803d63:	48 89 c6             	mov    %rax,%rsi
  803d66:	bf 00 00 00 00       	mov    $0x0,%edi
  803d6b:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  803d72:	00 00 00 
  803d75:	ff d0                	callq  *%rax
  803d77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d7e:	79 05                	jns    803d85 <opencons+0x54>
		return r;
  803d80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d83:	eb 30                	jmp    803db5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d89:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d90:	00 00 00 
  803d93:	8b 12                	mov    (%rdx),%edx
  803d95:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d9b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803da2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da6:	48 89 c7             	mov    %rax,%rdi
  803da9:	48 b8 94 21 80 00 00 	movabs $0x802194,%rax
  803db0:	00 00 00 
  803db3:	ff d0                	callq  *%rax
}
  803db5:	c9                   	leaveq 
  803db6:	c3                   	retq   

0000000000803db7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803db7:	55                   	push   %rbp
  803db8:	48 89 e5             	mov    %rsp,%rbp
  803dbb:	48 83 ec 30          	sub    $0x30,%rsp
  803dbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803dc3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dc7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803dcb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dd0:	75 13                	jne    803de5 <devcons_read+0x2e>
		return 0;
  803dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd7:	eb 49                	jmp    803e22 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803dd9:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  803de0:	00 00 00 
  803de3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803de5:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803dec:	00 00 00 
  803def:	ff d0                	callq  *%rax
  803df1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803df4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803df8:	74 df                	je     803dd9 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803dfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dfe:	79 05                	jns    803e05 <devcons_read+0x4e>
		return c;
  803e00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e03:	eb 1d                	jmp    803e22 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803e05:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803e09:	75 07                	jne    803e12 <devcons_read+0x5b>
		return 0;
  803e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e10:	eb 10                	jmp    803e22 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803e12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e15:	89 c2                	mov    %eax,%edx
  803e17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e1b:	88 10                	mov    %dl,(%rax)
	return 1;
  803e1d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e22:	c9                   	leaveq 
  803e23:	c3                   	retq   

0000000000803e24 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e24:	55                   	push   %rbp
  803e25:	48 89 e5             	mov    %rsp,%rbp
  803e28:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e2f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e36:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e3d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e4b:	eb 77                	jmp    803ec4 <devcons_write+0xa0>
		m = n - tot;
  803e4d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e54:	89 c2                	mov    %eax,%edx
  803e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e59:	89 d1                	mov    %edx,%ecx
  803e5b:	29 c1                	sub    %eax,%ecx
  803e5d:	89 c8                	mov    %ecx,%eax
  803e5f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e65:	83 f8 7f             	cmp    $0x7f,%eax
  803e68:	76 07                	jbe    803e71 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803e6a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e74:	48 63 d0             	movslq %eax,%rdx
  803e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7a:	48 98                	cltq   
  803e7c:	48 89 c1             	mov    %rax,%rcx
  803e7f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803e86:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e8d:	48 89 ce             	mov    %rcx,%rsi
  803e90:	48 89 c7             	mov    %rax,%rdi
  803e93:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  803e9a:	00 00 00 
  803e9d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ea2:	48 63 d0             	movslq %eax,%rdx
  803ea5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803eac:	48 89 d6             	mov    %rdx,%rsi
  803eaf:	48 89 c7             	mov    %rax,%rdi
  803eb2:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ebe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ec1:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ec4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec7:	48 98                	cltq   
  803ec9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ed0:	0f 82 77 ff ff ff    	jb     803e4d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ed9:	c9                   	leaveq 
  803eda:	c3                   	retq   

0000000000803edb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803edb:	55                   	push   %rbp
  803edc:	48 89 e5             	mov    %rsp,%rbp
  803edf:	48 83 ec 08          	sub    $0x8,%rsp
  803ee3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eec:	c9                   	leaveq 
  803eed:	c3                   	retq   

0000000000803eee <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803eee:	55                   	push   %rbp
  803eef:	48 89 e5             	mov    %rsp,%rbp
  803ef2:	48 83 ec 10          	sub    $0x10,%rsp
  803ef6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803efa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f02:	48 be a0 4a 80 00 00 	movabs $0x804aa0,%rsi
  803f09:	00 00 00 
  803f0c:	48 89 c7             	mov    %rax,%rdi
  803f0f:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  803f16:	00 00 00 
  803f19:	ff d0                	callq  *%rax
	return 0;
  803f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f20:	c9                   	leaveq 
  803f21:	c3                   	retq   
	...

0000000000803f24 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f24:	55                   	push   %rbp
  803f25:	48 89 e5             	mov    %rsp,%rbp
  803f28:	48 83 ec 18          	sub    $0x18,%rsp
  803f2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f34:	48 89 c2             	mov    %rax,%rdx
  803f37:	48 c1 ea 15          	shr    $0x15,%rdx
  803f3b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f42:	01 00 00 
  803f45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f49:	83 e0 01             	and    $0x1,%eax
  803f4c:	48 85 c0             	test   %rax,%rax
  803f4f:	75 07                	jne    803f58 <pageref+0x34>
		return 0;
  803f51:	b8 00 00 00 00       	mov    $0x0,%eax
  803f56:	eb 53                	jmp    803fab <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f5c:	48 89 c2             	mov    %rax,%rdx
  803f5f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803f63:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f6a:	01 00 00 
  803f6d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f71:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f79:	83 e0 01             	and    $0x1,%eax
  803f7c:	48 85 c0             	test   %rax,%rax
  803f7f:	75 07                	jne    803f88 <pageref+0x64>
		return 0;
  803f81:	b8 00 00 00 00       	mov    $0x0,%eax
  803f86:	eb 23                	jmp    803fab <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8c:	48 89 c2             	mov    %rax,%rdx
  803f8f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803f93:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f9a:	00 00 00 
  803f9d:	48 c1 e2 04          	shl    $0x4,%rdx
  803fa1:	48 01 d0             	add    %rdx,%rax
  803fa4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fa8:	0f b7 c0             	movzwl %ax,%eax
}
  803fab:	c9                   	leaveq 
  803fac:	c3                   	retq   
