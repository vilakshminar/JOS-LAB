
obj/user/echosrv.debug:     file format elf64-x86-64


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

0000000000800044 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

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
  800057:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  80005e:	00 00 00 
  800061:	b8 00 00 00 00       	mov    $0x0,%eax
  800066:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  80006d:	00 00 00 
  800070:	ff d2                	callq  *%rdx
	exit();
  800072:	48 b8 e0 03 80 00 00 	movabs $0x8003e0,%rax
  800079:	00 00 00 
  80007c:	ff d0                	callq  *%rax
}
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <handle_client>:

void
handle_client(int sock)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 40          	sub    $0x40,%rsp
  800088:	89 7d cc             	mov    %edi,-0x34(%rbp)
	char buffer[BUFFSIZE];
	int received = -1;
  80008b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800092:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800096:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800099:	ba 20 00 00 00       	mov    $0x20,%edx
  80009e:	48 89 ce             	mov    %rcx,%rsi
  8000a1:	89 c7                	mov    %eax,%edi
  8000a3:	48 b8 78 22 80 00 00 	movabs $0x802278,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b6:	0f 89 8d 00 00 00    	jns    800149 <handle_client+0xc9>
		die("Failed to receive initial bytes from client");
  8000bc:	48 bf 48 43 80 00 00 	movabs $0x804348,%rdi
  8000c3:	00 00 00 
  8000c6:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000d2:	eb 75                	jmp    800149 <handle_client+0xc9>
		// Send back received data
		if (write(sock, buffer, received) != received)
  8000d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d7:	48 63 d0             	movslq %eax,%rdx
  8000da:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8000de:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8000e1:	48 89 ce             	mov    %rcx,%rsi
  8000e4:	89 c7                	mov    %eax,%edi
  8000e6:	48 b8 c6 23 80 00 00 	movabs $0x8023c6,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	callq  *%rax
  8000f2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000f5:	74 16                	je     80010d <handle_client+0x8d>
			die("Failed to send bytes to client");
  8000f7:	48 bf 78 43 80 00 00 	movabs $0x804378,%rdi
  8000fe:	00 00 00 
  800101:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80010d:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800111:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800114:	ba 20 00 00 00       	mov    $0x20,%edx
  800119:	48 89 ce             	mov    %rcx,%rsi
  80011c:	89 c7                	mov    %eax,%edi
  80011e:	48 b8 78 22 80 00 00 	movabs $0x802278,%rax
  800125:	00 00 00 
  800128:	ff d0                	callq  *%rax
  80012a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80012d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800131:	79 16                	jns    800149 <handle_client+0xc9>
			die("Failed to receive additional bytes from client");
  800133:	48 bf 98 43 80 00 00 	movabs $0x804398,%rdi
  80013a:	00 00 00 
  80013d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800144:	00 00 00 
  800147:	ff d0                	callq  *%rax
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  800149:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80014d:	7f 85                	jg     8000d4 <handle_client+0x54>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80014f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800152:	89 c7                	mov    %eax,%edi
  800154:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax
}
  800160:	c9                   	leaveq 
  800161:	c3                   	retq   

0000000000800162 <umain>:

void
umain(int argc, char **argv)
{
  800162:	55                   	push   %rbp
  800163:	48 89 e5             	mov    %rsp,%rbp
  800166:	48 83 ec 70          	sub    $0x70,%rsp
  80016a:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  80016d:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
	int serversock, clientsock;
	struct sockaddr_in echoserver, echoclient;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  800171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800178:	ba 06 00 00 00       	mov    $0x6,%edx
  80017d:	be 01 00 00 00       	mov    $0x1,%esi
  800182:	bf 02 00 00 00       	mov    $0x2,%edi
  800187:	48 b8 dd 2d 80 00 00 	movabs $0x802ddd,%rax
  80018e:	00 00 00 
  800191:	ff d0                	callq  *%rax
  800193:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800196:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80019a:	79 16                	jns    8001b2 <umain+0x50>
		die("Failed to create socket");
  80019c:	48 bf c7 43 80 00 00 	movabs $0x8043c7,%rdi
  8001a3:	00 00 00 
  8001a6:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  8001b2:	48 bf df 43 80 00 00 	movabs $0x8043df,%rdi
  8001b9:	00 00 00 
  8001bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c1:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  8001c8:	00 00 00 
  8001cb:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8001cd:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001d1:	ba 10 00 00 00       	mov    $0x10,%edx
  8001d6:	be 00 00 00 00       	mov    $0x0,%esi
  8001db:	48 89 c7             	mov    %rax,%rdi
  8001de:	48 b8 7f 13 80 00 00 	movabs $0x80137f,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8001ea:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  8001ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f3:	48 b8 e5 42 80 00 00 	movabs $0x8042e5,%rax
  8001fa:	00 00 00 
  8001fd:	ff d0                	callq  *%rax
  8001ff:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  800202:	bf 07 00 00 00       	mov    $0x7,%edi
  800207:	48 b8 a0 42 80 00 00 	movabs $0x8042a0,%rax
  80020e:	00 00 00 
  800211:	ff d0                	callq  *%rax
  800213:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to bind\n");
  800217:	48 bf ee 43 80 00 00 	movabs $0x8043ee,%rdi
  80021e:	00 00 00 
  800221:	b8 00 00 00 00       	mov    $0x0,%eax
  800226:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  80022d:	00 00 00 
  800230:	ff d2                	callq  *%rdx

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800232:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800236:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800239:	ba 10 00 00 00       	mov    $0x10,%edx
  80023e:	48 89 ce             	mov    %rcx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 cd 2b 80 00 00 	movabs $0x802bcd,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	85 c0                	test   %eax,%eax
  800251:	79 16                	jns    800269 <umain+0x107>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800253:	48 bf 00 44 80 00 00 	movabs $0x804400,%rdi
  80025a:	00 00 00 
  80025d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800269:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80026c:	be 05 00 00 00       	mov    $0x5,%esi
  800271:	89 c7                	mov    %eax,%edi
  800273:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  80027a:	00 00 00 
  80027d:	ff d0                	callq  *%rax
  80027f:	85 c0                	test   %eax,%eax
  800281:	79 16                	jns    800299 <umain+0x137>
		die("Failed to listen on server socket");
  800283:	48 bf 28 44 80 00 00 	movabs $0x804428,%rdi
  80028a:	00 00 00 
  80028d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800294:	00 00 00 
  800297:	ff d0                	callq  *%rax

	cprintf("bound\n");
  800299:	48 bf 4a 44 80 00 00 	movabs $0x80444a,%rdi
  8002a0:	00 00 00 
  8002a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a8:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  8002af:	00 00 00 
  8002b2:	ff d2                	callq  *%rdx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8002b4:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%rbp)
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
  8002bb:	48 8d 55 ac          	lea    -0x54(%rbp),%rdx
	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
  8002bf:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  8002c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c6:	48 89 ce             	mov    %rcx,%rsi
  8002c9:	89 c7                	mov    %eax,%edi
  8002cb:	48 b8 5e 2b 80 00 00 	movabs $0x802b5e,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax
  8002d7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002da:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002de:	79 16                	jns    8002f6 <umain+0x194>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8002e0:	48 bf 58 44 80 00 00 	movabs $0x804458,%rdi
  8002e7:	00 00 00 
  8002ea:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8002f1:	00 00 00 
  8002f4:	ff d0                	callq  *%rax
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8002f6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8002f9:	89 c7                	mov    %eax,%edi
  8002fb:	48 b8 7d 41 80 00 00 	movabs $0x80417d,%rax
  800302:	00 00 00 
  800305:	ff d0                	callq  *%rax
  800307:	48 89 c6             	mov    %rax,%rsi
  80030a:	48 bf 7b 44 80 00 00 	movabs $0x80447b,%rdi
  800311:	00 00 00 
  800314:	b8 00 00 00 00       	mov    $0x0,%eax
  800319:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  800320:	00 00 00 
  800323:	ff d2                	callq  *%rdx
		handle_client(clientsock);
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	89 c7                	mov    %eax,%edi
  80032a:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
	}
  800336:	e9 79 ff ff ff       	jmpq   8002b4 <umain+0x152>
	...

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
  80034b:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800352:	00 00 00 
  800355:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80035c:	48 b8 a4 19 80 00 00 	movabs $0x8019a4,%rax
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
  800391:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800398:	00 00 00 
  80039b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80039e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003a2:	7e 14                	jle    8003b8 <libmain+0x7c>
		binaryname = argv[0];
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	48 8b 10             	mov    (%rax),%rdx
  8003ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003b2:	00 00 00 
  8003b5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bf:	48 89 d6             	mov    %rdx,%rsi
  8003c2:	89 c7                	mov    %eax,%edi
  8003c4:	48 b8 62 01 80 00 00 	movabs $0x800162,%rax
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
  8003e4:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  8003eb:	00 00 00 
  8003ee:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8003f5:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8003fc:	00 00 00 
  8003ff:	ff d0                	callq  *%rax
}
  800401:	5d                   	pop    %rbp
  800402:	c3                   	retq   
	...

0000000000800404 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800404:	55                   	push   %rbp
  800405:	48 89 e5             	mov    %rsp,%rbp
  800408:	48 83 ec 10          	sub    $0x10,%rsp
  80040c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80040f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800417:	8b 00                	mov    (%rax),%eax
  800419:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80041c:	89 d6                	mov    %edx,%esi
  80041e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800422:	48 63 d0             	movslq %eax,%rdx
  800425:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80042a:	8d 50 01             	lea    0x1(%rax),%edx
  80042d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800431:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800437:	8b 00                	mov    (%rax),%eax
  800439:	3d ff 00 00 00       	cmp    $0xff,%eax
  80043e:	75 2c                	jne    80046c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800444:	8b 00                	mov    (%rax),%eax
  800446:	48 98                	cltq   
  800448:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044c:	48 83 c2 08          	add    $0x8,%rdx
  800450:	48 89 c6             	mov    %rax,%rsi
  800453:	48 89 d7             	mov    %rdx,%rdi
  800456:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  80045d:	00 00 00 
  800460:	ff d0                	callq  *%rax
		b->idx = 0;
  800462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800466:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80046c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800470:	8b 40 04             	mov    0x4(%rax),%eax
  800473:	8d 50 01             	lea    0x1(%rax),%edx
  800476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80047d:	c9                   	leaveq 
  80047e:	c3                   	retq   

000000000080047f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80047f:	55                   	push   %rbp
  800480:	48 89 e5             	mov    %rsp,%rbp
  800483:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80048a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800491:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800498:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80049f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004a6:	48 8b 0a             	mov    (%rdx),%rcx
  8004a9:	48 89 08             	mov    %rcx,(%rax)
  8004ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8004bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004c3:	00 00 00 
	b.cnt = 0;
  8004c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004cd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8004d0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004d7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004de:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004e5:	48 89 c6             	mov    %rax,%rsi
  8004e8:	48 bf 04 04 80 00 00 	movabs $0x800404,%rdi
  8004ef:	00 00 00 
  8004f2:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8004fe:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800504:	48 98                	cltq   
  800506:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80050d:	48 83 c2 08          	add    $0x8,%rdx
  800511:	48 89 c6             	mov    %rax,%rsi
  800514:	48 89 d7             	mov    %rdx,%rdi
  800517:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  80051e:	00 00 00 
  800521:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800529:	c9                   	leaveq 
  80052a:	c3                   	retq   

000000000080052b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80052b:	55                   	push   %rbp
  80052c:	48 89 e5             	mov    %rsp,%rbp
  80052f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800536:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80053d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800544:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80054b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800552:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800559:	84 c0                	test   %al,%al
  80055b:	74 20                	je     80057d <cprintf+0x52>
  80055d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800561:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800565:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800569:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80056d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800571:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800575:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800579:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80057d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800584:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80058b:	00 00 00 
  80058e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800595:	00 00 00 
  800598:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80059c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005a3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005aa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8005b1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005b8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005bf:	48 8b 0a             	mov    (%rdx),%rcx
  8005c2:	48 89 08             	mov    %rcx,(%rax)
  8005c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8005d5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005dc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e3:	48 89 d6             	mov    %rdx,%rsi
  8005e6:	48 89 c7             	mov    %rax,%rdi
  8005e9:	48 b8 7f 04 80 00 00 	movabs $0x80047f,%rax
  8005f0:	00 00 00 
  8005f3:	ff d0                	callq  *%rax
  8005f5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8005fb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800601:	c9                   	leaveq 
  800602:	c3                   	retq   
	...

0000000000800604 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800604:	55                   	push   %rbp
  800605:	48 89 e5             	mov    %rsp,%rbp
  800608:	48 83 ec 30          	sub    $0x30,%rsp
  80060c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800610:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800614:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800618:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80061b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80061f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800623:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800626:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80062a:	77 52                	ja     80067e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80062c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80062f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800633:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800636:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80063a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063e:	ba 00 00 00 00       	mov    $0x0,%edx
  800643:	48 f7 75 d0          	divq   -0x30(%rbp)
  800647:	48 89 c2             	mov    %rax,%rdx
  80064a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80064d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800650:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800658:	41 89 f9             	mov    %edi,%r9d
  80065b:	48 89 c7             	mov    %rax,%rdi
  80065e:	48 b8 04 06 80 00 00 	movabs $0x800604,%rax
  800665:	00 00 00 
  800668:	ff d0                	callq  *%rax
  80066a:	eb 1c                	jmp    800688 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80066c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800670:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800673:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800677:	48 89 d6             	mov    %rdx,%rsi
  80067a:	89 c7                	mov    %eax,%edi
  80067c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80067e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800682:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800686:	7f e4                	jg     80066c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800688:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80068b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068f:	ba 00 00 00 00       	mov    $0x0,%edx
  800694:	48 f7 f1             	div    %rcx
  800697:	48 89 d0             	mov    %rdx,%rax
  80069a:	48 ba 68 46 80 00 00 	movabs $0x804668,%rdx
  8006a1:	00 00 00 
  8006a4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006a8:	0f be c0             	movsbl %al,%eax
  8006ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006af:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006b3:	48 89 d6             	mov    %rdx,%rsi
  8006b6:	89 c7                	mov    %eax,%edi
  8006b8:	ff d1                	callq  *%rcx
}
  8006ba:	c9                   	leaveq 
  8006bb:	c3                   	retq   

00000000008006bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006bc:	55                   	push   %rbp
  8006bd:	48 89 e5             	mov    %rsp,%rbp
  8006c0:	48 83 ec 20          	sub    $0x20,%rsp
  8006c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006c8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006cb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006cf:	7e 52                	jle    800723 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d5:	8b 00                	mov    (%rax),%eax
  8006d7:	83 f8 30             	cmp    $0x30,%eax
  8006da:	73 24                	jae    800700 <getuint+0x44>
  8006dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	8b 00                	mov    (%rax),%eax
  8006ea:	89 c0                	mov    %eax,%eax
  8006ec:	48 01 d0             	add    %rdx,%rax
  8006ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f3:	8b 12                	mov    (%rdx),%edx
  8006f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fc:	89 0a                	mov    %ecx,(%rdx)
  8006fe:	eb 17                	jmp    800717 <getuint+0x5b>
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800708:	48 89 d0             	mov    %rdx,%rax
  80070b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800713:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800717:	48 8b 00             	mov    (%rax),%rax
  80071a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80071e:	e9 a3 00 00 00       	jmpq   8007c6 <getuint+0x10a>
	else if (lflag)
  800723:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800727:	74 4f                	je     800778 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	8b 00                	mov    (%rax),%eax
  80072f:	83 f8 30             	cmp    $0x30,%eax
  800732:	73 24                	jae    800758 <getuint+0x9c>
  800734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800738:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	89 c0                	mov    %eax,%eax
  800744:	48 01 d0             	add    %rdx,%rax
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	8b 12                	mov    (%rdx),%edx
  80074d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800750:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800754:	89 0a                	mov    %ecx,(%rdx)
  800756:	eb 17                	jmp    80076f <getuint+0xb3>
  800758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800760:	48 89 d0             	mov    %rdx,%rax
  800763:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800767:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076f:	48 8b 00             	mov    (%rax),%rax
  800772:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800776:	eb 4e                	jmp    8007c6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	8b 00                	mov    (%rax),%eax
  80077e:	83 f8 30             	cmp    $0x30,%eax
  800781:	73 24                	jae    8007a7 <getuint+0xeb>
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078f:	8b 00                	mov    (%rax),%eax
  800791:	89 c0                	mov    %eax,%eax
  800793:	48 01 d0             	add    %rdx,%rax
  800796:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079a:	8b 12                	mov    (%rdx),%edx
  80079c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a3:	89 0a                	mov    %ecx,(%rdx)
  8007a5:	eb 17                	jmp    8007be <getuint+0x102>
  8007a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ab:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007af:	48 89 d0             	mov    %rdx,%rax
  8007b2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007be:	8b 00                	mov    (%rax),%eax
  8007c0:	89 c0                	mov    %eax,%eax
  8007c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ca:	c9                   	leaveq 
  8007cb:	c3                   	retq   

00000000008007cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cc:	55                   	push   %rbp
  8007cd:	48 89 e5             	mov    %rsp,%rbp
  8007d0:	48 83 ec 20          	sub    $0x20,%rsp
  8007d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007df:	7e 52                	jle    800833 <getint+0x67>
		x=va_arg(*ap, long long);
  8007e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e5:	8b 00                	mov    (%rax),%eax
  8007e7:	83 f8 30             	cmp    $0x30,%eax
  8007ea:	73 24                	jae    800810 <getint+0x44>
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	8b 00                	mov    (%rax),%eax
  8007fa:	89 c0                	mov    %eax,%eax
  8007fc:	48 01 d0             	add    %rdx,%rax
  8007ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800803:	8b 12                	mov    (%rdx),%edx
  800805:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800808:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080c:	89 0a                	mov    %ecx,(%rdx)
  80080e:	eb 17                	jmp    800827 <getint+0x5b>
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800818:	48 89 d0             	mov    %rdx,%rax
  80081b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800823:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800827:	48 8b 00             	mov    (%rax),%rax
  80082a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082e:	e9 a3 00 00 00       	jmpq   8008d6 <getint+0x10a>
	else if (lflag)
  800833:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800837:	74 4f                	je     800888 <getint+0xbc>
		x=va_arg(*ap, long);
  800839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083d:	8b 00                	mov    (%rax),%eax
  80083f:	83 f8 30             	cmp    $0x30,%eax
  800842:	73 24                	jae    800868 <getint+0x9c>
  800844:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800848:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	8b 00                	mov    (%rax),%eax
  800852:	89 c0                	mov    %eax,%eax
  800854:	48 01 d0             	add    %rdx,%rax
  800857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085b:	8b 12                	mov    (%rdx),%edx
  80085d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800860:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800864:	89 0a                	mov    %ecx,(%rdx)
  800866:	eb 17                	jmp    80087f <getint+0xb3>
  800868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800870:	48 89 d0             	mov    %rdx,%rax
  800873:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800877:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087f:	48 8b 00             	mov    (%rax),%rax
  800882:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800886:	eb 4e                	jmp    8008d6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088c:	8b 00                	mov    (%rax),%eax
  80088e:	83 f8 30             	cmp    $0x30,%eax
  800891:	73 24                	jae    8008b7 <getint+0xeb>
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	8b 00                	mov    (%rax),%eax
  8008a1:	89 c0                	mov    %eax,%eax
  8008a3:	48 01 d0             	add    %rdx,%rax
  8008a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008aa:	8b 12                	mov    (%rdx),%edx
  8008ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b3:	89 0a                	mov    %ecx,(%rdx)
  8008b5:	eb 17                	jmp    8008ce <getint+0x102>
  8008b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008bf:	48 89 d0             	mov    %rdx,%rax
  8008c2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ce:	8b 00                	mov    (%rax),%eax
  8008d0:	48 98                	cltq   
  8008d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008da:	c9                   	leaveq 
  8008db:	c3                   	retq   

00000000008008dc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
  8008e0:	41 54                	push   %r12
  8008e2:	53                   	push   %rbx
  8008e3:	48 83 ec 60          	sub    $0x60,%rsp
  8008e7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008eb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008ef:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008f7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008fb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008ff:	48 8b 0a             	mov    (%rdx),%rcx
  800902:	48 89 08             	mov    %rcx,(%rax)
  800905:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800909:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80090d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800911:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800915:	eb 17                	jmp    80092e <vprintfmt+0x52>
			if (ch == '\0')
  800917:	85 db                	test   %ebx,%ebx
  800919:	0f 84 d7 04 00 00    	je     800df6 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  80091f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800923:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800927:	48 89 c6             	mov    %rax,%rsi
  80092a:	89 df                	mov    %ebx,%edi
  80092c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800932:	0f b6 00             	movzbl (%rax),%eax
  800935:	0f b6 d8             	movzbl %al,%ebx
  800938:	83 fb 25             	cmp    $0x25,%ebx
  80093b:	0f 95 c0             	setne  %al
  80093e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800943:	84 c0                	test   %al,%al
  800945:	75 d0                	jne    800917 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800947:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80094b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800952:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800959:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800960:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800967:	eb 04                	jmp    80096d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800969:	90                   	nop
  80096a:	eb 01                	jmp    80096d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80096c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800971:	0f b6 00             	movzbl (%rax),%eax
  800974:	0f b6 d8             	movzbl %al,%ebx
  800977:	89 d8                	mov    %ebx,%eax
  800979:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80097e:	83 e8 23             	sub    $0x23,%eax
  800981:	83 f8 55             	cmp    $0x55,%eax
  800984:	0f 87 38 04 00 00    	ja     800dc2 <vprintfmt+0x4e6>
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800993:	00 
  800994:	48 b8 90 46 80 00 00 	movabs $0x804690,%rax
  80099b:	00 00 00 
  80099e:	48 01 d0             	add    %rdx,%rax
  8009a1:	48 8b 00             	mov    (%rax),%rax
  8009a4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009a6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009aa:	eb c1                	jmp    80096d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ac:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009b0:	eb bb                	jmp    80096d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009b9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009bc:	89 d0                	mov    %edx,%eax
  8009be:	c1 e0 02             	shl    $0x2,%eax
  8009c1:	01 d0                	add    %edx,%eax
  8009c3:	01 c0                	add    %eax,%eax
  8009c5:	01 d8                	add    %ebx,%eax
  8009c7:	83 e8 30             	sub    $0x30,%eax
  8009ca:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009cd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d1:	0f b6 00             	movzbl (%rax),%eax
  8009d4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d7:	83 fb 2f             	cmp    $0x2f,%ebx
  8009da:	7e 63                	jle    800a3f <vprintfmt+0x163>
  8009dc:	83 fb 39             	cmp    $0x39,%ebx
  8009df:	7f 5e                	jg     800a3f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e6:	eb d1                	jmp    8009b9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009eb:	83 f8 30             	cmp    $0x30,%eax
  8009ee:	73 17                	jae    800a07 <vprintfmt+0x12b>
  8009f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f7:	89 c0                	mov    %eax,%eax
  8009f9:	48 01 d0             	add    %rdx,%rax
  8009fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ff:	83 c2 08             	add    $0x8,%edx
  800a02:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a05:	eb 0f                	jmp    800a16 <vprintfmt+0x13a>
  800a07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0b:	48 89 d0             	mov    %rdx,%rax
  800a0e:	48 83 c2 08          	add    $0x8,%rdx
  800a12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a16:	8b 00                	mov    (%rax),%eax
  800a18:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a1b:	eb 23                	jmp    800a40 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800a1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a21:	0f 89 42 ff ff ff    	jns    800969 <vprintfmt+0x8d>
				width = 0;
  800a27:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a2e:	e9 36 ff ff ff       	jmpq   800969 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800a33:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a3a:	e9 2e ff ff ff       	jmpq   80096d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a3f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a44:	0f 89 22 ff ff ff    	jns    80096c <vprintfmt+0x90>
				width = precision, precision = -1;
  800a4a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a4d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a50:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a57:	e9 10 ff ff ff       	jmpq   80096c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a5c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a60:	e9 08 ff ff ff       	jmpq   80096d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a68:	83 f8 30             	cmp    $0x30,%eax
  800a6b:	73 17                	jae    800a84 <vprintfmt+0x1a8>
  800a6d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a74:	89 c0                	mov    %eax,%eax
  800a76:	48 01 d0             	add    %rdx,%rax
  800a79:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7c:	83 c2 08             	add    $0x8,%edx
  800a7f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a82:	eb 0f                	jmp    800a93 <vprintfmt+0x1b7>
  800a84:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a88:	48 89 d0             	mov    %rdx,%rax
  800a8b:	48 83 c2 08          	add    $0x8,%rdx
  800a8f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a93:	8b 00                	mov    (%rax),%eax
  800a95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a99:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a9d:	48 89 d6             	mov    %rdx,%rsi
  800aa0:	89 c7                	mov    %eax,%edi
  800aa2:	ff d1                	callq  *%rcx
			break;
  800aa4:	e9 47 03 00 00       	jmpq   800df0 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800aa9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aac:	83 f8 30             	cmp    $0x30,%eax
  800aaf:	73 17                	jae    800ac8 <vprintfmt+0x1ec>
  800ab1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab8:	89 c0                	mov    %eax,%eax
  800aba:	48 01 d0             	add    %rdx,%rax
  800abd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac0:	83 c2 08             	add    $0x8,%edx
  800ac3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac6:	eb 0f                	jmp    800ad7 <vprintfmt+0x1fb>
  800ac8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acc:	48 89 d0             	mov    %rdx,%rax
  800acf:	48 83 c2 08          	add    $0x8,%rdx
  800ad3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ad9:	85 db                	test   %ebx,%ebx
  800adb:	79 02                	jns    800adf <vprintfmt+0x203>
				err = -err;
  800add:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800adf:	83 fb 10             	cmp    $0x10,%ebx
  800ae2:	7f 16                	jg     800afa <vprintfmt+0x21e>
  800ae4:	48 b8 e0 45 80 00 00 	movabs $0x8045e0,%rax
  800aeb:	00 00 00 
  800aee:	48 63 d3             	movslq %ebx,%rdx
  800af1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800af5:	4d 85 e4             	test   %r12,%r12
  800af8:	75 2e                	jne    800b28 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800afa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800afe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b02:	89 d9                	mov    %ebx,%ecx
  800b04:	48 ba 79 46 80 00 00 	movabs $0x804679,%rdx
  800b0b:	00 00 00 
  800b0e:	48 89 c7             	mov    %rax,%rdi
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
  800b16:	49 b8 00 0e 80 00 00 	movabs $0x800e00,%r8
  800b1d:	00 00 00 
  800b20:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b23:	e9 c8 02 00 00       	jmpq   800df0 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b28:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b30:	4c 89 e1             	mov    %r12,%rcx
  800b33:	48 ba 82 46 80 00 00 	movabs $0x804682,%rdx
  800b3a:	00 00 00 
  800b3d:	48 89 c7             	mov    %rax,%rdi
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
  800b45:	49 b8 00 0e 80 00 00 	movabs $0x800e00,%r8
  800b4c:	00 00 00 
  800b4f:	41 ff d0             	callq  *%r8
			break;
  800b52:	e9 99 02 00 00       	jmpq   800df0 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5a:	83 f8 30             	cmp    $0x30,%eax
  800b5d:	73 17                	jae    800b76 <vprintfmt+0x29a>
  800b5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b66:	89 c0                	mov    %eax,%eax
  800b68:	48 01 d0             	add    %rdx,%rax
  800b6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b6e:	83 c2 08             	add    $0x8,%edx
  800b71:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b74:	eb 0f                	jmp    800b85 <vprintfmt+0x2a9>
  800b76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7a:	48 89 d0             	mov    %rdx,%rax
  800b7d:	48 83 c2 08          	add    $0x8,%rdx
  800b81:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b85:	4c 8b 20             	mov    (%rax),%r12
  800b88:	4d 85 e4             	test   %r12,%r12
  800b8b:	75 0a                	jne    800b97 <vprintfmt+0x2bb>
				p = "(null)";
  800b8d:	49 bc 85 46 80 00 00 	movabs $0x804685,%r12
  800b94:	00 00 00 
			if (width > 0 && padc != '-')
  800b97:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9b:	7e 7a                	jle    800c17 <vprintfmt+0x33b>
  800b9d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ba1:	74 74                	je     800c17 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ba6:	48 98                	cltq   
  800ba8:	48 89 c6             	mov    %rax,%rsi
  800bab:	4c 89 e7             	mov    %r12,%rdi
  800bae:	48 b8 aa 10 80 00 00 	movabs $0x8010aa,%rax
  800bb5:	00 00 00 
  800bb8:	ff d0                	callq  *%rax
  800bba:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bbd:	eb 17                	jmp    800bd6 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800bbf:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800bc3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800bcb:	48 89 d6             	mov    %rdx,%rsi
  800bce:	89 c7                	mov    %eax,%edi
  800bd0:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bda:	7f e3                	jg     800bbf <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bdc:	eb 39                	jmp    800c17 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800bde:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800be2:	74 1e                	je     800c02 <vprintfmt+0x326>
  800be4:	83 fb 1f             	cmp    $0x1f,%ebx
  800be7:	7e 05                	jle    800bee <vprintfmt+0x312>
  800be9:	83 fb 7e             	cmp    $0x7e,%ebx
  800bec:	7e 14                	jle    800c02 <vprintfmt+0x326>
					putch('?', putdat);
  800bee:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bf2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bf6:	48 89 c6             	mov    %rax,%rsi
  800bf9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bfe:	ff d2                	callq  *%rdx
  800c00:	eb 0f                	jmp    800c11 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c02:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c06:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c0a:	48 89 c6             	mov    %rax,%rsi
  800c0d:	89 df                	mov    %ebx,%edi
  800c0f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c11:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c15:	eb 01                	jmp    800c18 <vprintfmt+0x33c>
  800c17:	90                   	nop
  800c18:	41 0f b6 04 24       	movzbl (%r12),%eax
  800c1d:	0f be d8             	movsbl %al,%ebx
  800c20:	85 db                	test   %ebx,%ebx
  800c22:	0f 95 c0             	setne  %al
  800c25:	49 83 c4 01          	add    $0x1,%r12
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 28                	je     800c55 <vprintfmt+0x379>
  800c2d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c31:	78 ab                	js     800bde <vprintfmt+0x302>
  800c33:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c37:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c3b:	79 a1                	jns    800bde <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c3d:	eb 16                	jmp    800c55 <vprintfmt+0x379>
				putch(' ', putdat);
  800c3f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c43:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c47:	48 89 c6             	mov    %rax,%rsi
  800c4a:	bf 20 00 00 00       	mov    $0x20,%edi
  800c4f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c51:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c59:	7f e4                	jg     800c3f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c5b:	e9 90 01 00 00       	jmpq   800df0 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c60:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c64:	be 03 00 00 00       	mov    $0x3,%esi
  800c69:	48 89 c7             	mov    %rax,%rdi
  800c6c:	48 b8 cc 07 80 00 00 	movabs $0x8007cc,%rax
  800c73:	00 00 00 
  800c76:	ff d0                	callq  *%rax
  800c78:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c80:	48 85 c0             	test   %rax,%rax
  800c83:	79 1d                	jns    800ca2 <vprintfmt+0x3c6>
				putch('-', putdat);
  800c85:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c89:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c8d:	48 89 c6             	mov    %rax,%rsi
  800c90:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c95:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9b:	48 f7 d8             	neg    %rax
  800c9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ca2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ca9:	e9 d5 00 00 00       	jmpq   800d83 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cae:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb2:	be 03 00 00 00       	mov    $0x3,%esi
  800cb7:	48 89 c7             	mov    %rax,%rdi
  800cba:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  800cc1:	00 00 00 
  800cc4:	ff d0                	callq  *%rax
  800cc6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cca:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd1:	e9 ad 00 00 00       	jmpq   800d83 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800cd6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cda:	be 03 00 00 00       	mov    $0x3,%esi
  800cdf:	48 89 c7             	mov    %rax,%rdi
  800ce2:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  800ce9:	00 00 00 
  800cec:	ff d0                	callq  *%rax
  800cee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800cf2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cf9:	e9 85 00 00 00       	jmpq   800d83 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800cfe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d02:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d06:	48 89 c6             	mov    %rax,%rsi
  800d09:	bf 30 00 00 00       	mov    $0x30,%edi
  800d0e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800d10:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d14:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d18:	48 89 c6             	mov    %rax,%rsi
  800d1b:	bf 78 00 00 00       	mov    $0x78,%edi
  800d20:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d25:	83 f8 30             	cmp    $0x30,%eax
  800d28:	73 17                	jae    800d41 <vprintfmt+0x465>
  800d2a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d31:	89 c0                	mov    %eax,%eax
  800d33:	48 01 d0             	add    %rdx,%rax
  800d36:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d39:	83 c2 08             	add    $0x8,%edx
  800d3c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d3f:	eb 0f                	jmp    800d50 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800d41:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d45:	48 89 d0             	mov    %rdx,%rax
  800d48:	48 83 c2 08          	add    $0x8,%rdx
  800d4c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d50:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d53:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d57:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d5e:	eb 23                	jmp    800d83 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d60:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d64:	be 03 00 00 00       	mov    $0x3,%esi
  800d69:	48 89 c7             	mov    %rax,%rdi
  800d6c:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  800d73:	00 00 00 
  800d76:	ff d0                	callq  *%rax
  800d78:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d7c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d83:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d88:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d8b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d92:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9a:	45 89 c1             	mov    %r8d,%r9d
  800d9d:	41 89 f8             	mov    %edi,%r8d
  800da0:	48 89 c7             	mov    %rax,%rdi
  800da3:	48 b8 04 06 80 00 00 	movabs $0x800604,%rax
  800daa:	00 00 00 
  800dad:	ff d0                	callq  *%rax
			break;
  800daf:	eb 3f                	jmp    800df0 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800db5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800db9:	48 89 c6             	mov    %rax,%rsi
  800dbc:	89 df                	mov    %ebx,%edi
  800dbe:	ff d2                	callq  *%rdx
			break;
  800dc0:	eb 2e                	jmp    800df0 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dc2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dc6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dca:	48 89 c6             	mov    %rax,%rsi
  800dcd:	bf 25 00 00 00       	mov    $0x25,%edi
  800dd2:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd9:	eb 05                	jmp    800de0 <vprintfmt+0x504>
  800ddb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800de0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800de4:	48 83 e8 01          	sub    $0x1,%rax
  800de8:	0f b6 00             	movzbl (%rax),%eax
  800deb:	3c 25                	cmp    $0x25,%al
  800ded:	75 ec                	jne    800ddb <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800def:	90                   	nop
		}
	}
  800df0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800df1:	e9 38 fb ff ff       	jmpq   80092e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800df6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800df7:	48 83 c4 60          	add    $0x60,%rsp
  800dfb:	5b                   	pop    %rbx
  800dfc:	41 5c                	pop    %r12
  800dfe:	5d                   	pop    %rbp
  800dff:	c3                   	retq   

0000000000800e00 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e00:	55                   	push   %rbp
  800e01:	48 89 e5             	mov    %rsp,%rbp
  800e04:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e0b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e12:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e19:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e20:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e27:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e2e:	84 c0                	test   %al,%al
  800e30:	74 20                	je     800e52 <printfmt+0x52>
  800e32:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e36:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e3a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e3e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e42:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e46:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e4a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e4e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e52:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e59:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e60:	00 00 00 
  800e63:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e6a:	00 00 00 
  800e6d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e71:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e78:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e7f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e86:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e8d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e94:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e9b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ea2:	48 89 c7             	mov    %rax,%rdi
  800ea5:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  800eac:	00 00 00 
  800eaf:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eb1:	c9                   	leaveq 
  800eb2:	c3                   	retq   

0000000000800eb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eb3:	55                   	push   %rbp
  800eb4:	48 89 e5             	mov    %rsp,%rbp
  800eb7:	48 83 ec 10          	sub    $0x10,%rsp
  800ebb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ebe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec6:	8b 40 10             	mov    0x10(%rax),%eax
  800ec9:	8d 50 01             	lea    0x1(%rax),%edx
  800ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed7:	48 8b 10             	mov    (%rax),%rdx
  800eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ede:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ee2:	48 39 c2             	cmp    %rax,%rdx
  800ee5:	73 17                	jae    800efe <sprintputch+0x4b>
		*b->buf++ = ch;
  800ee7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eeb:	48 8b 00             	mov    (%rax),%rax
  800eee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ef1:	88 10                	mov    %dl,(%rax)
  800ef3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800efb:	48 89 10             	mov    %rdx,(%rax)
}
  800efe:	c9                   	leaveq 
  800eff:	c3                   	retq   

0000000000800f00 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f00:	55                   	push   %rbp
  800f01:	48 89 e5             	mov    %rsp,%rbp
  800f04:	48 83 ec 50          	sub    $0x50,%rsp
  800f08:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f0c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f0f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f13:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f17:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f1b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f1f:	48 8b 0a             	mov    (%rdx),%rcx
  800f22:	48 89 08             	mov    %rcx,(%rax)
  800f25:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f29:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f2d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f31:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f35:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f39:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f3d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f40:	48 98                	cltq   
  800f42:	48 83 e8 01          	sub    $0x1,%rax
  800f46:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f4a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f4e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f55:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f5a:	74 06                	je     800f62 <vsnprintf+0x62>
  800f5c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f60:	7f 07                	jg     800f69 <vsnprintf+0x69>
		return -E_INVAL;
  800f62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f67:	eb 2f                	jmp    800f98 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f69:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f6d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f71:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f75:	48 89 c6             	mov    %rax,%rsi
  800f78:	48 bf b3 0e 80 00 00 	movabs $0x800eb3,%rdi
  800f7f:	00 00 00 
  800f82:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  800f89:	00 00 00 
  800f8c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f92:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f95:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f98:	c9                   	leaveq 
  800f99:	c3                   	retq   

0000000000800f9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f9a:	55                   	push   %rbp
  800f9b:	48 89 e5             	mov    %rsp,%rbp
  800f9e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fa5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fac:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fb2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fb9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fc0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fc7:	84 c0                	test   %al,%al
  800fc9:	74 20                	je     800feb <snprintf+0x51>
  800fcb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fcf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fd3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fd7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fdb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fdf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fe3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fe7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800feb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ff2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ff9:	00 00 00 
  800ffc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801003:	00 00 00 
  801006:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80100a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801011:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801018:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80101f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801026:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80102d:	48 8b 0a             	mov    (%rdx),%rcx
  801030:	48 89 08             	mov    %rcx,(%rax)
  801033:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801037:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80103b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80103f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801043:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80104a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801051:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801057:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80105e:	48 89 c7             	mov    %rax,%rdi
  801061:	48 b8 00 0f 80 00 00 	movabs $0x800f00,%rax
  801068:	00 00 00 
  80106b:	ff d0                	callq  *%rax
  80106d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801073:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801079:	c9                   	leaveq 
  80107a:	c3                   	retq   
	...

000000000080107c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80107c:	55                   	push   %rbp
  80107d:	48 89 e5             	mov    %rsp,%rbp
  801080:	48 83 ec 18          	sub    $0x18,%rsp
  801084:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801088:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80108f:	eb 09                	jmp    80109a <strlen+0x1e>
		n++;
  801091:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80109a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	84 c0                	test   %al,%al
  8010a3:	75 ec                	jne    801091 <strlen+0x15>
		n++;
	return n;
  8010a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a8:	c9                   	leaveq 
  8010a9:	c3                   	retq   

00000000008010aa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010aa:	55                   	push   %rbp
  8010ab:	48 89 e5             	mov    %rsp,%rbp
  8010ae:	48 83 ec 20          	sub    $0x20,%rsp
  8010b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010c1:	eb 0e                	jmp    8010d1 <strnlen+0x27>
		n++;
  8010c3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010cc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010d1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010d6:	74 0b                	je     8010e3 <strnlen+0x39>
  8010d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dc:	0f b6 00             	movzbl (%rax),%eax
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 e0                	jne    8010c3 <strnlen+0x19>
		n++;
	return n;
  8010e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010e6:	c9                   	leaveq 
  8010e7:	c3                   	retq   

00000000008010e8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010e8:	55                   	push   %rbp
  8010e9:	48 89 e5             	mov    %rsp,%rbp
  8010ec:	48 83 ec 20          	sub    $0x20,%rsp
  8010f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801100:	90                   	nop
  801101:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801105:	0f b6 10             	movzbl (%rax),%edx
  801108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110c:	88 10                	mov    %dl,(%rax)
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	0f b6 00             	movzbl (%rax),%eax
  801115:	84 c0                	test   %al,%al
  801117:	0f 95 c0             	setne  %al
  80111a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80111f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801124:	84 c0                	test   %al,%al
  801126:	75 d9                	jne    801101 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80112c:	c9                   	leaveq 
  80112d:	c3                   	retq   

000000000080112e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80112e:	55                   	push   %rbp
  80112f:	48 89 e5             	mov    %rsp,%rbp
  801132:	48 83 ec 20          	sub    $0x20,%rsp
  801136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80113e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801142:	48 89 c7             	mov    %rax,%rdi
  801145:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  80114c:	00 00 00 
  80114f:	ff d0                	callq  *%rax
  801151:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801157:	48 98                	cltq   
  801159:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80115d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801161:	48 89 d6             	mov    %rdx,%rsi
  801164:	48 89 c7             	mov    %rax,%rdi
  801167:	48 b8 e8 10 80 00 00 	movabs $0x8010e8,%rax
  80116e:	00 00 00 
  801171:	ff d0                	callq  *%rax
	return dst;
  801173:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801177:	c9                   	leaveq 
  801178:	c3                   	retq   

0000000000801179 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801179:	55                   	push   %rbp
  80117a:	48 89 e5             	mov    %rsp,%rbp
  80117d:	48 83 ec 28          	sub    $0x28,%rsp
  801181:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801185:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801189:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801195:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80119c:	00 
  80119d:	eb 27                	jmp    8011c6 <strncpy+0x4d>
		*dst++ = *src;
  80119f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a3:	0f b6 10             	movzbl (%rax),%edx
  8011a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011aa:	88 10                	mov    %dl,(%rax)
  8011ac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b5:	0f b6 00             	movzbl (%rax),%eax
  8011b8:	84 c0                	test   %al,%al
  8011ba:	74 05                	je     8011c1 <strncpy+0x48>
			src++;
  8011bc:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ca:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011ce:	72 cf                	jb     80119f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 28          	sub    $0x28,%rsp
  8011de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011f2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f7:	74 37                	je     801230 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8011f9:	eb 17                	jmp    801212 <strlcpy+0x3c>
			*dst++ = *src++;
  8011fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ff:	0f b6 10             	movzbl (%rax),%edx
  801202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801206:	88 10                	mov    %dl,(%rax)
  801208:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80120d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801212:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801217:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80121c:	74 0b                	je     801229 <strlcpy+0x53>
  80121e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801222:	0f b6 00             	movzbl (%rax),%eax
  801225:	84 c0                	test   %al,%al
  801227:	75 d2                	jne    8011fb <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801230:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801238:	48 89 d1             	mov    %rdx,%rcx
  80123b:	48 29 c1             	sub    %rax,%rcx
  80123e:	48 89 c8             	mov    %rcx,%rax
}
  801241:	c9                   	leaveq 
  801242:	c3                   	retq   

0000000000801243 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801243:	55                   	push   %rbp
  801244:	48 89 e5             	mov    %rsp,%rbp
  801247:	48 83 ec 10          	sub    $0x10,%rsp
  80124b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801253:	eb 0a                	jmp    80125f <strcmp+0x1c>
		p++, q++;
  801255:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80125f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801263:	0f b6 00             	movzbl (%rax),%eax
  801266:	84 c0                	test   %al,%al
  801268:	74 12                	je     80127c <strcmp+0x39>
  80126a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126e:	0f b6 10             	movzbl (%rax),%edx
  801271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801275:	0f b6 00             	movzbl (%rax),%eax
  801278:	38 c2                	cmp    %al,%dl
  80127a:	74 d9                	je     801255 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80127c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801280:	0f b6 00             	movzbl (%rax),%eax
  801283:	0f b6 d0             	movzbl %al,%edx
  801286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128a:	0f b6 00             	movzbl (%rax),%eax
  80128d:	0f b6 c0             	movzbl %al,%eax
  801290:	89 d1                	mov    %edx,%ecx
  801292:	29 c1                	sub    %eax,%ecx
  801294:	89 c8                	mov    %ecx,%eax
}
  801296:	c9                   	leaveq 
  801297:	c3                   	retq   

0000000000801298 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801298:	55                   	push   %rbp
  801299:	48 89 e5             	mov    %rsp,%rbp
  80129c:	48 83 ec 18          	sub    $0x18,%rsp
  8012a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012ac:	eb 0f                	jmp    8012bd <strncmp+0x25>
		n--, p++, q++;
  8012ae:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c2:	74 1d                	je     8012e1 <strncmp+0x49>
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	0f b6 00             	movzbl (%rax),%eax
  8012cb:	84 c0                	test   %al,%al
  8012cd:	74 12                	je     8012e1 <strncmp+0x49>
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	0f b6 10             	movzbl (%rax),%edx
  8012d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012da:	0f b6 00             	movzbl (%rax),%eax
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 cd                	je     8012ae <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e6:	75 07                	jne    8012ef <strncmp+0x57>
		return 0;
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	eb 1a                	jmp    801309 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	0f b6 00             	movzbl (%rax),%eax
  8012f6:	0f b6 d0             	movzbl %al,%edx
  8012f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fd:	0f b6 00             	movzbl (%rax),%eax
  801300:	0f b6 c0             	movzbl %al,%eax
  801303:	89 d1                	mov    %edx,%ecx
  801305:	29 c1                	sub    %eax,%ecx
  801307:	89 c8                	mov    %ecx,%eax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 10          	sub    $0x10,%rsp
  801313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801317:	89 f0                	mov    %esi,%eax
  801319:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80131c:	eb 17                	jmp    801335 <strchr+0x2a>
		if (*s == c)
  80131e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801328:	75 06                	jne    801330 <strchr+0x25>
			return (char *) s;
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	eb 15                	jmp    801345 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801330:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	84 c0                	test   %al,%al
  80133e:	75 de                	jne    80131e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801345:	c9                   	leaveq 
  801346:	c3                   	retq   

0000000000801347 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	48 83 ec 10          	sub    $0x10,%rsp
  80134f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801353:	89 f0                	mov    %esi,%eax
  801355:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801358:	eb 11                	jmp    80136b <strfind+0x24>
		if (*s == c)
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801364:	74 12                	je     801378 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801366:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136f:	0f b6 00             	movzbl (%rax),%eax
  801372:	84 c0                	test   %al,%al
  801374:	75 e4                	jne    80135a <strfind+0x13>
  801376:	eb 01                	jmp    801379 <strfind+0x32>
		if (*s == c)
			break;
  801378:	90                   	nop
	return (char *) s;
  801379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137d:	c9                   	leaveq 
  80137e:	c3                   	retq   

000000000080137f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80137f:	55                   	push   %rbp
  801380:	48 89 e5             	mov    %rsp,%rbp
  801383:	48 83 ec 18          	sub    $0x18,%rsp
  801387:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80138e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801392:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801397:	75 06                	jne    80139f <memset+0x20>
		return v;
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	eb 69                	jmp    801408 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80139f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a3:	83 e0 03             	and    $0x3,%eax
  8013a6:	48 85 c0             	test   %rax,%rax
  8013a9:	75 48                	jne    8013f3 <memset+0x74>
  8013ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013af:	83 e0 03             	and    $0x3,%eax
  8013b2:	48 85 c0             	test   %rax,%rax
  8013b5:	75 3c                	jne    8013f3 <memset+0x74>
		c &= 0xFF;
  8013b7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c1:	89 c2                	mov    %eax,%edx
  8013c3:	c1 e2 18             	shl    $0x18,%edx
  8013c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c9:	c1 e0 10             	shl    $0x10,%eax
  8013cc:	09 c2                	or     %eax,%edx
  8013ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d1:	c1 e0 08             	shl    $0x8,%eax
  8013d4:	09 d0                	or     %edx,%eax
  8013d6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dd:	48 89 c1             	mov    %rax,%rcx
  8013e0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013eb:	48 89 d7             	mov    %rdx,%rdi
  8013ee:	fc                   	cld    
  8013ef:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013f1:	eb 11                	jmp    801404 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013fa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013fe:	48 89 d7             	mov    %rdx,%rdi
  801401:	fc                   	cld    
  801402:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801404:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801408:	c9                   	leaveq 
  801409:	c3                   	retq   

000000000080140a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80140a:	55                   	push   %rbp
  80140b:	48 89 e5             	mov    %rsp,%rbp
  80140e:	48 83 ec 28          	sub    $0x28,%rsp
  801412:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801416:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80141a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80141e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801422:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80142e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801432:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801436:	0f 83 88 00 00 00    	jae    8014c4 <memmove+0xba>
  80143c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801440:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801444:	48 01 d0             	add    %rdx,%rax
  801447:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144b:	76 77                	jbe    8014c4 <memmove+0xba>
		s += n;
  80144d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801451:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801459:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80145d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801461:	83 e0 03             	and    $0x3,%eax
  801464:	48 85 c0             	test   %rax,%rax
  801467:	75 3b                	jne    8014a4 <memmove+0x9a>
  801469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146d:	83 e0 03             	and    $0x3,%eax
  801470:	48 85 c0             	test   %rax,%rax
  801473:	75 2f                	jne    8014a4 <memmove+0x9a>
  801475:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801479:	83 e0 03             	and    $0x3,%eax
  80147c:	48 85 c0             	test   %rax,%rax
  80147f:	75 23                	jne    8014a4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	48 83 e8 04          	sub    $0x4,%rax
  801489:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148d:	48 83 ea 04          	sub    $0x4,%rdx
  801491:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801495:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801499:	48 89 c7             	mov    %rax,%rdi
  80149c:	48 89 d6             	mov    %rdx,%rsi
  80149f:	fd                   	std    
  8014a0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a2:	eb 1d                	jmp    8014c1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b8:	48 89 d7             	mov    %rdx,%rdi
  8014bb:	48 89 c1             	mov    %rax,%rcx
  8014be:	fd                   	std    
  8014bf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014c1:	fc                   	cld    
  8014c2:	eb 57                	jmp    80151b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	83 e0 03             	and    $0x3,%eax
  8014cb:	48 85 c0             	test   %rax,%rax
  8014ce:	75 36                	jne    801506 <memmove+0xfc>
  8014d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d4:	83 e0 03             	and    $0x3,%eax
  8014d7:	48 85 c0             	test   %rax,%rax
  8014da:	75 2a                	jne    801506 <memmove+0xfc>
  8014dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e0:	83 e0 03             	and    $0x3,%eax
  8014e3:	48 85 c0             	test   %rax,%rax
  8014e6:	75 1e                	jne    801506 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	48 89 c1             	mov    %rax,%rcx
  8014ef:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fb:	48 89 c7             	mov    %rax,%rdi
  8014fe:	48 89 d6             	mov    %rdx,%rsi
  801501:	fc                   	cld    
  801502:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801504:	eb 15                	jmp    80151b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801512:	48 89 c7             	mov    %rax,%rdi
  801515:	48 89 d6             	mov    %rdx,%rsi
  801518:	fc                   	cld    
  801519:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80151b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80151f:	c9                   	leaveq 
  801520:	c3                   	retq   

0000000000801521 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801521:	55                   	push   %rbp
  801522:	48 89 e5             	mov    %rsp,%rbp
  801525:	48 83 ec 18          	sub    $0x18,%rsp
  801529:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801531:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801535:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801539:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801541:	48 89 ce             	mov    %rcx,%rsi
  801544:	48 89 c7             	mov    %rax,%rdi
  801547:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  80154e:	00 00 00 
  801551:	ff d0                	callq  *%rax
}
  801553:	c9                   	leaveq 
  801554:	c3                   	retq   

0000000000801555 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801555:	55                   	push   %rbp
  801556:	48 89 e5             	mov    %rsp,%rbp
  801559:	48 83 ec 28          	sub    $0x28,%rsp
  80155d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801561:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801565:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801571:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801575:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801579:	eb 38                	jmp    8015b3 <memcmp+0x5e>
		if (*s1 != *s2)
  80157b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157f:	0f b6 10             	movzbl (%rax),%edx
  801582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	38 c2                	cmp    %al,%dl
  80158b:	74 1c                	je     8015a9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80158d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801591:	0f b6 00             	movzbl (%rax),%eax
  801594:	0f b6 d0             	movzbl %al,%edx
  801597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	0f b6 c0             	movzbl %al,%eax
  8015a1:	89 d1                	mov    %edx,%ecx
  8015a3:	29 c1                	sub    %eax,%ecx
  8015a5:	89 c8                	mov    %ecx,%eax
  8015a7:	eb 20                	jmp    8015c9 <memcmp+0x74>
		s1++, s2++;
  8015a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ae:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015b8:	0f 95 c0             	setne  %al
  8015bb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 b7                	jne    80157b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c9:	c9                   	leaveq 
  8015ca:	c3                   	retq   

00000000008015cb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015cb:	55                   	push   %rbp
  8015cc:	48 89 e5             	mov    %rsp,%rbp
  8015cf:	48 83 ec 28          	sub    $0x28,%rsp
  8015d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e6:	48 01 d0             	add    %rdx,%rax
  8015e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015ed:	eb 13                	jmp    801602 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f3:	0f b6 10             	movzbl (%rax),%edx
  8015f6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015f9:	38 c2                	cmp    %al,%dl
  8015fb:	74 11                	je     80160e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015fd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801606:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80160a:	72 e3                	jb     8015ef <memfind+0x24>
  80160c:	eb 01                	jmp    80160f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80160e:	90                   	nop
	return (void *) s;
  80160f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801613:	c9                   	leaveq 
  801614:	c3                   	retq   

0000000000801615 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801615:	55                   	push   %rbp
  801616:	48 89 e5             	mov    %rsp,%rbp
  801619:	48 83 ec 38          	sub    $0x38,%rsp
  80161d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801621:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801625:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801628:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80162f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801636:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801637:	eb 05                	jmp    80163e <strtol+0x29>
		s++;
  801639:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	3c 20                	cmp    $0x20,%al
  801647:	74 f0                	je     801639 <strtol+0x24>
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	0f b6 00             	movzbl (%rax),%eax
  801650:	3c 09                	cmp    $0x9,%al
  801652:	74 e5                	je     801639 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	3c 2b                	cmp    $0x2b,%al
  80165d:	75 07                	jne    801666 <strtol+0x51>
		s++;
  80165f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801664:	eb 17                	jmp    80167d <strtol+0x68>
	else if (*s == '-')
  801666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166a:	0f b6 00             	movzbl (%rax),%eax
  80166d:	3c 2d                	cmp    $0x2d,%al
  80166f:	75 0c                	jne    80167d <strtol+0x68>
		s++, neg = 1;
  801671:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801676:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80167d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801681:	74 06                	je     801689 <strtol+0x74>
  801683:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801687:	75 28                	jne    8016b1 <strtol+0x9c>
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	3c 30                	cmp    $0x30,%al
  801692:	75 1d                	jne    8016b1 <strtol+0x9c>
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	48 83 c0 01          	add    $0x1,%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	3c 78                	cmp    $0x78,%al
  8016a1:	75 0e                	jne    8016b1 <strtol+0x9c>
		s += 2, base = 16;
  8016a3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016a8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016af:	eb 2c                	jmp    8016dd <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016b1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b5:	75 19                	jne    8016d0 <strtol+0xbb>
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	3c 30                	cmp    $0x30,%al
  8016c0:	75 0e                	jne    8016d0 <strtol+0xbb>
		s++, base = 8;
  8016c2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016ce:	eb 0d                	jmp    8016dd <strtol+0xc8>
	else if (base == 0)
  8016d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d4:	75 07                	jne    8016dd <strtol+0xc8>
		base = 10;
  8016d6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	3c 2f                	cmp    $0x2f,%al
  8016e6:	7e 1d                	jle    801705 <strtol+0xf0>
  8016e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	3c 39                	cmp    $0x39,%al
  8016f1:	7f 12                	jg     801705 <strtol+0xf0>
			dig = *s - '0';
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	0f be c0             	movsbl %al,%eax
  8016fd:	83 e8 30             	sub    $0x30,%eax
  801700:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801703:	eb 4e                	jmp    801753 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801709:	0f b6 00             	movzbl (%rax),%eax
  80170c:	3c 60                	cmp    $0x60,%al
  80170e:	7e 1d                	jle    80172d <strtol+0x118>
  801710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801714:	0f b6 00             	movzbl (%rax),%eax
  801717:	3c 7a                	cmp    $0x7a,%al
  801719:	7f 12                	jg     80172d <strtol+0x118>
			dig = *s - 'a' + 10;
  80171b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171f:	0f b6 00             	movzbl (%rax),%eax
  801722:	0f be c0             	movsbl %al,%eax
  801725:	83 e8 57             	sub    $0x57,%eax
  801728:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80172b:	eb 26                	jmp    801753 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	0f b6 00             	movzbl (%rax),%eax
  801734:	3c 40                	cmp    $0x40,%al
  801736:	7e 47                	jle    80177f <strtol+0x16a>
  801738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173c:	0f b6 00             	movzbl (%rax),%eax
  80173f:	3c 5a                	cmp    $0x5a,%al
  801741:	7f 3c                	jg     80177f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801743:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801747:	0f b6 00             	movzbl (%rax),%eax
  80174a:	0f be c0             	movsbl %al,%eax
  80174d:	83 e8 37             	sub    $0x37,%eax
  801750:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801753:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801756:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801759:	7d 23                	jge    80177e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80175b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801760:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801763:	48 98                	cltq   
  801765:	48 89 c2             	mov    %rax,%rdx
  801768:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80176d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801770:	48 98                	cltq   
  801772:	48 01 d0             	add    %rdx,%rax
  801775:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801779:	e9 5f ff ff ff       	jmpq   8016dd <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80177e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80177f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801784:	74 0b                	je     801791 <strtol+0x17c>
		*endptr = (char *) s;
  801786:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80178e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801791:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801795:	74 09                	je     8017a0 <strtol+0x18b>
  801797:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179b:	48 f7 d8             	neg    %rax
  80179e:	eb 04                	jmp    8017a4 <strtol+0x18f>
  8017a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017a4:	c9                   	leaveq 
  8017a5:	c3                   	retq   

00000000008017a6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017a6:	55                   	push   %rbp
  8017a7:	48 89 e5             	mov    %rsp,%rbp
  8017aa:	48 83 ec 30          	sub    $0x30,%rsp
  8017ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8017b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ba:	0f b6 00             	movzbl (%rax),%eax
  8017bd:	88 45 ff             	mov    %al,-0x1(%rbp)
  8017c0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8017c5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017c9:	75 06                	jne    8017d1 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	eb 68                	jmp    801839 <strstr+0x93>

    len = strlen(str);
  8017d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	48 98                	cltq   
  8017e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ee:	0f b6 00             	movzbl (%rax),%eax
  8017f1:	88 45 ef             	mov    %al,-0x11(%rbp)
  8017f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8017f9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017fd:	75 07                	jne    801806 <strstr+0x60>
                return (char *) 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801804:	eb 33                	jmp    801839 <strstr+0x93>
        } while (sc != c);
  801806:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80180a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80180d:	75 db                	jne    8017ea <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80180f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801813:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181b:	48 89 ce             	mov    %rcx,%rsi
  80181e:	48 89 c7             	mov    %rax,%rdi
  801821:	48 b8 98 12 80 00 00 	movabs $0x801298,%rax
  801828:	00 00 00 
  80182b:	ff d0                	callq  *%rax
  80182d:	85 c0                	test   %eax,%eax
  80182f:	75 b9                	jne    8017ea <strstr+0x44>

    return (char *) (in - 1);
  801831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801835:	48 83 e8 01          	sub    $0x1,%rax
}
  801839:	c9                   	leaveq 
  80183a:	c3                   	retq   
	...

000000000080183c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80183c:	55                   	push   %rbp
  80183d:	48 89 e5             	mov    %rsp,%rbp
  801840:	53                   	push   %rbx
  801841:	48 83 ec 58          	sub    $0x58,%rsp
  801845:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801848:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80184b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80184f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801853:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801857:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80185e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801861:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801865:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801869:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80186d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801871:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801875:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801878:	4c 89 c3             	mov    %r8,%rbx
  80187b:	cd 30                	int    $0x30
  80187d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801881:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801885:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801889:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80188d:	74 3e                	je     8018cd <syscall+0x91>
  80188f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801894:	7e 37                	jle    8018cd <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801896:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80189a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80189d:	49 89 d0             	mov    %rdx,%r8
  8018a0:	89 c1                	mov    %eax,%ecx
  8018a2:	48 ba 40 49 80 00 00 	movabs $0x804940,%rdx
  8018a9:	00 00 00 
  8018ac:	be 23 00 00 00       	mov    $0x23,%esi
  8018b1:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  8018b8:	00 00 00 
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c0:	49 b9 f0 3a 80 00 00 	movabs $0x803af0,%r9
  8018c7:	00 00 00 
  8018ca:	41 ff d1             	callq  *%r9

	return ret;
  8018cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018d1:	48 83 c4 58          	add    $0x58,%rsp
  8018d5:	5b                   	pop    %rbx
  8018d6:	5d                   	pop    %rbp
  8018d7:	c3                   	retq   

00000000008018d8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018d8:	55                   	push   %rbp
  8018d9:	48 89 e5             	mov    %rsp,%rbp
  8018dc:	48 83 ec 20          	sub    $0x20,%rsp
  8018e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f7:	00 
  8018f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801904:	48 89 d1             	mov    %rdx,%rcx
  801907:	48 89 c2             	mov    %rax,%rdx
  80190a:	be 00 00 00 00       	mov    $0x0,%esi
  80190f:	bf 00 00 00 00       	mov    $0x0,%edi
  801914:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  80191b:	00 00 00 
  80191e:	ff d0                	callq  *%rax
}
  801920:	c9                   	leaveq 
  801921:	c3                   	retq   

0000000000801922 <sys_cgetc>:

int
sys_cgetc(void)
{
  801922:	55                   	push   %rbp
  801923:	48 89 e5             	mov    %rsp,%rbp
  801926:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80192a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801931:	00 
  801932:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801938:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801943:	ba 00 00 00 00       	mov    $0x0,%edx
  801948:	be 00 00 00 00       	mov    $0x0,%esi
  80194d:	bf 01 00 00 00       	mov    $0x1,%edi
  801952:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
}
  80195e:	c9                   	leaveq 
  80195f:	c3                   	retq   

0000000000801960 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801960:	55                   	push   %rbp
  801961:	48 89 e5             	mov    %rsp,%rbp
  801964:	48 83 ec 20          	sub    $0x20,%rsp
  801968:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80196b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196e:	48 98                	cltq   
  801970:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801977:	00 
  801978:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801984:	b9 00 00 00 00       	mov    $0x0,%ecx
  801989:	48 89 c2             	mov    %rax,%rdx
  80198c:	be 01 00 00 00       	mov    $0x1,%esi
  801991:	bf 03 00 00 00       	mov    $0x3,%edi
  801996:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  80199d:	00 00 00 
  8019a0:	ff d0                	callq  *%rax
}
  8019a2:	c9                   	leaveq 
  8019a3:	c3                   	retq   

00000000008019a4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019a4:	55                   	push   %rbp
  8019a5:	48 89 e5             	mov    %rsp,%rbp
  8019a8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b3:	00 
  8019b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	be 00 00 00 00       	mov    $0x0,%esi
  8019cf:	bf 02 00 00 00       	mov    $0x2,%edi
  8019d4:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  8019db:	00 00 00 
  8019de:	ff d0                	callq  *%rax
}
  8019e0:	c9                   	leaveq 
  8019e1:	c3                   	retq   

00000000008019e2 <sys_yield>:

void
sys_yield(void)
{
  8019e2:	55                   	push   %rbp
  8019e3:	48 89 e5             	mov    %rsp,%rbp
  8019e6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f1:	00 
  8019f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a03:	ba 00 00 00 00       	mov    $0x0,%edx
  801a08:	be 00 00 00 00       	mov    $0x0,%esi
  801a0d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a12:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
}
  801a1e:	c9                   	leaveq 
  801a1f:	c3                   	retq   

0000000000801a20 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a20:	55                   	push   %rbp
  801a21:	48 89 e5             	mov    %rsp,%rbp
  801a24:	48 83 ec 20          	sub    $0x20,%rsp
  801a28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a35:	48 63 c8             	movslq %eax,%rcx
  801a38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a3f:	48 98                	cltq   
  801a41:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a48:	00 
  801a49:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4f:	49 89 c8             	mov    %rcx,%r8
  801a52:	48 89 d1             	mov    %rdx,%rcx
  801a55:	48 89 c2             	mov    %rax,%rdx
  801a58:	be 01 00 00 00       	mov    $0x1,%esi
  801a5d:	bf 04 00 00 00       	mov    $0x4,%edi
  801a62:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801a69:	00 00 00 
  801a6c:	ff d0                	callq  *%rax
}
  801a6e:	c9                   	leaveq 
  801a6f:	c3                   	retq   

0000000000801a70 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a70:	55                   	push   %rbp
  801a71:	48 89 e5             	mov    %rsp,%rbp
  801a74:	48 83 ec 30          	sub    $0x30,%rsp
  801a78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a7f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a82:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a86:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a8a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a8d:	48 63 c8             	movslq %eax,%rcx
  801a90:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a97:	48 63 f0             	movslq %eax,%rsi
  801a9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa1:	48 98                	cltq   
  801aa3:	48 89 0c 24          	mov    %rcx,(%rsp)
  801aa7:	49 89 f9             	mov    %rdi,%r9
  801aaa:	49 89 f0             	mov    %rsi,%r8
  801aad:	48 89 d1             	mov    %rdx,%rcx
  801ab0:	48 89 c2             	mov    %rax,%rdx
  801ab3:	be 01 00 00 00       	mov    $0x1,%esi
  801ab8:	bf 05 00 00 00       	mov    $0x5,%edi
  801abd:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801ac4:	00 00 00 
  801ac7:	ff d0                	callq  *%rax
}
  801ac9:	c9                   	leaveq 
  801aca:	c3                   	retq   

0000000000801acb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801acb:	55                   	push   %rbp
  801acc:	48 89 e5             	mov    %rsp,%rbp
  801acf:	48 83 ec 20          	sub    $0x20,%rsp
  801ad3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ada:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae1:	48 98                	cltq   
  801ae3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aea:	00 
  801aeb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af7:	48 89 d1             	mov    %rdx,%rcx
  801afa:	48 89 c2             	mov    %rax,%rdx
  801afd:	be 01 00 00 00       	mov    $0x1,%esi
  801b02:	bf 06 00 00 00       	mov    $0x6,%edi
  801b07:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801b0e:	00 00 00 
  801b11:	ff d0                	callq  *%rax
}
  801b13:	c9                   	leaveq 
  801b14:	c3                   	retq   

0000000000801b15 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	48 83 ec 20          	sub    $0x20,%rsp
  801b1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b20:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b26:	48 63 d0             	movslq %eax,%rdx
  801b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2c:	48 98                	cltq   
  801b2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b35:	00 
  801b36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b42:	48 89 d1             	mov    %rdx,%rcx
  801b45:	48 89 c2             	mov    %rax,%rdx
  801b48:	be 01 00 00 00       	mov    $0x1,%esi
  801b4d:	bf 08 00 00 00       	mov    $0x8,%edi
  801b52:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801b59:	00 00 00 
  801b5c:	ff d0                	callq  *%rax
}
  801b5e:	c9                   	leaveq 
  801b5f:	c3                   	retq   

0000000000801b60 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b60:	55                   	push   %rbp
  801b61:	48 89 e5             	mov    %rsp,%rbp
  801b64:	48 83 ec 20          	sub    $0x20,%rsp
  801b68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b76:	48 98                	cltq   
  801b78:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7f:	00 
  801b80:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8c:	48 89 d1             	mov    %rdx,%rcx
  801b8f:	48 89 c2             	mov    %rax,%rdx
  801b92:	be 01 00 00 00       	mov    $0x1,%esi
  801b97:	bf 09 00 00 00       	mov    $0x9,%edi
  801b9c:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	callq  *%rax
}
  801ba8:	c9                   	leaveq 
  801ba9:	c3                   	retq   

0000000000801baa <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801baa:	55                   	push   %rbp
  801bab:	48 89 e5             	mov    %rsp,%rbp
  801bae:	48 83 ec 20          	sub    $0x20,%rsp
  801bb2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc0:	48 98                	cltq   
  801bc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc9:	00 
  801bca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd6:	48 89 d1             	mov    %rdx,%rcx
  801bd9:	48 89 c2             	mov    %rax,%rdx
  801bdc:	be 01 00 00 00       	mov    $0x1,%esi
  801be1:	bf 0a 00 00 00       	mov    $0xa,%edi
  801be6:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801bed:	00 00 00 
  801bf0:	ff d0                	callq  *%rax
}
  801bf2:	c9                   	leaveq 
  801bf3:	c3                   	retq   

0000000000801bf4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bf4:	55                   	push   %rbp
  801bf5:	48 89 e5             	mov    %rsp,%rbp
  801bf8:	48 83 ec 30          	sub    $0x30,%rsp
  801bfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c03:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c07:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c0d:	48 63 f0             	movslq %eax,%rsi
  801c10:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c17:	48 98                	cltq   
  801c19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c24:	00 
  801c25:	49 89 f1             	mov    %rsi,%r9
  801c28:	49 89 c8             	mov    %rcx,%r8
  801c2b:	48 89 d1             	mov    %rdx,%rcx
  801c2e:	48 89 c2             	mov    %rax,%rdx
  801c31:	be 00 00 00 00       	mov    $0x0,%esi
  801c36:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c3b:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801c42:	00 00 00 
  801c45:	ff d0                	callq  *%rax
}
  801c47:	c9                   	leaveq 
  801c48:	c3                   	retq   

0000000000801c49 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c49:	55                   	push   %rbp
  801c4a:	48 89 e5             	mov    %rsp,%rbp
  801c4d:	48 83 ec 20          	sub    $0x20,%rsp
  801c51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c60:	00 
  801c61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c72:	48 89 c2             	mov    %rax,%rdx
  801c75:	be 01 00 00 00       	mov    $0x1,%esi
  801c7a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c7f:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801c86:	00 00 00 
  801c89:	ff d0                	callq  *%rax
}
  801c8b:	c9                   	leaveq 
  801c8c:	c3                   	retq   

0000000000801c8d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c8d:	55                   	push   %rbp
  801c8e:	48 89 e5             	mov    %rsp,%rbp
  801c91:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c95:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9c:	00 
  801c9d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cae:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb3:	be 00 00 00 00       	mov    $0x0,%esi
  801cb8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cbd:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   

0000000000801ccb <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 20          	sub    $0x20,%rsp
  801cd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801cdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cea:	00 
  801ceb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf7:	48 89 d1             	mov    %rdx,%rcx
  801cfa:	48 89 c2             	mov    %rax,%rdx
  801cfd:	be 00 00 00 00       	mov    $0x0,%esi
  801d02:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d07:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	callq  *%rax
}
  801d13:	c9                   	leaveq 
  801d14:	c3                   	retq   

0000000000801d15 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801d15:	55                   	push   %rbp
  801d16:	48 89 e5             	mov    %rsp,%rbp
  801d19:	48 83 ec 20          	sub    $0x20,%rsp
  801d1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d34:	00 
  801d35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d41:	48 89 d1             	mov    %rdx,%rcx
  801d44:	48 89 c2             	mov    %rax,%rdx
  801d47:	be 00 00 00 00       	mov    $0x0,%esi
  801d4c:	bf 10 00 00 00       	mov    $0x10,%edi
  801d51:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801d58:	00 00 00 
  801d5b:	ff d0                	callq  *%rax
}
  801d5d:	c9                   	leaveq 
  801d5e:	c3                   	retq   
	...

0000000000801d60 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d60:	55                   	push   %rbp
  801d61:	48 89 e5             	mov    %rsp,%rbp
  801d64:	48 83 ec 08          	sub    $0x8,%rsp
  801d68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d6c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d70:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d77:	ff ff ff 
  801d7a:	48 01 d0             	add    %rdx,%rax
  801d7d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d81:	c9                   	leaveq 
  801d82:	c3                   	retq   

0000000000801d83 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d83:	55                   	push   %rbp
  801d84:	48 89 e5             	mov    %rsp,%rbp
  801d87:	48 83 ec 08          	sub    $0x8,%rsp
  801d8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d93:	48 89 c7             	mov    %rax,%rdi
  801d96:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  801d9d:	00 00 00 
  801da0:	ff d0                	callq  *%rax
  801da2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801da8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801dac:	c9                   	leaveq 
  801dad:	c3                   	retq   

0000000000801dae <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dae:	55                   	push   %rbp
  801daf:	48 89 e5             	mov    %rsp,%rbp
  801db2:	48 83 ec 18          	sub    $0x18,%rsp
  801db6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dc1:	eb 6b                	jmp    801e2e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc6:	48 98                	cltq   
  801dc8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dce:	48 c1 e0 0c          	shl    $0xc,%rax
  801dd2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dda:	48 89 c2             	mov    %rax,%rdx
  801ddd:	48 c1 ea 15          	shr    $0x15,%rdx
  801de1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801de8:	01 00 00 
  801deb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801def:	83 e0 01             	and    $0x1,%eax
  801df2:	48 85 c0             	test   %rax,%rax
  801df5:	74 21                	je     801e18 <fd_alloc+0x6a>
  801df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dfb:	48 89 c2             	mov    %rax,%rdx
  801dfe:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e02:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e09:	01 00 00 
  801e0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e10:	83 e0 01             	and    $0x1,%eax
  801e13:	48 85 c0             	test   %rax,%rax
  801e16:	75 12                	jne    801e2a <fd_alloc+0x7c>
			*fd_store = fd;
  801e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e20:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	eb 1a                	jmp    801e44 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e2a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e2e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e32:	7e 8f                	jle    801dc3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e38:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e3f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e44:	c9                   	leaveq 
  801e45:	c3                   	retq   

0000000000801e46 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e46:	55                   	push   %rbp
  801e47:	48 89 e5             	mov    %rsp,%rbp
  801e4a:	48 83 ec 20          	sub    $0x20,%rsp
  801e4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e55:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e59:	78 06                	js     801e61 <fd_lookup+0x1b>
  801e5b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e5f:	7e 07                	jle    801e68 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e66:	eb 6c                	jmp    801ed4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e68:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e6b:	48 98                	cltq   
  801e6d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e73:	48 c1 e0 0c          	shl    $0xc,%rax
  801e77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7f:	48 89 c2             	mov    %rax,%rdx
  801e82:	48 c1 ea 15          	shr    $0x15,%rdx
  801e86:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e8d:	01 00 00 
  801e90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e94:	83 e0 01             	and    $0x1,%eax
  801e97:	48 85 c0             	test   %rax,%rax
  801e9a:	74 21                	je     801ebd <fd_lookup+0x77>
  801e9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea0:	48 89 c2             	mov    %rax,%rdx
  801ea3:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ea7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eae:	01 00 00 
  801eb1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb5:	83 e0 01             	and    $0x1,%eax
  801eb8:	48 85 c0             	test   %rax,%rax
  801ebb:	75 07                	jne    801ec4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ebd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ec2:	eb 10                	jmp    801ed4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ec4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ec8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ecc:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed4:	c9                   	leaveq 
  801ed5:	c3                   	retq   

0000000000801ed6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ed6:	55                   	push   %rbp
  801ed7:	48 89 e5             	mov    %rsp,%rbp
  801eda:	48 83 ec 30          	sub    $0x30,%rsp
  801ede:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ee2:	89 f0                	mov    %esi,%eax
  801ee4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ee7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eeb:	48 89 c7             	mov    %rax,%rdi
  801eee:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  801ef5:	00 00 00 
  801ef8:	ff d0                	callq  *%rax
  801efa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801efe:	48 89 d6             	mov    %rdx,%rsi
  801f01:	89 c7                	mov    %eax,%edi
  801f03:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  801f0a:	00 00 00 
  801f0d:	ff d0                	callq  *%rax
  801f0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f16:	78 0a                	js     801f22 <fd_close+0x4c>
	    || fd != fd2)
  801f18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f1c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f20:	74 12                	je     801f34 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f22:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f26:	74 05                	je     801f2d <fd_close+0x57>
  801f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2b:	eb 05                	jmp    801f32 <fd_close+0x5c>
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f32:	eb 69                	jmp    801f9d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f38:	8b 00                	mov    (%rax),%eax
  801f3a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f3e:	48 89 d6             	mov    %rdx,%rsi
  801f41:	89 c7                	mov    %eax,%edi
  801f43:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  801f4a:	00 00 00 
  801f4d:	ff d0                	callq  *%rax
  801f4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f56:	78 2a                	js     801f82 <fd_close+0xac>
		if (dev->dev_close)
  801f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f5c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f60:	48 85 c0             	test   %rax,%rax
  801f63:	74 16                	je     801f7b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f69:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f71:	48 89 c7             	mov    %rax,%rdi
  801f74:	ff d2                	callq  *%rdx
  801f76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f79:	eb 07                	jmp    801f82 <fd_close+0xac>
		else
			r = 0;
  801f7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f86:	48 89 c6             	mov    %rax,%rsi
  801f89:	bf 00 00 00 00       	mov    $0x0,%edi
  801f8e:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	callq  *%rax
	return r;
  801f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f9d:	c9                   	leaveq 
  801f9e:	c3                   	retq   

0000000000801f9f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f9f:	55                   	push   %rbp
  801fa0:	48 89 e5             	mov    %rsp,%rbp
  801fa3:	48 83 ec 20          	sub    $0x20,%rsp
  801fa7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801faa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fb5:	eb 41                	jmp    801ff8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fb7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fbe:	00 00 00 
  801fc1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fc4:	48 63 d2             	movslq %edx,%rdx
  801fc7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcb:	8b 00                	mov    (%rax),%eax
  801fcd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fd0:	75 22                	jne    801ff4 <dev_lookup+0x55>
			*dev = devtab[i];
  801fd2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fd9:	00 00 00 
  801fdc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fdf:	48 63 d2             	movslq %edx,%rdx
  801fe2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fea:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff2:	eb 60                	jmp    802054 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ff4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ff8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fff:	00 00 00 
  802002:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802005:	48 63 d2             	movslq %edx,%rdx
  802008:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80200c:	48 85 c0             	test   %rax,%rax
  80200f:	75 a6                	jne    801fb7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802011:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802018:	00 00 00 
  80201b:	48 8b 00             	mov    (%rax),%rax
  80201e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802024:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802027:	89 c6                	mov    %eax,%esi
  802029:	48 bf 70 49 80 00 00 	movabs $0x804970,%rdi
  802030:	00 00 00 
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
  802038:	48 b9 2b 05 80 00 00 	movabs $0x80052b,%rcx
  80203f:	00 00 00 
  802042:	ff d1                	callq  *%rcx
	*dev = 0;
  802044:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802048:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80204f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802054:	c9                   	leaveq 
  802055:	c3                   	retq   

0000000000802056 <close>:

int
close(int fdnum)
{
  802056:	55                   	push   %rbp
  802057:	48 89 e5             	mov    %rsp,%rbp
  80205a:	48 83 ec 20          	sub    $0x20,%rsp
  80205e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802061:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802065:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802068:	48 89 d6             	mov    %rdx,%rsi
  80206b:	89 c7                	mov    %eax,%edi
  80206d:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax
  802079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80207c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802080:	79 05                	jns    802087 <close+0x31>
		return r;
  802082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802085:	eb 18                	jmp    80209f <close+0x49>
	else
		return fd_close(fd, 1);
  802087:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80208b:	be 01 00 00 00       	mov    $0x1,%esi
  802090:	48 89 c7             	mov    %rax,%rdi
  802093:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  80209a:	00 00 00 
  80209d:	ff d0                	callq  *%rax
}
  80209f:	c9                   	leaveq 
  8020a0:	c3                   	retq   

00000000008020a1 <close_all>:

void
close_all(void)
{
  8020a1:	55                   	push   %rbp
  8020a2:	48 89 e5             	mov    %rsp,%rbp
  8020a5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020b0:	eb 15                	jmp    8020c7 <close_all+0x26>
		close(i);
  8020b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b5:	89 c7                	mov    %eax,%edi
  8020b7:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020c3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020c7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020cb:	7e e5                	jle    8020b2 <close_all+0x11>
		close(i);
}
  8020cd:	c9                   	leaveq 
  8020ce:	c3                   	retq   

00000000008020cf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020cf:	55                   	push   %rbp
  8020d0:	48 89 e5             	mov    %rsp,%rbp
  8020d3:	48 83 ec 40          	sub    $0x40,%rsp
  8020d7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020da:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020dd:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020e1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020e4:	48 89 d6             	mov    %rdx,%rsi
  8020e7:	89 c7                	mov    %eax,%edi
  8020e9:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  8020f0:	00 00 00 
  8020f3:	ff d0                	callq  *%rax
  8020f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fc:	79 08                	jns    802106 <dup+0x37>
		return r;
  8020fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802101:	e9 70 01 00 00       	jmpq   802276 <dup+0x1a7>
	close(newfdnum);
  802106:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802109:	89 c7                	mov    %eax,%edi
  80210b:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  802112:	00 00 00 
  802115:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802117:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80211a:	48 98                	cltq   
  80211c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802122:	48 c1 e0 0c          	shl    $0xc,%rax
  802126:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80212a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212e:	48 89 c7             	mov    %rax,%rdi
  802131:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  802138:	00 00 00 
  80213b:	ff d0                	callq  *%rax
  80213d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802141:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802145:	48 89 c7             	mov    %rax,%rdi
  802148:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  80214f:	00 00 00 
  802152:	ff d0                	callq  *%rax
  802154:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215c:	48 89 c2             	mov    %rax,%rdx
  80215f:	48 c1 ea 15          	shr    $0x15,%rdx
  802163:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80216a:	01 00 00 
  80216d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802171:	83 e0 01             	and    $0x1,%eax
  802174:	84 c0                	test   %al,%al
  802176:	74 71                	je     8021e9 <dup+0x11a>
  802178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217c:	48 89 c2             	mov    %rax,%rdx
  80217f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802183:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80218a:	01 00 00 
  80218d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802191:	83 e0 01             	and    $0x1,%eax
  802194:	84 c0                	test   %al,%al
  802196:	74 51                	je     8021e9 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219c:	48 89 c2             	mov    %rax,%rdx
  80219f:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021aa:	01 00 00 
  8021ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b1:	89 c1                	mov    %eax,%ecx
  8021b3:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c1:	41 89 c8             	mov    %ecx,%r8d
  8021c4:	48 89 d1             	mov    %rdx,%rcx
  8021c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021cc:	48 89 c6             	mov    %rax,%rsi
  8021cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d4:	48 b8 70 1a 80 00 00 	movabs $0x801a70,%rax
  8021db:	00 00 00 
  8021de:	ff d0                	callq  *%rax
  8021e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e7:	78 56                	js     80223f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ed:	48 89 c2             	mov    %rax,%rdx
  8021f0:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fb:	01 00 00 
  8021fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802202:	89 c1                	mov    %eax,%ecx
  802204:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80220a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80220e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802212:	41 89 c8             	mov    %ecx,%r8d
  802215:	48 89 d1             	mov    %rdx,%rcx
  802218:	ba 00 00 00 00       	mov    $0x0,%edx
  80221d:	48 89 c6             	mov    %rax,%rsi
  802220:	bf 00 00 00 00       	mov    $0x0,%edi
  802225:	48 b8 70 1a 80 00 00 	movabs $0x801a70,%rax
  80222c:	00 00 00 
  80222f:	ff d0                	callq  *%rax
  802231:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802234:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802238:	78 08                	js     802242 <dup+0x173>
		goto err;

	return newfdnum;
  80223a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80223d:	eb 37                	jmp    802276 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80223f:	90                   	nop
  802240:	eb 01                	jmp    802243 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802242:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802247:	48 89 c6             	mov    %rax,%rsi
  80224a:	bf 00 00 00 00       	mov    $0x0,%edi
  80224f:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  802256:	00 00 00 
  802259:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80225b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80225f:	48 89 c6             	mov    %rax,%rsi
  802262:	bf 00 00 00 00       	mov    $0x0,%edi
  802267:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  80226e:	00 00 00 
  802271:	ff d0                	callq  *%rax
	return r;
  802273:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802276:	c9                   	leaveq 
  802277:	c3                   	retq   

0000000000802278 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802278:	55                   	push   %rbp
  802279:	48 89 e5             	mov    %rsp,%rbp
  80227c:	48 83 ec 40          	sub    $0x40,%rsp
  802280:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802283:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802287:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80228b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80228f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802292:	48 89 d6             	mov    %rdx,%rsi
  802295:	89 c7                	mov    %eax,%edi
  802297:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	callq  *%rax
  8022a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022aa:	78 24                	js     8022d0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b0:	8b 00                	mov    (%rax),%eax
  8022b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022b6:	48 89 d6             	mov    %rdx,%rsi
  8022b9:	89 c7                	mov    %eax,%edi
  8022bb:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  8022c2:	00 00 00 
  8022c5:	ff d0                	callq  *%rax
  8022c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ce:	79 05                	jns    8022d5 <read+0x5d>
		return r;
  8022d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d3:	eb 7a                	jmp    80234f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d9:	8b 40 08             	mov    0x8(%rax),%eax
  8022dc:	83 e0 03             	and    $0x3,%eax
  8022df:	83 f8 01             	cmp    $0x1,%eax
  8022e2:	75 3a                	jne    80231e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022e4:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  8022eb:	00 00 00 
  8022ee:	48 8b 00             	mov    (%rax),%rax
  8022f1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022f7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022fa:	89 c6                	mov    %eax,%esi
  8022fc:	48 bf 8f 49 80 00 00 	movabs $0x80498f,%rdi
  802303:	00 00 00 
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
  80230b:	48 b9 2b 05 80 00 00 	movabs $0x80052b,%rcx
  802312:	00 00 00 
  802315:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802317:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80231c:	eb 31                	jmp    80234f <read+0xd7>
	}
	if (!dev->dev_read)
  80231e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802322:	48 8b 40 10          	mov    0x10(%rax),%rax
  802326:	48 85 c0             	test   %rax,%rax
  802329:	75 07                	jne    802332 <read+0xba>
		return -E_NOT_SUPP;
  80232b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802330:	eb 1d                	jmp    80234f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802336:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80233a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802342:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802346:	48 89 ce             	mov    %rcx,%rsi
  802349:	48 89 c7             	mov    %rax,%rdi
  80234c:	41 ff d0             	callq  *%r8
}
  80234f:	c9                   	leaveq 
  802350:	c3                   	retq   

0000000000802351 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802351:	55                   	push   %rbp
  802352:	48 89 e5             	mov    %rsp,%rbp
  802355:	48 83 ec 30          	sub    $0x30,%rsp
  802359:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80235c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802360:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80236b:	eb 46                	jmp    8023b3 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80236d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802370:	48 98                	cltq   
  802372:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802376:	48 29 c2             	sub    %rax,%rdx
  802379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237c:	48 98                	cltq   
  80237e:	48 89 c1             	mov    %rax,%rcx
  802381:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802385:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802388:	48 89 ce             	mov    %rcx,%rsi
  80238b:	89 c7                	mov    %eax,%edi
  80238d:	48 b8 78 22 80 00 00 	movabs $0x802278,%rax
  802394:	00 00 00 
  802397:	ff d0                	callq  *%rax
  802399:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80239c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023a0:	79 05                	jns    8023a7 <readn+0x56>
			return m;
  8023a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023a5:	eb 1d                	jmp    8023c4 <readn+0x73>
		if (m == 0)
  8023a7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023ab:	74 13                	je     8023c0 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b6:	48 98                	cltq   
  8023b8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023bc:	72 af                	jb     80236d <readn+0x1c>
  8023be:	eb 01                	jmp    8023c1 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023c0:	90                   	nop
	}
	return tot;
  8023c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023c4:	c9                   	leaveq 
  8023c5:	c3                   	retq   

00000000008023c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023c6:	55                   	push   %rbp
  8023c7:	48 89 e5             	mov    %rsp,%rbp
  8023ca:	48 83 ec 40          	sub    $0x40,%rsp
  8023ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023e0:	48 89 d6             	mov    %rdx,%rsi
  8023e3:	89 c7                	mov    %eax,%edi
  8023e5:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
  8023f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f8:	78 24                	js     80241e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	8b 00                	mov    (%rax),%eax
  802400:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802404:	48 89 d6             	mov    %rdx,%rsi
  802407:	89 c7                	mov    %eax,%edi
  802409:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  802410:	00 00 00 
  802413:	ff d0                	callq  *%rax
  802415:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802418:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241c:	79 05                	jns    802423 <write+0x5d>
		return r;
  80241e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802421:	eb 79                	jmp    80249c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802427:	8b 40 08             	mov    0x8(%rax),%eax
  80242a:	83 e0 03             	and    $0x3,%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	75 3a                	jne    80246b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802431:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802438:	00 00 00 
  80243b:	48 8b 00             	mov    (%rax),%rax
  80243e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802444:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802447:	89 c6                	mov    %eax,%esi
  802449:	48 bf ab 49 80 00 00 	movabs $0x8049ab,%rdi
  802450:	00 00 00 
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	48 b9 2b 05 80 00 00 	movabs $0x80052b,%rcx
  80245f:	00 00 00 
  802462:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802464:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802469:	eb 31                	jmp    80249c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802473:	48 85 c0             	test   %rax,%rax
  802476:	75 07                	jne    80247f <write+0xb9>
		return -E_NOT_SUPP;
  802478:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80247d:	eb 1d                	jmp    80249c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80247f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802483:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80248f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802493:	48 89 ce             	mov    %rcx,%rsi
  802496:	48 89 c7             	mov    %rax,%rdi
  802499:	41 ff d0             	callq  *%r8
}
  80249c:	c9                   	leaveq 
  80249d:	c3                   	retq   

000000000080249e <seek>:

int
seek(int fdnum, off_t offset)
{
  80249e:	55                   	push   %rbp
  80249f:	48 89 e5             	mov    %rsp,%rbp
  8024a2:	48 83 ec 18          	sub    $0x18,%rsp
  8024a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024a9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024b3:	48 89 d6             	mov    %rdx,%rsi
  8024b6:	89 c7                	mov    %eax,%edi
  8024b8:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  8024bf:	00 00 00 
  8024c2:	ff d0                	callq  *%rax
  8024c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024cb:	79 05                	jns    8024d2 <seek+0x34>
		return r;
  8024cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d0:	eb 0f                	jmp    8024e1 <seek+0x43>
	fd->fd_offset = offset;
  8024d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024d9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e1:	c9                   	leaveq 
  8024e2:	c3                   	retq   

00000000008024e3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024e3:	55                   	push   %rbp
  8024e4:	48 89 e5             	mov    %rsp,%rbp
  8024e7:	48 83 ec 30          	sub    $0x30,%rsp
  8024eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ee:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f8:	48 89 d6             	mov    %rdx,%rsi
  8024fb:	89 c7                	mov    %eax,%edi
  8024fd:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  802504:	00 00 00 
  802507:	ff d0                	callq  *%rax
  802509:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802510:	78 24                	js     802536 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802516:	8b 00                	mov    (%rax),%eax
  802518:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80251c:	48 89 d6             	mov    %rdx,%rsi
  80251f:	89 c7                	mov    %eax,%edi
  802521:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  802528:	00 00 00 
  80252b:	ff d0                	callq  *%rax
  80252d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802530:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802534:	79 05                	jns    80253b <ftruncate+0x58>
		return r;
  802536:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802539:	eb 72                	jmp    8025ad <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80253b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253f:	8b 40 08             	mov    0x8(%rax),%eax
  802542:	83 e0 03             	and    $0x3,%eax
  802545:	85 c0                	test   %eax,%eax
  802547:	75 3a                	jne    802583 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802549:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802550:	00 00 00 
  802553:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802556:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80255c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255f:	89 c6                	mov    %eax,%esi
  802561:	48 bf c8 49 80 00 00 	movabs $0x8049c8,%rdi
  802568:	00 00 00 
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
  802570:	48 b9 2b 05 80 00 00 	movabs $0x80052b,%rcx
  802577:	00 00 00 
  80257a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80257c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802581:	eb 2a                	jmp    8025ad <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802587:	48 8b 40 30          	mov    0x30(%rax),%rax
  80258b:	48 85 c0             	test   %rax,%rax
  80258e:	75 07                	jne    802597 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802590:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802595:	eb 16                	jmp    8025ad <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80259f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025a6:	89 d6                	mov    %edx,%esi
  8025a8:	48 89 c7             	mov    %rax,%rdi
  8025ab:	ff d1                	callq  *%rcx
}
  8025ad:	c9                   	leaveq 
  8025ae:	c3                   	retq   

00000000008025af <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025af:	55                   	push   %rbp
  8025b0:	48 89 e5             	mov    %rsp,%rbp
  8025b3:	48 83 ec 30          	sub    $0x30,%rsp
  8025b7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025be:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025c5:	48 89 d6             	mov    %rdx,%rsi
  8025c8:	89 c7                	mov    %eax,%edi
  8025ca:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  8025d1:	00 00 00 
  8025d4:	ff d0                	callq  *%rax
  8025d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025dd:	78 24                	js     802603 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e3:	8b 00                	mov    (%rax),%eax
  8025e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025e9:	48 89 d6             	mov    %rdx,%rsi
  8025ec:	89 c7                	mov    %eax,%edi
  8025ee:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  8025f5:	00 00 00 
  8025f8:	ff d0                	callq  *%rax
  8025fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802601:	79 05                	jns    802608 <fstat+0x59>
		return r;
  802603:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802606:	eb 5e                	jmp    802666 <fstat+0xb7>
	if (!dev->dev_stat)
  802608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802610:	48 85 c0             	test   %rax,%rax
  802613:	75 07                	jne    80261c <fstat+0x6d>
		return -E_NOT_SUPP;
  802615:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80261a:	eb 4a                	jmp    802666 <fstat+0xb7>
	stat->st_name[0] = 0;
  80261c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802620:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802623:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802627:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80262e:	00 00 00 
	stat->st_isdir = 0;
  802631:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802635:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80263c:	00 00 00 
	stat->st_dev = dev;
  80263f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802643:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802647:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80264e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802652:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80265e:	48 89 d6             	mov    %rdx,%rsi
  802661:	48 89 c7             	mov    %rax,%rdi
  802664:	ff d1                	callq  *%rcx
}
  802666:	c9                   	leaveq 
  802667:	c3                   	retq   

0000000000802668 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802668:	55                   	push   %rbp
  802669:	48 89 e5             	mov    %rsp,%rbp
  80266c:	48 83 ec 20          	sub    $0x20,%rsp
  802670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802674:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267c:	be 00 00 00 00       	mov    $0x0,%esi
  802681:	48 89 c7             	mov    %rax,%rdi
  802684:	48 b8 57 27 80 00 00 	movabs $0x802757,%rax
  80268b:	00 00 00 
  80268e:	ff d0                	callq  *%rax
  802690:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802693:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802697:	79 05                	jns    80269e <stat+0x36>
		return fd;
  802699:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269c:	eb 2f                	jmp    8026cd <stat+0x65>
	r = fstat(fd, stat);
  80269e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a5:	48 89 d6             	mov    %rdx,%rsi
  8026a8:	89 c7                	mov    %eax,%edi
  8026aa:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax
  8026b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026bc:	89 c7                	mov    %eax,%edi
  8026be:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  8026c5:	00 00 00 
  8026c8:	ff d0                	callq  *%rax
	return r;
  8026ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026cd:	c9                   	leaveq 
  8026ce:	c3                   	retq   
	...

00000000008026d0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026d0:	55                   	push   %rbp
  8026d1:	48 89 e5             	mov    %rsp,%rbp
  8026d4:	48 83 ec 10          	sub    $0x10,%rsp
  8026d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026df:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  8026e6:	00 00 00 
  8026e9:	8b 00                	mov    (%rax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	75 1d                	jne    80270c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026ef:	bf 01 00 00 00       	mov    $0x1,%edi
  8026f4:	48 b8 87 3d 80 00 00 	movabs $0x803d87,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax
  802700:	48 ba 1c 70 80 00 00 	movabs $0x80701c,%rdx
  802707:	00 00 00 
  80270a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80270c:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  802713:	00 00 00 
  802716:	8b 00                	mov    (%rax),%eax
  802718:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80271b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802720:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802727:	00 00 00 
  80272a:	89 c7                	mov    %eax,%edi
  80272c:	48 b8 c4 3c 80 00 00 	movabs $0x803cc4,%rax
  802733:	00 00 00 
  802736:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802738:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273c:	ba 00 00 00 00       	mov    $0x0,%edx
  802741:	48 89 c6             	mov    %rax,%rsi
  802744:	bf 00 00 00 00       	mov    $0x0,%edi
  802749:	48 b8 04 3c 80 00 00 	movabs $0x803c04,%rax
  802750:	00 00 00 
  802753:	ff d0                	callq  *%rax
}
  802755:	c9                   	leaveq 
  802756:	c3                   	retq   

0000000000802757 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802757:	55                   	push   %rbp
  802758:	48 89 e5             	mov    %rsp,%rbp
  80275b:	48 83 ec 20          	sub    $0x20,%rsp
  80275f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802763:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276a:	48 89 c7             	mov    %rax,%rdi
  80276d:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  802774:	00 00 00 
  802777:	ff d0                	callq  *%rax
  802779:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80277e:	7e 0a                	jle    80278a <open+0x33>
                return -E_BAD_PATH;
  802780:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802785:	e9 a5 00 00 00       	jmpq   80282f <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80278a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80278e:	48 89 c7             	mov    %rax,%rdi
  802791:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
  80279d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a4:	79 08                	jns    8027ae <open+0x57>
		return r;
  8027a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a9:	e9 81 00 00 00       	jmpq   80282f <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8027ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b2:	48 89 c6             	mov    %rax,%rsi
  8027b5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027bc:	00 00 00 
  8027bf:	48 b8 e8 10 80 00 00 	movabs $0x8010e8,%rax
  8027c6:	00 00 00 
  8027c9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8027cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027d2:	00 00 00 
  8027d5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027d8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8027de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e2:	48 89 c6             	mov    %rax,%rsi
  8027e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8027ea:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  8027f1:	00 00 00 
  8027f4:	ff d0                	callq  *%rax
  8027f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8027f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027fd:	79 1d                	jns    80281c <open+0xc5>
	{
		fd_close(fd,0);
  8027ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802803:	be 00 00 00 00       	mov    $0x0,%esi
  802808:	48 89 c7             	mov    %rax,%rdi
  80280b:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  802812:	00 00 00 
  802815:	ff d0                	callq  *%rax
		return r;
  802817:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281a:	eb 13                	jmp    80282f <open+0xd8>
	}
	return fd2num(fd);
  80281c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802820:	48 89 c7             	mov    %rax,%rdi
  802823:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  80282a:	00 00 00 
  80282d:	ff d0                	callq  *%rax
	


}
  80282f:	c9                   	leaveq 
  802830:	c3                   	retq   

0000000000802831 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802831:	55                   	push   %rbp
  802832:	48 89 e5             	mov    %rsp,%rbp
  802835:	48 83 ec 10          	sub    $0x10,%rsp
  802839:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80283d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802841:	8b 50 0c             	mov    0xc(%rax),%edx
  802844:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80284b:	00 00 00 
  80284e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802850:	be 00 00 00 00       	mov    $0x0,%esi
  802855:	bf 06 00 00 00       	mov    $0x6,%edi
  80285a:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
}
  802866:	c9                   	leaveq 
  802867:	c3                   	retq   

0000000000802868 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802868:	55                   	push   %rbp
  802869:	48 89 e5             	mov    %rsp,%rbp
  80286c:	48 83 ec 30          	sub    $0x30,%rsp
  802870:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802874:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802878:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80287c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802880:	8b 50 0c             	mov    0xc(%rax),%edx
  802883:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80288a:	00 00 00 
  80288d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80288f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802896:	00 00 00 
  802899:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80289d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028a1:	be 00 00 00 00       	mov    $0x0,%esi
  8028a6:	bf 03 00 00 00       	mov    $0x3,%edi
  8028ab:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  8028b2:	00 00 00 
  8028b5:	ff d0                	callq  *%rax
  8028b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028be:	79 05                	jns    8028c5 <devfile_read+0x5d>
	{
		return r;
  8028c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c3:	eb 2c                	jmp    8028f1 <devfile_read+0x89>
	}
	if(r > 0)
  8028c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c9:	7e 23                	jle    8028ee <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8028cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ce:	48 63 d0             	movslq %eax,%rdx
  8028d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028dc:	00 00 00 
  8028df:	48 89 c7             	mov    %rax,%rdi
  8028e2:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  8028e9:	00 00 00 
  8028ec:	ff d0                	callq  *%rax
	return r;
  8028ee:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8028f1:	c9                   	leaveq 
  8028f2:	c3                   	retq   

00000000008028f3 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028f3:	55                   	push   %rbp
  8028f4:	48 89 e5             	mov    %rsp,%rbp
  8028f7:	48 83 ec 30          	sub    $0x30,%rsp
  8028fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802903:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290b:	8b 50 0c             	mov    0xc(%rax),%edx
  80290e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802915:	00 00 00 
  802918:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80291a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802921:	00 
  802922:	76 08                	jbe    80292c <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802924:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80292b:	00 
	fsipcbuf.write.req_n=n;
  80292c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802933:	00 00 00 
  802936:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80293a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80293e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802942:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802946:	48 89 c6             	mov    %rax,%rsi
  802949:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802950:	00 00 00 
  802953:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  80295a:	00 00 00 
  80295d:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80295f:	be 00 00 00 00       	mov    $0x0,%esi
  802964:	bf 04 00 00 00       	mov    $0x4,%edi
  802969:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  802970:	00 00 00 
  802973:	ff d0                	callq  *%rax
  802975:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802978:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80297b:	c9                   	leaveq 
  80297c:	c3                   	retq   

000000000080297d <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  80297d:	55                   	push   %rbp
  80297e:	48 89 e5             	mov    %rsp,%rbp
  802981:	48 83 ec 10          	sub    $0x10,%rsp
  802985:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802989:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80298c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802990:	8b 50 0c             	mov    0xc(%rax),%edx
  802993:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80299a:	00 00 00 
  80299d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80299f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a6:	00 00 00 
  8029a9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029ac:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029af:	be 00 00 00 00       	mov    $0x0,%esi
  8029b4:	bf 02 00 00 00       	mov    $0x2,%edi
  8029b9:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
}
  8029c5:	c9                   	leaveq 
  8029c6:	c3                   	retq   

00000000008029c7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029c7:	55                   	push   %rbp
  8029c8:	48 89 e5             	mov    %rsp,%rbp
  8029cb:	48 83 ec 20          	sub    $0x20,%rsp
  8029cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029db:	8b 50 0c             	mov    0xc(%rax),%edx
  8029de:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029e5:	00 00 00 
  8029e8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029ea:	be 00 00 00 00       	mov    $0x0,%esi
  8029ef:	bf 05 00 00 00       	mov    $0x5,%edi
  8029f4:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  8029fb:	00 00 00 
  8029fe:	ff d0                	callq  *%rax
  802a00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a07:	79 05                	jns    802a0e <devfile_stat+0x47>
		return r;
  802a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0c:	eb 56                	jmp    802a64 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a12:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a19:	00 00 00 
  802a1c:	48 89 c7             	mov    %rax,%rdi
  802a1f:	48 b8 e8 10 80 00 00 	movabs $0x8010e8,%rax
  802a26:	00 00 00 
  802a29:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a2b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a32:	00 00 00 
  802a35:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a3f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a4c:	00 00 00 
  802a4f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a59:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a64:	c9                   	leaveq 
  802a65:	c3                   	retq   
	...

0000000000802a68 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a68:	55                   	push   %rbp
  802a69:	48 89 e5             	mov    %rsp,%rbp
  802a6c:	48 83 ec 20          	sub    $0x20,%rsp
  802a70:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a73:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a7a:	48 89 d6             	mov    %rdx,%rsi
  802a7d:	89 c7                	mov    %eax,%edi
  802a7f:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	callq  *%rax
  802a8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a92:	79 05                	jns    802a99 <fd2sockid+0x31>
		return r;
  802a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a97:	eb 24                	jmp    802abd <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802a99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9d:	8b 10                	mov    (%rax),%edx
  802a9f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802aa6:	00 00 00 
  802aa9:	8b 00                	mov    (%rax),%eax
  802aab:	39 c2                	cmp    %eax,%edx
  802aad:	74 07                	je     802ab6 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802aaf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab4:	eb 07                	jmp    802abd <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aba:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802abd:	c9                   	leaveq 
  802abe:	c3                   	retq   

0000000000802abf <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802abf:	55                   	push   %rbp
  802ac0:	48 89 e5             	mov    %rsp,%rbp
  802ac3:	48 83 ec 20          	sub    $0x20,%rsp
  802ac7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802aca:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ace:	48 89 c7             	mov    %rax,%rdi
  802ad1:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  802ad8:	00 00 00 
  802adb:	ff d0                	callq  *%rax
  802add:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae4:	78 26                	js     802b0c <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802ae6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aea:	ba 07 04 00 00       	mov    $0x407,%edx
  802aef:	48 89 c6             	mov    %rax,%rsi
  802af2:	bf 00 00 00 00       	mov    $0x0,%edi
  802af7:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802afe:	00 00 00 
  802b01:	ff d0                	callq  *%rax
  802b03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0a:	79 16                	jns    802b22 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802b0c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b0f:	89 c7                	mov    %eax,%edi
  802b11:	48 b8 cc 2f 80 00 00 	movabs $0x802fcc,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
		return r;
  802b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b20:	eb 3a                	jmp    802b5c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802b22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b26:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802b2d:	00 00 00 
  802b30:	8b 12                	mov    (%rdx),%edx
  802b32:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802b34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b38:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b43:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b46:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802b49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4d:	48 89 c7             	mov    %rax,%rdi
  802b50:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  802b57:	00 00 00 
  802b5a:	ff d0                	callq  *%rax
}
  802b5c:	c9                   	leaveq 
  802b5d:	c3                   	retq   

0000000000802b5e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b5e:	55                   	push   %rbp
  802b5f:	48 89 e5             	mov    %rsp,%rbp
  802b62:	48 83 ec 30          	sub    $0x30,%rsp
  802b66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b6d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b74:	89 c7                	mov    %eax,%edi
  802b76:	48 b8 68 2a 80 00 00 	movabs $0x802a68,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
  802b82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b89:	79 05                	jns    802b90 <accept+0x32>
		return r;
  802b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8e:	eb 3b                	jmp    802bcb <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b90:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b94:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9b:	48 89 ce             	mov    %rcx,%rsi
  802b9e:	89 c7                	mov    %eax,%edi
  802ba0:	48 b8 a9 2e 80 00 00 	movabs $0x802ea9,%rax
  802ba7:	00 00 00 
  802baa:	ff d0                	callq  *%rax
  802bac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802baf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb3:	79 05                	jns    802bba <accept+0x5c>
		return r;
  802bb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb8:	eb 11                	jmp    802bcb <accept+0x6d>
	return alloc_sockfd(r);
  802bba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbd:	89 c7                	mov    %eax,%edi
  802bbf:	48 b8 bf 2a 80 00 00 	movabs $0x802abf,%rax
  802bc6:	00 00 00 
  802bc9:	ff d0                	callq  *%rax
}
  802bcb:	c9                   	leaveq 
  802bcc:	c3                   	retq   

0000000000802bcd <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802bcd:	55                   	push   %rbp
  802bce:	48 89 e5             	mov    %rsp,%rbp
  802bd1:	48 83 ec 20          	sub    $0x20,%rsp
  802bd5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bd8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bdc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bdf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802be2:	89 c7                	mov    %eax,%edi
  802be4:	48 b8 68 2a 80 00 00 	movabs $0x802a68,%rax
  802beb:	00 00 00 
  802bee:	ff d0                	callq  *%rax
  802bf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf7:	79 05                	jns    802bfe <bind+0x31>
		return r;
  802bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfc:	eb 1b                	jmp    802c19 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802bfe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c01:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c08:	48 89 ce             	mov    %rcx,%rsi
  802c0b:	89 c7                	mov    %eax,%edi
  802c0d:	48 b8 28 2f 80 00 00 	movabs $0x802f28,%rax
  802c14:	00 00 00 
  802c17:	ff d0                	callq  *%rax
}
  802c19:	c9                   	leaveq 
  802c1a:	c3                   	retq   

0000000000802c1b <shutdown>:

int
shutdown(int s, int how)
{
  802c1b:	55                   	push   %rbp
  802c1c:	48 89 e5             	mov    %rsp,%rbp
  802c1f:	48 83 ec 20          	sub    $0x20,%rsp
  802c23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c26:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c2c:	89 c7                	mov    %eax,%edi
  802c2e:	48 b8 68 2a 80 00 00 	movabs $0x802a68,%rax
  802c35:	00 00 00 
  802c38:	ff d0                	callq  *%rax
  802c3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c41:	79 05                	jns    802c48 <shutdown+0x2d>
		return r;
  802c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c46:	eb 16                	jmp    802c5e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802c48:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4e:	89 d6                	mov    %edx,%esi
  802c50:	89 c7                	mov    %eax,%edi
  802c52:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  802c59:	00 00 00 
  802c5c:	ff d0                	callq  *%rax
}
  802c5e:	c9                   	leaveq 
  802c5f:	c3                   	retq   

0000000000802c60 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802c60:	55                   	push   %rbp
  802c61:	48 89 e5             	mov    %rsp,%rbp
  802c64:	48 83 ec 10          	sub    $0x10,%rsp
  802c68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c70:	48 89 c7             	mov    %rax,%rdi
  802c73:	48 b8 0c 3e 80 00 00 	movabs $0x803e0c,%rax
  802c7a:	00 00 00 
  802c7d:	ff d0                	callq  *%rax
  802c7f:	83 f8 01             	cmp    $0x1,%eax
  802c82:	75 17                	jne    802c9b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802c84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c88:	8b 40 0c             	mov    0xc(%rax),%eax
  802c8b:	89 c7                	mov    %eax,%edi
  802c8d:	48 b8 cc 2f 80 00 00 	movabs $0x802fcc,%rax
  802c94:	00 00 00 
  802c97:	ff d0                	callq  *%rax
  802c99:	eb 05                	jmp    802ca0 <devsock_close+0x40>
	else
		return 0;
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca0:	c9                   	leaveq 
  802ca1:	c3                   	retq   

0000000000802ca2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ca2:	55                   	push   %rbp
  802ca3:	48 89 e5             	mov    %rsp,%rbp
  802ca6:	48 83 ec 20          	sub    $0x20,%rsp
  802caa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cb1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cb7:	89 c7                	mov    %eax,%edi
  802cb9:	48 b8 68 2a 80 00 00 	movabs $0x802a68,%rax
  802cc0:	00 00 00 
  802cc3:	ff d0                	callq  *%rax
  802cc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ccc:	79 05                	jns    802cd3 <connect+0x31>
		return r;
  802cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd1:	eb 1b                	jmp    802cee <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802cd3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cd6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdd:	48 89 ce             	mov    %rcx,%rsi
  802ce0:	89 c7                	mov    %eax,%edi
  802ce2:	48 b8 f9 2f 80 00 00 	movabs $0x802ff9,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
}
  802cee:	c9                   	leaveq 
  802cef:	c3                   	retq   

0000000000802cf0 <listen>:

int
listen(int s, int backlog)
{
  802cf0:	55                   	push   %rbp
  802cf1:	48 89 e5             	mov    %rsp,%rbp
  802cf4:	48 83 ec 20          	sub    $0x20,%rsp
  802cf8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cfb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cfe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d01:	89 c7                	mov    %eax,%edi
  802d03:	48 b8 68 2a 80 00 00 	movabs $0x802a68,%rax
  802d0a:	00 00 00 
  802d0d:	ff d0                	callq  *%rax
  802d0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d16:	79 05                	jns    802d1d <listen+0x2d>
		return r;
  802d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1b:	eb 16                	jmp    802d33 <listen+0x43>
	return nsipc_listen(r, backlog);
  802d1d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d23:	89 d6                	mov    %edx,%esi
  802d25:	89 c7                	mov    %eax,%edi
  802d27:	48 b8 5d 30 80 00 00 	movabs $0x80305d,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
}
  802d33:	c9                   	leaveq 
  802d34:	c3                   	retq   

0000000000802d35 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802d35:	55                   	push   %rbp
  802d36:	48 89 e5             	mov    %rsp,%rbp
  802d39:	48 83 ec 20          	sub    $0x20,%rsp
  802d3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d45:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802d49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4d:	89 c2                	mov    %eax,%edx
  802d4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d53:	8b 40 0c             	mov    0xc(%rax),%eax
  802d56:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d5f:	89 c7                	mov    %eax,%edi
  802d61:	48 b8 9d 30 80 00 00 	movabs $0x80309d,%rax
  802d68:	00 00 00 
  802d6b:	ff d0                	callq  *%rax
}
  802d6d:	c9                   	leaveq 
  802d6e:	c3                   	retq   

0000000000802d6f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802d6f:	55                   	push   %rbp
  802d70:	48 89 e5             	mov    %rsp,%rbp
  802d73:	48 83 ec 20          	sub    $0x20,%rsp
  802d77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d7f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802d83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d87:	89 c2                	mov    %eax,%edx
  802d89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d8d:	8b 40 0c             	mov    0xc(%rax),%eax
  802d90:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d94:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d99:	89 c7                	mov    %eax,%edi
  802d9b:	48 b8 69 31 80 00 00 	movabs $0x803169,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	callq  *%rax
}
  802da7:	c9                   	leaveq 
  802da8:	c3                   	retq   

0000000000802da9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802da9:	55                   	push   %rbp
  802daa:	48 89 e5             	mov    %rsp,%rbp
  802dad:	48 83 ec 10          	sub    $0x10,%rsp
  802db1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802db5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbd:	48 be f3 49 80 00 00 	movabs $0x8049f3,%rsi
  802dc4:	00 00 00 
  802dc7:	48 89 c7             	mov    %rax,%rdi
  802dca:	48 b8 e8 10 80 00 00 	movabs $0x8010e8,%rax
  802dd1:	00 00 00 
  802dd4:	ff d0                	callq  *%rax
	return 0;
  802dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ddb:	c9                   	leaveq 
  802ddc:	c3                   	retq   

0000000000802ddd <socket>:

int
socket(int domain, int type, int protocol)
{
  802ddd:	55                   	push   %rbp
  802dde:	48 89 e5             	mov    %rsp,%rbp
  802de1:	48 83 ec 20          	sub    $0x20,%rsp
  802de5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802de8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802deb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802dee:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802df1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802df4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802df7:	89 ce                	mov    %ecx,%esi
  802df9:	89 c7                	mov    %eax,%edi
  802dfb:	48 b8 21 32 80 00 00 	movabs $0x803221,%rax
  802e02:	00 00 00 
  802e05:	ff d0                	callq  *%rax
  802e07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0e:	79 05                	jns    802e15 <socket+0x38>
		return r;
  802e10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e13:	eb 11                	jmp    802e26 <socket+0x49>
	return alloc_sockfd(r);
  802e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e18:	89 c7                	mov    %eax,%edi
  802e1a:	48 b8 bf 2a 80 00 00 	movabs $0x802abf,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	callq  *%rax
}
  802e26:	c9                   	leaveq 
  802e27:	c3                   	retq   

0000000000802e28 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802e28:	55                   	push   %rbp
  802e29:	48 89 e5             	mov    %rsp,%rbp
  802e2c:	48 83 ec 10          	sub    $0x10,%rsp
  802e30:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802e33:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802e3a:	00 00 00 
  802e3d:	8b 00                	mov    (%rax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	75 1d                	jne    802e60 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802e43:	bf 02 00 00 00       	mov    $0x2,%edi
  802e48:	48 b8 87 3d 80 00 00 	movabs $0x803d87,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	callq  *%rax
  802e54:	48 ba 28 70 80 00 00 	movabs $0x807028,%rdx
  802e5b:	00 00 00 
  802e5e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802e60:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802e67:	00 00 00 
  802e6a:	8b 00                	mov    (%rax),%eax
  802e6c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e6f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e74:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802e7b:	00 00 00 
  802e7e:	89 c7                	mov    %eax,%edi
  802e80:	48 b8 c4 3c 80 00 00 	movabs $0x803cc4,%rax
  802e87:	00 00 00 
  802e8a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802e8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e91:	be 00 00 00 00       	mov    $0x0,%esi
  802e96:	bf 00 00 00 00       	mov    $0x0,%edi
  802e9b:	48 b8 04 3c 80 00 00 	movabs $0x803c04,%rax
  802ea2:	00 00 00 
  802ea5:	ff d0                	callq  *%rax
}
  802ea7:	c9                   	leaveq 
  802ea8:	c3                   	retq   

0000000000802ea9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ea9:	55                   	push   %rbp
  802eaa:	48 89 e5             	mov    %rsp,%rbp
  802ead:	48 83 ec 30          	sub    $0x30,%rsp
  802eb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eb8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802ebc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ec3:	00 00 00 
  802ec6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ec9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802ecb:	bf 01 00 00 00       	mov    $0x1,%edi
  802ed0:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  802ed7:	00 00 00 
  802eda:	ff d0                	callq  *%rax
  802edc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee3:	78 3e                	js     802f23 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802ee5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802eec:	00 00 00 
  802eef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef7:	8b 40 10             	mov    0x10(%rax),%eax
  802efa:	89 c2                	mov    %eax,%edx
  802efc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f04:	48 89 ce             	mov    %rcx,%rsi
  802f07:	48 89 c7             	mov    %rax,%rdi
  802f0a:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802f16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1a:	8b 50 10             	mov    0x10(%rax),%edx
  802f1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f21:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f26:	c9                   	leaveq 
  802f27:	c3                   	retq   

0000000000802f28 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f28:	55                   	push   %rbp
  802f29:	48 89 e5             	mov    %rsp,%rbp
  802f2c:	48 83 ec 10          	sub    $0x10,%rsp
  802f30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f37:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802f3a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f41:	00 00 00 
  802f44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f47:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802f49:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f50:	48 89 c6             	mov    %rax,%rsi
  802f53:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802f5a:	00 00 00 
  802f5d:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802f69:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f70:	00 00 00 
  802f73:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f76:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802f79:	bf 02 00 00 00       	mov    $0x2,%edi
  802f7e:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  802f85:	00 00 00 
  802f88:	ff d0                	callq  *%rax
}
  802f8a:	c9                   	leaveq 
  802f8b:	c3                   	retq   

0000000000802f8c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802f8c:	55                   	push   %rbp
  802f8d:	48 89 e5             	mov    %rsp,%rbp
  802f90:	48 83 ec 10          	sub    $0x10,%rsp
  802f94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f97:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802f9a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fa1:	00 00 00 
  802fa4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fa7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802fa9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fb0:	00 00 00 
  802fb3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fb6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802fb9:	bf 03 00 00 00       	mov    $0x3,%edi
  802fbe:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
}
  802fca:	c9                   	leaveq 
  802fcb:	c3                   	retq   

0000000000802fcc <nsipc_close>:

int
nsipc_close(int s)
{
  802fcc:	55                   	push   %rbp
  802fcd:	48 89 e5             	mov    %rsp,%rbp
  802fd0:	48 83 ec 10          	sub    $0x10,%rsp
  802fd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802fd7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fde:	00 00 00 
  802fe1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fe4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802fe6:	bf 04 00 00 00       	mov    $0x4,%edi
  802feb:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
}
  802ff7:	c9                   	leaveq 
  802ff8:	c3                   	retq   

0000000000802ff9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ff9:	55                   	push   %rbp
  802ffa:	48 89 e5             	mov    %rsp,%rbp
  802ffd:	48 83 ec 10          	sub    $0x10,%rsp
  803001:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803004:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803008:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80300b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803012:	00 00 00 
  803015:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803018:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80301a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80301d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803021:	48 89 c6             	mov    %rax,%rsi
  803024:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80302b:	00 00 00 
  80302e:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  803035:	00 00 00 
  803038:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80303a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803041:	00 00 00 
  803044:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803047:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80304a:	bf 05 00 00 00       	mov    $0x5,%edi
  80304f:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  803056:	00 00 00 
  803059:	ff d0                	callq  *%rax
}
  80305b:	c9                   	leaveq 
  80305c:	c3                   	retq   

000000000080305d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80305d:	55                   	push   %rbp
  80305e:	48 89 e5             	mov    %rsp,%rbp
  803061:	48 83 ec 10          	sub    $0x10,%rsp
  803065:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803068:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80306b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803072:	00 00 00 
  803075:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803078:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80307a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803081:	00 00 00 
  803084:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803087:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80308a:	bf 06 00 00 00       	mov    $0x6,%edi
  80308f:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
}
  80309b:	c9                   	leaveq 
  80309c:	c3                   	retq   

000000000080309d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80309d:	55                   	push   %rbp
  80309e:	48 89 e5             	mov    %rsp,%rbp
  8030a1:	48 83 ec 30          	sub    $0x30,%rsp
  8030a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030ac:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8030af:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8030b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030b9:	00 00 00 
  8030bc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030bf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8030c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030c8:	00 00 00 
  8030cb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030ce:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8030d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030d8:	00 00 00 
  8030db:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030de:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8030e1:	bf 07 00 00 00       	mov    $0x7,%edi
  8030e6:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
  8030f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f9:	78 69                	js     803164 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8030fb:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803102:	7f 08                	jg     80310c <nsipc_recv+0x6f>
  803104:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803107:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80310a:	7e 35                	jle    803141 <nsipc_recv+0xa4>
  80310c:	48 b9 fa 49 80 00 00 	movabs $0x8049fa,%rcx
  803113:	00 00 00 
  803116:	48 ba 0f 4a 80 00 00 	movabs $0x804a0f,%rdx
  80311d:	00 00 00 
  803120:	be 61 00 00 00       	mov    $0x61,%esi
  803125:	48 bf 24 4a 80 00 00 	movabs $0x804a24,%rdi
  80312c:	00 00 00 
  80312f:	b8 00 00 00 00       	mov    $0x0,%eax
  803134:	49 b8 f0 3a 80 00 00 	movabs $0x803af0,%r8
  80313b:	00 00 00 
  80313e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803144:	48 63 d0             	movslq %eax,%rdx
  803147:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803152:	00 00 00 
  803155:	48 89 c7             	mov    %rax,%rdi
  803158:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  80315f:	00 00 00 
  803162:	ff d0                	callq  *%rax
	}

	return r;
  803164:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803167:	c9                   	leaveq 
  803168:	c3                   	retq   

0000000000803169 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803169:	55                   	push   %rbp
  80316a:	48 89 e5             	mov    %rsp,%rbp
  80316d:	48 83 ec 20          	sub    $0x20,%rsp
  803171:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803174:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803178:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80317b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80317e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803185:	00 00 00 
  803188:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80318b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80318d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803194:	7e 35                	jle    8031cb <nsipc_send+0x62>
  803196:	48 b9 30 4a 80 00 00 	movabs $0x804a30,%rcx
  80319d:	00 00 00 
  8031a0:	48 ba 0f 4a 80 00 00 	movabs $0x804a0f,%rdx
  8031a7:	00 00 00 
  8031aa:	be 6c 00 00 00       	mov    $0x6c,%esi
  8031af:	48 bf 24 4a 80 00 00 	movabs $0x804a24,%rdi
  8031b6:	00 00 00 
  8031b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031be:	49 b8 f0 3a 80 00 00 	movabs $0x803af0,%r8
  8031c5:	00 00 00 
  8031c8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8031cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ce:	48 63 d0             	movslq %eax,%rdx
  8031d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d5:	48 89 c6             	mov    %rax,%rsi
  8031d8:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8031df:	00 00 00 
  8031e2:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  8031e9:	00 00 00 
  8031ec:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8031ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031f5:	00 00 00 
  8031f8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031fb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8031fe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803205:	00 00 00 
  803208:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80320b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80320e:	bf 08 00 00 00       	mov    $0x8,%edi
  803213:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
}
  80321f:	c9                   	leaveq 
  803220:	c3                   	retq   

0000000000803221 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803221:	55                   	push   %rbp
  803222:	48 89 e5             	mov    %rsp,%rbp
  803225:	48 83 ec 10          	sub    $0x10,%rsp
  803229:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80322c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80322f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803232:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803239:	00 00 00 
  80323c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80323f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803241:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803248:	00 00 00 
  80324b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80324e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803251:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803258:	00 00 00 
  80325b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80325e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803261:	bf 09 00 00 00       	mov    $0x9,%edi
  803266:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
}
  803272:	c9                   	leaveq 
  803273:	c3                   	retq   

0000000000803274 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803274:	55                   	push   %rbp
  803275:	48 89 e5             	mov    %rsp,%rbp
  803278:	53                   	push   %rbx
  803279:	48 83 ec 38          	sub    $0x38,%rsp
  80327d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803281:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803285:	48 89 c7             	mov    %rax,%rdi
  803288:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  80328f:	00 00 00 
  803292:	ff d0                	callq  *%rax
  803294:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803297:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329b:	0f 88 bf 01 00 00    	js     803460 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a5:	ba 07 04 00 00       	mov    $0x407,%edx
  8032aa:	48 89 c6             	mov    %rax,%rsi
  8032ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b2:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c5:	0f 88 95 01 00 00    	js     803460 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032cb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032cf:	48 89 c7             	mov    %rax,%rdi
  8032d2:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  8032d9:	00 00 00 
  8032dc:	ff d0                	callq  *%rax
  8032de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032e5:	0f 88 5d 01 00 00    	js     803448 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ef:	ba 07 04 00 00       	mov    $0x407,%edx
  8032f4:	48 89 c6             	mov    %rax,%rsi
  8032f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8032fc:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
  803308:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80330b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80330f:	0f 88 33 01 00 00    	js     803448 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803315:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803319:	48 89 c7             	mov    %rax,%rdi
  80331c:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  803323:	00 00 00 
  803326:	ff d0                	callq  *%rax
  803328:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80332c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803330:	ba 07 04 00 00       	mov    $0x407,%edx
  803335:	48 89 c6             	mov    %rax,%rsi
  803338:	bf 00 00 00 00       	mov    $0x0,%edi
  80333d:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  803344:	00 00 00 
  803347:	ff d0                	callq  *%rax
  803349:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80334c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803350:	0f 88 d9 00 00 00    	js     80342f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803356:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335a:	48 89 c7             	mov    %rax,%rdi
  80335d:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
  803369:	48 89 c2             	mov    %rax,%rdx
  80336c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803370:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803376:	48 89 d1             	mov    %rdx,%rcx
  803379:	ba 00 00 00 00       	mov    $0x0,%edx
  80337e:	48 89 c6             	mov    %rax,%rsi
  803381:	bf 00 00 00 00       	mov    $0x0,%edi
  803386:	48 b8 70 1a 80 00 00 	movabs $0x801a70,%rax
  80338d:	00 00 00 
  803390:	ff d0                	callq  *%rax
  803392:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803395:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803399:	78 79                	js     803414 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80339b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8033a6:	00 00 00 
  8033a9:	8b 12                	mov    (%rdx),%edx
  8033ab:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033bc:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8033c3:	00 00 00 
  8033c6:	8b 12                	mov    (%rdx),%edx
  8033c8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ce:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d9:	48 89 c7             	mov    %rax,%rdi
  8033dc:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
  8033e8:	89 c2                	mov    %eax,%edx
  8033ea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033ee:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033f0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033f4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033fc:	48 89 c7             	mov    %rax,%rdi
  8033ff:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
  80340b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80340d:	b8 00 00 00 00       	mov    $0x0,%eax
  803412:	eb 4f                	jmp    803463 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803414:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803415:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803419:	48 89 c6             	mov    %rax,%rsi
  80341c:	bf 00 00 00 00       	mov    $0x0,%edi
  803421:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  803428:	00 00 00 
  80342b:	ff d0                	callq  *%rax
  80342d:	eb 01                	jmp    803430 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80342f:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803430:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803434:	48 89 c6             	mov    %rax,%rsi
  803437:	bf 00 00 00 00       	mov    $0x0,%edi
  80343c:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  803443:	00 00 00 
  803446:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80344c:	48 89 c6             	mov    %rax,%rsi
  80344f:	bf 00 00 00 00       	mov    $0x0,%edi
  803454:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
    err:
	return r;
  803460:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803463:	48 83 c4 38          	add    $0x38,%rsp
  803467:	5b                   	pop    %rbx
  803468:	5d                   	pop    %rbp
  803469:	c3                   	retq   

000000000080346a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80346a:	55                   	push   %rbp
  80346b:	48 89 e5             	mov    %rsp,%rbp
  80346e:	53                   	push   %rbx
  80346f:	48 83 ec 28          	sub    $0x28,%rsp
  803473:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803477:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80347b:	eb 01                	jmp    80347e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  80347d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80347e:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803485:	00 00 00 
  803488:	48 8b 00             	mov    (%rax),%rax
  80348b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803491:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803498:	48 89 c7             	mov    %rax,%rdi
  80349b:	48 b8 0c 3e 80 00 00 	movabs $0x803e0c,%rax
  8034a2:	00 00 00 
  8034a5:	ff d0                	callq  *%rax
  8034a7:	89 c3                	mov    %eax,%ebx
  8034a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ad:	48 89 c7             	mov    %rax,%rdi
  8034b0:	48 b8 0c 3e 80 00 00 	movabs $0x803e0c,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
  8034bc:	39 c3                	cmp    %eax,%ebx
  8034be:	0f 94 c0             	sete   %al
  8034c1:	0f b6 c0             	movzbl %al,%eax
  8034c4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034c7:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  8034ce:	00 00 00 
  8034d1:	48 8b 00             	mov    (%rax),%rax
  8034d4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034da:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034e3:	75 0a                	jne    8034ef <_pipeisclosed+0x85>
			return ret;
  8034e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8034e8:	48 83 c4 28          	add    $0x28,%rsp
  8034ec:	5b                   	pop    %rbx
  8034ed:	5d                   	pop    %rbp
  8034ee:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8034ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034f2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034f5:	74 86                	je     80347d <_pipeisclosed+0x13>
  8034f7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034fb:	75 80                	jne    80347d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034fd:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803504:	00 00 00 
  803507:	48 8b 00             	mov    (%rax),%rax
  80350a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803510:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803513:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803516:	89 c6                	mov    %eax,%esi
  803518:	48 bf 41 4a 80 00 00 	movabs $0x804a41,%rdi
  80351f:	00 00 00 
  803522:	b8 00 00 00 00       	mov    $0x0,%eax
  803527:	49 b8 2b 05 80 00 00 	movabs $0x80052b,%r8
  80352e:	00 00 00 
  803531:	41 ff d0             	callq  *%r8
	}
  803534:	e9 44 ff ff ff       	jmpq   80347d <_pipeisclosed+0x13>

0000000000803539 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803539:	55                   	push   %rbp
  80353a:	48 89 e5             	mov    %rsp,%rbp
  80353d:	48 83 ec 30          	sub    $0x30,%rsp
  803541:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803544:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803548:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80354b:	48 89 d6             	mov    %rdx,%rsi
  80354e:	89 c7                	mov    %eax,%edi
  803550:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  803557:	00 00 00 
  80355a:	ff d0                	callq  *%rax
  80355c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80355f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803563:	79 05                	jns    80356a <pipeisclosed+0x31>
		return r;
  803565:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803568:	eb 31                	jmp    80359b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80356a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80356e:	48 89 c7             	mov    %rax,%rdi
  803571:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
  80357d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803585:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803589:	48 89 d6             	mov    %rdx,%rsi
  80358c:	48 89 c7             	mov    %rax,%rdi
  80358f:	48 b8 6a 34 80 00 00 	movabs $0x80346a,%rax
  803596:	00 00 00 
  803599:	ff d0                	callq  *%rax
}
  80359b:	c9                   	leaveq 
  80359c:	c3                   	retq   

000000000080359d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80359d:	55                   	push   %rbp
  80359e:	48 89 e5             	mov    %rsp,%rbp
  8035a1:	48 83 ec 40          	sub    $0x40,%rsp
  8035a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035b5:	48 89 c7             	mov    %rax,%rdi
  8035b8:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  8035bf:	00 00 00 
  8035c2:	ff d0                	callq  *%rax
  8035c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035d0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035d7:	00 
  8035d8:	e9 97 00 00 00       	jmpq   803674 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035dd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035e2:	74 09                	je     8035ed <devpipe_read+0x50>
				return i;
  8035e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e8:	e9 95 00 00 00       	jmpq   803682 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f5:	48 89 d6             	mov    %rdx,%rsi
  8035f8:	48 89 c7             	mov    %rax,%rdi
  8035fb:	48 b8 6a 34 80 00 00 	movabs $0x80346a,%rax
  803602:	00 00 00 
  803605:	ff d0                	callq  *%rax
  803607:	85 c0                	test   %eax,%eax
  803609:	74 07                	je     803612 <devpipe_read+0x75>
				return 0;
  80360b:	b8 00 00 00 00       	mov    $0x0,%eax
  803610:	eb 70                	jmp    803682 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803612:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  803619:	00 00 00 
  80361c:	ff d0                	callq  *%rax
  80361e:	eb 01                	jmp    803621 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803620:	90                   	nop
  803621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803625:	8b 10                	mov    (%rax),%edx
  803627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362b:	8b 40 04             	mov    0x4(%rax),%eax
  80362e:	39 c2                	cmp    %eax,%edx
  803630:	74 ab                	je     8035dd <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803636:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80363a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80363e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803642:	8b 00                	mov    (%rax),%eax
  803644:	89 c2                	mov    %eax,%edx
  803646:	c1 fa 1f             	sar    $0x1f,%edx
  803649:	c1 ea 1b             	shr    $0x1b,%edx
  80364c:	01 d0                	add    %edx,%eax
  80364e:	83 e0 1f             	and    $0x1f,%eax
  803651:	29 d0                	sub    %edx,%eax
  803653:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803657:	48 98                	cltq   
  803659:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80365e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803664:	8b 00                	mov    (%rax),%eax
  803666:	8d 50 01             	lea    0x1(%rax),%edx
  803669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80366f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803674:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803678:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80367c:	72 a2                	jb     803620 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80367e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803682:	c9                   	leaveq 
  803683:	c3                   	retq   

0000000000803684 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803684:	55                   	push   %rbp
  803685:	48 89 e5             	mov    %rsp,%rbp
  803688:	48 83 ec 40          	sub    $0x40,%rsp
  80368c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803690:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803694:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80369c:	48 89 c7             	mov    %rax,%rdi
  80369f:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  8036a6:	00 00 00 
  8036a9:	ff d0                	callq  *%rax
  8036ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036b7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036be:	00 
  8036bf:	e9 93 00 00 00       	jmpq   803757 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036cc:	48 89 d6             	mov    %rdx,%rsi
  8036cf:	48 89 c7             	mov    %rax,%rdi
  8036d2:	48 b8 6a 34 80 00 00 	movabs $0x80346a,%rax
  8036d9:	00 00 00 
  8036dc:	ff d0                	callq  *%rax
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	74 07                	je     8036e9 <devpipe_write+0x65>
				return 0;
  8036e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e7:	eb 7c                	jmp    803765 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036e9:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  8036f0:	00 00 00 
  8036f3:	ff d0                	callq  *%rax
  8036f5:	eb 01                	jmp    8036f8 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036f7:	90                   	nop
  8036f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fc:	8b 40 04             	mov    0x4(%rax),%eax
  8036ff:	48 63 d0             	movslq %eax,%rdx
  803702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803706:	8b 00                	mov    (%rax),%eax
  803708:	48 98                	cltq   
  80370a:	48 83 c0 20          	add    $0x20,%rax
  80370e:	48 39 c2             	cmp    %rax,%rdx
  803711:	73 b1                	jae    8036c4 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803717:	8b 40 04             	mov    0x4(%rax),%eax
  80371a:	89 c2                	mov    %eax,%edx
  80371c:	c1 fa 1f             	sar    $0x1f,%edx
  80371f:	c1 ea 1b             	shr    $0x1b,%edx
  803722:	01 d0                	add    %edx,%eax
  803724:	83 e0 1f             	and    $0x1f,%eax
  803727:	29 d0                	sub    %edx,%eax
  803729:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80372d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803731:	48 01 ca             	add    %rcx,%rdx
  803734:	0f b6 0a             	movzbl (%rdx),%ecx
  803737:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80373b:	48 98                	cltq   
  80373d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803745:	8b 40 04             	mov    0x4(%rax),%eax
  803748:	8d 50 01             	lea    0x1(%rax),%edx
  80374b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803752:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803757:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80375f:	72 96                	jb     8036f7 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803761:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803765:	c9                   	leaveq 
  803766:	c3                   	retq   

0000000000803767 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803767:	55                   	push   %rbp
  803768:	48 89 e5             	mov    %rsp,%rbp
  80376b:	48 83 ec 20          	sub    $0x20,%rsp
  80376f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803773:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80377b:	48 89 c7             	mov    %rax,%rdi
  80377e:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
  80378a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80378e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803792:	48 be 54 4a 80 00 00 	movabs $0x804a54,%rsi
  803799:	00 00 00 
  80379c:	48 89 c7             	mov    %rax,%rdi
  80379f:	48 b8 e8 10 80 00 00 	movabs $0x8010e8,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037af:	8b 50 04             	mov    0x4(%rax),%edx
  8037b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b6:	8b 00                	mov    (%rax),%eax
  8037b8:	29 c2                	sub    %eax,%edx
  8037ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037be:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037cf:	00 00 00 
	stat->st_dev = &devpipe;
  8037d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037d6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037dd:	00 00 00 
  8037e0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8037e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ec:	c9                   	leaveq 
  8037ed:	c3                   	retq   

00000000008037ee <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037ee:	55                   	push   %rbp
  8037ef:	48 89 e5             	mov    %rsp,%rbp
  8037f2:	48 83 ec 10          	sub    $0x10,%rsp
  8037f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fe:	48 89 c6             	mov    %rax,%rsi
  803801:	bf 00 00 00 00       	mov    $0x0,%edi
  803806:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  80380d:	00 00 00 
  803810:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803812:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803816:	48 89 c7             	mov    %rax,%rdi
  803819:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
  803825:	48 89 c6             	mov    %rax,%rsi
  803828:	bf 00 00 00 00       	mov    $0x0,%edi
  80382d:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  803834:	00 00 00 
  803837:	ff d0                	callq  *%rax
}
  803839:	c9                   	leaveq 
  80383a:	c3                   	retq   
	...

000000000080383c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80383c:	55                   	push   %rbp
  80383d:	48 89 e5             	mov    %rsp,%rbp
  803840:	48 83 ec 20          	sub    $0x20,%rsp
  803844:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803847:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80384d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803851:	be 01 00 00 00       	mov    $0x1,%esi
  803856:	48 89 c7             	mov    %rax,%rdi
  803859:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  803860:	00 00 00 
  803863:	ff d0                	callq  *%rax
}
  803865:	c9                   	leaveq 
  803866:	c3                   	retq   

0000000000803867 <getchar>:

int
getchar(void)
{
  803867:	55                   	push   %rbp
  803868:	48 89 e5             	mov    %rsp,%rbp
  80386b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80386f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803873:	ba 01 00 00 00       	mov    $0x1,%edx
  803878:	48 89 c6             	mov    %rax,%rsi
  80387b:	bf 00 00 00 00       	mov    $0x0,%edi
  803880:	48 b8 78 22 80 00 00 	movabs $0x802278,%rax
  803887:	00 00 00 
  80388a:	ff d0                	callq  *%rax
  80388c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80388f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803893:	79 05                	jns    80389a <getchar+0x33>
		return r;
  803895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803898:	eb 14                	jmp    8038ae <getchar+0x47>
	if (r < 1)
  80389a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389e:	7f 07                	jg     8038a7 <getchar+0x40>
		return -E_EOF;
  8038a0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038a5:	eb 07                	jmp    8038ae <getchar+0x47>
	return c;
  8038a7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038ab:	0f b6 c0             	movzbl %al,%eax
}
  8038ae:	c9                   	leaveq 
  8038af:	c3                   	retq   

00000000008038b0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038b0:	55                   	push   %rbp
  8038b1:	48 89 e5             	mov    %rsp,%rbp
  8038b4:	48 83 ec 20          	sub    $0x20,%rsp
  8038b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c2:	48 89 d6             	mov    %rdx,%rsi
  8038c5:	89 c7                	mov    %eax,%edi
  8038c7:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
  8038d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038da:	79 05                	jns    8038e1 <iscons+0x31>
		return r;
  8038dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038df:	eb 1a                	jmp    8038fb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e5:	8b 10                	mov    (%rax),%edx
  8038e7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8038ee:	00 00 00 
  8038f1:	8b 00                	mov    (%rax),%eax
  8038f3:	39 c2                	cmp    %eax,%edx
  8038f5:	0f 94 c0             	sete   %al
  8038f8:	0f b6 c0             	movzbl %al,%eax
}
  8038fb:	c9                   	leaveq 
  8038fc:	c3                   	retq   

00000000008038fd <opencons>:

int
opencons(void)
{
  8038fd:	55                   	push   %rbp
  8038fe:	48 89 e5             	mov    %rsp,%rbp
  803901:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803905:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803909:	48 89 c7             	mov    %rax,%rdi
  80390c:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  803913:	00 00 00 
  803916:	ff d0                	callq  *%rax
  803918:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80391b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391f:	79 05                	jns    803926 <opencons+0x29>
		return r;
  803921:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803924:	eb 5b                	jmp    803981 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803926:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392a:	ba 07 04 00 00       	mov    $0x407,%edx
  80392f:	48 89 c6             	mov    %rax,%rsi
  803932:	bf 00 00 00 00       	mov    $0x0,%edi
  803937:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
  803943:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803946:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80394a:	79 05                	jns    803951 <opencons+0x54>
		return r;
  80394c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394f:	eb 30                	jmp    803981 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803955:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80395c:	00 00 00 
  80395f:	8b 12                	mov    (%rdx),%edx
  803961:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803963:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803967:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80396e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803972:	48 89 c7             	mov    %rax,%rdi
  803975:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  80397c:	00 00 00 
  80397f:	ff d0                	callq  *%rax
}
  803981:	c9                   	leaveq 
  803982:	c3                   	retq   

0000000000803983 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803983:	55                   	push   %rbp
  803984:	48 89 e5             	mov    %rsp,%rbp
  803987:	48 83 ec 30          	sub    $0x30,%rsp
  80398b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80398f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803993:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803997:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80399c:	75 13                	jne    8039b1 <devcons_read+0x2e>
		return 0;
  80399e:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a3:	eb 49                	jmp    8039ee <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8039a5:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  8039ac:	00 00 00 
  8039af:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039b1:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  8039b8:	00 00 00 
  8039bb:	ff d0                	callq  *%rax
  8039bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c4:	74 df                	je     8039a5 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8039c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ca:	79 05                	jns    8039d1 <devcons_read+0x4e>
		return c;
  8039cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039cf:	eb 1d                	jmp    8039ee <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8039d1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039d5:	75 07                	jne    8039de <devcons_read+0x5b>
		return 0;
  8039d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039dc:	eb 10                	jmp    8039ee <devcons_read+0x6b>
	*(char*)vbuf = c;
  8039de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e1:	89 c2                	mov    %eax,%edx
  8039e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e7:	88 10                	mov    %dl,(%rax)
	return 1;
  8039e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039ee:	c9                   	leaveq 
  8039ef:	c3                   	retq   

00000000008039f0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039f0:	55                   	push   %rbp
  8039f1:	48 89 e5             	mov    %rsp,%rbp
  8039f4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039fb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a02:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a09:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a17:	eb 77                	jmp    803a90 <devcons_write+0xa0>
		m = n - tot;
  803a19:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a20:	89 c2                	mov    %eax,%edx
  803a22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a25:	89 d1                	mov    %edx,%ecx
  803a27:	29 c1                	sub    %eax,%ecx
  803a29:	89 c8                	mov    %ecx,%eax
  803a2b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a31:	83 f8 7f             	cmp    $0x7f,%eax
  803a34:	76 07                	jbe    803a3d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803a36:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a40:	48 63 d0             	movslq %eax,%rdx
  803a43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a46:	48 98                	cltq   
  803a48:	48 89 c1             	mov    %rax,%rcx
  803a4b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803a52:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a59:	48 89 ce             	mov    %rcx,%rsi
  803a5c:	48 89 c7             	mov    %rax,%rdi
  803a5f:	48 b8 0a 14 80 00 00 	movabs $0x80140a,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a6e:	48 63 d0             	movslq %eax,%rdx
  803a71:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a78:	48 89 d6             	mov    %rdx,%rsi
  803a7b:	48 89 c7             	mov    %rax,%rdi
  803a7e:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  803a85:	00 00 00 
  803a88:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a8d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a93:	48 98                	cltq   
  803a95:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a9c:	0f 82 77 ff ff ff    	jb     803a19 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803aa5:	c9                   	leaveq 
  803aa6:	c3                   	retq   

0000000000803aa7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803aa7:	55                   	push   %rbp
  803aa8:	48 89 e5             	mov    %rsp,%rbp
  803aab:	48 83 ec 08          	sub    $0x8,%rsp
  803aaf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ab3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ab8:	c9                   	leaveq 
  803ab9:	c3                   	retq   

0000000000803aba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803aba:	55                   	push   %rbp
  803abb:	48 89 e5             	mov    %rsp,%rbp
  803abe:	48 83 ec 10          	sub    $0x10,%rsp
  803ac2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ac6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ace:	48 be 60 4a 80 00 00 	movabs $0x804a60,%rsi
  803ad5:	00 00 00 
  803ad8:	48 89 c7             	mov    %rax,%rdi
  803adb:	48 b8 e8 10 80 00 00 	movabs $0x8010e8,%rax
  803ae2:	00 00 00 
  803ae5:	ff d0                	callq  *%rax
	return 0;
  803ae7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aec:	c9                   	leaveq 
  803aed:	c3                   	retq   
	...

0000000000803af0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803af0:	55                   	push   %rbp
  803af1:	48 89 e5             	mov    %rsp,%rbp
  803af4:	53                   	push   %rbx
  803af5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803afc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803b03:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803b09:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803b10:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803b17:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803b1e:	84 c0                	test   %al,%al
  803b20:	74 23                	je     803b45 <_panic+0x55>
  803b22:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b29:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b2d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b31:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b35:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b39:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b3d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b41:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b45:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b4c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b53:	00 00 00 
  803b56:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b5d:	00 00 00 
  803b60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b64:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b6b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b72:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b79:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803b80:	00 00 00 
  803b83:	48 8b 18             	mov    (%rax),%rbx
  803b86:	48 b8 a4 19 80 00 00 	movabs $0x8019a4,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
  803b92:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803b98:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b9f:	41 89 c8             	mov    %ecx,%r8d
  803ba2:	48 89 d1             	mov    %rdx,%rcx
  803ba5:	48 89 da             	mov    %rbx,%rdx
  803ba8:	89 c6                	mov    %eax,%esi
  803baa:	48 bf 68 4a 80 00 00 	movabs $0x804a68,%rdi
  803bb1:	00 00 00 
  803bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb9:	49 b9 2b 05 80 00 00 	movabs $0x80052b,%r9
  803bc0:	00 00 00 
  803bc3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803bc6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803bcd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bd4:	48 89 d6             	mov    %rdx,%rsi
  803bd7:	48 89 c7             	mov    %rax,%rdi
  803bda:	48 b8 7f 04 80 00 00 	movabs $0x80047f,%rax
  803be1:	00 00 00 
  803be4:	ff d0                	callq  *%rax
	cprintf("\n");
  803be6:	48 bf 8b 4a 80 00 00 	movabs $0x804a8b,%rdi
  803bed:	00 00 00 
  803bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf5:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  803bfc:	00 00 00 
  803bff:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803c01:	cc                   	int3   
  803c02:	eb fd                	jmp    803c01 <_panic+0x111>

0000000000803c04 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c04:	55                   	push   %rbp
  803c05:	48 89 e5             	mov    %rsp,%rbp
  803c08:	48 83 ec 30          	sub    $0x30,%rsp
  803c0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c14:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803c18:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c1d:	74 18                	je     803c37 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803c1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c23:	48 89 c7             	mov    %rax,%rdi
  803c26:	48 b8 49 1c 80 00 00 	movabs $0x801c49,%rax
  803c2d:	00 00 00 
  803c30:	ff d0                	callq  *%rax
  803c32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c35:	eb 19                	jmp    803c50 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803c37:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803c3e:	00 00 00 
  803c41:	48 b8 49 1c 80 00 00 	movabs $0x801c49,%rax
  803c48:	00 00 00 
  803c4b:	ff d0                	callq  *%rax
  803c4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803c50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c54:	79 19                	jns    803c6f <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803c56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c5a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803c60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c64:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6d:	eb 53                	jmp    803cc2 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803c6f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c74:	74 19                	je     803c8f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803c76:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803c7d:	00 00 00 
  803c80:	48 8b 00             	mov    (%rax),%rax
  803c83:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c8d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803c8f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c94:	74 19                	je     803caf <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803c96:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803c9d:	00 00 00 
  803ca0:	48 8b 00             	mov    (%rax),%rax
  803ca3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cad:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803caf:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803cb6:	00 00 00 
  803cb9:	48 8b 00             	mov    (%rax),%rax
  803cbc:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803cc2:	c9                   	leaveq 
  803cc3:	c3                   	retq   

0000000000803cc4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803cc4:	55                   	push   %rbp
  803cc5:	48 89 e5             	mov    %rsp,%rbp
  803cc8:	48 83 ec 30          	sub    $0x30,%rsp
  803ccc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ccf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cd2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803cd6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803cd9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803ce0:	e9 96 00 00 00       	jmpq   803d7b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803ce5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803cea:	74 20                	je     803d0c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803cec:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803cef:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803cf2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cf9:	89 c7                	mov    %eax,%edi
  803cfb:	48 b8 f4 1b 80 00 00 	movabs $0x801bf4,%rax
  803d02:	00 00 00 
  803d05:	ff d0                	callq  *%rax
  803d07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d0a:	eb 2d                	jmp    803d39 <ipc_send+0x75>
		else if(pg==NULL)
  803d0c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d11:	75 26                	jne    803d39 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803d13:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d19:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d1e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d25:	00 00 00 
  803d28:	89 c7                	mov    %eax,%edi
  803d2a:	48 b8 f4 1b 80 00 00 	movabs $0x801bf4,%rax
  803d31:	00 00 00 
  803d34:	ff d0                	callq  *%rax
  803d36:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803d39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d3d:	79 30                	jns    803d6f <ipc_send+0xab>
  803d3f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d43:	74 2a                	je     803d6f <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803d45:	48 ba 8d 4a 80 00 00 	movabs $0x804a8d,%rdx
  803d4c:	00 00 00 
  803d4f:	be 40 00 00 00       	mov    $0x40,%esi
  803d54:	48 bf a5 4a 80 00 00 	movabs $0x804aa5,%rdi
  803d5b:	00 00 00 
  803d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d63:	48 b9 f0 3a 80 00 00 	movabs $0x803af0,%rcx
  803d6a:	00 00 00 
  803d6d:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803d6f:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803d7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d7f:	0f 85 60 ff ff ff    	jne    803ce5 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803d85:	c9                   	leaveq 
  803d86:	c3                   	retq   

0000000000803d87 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d87:	55                   	push   %rbp
  803d88:	48 89 e5             	mov    %rsp,%rbp
  803d8b:	48 83 ec 18          	sub    $0x18,%rsp
  803d8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803d92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d99:	eb 5e                	jmp    803df9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d9b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803da2:	00 00 00 
  803da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da8:	48 63 d0             	movslq %eax,%rdx
  803dab:	48 89 d0             	mov    %rdx,%rax
  803dae:	48 c1 e0 03          	shl    $0x3,%rax
  803db2:	48 01 d0             	add    %rdx,%rax
  803db5:	48 c1 e0 05          	shl    $0x5,%rax
  803db9:	48 01 c8             	add    %rcx,%rax
  803dbc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803dc2:	8b 00                	mov    (%rax),%eax
  803dc4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dc7:	75 2c                	jne    803df5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803dc9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803dd0:	00 00 00 
  803dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd6:	48 63 d0             	movslq %eax,%rdx
  803dd9:	48 89 d0             	mov    %rdx,%rax
  803ddc:	48 c1 e0 03          	shl    $0x3,%rax
  803de0:	48 01 d0             	add    %rdx,%rax
  803de3:	48 c1 e0 05          	shl    $0x5,%rax
  803de7:	48 01 c8             	add    %rcx,%rax
  803dea:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803df0:	8b 40 08             	mov    0x8(%rax),%eax
  803df3:	eb 12                	jmp    803e07 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803df5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803df9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e00:	7e 99                	jle    803d9b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e07:	c9                   	leaveq 
  803e08:	c3                   	retq   
  803e09:	00 00                	add    %al,(%rax)
	...

0000000000803e0c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e0c:	55                   	push   %rbp
  803e0d:	48 89 e5             	mov    %rsp,%rbp
  803e10:	48 83 ec 18          	sub    $0x18,%rsp
  803e14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e1c:	48 89 c2             	mov    %rax,%rdx
  803e1f:	48 c1 ea 15          	shr    $0x15,%rdx
  803e23:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e2a:	01 00 00 
  803e2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e31:	83 e0 01             	and    $0x1,%eax
  803e34:	48 85 c0             	test   %rax,%rax
  803e37:	75 07                	jne    803e40 <pageref+0x34>
		return 0;
  803e39:	b8 00 00 00 00       	mov    $0x0,%eax
  803e3e:	eb 53                	jmp    803e93 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e44:	48 89 c2             	mov    %rax,%rdx
  803e47:	48 c1 ea 0c          	shr    $0xc,%rdx
  803e4b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e52:	01 00 00 
  803e55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e61:	83 e0 01             	and    $0x1,%eax
  803e64:	48 85 c0             	test   %rax,%rax
  803e67:	75 07                	jne    803e70 <pageref+0x64>
		return 0;
  803e69:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6e:	eb 23                	jmp    803e93 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e74:	48 89 c2             	mov    %rax,%rdx
  803e77:	48 c1 ea 0c          	shr    $0xc,%rdx
  803e7b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e82:	00 00 00 
  803e85:	48 c1 e2 04          	shl    $0x4,%rdx
  803e89:	48 01 d0             	add    %rdx,%rax
  803e8c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e90:	0f b7 c0             	movzwl %ax,%eax
}
  803e93:	c9                   	leaveq 
  803e94:	c3                   	retq   
  803e95:	00 00                	add    %al,(%rax)
	...

0000000000803e98 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  803e98:	55                   	push   %rbp
  803e99:	48 89 e5             	mov    %rsp,%rbp
  803e9c:	48 83 ec 20          	sub    $0x20,%rsp
  803ea0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  803ea4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ea8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eac:	48 89 d6             	mov    %rdx,%rsi
  803eaf:	48 89 c7             	mov    %rax,%rdi
  803eb2:	48 b8 ce 3e 80 00 00 	movabs $0x803ece,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax
  803ebe:	85 c0                	test   %eax,%eax
  803ec0:	74 05                	je     803ec7 <inet_addr+0x2f>
    return (val.s_addr);
  803ec2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ec5:	eb 05                	jmp    803ecc <inet_addr+0x34>
  }
  return (INADDR_NONE);
  803ec7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803ecc:	c9                   	leaveq 
  803ecd:	c3                   	retq   

0000000000803ece <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803ece:	55                   	push   %rbp
  803ecf:	48 89 e5             	mov    %rsp,%rbp
  803ed2:	53                   	push   %rbx
  803ed3:	48 83 ec 48          	sub    $0x48,%rsp
  803ed7:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  803edb:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  803edf:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803ee3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  c = *cp;
  803ee7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803eeb:	0f b6 00             	movzbl (%rax),%eax
  803eee:	0f be c0             	movsbl %al,%eax
  803ef1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803ef4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ef7:	3c 2f                	cmp    $0x2f,%al
  803ef9:	76 07                	jbe    803f02 <inet_aton+0x34>
  803efb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803efe:	3c 39                	cmp    $0x39,%al
  803f00:	76 0a                	jbe    803f0c <inet_aton+0x3e>
      return (0);
  803f02:	b8 00 00 00 00       	mov    $0x0,%eax
  803f07:	e9 6a 02 00 00       	jmpq   804176 <inet_aton+0x2a8>
    val = 0;
  803f0c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    base = 10;
  803f13:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%rbp)
    if (c == '0') {
  803f1a:	83 7d e4 30          	cmpl   $0x30,-0x1c(%rbp)
  803f1e:	75 40                	jne    803f60 <inet_aton+0x92>
      c = *++cp;
  803f20:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f25:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f29:	0f b6 00             	movzbl (%rax),%eax
  803f2c:	0f be c0             	movsbl %al,%eax
  803f2f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if (c == 'x' || c == 'X') {
  803f32:	83 7d e4 78          	cmpl   $0x78,-0x1c(%rbp)
  803f36:	74 06                	je     803f3e <inet_aton+0x70>
  803f38:	83 7d e4 58          	cmpl   $0x58,-0x1c(%rbp)
  803f3c:	75 1b                	jne    803f59 <inet_aton+0x8b>
        base = 16;
  803f3e:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
        c = *++cp;
  803f45:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f4a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f4e:	0f b6 00             	movzbl (%rax),%eax
  803f51:	0f be c0             	movsbl %al,%eax
  803f54:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803f57:	eb 07                	jmp    803f60 <inet_aton+0x92>
      } else
        base = 8;
  803f59:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  803f60:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f63:	3c 2f                	cmp    $0x2f,%al
  803f65:	76 2f                	jbe    803f96 <inet_aton+0xc8>
  803f67:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f6a:	3c 39                	cmp    $0x39,%al
  803f6c:	77 28                	ja     803f96 <inet_aton+0xc8>
        val = (val * base) + (int)(c - '0');
  803f6e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f71:	89 c2                	mov    %eax,%edx
  803f73:	0f af 55 ec          	imul   -0x14(%rbp),%edx
  803f77:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f7a:	01 d0                	add    %edx,%eax
  803f7c:	83 e8 30             	sub    $0x30,%eax
  803f7f:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  803f82:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f87:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f8b:	0f b6 00             	movzbl (%rax),%eax
  803f8e:	0f be c0             	movsbl %al,%eax
  803f91:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  803f94:	eb ca                	jmp    803f60 <inet_aton+0x92>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  803f96:	83 7d e8 10          	cmpl   $0x10,-0x18(%rbp)
  803f9a:	75 74                	jne    804010 <inet_aton+0x142>
  803f9c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f9f:	3c 2f                	cmp    $0x2f,%al
  803fa1:	76 07                	jbe    803faa <inet_aton+0xdc>
  803fa3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fa6:	3c 39                	cmp    $0x39,%al
  803fa8:	76 1c                	jbe    803fc6 <inet_aton+0xf8>
  803faa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fad:	3c 60                	cmp    $0x60,%al
  803faf:	76 07                	jbe    803fb8 <inet_aton+0xea>
  803fb1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fb4:	3c 66                	cmp    $0x66,%al
  803fb6:	76 0e                	jbe    803fc6 <inet_aton+0xf8>
  803fb8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fbb:	3c 40                	cmp    $0x40,%al
  803fbd:	76 51                	jbe    804010 <inet_aton+0x142>
  803fbf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fc2:	3c 46                	cmp    $0x46,%al
  803fc4:	77 4a                	ja     804010 <inet_aton+0x142>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  803fc6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fc9:	89 c2                	mov    %eax,%edx
  803fcb:	c1 e2 04             	shl    $0x4,%edx
  803fce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fd1:	8d 48 0a             	lea    0xa(%rax),%ecx
  803fd4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fd7:	3c 60                	cmp    $0x60,%al
  803fd9:	76 0e                	jbe    803fe9 <inet_aton+0x11b>
  803fdb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fde:	3c 7a                	cmp    $0x7a,%al
  803fe0:	77 07                	ja     803fe9 <inet_aton+0x11b>
  803fe2:	b8 61 00 00 00       	mov    $0x61,%eax
  803fe7:	eb 05                	jmp    803fee <inet_aton+0x120>
  803fe9:	b8 41 00 00 00       	mov    $0x41,%eax
  803fee:	89 cb                	mov    %ecx,%ebx
  803ff0:	29 c3                	sub    %eax,%ebx
  803ff2:	89 d8                	mov    %ebx,%eax
  803ff4:	09 d0                	or     %edx,%eax
  803ff6:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  803ff9:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803ffe:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804002:	0f b6 00             	movzbl (%rax),%eax
  804005:	0f be c0             	movsbl %al,%eax
  804008:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else
        break;
    }
  80400b:	e9 50 ff ff ff       	jmpq   803f60 <inet_aton+0x92>
    if (c == '.') {
  804010:	83 7d e4 2e          	cmpl   $0x2e,-0x1c(%rbp)
  804014:	75 3d                	jne    804053 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804016:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  80401a:	48 83 c0 0c          	add    $0xc,%rax
  80401e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804022:	72 0a                	jb     80402e <inet_aton+0x160>
        return (0);
  804024:	b8 00 00 00 00       	mov    $0x0,%eax
  804029:	e9 48 01 00 00       	jmpq   804176 <inet_aton+0x2a8>
      *pp++ = val;
  80402e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804032:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804035:	89 10                	mov    %edx,(%rax)
  804037:	48 83 45 d8 04       	addq   $0x4,-0x28(%rbp)
      c = *++cp;
  80403c:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804041:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804045:	0f b6 00             	movzbl (%rax),%eax
  804048:	0f be c0             	movsbl %al,%eax
  80404b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    } else
      break;
  }
  80404e:	e9 a1 fe ff ff       	jmpq   803ef4 <inet_aton+0x26>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804053:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804054:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804058:	74 3c                	je     804096 <inet_aton+0x1c8>
  80405a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80405d:	3c 1f                	cmp    $0x1f,%al
  80405f:	76 2b                	jbe    80408c <inet_aton+0x1be>
  804061:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804064:	84 c0                	test   %al,%al
  804066:	78 24                	js     80408c <inet_aton+0x1be>
  804068:	83 7d e4 20          	cmpl   $0x20,-0x1c(%rbp)
  80406c:	74 28                	je     804096 <inet_aton+0x1c8>
  80406e:	83 7d e4 0c          	cmpl   $0xc,-0x1c(%rbp)
  804072:	74 22                	je     804096 <inet_aton+0x1c8>
  804074:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  804078:	74 1c                	je     804096 <inet_aton+0x1c8>
  80407a:	83 7d e4 0d          	cmpl   $0xd,-0x1c(%rbp)
  80407e:	74 16                	je     804096 <inet_aton+0x1c8>
  804080:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  804084:	74 10                	je     804096 <inet_aton+0x1c8>
  804086:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%rbp)
  80408a:	74 0a                	je     804096 <inet_aton+0x1c8>
    return (0);
  80408c:	b8 00 00 00 00       	mov    $0x0,%eax
  804091:	e9 e0 00 00 00       	jmpq   804176 <inet_aton+0x2a8>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804096:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80409a:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  80409e:	48 89 d1             	mov    %rdx,%rcx
  8040a1:	48 29 c1             	sub    %rax,%rcx
  8040a4:	48 89 c8             	mov    %rcx,%rax
  8040a7:	48 c1 f8 02          	sar    $0x2,%rax
  8040ab:	83 c0 01             	add    $0x1,%eax
  8040ae:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  switch (n) {
  8040b1:	83 7d d4 04          	cmpl   $0x4,-0x2c(%rbp)
  8040b5:	0f 87 98 00 00 00    	ja     804153 <inet_aton+0x285>
  8040bb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8040be:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040c5:	00 
  8040c6:	48 b8 b0 4a 80 00 00 	movabs $0x804ab0,%rax
  8040cd:	00 00 00 
  8040d0:	48 01 d0             	add    %rdx,%rax
  8040d3:	48 8b 00             	mov    (%rax),%rax
  8040d6:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8040d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8040dd:	e9 94 00 00 00       	jmpq   804176 <inet_aton+0x2a8>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8040e2:	81 7d ec ff ff ff 00 	cmpl   $0xffffff,-0x14(%rbp)
  8040e9:	76 0a                	jbe    8040f5 <inet_aton+0x227>
      return (0);
  8040eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f0:	e9 81 00 00 00       	jmpq   804176 <inet_aton+0x2a8>
    val |= parts[0] << 24;
  8040f5:	8b 45 c0             	mov    -0x40(%rbp),%eax
  8040f8:	c1 e0 18             	shl    $0x18,%eax
  8040fb:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  8040fe:	eb 53                	jmp    804153 <inet_aton+0x285>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804100:	81 7d ec ff ff 00 00 	cmpl   $0xffff,-0x14(%rbp)
  804107:	76 07                	jbe    804110 <inet_aton+0x242>
      return (0);
  804109:	b8 00 00 00 00       	mov    $0x0,%eax
  80410e:	eb 66                	jmp    804176 <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804110:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804113:	89 c2                	mov    %eax,%edx
  804115:	c1 e2 18             	shl    $0x18,%edx
  804118:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80411b:	c1 e0 10             	shl    $0x10,%eax
  80411e:	09 d0                	or     %edx,%eax
  804120:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804123:	eb 2e                	jmp    804153 <inet_aton+0x285>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804125:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%rbp)
  80412c:	76 07                	jbe    804135 <inet_aton+0x267>
      return (0);
  80412e:	b8 00 00 00 00       	mov    $0x0,%eax
  804133:	eb 41                	jmp    804176 <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804135:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804138:	89 c2                	mov    %eax,%edx
  80413a:	c1 e2 18             	shl    $0x18,%edx
  80413d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804140:	c1 e0 10             	shl    $0x10,%eax
  804143:	09 c2                	or     %eax,%edx
  804145:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804148:	c1 e0 08             	shl    $0x8,%eax
  80414b:	09 d0                	or     %edx,%eax
  80414d:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804150:	eb 01                	jmp    804153 <inet_aton+0x285>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  804152:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804153:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  804158:	74 17                	je     804171 <inet_aton+0x2a3>
    addr->s_addr = htonl(val);
  80415a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80415d:	89 c7                	mov    %eax,%edi
  80415f:	48 b8 e5 42 80 00 00 	movabs $0x8042e5,%rax
  804166:	00 00 00 
  804169:	ff d0                	callq  *%rax
  80416b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80416f:	89 02                	mov    %eax,(%rdx)
  return (1);
  804171:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804176:	48 83 c4 48          	add    $0x48,%rsp
  80417a:	5b                   	pop    %rbx
  80417b:	5d                   	pop    %rbp
  80417c:	c3                   	retq   

000000000080417d <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  80417d:	55                   	push   %rbp
  80417e:	48 89 e5             	mov    %rsp,%rbp
  804181:	48 83 ec 30          	sub    $0x30,%rsp
  804185:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804188:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80418b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80418e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  804195:	00 00 00 
  804198:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  80419c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8041a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  8041a4:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8041a8:	e9 d1 00 00 00       	jmpq   80427e <inet_ntoa+0x101>
    i = 0;
  8041ad:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8041b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b5:	0f b6 08             	movzbl (%rax),%ecx
  8041b8:	0f b6 d1             	movzbl %cl,%edx
  8041bb:	89 d0                	mov    %edx,%eax
  8041bd:	c1 e0 02             	shl    $0x2,%eax
  8041c0:	01 d0                	add    %edx,%eax
  8041c2:	c1 e0 03             	shl    $0x3,%eax
  8041c5:	01 d0                	add    %edx,%eax
  8041c7:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8041ce:	01 d0                	add    %edx,%eax
  8041d0:	66 c1 e8 08          	shr    $0x8,%ax
  8041d4:	c0 e8 03             	shr    $0x3,%al
  8041d7:	88 45 ed             	mov    %al,-0x13(%rbp)
  8041da:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8041de:	89 d0                	mov    %edx,%eax
  8041e0:	c1 e0 02             	shl    $0x2,%eax
  8041e3:	01 d0                	add    %edx,%eax
  8041e5:	01 c0                	add    %eax,%eax
  8041e7:	89 ca                	mov    %ecx,%edx
  8041e9:	28 c2                	sub    %al,%dl
  8041eb:	89 d0                	mov    %edx,%eax
  8041ed:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8041f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041f4:	0f b6 00             	movzbl (%rax),%eax
  8041f7:	0f b6 d0             	movzbl %al,%edx
  8041fa:	89 d0                	mov    %edx,%eax
  8041fc:	c1 e0 02             	shl    $0x2,%eax
  8041ff:	01 d0                	add    %edx,%eax
  804201:	c1 e0 03             	shl    $0x3,%eax
  804204:	01 d0                	add    %edx,%eax
  804206:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  80420d:	01 d0                	add    %edx,%eax
  80420f:	66 c1 e8 08          	shr    $0x8,%ax
  804213:	89 c2                	mov    %eax,%edx
  804215:	c0 ea 03             	shr    $0x3,%dl
  804218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80421c:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  80421e:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804222:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804226:	83 c2 30             	add    $0x30,%edx
  804229:	48 98                	cltq   
  80422b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  80422f:	80 45 ee 01          	addb   $0x1,-0x12(%rbp)
    } while(*ap);
  804233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804237:	0f b6 00             	movzbl (%rax),%eax
  80423a:	84 c0                	test   %al,%al
  80423c:	0f 85 6f ff ff ff    	jne    8041b1 <inet_ntoa+0x34>
    while(i--)
  804242:	eb 16                	jmp    80425a <inet_ntoa+0xdd>
      *rp++ = inv[i];
  804244:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804248:	48 98                	cltq   
  80424a:	0f b6 54 05 e0       	movzbl -0x20(%rbp,%rax,1),%edx
  80424f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804253:	88 10                	mov    %dl,(%rax)
  804255:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80425a:	80 7d ee 00          	cmpb   $0x0,-0x12(%rbp)
  80425e:	0f 95 c0             	setne  %al
  804261:	80 6d ee 01          	subb   $0x1,-0x12(%rbp)
  804265:	84 c0                	test   %al,%al
  804267:	75 db                	jne    804244 <inet_ntoa+0xc7>
      *rp++ = inv[i];
    *rp++ = '.';
  804269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80426d:	c6 00 2e             	movb   $0x2e,(%rax)
  804270:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    ap++;
  804275:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80427a:	80 45 ef 01          	addb   $0x1,-0x11(%rbp)
  80427e:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  804282:	0f 86 25 ff ff ff    	jbe    8041ad <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804288:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  80428d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804291:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804294:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80429b:	00 00 00 
}
  80429e:	c9                   	leaveq 
  80429f:	c3                   	retq   

00000000008042a0 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8042a0:	55                   	push   %rbp
  8042a1:	48 89 e5             	mov    %rsp,%rbp
  8042a4:	48 83 ec 08          	sub    $0x8,%rsp
  8042a8:	89 f8                	mov    %edi,%eax
  8042aa:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8042ae:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8042b2:	c1 e0 08             	shl    $0x8,%eax
  8042b5:	89 c2                	mov    %eax,%edx
  8042b7:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8042bb:	66 c1 e8 08          	shr    $0x8,%ax
  8042bf:	09 d0                	or     %edx,%eax
}
  8042c1:	c9                   	leaveq 
  8042c2:	c3                   	retq   

00000000008042c3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8042c3:	55                   	push   %rbp
  8042c4:	48 89 e5             	mov    %rsp,%rbp
  8042c7:	48 83 ec 08          	sub    $0x8,%rsp
  8042cb:	89 f8                	mov    %edi,%eax
  8042cd:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8042d1:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8042d5:	89 c7                	mov    %eax,%edi
  8042d7:	48 b8 a0 42 80 00 00 	movabs $0x8042a0,%rax
  8042de:	00 00 00 
  8042e1:	ff d0                	callq  *%rax
}
  8042e3:	c9                   	leaveq 
  8042e4:	c3                   	retq   

00000000008042e5 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8042e5:	55                   	push   %rbp
  8042e6:	48 89 e5             	mov    %rsp,%rbp
  8042e9:	48 83 ec 08          	sub    $0x8,%rsp
  8042ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8042f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f3:	89 c2                	mov    %eax,%edx
  8042f5:	c1 e2 18             	shl    $0x18,%edx
    ((n & 0xff00) << 8) |
  8042f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042fb:	25 00 ff 00 00       	and    $0xff00,%eax
  804300:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804303:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  804305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804308:	25 00 00 ff 00       	and    $0xff0000,%eax
  80430d:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804311:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  804313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804316:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804319:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80431b:	c9                   	leaveq 
  80431c:	c3                   	retq   

000000000080431d <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80431d:	55                   	push   %rbp
  80431e:	48 89 e5             	mov    %rsp,%rbp
  804321:	48 83 ec 08          	sub    $0x8,%rsp
  804325:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432b:	89 c7                	mov    %eax,%edi
  80432d:	48 b8 e5 42 80 00 00 	movabs $0x8042e5,%rax
  804334:	00 00 00 
  804337:	ff d0                	callq  *%rax
}
  804339:	c9                   	leaveq 
  80433a:	c3                   	retq   
