
obj/user/echotest.debug:     file format elf64-x86-64


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
  80003c:	e8 db 02 00 00       	callq  80031c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  800050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800054:	48 89 c6             	mov    %rax,%rsi
  800057:	48 bf 2e 43 80 00 00 	movabs $0x80432e,%rdi
  80005e:	00 00 00 
  800061:	b8 00 00 00 00       	mov    $0x0,%eax
  800066:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  80006d:	00 00 00 
  800070:	ff d2                	callq  *%rdx
	exit();
  800072:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800079:	00 00 00 
  80007c:	ff d0                	callq  *%rax
}
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <umain>:

void umain(int argc, char **argv)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 50          	sub    $0x50,%rsp
  800088:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80008b:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80008f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("Connecting to:\n");
  800096:	48 bf 32 43 80 00 00 	movabs $0x804332,%rdi
  80009d:	00 00 00 
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  8000ac:	00 00 00 
  8000af:	ff d2                	callq  *%rdx
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  8000b1:	48 bf 42 43 80 00 00 	movabs $0x804342,%rdi
  8000b8:	00 00 00 
  8000bb:	48 b8 78 3e 80 00 00 	movabs $0x803e78,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	48 be 42 43 80 00 00 	movabs $0x804342,%rsi
  8000d0:	00 00 00 
  8000d3:	48 bf 4c 43 80 00 00 	movabs $0x80434c,%rdi
  8000da:	00 00 00 
  8000dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e2:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  8000e9:	00 00 00 
  8000ec:	ff d1                	callq  *%rcx

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000ee:	ba 06 00 00 00       	mov    $0x6,%edx
  8000f3:	be 01 00 00 00       	mov    $0x1,%esi
  8000f8:	bf 02 00 00 00       	mov    $0x2,%edi
  8000fd:	48 b8 bd 2d 80 00 00 	movabs $0x802dbd,%rax
  800104:	00 00 00 
  800107:	ff d0                	callq  *%rax
  800109:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80010c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800110:	79 16                	jns    800128 <umain+0xa8>
		die("Failed to create socket");
  800112:	48 bf 61 43 80 00 00 	movabs $0x804361,%rdi
  800119:	00 00 00 
  80011c:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  800128:	48 bf 79 43 80 00 00 	movabs $0x804379,%rdi
  80012f:	00 00 00 
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
  800137:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  80013e:	00 00 00 
  800141:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800143:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800147:	ba 10 00 00 00       	mov    $0x10,%edx
  80014c:	be 00 00 00 00       	mov    $0x0,%esi
  800151:	48 89 c7             	mov    %rax,%rdi
  800154:	48 b8 5f 13 80 00 00 	movabs $0x80135f,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800160:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  800164:	48 bf 42 43 80 00 00 	movabs $0x804342,%rdi
  80016b:	00 00 00 
  80016e:	48 b8 78 3e 80 00 00 	movabs $0x803e78,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
  80017a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  80017d:	bf 10 27 00 00       	mov    $0x2710,%edi
  800182:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
  80018e:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to connect to server\n");
  800192:	48 bf 88 43 80 00 00 	movabs $0x804388,%rdi
  800199:	00 00 00 
  80019c:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a1:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  8001a8:	00 00 00 
  8001ab:	ff d2                	callq  *%rdx

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8001ad:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  8001b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b4:	ba 10 00 00 00       	mov    $0x10,%edx
  8001b9:	48 89 ce             	mov    %rcx,%rsi
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	79 16                	jns    8001e4 <umain+0x164>
		die("Failed to connect with server");
  8001ce:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  8001d5:	00 00 00 
  8001d8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax

	cprintf("connected to server\n");
  8001e4:	48 bf c3 43 80 00 00 	movabs $0x8043c3,%rdi
  8001eb:	00 00 00 
  8001ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f3:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  8001fa:	00 00 00 
  8001fd:	ff d2                	callq  *%rdx

	// Send the word to the server
	echolen = strlen(msg);
  8001ff:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800206:	00 00 00 
  800209:	48 8b 00             	mov    (%rax),%rax
  80020c:	48 89 c7             	mov    %rax,%rdi
  80020f:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  800216:	00 00 00 
  800219:	ff d0                	callq  *%rax
  80021b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(sock, msg, echolen) != echolen)
  80021e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800221:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800228:	00 00 00 
  80022b:	48 8b 08             	mov    (%rax),%rcx
  80022e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800231:	48 89 ce             	mov    %rcx,%rsi
  800234:	89 c7                	mov    %eax,%edi
  800236:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
  800242:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800245:	74 16                	je     80025d <umain+0x1dd>
		die("Mismatch in number of sent bytes");
  800247:	48 bf d8 43 80 00 00 	movabs $0x8043d8,%rdi
  80024e:	00 00 00 
  800251:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax

	// Receive the word back from the server
	cprintf("Received: \n");
  80025d:	48 bf f9 43 80 00 00 	movabs $0x8043f9,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  800273:	00 00 00 
  800276:	ff d2                	callq  *%rdx
	while (received < echolen) {
  800278:	eb 6b                	jmp    8002e5 <umain+0x265>
		int bytes = 0;
  80027a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800281:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  800285:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800288:	ba 1f 00 00 00       	mov    $0x1f,%edx
  80028d:	48 89 ce             	mov    %rcx,%rsi
  800290:	89 c7                	mov    %eax,%edi
  800292:	48 b8 58 22 80 00 00 	movabs $0x802258,%rax
  800299:	00 00 00 
  80029c:	ff d0                	callq  *%rax
  80029e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a5:	7f 16                	jg     8002bd <umain+0x23d>
			die("Failed to receive bytes from server");
  8002a7:	48 bf 08 44 80 00 00 	movabs $0x804408,%rdi
  8002ae:	00 00 00 
  8002b1:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8002b8:	00 00 00 
  8002bb:	ff d0                	callq  *%rax
		}
		received += bytes;
  8002bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c0:	01 45 fc             	add    %eax,-0x4(%rbp)
		buffer[bytes] = '\0';        // Assure null terminated string
  8002c3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c6:	48 98                	cltq   
  8002c8:	c6 44 05 c0 00       	movb   $0x0,-0x40(%rbp,%rax,1)
		cprintf(buffer);
  8002cd:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  8002e0:	00 00 00 
  8002e3:	ff d2                	callq  *%rdx
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8002e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e8:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002eb:	72 8d                	jb     80027a <umain+0x1fa>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8002ed:	48 bf 2c 44 80 00 00 	movabs $0x80442c,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  800303:	00 00 00 
  800306:	ff d2                	callq  *%rdx

	close(sock);
  800308:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030b:	89 c7                	mov    %eax,%edi
  80030d:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  800314:	00 00 00 
  800317:	ff d0                	callq  *%rax
}
  800319:	c9                   	leaveq 
  80031a:	c3                   	retq   
	...

000000000080031c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80031c:	55                   	push   %rbp
  80031d:	48 89 e5             	mov    %rsp,%rbp
  800320:	48 83 ec 10          	sub    $0x10,%rsp
  800324:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800327:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80032b:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800332:	00 00 00 
  800335:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80033c:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  800343:	00 00 00 
  800346:	ff d0                	callq  *%rax
  800348:	48 98                	cltq   
  80034a:	48 89 c2             	mov    %rax,%rdx
  80034d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800353:	48 89 d0             	mov    %rdx,%rax
  800356:	48 c1 e0 03          	shl    $0x3,%rax
  80035a:	48 01 d0             	add    %rdx,%rax
  80035d:	48 c1 e0 05          	shl    $0x5,%rax
  800361:	48 89 c2             	mov    %rax,%rdx
  800364:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80036b:	00 00 00 
  80036e:	48 01 c2             	add    %rax,%rdx
  800371:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800378:	00 00 00 
  80037b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800382:	7e 14                	jle    800398 <libmain+0x7c>
		binaryname = argv[0];
  800384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800388:	48 8b 10             	mov    (%rax),%rdx
  80038b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800392:	00 00 00 
  800395:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800398:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039f:	48 89 d6             	mov    %rdx,%rsi
  8003a2:	89 c7                	mov    %eax,%edi
  8003a4:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  8003ab:	00 00 00 
  8003ae:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003b0:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  8003b7:	00 00 00 
  8003ba:	ff d0                	callq  *%rax
}
  8003bc:	c9                   	leaveq 
  8003bd:	c3                   	retq   
	...

00000000008003c0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003c0:	55                   	push   %rbp
  8003c1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003c4:	48 b8 81 20 80 00 00 	movabs $0x802081,%rax
  8003cb:	00 00 00 
  8003ce:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d5:	48 b8 40 19 80 00 00 	movabs $0x801940,%rax
  8003dc:	00 00 00 
  8003df:	ff d0                	callq  *%rax
}
  8003e1:	5d                   	pop    %rbp
  8003e2:	c3                   	retq   
	...

00000000008003e4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003e4:	55                   	push   %rbp
  8003e5:	48 89 e5             	mov    %rsp,%rbp
  8003e8:	48 83 ec 10          	sub    $0x10,%rsp
  8003ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8003f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f7:	8b 00                	mov    (%rax),%eax
  8003f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003fc:	89 d6                	mov    %edx,%esi
  8003fe:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800402:	48 63 d0             	movslq %eax,%rdx
  800405:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80040a:	8d 50 01             	lea    0x1(%rax),%edx
  80040d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800411:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800417:	8b 00                	mov    (%rax),%eax
  800419:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041e:	75 2c                	jne    80044c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800424:	8b 00                	mov    (%rax),%eax
  800426:	48 98                	cltq   
  800428:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042c:	48 83 c2 08          	add    $0x8,%rdx
  800430:	48 89 c6             	mov    %rax,%rsi
  800433:	48 89 d7             	mov    %rdx,%rdi
  800436:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  80043d:	00 00 00 
  800440:	ff d0                	callq  *%rax
		b->idx = 0;
  800442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800446:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80044c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800450:	8b 40 04             	mov    0x4(%rax),%eax
  800453:	8d 50 01             	lea    0x1(%rax),%edx
  800456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80045d:	c9                   	leaveq 
  80045e:	c3                   	retq   

000000000080045f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80045f:	55                   	push   %rbp
  800460:	48 89 e5             	mov    %rsp,%rbp
  800463:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80046a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800471:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800478:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80047f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800486:	48 8b 0a             	mov    (%rdx),%rcx
  800489:	48 89 08             	mov    %rcx,(%rax)
  80048c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800490:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800494:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800498:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80049c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004a3:	00 00 00 
	b.cnt = 0;
  8004a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004ad:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8004b0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004b7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004be:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004c5:	48 89 c6             	mov    %rax,%rsi
  8004c8:	48 bf e4 03 80 00 00 	movabs $0x8003e4,%rdi
  8004cf:	00 00 00 
  8004d2:	48 b8 bc 08 80 00 00 	movabs $0x8008bc,%rax
  8004d9:	00 00 00 
  8004dc:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8004de:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004e4:	48 98                	cltq   
  8004e6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004ed:	48 83 c2 08          	add    $0x8,%rdx
  8004f1:	48 89 c6             	mov    %rax,%rsi
  8004f4:	48 89 d7             	mov    %rdx,%rdi
  8004f7:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800503:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800509:	c9                   	leaveq 
  80050a:	c3                   	retq   

000000000080050b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80050b:	55                   	push   %rbp
  80050c:	48 89 e5             	mov    %rsp,%rbp
  80050f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800516:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80051d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800524:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80052b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800532:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800539:	84 c0                	test   %al,%al
  80053b:	74 20                	je     80055d <cprintf+0x52>
  80053d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800541:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800545:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800549:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80054d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800551:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800555:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800559:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80055d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800564:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80056b:	00 00 00 
  80056e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800575:	00 00 00 
  800578:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80057c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800583:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80058a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800591:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800598:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80059f:	48 8b 0a             	mov    (%rdx),%rcx
  8005a2:	48 89 08             	mov    %rcx,(%rax)
  8005a5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005a9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ad:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005b1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8005b5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005bc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005c3:	48 89 d6             	mov    %rdx,%rsi
  8005c6:	48 89 c7             	mov    %rax,%rdi
  8005c9:	48 b8 5f 04 80 00 00 	movabs $0x80045f,%rax
  8005d0:	00 00 00 
  8005d3:	ff d0                	callq  *%rax
  8005d5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8005db:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005e1:	c9                   	leaveq 
  8005e2:	c3                   	retq   
	...

00000000008005e4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e4:	55                   	push   %rbp
  8005e5:	48 89 e5             	mov    %rsp,%rbp
  8005e8:	48 83 ec 30          	sub    $0x30,%rsp
  8005ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005f8:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005fb:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005ff:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800603:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800606:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80060a:	77 52                	ja     80065e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80060f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800613:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800616:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80061a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061e:	ba 00 00 00 00       	mov    $0x0,%edx
  800623:	48 f7 75 d0          	divq   -0x30(%rbp)
  800627:	48 89 c2             	mov    %rax,%rdx
  80062a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80062d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800630:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800638:	41 89 f9             	mov    %edi,%r9d
  80063b:	48 89 c7             	mov    %rax,%rdi
  80063e:	48 b8 e4 05 80 00 00 	movabs $0x8005e4,%rax
  800645:	00 00 00 
  800648:	ff d0                	callq  *%rax
  80064a:	eb 1c                	jmp    800668 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80064c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800650:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800653:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800657:	48 89 d6             	mov    %rdx,%rsi
  80065a:	89 c7                	mov    %eax,%edi
  80065c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80065e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800662:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800666:	7f e4                	jg     80064c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800668:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80066b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	48 f7 f1             	div    %rcx
  800677:	48 89 d0             	mov    %rdx,%rax
  80067a:	48 ba 08 46 80 00 00 	movabs $0x804608,%rdx
  800681:	00 00 00 
  800684:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800688:	0f be c0             	movsbl %al,%eax
  80068b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80068f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800693:	48 89 d6             	mov    %rdx,%rsi
  800696:	89 c7                	mov    %eax,%edi
  800698:	ff d1                	callq  *%rcx
}
  80069a:	c9                   	leaveq 
  80069b:	c3                   	retq   

000000000080069c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80069c:	55                   	push   %rbp
  80069d:	48 89 e5             	mov    %rsp,%rbp
  8006a0:	48 83 ec 20          	sub    $0x20,%rsp
  8006a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006a8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006ab:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006af:	7e 52                	jle    800703 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	8b 00                	mov    (%rax),%eax
  8006b7:	83 f8 30             	cmp    $0x30,%eax
  8006ba:	73 24                	jae    8006e0 <getuint+0x44>
  8006bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c8:	8b 00                	mov    (%rax),%eax
  8006ca:	89 c0                	mov    %eax,%eax
  8006cc:	48 01 d0             	add    %rdx,%rax
  8006cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d3:	8b 12                	mov    (%rdx),%edx
  8006d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dc:	89 0a                	mov    %ecx,(%rdx)
  8006de:	eb 17                	jmp    8006f7 <getuint+0x5b>
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e8:	48 89 d0             	mov    %rdx,%rax
  8006eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f7:	48 8b 00             	mov    (%rax),%rax
  8006fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006fe:	e9 a3 00 00 00       	jmpq   8007a6 <getuint+0x10a>
	else if (lflag)
  800703:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800707:	74 4f                	je     800758 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	8b 00                	mov    (%rax),%eax
  80070f:	83 f8 30             	cmp    $0x30,%eax
  800712:	73 24                	jae    800738 <getuint+0x9c>
  800714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800718:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	8b 00                	mov    (%rax),%eax
  800722:	89 c0                	mov    %eax,%eax
  800724:	48 01 d0             	add    %rdx,%rax
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	8b 12                	mov    (%rdx),%edx
  80072d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800730:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800734:	89 0a                	mov    %ecx,(%rdx)
  800736:	eb 17                	jmp    80074f <getuint+0xb3>
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800740:	48 89 d0             	mov    %rdx,%rax
  800743:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074f:	48 8b 00             	mov    (%rax),%rax
  800752:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800756:	eb 4e                	jmp    8007a6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075c:	8b 00                	mov    (%rax),%eax
  80075e:	83 f8 30             	cmp    $0x30,%eax
  800761:	73 24                	jae    800787 <getuint+0xeb>
  800763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800767:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	8b 00                	mov    (%rax),%eax
  800771:	89 c0                	mov    %eax,%eax
  800773:	48 01 d0             	add    %rdx,%rax
  800776:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077a:	8b 12                	mov    (%rdx),%edx
  80077c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800783:	89 0a                	mov    %ecx,(%rdx)
  800785:	eb 17                	jmp    80079e <getuint+0x102>
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80078f:	48 89 d0             	mov    %rdx,%rax
  800792:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800796:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079e:	8b 00                	mov    (%rax),%eax
  8007a0:	89 c0                	mov    %eax,%eax
  8007a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007aa:	c9                   	leaveq 
  8007ab:	c3                   	retq   

00000000008007ac <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ac:	55                   	push   %rbp
  8007ad:	48 89 e5             	mov    %rsp,%rbp
  8007b0:	48 83 ec 20          	sub    $0x20,%rsp
  8007b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007bb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007bf:	7e 52                	jle    800813 <getint+0x67>
		x=va_arg(*ap, long long);
  8007c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c5:	8b 00                	mov    (%rax),%eax
  8007c7:	83 f8 30             	cmp    $0x30,%eax
  8007ca:	73 24                	jae    8007f0 <getint+0x44>
  8007cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d8:	8b 00                	mov    (%rax),%eax
  8007da:	89 c0                	mov    %eax,%eax
  8007dc:	48 01 d0             	add    %rdx,%rax
  8007df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e3:	8b 12                	mov    (%rdx),%edx
  8007e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	89 0a                	mov    %ecx,(%rdx)
  8007ee:	eb 17                	jmp    800807 <getint+0x5b>
  8007f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f8:	48 89 d0             	mov    %rdx,%rax
  8007fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800803:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800807:	48 8b 00             	mov    (%rax),%rax
  80080a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080e:	e9 a3 00 00 00       	jmpq   8008b6 <getint+0x10a>
	else if (lflag)
  800813:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800817:	74 4f                	je     800868 <getint+0xbc>
		x=va_arg(*ap, long);
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	83 f8 30             	cmp    $0x30,%eax
  800822:	73 24                	jae    800848 <getint+0x9c>
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	8b 00                	mov    (%rax),%eax
  800832:	89 c0                	mov    %eax,%eax
  800834:	48 01 d0             	add    %rdx,%rax
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	8b 12                	mov    (%rdx),%edx
  80083d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	89 0a                	mov    %ecx,(%rdx)
  800846:	eb 17                	jmp    80085f <getint+0xb3>
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800850:	48 89 d0             	mov    %rdx,%rax
  800853:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085f:	48 8b 00             	mov    (%rax),%rax
  800862:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800866:	eb 4e                	jmp    8008b6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086c:	8b 00                	mov    (%rax),%eax
  80086e:	83 f8 30             	cmp    $0x30,%eax
  800871:	73 24                	jae    800897 <getint+0xeb>
  800873:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800877:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80087b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087f:	8b 00                	mov    (%rax),%eax
  800881:	89 c0                	mov    %eax,%eax
  800883:	48 01 d0             	add    %rdx,%rax
  800886:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088a:	8b 12                	mov    (%rdx),%edx
  80088c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	89 0a                	mov    %ecx,(%rdx)
  800895:	eb 17                	jmp    8008ae <getint+0x102>
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089f:	48 89 d0             	mov    %rdx,%rax
  8008a2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008aa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ae:	8b 00                	mov    (%rax),%eax
  8008b0:	48 98                	cltq   
  8008b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008ba:	c9                   	leaveq 
  8008bb:	c3                   	retq   

00000000008008bc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008bc:	55                   	push   %rbp
  8008bd:	48 89 e5             	mov    %rsp,%rbp
  8008c0:	41 54                	push   %r12
  8008c2:	53                   	push   %rbx
  8008c3:	48 83 ec 60          	sub    $0x60,%rsp
  8008c7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008cb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008cf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008d7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008db:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008df:	48 8b 0a             	mov    (%rdx),%rcx
  8008e2:	48 89 08             	mov    %rcx,(%rax)
  8008e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f5:	eb 17                	jmp    80090e <vprintfmt+0x52>
			if (ch == '\0')
  8008f7:	85 db                	test   %ebx,%ebx
  8008f9:	0f 84 d7 04 00 00    	je     800dd6 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8008ff:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800903:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800907:	48 89 c6             	mov    %rax,%rsi
  80090a:	89 df                	mov    %ebx,%edi
  80090c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800912:	0f b6 00             	movzbl (%rax),%eax
  800915:	0f b6 d8             	movzbl %al,%ebx
  800918:	83 fb 25             	cmp    $0x25,%ebx
  80091b:	0f 95 c0             	setne  %al
  80091e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800923:	84 c0                	test   %al,%al
  800925:	75 d0                	jne    8008f7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800927:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80092b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800932:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800939:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800940:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800947:	eb 04                	jmp    80094d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800949:	90                   	nop
  80094a:	eb 01                	jmp    80094d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80094c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800951:	0f b6 00             	movzbl (%rax),%eax
  800954:	0f b6 d8             	movzbl %al,%ebx
  800957:	89 d8                	mov    %ebx,%eax
  800959:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80095e:	83 e8 23             	sub    $0x23,%eax
  800961:	83 f8 55             	cmp    $0x55,%eax
  800964:	0f 87 38 04 00 00    	ja     800da2 <vprintfmt+0x4e6>
  80096a:	89 c0                	mov    %eax,%eax
  80096c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800973:	00 
  800974:	48 b8 30 46 80 00 00 	movabs $0x804630,%rax
  80097b:	00 00 00 
  80097e:	48 01 d0             	add    %rdx,%rax
  800981:	48 8b 00             	mov    (%rax),%rax
  800984:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800986:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80098a:	eb c1                	jmp    80094d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80098c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800990:	eb bb                	jmp    80094d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800992:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800999:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	c1 e0 02             	shl    $0x2,%eax
  8009a1:	01 d0                	add    %edx,%eax
  8009a3:	01 c0                	add    %eax,%eax
  8009a5:	01 d8                	add    %ebx,%eax
  8009a7:	83 e8 30             	sub    $0x30,%eax
  8009aa:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009ad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009b1:	0f b6 00             	movzbl (%rax),%eax
  8009b4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b7:	83 fb 2f             	cmp    $0x2f,%ebx
  8009ba:	7e 63                	jle    800a1f <vprintfmt+0x163>
  8009bc:	83 fb 39             	cmp    $0x39,%ebx
  8009bf:	7f 5e                	jg     800a1f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c6:	eb d1                	jmp    800999 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cb:	83 f8 30             	cmp    $0x30,%eax
  8009ce:	73 17                	jae    8009e7 <vprintfmt+0x12b>
  8009d0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d7:	89 c0                	mov    %eax,%eax
  8009d9:	48 01 d0             	add    %rdx,%rax
  8009dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009df:	83 c2 08             	add    $0x8,%edx
  8009e2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e5:	eb 0f                	jmp    8009f6 <vprintfmt+0x13a>
  8009e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009eb:	48 89 d0             	mov    %rdx,%rax
  8009ee:	48 83 c2 08          	add    $0x8,%rdx
  8009f2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f6:	8b 00                	mov    (%rax),%eax
  8009f8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009fb:	eb 23                	jmp    800a20 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8009fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a01:	0f 89 42 ff ff ff    	jns    800949 <vprintfmt+0x8d>
				width = 0;
  800a07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a0e:	e9 36 ff ff ff       	jmpq   800949 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800a13:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a1a:	e9 2e ff ff ff       	jmpq   80094d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a20:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a24:	0f 89 22 ff ff ff    	jns    80094c <vprintfmt+0x90>
				width = precision, precision = -1;
  800a2a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a2d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a30:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a37:	e9 10 ff ff ff       	jmpq   80094c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a40:	e9 08 ff ff ff       	jmpq   80094d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a48:	83 f8 30             	cmp    $0x30,%eax
  800a4b:	73 17                	jae    800a64 <vprintfmt+0x1a8>
  800a4d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a54:	89 c0                	mov    %eax,%eax
  800a56:	48 01 d0             	add    %rdx,%rax
  800a59:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5c:	83 c2 08             	add    $0x8,%edx
  800a5f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a62:	eb 0f                	jmp    800a73 <vprintfmt+0x1b7>
  800a64:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a68:	48 89 d0             	mov    %rdx,%rax
  800a6b:	48 83 c2 08          	add    $0x8,%rdx
  800a6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a73:	8b 00                	mov    (%rax),%eax
  800a75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a79:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a7d:	48 89 d6             	mov    %rdx,%rsi
  800a80:	89 c7                	mov    %eax,%edi
  800a82:	ff d1                	callq  *%rcx
			break;
  800a84:	e9 47 03 00 00       	jmpq   800dd0 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8c:	83 f8 30             	cmp    $0x30,%eax
  800a8f:	73 17                	jae    800aa8 <vprintfmt+0x1ec>
  800a91:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a98:	89 c0                	mov    %eax,%eax
  800a9a:	48 01 d0             	add    %rdx,%rax
  800a9d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa0:	83 c2 08             	add    $0x8,%edx
  800aa3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa6:	eb 0f                	jmp    800ab7 <vprintfmt+0x1fb>
  800aa8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aac:	48 89 d0             	mov    %rdx,%rax
  800aaf:	48 83 c2 08          	add    $0x8,%rdx
  800ab3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	79 02                	jns    800abf <vprintfmt+0x203>
				err = -err;
  800abd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800abf:	83 fb 10             	cmp    $0x10,%ebx
  800ac2:	7f 16                	jg     800ada <vprintfmt+0x21e>
  800ac4:	48 b8 80 45 80 00 00 	movabs $0x804580,%rax
  800acb:	00 00 00 
  800ace:	48 63 d3             	movslq %ebx,%rdx
  800ad1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ad5:	4d 85 e4             	test   %r12,%r12
  800ad8:	75 2e                	jne    800b08 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800ada:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ade:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae2:	89 d9                	mov    %ebx,%ecx
  800ae4:	48 ba 19 46 80 00 00 	movabs $0x804619,%rdx
  800aeb:	00 00 00 
  800aee:	48 89 c7             	mov    %rax,%rdi
  800af1:	b8 00 00 00 00       	mov    $0x0,%eax
  800af6:	49 b8 e0 0d 80 00 00 	movabs $0x800de0,%r8
  800afd:	00 00 00 
  800b00:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b03:	e9 c8 02 00 00       	jmpq   800dd0 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b08:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b10:	4c 89 e1             	mov    %r12,%rcx
  800b13:	48 ba 22 46 80 00 00 	movabs $0x804622,%rdx
  800b1a:	00 00 00 
  800b1d:	48 89 c7             	mov    %rax,%rdi
  800b20:	b8 00 00 00 00       	mov    $0x0,%eax
  800b25:	49 b8 e0 0d 80 00 00 	movabs $0x800de0,%r8
  800b2c:	00 00 00 
  800b2f:	41 ff d0             	callq  *%r8
			break;
  800b32:	e9 99 02 00 00       	jmpq   800dd0 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3a:	83 f8 30             	cmp    $0x30,%eax
  800b3d:	73 17                	jae    800b56 <vprintfmt+0x29a>
  800b3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b46:	89 c0                	mov    %eax,%eax
  800b48:	48 01 d0             	add    %rdx,%rax
  800b4b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4e:	83 c2 08             	add    $0x8,%edx
  800b51:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b54:	eb 0f                	jmp    800b65 <vprintfmt+0x2a9>
  800b56:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5a:	48 89 d0             	mov    %rdx,%rax
  800b5d:	48 83 c2 08          	add    $0x8,%rdx
  800b61:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b65:	4c 8b 20             	mov    (%rax),%r12
  800b68:	4d 85 e4             	test   %r12,%r12
  800b6b:	75 0a                	jne    800b77 <vprintfmt+0x2bb>
				p = "(null)";
  800b6d:	49 bc 25 46 80 00 00 	movabs $0x804625,%r12
  800b74:	00 00 00 
			if (width > 0 && padc != '-')
  800b77:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b7b:	7e 7a                	jle    800bf7 <vprintfmt+0x33b>
  800b7d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b81:	74 74                	je     800bf7 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b83:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b86:	48 98                	cltq   
  800b88:	48 89 c6             	mov    %rax,%rsi
  800b8b:	4c 89 e7             	mov    %r12,%rdi
  800b8e:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  800b95:	00 00 00 
  800b98:	ff d0                	callq  *%rax
  800b9a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b9d:	eb 17                	jmp    800bb6 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800b9f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800ba3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800bab:	48 89 d6             	mov    %rdx,%rsi
  800bae:	89 c7                	mov    %eax,%edi
  800bb0:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bba:	7f e3                	jg     800b9f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbc:	eb 39                	jmp    800bf7 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bc2:	74 1e                	je     800be2 <vprintfmt+0x326>
  800bc4:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc7:	7e 05                	jle    800bce <vprintfmt+0x312>
  800bc9:	83 fb 7e             	cmp    $0x7e,%ebx
  800bcc:	7e 14                	jle    800be2 <vprintfmt+0x326>
					putch('?', putdat);
  800bce:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bd2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bd6:	48 89 c6             	mov    %rax,%rsi
  800bd9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bde:	ff d2                	callq  *%rdx
  800be0:	eb 0f                	jmp    800bf1 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800be2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800be6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bea:	48 89 c6             	mov    %rax,%rsi
  800bed:	89 df                	mov    %ebx,%edi
  800bef:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf5:	eb 01                	jmp    800bf8 <vprintfmt+0x33c>
  800bf7:	90                   	nop
  800bf8:	41 0f b6 04 24       	movzbl (%r12),%eax
  800bfd:	0f be d8             	movsbl %al,%ebx
  800c00:	85 db                	test   %ebx,%ebx
  800c02:	0f 95 c0             	setne  %al
  800c05:	49 83 c4 01          	add    $0x1,%r12
  800c09:	84 c0                	test   %al,%al
  800c0b:	74 28                	je     800c35 <vprintfmt+0x379>
  800c0d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c11:	78 ab                	js     800bbe <vprintfmt+0x302>
  800c13:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c17:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c1b:	79 a1                	jns    800bbe <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c1d:	eb 16                	jmp    800c35 <vprintfmt+0x379>
				putch(' ', putdat);
  800c1f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c23:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c27:	48 89 c6             	mov    %rax,%rsi
  800c2a:	bf 20 00 00 00       	mov    $0x20,%edi
  800c2f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c31:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c35:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c39:	7f e4                	jg     800c1f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c3b:	e9 90 01 00 00       	jmpq   800dd0 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c40:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c44:	be 03 00 00 00       	mov    $0x3,%esi
  800c49:	48 89 c7             	mov    %rax,%rdi
  800c4c:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800c53:	00 00 00 
  800c56:	ff d0                	callq  *%rax
  800c58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c60:	48 85 c0             	test   %rax,%rax
  800c63:	79 1d                	jns    800c82 <vprintfmt+0x3c6>
				putch('-', putdat);
  800c65:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c69:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c6d:	48 89 c6             	mov    %rax,%rsi
  800c70:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c75:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7b:	48 f7 d8             	neg    %rax
  800c7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c82:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c89:	e9 d5 00 00 00       	jmpq   800d63 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c92:	be 03 00 00 00       	mov    $0x3,%esi
  800c97:	48 89 c7             	mov    %rax,%rdi
  800c9a:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  800ca1:	00 00 00 
  800ca4:	ff d0                	callq  *%rax
  800ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800caa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cb1:	e9 ad 00 00 00       	jmpq   800d63 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800cb6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cba:	be 03 00 00 00       	mov    $0x3,%esi
  800cbf:	48 89 c7             	mov    %rax,%rdi
  800cc2:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  800cc9:	00 00 00 
  800ccc:	ff d0                	callq  *%rax
  800cce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800cd2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cd9:	e9 85 00 00 00       	jmpq   800d63 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800cde:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ce2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ce6:	48 89 c6             	mov    %rax,%rsi
  800ce9:	bf 30 00 00 00       	mov    $0x30,%edi
  800cee:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800cf0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cf4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cf8:	48 89 c6             	mov    %rax,%rsi
  800cfb:	bf 78 00 00 00       	mov    $0x78,%edi
  800d00:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d05:	83 f8 30             	cmp    $0x30,%eax
  800d08:	73 17                	jae    800d21 <vprintfmt+0x465>
  800d0a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d11:	89 c0                	mov    %eax,%eax
  800d13:	48 01 d0             	add    %rdx,%rax
  800d16:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d19:	83 c2 08             	add    $0x8,%edx
  800d1c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d1f:	eb 0f                	jmp    800d30 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800d21:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d25:	48 89 d0             	mov    %rdx,%rax
  800d28:	48 83 c2 08          	add    $0x8,%rdx
  800d2c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d30:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d37:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d3e:	eb 23                	jmp    800d63 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d40:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d44:	be 03 00 00 00       	mov    $0x3,%esi
  800d49:	48 89 c7             	mov    %rax,%rdi
  800d4c:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  800d53:	00 00 00 
  800d56:	ff d0                	callq  *%rax
  800d58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d5c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d63:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d68:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d6b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d72:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7a:	45 89 c1             	mov    %r8d,%r9d
  800d7d:	41 89 f8             	mov    %edi,%r8d
  800d80:	48 89 c7             	mov    %rax,%rdi
  800d83:	48 b8 e4 05 80 00 00 	movabs $0x8005e4,%rax
  800d8a:	00 00 00 
  800d8d:	ff d0                	callq  *%rax
			break;
  800d8f:	eb 3f                	jmp    800dd0 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d91:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d95:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d99:	48 89 c6             	mov    %rax,%rsi
  800d9c:	89 df                	mov    %ebx,%edi
  800d9e:	ff d2                	callq  *%rdx
			break;
  800da0:	eb 2e                	jmp    800dd0 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800da2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800da6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800daa:	48 89 c6             	mov    %rax,%rsi
  800dad:	bf 25 00 00 00       	mov    $0x25,%edi
  800db2:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800db4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800db9:	eb 05                	jmp    800dc0 <vprintfmt+0x504>
  800dbb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dc0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dc4:	48 83 e8 01          	sub    $0x1,%rax
  800dc8:	0f b6 00             	movzbl (%rax),%eax
  800dcb:	3c 25                	cmp    $0x25,%al
  800dcd:	75 ec                	jne    800dbb <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800dcf:	90                   	nop
		}
	}
  800dd0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dd1:	e9 38 fb ff ff       	jmpq   80090e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800dd6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800dd7:	48 83 c4 60          	add    $0x60,%rsp
  800ddb:	5b                   	pop    %rbx
  800ddc:	41 5c                	pop    %r12
  800dde:	5d                   	pop    %rbp
  800ddf:	c3                   	retq   

0000000000800de0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800de0:	55                   	push   %rbp
  800de1:	48 89 e5             	mov    %rsp,%rbp
  800de4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800deb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800df2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800df9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e00:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e07:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e0e:	84 c0                	test   %al,%al
  800e10:	74 20                	je     800e32 <printfmt+0x52>
  800e12:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e16:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e1a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e1e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e22:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e26:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e2a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e2e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e32:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e39:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e40:	00 00 00 
  800e43:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e4a:	00 00 00 
  800e4d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e51:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e58:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e5f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e66:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e6d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e74:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e7b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e82:	48 89 c7             	mov    %rax,%rdi
  800e85:	48 b8 bc 08 80 00 00 	movabs $0x8008bc,%rax
  800e8c:	00 00 00 
  800e8f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e91:	c9                   	leaveq 
  800e92:	c3                   	retq   

0000000000800e93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e93:	55                   	push   %rbp
  800e94:	48 89 e5             	mov    %rsp,%rbp
  800e97:	48 83 ec 10          	sub    $0x10,%rsp
  800e9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ea2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea6:	8b 40 10             	mov    0x10(%rax),%eax
  800ea9:	8d 50 01             	lea    0x1(%rax),%edx
  800eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb7:	48 8b 10             	mov    (%rax),%rdx
  800eba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ebe:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ec2:	48 39 c2             	cmp    %rax,%rdx
  800ec5:	73 17                	jae    800ede <sprintputch+0x4b>
		*b->buf++ = ch;
  800ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ecb:	48 8b 00             	mov    (%rax),%rax
  800ece:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ed1:	88 10                	mov    %dl,(%rax)
  800ed3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edb:	48 89 10             	mov    %rdx,(%rax)
}
  800ede:	c9                   	leaveq 
  800edf:	c3                   	retq   

0000000000800ee0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee0:	55                   	push   %rbp
  800ee1:	48 89 e5             	mov    %rsp,%rbp
  800ee4:	48 83 ec 50          	sub    $0x50,%rsp
  800ee8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eec:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eef:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ef3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ef7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800efb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eff:	48 8b 0a             	mov    (%rdx),%rcx
  800f02:	48 89 08             	mov    %rcx,(%rax)
  800f05:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f09:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f0d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f11:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f15:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f19:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f1d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f20:	48 98                	cltq   
  800f22:	48 83 e8 01          	sub    $0x1,%rax
  800f26:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f2a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f35:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f3a:	74 06                	je     800f42 <vsnprintf+0x62>
  800f3c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f40:	7f 07                	jg     800f49 <vsnprintf+0x69>
		return -E_INVAL;
  800f42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f47:	eb 2f                	jmp    800f78 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f49:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f4d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f51:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f55:	48 89 c6             	mov    %rax,%rsi
  800f58:	48 bf 93 0e 80 00 00 	movabs $0x800e93,%rdi
  800f5f:	00 00 00 
  800f62:	48 b8 bc 08 80 00 00 	movabs $0x8008bc,%rax
  800f69:	00 00 00 
  800f6c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f72:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f75:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f78:	c9                   	leaveq 
  800f79:	c3                   	retq   

0000000000800f7a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f7a:	55                   	push   %rbp
  800f7b:	48 89 e5             	mov    %rsp,%rbp
  800f7e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f85:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f8c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f92:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f99:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fa0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fa7:	84 c0                	test   %al,%al
  800fa9:	74 20                	je     800fcb <snprintf+0x51>
  800fab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800faf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fb3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fb7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fbb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fbf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fc3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fc7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fcb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fd2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fd9:	00 00 00 
  800fdc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fe3:	00 00 00 
  800fe6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ff1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ff8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801006:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80100d:	48 8b 0a             	mov    (%rdx),%rcx
  801010:	48 89 08             	mov    %rcx,(%rax)
  801013:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801017:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80101b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80101f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801023:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80102a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801031:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801037:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80103e:	48 89 c7             	mov    %rax,%rdi
  801041:	48 b8 e0 0e 80 00 00 	movabs $0x800ee0,%rax
  801048:	00 00 00 
  80104b:	ff d0                	callq  *%rax
  80104d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801053:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801059:	c9                   	leaveq 
  80105a:	c3                   	retq   
	...

000000000080105c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80105c:	55                   	push   %rbp
  80105d:	48 89 e5             	mov    %rsp,%rbp
  801060:	48 83 ec 18          	sub    $0x18,%rsp
  801064:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801068:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80106f:	eb 09                	jmp    80107a <strlen+0x1e>
		n++;
  801071:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801075:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80107a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107e:	0f b6 00             	movzbl (%rax),%eax
  801081:	84 c0                	test   %al,%al
  801083:	75 ec                	jne    801071 <strlen+0x15>
		n++;
	return n;
  801085:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 20          	sub    $0x20,%rsp
  801092:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801096:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80109a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a1:	eb 0e                	jmp    8010b1 <strnlen+0x27>
		n++;
  8010a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010a7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ac:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010b1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010b6:	74 0b                	je     8010c3 <strnlen+0x39>
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	0f b6 00             	movzbl (%rax),%eax
  8010bf:	84 c0                	test   %al,%al
  8010c1:	75 e0                	jne    8010a3 <strnlen+0x19>
		n++;
	return n;
  8010c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010c6:	c9                   	leaveq 
  8010c7:	c3                   	retq   

00000000008010c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010c8:	55                   	push   %rbp
  8010c9:	48 89 e5             	mov    %rsp,%rbp
  8010cc:	48 83 ec 20          	sub    $0x20,%rsp
  8010d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010e0:	90                   	nop
  8010e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e5:	0f b6 10             	movzbl (%rax),%edx
  8010e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ec:	88 10                	mov    %dl,(%rax)
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	0f 95 c0             	setne  %al
  8010fa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ff:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801104:	84 c0                	test   %al,%al
  801106:	75 d9                	jne    8010e1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80110c:	c9                   	leaveq 
  80110d:	c3                   	retq   

000000000080110e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80110e:	55                   	push   %rbp
  80110f:	48 89 e5             	mov    %rsp,%rbp
  801112:	48 83 ec 20          	sub    $0x20,%rsp
  801116:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	48 89 c7             	mov    %rax,%rdi
  801125:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  80112c:	00 00 00 
  80112f:	ff d0                	callq  *%rax
  801131:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801134:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801137:	48 98                	cltq   
  801139:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80113d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801141:	48 89 d6             	mov    %rdx,%rsi
  801144:	48 89 c7             	mov    %rax,%rdi
  801147:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  80114e:	00 00 00 
  801151:	ff d0                	callq  *%rax
	return dst;
  801153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801157:	c9                   	leaveq 
  801158:	c3                   	retq   

0000000000801159 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801159:	55                   	push   %rbp
  80115a:	48 89 e5             	mov    %rsp,%rbp
  80115d:	48 83 ec 28          	sub    $0x28,%rsp
  801161:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801165:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801169:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801175:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80117c:	00 
  80117d:	eb 27                	jmp    8011a6 <strncpy+0x4d>
		*dst++ = *src;
  80117f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801183:	0f b6 10             	movzbl (%rax),%edx
  801186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118a:	88 10                	mov    %dl,(%rax)
  80118c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801191:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801195:	0f b6 00             	movzbl (%rax),%eax
  801198:	84 c0                	test   %al,%al
  80119a:	74 05                	je     8011a1 <strncpy+0x48>
			src++;
  80119c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011aa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011ae:	72 cf                	jb     80117f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011b4:	c9                   	leaveq 
  8011b5:	c3                   	retq   

00000000008011b6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011b6:	55                   	push   %rbp
  8011b7:	48 89 e5             	mov    %rsp,%rbp
  8011ba:	48 83 ec 28          	sub    $0x28,%rsp
  8011be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011d7:	74 37                	je     801210 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8011d9:	eb 17                	jmp    8011f2 <strlcpy+0x3c>
			*dst++ = *src++;
  8011db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011df:	0f b6 10             	movzbl (%rax),%edx
  8011e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e6:	88 10                	mov    %dl,(%rax)
  8011e8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ed:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011f2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011f7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011fc:	74 0b                	je     801209 <strlcpy+0x53>
  8011fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801202:	0f b6 00             	movzbl (%rax),%eax
  801205:	84 c0                	test   %al,%al
  801207:	75 d2                	jne    8011db <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801210:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801218:	48 89 d1             	mov    %rdx,%rcx
  80121b:	48 29 c1             	sub    %rax,%rcx
  80121e:	48 89 c8             	mov    %rcx,%rax
}
  801221:	c9                   	leaveq 
  801222:	c3                   	retq   

0000000000801223 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801223:	55                   	push   %rbp
  801224:	48 89 e5             	mov    %rsp,%rbp
  801227:	48 83 ec 10          	sub    $0x10,%rsp
  80122b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80122f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801233:	eb 0a                	jmp    80123f <strcmp+0x1c>
		p++, q++;
  801235:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80123a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801243:	0f b6 00             	movzbl (%rax),%eax
  801246:	84 c0                	test   %al,%al
  801248:	74 12                	je     80125c <strcmp+0x39>
  80124a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124e:	0f b6 10             	movzbl (%rax),%edx
  801251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801255:	0f b6 00             	movzbl (%rax),%eax
  801258:	38 c2                	cmp    %al,%dl
  80125a:	74 d9                	je     801235 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80125c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801260:	0f b6 00             	movzbl (%rax),%eax
  801263:	0f b6 d0             	movzbl %al,%edx
  801266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126a:	0f b6 00             	movzbl (%rax),%eax
  80126d:	0f b6 c0             	movzbl %al,%eax
  801270:	89 d1                	mov    %edx,%ecx
  801272:	29 c1                	sub    %eax,%ecx
  801274:	89 c8                	mov    %ecx,%eax
}
  801276:	c9                   	leaveq 
  801277:	c3                   	retq   

0000000000801278 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801278:	55                   	push   %rbp
  801279:	48 89 e5             	mov    %rsp,%rbp
  80127c:	48 83 ec 18          	sub    $0x18,%rsp
  801280:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801284:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801288:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80128c:	eb 0f                	jmp    80129d <strncmp+0x25>
		n--, p++, q++;
  80128e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801293:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801298:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80129d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a2:	74 1d                	je     8012c1 <strncmp+0x49>
  8012a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a8:	0f b6 00             	movzbl (%rax),%eax
  8012ab:	84 c0                	test   %al,%al
  8012ad:	74 12                	je     8012c1 <strncmp+0x49>
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b3:	0f b6 10             	movzbl (%rax),%edx
  8012b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ba:	0f b6 00             	movzbl (%rax),%eax
  8012bd:	38 c2                	cmp    %al,%dl
  8012bf:	74 cd                	je     80128e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c6:	75 07                	jne    8012cf <strncmp+0x57>
		return 0;
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cd:	eb 1a                	jmp    8012e9 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	0f b6 00             	movzbl (%rax),%eax
  8012d6:	0f b6 d0             	movzbl %al,%edx
  8012d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dd:	0f b6 00             	movzbl (%rax),%eax
  8012e0:	0f b6 c0             	movzbl %al,%eax
  8012e3:	89 d1                	mov    %edx,%ecx
  8012e5:	29 c1                	sub    %eax,%ecx
  8012e7:	89 c8                	mov    %ecx,%eax
}
  8012e9:	c9                   	leaveq 
  8012ea:	c3                   	retq   

00000000008012eb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012eb:	55                   	push   %rbp
  8012ec:	48 89 e5             	mov    %rsp,%rbp
  8012ef:	48 83 ec 10          	sub    $0x10,%rsp
  8012f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f7:	89 f0                	mov    %esi,%eax
  8012f9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012fc:	eb 17                	jmp    801315 <strchr+0x2a>
		if (*s == c)
  8012fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801302:	0f b6 00             	movzbl (%rax),%eax
  801305:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801308:	75 06                	jne    801310 <strchr+0x25>
			return (char *) s;
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	eb 15                	jmp    801325 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801310:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801319:	0f b6 00             	movzbl (%rax),%eax
  80131c:	84 c0                	test   %al,%al
  80131e:	75 de                	jne    8012fe <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801320:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801325:	c9                   	leaveq 
  801326:	c3                   	retq   

0000000000801327 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801327:	55                   	push   %rbp
  801328:	48 89 e5             	mov    %rsp,%rbp
  80132b:	48 83 ec 10          	sub    $0x10,%rsp
  80132f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801333:	89 f0                	mov    %esi,%eax
  801335:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801338:	eb 11                	jmp    80134b <strfind+0x24>
		if (*s == c)
  80133a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133e:	0f b6 00             	movzbl (%rax),%eax
  801341:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801344:	74 12                	je     801358 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801346:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	84 c0                	test   %al,%al
  801354:	75 e4                	jne    80133a <strfind+0x13>
  801356:	eb 01                	jmp    801359 <strfind+0x32>
		if (*s == c)
			break;
  801358:	90                   	nop
	return (char *) s;
  801359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80135d:	c9                   	leaveq 
  80135e:	c3                   	retq   

000000000080135f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80135f:	55                   	push   %rbp
  801360:	48 89 e5             	mov    %rsp,%rbp
  801363:	48 83 ec 18          	sub    $0x18,%rsp
  801367:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80136e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801372:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801377:	75 06                	jne    80137f <memset+0x20>
		return v;
  801379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137d:	eb 69                	jmp    8013e8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80137f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801383:	83 e0 03             	and    $0x3,%eax
  801386:	48 85 c0             	test   %rax,%rax
  801389:	75 48                	jne    8013d3 <memset+0x74>
  80138b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138f:	83 e0 03             	and    $0x3,%eax
  801392:	48 85 c0             	test   %rax,%rax
  801395:	75 3c                	jne    8013d3 <memset+0x74>
		c &= 0xFF;
  801397:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80139e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a1:	89 c2                	mov    %eax,%edx
  8013a3:	c1 e2 18             	shl    $0x18,%edx
  8013a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a9:	c1 e0 10             	shl    $0x10,%eax
  8013ac:	09 c2                	or     %eax,%edx
  8013ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b1:	c1 e0 08             	shl    $0x8,%eax
  8013b4:	09 d0                	or     %edx,%eax
  8013b6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bd:	48 89 c1             	mov    %rax,%rcx
  8013c0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013cb:	48 89 d7             	mov    %rdx,%rdi
  8013ce:	fc                   	cld    
  8013cf:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013d1:	eb 11                	jmp    8013e4 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013da:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013de:	48 89 d7             	mov    %rdx,%rdi
  8013e1:	fc                   	cld    
  8013e2:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8013e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013e8:	c9                   	leaveq 
  8013e9:	c3                   	retq   

00000000008013ea <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013ea:	55                   	push   %rbp
  8013eb:	48 89 e5             	mov    %rsp,%rbp
  8013ee:	48 83 ec 28          	sub    $0x28,%rsp
  8013f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801402:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80140e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801412:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801416:	0f 83 88 00 00 00    	jae    8014a4 <memmove+0xba>
  80141c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801420:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801424:	48 01 d0             	add    %rdx,%rax
  801427:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80142b:	76 77                	jbe    8014a4 <memmove+0xba>
		s += n;
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80143d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801441:	83 e0 03             	and    $0x3,%eax
  801444:	48 85 c0             	test   %rax,%rax
  801447:	75 3b                	jne    801484 <memmove+0x9a>
  801449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144d:	83 e0 03             	and    $0x3,%eax
  801450:	48 85 c0             	test   %rax,%rax
  801453:	75 2f                	jne    801484 <memmove+0x9a>
  801455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801459:	83 e0 03             	and    $0x3,%eax
  80145c:	48 85 c0             	test   %rax,%rax
  80145f:	75 23                	jne    801484 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801465:	48 83 e8 04          	sub    $0x4,%rax
  801469:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146d:	48 83 ea 04          	sub    $0x4,%rdx
  801471:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801475:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801479:	48 89 c7             	mov    %rax,%rdi
  80147c:	48 89 d6             	mov    %rdx,%rsi
  80147f:	fd                   	std    
  801480:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801482:	eb 1d                	jmp    8014a1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801488:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801490:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801498:	48 89 d7             	mov    %rdx,%rdi
  80149b:	48 89 c1             	mov    %rax,%rcx
  80149e:	fd                   	std    
  80149f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014a1:	fc                   	cld    
  8014a2:	eb 57                	jmp    8014fb <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a8:	83 e0 03             	and    $0x3,%eax
  8014ab:	48 85 c0             	test   %rax,%rax
  8014ae:	75 36                	jne    8014e6 <memmove+0xfc>
  8014b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b4:	83 e0 03             	and    $0x3,%eax
  8014b7:	48 85 c0             	test   %rax,%rax
  8014ba:	75 2a                	jne    8014e6 <memmove+0xfc>
  8014bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c0:	83 e0 03             	and    $0x3,%eax
  8014c3:	48 85 c0             	test   %rax,%rax
  8014c6:	75 1e                	jne    8014e6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cc:	48 89 c1             	mov    %rax,%rcx
  8014cf:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014db:	48 89 c7             	mov    %rax,%rdi
  8014de:	48 89 d6             	mov    %rdx,%rsi
  8014e1:	fc                   	cld    
  8014e2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014e4:	eb 15                	jmp    8014fb <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ee:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014f2:	48 89 c7             	mov    %rax,%rdi
  8014f5:	48 89 d6             	mov    %rdx,%rsi
  8014f8:	fc                   	cld    
  8014f9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014ff:	c9                   	leaveq 
  801500:	c3                   	retq   

0000000000801501 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801501:	55                   	push   %rbp
  801502:	48 89 e5             	mov    %rsp,%rbp
  801505:	48 83 ec 18          	sub    $0x18,%rsp
  801509:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80150d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801511:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801515:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801519:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801521:	48 89 ce             	mov    %rcx,%rsi
  801524:	48 89 c7             	mov    %rax,%rdi
  801527:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  80152e:	00 00 00 
  801531:	ff d0                	callq  *%rax
}
  801533:	c9                   	leaveq 
  801534:	c3                   	retq   

0000000000801535 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801535:	55                   	push   %rbp
  801536:	48 89 e5             	mov    %rsp,%rbp
  801539:	48 83 ec 28          	sub    $0x28,%rsp
  80153d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801541:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801545:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801551:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801555:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801559:	eb 38                	jmp    801593 <memcmp+0x5e>
		if (*s1 != *s2)
  80155b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155f:	0f b6 10             	movzbl (%rax),%edx
  801562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801566:	0f b6 00             	movzbl (%rax),%eax
  801569:	38 c2                	cmp    %al,%dl
  80156b:	74 1c                	je     801589 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80156d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801571:	0f b6 00             	movzbl (%rax),%eax
  801574:	0f b6 d0             	movzbl %al,%edx
  801577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	0f b6 c0             	movzbl %al,%eax
  801581:	89 d1                	mov    %edx,%ecx
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 c8                	mov    %ecx,%eax
  801587:	eb 20                	jmp    8015a9 <memcmp+0x74>
		s1++, s2++;
  801589:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801593:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801598:	0f 95 c0             	setne  %al
  80159b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015a0:	84 c0                	test   %al,%al
  8015a2:	75 b7                	jne    80155b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a9:	c9                   	leaveq 
  8015aa:	c3                   	retq   

00000000008015ab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	48 83 ec 28          	sub    $0x28,%rsp
  8015b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c6:	48 01 d0             	add    %rdx,%rax
  8015c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015cd:	eb 13                	jmp    8015e2 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d3:	0f b6 10             	movzbl (%rax),%edx
  8015d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015d9:	38 c2                	cmp    %al,%dl
  8015db:	74 11                	je     8015ee <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015dd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015ea:	72 e3                	jb     8015cf <memfind+0x24>
  8015ec:	eb 01                	jmp    8015ef <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015ee:	90                   	nop
	return (void *) s;
  8015ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015f3:	c9                   	leaveq 
  8015f4:	c3                   	retq   

00000000008015f5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015f5:	55                   	push   %rbp
  8015f6:	48 89 e5             	mov    %rsp,%rbp
  8015f9:	48 83 ec 38          	sub    $0x38,%rsp
  8015fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801601:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801605:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801608:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80160f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801616:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801617:	eb 05                	jmp    80161e <strtol+0x29>
		s++;
  801619:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80161e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801622:	0f b6 00             	movzbl (%rax),%eax
  801625:	3c 20                	cmp    $0x20,%al
  801627:	74 f0                	je     801619 <strtol+0x24>
  801629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	3c 09                	cmp    $0x9,%al
  801632:	74 e5                	je     801619 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	3c 2b                	cmp    $0x2b,%al
  80163d:	75 07                	jne    801646 <strtol+0x51>
		s++;
  80163f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801644:	eb 17                	jmp    80165d <strtol+0x68>
	else if (*s == '-')
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	3c 2d                	cmp    $0x2d,%al
  80164f:	75 0c                	jne    80165d <strtol+0x68>
		s++, neg = 1;
  801651:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801656:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80165d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801661:	74 06                	je     801669 <strtol+0x74>
  801663:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801667:	75 28                	jne    801691 <strtol+0x9c>
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 30                	cmp    $0x30,%al
  801672:	75 1d                	jne    801691 <strtol+0x9c>
  801674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801678:	48 83 c0 01          	add    $0x1,%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 78                	cmp    $0x78,%al
  801681:	75 0e                	jne    801691 <strtol+0x9c>
		s += 2, base = 16;
  801683:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801688:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80168f:	eb 2c                	jmp    8016bd <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801691:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801695:	75 19                	jne    8016b0 <strtol+0xbb>
  801697:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169b:	0f b6 00             	movzbl (%rax),%eax
  80169e:	3c 30                	cmp    $0x30,%al
  8016a0:	75 0e                	jne    8016b0 <strtol+0xbb>
		s++, base = 8;
  8016a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016ae:	eb 0d                	jmp    8016bd <strtol+0xc8>
	else if (base == 0)
  8016b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b4:	75 07                	jne    8016bd <strtol+0xc8>
		base = 10;
  8016b6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c1:	0f b6 00             	movzbl (%rax),%eax
  8016c4:	3c 2f                	cmp    $0x2f,%al
  8016c6:	7e 1d                	jle    8016e5 <strtol+0xf0>
  8016c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cc:	0f b6 00             	movzbl (%rax),%eax
  8016cf:	3c 39                	cmp    $0x39,%al
  8016d1:	7f 12                	jg     8016e5 <strtol+0xf0>
			dig = *s - '0';
  8016d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d7:	0f b6 00             	movzbl (%rax),%eax
  8016da:	0f be c0             	movsbl %al,%eax
  8016dd:	83 e8 30             	sub    $0x30,%eax
  8016e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e3:	eb 4e                	jmp    801733 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	0f b6 00             	movzbl (%rax),%eax
  8016ec:	3c 60                	cmp    $0x60,%al
  8016ee:	7e 1d                	jle    80170d <strtol+0x118>
  8016f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f4:	0f b6 00             	movzbl (%rax),%eax
  8016f7:	3c 7a                	cmp    $0x7a,%al
  8016f9:	7f 12                	jg     80170d <strtol+0x118>
			dig = *s - 'a' + 10;
  8016fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ff:	0f b6 00             	movzbl (%rax),%eax
  801702:	0f be c0             	movsbl %al,%eax
  801705:	83 e8 57             	sub    $0x57,%eax
  801708:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80170b:	eb 26                	jmp    801733 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	0f b6 00             	movzbl (%rax),%eax
  801714:	3c 40                	cmp    $0x40,%al
  801716:	7e 47                	jle    80175f <strtol+0x16a>
  801718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171c:	0f b6 00             	movzbl (%rax),%eax
  80171f:	3c 5a                	cmp    $0x5a,%al
  801721:	7f 3c                	jg     80175f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801723:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801727:	0f b6 00             	movzbl (%rax),%eax
  80172a:	0f be c0             	movsbl %al,%eax
  80172d:	83 e8 37             	sub    $0x37,%eax
  801730:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801733:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801736:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801739:	7d 23                	jge    80175e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80173b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801740:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801743:	48 98                	cltq   
  801745:	48 89 c2             	mov    %rax,%rdx
  801748:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80174d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801750:	48 98                	cltq   
  801752:	48 01 d0             	add    %rdx,%rax
  801755:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801759:	e9 5f ff ff ff       	jmpq   8016bd <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80175e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80175f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801764:	74 0b                	je     801771 <strtol+0x17c>
		*endptr = (char *) s;
  801766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80176e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801771:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801775:	74 09                	je     801780 <strtol+0x18b>
  801777:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177b:	48 f7 d8             	neg    %rax
  80177e:	eb 04                	jmp    801784 <strtol+0x18f>
  801780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801784:	c9                   	leaveq 
  801785:	c3                   	retq   

0000000000801786 <strstr>:

char * strstr(const char *in, const char *str)
{
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
  80178a:	48 83 ec 30          	sub    $0x30,%rsp
  80178e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801792:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801796:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80179a:	0f b6 00             	movzbl (%rax),%eax
  80179d:	88 45 ff             	mov    %al,-0x1(%rbp)
  8017a0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8017a5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017a9:	75 06                	jne    8017b1 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	eb 68                	jmp    801819 <strstr+0x93>

    len = strlen(str);
  8017b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b5:	48 89 c7             	mov    %rax,%rdi
  8017b8:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  8017bf:	00 00 00 
  8017c2:	ff d0                	callq  *%rax
  8017c4:	48 98                	cltq   
  8017c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ce:	0f b6 00             	movzbl (%rax),%eax
  8017d1:	88 45 ef             	mov    %al,-0x11(%rbp)
  8017d4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8017d9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017dd:	75 07                	jne    8017e6 <strstr+0x60>
                return (char *) 0;
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e4:	eb 33                	jmp    801819 <strstr+0x93>
        } while (sc != c);
  8017e6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017ea:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017ed:	75 db                	jne    8017ca <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8017ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fb:	48 89 ce             	mov    %rcx,%rsi
  8017fe:	48 89 c7             	mov    %rax,%rdi
  801801:	48 b8 78 12 80 00 00 	movabs $0x801278,%rax
  801808:	00 00 00 
  80180b:	ff d0                	callq  *%rax
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 b9                	jne    8017ca <strstr+0x44>

    return (char *) (in - 1);
  801811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801815:	48 83 e8 01          	sub    $0x1,%rax
}
  801819:	c9                   	leaveq 
  80181a:	c3                   	retq   
	...

000000000080181c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80181c:	55                   	push   %rbp
  80181d:	48 89 e5             	mov    %rsp,%rbp
  801820:	53                   	push   %rbx
  801821:	48 83 ec 58          	sub    $0x58,%rsp
  801825:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801828:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80182b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80182f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801833:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801837:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80183e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801841:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801845:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801849:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80184d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801851:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801855:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801858:	4c 89 c3             	mov    %r8,%rbx
  80185b:	cd 30                	int    $0x30
  80185d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801861:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801865:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801869:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80186d:	74 3e                	je     8018ad <syscall+0x91>
  80186f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801874:	7e 37                	jle    8018ad <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801876:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80187a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80187d:	49 89 d0             	mov    %rdx,%r8
  801880:	89 c1                	mov    %eax,%ecx
  801882:	48 ba e0 48 80 00 00 	movabs $0x8048e0,%rdx
  801889:	00 00 00 
  80188c:	be 23 00 00 00       	mov    $0x23,%esi
  801891:	48 bf fd 48 80 00 00 	movabs $0x8048fd,%rdi
  801898:	00 00 00 
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a0:	49 b9 d0 3a 80 00 00 	movabs $0x803ad0,%r9
  8018a7:	00 00 00 
  8018aa:	41 ff d1             	callq  *%r9

	return ret;
  8018ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018b1:	48 83 c4 58          	add    $0x58,%rsp
  8018b5:	5b                   	pop    %rbx
  8018b6:	5d                   	pop    %rbp
  8018b7:	c3                   	retq   

00000000008018b8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018b8:	55                   	push   %rbp
  8018b9:	48 89 e5             	mov    %rsp,%rbp
  8018bc:	48 83 ec 20          	sub    $0x20,%rsp
  8018c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d7:	00 
  8018d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e4:	48 89 d1             	mov    %rdx,%rcx
  8018e7:	48 89 c2             	mov    %rax,%rdx
  8018ea:	be 00 00 00 00       	mov    $0x0,%esi
  8018ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8018f4:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  8018fb:	00 00 00 
  8018fe:	ff d0                	callq  *%rax
}
  801900:	c9                   	leaveq 
  801901:	c3                   	retq   

0000000000801902 <sys_cgetc>:

int
sys_cgetc(void)
{
  801902:	55                   	push   %rbp
  801903:	48 89 e5             	mov    %rsp,%rbp
  801906:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80190a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801911:	00 
  801912:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801918:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80191e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801923:	ba 00 00 00 00       	mov    $0x0,%edx
  801928:	be 00 00 00 00       	mov    $0x0,%esi
  80192d:	bf 01 00 00 00       	mov    $0x1,%edi
  801932:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801939:	00 00 00 
  80193c:	ff d0                	callq  *%rax
}
  80193e:	c9                   	leaveq 
  80193f:	c3                   	retq   

0000000000801940 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801940:	55                   	push   %rbp
  801941:	48 89 e5             	mov    %rsp,%rbp
  801944:	48 83 ec 20          	sub    $0x20,%rsp
  801948:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80194b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194e:	48 98                	cltq   
  801950:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801957:	00 
  801958:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801964:	b9 00 00 00 00       	mov    $0x0,%ecx
  801969:	48 89 c2             	mov    %rax,%rdx
  80196c:	be 01 00 00 00       	mov    $0x1,%esi
  801971:	bf 03 00 00 00       	mov    $0x3,%edi
  801976:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  80197d:	00 00 00 
  801980:	ff d0                	callq  *%rax
}
  801982:	c9                   	leaveq 
  801983:	c3                   	retq   

0000000000801984 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801984:	55                   	push   %rbp
  801985:	48 89 e5             	mov    %rsp,%rbp
  801988:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80198c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801993:	00 
  801994:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019aa:	be 00 00 00 00       	mov    $0x0,%esi
  8019af:	bf 02 00 00 00       	mov    $0x2,%edi
  8019b4:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  8019bb:	00 00 00 
  8019be:	ff d0                	callq  *%rax
}
  8019c0:	c9                   	leaveq 
  8019c1:	c3                   	retq   

00000000008019c2 <sys_yield>:

void
sys_yield(void)
{
  8019c2:	55                   	push   %rbp
  8019c3:	48 89 e5             	mov    %rsp,%rbp
  8019c6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019ca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d1:	00 
  8019d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e8:	be 00 00 00 00       	mov    $0x0,%esi
  8019ed:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019f2:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  8019f9:	00 00 00 
  8019fc:	ff d0                	callq  *%rax
}
  8019fe:	c9                   	leaveq 
  8019ff:	c3                   	retq   

0000000000801a00 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 20          	sub    $0x20,%rsp
  801a08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a0f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a15:	48 63 c8             	movslq %eax,%rcx
  801a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1f:	48 98                	cltq   
  801a21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a28:	00 
  801a29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2f:	49 89 c8             	mov    %rcx,%r8
  801a32:	48 89 d1             	mov    %rdx,%rcx
  801a35:	48 89 c2             	mov    %rax,%rdx
  801a38:	be 01 00 00 00       	mov    $0x1,%esi
  801a3d:	bf 04 00 00 00       	mov    $0x4,%edi
  801a42:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801a49:	00 00 00 
  801a4c:	ff d0                	callq  *%rax
}
  801a4e:	c9                   	leaveq 
  801a4f:	c3                   	retq   

0000000000801a50 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a50:	55                   	push   %rbp
  801a51:	48 89 e5             	mov    %rsp,%rbp
  801a54:	48 83 ec 30          	sub    $0x30,%rsp
  801a58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a5f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a62:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a66:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a6a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a6d:	48 63 c8             	movslq %eax,%rcx
  801a70:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a77:	48 63 f0             	movslq %eax,%rsi
  801a7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a81:	48 98                	cltq   
  801a83:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a87:	49 89 f9             	mov    %rdi,%r9
  801a8a:	49 89 f0             	mov    %rsi,%r8
  801a8d:	48 89 d1             	mov    %rdx,%rcx
  801a90:	48 89 c2             	mov    %rax,%rdx
  801a93:	be 01 00 00 00       	mov    $0x1,%esi
  801a98:	bf 05 00 00 00       	mov    $0x5,%edi
  801a9d:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	callq  *%rax
}
  801aa9:	c9                   	leaveq 
  801aaa:	c3                   	retq   

0000000000801aab <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801aab:	55                   	push   %rbp
  801aac:	48 89 e5             	mov    %rsp,%rbp
  801aaf:	48 83 ec 20          	sub    $0x20,%rsp
  801ab3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801aba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac1:	48 98                	cltq   
  801ac3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aca:	00 
  801acb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad7:	48 89 d1             	mov    %rdx,%rcx
  801ada:	48 89 c2             	mov    %rax,%rdx
  801add:	be 01 00 00 00       	mov    $0x1,%esi
  801ae2:	bf 06 00 00 00       	mov    $0x6,%edi
  801ae7:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
}
  801af3:	c9                   	leaveq 
  801af4:	c3                   	retq   

0000000000801af5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	48 83 ec 20          	sub    $0x20,%rsp
  801afd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b00:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b06:	48 63 d0             	movslq %eax,%rdx
  801b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b0c:	48 98                	cltq   
  801b0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b15:	00 
  801b16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b22:	48 89 d1             	mov    %rdx,%rcx
  801b25:	48 89 c2             	mov    %rax,%rdx
  801b28:	be 01 00 00 00       	mov    $0x1,%esi
  801b2d:	bf 08 00 00 00       	mov    $0x8,%edi
  801b32:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801b39:	00 00 00 
  801b3c:	ff d0                	callq  *%rax
}
  801b3e:	c9                   	leaveq 
  801b3f:	c3                   	retq   

0000000000801b40 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b40:	55                   	push   %rbp
  801b41:	48 89 e5             	mov    %rsp,%rbp
  801b44:	48 83 ec 20          	sub    $0x20,%rsp
  801b48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b56:	48 98                	cltq   
  801b58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5f:	00 
  801b60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6c:	48 89 d1             	mov    %rdx,%rcx
  801b6f:	48 89 c2             	mov    %rax,%rdx
  801b72:	be 01 00 00 00       	mov    $0x1,%esi
  801b77:	bf 09 00 00 00       	mov    $0x9,%edi
  801b7c:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801b83:	00 00 00 
  801b86:	ff d0                	callq  *%rax
}
  801b88:	c9                   	leaveq 
  801b89:	c3                   	retq   

0000000000801b8a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b8a:	55                   	push   %rbp
  801b8b:	48 89 e5             	mov    %rsp,%rbp
  801b8e:	48 83 ec 20          	sub    $0x20,%rsp
  801b92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba0:	48 98                	cltq   
  801ba2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba9:	00 
  801baa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb6:	48 89 d1             	mov    %rdx,%rcx
  801bb9:	48 89 c2             	mov    %rax,%rdx
  801bbc:	be 01 00 00 00       	mov    $0x1,%esi
  801bc1:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bc6:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801bcd:	00 00 00 
  801bd0:	ff d0                	callq  *%rax
}
  801bd2:	c9                   	leaveq 
  801bd3:	c3                   	retq   

0000000000801bd4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bd4:	55                   	push   %rbp
  801bd5:	48 89 e5             	mov    %rsp,%rbp
  801bd8:	48 83 ec 30          	sub    $0x30,%rsp
  801bdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801be3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801be7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bed:	48 63 f0             	movslq %eax,%rsi
  801bf0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf7:	48 98                	cltq   
  801bf9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c04:	00 
  801c05:	49 89 f1             	mov    %rsi,%r9
  801c08:	49 89 c8             	mov    %rcx,%r8
  801c0b:	48 89 d1             	mov    %rdx,%rcx
  801c0e:	48 89 c2             	mov    %rax,%rdx
  801c11:	be 00 00 00 00       	mov    $0x0,%esi
  801c16:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c1b:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	callq  *%rax
}
  801c27:	c9                   	leaveq 
  801c28:	c3                   	retq   

0000000000801c29 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c29:	55                   	push   %rbp
  801c2a:	48 89 e5             	mov    %rsp,%rbp
  801c2d:	48 83 ec 20          	sub    $0x20,%rsp
  801c31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c40:	00 
  801c41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c52:	48 89 c2             	mov    %rax,%rdx
  801c55:	be 01 00 00 00       	mov    $0x1,%esi
  801c5a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c5f:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801c66:	00 00 00 
  801c69:	ff d0                	callq  *%rax
}
  801c6b:	c9                   	leaveq 
  801c6c:	c3                   	retq   

0000000000801c6d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c6d:	55                   	push   %rbp
  801c6e:	48 89 e5             	mov    %rsp,%rbp
  801c71:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7c:	00 
  801c7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c93:	be 00 00 00 00       	mov    $0x0,%esi
  801c98:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c9d:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801ca4:	00 00 00 
  801ca7:	ff d0                	callq  *%rax
}
  801ca9:	c9                   	leaveq 
  801caa:	c3                   	retq   

0000000000801cab <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801cab:	55                   	push   %rbp
  801cac:	48 89 e5             	mov    %rsp,%rbp
  801caf:	48 83 ec 20          	sub    $0x20,%rsp
  801cb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cca:	00 
  801ccb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd7:	48 89 d1             	mov    %rdx,%rcx
  801cda:	48 89 c2             	mov    %rax,%rdx
  801cdd:	be 00 00 00 00       	mov    $0x0,%esi
  801ce2:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ce7:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801cee:	00 00 00 
  801cf1:	ff d0                	callq  *%rax
}
  801cf3:	c9                   	leaveq 
  801cf4:	c3                   	retq   

0000000000801cf5 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801cf5:	55                   	push   %rbp
  801cf6:	48 89 e5             	mov    %rsp,%rbp
  801cf9:	48 83 ec 20          	sub    $0x20,%rsp
  801cfd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d14:	00 
  801d15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d21:	48 89 d1             	mov    %rdx,%rcx
  801d24:	48 89 c2             	mov    %rax,%rdx
  801d27:	be 00 00 00 00       	mov    $0x0,%esi
  801d2c:	bf 10 00 00 00       	mov    $0x10,%edi
  801d31:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801d38:	00 00 00 
  801d3b:	ff d0                	callq  *%rax
}
  801d3d:	c9                   	leaveq 
  801d3e:	c3                   	retq   
	...

0000000000801d40 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d40:	55                   	push   %rbp
  801d41:	48 89 e5             	mov    %rsp,%rbp
  801d44:	48 83 ec 08          	sub    $0x8,%rsp
  801d48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d4c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d50:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d57:	ff ff ff 
  801d5a:	48 01 d0             	add    %rdx,%rax
  801d5d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 08          	sub    $0x8,%rsp
  801d6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d73:	48 89 c7             	mov    %rax,%rdi
  801d76:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	callq  *%rax
  801d82:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d88:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d8c:	c9                   	leaveq 
  801d8d:	c3                   	retq   

0000000000801d8e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d8e:	55                   	push   %rbp
  801d8f:	48 89 e5             	mov    %rsp,%rbp
  801d92:	48 83 ec 18          	sub    $0x18,%rsp
  801d96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801da1:	eb 6b                	jmp    801e0e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801da3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da6:	48 98                	cltq   
  801da8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dae:	48 c1 e0 0c          	shl    $0xc,%rax
  801db2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801db6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dba:	48 89 c2             	mov    %rax,%rdx
  801dbd:	48 c1 ea 15          	shr    $0x15,%rdx
  801dc1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dc8:	01 00 00 
  801dcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dcf:	83 e0 01             	and    $0x1,%eax
  801dd2:	48 85 c0             	test   %rax,%rax
  801dd5:	74 21                	je     801df8 <fd_alloc+0x6a>
  801dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddb:	48 89 c2             	mov    %rax,%rdx
  801dde:	48 c1 ea 0c          	shr    $0xc,%rdx
  801de2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801de9:	01 00 00 
  801dec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df0:	83 e0 01             	and    $0x1,%eax
  801df3:	48 85 c0             	test   %rax,%rax
  801df6:	75 12                	jne    801e0a <fd_alloc+0x7c>
			*fd_store = fd;
  801df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e00:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
  801e08:	eb 1a                	jmp    801e24 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e0a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e0e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e12:	7e 8f                	jle    801da3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e18:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e1f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e24:	c9                   	leaveq 
  801e25:	c3                   	retq   

0000000000801e26 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e26:	55                   	push   %rbp
  801e27:	48 89 e5             	mov    %rsp,%rbp
  801e2a:	48 83 ec 20          	sub    $0x20,%rsp
  801e2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e35:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e39:	78 06                	js     801e41 <fd_lookup+0x1b>
  801e3b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e3f:	7e 07                	jle    801e48 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e46:	eb 6c                	jmp    801eb4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e4b:	48 98                	cltq   
  801e4d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e53:	48 c1 e0 0c          	shl    $0xc,%rax
  801e57:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5f:	48 89 c2             	mov    %rax,%rdx
  801e62:	48 c1 ea 15          	shr    $0x15,%rdx
  801e66:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e6d:	01 00 00 
  801e70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e74:	83 e0 01             	and    $0x1,%eax
  801e77:	48 85 c0             	test   %rax,%rax
  801e7a:	74 21                	je     801e9d <fd_lookup+0x77>
  801e7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e80:	48 89 c2             	mov    %rax,%rdx
  801e83:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e87:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e8e:	01 00 00 
  801e91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e95:	83 e0 01             	and    $0x1,%eax
  801e98:	48 85 c0             	test   %rax,%rax
  801e9b:	75 07                	jne    801ea4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ea2:	eb 10                	jmp    801eb4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ea4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ea8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eac:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb4:	c9                   	leaveq 
  801eb5:	c3                   	retq   

0000000000801eb6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801eb6:	55                   	push   %rbp
  801eb7:	48 89 e5             	mov    %rsp,%rbp
  801eba:	48 83 ec 30          	sub    $0x30,%rsp
  801ebe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ec2:	89 f0                	mov    %esi,%eax
  801ec4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ec7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ecb:	48 89 c7             	mov    %rax,%rdi
  801ece:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  801ed5:	00 00 00 
  801ed8:	ff d0                	callq  *%rax
  801eda:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ede:	48 89 d6             	mov    %rdx,%rsi
  801ee1:	89 c7                	mov    %eax,%edi
  801ee3:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	callq  *%rax
  801eef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ef2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ef6:	78 0a                	js     801f02 <fd_close+0x4c>
	    || fd != fd2)
  801ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f00:	74 12                	je     801f14 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f02:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f06:	74 05                	je     801f0d <fd_close+0x57>
  801f08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0b:	eb 05                	jmp    801f12 <fd_close+0x5c>
  801f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f12:	eb 69                	jmp    801f7d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f18:	8b 00                	mov    (%rax),%eax
  801f1a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f1e:	48 89 d6             	mov    %rdx,%rsi
  801f21:	89 c7                	mov    %eax,%edi
  801f23:	48 b8 7f 1f 80 00 00 	movabs $0x801f7f,%rax
  801f2a:	00 00 00 
  801f2d:	ff d0                	callq  *%rax
  801f2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f36:	78 2a                	js     801f62 <fd_close+0xac>
		if (dev->dev_close)
  801f38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f3c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f40:	48 85 c0             	test   %rax,%rax
  801f43:	74 16                	je     801f5b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f49:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f51:	48 89 c7             	mov    %rax,%rdi
  801f54:	ff d2                	callq  *%rdx
  801f56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f59:	eb 07                	jmp    801f62 <fd_close+0xac>
		else
			r = 0;
  801f5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f66:	48 89 c6             	mov    %rax,%rsi
  801f69:	bf 00 00 00 00       	mov    $0x0,%edi
  801f6e:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
	return r;
  801f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f7d:	c9                   	leaveq 
  801f7e:	c3                   	retq   

0000000000801f7f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f7f:	55                   	push   %rbp
  801f80:	48 89 e5             	mov    %rsp,%rbp
  801f83:	48 83 ec 20          	sub    $0x20,%rsp
  801f87:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f95:	eb 41                	jmp    801fd8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f97:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f9e:	00 00 00 
  801fa1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fa4:	48 63 d2             	movslq %edx,%rdx
  801fa7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fab:	8b 00                	mov    (%rax),%eax
  801fad:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fb0:	75 22                	jne    801fd4 <dev_lookup+0x55>
			*dev = devtab[i];
  801fb2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fb9:	00 00 00 
  801fbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fbf:	48 63 d2             	movslq %edx,%rdx
  801fc2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fca:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	eb 60                	jmp    802034 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fd4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fd8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fdf:	00 00 00 
  801fe2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fe5:	48 63 d2             	movslq %edx,%rdx
  801fe8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fec:	48 85 c0             	test   %rax,%rax
  801fef:	75 a6                	jne    801f97 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ff1:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  801ff8:	00 00 00 
  801ffb:	48 8b 00             	mov    (%rax),%rax
  801ffe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802004:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802007:	89 c6                	mov    %eax,%esi
  802009:	48 bf 10 49 80 00 00 	movabs $0x804910,%rdi
  802010:	00 00 00 
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
  802018:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  80201f:	00 00 00 
  802022:	ff d1                	callq  *%rcx
	*dev = 0;
  802024:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802028:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80202f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802034:	c9                   	leaveq 
  802035:	c3                   	retq   

0000000000802036 <close>:

int
close(int fdnum)
{
  802036:	55                   	push   %rbp
  802037:	48 89 e5             	mov    %rsp,%rbp
  80203a:	48 83 ec 20          	sub    $0x20,%rsp
  80203e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802041:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802045:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802048:	48 89 d6             	mov    %rdx,%rsi
  80204b:	89 c7                	mov    %eax,%edi
  80204d:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  802054:	00 00 00 
  802057:	ff d0                	callq  *%rax
  802059:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80205c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802060:	79 05                	jns    802067 <close+0x31>
		return r;
  802062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802065:	eb 18                	jmp    80207f <close+0x49>
	else
		return fd_close(fd, 1);
  802067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80206b:	be 01 00 00 00       	mov    $0x1,%esi
  802070:	48 89 c7             	mov    %rax,%rdi
  802073:	48 b8 b6 1e 80 00 00 	movabs $0x801eb6,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	callq  *%rax
}
  80207f:	c9                   	leaveq 
  802080:	c3                   	retq   

0000000000802081 <close_all>:

void
close_all(void)
{
  802081:	55                   	push   %rbp
  802082:	48 89 e5             	mov    %rsp,%rbp
  802085:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802089:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802090:	eb 15                	jmp    8020a7 <close_all+0x26>
		close(i);
  802092:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802095:	89 c7                	mov    %eax,%edi
  802097:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020a7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020ab:	7e e5                	jle    802092 <close_all+0x11>
		close(i);
}
  8020ad:	c9                   	leaveq 
  8020ae:	c3                   	retq   

00000000008020af <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020af:	55                   	push   %rbp
  8020b0:	48 89 e5             	mov    %rsp,%rbp
  8020b3:	48 83 ec 40          	sub    $0x40,%rsp
  8020b7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020ba:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020bd:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020c1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020c4:	48 89 d6             	mov    %rdx,%rsi
  8020c7:	89 c7                	mov    %eax,%edi
  8020c9:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	callq  *%rax
  8020d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020dc:	79 08                	jns    8020e6 <dup+0x37>
		return r;
  8020de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e1:	e9 70 01 00 00       	jmpq   802256 <dup+0x1a7>
	close(newfdnum);
  8020e6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020e9:	89 c7                	mov    %eax,%edi
  8020eb:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  8020f2:	00 00 00 
  8020f5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020f7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020fa:	48 98                	cltq   
  8020fc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802102:	48 c1 e0 0c          	shl    $0xc,%rax
  802106:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80210a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210e:	48 89 c7             	mov    %rax,%rdi
  802111:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  802118:	00 00 00 
  80211b:	ff d0                	callq  *%rax
  80211d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802125:	48 89 c7             	mov    %rax,%rdi
  802128:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  80212f:	00 00 00 
  802132:	ff d0                	callq  *%rax
  802134:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213c:	48 89 c2             	mov    %rax,%rdx
  80213f:	48 c1 ea 15          	shr    $0x15,%rdx
  802143:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80214a:	01 00 00 
  80214d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802151:	83 e0 01             	and    $0x1,%eax
  802154:	84 c0                	test   %al,%al
  802156:	74 71                	je     8021c9 <dup+0x11a>
  802158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215c:	48 89 c2             	mov    %rax,%rdx
  80215f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802163:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80216a:	01 00 00 
  80216d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802171:	83 e0 01             	and    $0x1,%eax
  802174:	84 c0                	test   %al,%al
  802176:	74 51                	je     8021c9 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217c:	48 89 c2             	mov    %rax,%rdx
  80217f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802183:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80218a:	01 00 00 
  80218d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802191:	89 c1                	mov    %eax,%ecx
  802193:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802199:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80219d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a1:	41 89 c8             	mov    %ecx,%r8d
  8021a4:	48 89 d1             	mov    %rdx,%rcx
  8021a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ac:	48 89 c6             	mov    %rax,%rsi
  8021af:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b4:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  8021bb:	00 00 00 
  8021be:	ff d0                	callq  *%rax
  8021c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c7:	78 56                	js     80221f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cd:	48 89 c2             	mov    %rax,%rdx
  8021d0:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021db:	01 00 00 
  8021de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e2:	89 c1                	mov    %eax,%ecx
  8021e4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f2:	41 89 c8             	mov    %ecx,%r8d
  8021f5:	48 89 d1             	mov    %rdx,%rcx
  8021f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021fd:	48 89 c6             	mov    %rax,%rsi
  802200:	bf 00 00 00 00       	mov    $0x0,%edi
  802205:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  80220c:	00 00 00 
  80220f:	ff d0                	callq  *%rax
  802211:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802214:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802218:	78 08                	js     802222 <dup+0x173>
		goto err;

	return newfdnum;
  80221a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80221d:	eb 37                	jmp    802256 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80221f:	90                   	nop
  802220:	eb 01                	jmp    802223 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802222:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802227:	48 89 c6             	mov    %rax,%rsi
  80222a:	bf 00 00 00 00       	mov    $0x0,%edi
  80222f:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  802236:	00 00 00 
  802239:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80223b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80223f:	48 89 c6             	mov    %rax,%rsi
  802242:	bf 00 00 00 00       	mov    $0x0,%edi
  802247:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  80224e:	00 00 00 
  802251:	ff d0                	callq  *%rax
	return r;
  802253:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802256:	c9                   	leaveq 
  802257:	c3                   	retq   

0000000000802258 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802258:	55                   	push   %rbp
  802259:	48 89 e5             	mov    %rsp,%rbp
  80225c:	48 83 ec 40          	sub    $0x40,%rsp
  802260:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802263:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802267:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80226b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80226f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802272:	48 89 d6             	mov    %rdx,%rsi
  802275:	89 c7                	mov    %eax,%edi
  802277:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  80227e:	00 00 00 
  802281:	ff d0                	callq  *%rax
  802283:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802286:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80228a:	78 24                	js     8022b0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80228c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802290:	8b 00                	mov    (%rax),%eax
  802292:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802296:	48 89 d6             	mov    %rdx,%rsi
  802299:	89 c7                	mov    %eax,%edi
  80229b:	48 b8 7f 1f 80 00 00 	movabs $0x801f7f,%rax
  8022a2:	00 00 00 
  8022a5:	ff d0                	callq  *%rax
  8022a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ae:	79 05                	jns    8022b5 <read+0x5d>
		return r;
  8022b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b3:	eb 7a                	jmp    80232f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b9:	8b 40 08             	mov    0x8(%rax),%eax
  8022bc:	83 e0 03             	and    $0x3,%eax
  8022bf:	83 f8 01             	cmp    $0x1,%eax
  8022c2:	75 3a                	jne    8022fe <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022c4:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  8022cb:	00 00 00 
  8022ce:	48 8b 00             	mov    (%rax),%rax
  8022d1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022d7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022da:	89 c6                	mov    %eax,%esi
  8022dc:	48 bf 2f 49 80 00 00 	movabs $0x80492f,%rdi
  8022e3:	00 00 00 
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022eb:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  8022f2:	00 00 00 
  8022f5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022fc:	eb 31                	jmp    80232f <read+0xd7>
	}
	if (!dev->dev_read)
  8022fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802302:	48 8b 40 10          	mov    0x10(%rax),%rax
  802306:	48 85 c0             	test   %rax,%rax
  802309:	75 07                	jne    802312 <read+0xba>
		return -E_NOT_SUPP;
  80230b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802310:	eb 1d                	jmp    80232f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802316:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80231a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802322:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802326:	48 89 ce             	mov    %rcx,%rsi
  802329:	48 89 c7             	mov    %rax,%rdi
  80232c:	41 ff d0             	callq  *%r8
}
  80232f:	c9                   	leaveq 
  802330:	c3                   	retq   

0000000000802331 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802331:	55                   	push   %rbp
  802332:	48 89 e5             	mov    %rsp,%rbp
  802335:	48 83 ec 30          	sub    $0x30,%rsp
  802339:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80233c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802340:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802344:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80234b:	eb 46                	jmp    802393 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80234d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802350:	48 98                	cltq   
  802352:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802356:	48 29 c2             	sub    %rax,%rdx
  802359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235c:	48 98                	cltq   
  80235e:	48 89 c1             	mov    %rax,%rcx
  802361:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802365:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802368:	48 89 ce             	mov    %rcx,%rsi
  80236b:	89 c7                	mov    %eax,%edi
  80236d:	48 b8 58 22 80 00 00 	movabs $0x802258,%rax
  802374:	00 00 00 
  802377:	ff d0                	callq  *%rax
  802379:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80237c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802380:	79 05                	jns    802387 <readn+0x56>
			return m;
  802382:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802385:	eb 1d                	jmp    8023a4 <readn+0x73>
		if (m == 0)
  802387:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80238b:	74 13                	je     8023a0 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80238d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802390:	01 45 fc             	add    %eax,-0x4(%rbp)
  802393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802396:	48 98                	cltq   
  802398:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80239c:	72 af                	jb     80234d <readn+0x1c>
  80239e:	eb 01                	jmp    8023a1 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023a0:	90                   	nop
	}
	return tot;
  8023a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a4:	c9                   	leaveq 
  8023a5:	c3                   	retq   

00000000008023a6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023a6:	55                   	push   %rbp
  8023a7:	48 89 e5             	mov    %rsp,%rbp
  8023aa:	48 83 ec 40          	sub    $0x40,%rsp
  8023ae:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023b9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c0:	48 89 d6             	mov    %rdx,%rsi
  8023c3:	89 c7                	mov    %eax,%edi
  8023c5:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  8023cc:	00 00 00 
  8023cf:	ff d0                	callq  *%rax
  8023d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d8:	78 24                	js     8023fe <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023de:	8b 00                	mov    (%rax),%eax
  8023e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e4:	48 89 d6             	mov    %rdx,%rsi
  8023e7:	89 c7                	mov    %eax,%edi
  8023e9:	48 b8 7f 1f 80 00 00 	movabs $0x801f7f,%rax
  8023f0:	00 00 00 
  8023f3:	ff d0                	callq  *%rax
  8023f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fc:	79 05                	jns    802403 <write+0x5d>
		return r;
  8023fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802401:	eb 79                	jmp    80247c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802407:	8b 40 08             	mov    0x8(%rax),%eax
  80240a:	83 e0 03             	and    $0x3,%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	75 3a                	jne    80244b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802411:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802418:	00 00 00 
  80241b:	48 8b 00             	mov    (%rax),%rax
  80241e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802424:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802427:	89 c6                	mov    %eax,%esi
  802429:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
  802430:	00 00 00 
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  80243f:	00 00 00 
  802442:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802444:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802449:	eb 31                	jmp    80247c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802453:	48 85 c0             	test   %rax,%rax
  802456:	75 07                	jne    80245f <write+0xb9>
		return -E_NOT_SUPP;
  802458:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80245d:	eb 1d                	jmp    80247c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80245f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802463:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80246b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80246f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802473:	48 89 ce             	mov    %rcx,%rsi
  802476:	48 89 c7             	mov    %rax,%rdi
  802479:	41 ff d0             	callq  *%r8
}
  80247c:	c9                   	leaveq 
  80247d:	c3                   	retq   

000000000080247e <seek>:

int
seek(int fdnum, off_t offset)
{
  80247e:	55                   	push   %rbp
  80247f:	48 89 e5             	mov    %rsp,%rbp
  802482:	48 83 ec 18          	sub    $0x18,%rsp
  802486:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802489:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802490:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802493:	48 89 d6             	mov    %rdx,%rsi
  802496:	89 c7                	mov    %eax,%edi
  802498:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax
  8024a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ab:	79 05                	jns    8024b2 <seek+0x34>
		return r;
  8024ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b0:	eb 0f                	jmp    8024c1 <seek+0x43>
	fd->fd_offset = offset;
  8024b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024b9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c1:	c9                   	leaveq 
  8024c2:	c3                   	retq   

00000000008024c3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024c3:	55                   	push   %rbp
  8024c4:	48 89 e5             	mov    %rsp,%rbp
  8024c7:	48 83 ec 30          	sub    $0x30,%rsp
  8024cb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ce:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024d8:	48 89 d6             	mov    %rdx,%rsi
  8024db:	89 c7                	mov    %eax,%edi
  8024dd:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  8024e4:	00 00 00 
  8024e7:	ff d0                	callq  *%rax
  8024e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f0:	78 24                	js     802516 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f6:	8b 00                	mov    (%rax),%eax
  8024f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024fc:	48 89 d6             	mov    %rdx,%rsi
  8024ff:	89 c7                	mov    %eax,%edi
  802501:	48 b8 7f 1f 80 00 00 	movabs $0x801f7f,%rax
  802508:	00 00 00 
  80250b:	ff d0                	callq  *%rax
  80250d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802510:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802514:	79 05                	jns    80251b <ftruncate+0x58>
		return r;
  802516:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802519:	eb 72                	jmp    80258d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80251b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251f:	8b 40 08             	mov    0x8(%rax),%eax
  802522:	83 e0 03             	and    $0x3,%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	75 3a                	jne    802563 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802529:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802530:	00 00 00 
  802533:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802536:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80253c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80253f:	89 c6                	mov    %eax,%esi
  802541:	48 bf 68 49 80 00 00 	movabs $0x804968,%rdi
  802548:	00 00 00 
  80254b:	b8 00 00 00 00       	mov    $0x0,%eax
  802550:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  802557:	00 00 00 
  80255a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80255c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802561:	eb 2a                	jmp    80258d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802567:	48 8b 40 30          	mov    0x30(%rax),%rax
  80256b:	48 85 c0             	test   %rax,%rax
  80256e:	75 07                	jne    802577 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802570:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802575:	eb 16                	jmp    80258d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80257f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802583:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802586:	89 d6                	mov    %edx,%esi
  802588:	48 89 c7             	mov    %rax,%rdi
  80258b:	ff d1                	callq  *%rcx
}
  80258d:	c9                   	leaveq 
  80258e:	c3                   	retq   

000000000080258f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80258f:	55                   	push   %rbp
  802590:	48 89 e5             	mov    %rsp,%rbp
  802593:	48 83 ec 30          	sub    $0x30,%rsp
  802597:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80259a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80259e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025a5:	48 89 d6             	mov    %rdx,%rsi
  8025a8:	89 c7                	mov    %eax,%edi
  8025aa:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  8025b1:	00 00 00 
  8025b4:	ff d0                	callq  *%rax
  8025b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025bd:	78 24                	js     8025e3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c3:	8b 00                	mov    (%rax),%eax
  8025c5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c9:	48 89 d6             	mov    %rdx,%rsi
  8025cc:	89 c7                	mov    %eax,%edi
  8025ce:	48 b8 7f 1f 80 00 00 	movabs $0x801f7f,%rax
  8025d5:	00 00 00 
  8025d8:	ff d0                	callq  *%rax
  8025da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e1:	79 05                	jns    8025e8 <fstat+0x59>
		return r;
  8025e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e6:	eb 5e                	jmp    802646 <fstat+0xb7>
	if (!dev->dev_stat)
  8025e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ec:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025f0:	48 85 c0             	test   %rax,%rax
  8025f3:	75 07                	jne    8025fc <fstat+0x6d>
		return -E_NOT_SUPP;
  8025f5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025fa:	eb 4a                	jmp    802646 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802600:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802603:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802607:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80260e:	00 00 00 
	stat->st_isdir = 0;
  802611:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802615:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80261c:	00 00 00 
	stat->st_dev = dev;
  80261f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802623:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802627:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80262e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802632:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80263e:	48 89 d6             	mov    %rdx,%rsi
  802641:	48 89 c7             	mov    %rax,%rdi
  802644:	ff d1                	callq  *%rcx
}
  802646:	c9                   	leaveq 
  802647:	c3                   	retq   

0000000000802648 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802648:	55                   	push   %rbp
  802649:	48 89 e5             	mov    %rsp,%rbp
  80264c:	48 83 ec 20          	sub    $0x20,%rsp
  802650:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802654:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265c:	be 00 00 00 00       	mov    $0x0,%esi
  802661:	48 89 c7             	mov    %rax,%rdi
  802664:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  80266b:	00 00 00 
  80266e:	ff d0                	callq  *%rax
  802670:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802673:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802677:	79 05                	jns    80267e <stat+0x36>
		return fd;
  802679:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267c:	eb 2f                	jmp    8026ad <stat+0x65>
	r = fstat(fd, stat);
  80267e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802682:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802685:	48 89 d6             	mov    %rdx,%rsi
  802688:	89 c7                	mov    %eax,%edi
  80268a:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802691:	00 00 00 
  802694:	ff d0                	callq  *%rax
  802696:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802699:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269c:	89 c7                	mov    %eax,%edi
  80269e:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  8026a5:	00 00 00 
  8026a8:	ff d0                	callq  *%rax
	return r;
  8026aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026ad:	c9                   	leaveq 
  8026ae:	c3                   	retq   
	...

00000000008026b0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026b0:	55                   	push   %rbp
  8026b1:	48 89 e5             	mov    %rsp,%rbp
  8026b4:	48 83 ec 10          	sub    $0x10,%rsp
  8026b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026bf:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  8026c6:	00 00 00 
  8026c9:	8b 00                	mov    (%rax),%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	75 1d                	jne    8026ec <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026cf:	bf 01 00 00 00       	mov    $0x1,%edi
  8026d4:	48 b8 67 3d 80 00 00 	movabs $0x803d67,%rax
  8026db:	00 00 00 
  8026de:	ff d0                	callq  *%rax
  8026e0:	48 ba 1c 70 80 00 00 	movabs $0x80701c,%rdx
  8026e7:	00 00 00 
  8026ea:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026ec:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  8026f3:	00 00 00 
  8026f6:	8b 00                	mov    (%rax),%eax
  8026f8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026fb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802700:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802707:	00 00 00 
  80270a:	89 c7                	mov    %eax,%edi
  80270c:	48 b8 a4 3c 80 00 00 	movabs $0x803ca4,%rax
  802713:	00 00 00 
  802716:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271c:	ba 00 00 00 00       	mov    $0x0,%edx
  802721:	48 89 c6             	mov    %rax,%rsi
  802724:	bf 00 00 00 00       	mov    $0x0,%edi
  802729:	48 b8 e4 3b 80 00 00 	movabs $0x803be4,%rax
  802730:	00 00 00 
  802733:	ff d0                	callq  *%rax
}
  802735:	c9                   	leaveq 
  802736:	c3                   	retq   

0000000000802737 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802737:	55                   	push   %rbp
  802738:	48 89 e5             	mov    %rsp,%rbp
  80273b:	48 83 ec 20          	sub    $0x20,%rsp
  80273f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802743:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274a:	48 89 c7             	mov    %rax,%rdi
  80274d:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  802754:	00 00 00 
  802757:	ff d0                	callq  *%rax
  802759:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80275e:	7e 0a                	jle    80276a <open+0x33>
                return -E_BAD_PATH;
  802760:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802765:	e9 a5 00 00 00       	jmpq   80280f <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80276a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80276e:	48 89 c7             	mov    %rax,%rdi
  802771:	48 b8 8e 1d 80 00 00 	movabs $0x801d8e,%rax
  802778:	00 00 00 
  80277b:	ff d0                	callq  *%rax
  80277d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802780:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802784:	79 08                	jns    80278e <open+0x57>
		return r;
  802786:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802789:	e9 81 00 00 00       	jmpq   80280f <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80278e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802792:	48 89 c6             	mov    %rax,%rsi
  802795:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80279c:	00 00 00 
  80279f:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8027ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027b2:	00 00 00 
  8027b5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027b8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8027be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c2:	48 89 c6             	mov    %rax,%rsi
  8027c5:	bf 01 00 00 00       	mov    $0x1,%edi
  8027ca:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
  8027d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8027d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027dd:	79 1d                	jns    8027fc <open+0xc5>
	{
		fd_close(fd,0);
  8027df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e3:	be 00 00 00 00       	mov    $0x0,%esi
  8027e8:	48 89 c7             	mov    %rax,%rdi
  8027eb:	48 b8 b6 1e 80 00 00 	movabs $0x801eb6,%rax
  8027f2:	00 00 00 
  8027f5:	ff d0                	callq  *%rax
		return r;
  8027f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fa:	eb 13                	jmp    80280f <open+0xd8>
	}
	return fd2num(fd);
  8027fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802800:	48 89 c7             	mov    %rax,%rdi
  802803:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  80280a:	00 00 00 
  80280d:	ff d0                	callq  *%rax
	


}
  80280f:	c9                   	leaveq 
  802810:	c3                   	retq   

0000000000802811 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802811:	55                   	push   %rbp
  802812:	48 89 e5             	mov    %rsp,%rbp
  802815:	48 83 ec 10          	sub    $0x10,%rsp
  802819:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80281d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802821:	8b 50 0c             	mov    0xc(%rax),%edx
  802824:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80282b:	00 00 00 
  80282e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802830:	be 00 00 00 00       	mov    $0x0,%esi
  802835:	bf 06 00 00 00       	mov    $0x6,%edi
  80283a:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
}
  802846:	c9                   	leaveq 
  802847:	c3                   	retq   

0000000000802848 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802848:	55                   	push   %rbp
  802849:	48 89 e5             	mov    %rsp,%rbp
  80284c:	48 83 ec 30          	sub    $0x30,%rsp
  802850:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802854:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802858:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80285c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802860:	8b 50 0c             	mov    0xc(%rax),%edx
  802863:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80286a:	00 00 00 
  80286d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80286f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802876:	00 00 00 
  802879:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80287d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802881:	be 00 00 00 00       	mov    $0x0,%esi
  802886:	bf 03 00 00 00       	mov    $0x3,%edi
  80288b:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
  802897:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80289a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289e:	79 05                	jns    8028a5 <devfile_read+0x5d>
	{
		return r;
  8028a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a3:	eb 2c                	jmp    8028d1 <devfile_read+0x89>
	}
	if(r > 0)
  8028a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a9:	7e 23                	jle    8028ce <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8028ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ae:	48 63 d0             	movslq %eax,%rdx
  8028b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028bc:	00 00 00 
  8028bf:	48 89 c7             	mov    %rax,%rdi
  8028c2:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  8028c9:	00 00 00 
  8028cc:	ff d0                	callq  *%rax
	return r;
  8028ce:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8028d1:	c9                   	leaveq 
  8028d2:	c3                   	retq   

00000000008028d3 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028d3:	55                   	push   %rbp
  8028d4:	48 89 e5             	mov    %rsp,%rbp
  8028d7:	48 83 ec 30          	sub    $0x30,%rsp
  8028db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8028e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028eb:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028f5:	00 00 00 
  8028f8:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8028fa:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802901:	00 
  802902:	76 08                	jbe    80290c <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802904:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80290b:	00 
	fsipcbuf.write.req_n=n;
  80290c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802913:	00 00 00 
  802916:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80291a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80291e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802922:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802926:	48 89 c6             	mov    %rax,%rsi
  802929:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802930:	00 00 00 
  802933:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80293f:	be 00 00 00 00       	mov    $0x0,%esi
  802944:	bf 04 00 00 00       	mov    $0x4,%edi
  802949:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  802950:	00 00 00 
  802953:	ff d0                	callq  *%rax
  802955:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802958:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80295b:	c9                   	leaveq 
  80295c:	c3                   	retq   

000000000080295d <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  80295d:	55                   	push   %rbp
  80295e:	48 89 e5             	mov    %rsp,%rbp
  802961:	48 83 ec 10          	sub    $0x10,%rsp
  802965:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802969:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80296c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802970:	8b 50 0c             	mov    0xc(%rax),%edx
  802973:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80297a:	00 00 00 
  80297d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80297f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802986:	00 00 00 
  802989:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80298c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80298f:	be 00 00 00 00       	mov    $0x0,%esi
  802994:	bf 02 00 00 00       	mov    $0x2,%edi
  802999:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  8029a0:	00 00 00 
  8029a3:	ff d0                	callq  *%rax
}
  8029a5:	c9                   	leaveq 
  8029a6:	c3                   	retq   

00000000008029a7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029a7:	55                   	push   %rbp
  8029a8:	48 89 e5             	mov    %rsp,%rbp
  8029ab:	48 83 ec 20          	sub    $0x20,%rsp
  8029af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bb:	8b 50 0c             	mov    0xc(%rax),%edx
  8029be:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029c5:	00 00 00 
  8029c8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029ca:	be 00 00 00 00       	mov    $0x0,%esi
  8029cf:	bf 05 00 00 00       	mov    $0x5,%edi
  8029d4:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  8029db:	00 00 00 
  8029de:	ff d0                	callq  *%rax
  8029e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e7:	79 05                	jns    8029ee <devfile_stat+0x47>
		return r;
  8029e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ec:	eb 56                	jmp    802a44 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029f9:	00 00 00 
  8029fc:	48 89 c7             	mov    %rax,%rdi
  8029ff:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a0b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a12:	00 00 00 
  802a15:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a1f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a25:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a2c:	00 00 00 
  802a2f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a39:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a44:	c9                   	leaveq 
  802a45:	c3                   	retq   
	...

0000000000802a48 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a48:	55                   	push   %rbp
  802a49:	48 89 e5             	mov    %rsp,%rbp
  802a4c:	48 83 ec 20          	sub    $0x20,%rsp
  802a50:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a53:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a57:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a5a:	48 89 d6             	mov    %rdx,%rsi
  802a5d:	89 c7                	mov    %eax,%edi
  802a5f:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	callq  *%rax
  802a6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a72:	79 05                	jns    802a79 <fd2sockid+0x31>
		return r;
  802a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a77:	eb 24                	jmp    802a9d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802a79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a7d:	8b 10                	mov    (%rax),%edx
  802a7f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802a86:	00 00 00 
  802a89:	8b 00                	mov    (%rax),%eax
  802a8b:	39 c2                	cmp    %eax,%edx
  802a8d:	74 07                	je     802a96 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802a8f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a94:	eb 07                	jmp    802a9d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802a9d:	c9                   	leaveq 
  802a9e:	c3                   	retq   

0000000000802a9f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802a9f:	55                   	push   %rbp
  802aa0:	48 89 e5             	mov    %rsp,%rbp
  802aa3:	48 83 ec 20          	sub    $0x20,%rsp
  802aa7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802aaa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802aae:	48 89 c7             	mov    %rax,%rdi
  802ab1:	48 b8 8e 1d 80 00 00 	movabs $0x801d8e,%rax
  802ab8:	00 00 00 
  802abb:	ff d0                	callq  *%rax
  802abd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac4:	78 26                	js     802aec <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802ac6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aca:	ba 07 04 00 00       	mov    $0x407,%edx
  802acf:	48 89 c6             	mov    %rax,%rsi
  802ad2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad7:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  802ade:	00 00 00 
  802ae1:	ff d0                	callq  *%rax
  802ae3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aea:	79 16                	jns    802b02 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802aec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aef:	89 c7                	mov    %eax,%edi
  802af1:	48 b8 ac 2f 80 00 00 	movabs $0x802fac,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
		return r;
  802afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b00:	eb 3a                	jmp    802b3c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802b02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b06:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802b0d:	00 00 00 
  802b10:	8b 12                	mov    (%rdx),%edx
  802b12:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b18:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802b1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b23:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b26:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2d:	48 89 c7             	mov    %rax,%rdi
  802b30:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  802b37:	00 00 00 
  802b3a:	ff d0                	callq  *%rax
}
  802b3c:	c9                   	leaveq 
  802b3d:	c3                   	retq   

0000000000802b3e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b3e:	55                   	push   %rbp
  802b3f:	48 89 e5             	mov    %rsp,%rbp
  802b42:	48 83 ec 30          	sub    $0x30,%rsp
  802b46:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b4d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b51:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b54:	89 c7                	mov    %eax,%edi
  802b56:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802b5d:	00 00 00 
  802b60:	ff d0                	callq  *%rax
  802b62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b69:	79 05                	jns    802b70 <accept+0x32>
		return r;
  802b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6e:	eb 3b                	jmp    802bab <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b70:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b74:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7b:	48 89 ce             	mov    %rcx,%rsi
  802b7e:	89 c7                	mov    %eax,%edi
  802b80:	48 b8 89 2e 80 00 00 	movabs $0x802e89,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
  802b8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b93:	79 05                	jns    802b9a <accept+0x5c>
		return r;
  802b95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b98:	eb 11                	jmp    802bab <accept+0x6d>
	return alloc_sockfd(r);
  802b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9d:	89 c7                	mov    %eax,%edi
  802b9f:	48 b8 9f 2a 80 00 00 	movabs $0x802a9f,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
}
  802bab:	c9                   	leaveq 
  802bac:	c3                   	retq   

0000000000802bad <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802bad:	55                   	push   %rbp
  802bae:	48 89 e5             	mov    %rsp,%rbp
  802bb1:	48 83 ec 20          	sub    $0x20,%rsp
  802bb5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bbc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bc2:	89 c7                	mov    %eax,%edi
  802bc4:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
  802bd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd7:	79 05                	jns    802bde <bind+0x31>
		return r;
  802bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdc:	eb 1b                	jmp    802bf9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802bde:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802be1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802be5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be8:	48 89 ce             	mov    %rcx,%rsi
  802beb:	89 c7                	mov    %eax,%edi
  802bed:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
}
  802bf9:	c9                   	leaveq 
  802bfa:	c3                   	retq   

0000000000802bfb <shutdown>:

int
shutdown(int s, int how)
{
  802bfb:	55                   	push   %rbp
  802bfc:	48 89 e5             	mov    %rsp,%rbp
  802bff:	48 83 ec 20          	sub    $0x20,%rsp
  802c03:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c06:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c0c:	89 c7                	mov    %eax,%edi
  802c0e:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802c15:	00 00 00 
  802c18:	ff d0                	callq  *%rax
  802c1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c21:	79 05                	jns    802c28 <shutdown+0x2d>
		return r;
  802c23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c26:	eb 16                	jmp    802c3e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802c28:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2e:	89 d6                	mov    %edx,%esi
  802c30:	89 c7                	mov    %eax,%edi
  802c32:	48 b8 6c 2f 80 00 00 	movabs $0x802f6c,%rax
  802c39:	00 00 00 
  802c3c:	ff d0                	callq  *%rax
}
  802c3e:	c9                   	leaveq 
  802c3f:	c3                   	retq   

0000000000802c40 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802c40:	55                   	push   %rbp
  802c41:	48 89 e5             	mov    %rsp,%rbp
  802c44:	48 83 ec 10          	sub    $0x10,%rsp
  802c48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c50:	48 89 c7             	mov    %rax,%rdi
  802c53:	48 b8 ec 3d 80 00 00 	movabs $0x803dec,%rax
  802c5a:	00 00 00 
  802c5d:	ff d0                	callq  *%rax
  802c5f:	83 f8 01             	cmp    $0x1,%eax
  802c62:	75 17                	jne    802c7b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c68:	8b 40 0c             	mov    0xc(%rax),%eax
  802c6b:	89 c7                	mov    %eax,%edi
  802c6d:	48 b8 ac 2f 80 00 00 	movabs $0x802fac,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	eb 05                	jmp    802c80 <devsock_close+0x40>
	else
		return 0;
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c80:	c9                   	leaveq 
  802c81:	c3                   	retq   

0000000000802c82 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802c82:	55                   	push   %rbp
  802c83:	48 89 e5             	mov    %rsp,%rbp
  802c86:	48 83 ec 20          	sub    $0x20,%rsp
  802c8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c91:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c97:	89 c7                	mov    %eax,%edi
  802c99:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802ca0:	00 00 00 
  802ca3:	ff d0                	callq  *%rax
  802ca5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cac:	79 05                	jns    802cb3 <connect+0x31>
		return r;
  802cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb1:	eb 1b                	jmp    802cce <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802cb3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cb6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbd:	48 89 ce             	mov    %rcx,%rsi
  802cc0:	89 c7                	mov    %eax,%edi
  802cc2:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  802cc9:	00 00 00 
  802ccc:	ff d0                	callq  *%rax
}
  802cce:	c9                   	leaveq 
  802ccf:	c3                   	retq   

0000000000802cd0 <listen>:

int
listen(int s, int backlog)
{
  802cd0:	55                   	push   %rbp
  802cd1:	48 89 e5             	mov    %rsp,%rbp
  802cd4:	48 83 ec 20          	sub    $0x20,%rsp
  802cd8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cdb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ce1:	89 c7                	mov    %eax,%edi
  802ce3:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
  802cef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf6:	79 05                	jns    802cfd <listen+0x2d>
		return r;
  802cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfb:	eb 16                	jmp    802d13 <listen+0x43>
	return nsipc_listen(r, backlog);
  802cfd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d03:	89 d6                	mov    %edx,%esi
  802d05:	89 c7                	mov    %eax,%edi
  802d07:	48 b8 3d 30 80 00 00 	movabs $0x80303d,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
}
  802d13:	c9                   	leaveq 
  802d14:	c3                   	retq   

0000000000802d15 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802d15:	55                   	push   %rbp
  802d16:	48 89 e5             	mov    %rsp,%rbp
  802d19:	48 83 ec 20          	sub    $0x20,%rsp
  802d1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d25:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2d:	89 c2                	mov    %eax,%edx
  802d2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d33:	8b 40 0c             	mov    0xc(%rax),%eax
  802d36:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d3f:	89 c7                	mov    %eax,%edi
  802d41:	48 b8 7d 30 80 00 00 	movabs $0x80307d,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
}
  802d4d:	c9                   	leaveq 
  802d4e:	c3                   	retq   

0000000000802d4f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802d4f:	55                   	push   %rbp
  802d50:	48 89 e5             	mov    %rsp,%rbp
  802d53:	48 83 ec 20          	sub    $0x20,%rsp
  802d57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d5f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802d63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d67:	89 c2                	mov    %eax,%edx
  802d69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d6d:	8b 40 0c             	mov    0xc(%rax),%eax
  802d70:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d74:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d79:	89 c7                	mov    %eax,%edi
  802d7b:	48 b8 49 31 80 00 00 	movabs $0x803149,%rax
  802d82:	00 00 00 
  802d85:	ff d0                	callq  *%rax
}
  802d87:	c9                   	leaveq 
  802d88:	c3                   	retq   

0000000000802d89 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802d89:	55                   	push   %rbp
  802d8a:	48 89 e5             	mov    %rsp,%rbp
  802d8d:	48 83 ec 10          	sub    $0x10,%rsp
  802d91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802d99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9d:	48 be 93 49 80 00 00 	movabs $0x804993,%rsi
  802da4:	00 00 00 
  802da7:	48 89 c7             	mov    %rax,%rdi
  802daa:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  802db1:	00 00 00 
  802db4:	ff d0                	callq  *%rax
	return 0;
  802db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dbb:	c9                   	leaveq 
  802dbc:	c3                   	retq   

0000000000802dbd <socket>:

int
socket(int domain, int type, int protocol)
{
  802dbd:	55                   	push   %rbp
  802dbe:	48 89 e5             	mov    %rsp,%rbp
  802dc1:	48 83 ec 20          	sub    $0x20,%rsp
  802dc5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dc8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802dcb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802dce:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802dd1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802dd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd7:	89 ce                	mov    %ecx,%esi
  802dd9:	89 c7                	mov    %eax,%edi
  802ddb:	48 b8 01 32 80 00 00 	movabs $0x803201,%rax
  802de2:	00 00 00 
  802de5:	ff d0                	callq  *%rax
  802de7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dee:	79 05                	jns    802df5 <socket+0x38>
		return r;
  802df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df3:	eb 11                	jmp    802e06 <socket+0x49>
	return alloc_sockfd(r);
  802df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df8:	89 c7                	mov    %eax,%edi
  802dfa:	48 b8 9f 2a 80 00 00 	movabs $0x802a9f,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
}
  802e06:	c9                   	leaveq 
  802e07:	c3                   	retq   

0000000000802e08 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802e08:	55                   	push   %rbp
  802e09:	48 89 e5             	mov    %rsp,%rbp
  802e0c:	48 83 ec 10          	sub    $0x10,%rsp
  802e10:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802e13:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802e1a:	00 00 00 
  802e1d:	8b 00                	mov    (%rax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	75 1d                	jne    802e40 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802e23:	bf 02 00 00 00       	mov    $0x2,%edi
  802e28:	48 b8 67 3d 80 00 00 	movabs $0x803d67,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
  802e34:	48 ba 28 70 80 00 00 	movabs $0x807028,%rdx
  802e3b:	00 00 00 
  802e3e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802e40:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802e47:	00 00 00 
  802e4a:	8b 00                	mov    (%rax),%eax
  802e4c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e4f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e54:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802e5b:	00 00 00 
  802e5e:	89 c7                	mov    %eax,%edi
  802e60:	48 b8 a4 3c 80 00 00 	movabs $0x803ca4,%rax
  802e67:	00 00 00 
  802e6a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802e6c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e71:	be 00 00 00 00       	mov    $0x0,%esi
  802e76:	bf 00 00 00 00       	mov    $0x0,%edi
  802e7b:	48 b8 e4 3b 80 00 00 	movabs $0x803be4,%rax
  802e82:	00 00 00 
  802e85:	ff d0                	callq  *%rax
}
  802e87:	c9                   	leaveq 
  802e88:	c3                   	retq   

0000000000802e89 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e89:	55                   	push   %rbp
  802e8a:	48 89 e5             	mov    %rsp,%rbp
  802e8d:	48 83 ec 30          	sub    $0x30,%rsp
  802e91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e98:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802e9c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ea3:	00 00 00 
  802ea6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ea9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802eab:	bf 01 00 00 00       	mov    $0x1,%edi
  802eb0:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  802eb7:	00 00 00 
  802eba:	ff d0                	callq  *%rax
  802ebc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec3:	78 3e                	js     802f03 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802ec5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ecc:	00 00 00 
  802ecf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed7:	8b 40 10             	mov    0x10(%rax),%eax
  802eda:	89 c2                	mov    %eax,%edx
  802edc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802ee0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ee4:	48 89 ce             	mov    %rcx,%rsi
  802ee7:	48 89 c7             	mov    %rax,%rdi
  802eea:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  802ef1:	00 00 00 
  802ef4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efa:	8b 50 10             	mov    0x10(%rax),%edx
  802efd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f01:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802f03:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f06:	c9                   	leaveq 
  802f07:	c3                   	retq   

0000000000802f08 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f08:	55                   	push   %rbp
  802f09:	48 89 e5             	mov    %rsp,%rbp
  802f0c:	48 83 ec 10          	sub    $0x10,%rsp
  802f10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f17:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802f1a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f21:	00 00 00 
  802f24:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f27:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802f29:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f30:	48 89 c6             	mov    %rax,%rsi
  802f33:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802f3a:	00 00 00 
  802f3d:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  802f44:	00 00 00 
  802f47:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802f49:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f50:	00 00 00 
  802f53:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f56:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802f59:	bf 02 00 00 00       	mov    $0x2,%edi
  802f5e:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  802f65:	00 00 00 
  802f68:	ff d0                	callq  *%rax
}
  802f6a:	c9                   	leaveq 
  802f6b:	c3                   	retq   

0000000000802f6c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802f6c:	55                   	push   %rbp
  802f6d:	48 89 e5             	mov    %rsp,%rbp
  802f70:	48 83 ec 10          	sub    $0x10,%rsp
  802f74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f77:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802f7a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f81:	00 00 00 
  802f84:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f87:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802f89:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f90:	00 00 00 
  802f93:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f96:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802f99:	bf 03 00 00 00       	mov    $0x3,%edi
  802f9e:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
}
  802faa:	c9                   	leaveq 
  802fab:	c3                   	retq   

0000000000802fac <nsipc_close>:

int
nsipc_close(int s)
{
  802fac:	55                   	push   %rbp
  802fad:	48 89 e5             	mov    %rsp,%rbp
  802fb0:	48 83 ec 10          	sub    $0x10,%rsp
  802fb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802fb7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fbe:	00 00 00 
  802fc1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fc4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802fc6:	bf 04 00 00 00       	mov    $0x4,%edi
  802fcb:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
}
  802fd7:	c9                   	leaveq 
  802fd8:	c3                   	retq   

0000000000802fd9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802fd9:	55                   	push   %rbp
  802fda:	48 89 e5             	mov    %rsp,%rbp
  802fdd:	48 83 ec 10          	sub    $0x10,%rsp
  802fe1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fe4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fe8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802feb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ff2:	00 00 00 
  802ff5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ff8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802ffa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ffd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803001:	48 89 c6             	mov    %rax,%rsi
  803004:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80300b:	00 00 00 
  80300e:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  803015:	00 00 00 
  803018:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80301a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803021:	00 00 00 
  803024:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803027:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80302a:	bf 05 00 00 00       	mov    $0x5,%edi
  80302f:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  803036:	00 00 00 
  803039:	ff d0                	callq  *%rax
}
  80303b:	c9                   	leaveq 
  80303c:	c3                   	retq   

000000000080303d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80303d:	55                   	push   %rbp
  80303e:	48 89 e5             	mov    %rsp,%rbp
  803041:	48 83 ec 10          	sub    $0x10,%rsp
  803045:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803048:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80304b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803052:	00 00 00 
  803055:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803058:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80305a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803061:	00 00 00 
  803064:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803067:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80306a:	bf 06 00 00 00       	mov    $0x6,%edi
  80306f:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
}
  80307b:	c9                   	leaveq 
  80307c:	c3                   	retq   

000000000080307d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80307d:	55                   	push   %rbp
  80307e:	48 89 e5             	mov    %rsp,%rbp
  803081:	48 83 ec 30          	sub    $0x30,%rsp
  803085:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803088:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80308c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80308f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803092:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803099:	00 00 00 
  80309c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80309f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8030a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030a8:	00 00 00 
  8030ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030ae:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8030b1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030b8:	00 00 00 
  8030bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030be:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8030c1:	bf 07 00 00 00       	mov    $0x7,%edi
  8030c6:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  8030cd:	00 00 00 
  8030d0:	ff d0                	callq  *%rax
  8030d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d9:	78 69                	js     803144 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8030db:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8030e2:	7f 08                	jg     8030ec <nsipc_recv+0x6f>
  8030e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8030ea:	7e 35                	jle    803121 <nsipc_recv+0xa4>
  8030ec:	48 b9 9a 49 80 00 00 	movabs $0x80499a,%rcx
  8030f3:	00 00 00 
  8030f6:	48 ba af 49 80 00 00 	movabs $0x8049af,%rdx
  8030fd:	00 00 00 
  803100:	be 61 00 00 00       	mov    $0x61,%esi
  803105:	48 bf c4 49 80 00 00 	movabs $0x8049c4,%rdi
  80310c:	00 00 00 
  80310f:	b8 00 00 00 00       	mov    $0x0,%eax
  803114:	49 b8 d0 3a 80 00 00 	movabs $0x803ad0,%r8
  80311b:	00 00 00 
  80311e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803121:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803124:	48 63 d0             	movslq %eax,%rdx
  803127:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80312b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803132:	00 00 00 
  803135:	48 89 c7             	mov    %rax,%rdi
  803138:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
	}

	return r;
  803144:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	48 83 ec 20          	sub    $0x20,%rsp
  803151:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803154:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803158:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80315b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80315e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803165:	00 00 00 
  803168:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80316b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80316d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803174:	7e 35                	jle    8031ab <nsipc_send+0x62>
  803176:	48 b9 d0 49 80 00 00 	movabs $0x8049d0,%rcx
  80317d:	00 00 00 
  803180:	48 ba af 49 80 00 00 	movabs $0x8049af,%rdx
  803187:	00 00 00 
  80318a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80318f:	48 bf c4 49 80 00 00 	movabs $0x8049c4,%rdi
  803196:	00 00 00 
  803199:	b8 00 00 00 00       	mov    $0x0,%eax
  80319e:	49 b8 d0 3a 80 00 00 	movabs $0x803ad0,%r8
  8031a5:	00 00 00 
  8031a8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8031ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ae:	48 63 d0             	movslq %eax,%rdx
  8031b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b5:	48 89 c6             	mov    %rax,%rsi
  8031b8:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8031bf:	00 00 00 
  8031c2:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8031ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d5:	00 00 00 
  8031d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031db:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8031de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031e5:	00 00 00 
  8031e8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031eb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8031ee:	bf 08 00 00 00       	mov    $0x8,%edi
  8031f3:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  8031fa:	00 00 00 
  8031fd:	ff d0                	callq  *%rax
}
  8031ff:	c9                   	leaveq 
  803200:	c3                   	retq   

0000000000803201 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803201:	55                   	push   %rbp
  803202:	48 89 e5             	mov    %rsp,%rbp
  803205:	48 83 ec 10          	sub    $0x10,%rsp
  803209:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80320c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80320f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803212:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803219:	00 00 00 
  80321c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80321f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803221:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803228:	00 00 00 
  80322b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80322e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803231:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803238:	00 00 00 
  80323b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80323e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803241:	bf 09 00 00 00       	mov    $0x9,%edi
  803246:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  80324d:	00 00 00 
  803250:	ff d0                	callq  *%rax
}
  803252:	c9                   	leaveq 
  803253:	c3                   	retq   

0000000000803254 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803254:	55                   	push   %rbp
  803255:	48 89 e5             	mov    %rsp,%rbp
  803258:	53                   	push   %rbx
  803259:	48 83 ec 38          	sub    $0x38,%rsp
  80325d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803261:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803265:	48 89 c7             	mov    %rax,%rdi
  803268:	48 b8 8e 1d 80 00 00 	movabs $0x801d8e,%rax
  80326f:	00 00 00 
  803272:	ff d0                	callq  *%rax
  803274:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803277:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80327b:	0f 88 bf 01 00 00    	js     803440 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803285:	ba 07 04 00 00       	mov    $0x407,%edx
  80328a:	48 89 c6             	mov    %rax,%rsi
  80328d:	bf 00 00 00 00       	mov    $0x0,%edi
  803292:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  803299:	00 00 00 
  80329c:	ff d0                	callq  *%rax
  80329e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a5:	0f 88 95 01 00 00    	js     803440 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032ab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032af:	48 89 c7             	mov    %rax,%rdi
  8032b2:	48 b8 8e 1d 80 00 00 	movabs $0x801d8e,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c5:	0f 88 5d 01 00 00    	js     803428 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032cf:	ba 07 04 00 00       	mov    $0x407,%edx
  8032d4:	48 89 c6             	mov    %rax,%rsi
  8032d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8032dc:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	callq  *%rax
  8032e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ef:	0f 88 33 01 00 00    	js     803428 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f9:	48 89 c7             	mov    %rax,%rdi
  8032fc:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
  803308:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80330c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803310:	ba 07 04 00 00       	mov    $0x407,%edx
  803315:	48 89 c6             	mov    %rax,%rsi
  803318:	bf 00 00 00 00       	mov    $0x0,%edi
  80331d:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  803324:	00 00 00 
  803327:	ff d0                	callq  *%rax
  803329:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80332c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803330:	0f 88 d9 00 00 00    	js     80340f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803336:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333a:	48 89 c7             	mov    %rax,%rdi
  80333d:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  803344:	00 00 00 
  803347:	ff d0                	callq  *%rax
  803349:	48 89 c2             	mov    %rax,%rdx
  80334c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803350:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803356:	48 89 d1             	mov    %rdx,%rcx
  803359:	ba 00 00 00 00       	mov    $0x0,%edx
  80335e:	48 89 c6             	mov    %rax,%rsi
  803361:	bf 00 00 00 00       	mov    $0x0,%edi
  803366:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  80336d:	00 00 00 
  803370:	ff d0                	callq  *%rax
  803372:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803375:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803379:	78 79                	js     8033f4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80337b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80337f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803386:	00 00 00 
  803389:	8b 12                	mov    (%rdx),%edx
  80338b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80338d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803391:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803398:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8033a3:	00 00 00 
  8033a6:	8b 12                	mov    (%rdx),%edx
  8033a8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b9:	48 89 c7             	mov    %rax,%rdi
  8033bc:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  8033c3:	00 00 00 
  8033c6:	ff d0                	callq  *%rax
  8033c8:	89 c2                	mov    %eax,%edx
  8033ca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033ce:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033d4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033dc:	48 89 c7             	mov    %rax,%rdi
  8033df:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  8033e6:	00 00 00 
  8033e9:	ff d0                	callq  *%rax
  8033eb:	89 03                	mov    %eax,(%rbx)
	return 0;
  8033ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f2:	eb 4f                	jmp    803443 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8033f4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8033f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f9:	48 89 c6             	mov    %rax,%rsi
  8033fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803401:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  803408:	00 00 00 
  80340b:	ff d0                	callq  *%rax
  80340d:	eb 01                	jmp    803410 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80340f:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803410:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803414:	48 89 c6             	mov    %rax,%rsi
  803417:	bf 00 00 00 00       	mov    $0x0,%edi
  80341c:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80342c:	48 89 c6             	mov    %rax,%rsi
  80342f:	bf 00 00 00 00       	mov    $0x0,%edi
  803434:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  80343b:	00 00 00 
  80343e:	ff d0                	callq  *%rax
    err:
	return r;
  803440:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803443:	48 83 c4 38          	add    $0x38,%rsp
  803447:	5b                   	pop    %rbx
  803448:	5d                   	pop    %rbp
  803449:	c3                   	retq   

000000000080344a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80344a:	55                   	push   %rbp
  80344b:	48 89 e5             	mov    %rsp,%rbp
  80344e:	53                   	push   %rbx
  80344f:	48 83 ec 28          	sub    $0x28,%rsp
  803453:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803457:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80345b:	eb 01                	jmp    80345e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  80345d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80345e:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803465:	00 00 00 
  803468:	48 8b 00             	mov    (%rax),%rax
  80346b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803471:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803478:	48 89 c7             	mov    %rax,%rdi
  80347b:	48 b8 ec 3d 80 00 00 	movabs $0x803dec,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
  803487:	89 c3                	mov    %eax,%ebx
  803489:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80348d:	48 89 c7             	mov    %rax,%rdi
  803490:	48 b8 ec 3d 80 00 00 	movabs $0x803dec,%rax
  803497:	00 00 00 
  80349a:	ff d0                	callq  *%rax
  80349c:	39 c3                	cmp    %eax,%ebx
  80349e:	0f 94 c0             	sete   %al
  8034a1:	0f b6 c0             	movzbl %al,%eax
  8034a4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034a7:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  8034ae:	00 00 00 
  8034b1:	48 8b 00             	mov    (%rax),%rax
  8034b4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034ba:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034c3:	75 0a                	jne    8034cf <_pipeisclosed+0x85>
			return ret;
  8034c5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8034c8:	48 83 c4 28          	add    $0x28,%rsp
  8034cc:	5b                   	pop    %rbx
  8034cd:	5d                   	pop    %rbp
  8034ce:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8034cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034d5:	74 86                	je     80345d <_pipeisclosed+0x13>
  8034d7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034db:	75 80                	jne    80345d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034dd:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  8034e4:	00 00 00 
  8034e7:	48 8b 00             	mov    (%rax),%rax
  8034ea:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034f0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034f6:	89 c6                	mov    %eax,%esi
  8034f8:	48 bf e1 49 80 00 00 	movabs $0x8049e1,%rdi
  8034ff:	00 00 00 
  803502:	b8 00 00 00 00       	mov    $0x0,%eax
  803507:	49 b8 0b 05 80 00 00 	movabs $0x80050b,%r8
  80350e:	00 00 00 
  803511:	41 ff d0             	callq  *%r8
	}
  803514:	e9 44 ff ff ff       	jmpq   80345d <_pipeisclosed+0x13>

0000000000803519 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803519:	55                   	push   %rbp
  80351a:	48 89 e5             	mov    %rsp,%rbp
  80351d:	48 83 ec 30          	sub    $0x30,%rsp
  803521:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803524:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803528:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80352b:	48 89 d6             	mov    %rdx,%rsi
  80352e:	89 c7                	mov    %eax,%edi
  803530:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
  80353c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803543:	79 05                	jns    80354a <pipeisclosed+0x31>
		return r;
  803545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803548:	eb 31                	jmp    80357b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80354a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354e:	48 89 c7             	mov    %rax,%rdi
  803551:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  803558:	00 00 00 
  80355b:	ff d0                	callq  *%rax
  80355d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803565:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803569:	48 89 d6             	mov    %rdx,%rsi
  80356c:	48 89 c7             	mov    %rax,%rdi
  80356f:	48 b8 4a 34 80 00 00 	movabs $0x80344a,%rax
  803576:	00 00 00 
  803579:	ff d0                	callq  *%rax
}
  80357b:	c9                   	leaveq 
  80357c:	c3                   	retq   

000000000080357d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80357d:	55                   	push   %rbp
  80357e:	48 89 e5             	mov    %rsp,%rbp
  803581:	48 83 ec 40          	sub    $0x40,%rsp
  803585:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803589:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80358d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803591:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803595:	48 89 c7             	mov    %rax,%rdi
  803598:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  80359f:	00 00 00 
  8035a2:	ff d0                	callq  *%rax
  8035a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035b0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035b7:	00 
  8035b8:	e9 97 00 00 00       	jmpq   803654 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035bd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035c2:	74 09                	je     8035cd <devpipe_read+0x50>
				return i;
  8035c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c8:	e9 95 00 00 00       	jmpq   803662 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d5:	48 89 d6             	mov    %rdx,%rsi
  8035d8:	48 89 c7             	mov    %rax,%rdi
  8035db:	48 b8 4a 34 80 00 00 	movabs $0x80344a,%rax
  8035e2:	00 00 00 
  8035e5:	ff d0                	callq  *%rax
  8035e7:	85 c0                	test   %eax,%eax
  8035e9:	74 07                	je     8035f2 <devpipe_read+0x75>
				return 0;
  8035eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f0:	eb 70                	jmp    803662 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035f2:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  8035f9:	00 00 00 
  8035fc:	ff d0                	callq  *%rax
  8035fe:	eb 01                	jmp    803601 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803600:	90                   	nop
  803601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803605:	8b 10                	mov    (%rax),%edx
  803607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360b:	8b 40 04             	mov    0x4(%rax),%eax
  80360e:	39 c2                	cmp    %eax,%edx
  803610:	74 ab                	je     8035bd <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80361a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80361e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803622:	8b 00                	mov    (%rax),%eax
  803624:	89 c2                	mov    %eax,%edx
  803626:	c1 fa 1f             	sar    $0x1f,%edx
  803629:	c1 ea 1b             	shr    $0x1b,%edx
  80362c:	01 d0                	add    %edx,%eax
  80362e:	83 e0 1f             	and    $0x1f,%eax
  803631:	29 d0                	sub    %edx,%eax
  803633:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803637:	48 98                	cltq   
  803639:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80363e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803640:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803644:	8b 00                	mov    (%rax),%eax
  803646:	8d 50 01             	lea    0x1(%rax),%edx
  803649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80364f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803658:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80365c:	72 a2                	jb     803600 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80365e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803662:	c9                   	leaveq 
  803663:	c3                   	retq   

0000000000803664 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803664:	55                   	push   %rbp
  803665:	48 89 e5             	mov    %rsp,%rbp
  803668:	48 83 ec 40          	sub    $0x40,%rsp
  80366c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803670:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803674:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80367c:	48 89 c7             	mov    %rax,%rdi
  80367f:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  803686:	00 00 00 
  803689:	ff d0                	callq  *%rax
  80368b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80368f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803693:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803697:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80369e:	00 
  80369f:	e9 93 00 00 00       	jmpq   803737 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ac:	48 89 d6             	mov    %rdx,%rsi
  8036af:	48 89 c7             	mov    %rax,%rdi
  8036b2:	48 b8 4a 34 80 00 00 	movabs $0x80344a,%rax
  8036b9:	00 00 00 
  8036bc:	ff d0                	callq  *%rax
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	74 07                	je     8036c9 <devpipe_write+0x65>
				return 0;
  8036c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c7:	eb 7c                	jmp    803745 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036c9:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
  8036d5:	eb 01                	jmp    8036d8 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036d7:	90                   	nop
  8036d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036dc:	8b 40 04             	mov    0x4(%rax),%eax
  8036df:	48 63 d0             	movslq %eax,%rdx
  8036e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e6:	8b 00                	mov    (%rax),%eax
  8036e8:	48 98                	cltq   
  8036ea:	48 83 c0 20          	add    $0x20,%rax
  8036ee:	48 39 c2             	cmp    %rax,%rdx
  8036f1:	73 b1                	jae    8036a4 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f7:	8b 40 04             	mov    0x4(%rax),%eax
  8036fa:	89 c2                	mov    %eax,%edx
  8036fc:	c1 fa 1f             	sar    $0x1f,%edx
  8036ff:	c1 ea 1b             	shr    $0x1b,%edx
  803702:	01 d0                	add    %edx,%eax
  803704:	83 e0 1f             	and    $0x1f,%eax
  803707:	29 d0                	sub    %edx,%eax
  803709:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80370d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803711:	48 01 ca             	add    %rcx,%rdx
  803714:	0f b6 0a             	movzbl (%rdx),%ecx
  803717:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80371b:	48 98                	cltq   
  80371d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803725:	8b 40 04             	mov    0x4(%rax),%eax
  803728:	8d 50 01             	lea    0x1(%rax),%edx
  80372b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803732:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803737:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80373f:	72 96                	jb     8036d7 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803741:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803745:	c9                   	leaveq 
  803746:	c3                   	retq   

0000000000803747 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803747:	55                   	push   %rbp
  803748:	48 89 e5             	mov    %rsp,%rbp
  80374b:	48 83 ec 20          	sub    $0x20,%rsp
  80374f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803753:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80375b:	48 89 c7             	mov    %rax,%rdi
  80375e:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  803765:	00 00 00 
  803768:	ff d0                	callq  *%rax
  80376a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80376e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803772:	48 be f4 49 80 00 00 	movabs $0x8049f4,%rsi
  803779:	00 00 00 
  80377c:	48 89 c7             	mov    %rax,%rdi
  80377f:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80378b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378f:	8b 50 04             	mov    0x4(%rax),%edx
  803792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803796:	8b 00                	mov    (%rax),%eax
  803798:	29 c2                	sub    %eax,%edx
  80379a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80379e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037af:	00 00 00 
	stat->st_dev = &devpipe;
  8037b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037bd:	00 00 00 
  8037c0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8037c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037cc:	c9                   	leaveq 
  8037cd:	c3                   	retq   

00000000008037ce <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037ce:	55                   	push   %rbp
  8037cf:	48 89 e5             	mov    %rsp,%rbp
  8037d2:	48 83 ec 10          	sub    $0x10,%rsp
  8037d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037de:	48 89 c6             	mov    %rax,%rsi
  8037e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e6:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  8037ed:	00 00 00 
  8037f0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f6:	48 89 c7             	mov    %rax,%rdi
  8037f9:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  803800:	00 00 00 
  803803:	ff d0                	callq  *%rax
  803805:	48 89 c6             	mov    %rax,%rsi
  803808:	bf 00 00 00 00       	mov    $0x0,%edi
  80380d:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  803814:	00 00 00 
  803817:	ff d0                	callq  *%rax
}
  803819:	c9                   	leaveq 
  80381a:	c3                   	retq   
	...

000000000080381c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80381c:	55                   	push   %rbp
  80381d:	48 89 e5             	mov    %rsp,%rbp
  803820:	48 83 ec 20          	sub    $0x20,%rsp
  803824:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803827:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80382a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80382d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803831:	be 01 00 00 00       	mov    $0x1,%esi
  803836:	48 89 c7             	mov    %rax,%rdi
  803839:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
}
  803845:	c9                   	leaveq 
  803846:	c3                   	retq   

0000000000803847 <getchar>:

int
getchar(void)
{
  803847:	55                   	push   %rbp
  803848:	48 89 e5             	mov    %rsp,%rbp
  80384b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80384f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803853:	ba 01 00 00 00       	mov    $0x1,%edx
  803858:	48 89 c6             	mov    %rax,%rsi
  80385b:	bf 00 00 00 00       	mov    $0x0,%edi
  803860:	48 b8 58 22 80 00 00 	movabs $0x802258,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
  80386c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80386f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803873:	79 05                	jns    80387a <getchar+0x33>
		return r;
  803875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803878:	eb 14                	jmp    80388e <getchar+0x47>
	if (r < 1)
  80387a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80387e:	7f 07                	jg     803887 <getchar+0x40>
		return -E_EOF;
  803880:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803885:	eb 07                	jmp    80388e <getchar+0x47>
	return c;
  803887:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80388b:	0f b6 c0             	movzbl %al,%eax
}
  80388e:	c9                   	leaveq 
  80388f:	c3                   	retq   

0000000000803890 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803890:	55                   	push   %rbp
  803891:	48 89 e5             	mov    %rsp,%rbp
  803894:	48 83 ec 20          	sub    $0x20,%rsp
  803898:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80389b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80389f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a2:	48 89 d6             	mov    %rdx,%rsi
  8038a5:	89 c7                	mov    %eax,%edi
  8038a7:	48 b8 26 1e 80 00 00 	movabs $0x801e26,%rax
  8038ae:	00 00 00 
  8038b1:	ff d0                	callq  *%rax
  8038b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ba:	79 05                	jns    8038c1 <iscons+0x31>
		return r;
  8038bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038bf:	eb 1a                	jmp    8038db <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c5:	8b 10                	mov    (%rax),%edx
  8038c7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8038ce:	00 00 00 
  8038d1:	8b 00                	mov    (%rax),%eax
  8038d3:	39 c2                	cmp    %eax,%edx
  8038d5:	0f 94 c0             	sete   %al
  8038d8:	0f b6 c0             	movzbl %al,%eax
}
  8038db:	c9                   	leaveq 
  8038dc:	c3                   	retq   

00000000008038dd <opencons>:

int
opencons(void)
{
  8038dd:	55                   	push   %rbp
  8038de:	48 89 e5             	mov    %rsp,%rbp
  8038e1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038e5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038e9:	48 89 c7             	mov    %rax,%rdi
  8038ec:	48 b8 8e 1d 80 00 00 	movabs $0x801d8e,%rax
  8038f3:	00 00 00 
  8038f6:	ff d0                	callq  *%rax
  8038f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ff:	79 05                	jns    803906 <opencons+0x29>
		return r;
  803901:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803904:	eb 5b                	jmp    803961 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803906:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390a:	ba 07 04 00 00       	mov    $0x407,%edx
  80390f:	48 89 c6             	mov    %rax,%rsi
  803912:	bf 00 00 00 00       	mov    $0x0,%edi
  803917:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  80391e:	00 00 00 
  803921:	ff d0                	callq  *%rax
  803923:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803926:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392a:	79 05                	jns    803931 <opencons+0x54>
		return r;
  80392c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392f:	eb 30                	jmp    803961 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803931:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803935:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80393c:	00 00 00 
  80393f:	8b 12                	mov    (%rdx),%edx
  803941:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803947:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80394e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803952:	48 89 c7             	mov    %rax,%rdi
  803955:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  80395c:	00 00 00 
  80395f:	ff d0                	callq  *%rax
}
  803961:	c9                   	leaveq 
  803962:	c3                   	retq   

0000000000803963 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803963:	55                   	push   %rbp
  803964:	48 89 e5             	mov    %rsp,%rbp
  803967:	48 83 ec 30          	sub    $0x30,%rsp
  80396b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80396f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803973:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803977:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80397c:	75 13                	jne    803991 <devcons_read+0x2e>
		return 0;
  80397e:	b8 00 00 00 00       	mov    $0x0,%eax
  803983:	eb 49                	jmp    8039ce <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803985:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803991:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  803998:	00 00 00 
  80399b:	ff d0                	callq  *%rax
  80399d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a4:	74 df                	je     803985 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8039a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039aa:	79 05                	jns    8039b1 <devcons_read+0x4e>
		return c;
  8039ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039af:	eb 1d                	jmp    8039ce <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8039b1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039b5:	75 07                	jne    8039be <devcons_read+0x5b>
		return 0;
  8039b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bc:	eb 10                	jmp    8039ce <devcons_read+0x6b>
	*(char*)vbuf = c;
  8039be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c1:	89 c2                	mov    %eax,%edx
  8039c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c7:	88 10                	mov    %dl,(%rax)
	return 1;
  8039c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039ce:	c9                   	leaveq 
  8039cf:	c3                   	retq   

00000000008039d0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039d0:	55                   	push   %rbp
  8039d1:	48 89 e5             	mov    %rsp,%rbp
  8039d4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039db:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039e2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039e9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039f7:	eb 77                	jmp    803a70 <devcons_write+0xa0>
		m = n - tot;
  8039f9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a00:	89 c2                	mov    %eax,%edx
  803a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a05:	89 d1                	mov    %edx,%ecx
  803a07:	29 c1                	sub    %eax,%ecx
  803a09:	89 c8                	mov    %ecx,%eax
  803a0b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a11:	83 f8 7f             	cmp    $0x7f,%eax
  803a14:	76 07                	jbe    803a1d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803a16:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a20:	48 63 d0             	movslq %eax,%rdx
  803a23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a26:	48 98                	cltq   
  803a28:	48 89 c1             	mov    %rax,%rcx
  803a2b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803a32:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a39:	48 89 ce             	mov    %rcx,%rsi
  803a3c:	48 89 c7             	mov    %rax,%rdi
  803a3f:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  803a46:	00 00 00 
  803a49:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a4e:	48 63 d0             	movslq %eax,%rdx
  803a51:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a58:	48 89 d6             	mov    %rdx,%rsi
  803a5b:	48 89 c7             	mov    %rax,%rdi
  803a5e:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a6d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a73:	48 98                	cltq   
  803a75:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a7c:	0f 82 77 ff ff ff    	jb     8039f9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a85:	c9                   	leaveq 
  803a86:	c3                   	retq   

0000000000803a87 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a87:	55                   	push   %rbp
  803a88:	48 89 e5             	mov    %rsp,%rbp
  803a8b:	48 83 ec 08          	sub    $0x8,%rsp
  803a8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a98:	c9                   	leaveq 
  803a99:	c3                   	retq   

0000000000803a9a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a9a:	55                   	push   %rbp
  803a9b:	48 89 e5             	mov    %rsp,%rbp
  803a9e:	48 83 ec 10          	sub    $0x10,%rsp
  803aa2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803aa6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aae:	48 be 00 4a 80 00 00 	movabs $0x804a00,%rsi
  803ab5:	00 00 00 
  803ab8:	48 89 c7             	mov    %rax,%rdi
  803abb:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  803ac2:	00 00 00 
  803ac5:	ff d0                	callq  *%rax
	return 0;
  803ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803acc:	c9                   	leaveq 
  803acd:	c3                   	retq   
	...

0000000000803ad0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803ad0:	55                   	push   %rbp
  803ad1:	48 89 e5             	mov    %rsp,%rbp
  803ad4:	53                   	push   %rbx
  803ad5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803adc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803ae3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803ae9:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803af0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803af7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803afe:	84 c0                	test   %al,%al
  803b00:	74 23                	je     803b25 <_panic+0x55>
  803b02:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b09:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b0d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b11:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b15:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b19:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b1d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b21:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b25:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b2c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b33:	00 00 00 
  803b36:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b3d:	00 00 00 
  803b40:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b44:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b4b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b52:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b59:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803b60:	00 00 00 
  803b63:	48 8b 18             	mov    (%rax),%rbx
  803b66:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  803b6d:	00 00 00 
  803b70:	ff d0                	callq  *%rax
  803b72:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803b78:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b7f:	41 89 c8             	mov    %ecx,%r8d
  803b82:	48 89 d1             	mov    %rdx,%rcx
  803b85:	48 89 da             	mov    %rbx,%rdx
  803b88:	89 c6                	mov    %eax,%esi
  803b8a:	48 bf 08 4a 80 00 00 	movabs $0x804a08,%rdi
  803b91:	00 00 00 
  803b94:	b8 00 00 00 00       	mov    $0x0,%eax
  803b99:	49 b9 0b 05 80 00 00 	movabs $0x80050b,%r9
  803ba0:	00 00 00 
  803ba3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803ba6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803bad:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bb4:	48 89 d6             	mov    %rdx,%rsi
  803bb7:	48 89 c7             	mov    %rax,%rdi
  803bba:	48 b8 5f 04 80 00 00 	movabs $0x80045f,%rax
  803bc1:	00 00 00 
  803bc4:	ff d0                	callq  *%rax
	cprintf("\n");
  803bc6:	48 bf 2b 4a 80 00 00 	movabs $0x804a2b,%rdi
  803bcd:	00 00 00 
  803bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd5:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  803bdc:	00 00 00 
  803bdf:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803be1:	cc                   	int3   
  803be2:	eb fd                	jmp    803be1 <_panic+0x111>

0000000000803be4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803be4:	55                   	push   %rbp
  803be5:	48 89 e5             	mov    %rsp,%rbp
  803be8:	48 83 ec 30          	sub    $0x30,%rsp
  803bec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bf0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803bf8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803bfd:	74 18                	je     803c17 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803bff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c03:	48 89 c7             	mov    %rax,%rdi
  803c06:	48 b8 29 1c 80 00 00 	movabs $0x801c29,%rax
  803c0d:	00 00 00 
  803c10:	ff d0                	callq  *%rax
  803c12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c15:	eb 19                	jmp    803c30 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803c17:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803c1e:	00 00 00 
  803c21:	48 b8 29 1c 80 00 00 	movabs $0x801c29,%rax
  803c28:	00 00 00 
  803c2b:	ff d0                	callq  *%rax
  803c2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803c30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c34:	79 19                	jns    803c4f <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803c36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c3a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803c40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c44:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803c4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4d:	eb 53                	jmp    803ca2 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803c4f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c54:	74 19                	je     803c6f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803c56:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803c5d:	00 00 00 
  803c60:	48 8b 00             	mov    (%rax),%rax
  803c63:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803c69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c6d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803c6f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c74:	74 19                	je     803c8f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803c76:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803c7d:	00 00 00 
  803c80:	48 8b 00             	mov    (%rax),%rax
  803c83:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803c89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c8d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803c8f:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803c96:	00 00 00 
  803c99:	48 8b 00             	mov    (%rax),%rax
  803c9c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803ca2:	c9                   	leaveq 
  803ca3:	c3                   	retq   

0000000000803ca4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ca4:	55                   	push   %rbp
  803ca5:	48 89 e5             	mov    %rsp,%rbp
  803ca8:	48 83 ec 30          	sub    $0x30,%rsp
  803cac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803caf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cb2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803cb6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803cb9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803cc0:	e9 96 00 00 00       	jmpq   803d5b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803cc5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803cca:	74 20                	je     803cec <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803ccc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ccf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803cd2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cd9:	89 c7                	mov    %eax,%edi
  803cdb:	48 b8 d4 1b 80 00 00 	movabs $0x801bd4,%rax
  803ce2:	00 00 00 
  803ce5:	ff d0                	callq  *%rax
  803ce7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cea:	eb 2d                	jmp    803d19 <ipc_send+0x75>
		else if(pg==NULL)
  803cec:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803cf1:	75 26                	jne    803d19 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803cf3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803cf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cf9:	b9 00 00 00 00       	mov    $0x0,%ecx
  803cfe:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d05:	00 00 00 
  803d08:	89 c7                	mov    %eax,%edi
  803d0a:	48 b8 d4 1b 80 00 00 	movabs $0x801bd4,%rax
  803d11:	00 00 00 
  803d14:	ff d0                	callq  *%rax
  803d16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803d19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1d:	79 30                	jns    803d4f <ipc_send+0xab>
  803d1f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d23:	74 2a                	je     803d4f <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803d25:	48 ba 2d 4a 80 00 00 	movabs $0x804a2d,%rdx
  803d2c:	00 00 00 
  803d2f:	be 40 00 00 00       	mov    $0x40,%esi
  803d34:	48 bf 45 4a 80 00 00 	movabs $0x804a45,%rdi
  803d3b:	00 00 00 
  803d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d43:	48 b9 d0 3a 80 00 00 	movabs $0x803ad0,%rcx
  803d4a:	00 00 00 
  803d4d:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803d4f:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  803d56:	00 00 00 
  803d59:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803d5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d5f:	0f 85 60 ff ff ff    	jne    803cc5 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803d65:	c9                   	leaveq 
  803d66:	c3                   	retq   

0000000000803d67 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d67:	55                   	push   %rbp
  803d68:	48 89 e5             	mov    %rsp,%rbp
  803d6b:	48 83 ec 18          	sub    $0x18,%rsp
  803d6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803d72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d79:	eb 5e                	jmp    803dd9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d7b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d82:	00 00 00 
  803d85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d88:	48 63 d0             	movslq %eax,%rdx
  803d8b:	48 89 d0             	mov    %rdx,%rax
  803d8e:	48 c1 e0 03          	shl    $0x3,%rax
  803d92:	48 01 d0             	add    %rdx,%rax
  803d95:	48 c1 e0 05          	shl    $0x5,%rax
  803d99:	48 01 c8             	add    %rcx,%rax
  803d9c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803da2:	8b 00                	mov    (%rax),%eax
  803da4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803da7:	75 2c                	jne    803dd5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803da9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803db0:	00 00 00 
  803db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db6:	48 63 d0             	movslq %eax,%rdx
  803db9:	48 89 d0             	mov    %rdx,%rax
  803dbc:	48 c1 e0 03          	shl    $0x3,%rax
  803dc0:	48 01 d0             	add    %rdx,%rax
  803dc3:	48 c1 e0 05          	shl    $0x5,%rax
  803dc7:	48 01 c8             	add    %rcx,%rax
  803dca:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803dd0:	8b 40 08             	mov    0x8(%rax),%eax
  803dd3:	eb 12                	jmp    803de7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803dd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803dd9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803de0:	7e 99                	jle    803d7b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803de7:	c9                   	leaveq 
  803de8:	c3                   	retq   
  803de9:	00 00                	add    %al,(%rax)
	...

0000000000803dec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803dec:	55                   	push   %rbp
  803ded:	48 89 e5             	mov    %rsp,%rbp
  803df0:	48 83 ec 18          	sub    $0x18,%rsp
  803df4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dfc:	48 89 c2             	mov    %rax,%rdx
  803dff:	48 c1 ea 15          	shr    $0x15,%rdx
  803e03:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e0a:	01 00 00 
  803e0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e11:	83 e0 01             	and    $0x1,%eax
  803e14:	48 85 c0             	test   %rax,%rax
  803e17:	75 07                	jne    803e20 <pageref+0x34>
		return 0;
  803e19:	b8 00 00 00 00       	mov    $0x0,%eax
  803e1e:	eb 53                	jmp    803e73 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e24:	48 89 c2             	mov    %rax,%rdx
  803e27:	48 c1 ea 0c          	shr    $0xc,%rdx
  803e2b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e32:	01 00 00 
  803e35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e41:	83 e0 01             	and    $0x1,%eax
  803e44:	48 85 c0             	test   %rax,%rax
  803e47:	75 07                	jne    803e50 <pageref+0x64>
		return 0;
  803e49:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4e:	eb 23                	jmp    803e73 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e54:	48 89 c2             	mov    %rax,%rdx
  803e57:	48 c1 ea 0c          	shr    $0xc,%rdx
  803e5b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e62:	00 00 00 
  803e65:	48 c1 e2 04          	shl    $0x4,%rdx
  803e69:	48 01 d0             	add    %rdx,%rax
  803e6c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e70:	0f b7 c0             	movzwl %ax,%eax
}
  803e73:	c9                   	leaveq 
  803e74:	c3                   	retq   
  803e75:	00 00                	add    %al,(%rax)
	...

0000000000803e78 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  803e78:	55                   	push   %rbp
  803e79:	48 89 e5             	mov    %rsp,%rbp
  803e7c:	48 83 ec 20          	sub    $0x20,%rsp
  803e80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  803e84:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e8c:	48 89 d6             	mov    %rdx,%rsi
  803e8f:	48 89 c7             	mov    %rax,%rdi
  803e92:	48 b8 ae 3e 80 00 00 	movabs $0x803eae,%rax
  803e99:	00 00 00 
  803e9c:	ff d0                	callq  *%rax
  803e9e:	85 c0                	test   %eax,%eax
  803ea0:	74 05                	je     803ea7 <inet_addr+0x2f>
    return (val.s_addr);
  803ea2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ea5:	eb 05                	jmp    803eac <inet_addr+0x34>
  }
  return (INADDR_NONE);
  803ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803eac:	c9                   	leaveq 
  803ead:	c3                   	retq   

0000000000803eae <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803eae:	55                   	push   %rbp
  803eaf:	48 89 e5             	mov    %rsp,%rbp
  803eb2:	53                   	push   %rbx
  803eb3:	48 83 ec 48          	sub    $0x48,%rsp
  803eb7:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  803ebb:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  803ebf:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803ec3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  c = *cp;
  803ec7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803ecb:	0f b6 00             	movzbl (%rax),%eax
  803ece:	0f be c0             	movsbl %al,%eax
  803ed1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803ed4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ed7:	3c 2f                	cmp    $0x2f,%al
  803ed9:	76 07                	jbe    803ee2 <inet_aton+0x34>
  803edb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ede:	3c 39                	cmp    $0x39,%al
  803ee0:	76 0a                	jbe    803eec <inet_aton+0x3e>
      return (0);
  803ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee7:	e9 6a 02 00 00       	jmpq   804156 <inet_aton+0x2a8>
    val = 0;
  803eec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    base = 10;
  803ef3:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%rbp)
    if (c == '0') {
  803efa:	83 7d e4 30          	cmpl   $0x30,-0x1c(%rbp)
  803efe:	75 40                	jne    803f40 <inet_aton+0x92>
      c = *++cp;
  803f00:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f05:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f09:	0f b6 00             	movzbl (%rax),%eax
  803f0c:	0f be c0             	movsbl %al,%eax
  803f0f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if (c == 'x' || c == 'X') {
  803f12:	83 7d e4 78          	cmpl   $0x78,-0x1c(%rbp)
  803f16:	74 06                	je     803f1e <inet_aton+0x70>
  803f18:	83 7d e4 58          	cmpl   $0x58,-0x1c(%rbp)
  803f1c:	75 1b                	jne    803f39 <inet_aton+0x8b>
        base = 16;
  803f1e:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
        c = *++cp;
  803f25:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f2a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f2e:	0f b6 00             	movzbl (%rax),%eax
  803f31:	0f be c0             	movsbl %al,%eax
  803f34:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803f37:	eb 07                	jmp    803f40 <inet_aton+0x92>
      } else
        base = 8;
  803f39:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  803f40:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f43:	3c 2f                	cmp    $0x2f,%al
  803f45:	76 2f                	jbe    803f76 <inet_aton+0xc8>
  803f47:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f4a:	3c 39                	cmp    $0x39,%al
  803f4c:	77 28                	ja     803f76 <inet_aton+0xc8>
        val = (val * base) + (int)(c - '0');
  803f4e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f51:	89 c2                	mov    %eax,%edx
  803f53:	0f af 55 ec          	imul   -0x14(%rbp),%edx
  803f57:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f5a:	01 d0                	add    %edx,%eax
  803f5c:	83 e8 30             	sub    $0x30,%eax
  803f5f:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  803f62:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f67:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f6b:	0f b6 00             	movzbl (%rax),%eax
  803f6e:	0f be c0             	movsbl %al,%eax
  803f71:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  803f74:	eb ca                	jmp    803f40 <inet_aton+0x92>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  803f76:	83 7d e8 10          	cmpl   $0x10,-0x18(%rbp)
  803f7a:	75 74                	jne    803ff0 <inet_aton+0x142>
  803f7c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f7f:	3c 2f                	cmp    $0x2f,%al
  803f81:	76 07                	jbe    803f8a <inet_aton+0xdc>
  803f83:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f86:	3c 39                	cmp    $0x39,%al
  803f88:	76 1c                	jbe    803fa6 <inet_aton+0xf8>
  803f8a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f8d:	3c 60                	cmp    $0x60,%al
  803f8f:	76 07                	jbe    803f98 <inet_aton+0xea>
  803f91:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f94:	3c 66                	cmp    $0x66,%al
  803f96:	76 0e                	jbe    803fa6 <inet_aton+0xf8>
  803f98:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f9b:	3c 40                	cmp    $0x40,%al
  803f9d:	76 51                	jbe    803ff0 <inet_aton+0x142>
  803f9f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fa2:	3c 46                	cmp    $0x46,%al
  803fa4:	77 4a                	ja     803ff0 <inet_aton+0x142>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  803fa6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fa9:	89 c2                	mov    %eax,%edx
  803fab:	c1 e2 04             	shl    $0x4,%edx
  803fae:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fb1:	8d 48 0a             	lea    0xa(%rax),%ecx
  803fb4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fb7:	3c 60                	cmp    $0x60,%al
  803fb9:	76 0e                	jbe    803fc9 <inet_aton+0x11b>
  803fbb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fbe:	3c 7a                	cmp    $0x7a,%al
  803fc0:	77 07                	ja     803fc9 <inet_aton+0x11b>
  803fc2:	b8 61 00 00 00       	mov    $0x61,%eax
  803fc7:	eb 05                	jmp    803fce <inet_aton+0x120>
  803fc9:	b8 41 00 00 00       	mov    $0x41,%eax
  803fce:	89 cb                	mov    %ecx,%ebx
  803fd0:	29 c3                	sub    %eax,%ebx
  803fd2:	89 d8                	mov    %ebx,%eax
  803fd4:	09 d0                	or     %edx,%eax
  803fd6:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  803fd9:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803fde:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803fe2:	0f b6 00             	movzbl (%rax),%eax
  803fe5:	0f be c0             	movsbl %al,%eax
  803fe8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else
        break;
    }
  803feb:	e9 50 ff ff ff       	jmpq   803f40 <inet_aton+0x92>
    if (c == '.') {
  803ff0:	83 7d e4 2e          	cmpl   $0x2e,-0x1c(%rbp)
  803ff4:	75 3d                	jne    804033 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803ff6:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803ffa:	48 83 c0 0c          	add    $0xc,%rax
  803ffe:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804002:	72 0a                	jb     80400e <inet_aton+0x160>
        return (0);
  804004:	b8 00 00 00 00       	mov    $0x0,%eax
  804009:	e9 48 01 00 00       	jmpq   804156 <inet_aton+0x2a8>
      *pp++ = val;
  80400e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804012:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804015:	89 10                	mov    %edx,(%rax)
  804017:	48 83 45 d8 04       	addq   $0x4,-0x28(%rbp)
      c = *++cp;
  80401c:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804021:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804025:	0f b6 00             	movzbl (%rax),%eax
  804028:	0f be c0             	movsbl %al,%eax
  80402b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    } else
      break;
  }
  80402e:	e9 a1 fe ff ff       	jmpq   803ed4 <inet_aton+0x26>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804033:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804034:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804038:	74 3c                	je     804076 <inet_aton+0x1c8>
  80403a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80403d:	3c 1f                	cmp    $0x1f,%al
  80403f:	76 2b                	jbe    80406c <inet_aton+0x1be>
  804041:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804044:	84 c0                	test   %al,%al
  804046:	78 24                	js     80406c <inet_aton+0x1be>
  804048:	83 7d e4 20          	cmpl   $0x20,-0x1c(%rbp)
  80404c:	74 28                	je     804076 <inet_aton+0x1c8>
  80404e:	83 7d e4 0c          	cmpl   $0xc,-0x1c(%rbp)
  804052:	74 22                	je     804076 <inet_aton+0x1c8>
  804054:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  804058:	74 1c                	je     804076 <inet_aton+0x1c8>
  80405a:	83 7d e4 0d          	cmpl   $0xd,-0x1c(%rbp)
  80405e:	74 16                	je     804076 <inet_aton+0x1c8>
  804060:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  804064:	74 10                	je     804076 <inet_aton+0x1c8>
  804066:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%rbp)
  80406a:	74 0a                	je     804076 <inet_aton+0x1c8>
    return (0);
  80406c:	b8 00 00 00 00       	mov    $0x0,%eax
  804071:	e9 e0 00 00 00       	jmpq   804156 <inet_aton+0x2a8>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804076:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80407a:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  80407e:	48 89 d1             	mov    %rdx,%rcx
  804081:	48 29 c1             	sub    %rax,%rcx
  804084:	48 89 c8             	mov    %rcx,%rax
  804087:	48 c1 f8 02          	sar    $0x2,%rax
  80408b:	83 c0 01             	add    $0x1,%eax
  80408e:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  switch (n) {
  804091:	83 7d d4 04          	cmpl   $0x4,-0x2c(%rbp)
  804095:	0f 87 98 00 00 00    	ja     804133 <inet_aton+0x285>
  80409b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80409e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040a5:	00 
  8040a6:	48 b8 50 4a 80 00 00 	movabs $0x804a50,%rax
  8040ad:	00 00 00 
  8040b0:	48 01 d0             	add    %rdx,%rax
  8040b3:	48 8b 00             	mov    (%rax),%rax
  8040b6:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8040b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8040bd:	e9 94 00 00 00       	jmpq   804156 <inet_aton+0x2a8>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8040c2:	81 7d ec ff ff ff 00 	cmpl   $0xffffff,-0x14(%rbp)
  8040c9:	76 0a                	jbe    8040d5 <inet_aton+0x227>
      return (0);
  8040cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d0:	e9 81 00 00 00       	jmpq   804156 <inet_aton+0x2a8>
    val |= parts[0] << 24;
  8040d5:	8b 45 c0             	mov    -0x40(%rbp),%eax
  8040d8:	c1 e0 18             	shl    $0x18,%eax
  8040db:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  8040de:	eb 53                	jmp    804133 <inet_aton+0x285>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8040e0:	81 7d ec ff ff 00 00 	cmpl   $0xffff,-0x14(%rbp)
  8040e7:	76 07                	jbe    8040f0 <inet_aton+0x242>
      return (0);
  8040e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ee:	eb 66                	jmp    804156 <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8040f0:	8b 45 c0             	mov    -0x40(%rbp),%eax
  8040f3:	89 c2                	mov    %eax,%edx
  8040f5:	c1 e2 18             	shl    $0x18,%edx
  8040f8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8040fb:	c1 e0 10             	shl    $0x10,%eax
  8040fe:	09 d0                	or     %edx,%eax
  804100:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804103:	eb 2e                	jmp    804133 <inet_aton+0x285>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804105:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%rbp)
  80410c:	76 07                	jbe    804115 <inet_aton+0x267>
      return (0);
  80410e:	b8 00 00 00 00       	mov    $0x0,%eax
  804113:	eb 41                	jmp    804156 <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804115:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804118:	89 c2                	mov    %eax,%edx
  80411a:	c1 e2 18             	shl    $0x18,%edx
  80411d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804120:	c1 e0 10             	shl    $0x10,%eax
  804123:	09 c2                	or     %eax,%edx
  804125:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804128:	c1 e0 08             	shl    $0x8,%eax
  80412b:	09 d0                	or     %edx,%eax
  80412d:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804130:	eb 01                	jmp    804133 <inet_aton+0x285>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  804132:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804133:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  804138:	74 17                	je     804151 <inet_aton+0x2a3>
    addr->s_addr = htonl(val);
  80413a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80413d:	89 c7                	mov    %eax,%edi
  80413f:	48 b8 c5 42 80 00 00 	movabs $0x8042c5,%rax
  804146:	00 00 00 
  804149:	ff d0                	callq  *%rax
  80414b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80414f:	89 02                	mov    %eax,(%rdx)
  return (1);
  804151:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804156:	48 83 c4 48          	add    $0x48,%rsp
  80415a:	5b                   	pop    %rbx
  80415b:	5d                   	pop    %rbp
  80415c:	c3                   	retq   

000000000080415d <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  80415d:	55                   	push   %rbp
  80415e:	48 89 e5             	mov    %rsp,%rbp
  804161:	48 83 ec 30          	sub    $0x30,%rsp
  804165:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804168:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80416b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80416e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  804175:	00 00 00 
  804178:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  80417c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804180:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804184:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804188:	e9 d1 00 00 00       	jmpq   80425e <inet_ntoa+0x101>
    i = 0;
  80418d:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  804191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804195:	0f b6 08             	movzbl (%rax),%ecx
  804198:	0f b6 d1             	movzbl %cl,%edx
  80419b:	89 d0                	mov    %edx,%eax
  80419d:	c1 e0 02             	shl    $0x2,%eax
  8041a0:	01 d0                	add    %edx,%eax
  8041a2:	c1 e0 03             	shl    $0x3,%eax
  8041a5:	01 d0                	add    %edx,%eax
  8041a7:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8041ae:	01 d0                	add    %edx,%eax
  8041b0:	66 c1 e8 08          	shr    $0x8,%ax
  8041b4:	c0 e8 03             	shr    $0x3,%al
  8041b7:	88 45 ed             	mov    %al,-0x13(%rbp)
  8041ba:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8041be:	89 d0                	mov    %edx,%eax
  8041c0:	c1 e0 02             	shl    $0x2,%eax
  8041c3:	01 d0                	add    %edx,%eax
  8041c5:	01 c0                	add    %eax,%eax
  8041c7:	89 ca                	mov    %ecx,%edx
  8041c9:	28 c2                	sub    %al,%dl
  8041cb:	89 d0                	mov    %edx,%eax
  8041cd:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8041d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d4:	0f b6 00             	movzbl (%rax),%eax
  8041d7:	0f b6 d0             	movzbl %al,%edx
  8041da:	89 d0                	mov    %edx,%eax
  8041dc:	c1 e0 02             	shl    $0x2,%eax
  8041df:	01 d0                	add    %edx,%eax
  8041e1:	c1 e0 03             	shl    $0x3,%eax
  8041e4:	01 d0                	add    %edx,%eax
  8041e6:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8041ed:	01 d0                	add    %edx,%eax
  8041ef:	66 c1 e8 08          	shr    $0x8,%ax
  8041f3:	89 c2                	mov    %eax,%edx
  8041f5:	c0 ea 03             	shr    $0x3,%dl
  8041f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041fc:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8041fe:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804202:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804206:	83 c2 30             	add    $0x30,%edx
  804209:	48 98                	cltq   
  80420b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  80420f:	80 45 ee 01          	addb   $0x1,-0x12(%rbp)
    } while(*ap);
  804213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804217:	0f b6 00             	movzbl (%rax),%eax
  80421a:	84 c0                	test   %al,%al
  80421c:	0f 85 6f ff ff ff    	jne    804191 <inet_ntoa+0x34>
    while(i--)
  804222:	eb 16                	jmp    80423a <inet_ntoa+0xdd>
      *rp++ = inv[i];
  804224:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804228:	48 98                	cltq   
  80422a:	0f b6 54 05 e0       	movzbl -0x20(%rbp,%rax,1),%edx
  80422f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804233:	88 10                	mov    %dl,(%rax)
  804235:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80423a:	80 7d ee 00          	cmpb   $0x0,-0x12(%rbp)
  80423e:	0f 95 c0             	setne  %al
  804241:	80 6d ee 01          	subb   $0x1,-0x12(%rbp)
  804245:	84 c0                	test   %al,%al
  804247:	75 db                	jne    804224 <inet_ntoa+0xc7>
      *rp++ = inv[i];
    *rp++ = '.';
  804249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80424d:	c6 00 2e             	movb   $0x2e,(%rax)
  804250:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    ap++;
  804255:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80425a:	80 45 ef 01          	addb   $0x1,-0x11(%rbp)
  80425e:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  804262:	0f 86 25 ff ff ff    	jbe    80418d <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804268:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  80426d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804271:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804274:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80427b:	00 00 00 
}
  80427e:	c9                   	leaveq 
  80427f:	c3                   	retq   

0000000000804280 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804280:	55                   	push   %rbp
  804281:	48 89 e5             	mov    %rsp,%rbp
  804284:	48 83 ec 08          	sub    $0x8,%rsp
  804288:	89 f8                	mov    %edi,%eax
  80428a:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80428e:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804292:	c1 e0 08             	shl    $0x8,%eax
  804295:	89 c2                	mov    %eax,%edx
  804297:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80429b:	66 c1 e8 08          	shr    $0x8,%ax
  80429f:	09 d0                	or     %edx,%eax
}
  8042a1:	c9                   	leaveq 
  8042a2:	c3                   	retq   

00000000008042a3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8042a3:	55                   	push   %rbp
  8042a4:	48 89 e5             	mov    %rsp,%rbp
  8042a7:	48 83 ec 08          	sub    $0x8,%rsp
  8042ab:	89 f8                	mov    %edi,%eax
  8042ad:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8042b1:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8042b5:	89 c7                	mov    %eax,%edi
  8042b7:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  8042be:	00 00 00 
  8042c1:	ff d0                	callq  *%rax
}
  8042c3:	c9                   	leaveq 
  8042c4:	c3                   	retq   

00000000008042c5 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8042c5:	55                   	push   %rbp
  8042c6:	48 89 e5             	mov    %rsp,%rbp
  8042c9:	48 83 ec 08          	sub    $0x8,%rsp
  8042cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8042d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d3:	89 c2                	mov    %eax,%edx
  8042d5:	c1 e2 18             	shl    $0x18,%edx
    ((n & 0xff00) << 8) |
  8042d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042db:	25 00 ff 00 00       	and    $0xff00,%eax
  8042e0:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8042e3:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8042e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e8:	25 00 00 ff 00       	and    $0xff0000,%eax
  8042ed:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8042f1:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8042f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f6:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8042f9:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8042fb:	c9                   	leaveq 
  8042fc:	c3                   	retq   

00000000008042fd <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8042fd:	55                   	push   %rbp
  8042fe:	48 89 e5             	mov    %rsp,%rbp
  804301:	48 83 ec 08          	sub    $0x8,%rsp
  804305:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804308:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80430b:	89 c7                	mov    %eax,%edi
  80430d:	48 b8 c5 42 80 00 00 	movabs $0x8042c5,%rax
  804314:	00 00 00 
  804317:	ff d0                	callq  *%rax
}
  804319:	c9                   	leaveq 
  80431a:	c3                   	retq   
