
obj/user/lsfd.debug:     file format elf64-x86-64


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
  80003c:	e8 7f 01 00 00       	callq  8001c0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800048:	48 bf 20 43 80 00 00 	movabs $0x804320,%rdi
  80004f:	00 00 00 
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	48 ba af 03 80 00 00 	movabs $0x8003af,%rdx
  80005e:	00 00 00 
  800061:	ff d2                	callq  *%rdx
	exit();
  800063:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
}
  80006f:	5d                   	pop    %rbp
  800070:	c3                   	retq   

0000000000800071 <umain>:

void
umain(int argc, char **argv)
{
  800071:	55                   	push   %rbp
  800072:	48 89 e5             	mov    %rsp,%rbp
  800075:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007c:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800082:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800089:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800090:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800097:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009e:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a5:	48 89 ce             	mov    %rcx,%rsi
  8000a8:	48 89 c7             	mov    %rax,%rdi
  8000ab:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b7:	eb 1b                	jmp    8000d4 <umain+0x63>
		if (i == '1')
  8000b9:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bd:	75 09                	jne    8000c8 <umain+0x57>
			usefprint = 1;
  8000bf:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c6:	eb 0c                	jmp    8000d4 <umain+0x63>
		else
			usage();
  8000c8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000db:	48 89 c7             	mov    %rax,%rdi
  8000de:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
  8000ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f1:	79 c6                	jns    8000b9 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000fa:	e9 b3 00 00 00       	jmpq   8001b2 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000ff:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	48 89 d6             	mov    %rdx,%rsi
  80010c:	89 c7                	mov    %eax,%edi
  80010e:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
  80011a:	85 c0                	test   %eax,%eax
  80011c:	0f 88 8c 00 00 00    	js     8001ae <umain+0x13d>
			if (usefprint)
  800122:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800126:	74 4a                	je     800172 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012c:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800130:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800133:	8b 75 e4             	mov    -0x1c(%rbp),%esi
					i, st.st_name, st.st_isdir,
  800136:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80013d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800140:	48 89 0c 24          	mov    %rcx,(%rsp)
  800144:	41 89 f9             	mov    %edi,%r9d
  800147:	41 89 f0             	mov    %esi,%r8d
  80014a:	48 89 d1             	mov    %rdx,%rcx
  80014d:	89 c2                	mov    %eax,%edx
  80014f:	48 be 38 43 80 00 00 	movabs $0x804338,%rsi
  800156:	00 00 00 
  800159:	bf 01 00 00 00       	mov    $0x1,%edi
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 ba 64 2d 80 00 00 	movabs $0x802d64,%r10
  80016a:	00 00 00 
  80016d:	41 ff d2             	callq  *%r10
  800170:	eb 3c                	jmp    8001ae <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800176:	48 8b 78 08          	mov    0x8(%rax),%rdi
  80017a:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
					i, st.st_name, st.st_isdir,
  800180:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018a:	49 89 f9             	mov    %rdi,%r9
  80018d:	41 89 f0             	mov    %esi,%r8d
  800190:	89 c6                	mov    %eax,%esi
  800192:	48 bf 38 43 80 00 00 	movabs $0x804338,%rdi
  800199:	00 00 00 
  80019c:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a1:	49 ba af 03 80 00 00 	movabs $0x8003af,%r10
  8001a8:	00 00 00 
  8001ab:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b6:	0f 8e 43 ff ff ff    	jle    8000ff <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bc:	c9                   	leaveq 
  8001bd:	c3                   	retq   
	...

00000000008001c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c0:	55                   	push   %rbp
  8001c1:	48 89 e5             	mov    %rsp,%rbp
  8001c4:	48 83 ec 10          	sub    $0x10,%rsp
  8001c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001cf:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001d6:	00 00 00 
  8001d9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8001e0:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax
  8001ec:	48 98                	cltq   
  8001ee:	48 89 c2             	mov    %rax,%rdx
  8001f1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001f7:	48 89 d0             	mov    %rdx,%rax
  8001fa:	48 c1 e0 03          	shl    $0x3,%rax
  8001fe:	48 01 d0             	add    %rdx,%rax
  800201:	48 c1 e0 05          	shl    $0x5,%rax
  800205:	48 89 c2             	mov    %rax,%rdx
  800208:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80020f:	00 00 00 
  800212:	48 01 c2             	add    %rax,%rdx
  800215:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80021c:	00 00 00 
  80021f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800222:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800226:	7e 14                	jle    80023c <libmain+0x7c>
		binaryname = argv[0];
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	48 8b 10             	mov    (%rax),%rdx
  80022f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800236:	00 00 00 
  800239:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80023c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800240:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800243:	48 89 d6             	mov    %rdx,%rsi
  800246:	89 c7                	mov    %eax,%edi
  800248:	48 b8 71 00 80 00 00 	movabs $0x800071,%rax
  80024f:	00 00 00 
  800252:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800254:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  80025b:	00 00 00 
  80025e:	ff d0                	callq  *%rax
}
  800260:	c9                   	leaveq 
  800261:	c3                   	retq   
	...

0000000000800264 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800264:	55                   	push   %rbp
  800265:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800268:	48 b8 05 22 80 00 00 	movabs $0x802205,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800274:	bf 00 00 00 00       	mov    $0x0,%edi
  800279:	48 b8 e4 17 80 00 00 	movabs $0x8017e4,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
}
  800285:	5d                   	pop    %rbp
  800286:	c3                   	retq   
	...

0000000000800288 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 10          	sub    $0x10,%rsp
  800290:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800293:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029b:	8b 00                	mov    (%rax),%eax
  80029d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002a0:	89 d6                	mov    %edx,%esi
  8002a2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8002a6:	48 63 d0             	movslq %eax,%rdx
  8002a9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8002ae:	8d 50 01             	lea    0x1(%rax),%edx
  8002b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b5:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8002b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002bb:	8b 00                	mov    (%rax),%eax
  8002bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c2:	75 2c                	jne    8002f0 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8002c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002c8:	8b 00                	mov    (%rax),%eax
  8002ca:	48 98                	cltq   
  8002cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d0:	48 83 c2 08          	add    $0x8,%rdx
  8002d4:	48 89 c6             	mov    %rax,%rsi
  8002d7:	48 89 d7             	mov    %rdx,%rdi
  8002da:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
		b->idx = 0;
  8002e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8002f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f4:	8b 40 04             	mov    0x4(%rax),%eax
  8002f7:	8d 50 01             	lea    0x1(%rax),%edx
  8002fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fe:	89 50 04             	mov    %edx,0x4(%rax)
}
  800301:	c9                   	leaveq 
  800302:	c3                   	retq   

0000000000800303 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800303:	55                   	push   %rbp
  800304:	48 89 e5             	mov    %rsp,%rbp
  800307:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80030e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800315:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80031c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800323:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80032a:	48 8b 0a             	mov    (%rdx),%rcx
  80032d:	48 89 08             	mov    %rcx,(%rax)
  800330:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800334:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800338:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80033c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800340:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800347:	00 00 00 
	b.cnt = 0;
  80034a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800351:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800354:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80035b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800362:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf 88 02 80 00 00 	movabs $0x800288,%rdi
  800373:	00 00 00 
  800376:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  80037d:	00 00 00 
  800380:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800382:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800388:	48 98                	cltq   
  80038a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800391:	48 83 c2 08          	add    $0x8,%rdx
  800395:	48 89 c6             	mov    %rax,%rsi
  800398:	48 89 d7             	mov    %rdx,%rdi
  80039b:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  8003a2:	00 00 00 
  8003a5:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8003a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003ad:	c9                   	leaveq 
  8003ae:	c3                   	retq   

00000000008003af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003af:	55                   	push   %rbp
  8003b0:	48 89 e5             	mov    %rsp,%rbp
  8003b3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003ba:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003c1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003c8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003cf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003d6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003dd:	84 c0                	test   %al,%al
  8003df:	74 20                	je     800401 <cprintf+0x52>
  8003e1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003e5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003e9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003ed:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003f1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003f5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003f9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003fd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800401:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800408:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80040f:	00 00 00 
  800412:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800419:	00 00 00 
  80041c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800420:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800427:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80042e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800435:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80043c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800443:	48 8b 0a             	mov    (%rdx),%rcx
  800446:	48 89 08             	mov    %rcx,(%rax)
  800449:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80044d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800451:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800455:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800459:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800460:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800467:	48 89 d6             	mov    %rdx,%rsi
  80046a:	48 89 c7             	mov    %rax,%rdi
  80046d:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  800474:	00 00 00 
  800477:	ff d0                	callq  *%rax
  800479:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80047f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800485:	c9                   	leaveq 
  800486:	c3                   	retq   
	...

0000000000800488 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800488:	55                   	push   %rbp
  800489:	48 89 e5             	mov    %rsp,%rbp
  80048c:	48 83 ec 30          	sub    $0x30,%rsp
  800490:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800494:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800498:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80049c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80049f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8004a3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004aa:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004ae:	77 52                	ja     800502 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004b0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004b3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004b7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004ba:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8004be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c7:	48 f7 75 d0          	divq   -0x30(%rbp)
  8004cb:	48 89 c2             	mov    %rax,%rdx
  8004ce:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8004d1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8004d4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8004d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004dc:	41 89 f9             	mov    %edi,%r9d
  8004df:	48 89 c7             	mov    %rax,%rdi
  8004e2:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  8004e9:	00 00 00 
  8004ec:	ff d0                	callq  *%rax
  8004ee:	eb 1c                	jmp    80050c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004f7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	89 c7                	mov    %eax,%edi
  800500:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800502:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800506:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80050a:	7f e4                	jg     8004f0 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80050c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80050f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800513:	ba 00 00 00 00       	mov    $0x0,%edx
  800518:	48 f7 f1             	div    %rcx
  80051b:	48 89 d0             	mov    %rdx,%rax
  80051e:	48 ba 48 45 80 00 00 	movabs $0x804548,%rdx
  800525:	00 00 00 
  800528:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80052c:	0f be c0             	movsbl %al,%eax
  80052f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800533:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800537:	48 89 d6             	mov    %rdx,%rsi
  80053a:	89 c7                	mov    %eax,%edi
  80053c:	ff d1                	callq  *%rcx
}
  80053e:	c9                   	leaveq 
  80053f:	c3                   	retq   

0000000000800540 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800540:	55                   	push   %rbp
  800541:	48 89 e5             	mov    %rsp,%rbp
  800544:	48 83 ec 20          	sub    $0x20,%rsp
  800548:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80054f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800553:	7e 52                	jle    8005a7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800559:	8b 00                	mov    (%rax),%eax
  80055b:	83 f8 30             	cmp    $0x30,%eax
  80055e:	73 24                	jae    800584 <getuint+0x44>
  800560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800564:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056c:	8b 00                	mov    (%rax),%eax
  80056e:	89 c0                	mov    %eax,%eax
  800570:	48 01 d0             	add    %rdx,%rax
  800573:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800577:	8b 12                	mov    (%rdx),%edx
  800579:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80057c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800580:	89 0a                	mov    %ecx,(%rdx)
  800582:	eb 17                	jmp    80059b <getuint+0x5b>
  800584:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800588:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80058c:	48 89 d0             	mov    %rdx,%rax
  80058f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800593:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800597:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80059b:	48 8b 00             	mov    (%rax),%rax
  80059e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005a2:	e9 a3 00 00 00       	jmpq   80064a <getuint+0x10a>
	else if (lflag)
  8005a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005ab:	74 4f                	je     8005fc <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b1:	8b 00                	mov    (%rax),%eax
  8005b3:	83 f8 30             	cmp    $0x30,%eax
  8005b6:	73 24                	jae    8005dc <getuint+0x9c>
  8005b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	8b 00                	mov    (%rax),%eax
  8005c6:	89 c0                	mov    %eax,%eax
  8005c8:	48 01 d0             	add    %rdx,%rax
  8005cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cf:	8b 12                	mov    (%rdx),%edx
  8005d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d8:	89 0a                	mov    %ecx,(%rdx)
  8005da:	eb 17                	jmp    8005f3 <getuint+0xb3>
  8005dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e4:	48 89 d0             	mov    %rdx,%rax
  8005e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f3:	48 8b 00             	mov    (%rax),%rax
  8005f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005fa:	eb 4e                	jmp    80064a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	8b 00                	mov    (%rax),%eax
  800602:	83 f8 30             	cmp    $0x30,%eax
  800605:	73 24                	jae    80062b <getuint+0xeb>
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80060f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800613:	8b 00                	mov    (%rax),%eax
  800615:	89 c0                	mov    %eax,%eax
  800617:	48 01 d0             	add    %rdx,%rax
  80061a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061e:	8b 12                	mov    (%rdx),%edx
  800620:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800627:	89 0a                	mov    %ecx,(%rdx)
  800629:	eb 17                	jmp    800642 <getuint+0x102>
  80062b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800633:	48 89 d0             	mov    %rdx,%rax
  800636:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80063a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800642:	8b 00                	mov    (%rax),%eax
  800644:	89 c0                	mov    %eax,%eax
  800646:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80064a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80064e:	c9                   	leaveq 
  80064f:	c3                   	retq   

0000000000800650 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800650:	55                   	push   %rbp
  800651:	48 89 e5             	mov    %rsp,%rbp
  800654:	48 83 ec 20          	sub    $0x20,%rsp
  800658:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80065c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80065f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800663:	7e 52                	jle    8006b7 <getint+0x67>
		x=va_arg(*ap, long long);
  800665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800669:	8b 00                	mov    (%rax),%eax
  80066b:	83 f8 30             	cmp    $0x30,%eax
  80066e:	73 24                	jae    800694 <getint+0x44>
  800670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800674:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	8b 00                	mov    (%rax),%eax
  80067e:	89 c0                	mov    %eax,%eax
  800680:	48 01 d0             	add    %rdx,%rax
  800683:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800687:	8b 12                	mov    (%rdx),%edx
  800689:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80068c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800690:	89 0a                	mov    %ecx,(%rdx)
  800692:	eb 17                	jmp    8006ab <getint+0x5b>
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80069c:	48 89 d0             	mov    %rdx,%rax
  80069f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ab:	48 8b 00             	mov    (%rax),%rax
  8006ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b2:	e9 a3 00 00 00       	jmpq   80075a <getint+0x10a>
	else if (lflag)
  8006b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006bb:	74 4f                	je     80070c <getint+0xbc>
		x=va_arg(*ap, long);
  8006bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c1:	8b 00                	mov    (%rax),%eax
  8006c3:	83 f8 30             	cmp    $0x30,%eax
  8006c6:	73 24                	jae    8006ec <getint+0x9c>
  8006c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	8b 00                	mov    (%rax),%eax
  8006d6:	89 c0                	mov    %eax,%eax
  8006d8:	48 01 d0             	add    %rdx,%rax
  8006db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006df:	8b 12                	mov    (%rdx),%edx
  8006e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e8:	89 0a                	mov    %ecx,(%rdx)
  8006ea:	eb 17                	jmp    800703 <getint+0xb3>
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f4:	48 89 d0             	mov    %rdx,%rax
  8006f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800703:	48 8b 00             	mov    (%rax),%rax
  800706:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80070a:	eb 4e                	jmp    80075a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	8b 00                	mov    (%rax),%eax
  800712:	83 f8 30             	cmp    $0x30,%eax
  800715:	73 24                	jae    80073b <getint+0xeb>
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800723:	8b 00                	mov    (%rax),%eax
  800725:	89 c0                	mov    %eax,%eax
  800727:	48 01 d0             	add    %rdx,%rax
  80072a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072e:	8b 12                	mov    (%rdx),%edx
  800730:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800737:	89 0a                	mov    %ecx,(%rdx)
  800739:	eb 17                	jmp    800752 <getint+0x102>
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800743:	48 89 d0             	mov    %rdx,%rax
  800746:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80074a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800752:	8b 00                	mov    (%rax),%eax
  800754:	48 98                	cltq   
  800756:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80075a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80075e:	c9                   	leaveq 
  80075f:	c3                   	retq   

0000000000800760 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800760:	55                   	push   %rbp
  800761:	48 89 e5             	mov    %rsp,%rbp
  800764:	41 54                	push   %r12
  800766:	53                   	push   %rbx
  800767:	48 83 ec 60          	sub    $0x60,%rsp
  80076b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80076f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800773:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800777:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80077b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80077f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800783:	48 8b 0a             	mov    (%rdx),%rcx
  800786:	48 89 08             	mov    %rcx,(%rax)
  800789:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80078d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800791:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800795:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800799:	eb 17                	jmp    8007b2 <vprintfmt+0x52>
			if (ch == '\0')
  80079b:	85 db                	test   %ebx,%ebx
  80079d:	0f 84 d7 04 00 00    	je     800c7a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8007a3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8007a7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8007ab:	48 89 c6             	mov    %rax,%rsi
  8007ae:	89 df                	mov    %ebx,%edi
  8007b0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007b6:	0f b6 00             	movzbl (%rax),%eax
  8007b9:	0f b6 d8             	movzbl %al,%ebx
  8007bc:	83 fb 25             	cmp    $0x25,%ebx
  8007bf:	0f 95 c0             	setne  %al
  8007c2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007c7:	84 c0                	test   %al,%al
  8007c9:	75 d0                	jne    80079b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007cb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007cf:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007e4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8007eb:	eb 04                	jmp    8007f1 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8007ed:	90                   	nop
  8007ee:	eb 01                	jmp    8007f1 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8007f0:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007f5:	0f b6 00             	movzbl (%rax),%eax
  8007f8:	0f b6 d8             	movzbl %al,%ebx
  8007fb:	89 d8                	mov    %ebx,%eax
  8007fd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800802:	83 e8 23             	sub    $0x23,%eax
  800805:	83 f8 55             	cmp    $0x55,%eax
  800808:	0f 87 38 04 00 00    	ja     800c46 <vprintfmt+0x4e6>
  80080e:	89 c0                	mov    %eax,%eax
  800810:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800817:	00 
  800818:	48 b8 70 45 80 00 00 	movabs $0x804570,%rax
  80081f:	00 00 00 
  800822:	48 01 d0             	add    %rdx,%rax
  800825:	48 8b 00             	mov    (%rax),%rax
  800828:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80082e:	eb c1                	jmp    8007f1 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800830:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800834:	eb bb                	jmp    8007f1 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800836:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80083d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800840:	89 d0                	mov    %edx,%eax
  800842:	c1 e0 02             	shl    $0x2,%eax
  800845:	01 d0                	add    %edx,%eax
  800847:	01 c0                	add    %eax,%eax
  800849:	01 d8                	add    %ebx,%eax
  80084b:	83 e8 30             	sub    $0x30,%eax
  80084e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800851:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800855:	0f b6 00             	movzbl (%rax),%eax
  800858:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085b:	83 fb 2f             	cmp    $0x2f,%ebx
  80085e:	7e 63                	jle    8008c3 <vprintfmt+0x163>
  800860:	83 fb 39             	cmp    $0x39,%ebx
  800863:	7f 5e                	jg     8008c3 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800865:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80086a:	eb d1                	jmp    80083d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80086c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086f:	83 f8 30             	cmp    $0x30,%eax
  800872:	73 17                	jae    80088b <vprintfmt+0x12b>
  800874:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800878:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087b:	89 c0                	mov    %eax,%eax
  80087d:	48 01 d0             	add    %rdx,%rax
  800880:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800883:	83 c2 08             	add    $0x8,%edx
  800886:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800889:	eb 0f                	jmp    80089a <vprintfmt+0x13a>
  80088b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80088f:	48 89 d0             	mov    %rdx,%rax
  800892:	48 83 c2 08          	add    $0x8,%rdx
  800896:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089a:	8b 00                	mov    (%rax),%eax
  80089c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80089f:	eb 23                	jmp    8008c4 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8008a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008a5:	0f 89 42 ff ff ff    	jns    8007ed <vprintfmt+0x8d>
				width = 0;
  8008ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008b2:	e9 36 ff ff ff       	jmpq   8007ed <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8008b7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008be:	e9 2e ff ff ff       	jmpq   8007f1 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008c3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c8:	0f 89 22 ff ff ff    	jns    8007f0 <vprintfmt+0x90>
				width = precision, precision = -1;
  8008ce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008d1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008d4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008db:	e9 10 ff ff ff       	jmpq   8007f0 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008e4:	e9 08 ff ff ff       	jmpq   8007f1 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ec:	83 f8 30             	cmp    $0x30,%eax
  8008ef:	73 17                	jae    800908 <vprintfmt+0x1a8>
  8008f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f8:	89 c0                	mov    %eax,%eax
  8008fa:	48 01 d0             	add    %rdx,%rax
  8008fd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800900:	83 c2 08             	add    $0x8,%edx
  800903:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800906:	eb 0f                	jmp    800917 <vprintfmt+0x1b7>
  800908:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80090c:	48 89 d0             	mov    %rdx,%rax
  80090f:	48 83 c2 08          	add    $0x8,%rdx
  800913:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800917:	8b 00                	mov    (%rax),%eax
  800919:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80091d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800921:	48 89 d6             	mov    %rdx,%rsi
  800924:	89 c7                	mov    %eax,%edi
  800926:	ff d1                	callq  *%rcx
			break;
  800928:	e9 47 03 00 00       	jmpq   800c74 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80092d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800930:	83 f8 30             	cmp    $0x30,%eax
  800933:	73 17                	jae    80094c <vprintfmt+0x1ec>
  800935:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800939:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093c:	89 c0                	mov    %eax,%eax
  80093e:	48 01 d0             	add    %rdx,%rax
  800941:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800944:	83 c2 08             	add    $0x8,%edx
  800947:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80094a:	eb 0f                	jmp    80095b <vprintfmt+0x1fb>
  80094c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800950:	48 89 d0             	mov    %rdx,%rax
  800953:	48 83 c2 08          	add    $0x8,%rdx
  800957:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80095b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80095d:	85 db                	test   %ebx,%ebx
  80095f:	79 02                	jns    800963 <vprintfmt+0x203>
				err = -err;
  800961:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800963:	83 fb 10             	cmp    $0x10,%ebx
  800966:	7f 16                	jg     80097e <vprintfmt+0x21e>
  800968:	48 b8 c0 44 80 00 00 	movabs $0x8044c0,%rax
  80096f:	00 00 00 
  800972:	48 63 d3             	movslq %ebx,%rdx
  800975:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800979:	4d 85 e4             	test   %r12,%r12
  80097c:	75 2e                	jne    8009ac <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80097e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800982:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800986:	89 d9                	mov    %ebx,%ecx
  800988:	48 ba 59 45 80 00 00 	movabs $0x804559,%rdx
  80098f:	00 00 00 
  800992:	48 89 c7             	mov    %rax,%rdi
  800995:	b8 00 00 00 00       	mov    $0x0,%eax
  80099a:	49 b8 84 0c 80 00 00 	movabs $0x800c84,%r8
  8009a1:	00 00 00 
  8009a4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009a7:	e9 c8 02 00 00       	jmpq   800c74 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ac:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b4:	4c 89 e1             	mov    %r12,%rcx
  8009b7:	48 ba 62 45 80 00 00 	movabs $0x804562,%rdx
  8009be:	00 00 00 
  8009c1:	48 89 c7             	mov    %rax,%rdi
  8009c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c9:	49 b8 84 0c 80 00 00 	movabs $0x800c84,%r8
  8009d0:	00 00 00 
  8009d3:	41 ff d0             	callq  *%r8
			break;
  8009d6:	e9 99 02 00 00       	jmpq   800c74 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009de:	83 f8 30             	cmp    $0x30,%eax
  8009e1:	73 17                	jae    8009fa <vprintfmt+0x29a>
  8009e3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ea:	89 c0                	mov    %eax,%eax
  8009ec:	48 01 d0             	add    %rdx,%rax
  8009ef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f2:	83 c2 08             	add    $0x8,%edx
  8009f5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f8:	eb 0f                	jmp    800a09 <vprintfmt+0x2a9>
  8009fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009fe:	48 89 d0             	mov    %rdx,%rax
  800a01:	48 83 c2 08          	add    $0x8,%rdx
  800a05:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a09:	4c 8b 20             	mov    (%rax),%r12
  800a0c:	4d 85 e4             	test   %r12,%r12
  800a0f:	75 0a                	jne    800a1b <vprintfmt+0x2bb>
				p = "(null)";
  800a11:	49 bc 65 45 80 00 00 	movabs $0x804565,%r12
  800a18:	00 00 00 
			if (width > 0 && padc != '-')
  800a1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a1f:	7e 7a                	jle    800a9b <vprintfmt+0x33b>
  800a21:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a25:	74 74                	je     800a9b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a27:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a2a:	48 98                	cltq   
  800a2c:	48 89 c6             	mov    %rax,%rsi
  800a2f:	4c 89 e7             	mov    %r12,%rdi
  800a32:	48 b8 2e 0f 80 00 00 	movabs $0x800f2e,%rax
  800a39:	00 00 00 
  800a3c:	ff d0                	callq  *%rax
  800a3e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a41:	eb 17                	jmp    800a5a <vprintfmt+0x2fa>
					putch(padc, putdat);
  800a43:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800a47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a4f:	48 89 d6             	mov    %rdx,%rsi
  800a52:	89 c7                	mov    %eax,%edi
  800a54:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a56:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5e:	7f e3                	jg     800a43 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a60:	eb 39                	jmp    800a9b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800a62:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a66:	74 1e                	je     800a86 <vprintfmt+0x326>
  800a68:	83 fb 1f             	cmp    $0x1f,%ebx
  800a6b:	7e 05                	jle    800a72 <vprintfmt+0x312>
  800a6d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a70:	7e 14                	jle    800a86 <vprintfmt+0x326>
					putch('?', putdat);
  800a72:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a76:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a7a:	48 89 c6             	mov    %rax,%rsi
  800a7d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a82:	ff d2                	callq  *%rdx
  800a84:	eb 0f                	jmp    800a95 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800a86:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a8a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a8e:	48 89 c6             	mov    %rax,%rsi
  800a91:	89 df                	mov    %ebx,%edi
  800a93:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a95:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a99:	eb 01                	jmp    800a9c <vprintfmt+0x33c>
  800a9b:	90                   	nop
  800a9c:	41 0f b6 04 24       	movzbl (%r12),%eax
  800aa1:	0f be d8             	movsbl %al,%ebx
  800aa4:	85 db                	test   %ebx,%ebx
  800aa6:	0f 95 c0             	setne  %al
  800aa9:	49 83 c4 01          	add    $0x1,%r12
  800aad:	84 c0                	test   %al,%al
  800aaf:	74 28                	je     800ad9 <vprintfmt+0x379>
  800ab1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ab5:	78 ab                	js     800a62 <vprintfmt+0x302>
  800ab7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800abb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800abf:	79 a1                	jns    800a62 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac1:	eb 16                	jmp    800ad9 <vprintfmt+0x379>
				putch(' ', putdat);
  800ac3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ac7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800acb:	48 89 c6             	mov    %rax,%rsi
  800ace:	bf 20 00 00 00       	mov    $0x20,%edi
  800ad3:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ad9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800add:	7f e4                	jg     800ac3 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800adf:	e9 90 01 00 00       	jmpq   800c74 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ae4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae8:	be 03 00 00 00       	mov    $0x3,%esi
  800aed:	48 89 c7             	mov    %rax,%rdi
  800af0:	48 b8 50 06 80 00 00 	movabs $0x800650,%rax
  800af7:	00 00 00 
  800afa:	ff d0                	callq  *%rax
  800afc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b04:	48 85 c0             	test   %rax,%rax
  800b07:	79 1d                	jns    800b26 <vprintfmt+0x3c6>
				putch('-', putdat);
  800b09:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b0d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b11:	48 89 c6             	mov    %rax,%rsi
  800b14:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b19:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1f:	48 f7 d8             	neg    %rax
  800b22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b26:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b2d:	e9 d5 00 00 00       	jmpq   800c07 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b36:	be 03 00 00 00       	mov    $0x3,%esi
  800b3b:	48 89 c7             	mov    %rax,%rdi
  800b3e:	48 b8 40 05 80 00 00 	movabs $0x800540,%rax
  800b45:	00 00 00 
  800b48:	ff d0                	callq  *%rax
  800b4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b4e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b55:	e9 ad 00 00 00       	jmpq   800c07 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800b5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b5e:	be 03 00 00 00       	mov    $0x3,%esi
  800b63:	48 89 c7             	mov    %rax,%rdi
  800b66:	48 b8 40 05 80 00 00 	movabs $0x800540,%rax
  800b6d:	00 00 00 
  800b70:	ff d0                	callq  *%rax
  800b72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800b76:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b7d:	e9 85 00 00 00       	jmpq   800c07 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800b82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b8a:	48 89 c6             	mov    %rax,%rsi
  800b8d:	bf 30 00 00 00       	mov    $0x30,%edi
  800b92:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800b94:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b98:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b9c:	48 89 c6             	mov    %rax,%rsi
  800b9f:	bf 78 00 00 00       	mov    $0x78,%edi
  800ba4:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ba6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba9:	83 f8 30             	cmp    $0x30,%eax
  800bac:	73 17                	jae    800bc5 <vprintfmt+0x465>
  800bae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb5:	89 c0                	mov    %eax,%eax
  800bb7:	48 01 d0             	add    %rdx,%rax
  800bba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bbd:	83 c2 08             	add    $0x8,%edx
  800bc0:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc3:	eb 0f                	jmp    800bd4 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800bc5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc9:	48 89 d0             	mov    %rdx,%rax
  800bcc:	48 83 c2 08          	add    $0x8,%rdx
  800bd0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bd4:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bdb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800be2:	eb 23                	jmp    800c07 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800be4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be8:	be 03 00 00 00       	mov    $0x3,%esi
  800bed:	48 89 c7             	mov    %rax,%rdi
  800bf0:	48 b8 40 05 80 00 00 	movabs $0x800540,%rax
  800bf7:	00 00 00 
  800bfa:	ff d0                	callq  *%rax
  800bfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c00:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c07:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c0c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c0f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c16:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1e:	45 89 c1             	mov    %r8d,%r9d
  800c21:	41 89 f8             	mov    %edi,%r8d
  800c24:	48 89 c7             	mov    %rax,%rdi
  800c27:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  800c2e:	00 00 00 
  800c31:	ff d0                	callq  *%rax
			break;
  800c33:	eb 3f                	jmp    800c74 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c35:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c39:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c3d:	48 89 c6             	mov    %rax,%rsi
  800c40:	89 df                	mov    %ebx,%edi
  800c42:	ff d2                	callq  *%rdx
			break;
  800c44:	eb 2e                	jmp    800c74 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c46:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c4a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c4e:	48 89 c6             	mov    %rax,%rsi
  800c51:	bf 25 00 00 00       	mov    $0x25,%edi
  800c56:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c58:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c5d:	eb 05                	jmp    800c64 <vprintfmt+0x504>
  800c5f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c64:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c68:	48 83 e8 01          	sub    $0x1,%rax
  800c6c:	0f b6 00             	movzbl (%rax),%eax
  800c6f:	3c 25                	cmp    $0x25,%al
  800c71:	75 ec                	jne    800c5f <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800c73:	90                   	nop
		}
	}
  800c74:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c75:	e9 38 fb ff ff       	jmpq   8007b2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800c7a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800c7b:	48 83 c4 60          	add    $0x60,%rsp
  800c7f:	5b                   	pop    %rbx
  800c80:	41 5c                	pop    %r12
  800c82:	5d                   	pop    %rbp
  800c83:	c3                   	retq   

0000000000800c84 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c84:	55                   	push   %rbp
  800c85:	48 89 e5             	mov    %rsp,%rbp
  800c88:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c8f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c96:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c9d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ca4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cb2:	84 c0                	test   %al,%al
  800cb4:	74 20                	je     800cd6 <printfmt+0x52>
  800cb6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cbe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cc2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cc6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cd2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cd6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cdd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ce4:	00 00 00 
  800ce7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cee:	00 00 00 
  800cf1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cf5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cfc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d03:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d11:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d18:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d1f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d26:	48 89 c7             	mov    %rax,%rdi
  800d29:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  800d30:	00 00 00 
  800d33:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d35:	c9                   	leaveq 
  800d36:	c3                   	retq   

0000000000800d37 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d37:	55                   	push   %rbp
  800d38:	48 89 e5             	mov    %rsp,%rbp
  800d3b:	48 83 ec 10          	sub    $0x10,%rsp
  800d3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d4a:	8b 40 10             	mov    0x10(%rax),%eax
  800d4d:	8d 50 01             	lea    0x1(%rax),%edx
  800d50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d54:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5b:	48 8b 10             	mov    (%rax),%rdx
  800d5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d62:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d66:	48 39 c2             	cmp    %rax,%rdx
  800d69:	73 17                	jae    800d82 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6f:	48 8b 00             	mov    (%rax),%rax
  800d72:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d75:	88 10                	mov    %dl,(%rax)
  800d77:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7f:	48 89 10             	mov    %rdx,(%rax)
}
  800d82:	c9                   	leaveq 
  800d83:	c3                   	retq   

0000000000800d84 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d84:	55                   	push   %rbp
  800d85:	48 89 e5             	mov    %rsp,%rbp
  800d88:	48 83 ec 50          	sub    $0x50,%rsp
  800d8c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d90:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d93:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d97:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d9b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d9f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800da3:	48 8b 0a             	mov    (%rdx),%rcx
  800da6:	48 89 08             	mov    %rcx,(%rax)
  800da9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800db5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dbd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dc1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dc4:	48 98                	cltq   
  800dc6:	48 83 e8 01          	sub    $0x1,%rax
  800dca:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800dce:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800dd2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dd9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dde:	74 06                	je     800de6 <vsnprintf+0x62>
  800de0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800de4:	7f 07                	jg     800ded <vsnprintf+0x69>
		return -E_INVAL;
  800de6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800deb:	eb 2f                	jmp    800e1c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ded:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800df1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800df5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800df9:	48 89 c6             	mov    %rax,%rsi
  800dfc:	48 bf 37 0d 80 00 00 	movabs $0x800d37,%rdi
  800e03:	00 00 00 
  800e06:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  800e0d:	00 00 00 
  800e10:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e16:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e19:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e1c:	c9                   	leaveq 
  800e1d:	c3                   	retq   

0000000000800e1e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e1e:	55                   	push   %rbp
  800e1f:	48 89 e5             	mov    %rsp,%rbp
  800e22:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e29:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e30:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e36:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e3d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e44:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e4b:	84 c0                	test   %al,%al
  800e4d:	74 20                	je     800e6f <snprintf+0x51>
  800e4f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e53:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e57:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e5b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e5f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e63:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e67:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e6b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e6f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e76:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e7d:	00 00 00 
  800e80:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e87:	00 00 00 
  800e8a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e8e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e95:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e9c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ea3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800eaa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800eb1:	48 8b 0a             	mov    (%rdx),%rcx
  800eb4:	48 89 08             	mov    %rcx,(%rax)
  800eb7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ebb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ebf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ec3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ec7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ece:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ed5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800edb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ee2:	48 89 c7             	mov    %rax,%rdi
  800ee5:	48 b8 84 0d 80 00 00 	movabs $0x800d84,%rax
  800eec:	00 00 00 
  800eef:	ff d0                	callq  *%rax
  800ef1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ef7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800efd:	c9                   	leaveq 
  800efe:	c3                   	retq   
	...

0000000000800f00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f00:	55                   	push   %rbp
  800f01:	48 89 e5             	mov    %rsp,%rbp
  800f04:	48 83 ec 18          	sub    $0x18,%rsp
  800f08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f13:	eb 09                	jmp    800f1e <strlen+0x1e>
		n++;
  800f15:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f19:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f22:	0f b6 00             	movzbl (%rax),%eax
  800f25:	84 c0                	test   %al,%al
  800f27:	75 ec                	jne    800f15 <strlen+0x15>
		n++;
	return n;
  800f29:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f2c:	c9                   	leaveq 
  800f2d:	c3                   	retq   

0000000000800f2e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f2e:	55                   	push   %rbp
  800f2f:	48 89 e5             	mov    %rsp,%rbp
  800f32:	48 83 ec 20          	sub    $0x20,%rsp
  800f36:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f3a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f45:	eb 0e                	jmp    800f55 <strnlen+0x27>
		n++;
  800f47:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f4b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f50:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f55:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f5a:	74 0b                	je     800f67 <strnlen+0x39>
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f60:	0f b6 00             	movzbl (%rax),%eax
  800f63:	84 c0                	test   %al,%al
  800f65:	75 e0                	jne    800f47 <strnlen+0x19>
		n++;
	return n;
  800f67:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f6a:	c9                   	leaveq 
  800f6b:	c3                   	retq   

0000000000800f6c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f6c:	55                   	push   %rbp
  800f6d:	48 89 e5             	mov    %rsp,%rbp
  800f70:	48 83 ec 20          	sub    $0x20,%rsp
  800f74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f84:	90                   	nop
  800f85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f89:	0f b6 10             	movzbl (%rax),%edx
  800f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f90:	88 10                	mov    %dl,(%rax)
  800f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f96:	0f b6 00             	movzbl (%rax),%eax
  800f99:	84 c0                	test   %al,%al
  800f9b:	0f 95 c0             	setne  %al
  800f9e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fa3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 d9                	jne    800f85 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fb0:	c9                   	leaveq 
  800fb1:	c3                   	retq   

0000000000800fb2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fb2:	55                   	push   %rbp
  800fb3:	48 89 e5             	mov    %rsp,%rbp
  800fb6:	48 83 ec 20          	sub    $0x20,%rsp
  800fba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fbe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc6:	48 89 c7             	mov    %rax,%rdi
  800fc9:	48 b8 00 0f 80 00 00 	movabs $0x800f00,%rax
  800fd0:	00 00 00 
  800fd3:	ff d0                	callq  *%rax
  800fd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fdb:	48 98                	cltq   
  800fdd:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800fe1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fe5:	48 89 d6             	mov    %rdx,%rsi
  800fe8:	48 89 c7             	mov    %rax,%rdi
  800feb:	48 b8 6c 0f 80 00 00 	movabs $0x800f6c,%rax
  800ff2:	00 00 00 
  800ff5:	ff d0                	callq  *%rax
	return dst;
  800ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ffb:	c9                   	leaveq 
  800ffc:	c3                   	retq   

0000000000800ffd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ffd:	55                   	push   %rbp
  800ffe:	48 89 e5             	mov    %rsp,%rbp
  801001:	48 83 ec 28          	sub    $0x28,%rsp
  801005:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801009:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80100d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801015:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801019:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801020:	00 
  801021:	eb 27                	jmp    80104a <strncpy+0x4d>
		*dst++ = *src;
  801023:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801027:	0f b6 10             	movzbl (%rax),%edx
  80102a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102e:	88 10                	mov    %dl,(%rax)
  801030:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801035:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801039:	0f b6 00             	movzbl (%rax),%eax
  80103c:	84 c0                	test   %al,%al
  80103e:	74 05                	je     801045 <strncpy+0x48>
			src++;
  801040:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801045:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80104a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801052:	72 cf                	jb     801023 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801054:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801058:	c9                   	leaveq 
  801059:	c3                   	retq   

000000000080105a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80105a:	55                   	push   %rbp
  80105b:	48 89 e5             	mov    %rsp,%rbp
  80105e:	48 83 ec 28          	sub    $0x28,%rsp
  801062:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801066:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80106a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80106e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801072:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801076:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80107b:	74 37                	je     8010b4 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80107d:	eb 17                	jmp    801096 <strlcpy+0x3c>
			*dst++ = *src++;
  80107f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801083:	0f b6 10             	movzbl (%rax),%edx
  801086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108a:	88 10                	mov    %dl,(%rax)
  80108c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801091:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801096:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80109b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010a0:	74 0b                	je     8010ad <strlcpy+0x53>
  8010a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010a6:	0f b6 00             	movzbl (%rax),%eax
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 d2                	jne    80107f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bc:	48 89 d1             	mov    %rdx,%rcx
  8010bf:	48 29 c1             	sub    %rax,%rcx
  8010c2:	48 89 c8             	mov    %rcx,%rax
}
  8010c5:	c9                   	leaveq 
  8010c6:	c3                   	retq   

00000000008010c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010c7:	55                   	push   %rbp
  8010c8:	48 89 e5             	mov    %rsp,%rbp
  8010cb:	48 83 ec 10          	sub    $0x10,%rsp
  8010cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010d7:	eb 0a                	jmp    8010e3 <strcmp+0x1c>
		p++, q++;
  8010d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e7:	0f b6 00             	movzbl (%rax),%eax
  8010ea:	84 c0                	test   %al,%al
  8010ec:	74 12                	je     801100 <strcmp+0x39>
  8010ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f2:	0f b6 10             	movzbl (%rax),%edx
  8010f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f9:	0f b6 00             	movzbl (%rax),%eax
  8010fc:	38 c2                	cmp    %al,%dl
  8010fe:	74 d9                	je     8010d9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801100:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801104:	0f b6 00             	movzbl (%rax),%eax
  801107:	0f b6 d0             	movzbl %al,%edx
  80110a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110e:	0f b6 00             	movzbl (%rax),%eax
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	89 d1                	mov    %edx,%ecx
  801116:	29 c1                	sub    %eax,%ecx
  801118:	89 c8                	mov    %ecx,%eax
}
  80111a:	c9                   	leaveq 
  80111b:	c3                   	retq   

000000000080111c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80111c:	55                   	push   %rbp
  80111d:	48 89 e5             	mov    %rsp,%rbp
  801120:	48 83 ec 18          	sub    $0x18,%rsp
  801124:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801128:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80112c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801130:	eb 0f                	jmp    801141 <strncmp+0x25>
		n--, p++, q++;
  801132:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801137:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80113c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801141:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801146:	74 1d                	je     801165 <strncmp+0x49>
  801148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114c:	0f b6 00             	movzbl (%rax),%eax
  80114f:	84 c0                	test   %al,%al
  801151:	74 12                	je     801165 <strncmp+0x49>
  801153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801157:	0f b6 10             	movzbl (%rax),%edx
  80115a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115e:	0f b6 00             	movzbl (%rax),%eax
  801161:	38 c2                	cmp    %al,%dl
  801163:	74 cd                	je     801132 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801165:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80116a:	75 07                	jne    801173 <strncmp+0x57>
		return 0;
  80116c:	b8 00 00 00 00       	mov    $0x0,%eax
  801171:	eb 1a                	jmp    80118d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801173:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801177:	0f b6 00             	movzbl (%rax),%eax
  80117a:	0f b6 d0             	movzbl %al,%edx
  80117d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801181:	0f b6 00             	movzbl (%rax),%eax
  801184:	0f b6 c0             	movzbl %al,%eax
  801187:	89 d1                	mov    %edx,%ecx
  801189:	29 c1                	sub    %eax,%ecx
  80118b:	89 c8                	mov    %ecx,%eax
}
  80118d:	c9                   	leaveq 
  80118e:	c3                   	retq   

000000000080118f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80118f:	55                   	push   %rbp
  801190:	48 89 e5             	mov    %rsp,%rbp
  801193:	48 83 ec 10          	sub    $0x10,%rsp
  801197:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80119b:	89 f0                	mov    %esi,%eax
  80119d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011a0:	eb 17                	jmp    8011b9 <strchr+0x2a>
		if (*s == c)
  8011a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a6:	0f b6 00             	movzbl (%rax),%eax
  8011a9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011ac:	75 06                	jne    8011b4 <strchr+0x25>
			return (char *) s;
  8011ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b2:	eb 15                	jmp    8011c9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bd:	0f b6 00             	movzbl (%rax),%eax
  8011c0:	84 c0                	test   %al,%al
  8011c2:	75 de                	jne    8011a2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c9:	c9                   	leaveq 
  8011ca:	c3                   	retq   

00000000008011cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011cb:	55                   	push   %rbp
  8011cc:	48 89 e5             	mov    %rsp,%rbp
  8011cf:	48 83 ec 10          	sub    $0x10,%rsp
  8011d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d7:	89 f0                	mov    %esi,%eax
  8011d9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011dc:	eb 11                	jmp    8011ef <strfind+0x24>
		if (*s == c)
  8011de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e2:	0f b6 00             	movzbl (%rax),%eax
  8011e5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011e8:	74 12                	je     8011fc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f3:	0f b6 00             	movzbl (%rax),%eax
  8011f6:	84 c0                	test   %al,%al
  8011f8:	75 e4                	jne    8011de <strfind+0x13>
  8011fa:	eb 01                	jmp    8011fd <strfind+0x32>
		if (*s == c)
			break;
  8011fc:	90                   	nop
	return (char *) s;
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801201:	c9                   	leaveq 
  801202:	c3                   	retq   

0000000000801203 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801203:	55                   	push   %rbp
  801204:	48 89 e5             	mov    %rsp,%rbp
  801207:	48 83 ec 18          	sub    $0x18,%rsp
  80120b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80120f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801212:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801216:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80121b:	75 06                	jne    801223 <memset+0x20>
		return v;
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801221:	eb 69                	jmp    80128c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801227:	83 e0 03             	and    $0x3,%eax
  80122a:	48 85 c0             	test   %rax,%rax
  80122d:	75 48                	jne    801277 <memset+0x74>
  80122f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801233:	83 e0 03             	and    $0x3,%eax
  801236:	48 85 c0             	test   %rax,%rax
  801239:	75 3c                	jne    801277 <memset+0x74>
		c &= 0xFF;
  80123b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801242:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801245:	89 c2                	mov    %eax,%edx
  801247:	c1 e2 18             	shl    $0x18,%edx
  80124a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80124d:	c1 e0 10             	shl    $0x10,%eax
  801250:	09 c2                	or     %eax,%edx
  801252:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801255:	c1 e0 08             	shl    $0x8,%eax
  801258:	09 d0                	or     %edx,%eax
  80125a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801261:	48 89 c1             	mov    %rax,%rcx
  801264:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801268:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80126c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126f:	48 89 d7             	mov    %rdx,%rdi
  801272:	fc                   	cld    
  801273:	f3 ab                	rep stos %eax,%es:(%rdi)
  801275:	eb 11                	jmp    801288 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801277:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80127b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80127e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801282:	48 89 d7             	mov    %rdx,%rdi
  801285:	fc                   	cld    
  801286:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801288:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80128c:	c9                   	leaveq 
  80128d:	c3                   	retq   

000000000080128e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80128e:	55                   	push   %rbp
  80128f:	48 89 e5             	mov    %rsp,%rbp
  801292:	48 83 ec 28          	sub    $0x28,%rsp
  801296:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80129a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80129e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012ba:	0f 83 88 00 00 00    	jae    801348 <memmove+0xba>
  8012c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012c8:	48 01 d0             	add    %rdx,%rax
  8012cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012cf:	76 77                	jbe    801348 <memmove+0xba>
		s += n;
  8012d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012dd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e5:	83 e0 03             	and    $0x3,%eax
  8012e8:	48 85 c0             	test   %rax,%rax
  8012eb:	75 3b                	jne    801328 <memmove+0x9a>
  8012ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f1:	83 e0 03             	and    $0x3,%eax
  8012f4:	48 85 c0             	test   %rax,%rax
  8012f7:	75 2f                	jne    801328 <memmove+0x9a>
  8012f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fd:	83 e0 03             	and    $0x3,%eax
  801300:	48 85 c0             	test   %rax,%rax
  801303:	75 23                	jne    801328 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801309:	48 83 e8 04          	sub    $0x4,%rax
  80130d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801311:	48 83 ea 04          	sub    $0x4,%rdx
  801315:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801319:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80131d:	48 89 c7             	mov    %rax,%rdi
  801320:	48 89 d6             	mov    %rdx,%rsi
  801323:	fd                   	std    
  801324:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801326:	eb 1d                	jmp    801345 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801328:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801334:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801338:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133c:	48 89 d7             	mov    %rdx,%rdi
  80133f:	48 89 c1             	mov    %rax,%rcx
  801342:	fd                   	std    
  801343:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801345:	fc                   	cld    
  801346:	eb 57                	jmp    80139f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	83 e0 03             	and    $0x3,%eax
  80134f:	48 85 c0             	test   %rax,%rax
  801352:	75 36                	jne    80138a <memmove+0xfc>
  801354:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801358:	83 e0 03             	and    $0x3,%eax
  80135b:	48 85 c0             	test   %rax,%rax
  80135e:	75 2a                	jne    80138a <memmove+0xfc>
  801360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801364:	83 e0 03             	and    $0x3,%eax
  801367:	48 85 c0             	test   %rax,%rax
  80136a:	75 1e                	jne    80138a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80136c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801370:	48 89 c1             	mov    %rax,%rcx
  801373:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137f:	48 89 c7             	mov    %rax,%rdi
  801382:	48 89 d6             	mov    %rdx,%rsi
  801385:	fc                   	cld    
  801386:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801388:	eb 15                	jmp    80139f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80138a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801392:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801396:	48 89 c7             	mov    %rax,%rdi
  801399:	48 89 d6             	mov    %rdx,%rsi
  80139c:	fc                   	cld    
  80139d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80139f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013a3:	c9                   	leaveq 
  8013a4:	c3                   	retq   

00000000008013a5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013a5:	55                   	push   %rbp
  8013a6:	48 89 e5             	mov    %rsp,%rbp
  8013a9:	48 83 ec 18          	sub    $0x18,%rsp
  8013ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c5:	48 89 ce             	mov    %rcx,%rsi
  8013c8:	48 89 c7             	mov    %rax,%rdi
  8013cb:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  8013d2:	00 00 00 
  8013d5:	ff d0                	callq  *%rax
}
  8013d7:	c9                   	leaveq 
  8013d8:	c3                   	retq   

00000000008013d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013d9:	55                   	push   %rbp
  8013da:	48 89 e5             	mov    %rsp,%rbp
  8013dd:	48 83 ec 28          	sub    $0x28,%rsp
  8013e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013fd:	eb 38                	jmp    801437 <memcmp+0x5e>
		if (*s1 != *s2)
  8013ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801403:	0f b6 10             	movzbl (%rax),%edx
  801406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	38 c2                	cmp    %al,%dl
  80140f:	74 1c                	je     80142d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801415:	0f b6 00             	movzbl (%rax),%eax
  801418:	0f b6 d0             	movzbl %al,%edx
  80141b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	0f b6 c0             	movzbl %al,%eax
  801425:	89 d1                	mov    %edx,%ecx
  801427:	29 c1                	sub    %eax,%ecx
  801429:	89 c8                	mov    %ecx,%eax
  80142b:	eb 20                	jmp    80144d <memcmp+0x74>
		s1++, s2++;
  80142d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801432:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801437:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80143c:	0f 95 c0             	setne  %al
  80143f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801444:	84 c0                	test   %al,%al
  801446:	75 b7                	jne    8013ff <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144d:	c9                   	leaveq 
  80144e:	c3                   	retq   

000000000080144f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80144f:	55                   	push   %rbp
  801450:	48 89 e5             	mov    %rsp,%rbp
  801453:	48 83 ec 28          	sub    $0x28,%rsp
  801457:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80145b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80145e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801466:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80146a:	48 01 d0             	add    %rdx,%rax
  80146d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801471:	eb 13                	jmp    801486 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801477:	0f b6 10             	movzbl (%rax),%edx
  80147a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80147d:	38 c2                	cmp    %al,%dl
  80147f:	74 11                	je     801492 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801481:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80148e:	72 e3                	jb     801473 <memfind+0x24>
  801490:	eb 01                	jmp    801493 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801492:	90                   	nop
	return (void *) s;
  801493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801497:	c9                   	leaveq 
  801498:	c3                   	retq   

0000000000801499 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801499:	55                   	push   %rbp
  80149a:	48 89 e5             	mov    %rsp,%rbp
  80149d:	48 83 ec 38          	sub    $0x38,%rsp
  8014a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014a9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014b3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014ba:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014bb:	eb 05                	jmp    8014c2 <strtol+0x29>
		s++;
  8014bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3c 20                	cmp    $0x20,%al
  8014cb:	74 f0                	je     8014bd <strtol+0x24>
  8014cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	3c 09                	cmp    $0x9,%al
  8014d6:	74 e5                	je     8014bd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	3c 2b                	cmp    $0x2b,%al
  8014e1:	75 07                	jne    8014ea <strtol+0x51>
		s++;
  8014e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014e8:	eb 17                	jmp    801501 <strtol+0x68>
	else if (*s == '-')
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	3c 2d                	cmp    $0x2d,%al
  8014f3:	75 0c                	jne    801501 <strtol+0x68>
		s++, neg = 1;
  8014f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801501:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801505:	74 06                	je     80150d <strtol+0x74>
  801507:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80150b:	75 28                	jne    801535 <strtol+0x9c>
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	3c 30                	cmp    $0x30,%al
  801516:	75 1d                	jne    801535 <strtol+0x9c>
  801518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151c:	48 83 c0 01          	add    $0x1,%rax
  801520:	0f b6 00             	movzbl (%rax),%eax
  801523:	3c 78                	cmp    $0x78,%al
  801525:	75 0e                	jne    801535 <strtol+0x9c>
		s += 2, base = 16;
  801527:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80152c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801533:	eb 2c                	jmp    801561 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801535:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801539:	75 19                	jne    801554 <strtol+0xbb>
  80153b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153f:	0f b6 00             	movzbl (%rax),%eax
  801542:	3c 30                	cmp    $0x30,%al
  801544:	75 0e                	jne    801554 <strtol+0xbb>
		s++, base = 8;
  801546:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80154b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801552:	eb 0d                	jmp    801561 <strtol+0xc8>
	else if (base == 0)
  801554:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801558:	75 07                	jne    801561 <strtol+0xc8>
		base = 10;
  80155a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	3c 2f                	cmp    $0x2f,%al
  80156a:	7e 1d                	jle    801589 <strtol+0xf0>
  80156c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801570:	0f b6 00             	movzbl (%rax),%eax
  801573:	3c 39                	cmp    $0x39,%al
  801575:	7f 12                	jg     801589 <strtol+0xf0>
			dig = *s - '0';
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	0f be c0             	movsbl %al,%eax
  801581:	83 e8 30             	sub    $0x30,%eax
  801584:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801587:	eb 4e                	jmp    8015d7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	3c 60                	cmp    $0x60,%al
  801592:	7e 1d                	jle    8015b1 <strtol+0x118>
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	3c 7a                	cmp    $0x7a,%al
  80159d:	7f 12                	jg     8015b1 <strtol+0x118>
			dig = *s - 'a' + 10;
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	0f be c0             	movsbl %al,%eax
  8015a9:	83 e8 57             	sub    $0x57,%eax
  8015ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015af:	eb 26                	jmp    8015d7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3c 40                	cmp    $0x40,%al
  8015ba:	7e 47                	jle    801603 <strtol+0x16a>
  8015bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	3c 5a                	cmp    $0x5a,%al
  8015c5:	7f 3c                	jg     801603 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	0f be c0             	movsbl %al,%eax
  8015d1:	83 e8 37             	sub    $0x37,%eax
  8015d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015da:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015dd:	7d 23                	jge    801602 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8015df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015e7:	48 98                	cltq   
  8015e9:	48 89 c2             	mov    %rax,%rdx
  8015ec:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8015f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f4:	48 98                	cltq   
  8015f6:	48 01 d0             	add    %rdx,%rax
  8015f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015fd:	e9 5f ff ff ff       	jmpq   801561 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801602:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801603:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801608:	74 0b                	je     801615 <strtol+0x17c>
		*endptr = (char *) s;
  80160a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80160e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801612:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801615:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801619:	74 09                	je     801624 <strtol+0x18b>
  80161b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161f:	48 f7 d8             	neg    %rax
  801622:	eb 04                	jmp    801628 <strtol+0x18f>
  801624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801628:	c9                   	leaveq 
  801629:	c3                   	retq   

000000000080162a <strstr>:

char * strstr(const char *in, const char *str)
{
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	48 83 ec 30          	sub    $0x30,%rsp
  801632:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801636:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80163a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	88 45 ff             	mov    %al,-0x1(%rbp)
  801644:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801649:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80164d:	75 06                	jne    801655 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80164f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801653:	eb 68                	jmp    8016bd <strstr+0x93>

    len = strlen(str);
  801655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801659:	48 89 c7             	mov    %rax,%rdi
  80165c:	48 b8 00 0f 80 00 00 	movabs $0x800f00,%rax
  801663:	00 00 00 
  801666:	ff d0                	callq  *%rax
  801668:	48 98                	cltq   
  80166a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	88 45 ef             	mov    %al,-0x11(%rbp)
  801678:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80167d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801681:	75 07                	jne    80168a <strstr+0x60>
                return (char *) 0;
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	eb 33                	jmp    8016bd <strstr+0x93>
        } while (sc != c);
  80168a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80168e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801691:	75 db                	jne    80166e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801693:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801697:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80169b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169f:	48 89 ce             	mov    %rcx,%rsi
  8016a2:	48 89 c7             	mov    %rax,%rdi
  8016a5:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  8016ac:	00 00 00 
  8016af:	ff d0                	callq  *%rax
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	75 b9                	jne    80166e <strstr+0x44>

    return (char *) (in - 1);
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	48 83 e8 01          	sub    $0x1,%rax
}
  8016bd:	c9                   	leaveq 
  8016be:	c3                   	retq   
	...

00000000008016c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016c0:	55                   	push   %rbp
  8016c1:	48 89 e5             	mov    %rsp,%rbp
  8016c4:	53                   	push   %rbx
  8016c5:	48 83 ec 58          	sub    $0x58,%rsp
  8016c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016cc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016cf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016d3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016d7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016db:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016e2:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8016e5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016e9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016ed:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016f1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016f5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8016fc:	4c 89 c3             	mov    %r8,%rbx
  8016ff:	cd 30                	int    $0x30
  801701:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801705:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801709:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80170d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801711:	74 3e                	je     801751 <syscall+0x91>
  801713:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801718:	7e 37                	jle    801751 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80171a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80171e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801721:	49 89 d0             	mov    %rdx,%r8
  801724:	89 c1                	mov    %eax,%ecx
  801726:	48 ba 20 48 80 00 00 	movabs $0x804820,%rdx
  80172d:	00 00 00 
  801730:	be 23 00 00 00       	mov    $0x23,%esi
  801735:	48 bf 3d 48 80 00 00 	movabs $0x80483d,%rdi
  80173c:	00 00 00 
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	49 b9 5c 3f 80 00 00 	movabs $0x803f5c,%r9
  80174b:	00 00 00 
  80174e:	41 ff d1             	callq  *%r9

	return ret;
  801751:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801755:	48 83 c4 58          	add    $0x58,%rsp
  801759:	5b                   	pop    %rbx
  80175a:	5d                   	pop    %rbp
  80175b:	c3                   	retq   

000000000080175c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	48 83 ec 20          	sub    $0x20,%rsp
  801764:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801768:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80176c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801770:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801774:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80177b:	00 
  80177c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801782:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801788:	48 89 d1             	mov    %rdx,%rcx
  80178b:	48 89 c2             	mov    %rax,%rdx
  80178e:	be 00 00 00 00       	mov    $0x0,%esi
  801793:	bf 00 00 00 00       	mov    $0x0,%edi
  801798:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  80179f:	00 00 00 
  8017a2:	ff d0                	callq  *%rax
}
  8017a4:	c9                   	leaveq 
  8017a5:	c3                   	retq   

00000000008017a6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017a6:	55                   	push   %rbp
  8017a7:	48 89 e5             	mov    %rsp,%rbp
  8017aa:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017b5:	00 
  8017b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cc:	be 00 00 00 00       	mov    $0x0,%esi
  8017d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8017d6:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  8017dd:	00 00 00 
  8017e0:	ff d0                	callq  *%rax
}
  8017e2:	c9                   	leaveq 
  8017e3:	c3                   	retq   

00000000008017e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017e4:	55                   	push   %rbp
  8017e5:	48 89 e5             	mov    %rsp,%rbp
  8017e8:	48 83 ec 20          	sub    $0x20,%rsp
  8017ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f2:	48 98                	cltq   
  8017f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017fb:	00 
  8017fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801802:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801808:	b9 00 00 00 00       	mov    $0x0,%ecx
  80180d:	48 89 c2             	mov    %rax,%rdx
  801810:	be 01 00 00 00       	mov    $0x1,%esi
  801815:	bf 03 00 00 00       	mov    $0x3,%edi
  80181a:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801821:	00 00 00 
  801824:	ff d0                	callq  *%rax
}
  801826:	c9                   	leaveq 
  801827:	c3                   	retq   

0000000000801828 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801828:	55                   	push   %rbp
  801829:	48 89 e5             	mov    %rsp,%rbp
  80182c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801830:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801837:	00 
  801838:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801844:	b9 00 00 00 00       	mov    $0x0,%ecx
  801849:	ba 00 00 00 00       	mov    $0x0,%edx
  80184e:	be 00 00 00 00       	mov    $0x0,%esi
  801853:	bf 02 00 00 00       	mov    $0x2,%edi
  801858:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  80185f:	00 00 00 
  801862:	ff d0                	callq  *%rax
}
  801864:	c9                   	leaveq 
  801865:	c3                   	retq   

0000000000801866 <sys_yield>:

void
sys_yield(void)
{
  801866:	55                   	push   %rbp
  801867:	48 89 e5             	mov    %rsp,%rbp
  80186a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80186e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801875:	00 
  801876:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801882:	b9 00 00 00 00       	mov    $0x0,%ecx
  801887:	ba 00 00 00 00       	mov    $0x0,%edx
  80188c:	be 00 00 00 00       	mov    $0x0,%esi
  801891:	bf 0b 00 00 00       	mov    $0xb,%edi
  801896:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  80189d:	00 00 00 
  8018a0:	ff d0                	callq  *%rax
}
  8018a2:	c9                   	leaveq 
  8018a3:	c3                   	retq   

00000000008018a4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018a4:	55                   	push   %rbp
  8018a5:	48 89 e5             	mov    %rsp,%rbp
  8018a8:	48 83 ec 20          	sub    $0x20,%rsp
  8018ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018b3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018b9:	48 63 c8             	movslq %eax,%rcx
  8018bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c3:	48 98                	cltq   
  8018c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018cc:	00 
  8018cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d3:	49 89 c8             	mov    %rcx,%r8
  8018d6:	48 89 d1             	mov    %rdx,%rcx
  8018d9:	48 89 c2             	mov    %rax,%rdx
  8018dc:	be 01 00 00 00       	mov    $0x1,%esi
  8018e1:	bf 04 00 00 00       	mov    $0x4,%edi
  8018e6:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  8018ed:	00 00 00 
  8018f0:	ff d0                	callq  *%rax
}
  8018f2:	c9                   	leaveq 
  8018f3:	c3                   	retq   

00000000008018f4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018f4:	55                   	push   %rbp
  8018f5:	48 89 e5             	mov    %rsp,%rbp
  8018f8:	48 83 ec 30          	sub    $0x30,%rsp
  8018fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801903:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801906:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80190a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80190e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801911:	48 63 c8             	movslq %eax,%rcx
  801914:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801918:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80191b:	48 63 f0             	movslq %eax,%rsi
  80191e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801925:	48 98                	cltq   
  801927:	48 89 0c 24          	mov    %rcx,(%rsp)
  80192b:	49 89 f9             	mov    %rdi,%r9
  80192e:	49 89 f0             	mov    %rsi,%r8
  801931:	48 89 d1             	mov    %rdx,%rcx
  801934:	48 89 c2             	mov    %rax,%rdx
  801937:	be 01 00 00 00       	mov    $0x1,%esi
  80193c:	bf 05 00 00 00       	mov    $0x5,%edi
  801941:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801948:	00 00 00 
  80194b:	ff d0                	callq  *%rax
}
  80194d:	c9                   	leaveq 
  80194e:	c3                   	retq   

000000000080194f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80194f:	55                   	push   %rbp
  801950:	48 89 e5             	mov    %rsp,%rbp
  801953:	48 83 ec 20          	sub    $0x20,%rsp
  801957:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80195a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80195e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801962:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801965:	48 98                	cltq   
  801967:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196e:	00 
  80196f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801975:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197b:	48 89 d1             	mov    %rdx,%rcx
  80197e:	48 89 c2             	mov    %rax,%rdx
  801981:	be 01 00 00 00       	mov    $0x1,%esi
  801986:	bf 06 00 00 00       	mov    $0x6,%edi
  80198b:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801992:	00 00 00 
  801995:	ff d0                	callq  *%rax
}
  801997:	c9                   	leaveq 
  801998:	c3                   	retq   

0000000000801999 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801999:	55                   	push   %rbp
  80199a:	48 89 e5             	mov    %rsp,%rbp
  80199d:	48 83 ec 20          	sub    $0x20,%rsp
  8019a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019aa:	48 63 d0             	movslq %eax,%rdx
  8019ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b0:	48 98                	cltq   
  8019b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b9:	00 
  8019ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c6:	48 89 d1             	mov    %rdx,%rcx
  8019c9:	48 89 c2             	mov    %rax,%rdx
  8019cc:	be 01 00 00 00       	mov    $0x1,%esi
  8019d1:	bf 08 00 00 00       	mov    $0x8,%edi
  8019d6:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  8019dd:	00 00 00 
  8019e0:	ff d0                	callq  *%rax
}
  8019e2:	c9                   	leaveq 
  8019e3:	c3                   	retq   

00000000008019e4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019e4:	55                   	push   %rbp
  8019e5:	48 89 e5             	mov    %rsp,%rbp
  8019e8:	48 83 ec 20          	sub    $0x20,%rsp
  8019ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fa:	48 98                	cltq   
  8019fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a03:	00 
  801a04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a10:	48 89 d1             	mov    %rdx,%rcx
  801a13:	48 89 c2             	mov    %rax,%rdx
  801a16:	be 01 00 00 00       	mov    $0x1,%esi
  801a1b:	bf 09 00 00 00       	mov    $0x9,%edi
  801a20:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801a27:	00 00 00 
  801a2a:	ff d0                	callq  *%rax
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
  801a32:	48 83 ec 20          	sub    $0x20,%rsp
  801a36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a44:	48 98                	cltq   
  801a46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4d:	00 
  801a4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5a:	48 89 d1             	mov    %rdx,%rcx
  801a5d:	48 89 c2             	mov    %rax,%rdx
  801a60:	be 01 00 00 00       	mov    $0x1,%esi
  801a65:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a6a:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801a71:	00 00 00 
  801a74:	ff d0                	callq  *%rax
}
  801a76:	c9                   	leaveq 
  801a77:	c3                   	retq   

0000000000801a78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a78:	55                   	push   %rbp
  801a79:	48 89 e5             	mov    %rsp,%rbp
  801a7c:	48 83 ec 30          	sub    $0x30,%rsp
  801a80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a87:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a8b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a91:	48 63 f0             	movslq %eax,%rsi
  801a94:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9b:	48 98                	cltq   
  801a9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa8:	00 
  801aa9:	49 89 f1             	mov    %rsi,%r9
  801aac:	49 89 c8             	mov    %rcx,%r8
  801aaf:	48 89 d1             	mov    %rdx,%rcx
  801ab2:	48 89 c2             	mov    %rax,%rdx
  801ab5:	be 00 00 00 00       	mov    $0x0,%esi
  801aba:	bf 0c 00 00 00       	mov    $0xc,%edi
  801abf:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801ac6:	00 00 00 
  801ac9:	ff d0                	callq  *%rax
}
  801acb:	c9                   	leaveq 
  801acc:	c3                   	retq   

0000000000801acd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801acd:	55                   	push   %rbp
  801ace:	48 89 e5             	mov    %rsp,%rbp
  801ad1:	48 83 ec 20          	sub    $0x20,%rsp
  801ad5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ad9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801add:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae4:	00 
  801ae5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aeb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af6:	48 89 c2             	mov    %rax,%rdx
  801af9:	be 01 00 00 00       	mov    $0x1,%esi
  801afe:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b03:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801b0a:	00 00 00 
  801b0d:	ff d0                	callq  *%rax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b20:	00 
  801b21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b32:	ba 00 00 00 00       	mov    $0x0,%edx
  801b37:	be 00 00 00 00       	mov    $0x0,%esi
  801b3c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b41:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801b48:	00 00 00 
  801b4b:	ff d0                	callq  *%rax
}
  801b4d:	c9                   	leaveq 
  801b4e:	c3                   	retq   

0000000000801b4f <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801b4f:	55                   	push   %rbp
  801b50:	48 89 e5             	mov    %rsp,%rbp
  801b53:	48 83 ec 20          	sub    $0x20,%rsp
  801b57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6e:	00 
  801b6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7b:	48 89 d1             	mov    %rdx,%rcx
  801b7e:	48 89 c2             	mov    %rax,%rdx
  801b81:	be 00 00 00 00       	mov    $0x0,%esi
  801b86:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b8b:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	callq  *%rax
}
  801b97:	c9                   	leaveq 
  801b98:	c3                   	retq   

0000000000801b99 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801b99:	55                   	push   %rbp
  801b9a:	48 89 e5             	mov    %rsp,%rbp
  801b9d:	48 83 ec 20          	sub    $0x20,%rsp
  801ba1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ba5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb8:	00 
  801bb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc5:	48 89 d1             	mov    %rdx,%rcx
  801bc8:	48 89 c2             	mov    %rax,%rdx
  801bcb:	be 00 00 00 00       	mov    $0x0,%esi
  801bd0:	bf 10 00 00 00       	mov    $0x10,%edi
  801bd5:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801bdc:	00 00 00 
  801bdf:	ff d0                	callq  *%rax
}
  801be1:	c9                   	leaveq 
  801be2:	c3                   	retq   
	...

0000000000801be4 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801be4:	55                   	push   %rbp
  801be5:	48 89 e5             	mov    %rsp,%rbp
  801be8:	48 83 ec 18          	sub    $0x18,%rsp
  801bec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bf0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bfc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c00:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801c0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c13:	8b 00                	mov    (%rax),%eax
  801c15:	83 f8 01             	cmp    $0x1,%eax
  801c18:	7e 13                	jle    801c2d <argstart+0x49>
  801c1a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801c1f:	74 0c                	je     801c2d <argstart+0x49>
  801c21:	48 b8 4b 48 80 00 00 	movabs $0x80484b,%rax
  801c28:	00 00 00 
  801c2b:	eb 05                	jmp    801c32 <argstart+0x4e>
  801c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c36:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3e:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c45:	00 
}
  801c46:	c9                   	leaveq 
  801c47:	c3                   	retq   

0000000000801c48 <argnext>:

int
argnext(struct Argstate *args)
{
  801c48:	55                   	push   %rbp
  801c49:	48 89 e5             	mov    %rsp,%rbp
  801c4c:	48 83 ec 20          	sub    $0x20,%rsp
  801c50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c58:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c5f:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c64:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c68:	48 85 c0             	test   %rax,%rax
  801c6b:	75 0a                	jne    801c77 <argnext+0x2f>
		return -1;
  801c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c72:	e9 24 01 00 00       	jmpq   801d9b <argnext+0x153>

	if (!*args->curarg) {
  801c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c7b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c7f:	0f b6 00             	movzbl (%rax),%eax
  801c82:	84 c0                	test   %al,%al
  801c84:	0f 85 d5 00 00 00    	jne    801d5f <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8e:	48 8b 00             	mov    (%rax),%rax
  801c91:	8b 00                	mov    (%rax),%eax
  801c93:	83 f8 01             	cmp    $0x1,%eax
  801c96:	0f 84 ee 00 00 00    	je     801d8a <argnext+0x142>
		    || args->argv[1][0] != '-'
  801c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ca4:	48 83 c0 08          	add    $0x8,%rax
  801ca8:	48 8b 00             	mov    (%rax),%rax
  801cab:	0f b6 00             	movzbl (%rax),%eax
  801cae:	3c 2d                	cmp    $0x2d,%al
  801cb0:	0f 85 d4 00 00 00    	jne    801d8a <argnext+0x142>
		    || args->argv[1][1] == '\0')
  801cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cba:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cbe:	48 83 c0 08          	add    $0x8,%rax
  801cc2:	48 8b 00             	mov    (%rax),%rax
  801cc5:	48 83 c0 01          	add    $0x1,%rax
  801cc9:	0f b6 00             	movzbl (%rax),%eax
  801ccc:	84 c0                	test   %al,%al
  801cce:	0f 84 b6 00 00 00    	je     801d8a <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801cd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd8:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cdc:	48 83 c0 08          	add    $0x8,%rax
  801ce0:	48 8b 00             	mov    (%rax),%rax
  801ce3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ce7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ceb:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801cef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf3:	48 8b 00             	mov    (%rax),%rax
  801cf6:	8b 00                	mov    (%rax),%eax
  801cf8:	83 e8 01             	sub    $0x1,%eax
  801cfb:	48 98                	cltq   
  801cfd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801d04:	00 
  801d05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d09:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d0d:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d15:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d19:	48 83 c0 08          	add    $0x8,%rax
  801d1d:	48 89 ce             	mov    %rcx,%rsi
  801d20:	48 89 c7             	mov    %rax,%rdi
  801d23:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  801d2a:	00 00 00 
  801d2d:	ff d0                	callq  *%rax
		(*args->argc)--;
  801d2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d33:	48 8b 00             	mov    (%rax),%rax
  801d36:	8b 10                	mov    (%rax),%edx
  801d38:	83 ea 01             	sub    $0x1,%edx
  801d3b:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d41:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d45:	0f b6 00             	movzbl (%rax),%eax
  801d48:	3c 2d                	cmp    $0x2d,%al
  801d4a:	75 13                	jne    801d5f <argnext+0x117>
  801d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d50:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d54:	48 83 c0 01          	add    $0x1,%rax
  801d58:	0f b6 00             	movzbl (%rax),%eax
  801d5b:	84 c0                	test   %al,%al
  801d5d:	74 2a                	je     801d89 <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d63:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d67:	0f b6 00             	movzbl (%rax),%eax
  801d6a:	0f b6 c0             	movzbl %al,%eax
  801d6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801d70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d74:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d78:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d80:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801d84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d87:	eb 12                	jmp    801d9b <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  801d89:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

    endofargs:
	args->curarg = 0;
  801d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d8e:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801d95:	00 
	return -1;
  801d96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801d9b:	c9                   	leaveq 
  801d9c:	c3                   	retq   

0000000000801d9d <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801d9d:	55                   	push   %rbp
  801d9e:	48 89 e5             	mov    %rsp,%rbp
  801da1:	48 83 ec 10          	sub    $0x10,%rsp
  801da5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801da9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dad:	48 8b 40 18          	mov    0x18(%rax),%rax
  801db1:	48 85 c0             	test   %rax,%rax
  801db4:	74 0a                	je     801dc0 <argvalue+0x23>
  801db6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dba:	48 8b 40 18          	mov    0x18(%rax),%rax
  801dbe:	eb 13                	jmp    801dd3 <argvalue+0x36>
  801dc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc4:	48 89 c7             	mov    %rax,%rdi
  801dc7:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  801dce:	00 00 00 
  801dd1:	ff d0                	callq  *%rax
}
  801dd3:	c9                   	leaveq 
  801dd4:	c3                   	retq   

0000000000801dd5 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801dd5:	55                   	push   %rbp
  801dd6:	48 89 e5             	mov    %rsp,%rbp
  801dd9:	48 83 ec 10          	sub    $0x10,%rsp
  801ddd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  801de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de5:	48 8b 40 10          	mov    0x10(%rax),%rax
  801de9:	48 85 c0             	test   %rax,%rax
  801dec:	75 0a                	jne    801df8 <argnextvalue+0x23>
		return 0;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
  801df3:	e9 c8 00 00 00       	jmpq   801ec0 <argnextvalue+0xeb>
	if (*args->curarg) {
  801df8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfc:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e00:	0f b6 00             	movzbl (%rax),%eax
  801e03:	84 c0                	test   %al,%al
  801e05:	74 27                	je     801e2e <argnextvalue+0x59>
		args->argvalue = args->curarg;
  801e07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801e0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e13:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801e17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1b:	48 ba 4b 48 80 00 00 	movabs $0x80484b,%rdx
  801e22:	00 00 00 
  801e25:	48 89 50 10          	mov    %rdx,0x10(%rax)
  801e29:	e9 8a 00 00 00       	jmpq   801eb8 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  801e2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e32:	48 8b 00             	mov    (%rax),%rax
  801e35:	8b 00                	mov    (%rax),%eax
  801e37:	83 f8 01             	cmp    $0x1,%eax
  801e3a:	7e 64                	jle    801ea0 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  801e3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e40:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e44:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801e48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4c:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e54:	48 8b 00             	mov    (%rax),%rax
  801e57:	8b 00                	mov    (%rax),%eax
  801e59:	83 e8 01             	sub    $0x1,%eax
  801e5c:	48 98                	cltq   
  801e5e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801e65:	00 
  801e66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e6e:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801e72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e76:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e7a:	48 83 c0 08          	add    $0x8,%rax
  801e7e:	48 89 ce             	mov    %rcx,%rsi
  801e81:	48 89 c7             	mov    %rax,%rdi
  801e84:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  801e8b:	00 00 00 
  801e8e:	ff d0                	callq  *%rax
		(*args->argc)--;
  801e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e94:	48 8b 00             	mov    (%rax),%rax
  801e97:	8b 10                	mov    (%rax),%edx
  801e99:	83 ea 01             	sub    $0x1,%edx
  801e9c:	89 10                	mov    %edx,(%rax)
  801e9e:	eb 18                	jmp    801eb8 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  801ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea4:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801eab:	00 
		args->curarg = 0;
  801eac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb0:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801eb7:	00 
	}
	return (char*) args->argvalue;
  801eb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ebc:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801ec0:	c9                   	leaveq 
  801ec1:	c3                   	retq   
	...

0000000000801ec4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ec4:	55                   	push   %rbp
  801ec5:	48 89 e5             	mov    %rsp,%rbp
  801ec8:	48 83 ec 08          	sub    $0x8,%rsp
  801ecc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ed0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ed4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801edb:	ff ff ff 
  801ede:	48 01 d0             	add    %rdx,%rax
  801ee1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ee5:	c9                   	leaveq 
  801ee6:	c3                   	retq   

0000000000801ee7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ee7:	55                   	push   %rbp
  801ee8:	48 89 e5             	mov    %rsp,%rbp
  801eeb:	48 83 ec 08          	sub    $0x8,%rsp
  801eef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ef3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef7:	48 89 c7             	mov    %rax,%rdi
  801efa:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
  801f06:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f0c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f10:	c9                   	leaveq 
  801f11:	c3                   	retq   

0000000000801f12 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f12:	55                   	push   %rbp
  801f13:	48 89 e5             	mov    %rsp,%rbp
  801f16:	48 83 ec 18          	sub    $0x18,%rsp
  801f1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f25:	eb 6b                	jmp    801f92 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2a:	48 98                	cltq   
  801f2c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f32:	48 c1 e0 0c          	shl    $0xc,%rax
  801f36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3e:	48 89 c2             	mov    %rax,%rdx
  801f41:	48 c1 ea 15          	shr    $0x15,%rdx
  801f45:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f4c:	01 00 00 
  801f4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f53:	83 e0 01             	and    $0x1,%eax
  801f56:	48 85 c0             	test   %rax,%rax
  801f59:	74 21                	je     801f7c <fd_alloc+0x6a>
  801f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5f:	48 89 c2             	mov    %rax,%rdx
  801f62:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f6d:	01 00 00 
  801f70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f74:	83 e0 01             	and    $0x1,%eax
  801f77:	48 85 c0             	test   %rax,%rax
  801f7a:	75 12                	jne    801f8e <fd_alloc+0x7c>
			*fd_store = fd;
  801f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f84:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	eb 1a                	jmp    801fa8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f8e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f92:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f96:	7e 8f                	jle    801f27 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f9c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fa3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fa8:	c9                   	leaveq 
  801fa9:	c3                   	retq   

0000000000801faa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801faa:	55                   	push   %rbp
  801fab:	48 89 e5             	mov    %rsp,%rbp
  801fae:	48 83 ec 20          	sub    $0x20,%rsp
  801fb2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fbd:	78 06                	js     801fc5 <fd_lookup+0x1b>
  801fbf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fc3:	7e 07                	jle    801fcc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fca:	eb 6c                	jmp    802038 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801fcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fcf:	48 98                	cltq   
  801fd1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fd7:	48 c1 e0 0c          	shl    $0xc,%rax
  801fdb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe3:	48 89 c2             	mov    %rax,%rdx
  801fe6:	48 c1 ea 15          	shr    $0x15,%rdx
  801fea:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ff1:	01 00 00 
  801ff4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ff8:	83 e0 01             	and    $0x1,%eax
  801ffb:	48 85 c0             	test   %rax,%rax
  801ffe:	74 21                	je     802021 <fd_lookup+0x77>
  802000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802004:	48 89 c2             	mov    %rax,%rdx
  802007:	48 c1 ea 0c          	shr    $0xc,%rdx
  80200b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802012:	01 00 00 
  802015:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802019:	83 e0 01             	and    $0x1,%eax
  80201c:	48 85 c0             	test   %rax,%rax
  80201f:	75 07                	jne    802028 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802021:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802026:	eb 10                	jmp    802038 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802028:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80202c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802030:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802038:	c9                   	leaveq 
  802039:	c3                   	retq   

000000000080203a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80203a:	55                   	push   %rbp
  80203b:	48 89 e5             	mov    %rsp,%rbp
  80203e:	48 83 ec 30          	sub    $0x30,%rsp
  802042:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802046:	89 f0                	mov    %esi,%eax
  802048:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80204b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204f:	48 89 c7             	mov    %rax,%rdi
  802052:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  802059:	00 00 00 
  80205c:	ff d0                	callq  *%rax
  80205e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802062:	48 89 d6             	mov    %rdx,%rsi
  802065:	89 c7                	mov    %eax,%edi
  802067:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  80206e:	00 00 00 
  802071:	ff d0                	callq  *%rax
  802073:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802076:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80207a:	78 0a                	js     802086 <fd_close+0x4c>
	    || fd != fd2)
  80207c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802080:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802084:	74 12                	je     802098 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802086:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80208a:	74 05                	je     802091 <fd_close+0x57>
  80208c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80208f:	eb 05                	jmp    802096 <fd_close+0x5c>
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
  802096:	eb 69                	jmp    802101 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802098:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209c:	8b 00                	mov    (%rax),%eax
  80209e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020a2:	48 89 d6             	mov    %rdx,%rsi
  8020a5:	89 c7                	mov    %eax,%edi
  8020a7:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax
  8020b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ba:	78 2a                	js     8020e6 <fd_close+0xac>
		if (dev->dev_close)
  8020bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020c4:	48 85 c0             	test   %rax,%rax
  8020c7:	74 16                	je     8020df <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8020c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cd:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8020d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d5:	48 89 c7             	mov    %rax,%rdi
  8020d8:	ff d2                	callq  *%rdx
  8020da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020dd:	eb 07                	jmp    8020e6 <fd_close+0xac>
		else
			r = 0;
  8020df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ea:	48 89 c6             	mov    %rax,%rsi
  8020ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f2:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
	return r;
  8020fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802101:	c9                   	leaveq 
  802102:	c3                   	retq   

0000000000802103 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802103:	55                   	push   %rbp
  802104:	48 89 e5             	mov    %rsp,%rbp
  802107:	48 83 ec 20          	sub    $0x20,%rsp
  80210b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80210e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802112:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802119:	eb 41                	jmp    80215c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80211b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802122:	00 00 00 
  802125:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802128:	48 63 d2             	movslq %edx,%rdx
  80212b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212f:	8b 00                	mov    (%rax),%eax
  802131:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802134:	75 22                	jne    802158 <dev_lookup+0x55>
			*dev = devtab[i];
  802136:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80213d:	00 00 00 
  802140:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802143:	48 63 d2             	movslq %edx,%rdx
  802146:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80214a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80214e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
  802156:	eb 60                	jmp    8021b8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802158:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80215c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802163:	00 00 00 
  802166:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802169:	48 63 d2             	movslq %edx,%rdx
  80216c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802170:	48 85 c0             	test   %rax,%rax
  802173:	75 a6                	jne    80211b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802175:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80217c:	00 00 00 
  80217f:	48 8b 00             	mov    (%rax),%rax
  802182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802188:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80218b:	89 c6                	mov    %eax,%esi
  80218d:	48 bf 50 48 80 00 00 	movabs $0x804850,%rdi
  802194:	00 00 00 
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
  80219c:	48 b9 af 03 80 00 00 	movabs $0x8003af,%rcx
  8021a3:	00 00 00 
  8021a6:	ff d1                	callq  *%rcx
	*dev = 0;
  8021a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021ac:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021b8:	c9                   	leaveq 
  8021b9:	c3                   	retq   

00000000008021ba <close>:

int
close(int fdnum)
{
  8021ba:	55                   	push   %rbp
  8021bb:	48 89 e5             	mov    %rsp,%rbp
  8021be:	48 83 ec 20          	sub    $0x20,%rsp
  8021c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021c5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021cc:	48 89 d6             	mov    %rdx,%rsi
  8021cf:	89 c7                	mov    %eax,%edi
  8021d1:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
  8021dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e4:	79 05                	jns    8021eb <close+0x31>
		return r;
  8021e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e9:	eb 18                	jmp    802203 <close+0x49>
	else
		return fd_close(fd, 1);
  8021eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ef:	be 01 00 00 00       	mov    $0x1,%esi
  8021f4:	48 89 c7             	mov    %rax,%rdi
  8021f7:	48 b8 3a 20 80 00 00 	movabs $0x80203a,%rax
  8021fe:	00 00 00 
  802201:	ff d0                	callq  *%rax
}
  802203:	c9                   	leaveq 
  802204:	c3                   	retq   

0000000000802205 <close_all>:

void
close_all(void)
{
  802205:	55                   	push   %rbp
  802206:	48 89 e5             	mov    %rsp,%rbp
  802209:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80220d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802214:	eb 15                	jmp    80222b <close_all+0x26>
		close(i);
  802216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802219:	89 c7                	mov    %eax,%edi
  80221b:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  802222:	00 00 00 
  802225:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802227:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80222b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80222f:	7e e5                	jle    802216 <close_all+0x11>
		close(i);
}
  802231:	c9                   	leaveq 
  802232:	c3                   	retq   

0000000000802233 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802233:	55                   	push   %rbp
  802234:	48 89 e5             	mov    %rsp,%rbp
  802237:	48 83 ec 40          	sub    $0x40,%rsp
  80223b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80223e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802241:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802245:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802248:	48 89 d6             	mov    %rdx,%rsi
  80224b:	89 c7                	mov    %eax,%edi
  80224d:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  802254:	00 00 00 
  802257:	ff d0                	callq  *%rax
  802259:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802260:	79 08                	jns    80226a <dup+0x37>
		return r;
  802262:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802265:	e9 70 01 00 00       	jmpq   8023da <dup+0x1a7>
	close(newfdnum);
  80226a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80226d:	89 c7                	mov    %eax,%edi
  80226f:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  802276:	00 00 00 
  802279:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80227b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80227e:	48 98                	cltq   
  802280:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802286:	48 c1 e0 0c          	shl    $0xc,%rax
  80228a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80228e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802292:	48 89 c7             	mov    %rax,%rdi
  802295:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  80229c:	00 00 00 
  80229f:	ff d0                	callq  *%rax
  8022a1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a9:	48 89 c7             	mov    %rax,%rdi
  8022ac:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	callq  *%rax
  8022b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c0:	48 89 c2             	mov    %rax,%rdx
  8022c3:	48 c1 ea 15          	shr    $0x15,%rdx
  8022c7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ce:	01 00 00 
  8022d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d5:	83 e0 01             	and    $0x1,%eax
  8022d8:	84 c0                	test   %al,%al
  8022da:	74 71                	je     80234d <dup+0x11a>
  8022dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e0:	48 89 c2             	mov    %rax,%rdx
  8022e3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ee:	01 00 00 
  8022f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f5:	83 e0 01             	and    $0x1,%eax
  8022f8:	84 c0                	test   %al,%al
  8022fa:	74 51                	je     80234d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802300:	48 89 c2             	mov    %rax,%rdx
  802303:	48 c1 ea 0c          	shr    $0xc,%rdx
  802307:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80230e:	01 00 00 
  802311:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802315:	89 c1                	mov    %eax,%ecx
  802317:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80231d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802325:	41 89 c8             	mov    %ecx,%r8d
  802328:	48 89 d1             	mov    %rdx,%rcx
  80232b:	ba 00 00 00 00       	mov    $0x0,%edx
  802330:	48 89 c6             	mov    %rax,%rsi
  802333:	bf 00 00 00 00       	mov    $0x0,%edi
  802338:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
  802344:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802347:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234b:	78 56                	js     8023a3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80234d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802351:	48 89 c2             	mov    %rax,%rdx
  802354:	48 c1 ea 0c          	shr    $0xc,%rdx
  802358:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80235f:	01 00 00 
  802362:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802366:	89 c1                	mov    %eax,%ecx
  802368:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80236e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802372:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802376:	41 89 c8             	mov    %ecx,%r8d
  802379:	48 89 d1             	mov    %rdx,%rcx
  80237c:	ba 00 00 00 00       	mov    $0x0,%edx
  802381:	48 89 c6             	mov    %rax,%rsi
  802384:	bf 00 00 00 00       	mov    $0x0,%edi
  802389:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  802390:	00 00 00 
  802393:	ff d0                	callq  *%rax
  802395:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802398:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239c:	78 08                	js     8023a6 <dup+0x173>
		goto err;

	return newfdnum;
  80239e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023a1:	eb 37                	jmp    8023da <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8023a3:	90                   	nop
  8023a4:	eb 01                	jmp    8023a7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8023a6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8023a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ab:	48 89 c6             	mov    %rax,%rsi
  8023ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b3:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023c3:	48 89 c6             	mov    %rax,%rsi
  8023c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023cb:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
	return r;
  8023d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023da:	c9                   	leaveq 
  8023db:	c3                   	retq   

00000000008023dc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023dc:	55                   	push   %rbp
  8023dd:	48 89 e5             	mov    %rsp,%rbp
  8023e0:	48 83 ec 40          	sub    $0x40,%rsp
  8023e4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023ef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023f6:	48 89 d6             	mov    %rdx,%rsi
  8023f9:	89 c7                	mov    %eax,%edi
  8023fb:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  802402:	00 00 00 
  802405:	ff d0                	callq  *%rax
  802407:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80240e:	78 24                	js     802434 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802414:	8b 00                	mov    (%rax),%eax
  802416:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80241a:	48 89 d6             	mov    %rdx,%rsi
  80241d:	89 c7                	mov    %eax,%edi
  80241f:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  802426:	00 00 00 
  802429:	ff d0                	callq  *%rax
  80242b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802432:	79 05                	jns    802439 <read+0x5d>
		return r;
  802434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802437:	eb 7a                	jmp    8024b3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243d:	8b 40 08             	mov    0x8(%rax),%eax
  802440:	83 e0 03             	and    $0x3,%eax
  802443:	83 f8 01             	cmp    $0x1,%eax
  802446:	75 3a                	jne    802482 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802448:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80244f:	00 00 00 
  802452:	48 8b 00             	mov    (%rax),%rax
  802455:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80245b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80245e:	89 c6                	mov    %eax,%esi
  802460:	48 bf 6f 48 80 00 00 	movabs $0x80486f,%rdi
  802467:	00 00 00 
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
  80246f:	48 b9 af 03 80 00 00 	movabs $0x8003af,%rcx
  802476:	00 00 00 
  802479:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80247b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802480:	eb 31                	jmp    8024b3 <read+0xd7>
	}
	if (!dev->dev_read)
  802482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802486:	48 8b 40 10          	mov    0x10(%rax),%rax
  80248a:	48 85 c0             	test   %rax,%rax
  80248d:	75 07                	jne    802496 <read+0xba>
		return -E_NOT_SUPP;
  80248f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802494:	eb 1d                	jmp    8024b3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80249e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024a6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024aa:	48 89 ce             	mov    %rcx,%rsi
  8024ad:	48 89 c7             	mov    %rax,%rdi
  8024b0:	41 ff d0             	callq  *%r8
}
  8024b3:	c9                   	leaveq 
  8024b4:	c3                   	retq   

00000000008024b5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024b5:	55                   	push   %rbp
  8024b6:	48 89 e5             	mov    %rsp,%rbp
  8024b9:	48 83 ec 30          	sub    $0x30,%rsp
  8024bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024cf:	eb 46                	jmp    802517 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d4:	48 98                	cltq   
  8024d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024da:	48 29 c2             	sub    %rax,%rdx
  8024dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e0:	48 98                	cltq   
  8024e2:	48 89 c1             	mov    %rax,%rcx
  8024e5:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8024e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024ec:	48 89 ce             	mov    %rcx,%rsi
  8024ef:	89 c7                	mov    %eax,%edi
  8024f1:	48 b8 dc 23 80 00 00 	movabs $0x8023dc,%rax
  8024f8:	00 00 00 
  8024fb:	ff d0                	callq  *%rax
  8024fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802500:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802504:	79 05                	jns    80250b <readn+0x56>
			return m;
  802506:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802509:	eb 1d                	jmp    802528 <readn+0x73>
		if (m == 0)
  80250b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80250f:	74 13                	je     802524 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802511:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802514:	01 45 fc             	add    %eax,-0x4(%rbp)
  802517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251a:	48 98                	cltq   
  80251c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802520:	72 af                	jb     8024d1 <readn+0x1c>
  802522:	eb 01                	jmp    802525 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802524:	90                   	nop
	}
	return tot;
  802525:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802528:	c9                   	leaveq 
  802529:	c3                   	retq   

000000000080252a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80252a:	55                   	push   %rbp
  80252b:	48 89 e5             	mov    %rsp,%rbp
  80252e:	48 83 ec 40          	sub    $0x40,%rsp
  802532:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802535:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802539:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80253d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802541:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802544:	48 89 d6             	mov    %rdx,%rsi
  802547:	89 c7                	mov    %eax,%edi
  802549:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax
  802555:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802558:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255c:	78 24                	js     802582 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80255e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802562:	8b 00                	mov    (%rax),%eax
  802564:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802568:	48 89 d6             	mov    %rdx,%rsi
  80256b:	89 c7                	mov    %eax,%edi
  80256d:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  802574:	00 00 00 
  802577:	ff d0                	callq  *%rax
  802579:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802580:	79 05                	jns    802587 <write+0x5d>
		return r;
  802582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802585:	eb 79                	jmp    802600 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258b:	8b 40 08             	mov    0x8(%rax),%eax
  80258e:	83 e0 03             	and    $0x3,%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	75 3a                	jne    8025cf <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802595:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80259c:	00 00 00 
  80259f:	48 8b 00             	mov    (%rax),%rax
  8025a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025a8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025ab:	89 c6                	mov    %eax,%esi
  8025ad:	48 bf 8b 48 80 00 00 	movabs $0x80488b,%rdi
  8025b4:	00 00 00 
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bc:	48 b9 af 03 80 00 00 	movabs $0x8003af,%rcx
  8025c3:	00 00 00 
  8025c6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025cd:	eb 31                	jmp    802600 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025d7:	48 85 c0             	test   %rax,%rax
  8025da:	75 07                	jne    8025e3 <write+0xb9>
		return -E_NOT_SUPP;
  8025dc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025e1:	eb 1d                	jmp    802600 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8025e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e7:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8025eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025f3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025f7:	48 89 ce             	mov    %rcx,%rsi
  8025fa:	48 89 c7             	mov    %rax,%rdi
  8025fd:	41 ff d0             	callq  *%r8
}
  802600:	c9                   	leaveq 
  802601:	c3                   	retq   

0000000000802602 <seek>:

int
seek(int fdnum, off_t offset)
{
  802602:	55                   	push   %rbp
  802603:	48 89 e5             	mov    %rsp,%rbp
  802606:	48 83 ec 18          	sub    $0x18,%rsp
  80260a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80260d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802610:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802614:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802617:	48 89 d6             	mov    %rdx,%rsi
  80261a:	89 c7                	mov    %eax,%edi
  80261c:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  802623:	00 00 00 
  802626:	ff d0                	callq  *%rax
  802628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80262f:	79 05                	jns    802636 <seek+0x34>
		return r;
  802631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802634:	eb 0f                	jmp    802645 <seek+0x43>
	fd->fd_offset = offset;
  802636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80263d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802640:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802645:	c9                   	leaveq 
  802646:	c3                   	retq   

0000000000802647 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802647:	55                   	push   %rbp
  802648:	48 89 e5             	mov    %rsp,%rbp
  80264b:	48 83 ec 30          	sub    $0x30,%rsp
  80264f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802652:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802655:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802659:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80265c:	48 89 d6             	mov    %rdx,%rsi
  80265f:	89 c7                	mov    %eax,%edi
  802661:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
  80266d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802670:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802674:	78 24                	js     80269a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267a:	8b 00                	mov    (%rax),%eax
  80267c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802680:	48 89 d6             	mov    %rdx,%rsi
  802683:	89 c7                	mov    %eax,%edi
  802685:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802698:	79 05                	jns    80269f <ftruncate+0x58>
		return r;
  80269a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269d:	eb 72                	jmp    802711 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80269f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a3:	8b 40 08             	mov    0x8(%rax),%eax
  8026a6:	83 e0 03             	and    $0x3,%eax
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	75 3a                	jne    8026e7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026ad:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8026b4:	00 00 00 
  8026b7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026ba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026c0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026c3:	89 c6                	mov    %eax,%esi
  8026c5:	48 bf a8 48 80 00 00 	movabs $0x8048a8,%rdi
  8026cc:	00 00 00 
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d4:	48 b9 af 03 80 00 00 	movabs $0x8003af,%rcx
  8026db:	00 00 00 
  8026de:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026e5:	eb 2a                	jmp    802711 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8026e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026eb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026ef:	48 85 c0             	test   %rax,%rax
  8026f2:	75 07                	jne    8026fb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026f4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026f9:	eb 16                	jmp    802711 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ff:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802707:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80270a:	89 d6                	mov    %edx,%esi
  80270c:	48 89 c7             	mov    %rax,%rdi
  80270f:	ff d1                	callq  *%rcx
}
  802711:	c9                   	leaveq 
  802712:	c3                   	retq   

0000000000802713 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802713:	55                   	push   %rbp
  802714:	48 89 e5             	mov    %rsp,%rbp
  802717:	48 83 ec 30          	sub    $0x30,%rsp
  80271b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80271e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802722:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802726:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802729:	48 89 d6             	mov    %rdx,%rsi
  80272c:	89 c7                	mov    %eax,%edi
  80272e:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  802735:	00 00 00 
  802738:	ff d0                	callq  *%rax
  80273a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802741:	78 24                	js     802767 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802747:	8b 00                	mov    (%rax),%eax
  802749:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274d:	48 89 d6             	mov    %rdx,%rsi
  802750:	89 c7                	mov    %eax,%edi
  802752:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  802759:	00 00 00 
  80275c:	ff d0                	callq  *%rax
  80275e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802765:	79 05                	jns    80276c <fstat+0x59>
		return r;
  802767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80276a:	eb 5e                	jmp    8027ca <fstat+0xb7>
	if (!dev->dev_stat)
  80276c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802770:	48 8b 40 28          	mov    0x28(%rax),%rax
  802774:	48 85 c0             	test   %rax,%rax
  802777:	75 07                	jne    802780 <fstat+0x6d>
		return -E_NOT_SUPP;
  802779:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80277e:	eb 4a                	jmp    8027ca <fstat+0xb7>
	stat->st_name[0] = 0;
  802780:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802784:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802787:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80278b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802792:	00 00 00 
	stat->st_isdir = 0;
  802795:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802799:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027a0:	00 00 00 
	stat->st_dev = dev;
  8027a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ab:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8027ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027be:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8027c2:	48 89 d6             	mov    %rdx,%rsi
  8027c5:	48 89 c7             	mov    %rax,%rdi
  8027c8:	ff d1                	callq  *%rcx
}
  8027ca:	c9                   	leaveq 
  8027cb:	c3                   	retq   

00000000008027cc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027cc:	55                   	push   %rbp
  8027cd:	48 89 e5             	mov    %rsp,%rbp
  8027d0:	48 83 ec 20          	sub    $0x20,%rsp
  8027d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e0:	be 00 00 00 00       	mov    $0x0,%esi
  8027e5:	48 89 c7             	mov    %rax,%rdi
  8027e8:	48 b8 bb 28 80 00 00 	movabs $0x8028bb,%rax
  8027ef:	00 00 00 
  8027f2:	ff d0                	callq  *%rax
  8027f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027fb:	79 05                	jns    802802 <stat+0x36>
		return fd;
  8027fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802800:	eb 2f                	jmp    802831 <stat+0x65>
	r = fstat(fd, stat);
  802802:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802806:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802809:	48 89 d6             	mov    %rdx,%rsi
  80280c:	89 c7                	mov    %eax,%edi
  80280e:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  802815:	00 00 00 
  802818:	ff d0                	callq  *%rax
  80281a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80281d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802820:	89 c7                	mov    %eax,%edi
  802822:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  802829:	00 00 00 
  80282c:	ff d0                	callq  *%rax
	return r;
  80282e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802831:	c9                   	leaveq 
  802832:	c3                   	retq   
	...

0000000000802834 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802834:	55                   	push   %rbp
  802835:	48 89 e5             	mov    %rsp,%rbp
  802838:	48 83 ec 10          	sub    $0x10,%rsp
  80283c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80283f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802843:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  80284a:	00 00 00 
  80284d:	8b 00                	mov    (%rax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	75 1d                	jne    802870 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802853:	bf 01 00 00 00       	mov    $0x1,%edi
  802858:	48 b8 f3 41 80 00 00 	movabs $0x8041f3,%rax
  80285f:	00 00 00 
  802862:	ff d0                	callq  *%rax
  802864:	48 ba 1c 70 80 00 00 	movabs $0x80701c,%rdx
  80286b:	00 00 00 
  80286e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802870:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  802877:	00 00 00 
  80287a:	8b 00                	mov    (%rax),%eax
  80287c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80287f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802884:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80288b:	00 00 00 
  80288e:	89 c7                	mov    %eax,%edi
  802890:	48 b8 30 41 80 00 00 	movabs $0x804130,%rax
  802897:	00 00 00 
  80289a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80289c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a5:	48 89 c6             	mov    %rax,%rsi
  8028a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ad:	48 b8 70 40 80 00 00 	movabs $0x804070,%rax
  8028b4:	00 00 00 
  8028b7:	ff d0                	callq  *%rax
}
  8028b9:	c9                   	leaveq 
  8028ba:	c3                   	retq   

00000000008028bb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028bb:	55                   	push   %rbp
  8028bc:	48 89 e5             	mov    %rsp,%rbp
  8028bf:	48 83 ec 20          	sub    $0x20,%rsp
  8028c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8028ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ce:	48 89 c7             	mov    %rax,%rdi
  8028d1:	48 b8 00 0f 80 00 00 	movabs $0x800f00,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
  8028dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028e2:	7e 0a                	jle    8028ee <open+0x33>
                return -E_BAD_PATH;
  8028e4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028e9:	e9 a5 00 00 00       	jmpq   802993 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8028ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8028f2:	48 89 c7             	mov    %rax,%rdi
  8028f5:	48 b8 12 1f 80 00 00 	movabs $0x801f12,%rax
  8028fc:	00 00 00 
  8028ff:	ff d0                	callq  *%rax
  802901:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802904:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802908:	79 08                	jns    802912 <open+0x57>
		return r;
  80290a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290d:	e9 81 00 00 00       	jmpq   802993 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802916:	48 89 c6             	mov    %rax,%rsi
  802919:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802920:	00 00 00 
  802923:	48 b8 6c 0f 80 00 00 	movabs $0x800f6c,%rax
  80292a:	00 00 00 
  80292d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80292f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802936:	00 00 00 
  802939:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80293c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802942:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802946:	48 89 c6             	mov    %rax,%rsi
  802949:	bf 01 00 00 00       	mov    $0x1,%edi
  80294e:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802955:	00 00 00 
  802958:	ff d0                	callq  *%rax
  80295a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  80295d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802961:	79 1d                	jns    802980 <open+0xc5>
	{
		fd_close(fd,0);
  802963:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802967:	be 00 00 00 00       	mov    $0x0,%esi
  80296c:	48 89 c7             	mov    %rax,%rdi
  80296f:	48 b8 3a 20 80 00 00 	movabs $0x80203a,%rax
  802976:	00 00 00 
  802979:	ff d0                	callq  *%rax
		return r;
  80297b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297e:	eb 13                	jmp    802993 <open+0xd8>
	}
	return fd2num(fd);
  802980:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802984:	48 89 c7             	mov    %rax,%rdi
  802987:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  80298e:	00 00 00 
  802991:	ff d0                	callq  *%rax
	


}
  802993:	c9                   	leaveq 
  802994:	c3                   	retq   

0000000000802995 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802995:	55                   	push   %rbp
  802996:	48 89 e5             	mov    %rsp,%rbp
  802999:	48 83 ec 10          	sub    $0x10,%rsp
  80299d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a5:	8b 50 0c             	mov    0xc(%rax),%edx
  8029a8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029af:	00 00 00 
  8029b2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029b4:	be 00 00 00 00       	mov    $0x0,%esi
  8029b9:	bf 06 00 00 00       	mov    $0x6,%edi
  8029be:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  8029c5:	00 00 00 
  8029c8:	ff d0                	callq  *%rax
}
  8029ca:	c9                   	leaveq 
  8029cb:	c3                   	retq   

00000000008029cc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029cc:	55                   	push   %rbp
  8029cd:	48 89 e5             	mov    %rsp,%rbp
  8029d0:	48 83 ec 30          	sub    $0x30,%rsp
  8029d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e4:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ee:	00 00 00 
  8029f1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029f3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029fa:	00 00 00 
  8029fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a01:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802a05:	be 00 00 00 00       	mov    $0x0,%esi
  802a0a:	bf 03 00 00 00       	mov    $0x3,%edi
  802a0f:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802a16:	00 00 00 
  802a19:	ff d0                	callq  *%rax
  802a1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a22:	79 05                	jns    802a29 <devfile_read+0x5d>
	{
		return r;
  802a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a27:	eb 2c                	jmp    802a55 <devfile_read+0x89>
	}
	if(r > 0)
  802a29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2d:	7e 23                	jle    802a52 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802a2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a32:	48 63 d0             	movslq %eax,%rdx
  802a35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a39:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a40:	00 00 00 
  802a43:	48 89 c7             	mov    %rax,%rdi
  802a46:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
	return r;
  802a52:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802a55:	c9                   	leaveq 
  802a56:	c3                   	retq   

0000000000802a57 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a57:	55                   	push   %rbp
  802a58:	48 89 e5             	mov    %rsp,%rbp
  802a5b:	48 83 ec 30          	sub    $0x30,%rsp
  802a5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802a6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6f:	8b 50 0c             	mov    0xc(%rax),%edx
  802a72:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a79:	00 00 00 
  802a7c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802a7e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a85:	00 
  802a86:	76 08                	jbe    802a90 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802a88:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a8f:	00 
	fsipcbuf.write.req_n=n;
  802a90:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a97:	00 00 00 
  802a9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a9e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802aa2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aaa:	48 89 c6             	mov    %rax,%rsi
  802aad:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ab4:	00 00 00 
  802ab7:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802ac3:	be 00 00 00 00       	mov    $0x0,%esi
  802ac8:	bf 04 00 00 00       	mov    $0x4,%edi
  802acd:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
  802ad9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802adf:	c9                   	leaveq 
  802ae0:	c3                   	retq   

0000000000802ae1 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802ae1:	55                   	push   %rbp
  802ae2:	48 89 e5             	mov    %rsp,%rbp
  802ae5:	48 83 ec 10          	sub    $0x10,%rsp
  802ae9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802aed:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802af0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af4:	8b 50 0c             	mov    0xc(%rax),%edx
  802af7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802afe:	00 00 00 
  802b01:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802b03:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b0a:	00 00 00 
  802b0d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b10:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b13:	be 00 00 00 00       	mov    $0x0,%esi
  802b18:	bf 02 00 00 00       	mov    $0x2,%edi
  802b1d:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802b24:	00 00 00 
  802b27:	ff d0                	callq  *%rax
}
  802b29:	c9                   	leaveq 
  802b2a:	c3                   	retq   

0000000000802b2b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b2b:	55                   	push   %rbp
  802b2c:	48 89 e5             	mov    %rsp,%rbp
  802b2f:	48 83 ec 20          	sub    $0x20,%rsp
  802b33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3f:	8b 50 0c             	mov    0xc(%rax),%edx
  802b42:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b49:	00 00 00 
  802b4c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b4e:	be 00 00 00 00       	mov    $0x0,%esi
  802b53:	bf 05 00 00 00       	mov    $0x5,%edi
  802b58:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6b:	79 05                	jns    802b72 <devfile_stat+0x47>
		return r;
  802b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b70:	eb 56                	jmp    802bc8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b76:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b7d:	00 00 00 
  802b80:	48 89 c7             	mov    %rax,%rdi
  802b83:	48 b8 6c 0f 80 00 00 	movabs $0x800f6c,%rax
  802b8a:	00 00 00 
  802b8d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b8f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b96:	00 00 00 
  802b99:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ba9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bb0:	00 00 00 
  802bb3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bbd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc8:	c9                   	leaveq 
  802bc9:	c3                   	retq   
	...

0000000000802bcc <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802bcc:	55                   	push   %rbp
  802bcd:	48 89 e5             	mov    %rsp,%rbp
  802bd0:	48 83 ec 20          	sub    $0x20,%rsp
  802bd4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdc:	8b 40 0c             	mov    0xc(%rax),%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	7e 67                	jle    802c4a <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be7:	8b 40 04             	mov    0x4(%rax),%eax
  802bea:	48 63 d0             	movslq %eax,%rdx
  802bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf1:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf9:	8b 00                	mov    (%rax),%eax
  802bfb:	48 89 ce             	mov    %rcx,%rsi
  802bfe:	89 c7                	mov    %eax,%edi
  802c00:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	callq  *%rax
  802c0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c13:	7e 13                	jle    802c28 <writebuf+0x5c>
			b->result += result;
  802c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c19:	8b 40 08             	mov    0x8(%rax),%eax
  802c1c:	89 c2                	mov    %eax,%edx
  802c1e:	03 55 fc             	add    -0x4(%rbp),%edx
  802c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c25:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802c28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2c:	8b 40 04             	mov    0x4(%rax),%eax
  802c2f:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802c32:	74 16                	je     802c4a <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802c34:	b8 00 00 00 00       	mov    $0x0,%eax
  802c39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3d:	89 c2                	mov    %eax,%edx
  802c3f:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  802c43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c47:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802c4a:	c9                   	leaveq 
  802c4b:	c3                   	retq   

0000000000802c4c <putch>:

static void
putch(int ch, void *thunk)
{
  802c4c:	55                   	push   %rbp
  802c4d:	48 89 e5             	mov    %rsp,%rbp
  802c50:	48 83 ec 20          	sub    $0x20,%rsp
  802c54:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c57:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802c5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802c63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c67:	8b 40 04             	mov    0x4(%rax),%eax
  802c6a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c6d:	89 d6                	mov    %edx,%esi
  802c6f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802c73:	48 63 d0             	movslq %eax,%rdx
  802c76:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  802c7b:	8d 50 01             	lea    0x1(%rax),%edx
  802c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c82:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  802c85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c89:	8b 40 04             	mov    0x4(%rax),%eax
  802c8c:	3d 00 01 00 00       	cmp    $0x100,%eax
  802c91:	75 1e                	jne    802cb1 <putch+0x65>
		writebuf(b);
  802c93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c97:	48 89 c7             	mov    %rax,%rdi
  802c9a:	48 b8 cc 2b 80 00 00 	movabs $0x802bcc,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
		b->idx = 0;
  802ca6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802caa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802cb1:	c9                   	leaveq 
  802cb2:	c3                   	retq   

0000000000802cb3 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802cb3:	55                   	push   %rbp
  802cb4:	48 89 e5             	mov    %rsp,%rbp
  802cb7:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802cbe:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802cc4:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802ccb:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802cd2:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802cd8:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802cde:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802ce5:	00 00 00 
	b.result = 0;
  802ce8:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802cef:	00 00 00 
	b.error = 1;
  802cf2:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802cf9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802cfc:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802d03:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802d0a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d11:	48 89 c6             	mov    %rax,%rsi
  802d14:	48 bf 4c 2c 80 00 00 	movabs $0x802c4c,%rdi
  802d1b:	00 00 00 
  802d1e:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  802d25:	00 00 00 
  802d28:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802d2a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802d30:	85 c0                	test   %eax,%eax
  802d32:	7e 16                	jle    802d4a <vfprintf+0x97>
		writebuf(&b);
  802d34:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d3b:	48 89 c7             	mov    %rax,%rdi
  802d3e:	48 b8 cc 2b 80 00 00 	movabs $0x802bcc,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802d4a:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	74 08                	je     802d5c <vfprintf+0xa9>
  802d54:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d5a:	eb 06                	jmp    802d62 <vfprintf+0xaf>
  802d5c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802d62:	c9                   	leaveq 
  802d63:	c3                   	retq   

0000000000802d64 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802d64:	55                   	push   %rbp
  802d65:	48 89 e5             	mov    %rsp,%rbp
  802d68:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d6f:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802d75:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802d7c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802d83:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802d8a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802d91:	84 c0                	test   %al,%al
  802d93:	74 20                	je     802db5 <fprintf+0x51>
  802d95:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802d99:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802d9d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802da1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802da5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802da9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802dad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802db1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802db5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802dbc:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802dc3:	00 00 00 
  802dc6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802dcd:	00 00 00 
  802dd0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802dd4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802ddb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802de2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802de9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802df0:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802df7:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802dfd:	48 89 ce             	mov    %rcx,%rsi
  802e00:	89 c7                	mov    %eax,%edi
  802e02:	48 b8 b3 2c 80 00 00 	movabs $0x802cb3,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
  802e0e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802e14:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e1a:	c9                   	leaveq 
  802e1b:	c3                   	retq   

0000000000802e1c <printf>:

int
printf(const char *fmt, ...)
{
  802e1c:	55                   	push   %rbp
  802e1d:	48 89 e5             	mov    %rsp,%rbp
  802e20:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e27:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802e2e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e35:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e3c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e43:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e4a:	84 c0                	test   %al,%al
  802e4c:	74 20                	je     802e6e <printf+0x52>
  802e4e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e52:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e56:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e5a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e5e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e62:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e66:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e6a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e6e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802e75:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802e7c:	00 00 00 
  802e7f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802e86:	00 00 00 
  802e89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e8d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802e94:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802e9b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802ea2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802ea9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802eb0:	48 89 c6             	mov    %rax,%rsi
  802eb3:	bf 01 00 00 00       	mov    $0x1,%edi
  802eb8:	48 b8 b3 2c 80 00 00 	movabs $0x802cb3,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
  802ec4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802eca:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ed0:	c9                   	leaveq 
  802ed1:	c3                   	retq   
	...

0000000000802ed4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	48 83 ec 20          	sub    $0x20,%rsp
  802edc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802edf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ee3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ee6:	48 89 d6             	mov    %rdx,%rsi
  802ee9:	89 c7                	mov    %eax,%edi
  802eeb:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  802ef2:	00 00 00 
  802ef5:	ff d0                	callq  *%rax
  802ef7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802efe:	79 05                	jns    802f05 <fd2sockid+0x31>
		return r;
  802f00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f03:	eb 24                	jmp    802f29 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f09:	8b 10                	mov    (%rax),%edx
  802f0b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802f12:	00 00 00 
  802f15:	8b 00                	mov    (%rax),%eax
  802f17:	39 c2                	cmp    %eax,%edx
  802f19:	74 07                	je     802f22 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f1b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f20:	eb 07                	jmp    802f29 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f26:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802f29:	c9                   	leaveq 
  802f2a:	c3                   	retq   

0000000000802f2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f2b:	55                   	push   %rbp
  802f2c:	48 89 e5             	mov    %rsp,%rbp
  802f2f:	48 83 ec 20          	sub    $0x20,%rsp
  802f33:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802f36:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f3a:	48 89 c7             	mov    %rax,%rdi
  802f3d:	48 b8 12 1f 80 00 00 	movabs $0x801f12,%rax
  802f44:	00 00 00 
  802f47:	ff d0                	callq  *%rax
  802f49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f50:	78 26                	js     802f78 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802f52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f56:	ba 07 04 00 00       	mov    $0x407,%edx
  802f5b:	48 89 c6             	mov    %rax,%rsi
  802f5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802f63:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  802f6a:	00 00 00 
  802f6d:	ff d0                	callq  *%rax
  802f6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f76:	79 16                	jns    802f8e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f7b:	89 c7                	mov    %eax,%edi
  802f7d:	48 b8 38 34 80 00 00 	movabs $0x803438,%rax
  802f84:	00 00 00 
  802f87:	ff d0                	callq  *%rax
		return r;
  802f89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8c:	eb 3a                	jmp    802fc8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f92:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802f99:	00 00 00 
  802f9c:	8b 12                	mov    (%rdx),%edx
  802f9e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802faf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fb2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb9:	48 89 c7             	mov    %rax,%rdi
  802fbc:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  802fc3:	00 00 00 
  802fc6:	ff d0                	callq  *%rax
}
  802fc8:	c9                   	leaveq 
  802fc9:	c3                   	retq   

0000000000802fca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802fca:	55                   	push   %rbp
  802fcb:	48 89 e5             	mov    %rsp,%rbp
  802fce:	48 83 ec 30          	sub    $0x30,%rsp
  802fd2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fd5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fd9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fdd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe0:	89 c7                	mov    %eax,%edi
  802fe2:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  802fe9:	00 00 00 
  802fec:	ff d0                	callq  *%rax
  802fee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff5:	79 05                	jns    802ffc <accept+0x32>
		return r;
  802ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffa:	eb 3b                	jmp    803037 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ffc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803000:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803007:	48 89 ce             	mov    %rcx,%rsi
  80300a:	89 c7                	mov    %eax,%edi
  80300c:	48 b8 15 33 80 00 00 	movabs $0x803315,%rax
  803013:	00 00 00 
  803016:	ff d0                	callq  *%rax
  803018:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80301b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301f:	79 05                	jns    803026 <accept+0x5c>
		return r;
  803021:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803024:	eb 11                	jmp    803037 <accept+0x6d>
	return alloc_sockfd(r);
  803026:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803029:	89 c7                	mov    %eax,%edi
  80302b:	48 b8 2b 2f 80 00 00 	movabs $0x802f2b,%rax
  803032:	00 00 00 
  803035:	ff d0                	callq  *%rax
}
  803037:	c9                   	leaveq 
  803038:	c3                   	retq   

0000000000803039 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803039:	55                   	push   %rbp
  80303a:	48 89 e5             	mov    %rsp,%rbp
  80303d:	48 83 ec 20          	sub    $0x20,%rsp
  803041:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803044:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803048:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80304b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80304e:	89 c7                	mov    %eax,%edi
  803050:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803057:	00 00 00 
  80305a:	ff d0                	callq  *%rax
  80305c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80305f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803063:	79 05                	jns    80306a <bind+0x31>
		return r;
  803065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803068:	eb 1b                	jmp    803085 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80306a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80306d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803074:	48 89 ce             	mov    %rcx,%rsi
  803077:	89 c7                	mov    %eax,%edi
  803079:	48 b8 94 33 80 00 00 	movabs $0x803394,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
}
  803085:	c9                   	leaveq 
  803086:	c3                   	retq   

0000000000803087 <shutdown>:

int
shutdown(int s, int how)
{
  803087:	55                   	push   %rbp
  803088:	48 89 e5             	mov    %rsp,%rbp
  80308b:	48 83 ec 20          	sub    $0x20,%rsp
  80308f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803092:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803095:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803098:	89 c7                	mov    %eax,%edi
  80309a:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  8030a1:	00 00 00 
  8030a4:	ff d0                	callq  *%rax
  8030a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ad:	79 05                	jns    8030b4 <shutdown+0x2d>
		return r;
  8030af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b2:	eb 16                	jmp    8030ca <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8030b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ba:	89 d6                	mov    %edx,%esi
  8030bc:	89 c7                	mov    %eax,%edi
  8030be:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  8030c5:	00 00 00 
  8030c8:	ff d0                	callq  *%rax
}
  8030ca:	c9                   	leaveq 
  8030cb:	c3                   	retq   

00000000008030cc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8030cc:	55                   	push   %rbp
  8030cd:	48 89 e5             	mov    %rsp,%rbp
  8030d0:	48 83 ec 10          	sub    $0x10,%rsp
  8030d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8030d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030dc:	48 89 c7             	mov    %rax,%rdi
  8030df:	48 b8 78 42 80 00 00 	movabs $0x804278,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
  8030eb:	83 f8 01             	cmp    $0x1,%eax
  8030ee:	75 17                	jne    803107 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8030f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030f4:	8b 40 0c             	mov    0xc(%rax),%eax
  8030f7:	89 c7                	mov    %eax,%edi
  8030f9:	48 b8 38 34 80 00 00 	movabs $0x803438,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
  803105:	eb 05                	jmp    80310c <devsock_close+0x40>
	else
		return 0;
  803107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80310c:	c9                   	leaveq 
  80310d:	c3                   	retq   

000000000080310e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80310e:	55                   	push   %rbp
  80310f:	48 89 e5             	mov    %rsp,%rbp
  803112:	48 83 ec 20          	sub    $0x20,%rsp
  803116:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803119:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80311d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803120:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803123:	89 c7                	mov    %eax,%edi
  803125:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
  803131:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803134:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803138:	79 05                	jns    80313f <connect+0x31>
		return r;
  80313a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313d:	eb 1b                	jmp    80315a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80313f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803142:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803149:	48 89 ce             	mov    %rcx,%rsi
  80314c:	89 c7                	mov    %eax,%edi
  80314e:	48 b8 65 34 80 00 00 	movabs $0x803465,%rax
  803155:	00 00 00 
  803158:	ff d0                	callq  *%rax
}
  80315a:	c9                   	leaveq 
  80315b:	c3                   	retq   

000000000080315c <listen>:

int
listen(int s, int backlog)
{
  80315c:	55                   	push   %rbp
  80315d:	48 89 e5             	mov    %rsp,%rbp
  803160:	48 83 ec 20          	sub    $0x20,%rsp
  803164:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803167:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80316a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80316d:	89 c7                	mov    %eax,%edi
  80316f:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803176:	00 00 00 
  803179:	ff d0                	callq  *%rax
  80317b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803182:	79 05                	jns    803189 <listen+0x2d>
		return r;
  803184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803187:	eb 16                	jmp    80319f <listen+0x43>
	return nsipc_listen(r, backlog);
  803189:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80318c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318f:	89 d6                	mov    %edx,%esi
  803191:	89 c7                	mov    %eax,%edi
  803193:	48 b8 c9 34 80 00 00 	movabs $0x8034c9,%rax
  80319a:	00 00 00 
  80319d:	ff d0                	callq  *%rax
}
  80319f:	c9                   	leaveq 
  8031a0:	c3                   	retq   

00000000008031a1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	48 83 ec 20          	sub    $0x20,%rsp
  8031a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8031b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b9:	89 c2                	mov    %eax,%edx
  8031bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bf:	8b 40 0c             	mov    0xc(%rax),%eax
  8031c2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031cb:	89 c7                	mov    %eax,%edi
  8031cd:	48 b8 09 35 80 00 00 	movabs $0x803509,%rax
  8031d4:	00 00 00 
  8031d7:	ff d0                	callq  *%rax
}
  8031d9:	c9                   	leaveq 
  8031da:	c3                   	retq   

00000000008031db <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8031db:	55                   	push   %rbp
  8031dc:	48 89 e5             	mov    %rsp,%rbp
  8031df:	48 83 ec 20          	sub    $0x20,%rsp
  8031e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8031ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f3:	89 c2                	mov    %eax,%edx
  8031f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031f9:	8b 40 0c             	mov    0xc(%rax),%eax
  8031fc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803200:	b9 00 00 00 00       	mov    $0x0,%ecx
  803205:	89 c7                	mov    %eax,%edi
  803207:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  80320e:	00 00 00 
  803211:	ff d0                	callq  *%rax
}
  803213:	c9                   	leaveq 
  803214:	c3                   	retq   

0000000000803215 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803215:	55                   	push   %rbp
  803216:	48 89 e5             	mov    %rsp,%rbp
  803219:	48 83 ec 10          	sub    $0x10,%rsp
  80321d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803221:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803229:	48 be d3 48 80 00 00 	movabs $0x8048d3,%rsi
  803230:	00 00 00 
  803233:	48 89 c7             	mov    %rax,%rdi
  803236:	48 b8 6c 0f 80 00 00 	movabs $0x800f6c,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
	return 0;
  803242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803247:	c9                   	leaveq 
  803248:	c3                   	retq   

0000000000803249 <socket>:

int
socket(int domain, int type, int protocol)
{
  803249:	55                   	push   %rbp
  80324a:	48 89 e5             	mov    %rsp,%rbp
  80324d:	48 83 ec 20          	sub    $0x20,%rsp
  803251:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803254:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803257:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80325a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80325d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803260:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803263:	89 ce                	mov    %ecx,%esi
  803265:	89 c7                	mov    %eax,%edi
  803267:	48 b8 8d 36 80 00 00 	movabs $0x80368d,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
  803273:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803276:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80327a:	79 05                	jns    803281 <socket+0x38>
		return r;
  80327c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80327f:	eb 11                	jmp    803292 <socket+0x49>
	return alloc_sockfd(r);
  803281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803284:	89 c7                	mov    %eax,%edi
  803286:	48 b8 2b 2f 80 00 00 	movabs $0x802f2b,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
}
  803292:	c9                   	leaveq 
  803293:	c3                   	retq   

0000000000803294 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803294:	55                   	push   %rbp
  803295:	48 89 e5             	mov    %rsp,%rbp
  803298:	48 83 ec 10          	sub    $0x10,%rsp
  80329c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80329f:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  8032a6:	00 00 00 
  8032a9:	8b 00                	mov    (%rax),%eax
  8032ab:	85 c0                	test   %eax,%eax
  8032ad:	75 1d                	jne    8032cc <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8032af:	bf 02 00 00 00       	mov    $0x2,%edi
  8032b4:	48 b8 f3 41 80 00 00 	movabs $0x8041f3,%rax
  8032bb:	00 00 00 
  8032be:	ff d0                	callq  *%rax
  8032c0:	48 ba 2c 70 80 00 00 	movabs $0x80702c,%rdx
  8032c7:	00 00 00 
  8032ca:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032cc:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  8032d3:	00 00 00 
  8032d6:	8b 00                	mov    (%rax),%eax
  8032d8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032db:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032e0:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8032e7:	00 00 00 
  8032ea:	89 c7                	mov    %eax,%edi
  8032ec:	48 b8 30 41 80 00 00 	movabs $0x804130,%rax
  8032f3:	00 00 00 
  8032f6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8032f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8032fd:	be 00 00 00 00       	mov    $0x0,%esi
  803302:	bf 00 00 00 00       	mov    $0x0,%edi
  803307:	48 b8 70 40 80 00 00 	movabs $0x804070,%rax
  80330e:	00 00 00 
  803311:	ff d0                	callq  *%rax
}
  803313:	c9                   	leaveq 
  803314:	c3                   	retq   

0000000000803315 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803315:	55                   	push   %rbp
  803316:	48 89 e5             	mov    %rsp,%rbp
  803319:	48 83 ec 30          	sub    $0x30,%rsp
  80331d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803320:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803324:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803328:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80332f:	00 00 00 
  803332:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803335:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803337:	bf 01 00 00 00       	mov    $0x1,%edi
  80333c:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803343:	00 00 00 
  803346:	ff d0                	callq  *%rax
  803348:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80334b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334f:	78 3e                	js     80338f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803351:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803358:	00 00 00 
  80335b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80335f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803363:	8b 40 10             	mov    0x10(%rax),%eax
  803366:	89 c2                	mov    %eax,%edx
  803368:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80336c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803370:	48 89 ce             	mov    %rcx,%rsi
  803373:	48 89 c7             	mov    %rax,%rdi
  803376:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  80337d:	00 00 00 
  803380:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803386:	8b 50 10             	mov    0x10(%rax),%edx
  803389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80338d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80338f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803392:	c9                   	leaveq 
  803393:	c3                   	retq   

0000000000803394 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803394:	55                   	push   %rbp
  803395:	48 89 e5             	mov    %rsp,%rbp
  803398:	48 83 ec 10          	sub    $0x10,%rsp
  80339c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80339f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033a3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8033a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ad:	00 00 00 
  8033b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033b3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8033b5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033bc:	48 89 c6             	mov    %rax,%rsi
  8033bf:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8033c6:	00 00 00 
  8033c9:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  8033d0:	00 00 00 
  8033d3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8033d5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033dc:	00 00 00 
  8033df:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033e2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8033e5:	bf 02 00 00 00       	mov    $0x2,%edi
  8033ea:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  8033f1:	00 00 00 
  8033f4:	ff d0                	callq  *%rax
}
  8033f6:	c9                   	leaveq 
  8033f7:	c3                   	retq   

00000000008033f8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8033f8:	55                   	push   %rbp
  8033f9:	48 89 e5             	mov    %rsp,%rbp
  8033fc:	48 83 ec 10          	sub    $0x10,%rsp
  803400:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803403:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803406:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80340d:	00 00 00 
  803410:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803413:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803415:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80341c:	00 00 00 
  80341f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803422:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803425:	bf 03 00 00 00       	mov    $0x3,%edi
  80342a:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803431:	00 00 00 
  803434:	ff d0                	callq  *%rax
}
  803436:	c9                   	leaveq 
  803437:	c3                   	retq   

0000000000803438 <nsipc_close>:

int
nsipc_close(int s)
{
  803438:	55                   	push   %rbp
  803439:	48 89 e5             	mov    %rsp,%rbp
  80343c:	48 83 ec 10          	sub    $0x10,%rsp
  803440:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803443:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80344a:	00 00 00 
  80344d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803450:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803452:	bf 04 00 00 00       	mov    $0x4,%edi
  803457:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  80345e:	00 00 00 
  803461:	ff d0                	callq  *%rax
}
  803463:	c9                   	leaveq 
  803464:	c3                   	retq   

0000000000803465 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803465:	55                   	push   %rbp
  803466:	48 89 e5             	mov    %rsp,%rbp
  803469:	48 83 ec 10          	sub    $0x10,%rsp
  80346d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803470:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803474:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803477:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80347e:	00 00 00 
  803481:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803484:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803486:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348d:	48 89 c6             	mov    %rax,%rsi
  803490:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803497:	00 00 00 
  80349a:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8034a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ad:	00 00 00 
  8034b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034b3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8034b6:	bf 05 00 00 00       	mov    $0x5,%edi
  8034bb:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  8034c2:	00 00 00 
  8034c5:	ff d0                	callq  *%rax
}
  8034c7:	c9                   	leaveq 
  8034c8:	c3                   	retq   

00000000008034c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8034c9:	55                   	push   %rbp
  8034ca:	48 89 e5             	mov    %rsp,%rbp
  8034cd:	48 83 ec 10          	sub    $0x10,%rsp
  8034d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034d4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8034d7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034de:	00 00 00 
  8034e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034e4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8034e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ed:	00 00 00 
  8034f0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034f3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8034f6:	bf 06 00 00 00       	mov    $0x6,%edi
  8034fb:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803502:	00 00 00 
  803505:	ff d0                	callq  *%rax
}
  803507:	c9                   	leaveq 
  803508:	c3                   	retq   

0000000000803509 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803509:	55                   	push   %rbp
  80350a:	48 89 e5             	mov    %rsp,%rbp
  80350d:	48 83 ec 30          	sub    $0x30,%rsp
  803511:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803514:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803518:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80351b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80351e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803525:	00 00 00 
  803528:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80352b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80352d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803534:	00 00 00 
  803537:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80353a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80353d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803544:	00 00 00 
  803547:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80354a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80354d:	bf 07 00 00 00       	mov    $0x7,%edi
  803552:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803559:	00 00 00 
  80355c:	ff d0                	callq  *%rax
  80355e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803561:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803565:	78 69                	js     8035d0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803567:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80356e:	7f 08                	jg     803578 <nsipc_recv+0x6f>
  803570:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803573:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803576:	7e 35                	jle    8035ad <nsipc_recv+0xa4>
  803578:	48 b9 da 48 80 00 00 	movabs $0x8048da,%rcx
  80357f:	00 00 00 
  803582:	48 ba ef 48 80 00 00 	movabs $0x8048ef,%rdx
  803589:	00 00 00 
  80358c:	be 61 00 00 00       	mov    $0x61,%esi
  803591:	48 bf 04 49 80 00 00 	movabs $0x804904,%rdi
  803598:	00 00 00 
  80359b:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a0:	49 b8 5c 3f 80 00 00 	movabs $0x803f5c,%r8
  8035a7:	00 00 00 
  8035aa:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8035ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b0:	48 63 d0             	movslq %eax,%rdx
  8035b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035be:	00 00 00 
  8035c1:	48 89 c7             	mov    %rax,%rdi
  8035c4:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  8035cb:	00 00 00 
  8035ce:	ff d0                	callq  *%rax
	}

	return r;
  8035d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035d3:	c9                   	leaveq 
  8035d4:	c3                   	retq   

00000000008035d5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8035d5:	55                   	push   %rbp
  8035d6:	48 89 e5             	mov    %rsp,%rbp
  8035d9:	48 83 ec 20          	sub    $0x20,%rsp
  8035dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8035e7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8035ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f1:	00 00 00 
  8035f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035f7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8035f9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803600:	7e 35                	jle    803637 <nsipc_send+0x62>
  803602:	48 b9 10 49 80 00 00 	movabs $0x804910,%rcx
  803609:	00 00 00 
  80360c:	48 ba ef 48 80 00 00 	movabs $0x8048ef,%rdx
  803613:	00 00 00 
  803616:	be 6c 00 00 00       	mov    $0x6c,%esi
  80361b:	48 bf 04 49 80 00 00 	movabs $0x804904,%rdi
  803622:	00 00 00 
  803625:	b8 00 00 00 00       	mov    $0x0,%eax
  80362a:	49 b8 5c 3f 80 00 00 	movabs $0x803f5c,%r8
  803631:	00 00 00 
  803634:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803637:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80363a:	48 63 d0             	movslq %eax,%rdx
  80363d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803641:	48 89 c6             	mov    %rax,%rsi
  803644:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80364b:	00 00 00 
  80364e:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80365a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803661:	00 00 00 
  803664:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803667:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80366a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803671:	00 00 00 
  803674:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803677:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80367a:	bf 08 00 00 00       	mov    $0x8,%edi
  80367f:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803686:	00 00 00 
  803689:	ff d0                	callq  *%rax
}
  80368b:	c9                   	leaveq 
  80368c:	c3                   	retq   

000000000080368d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80368d:	55                   	push   %rbp
  80368e:	48 89 e5             	mov    %rsp,%rbp
  803691:	48 83 ec 10          	sub    $0x10,%rsp
  803695:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803698:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80369b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80369e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036a5:	00 00 00 
  8036a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036ab:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8036ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036b4:	00 00 00 
  8036b7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036ba:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8036bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036c4:	00 00 00 
  8036c7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8036ca:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8036cd:	bf 09 00 00 00       	mov    $0x9,%edi
  8036d2:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  8036d9:	00 00 00 
  8036dc:	ff d0                	callq  *%rax
}
  8036de:	c9                   	leaveq 
  8036df:	c3                   	retq   

00000000008036e0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036e0:	55                   	push   %rbp
  8036e1:	48 89 e5             	mov    %rsp,%rbp
  8036e4:	53                   	push   %rbx
  8036e5:	48 83 ec 38          	sub    $0x38,%rsp
  8036e9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8036ed:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8036f1:	48 89 c7             	mov    %rax,%rdi
  8036f4:	48 b8 12 1f 80 00 00 	movabs $0x801f12,%rax
  8036fb:	00 00 00 
  8036fe:	ff d0                	callq  *%rax
  803700:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803703:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803707:	0f 88 bf 01 00 00    	js     8038cc <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80370d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803711:	ba 07 04 00 00       	mov    $0x407,%edx
  803716:	48 89 c6             	mov    %rax,%rsi
  803719:	bf 00 00 00 00       	mov    $0x0,%edi
  80371e:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  803725:	00 00 00 
  803728:	ff d0                	callq  *%rax
  80372a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80372d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803731:	0f 88 95 01 00 00    	js     8038cc <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803737:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80373b:	48 89 c7             	mov    %rax,%rdi
  80373e:	48 b8 12 1f 80 00 00 	movabs $0x801f12,%rax
  803745:	00 00 00 
  803748:	ff d0                	callq  *%rax
  80374a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80374d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803751:	0f 88 5d 01 00 00    	js     8038b4 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803757:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80375b:	ba 07 04 00 00       	mov    $0x407,%edx
  803760:	48 89 c6             	mov    %rax,%rsi
  803763:	bf 00 00 00 00       	mov    $0x0,%edi
  803768:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  80376f:	00 00 00 
  803772:	ff d0                	callq  *%rax
  803774:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803777:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80377b:	0f 88 33 01 00 00    	js     8038b4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803785:	48 89 c7             	mov    %rax,%rdi
  803788:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  80378f:	00 00 00 
  803792:	ff d0                	callq  *%rax
  803794:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803798:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80379c:	ba 07 04 00 00       	mov    $0x407,%edx
  8037a1:	48 89 c6             	mov    %rax,%rsi
  8037a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a9:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  8037b0:	00 00 00 
  8037b3:	ff d0                	callq  *%rax
  8037b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037bc:	0f 88 d9 00 00 00    	js     80389b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c6:	48 89 c7             	mov    %rax,%rdi
  8037c9:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  8037d0:	00 00 00 
  8037d3:	ff d0                	callq  *%rax
  8037d5:	48 89 c2             	mov    %rax,%rdx
  8037d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037dc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8037e2:	48 89 d1             	mov    %rdx,%rcx
  8037e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8037ea:	48 89 c6             	mov    %rax,%rsi
  8037ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f2:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  8037f9:	00 00 00 
  8037fc:	ff d0                	callq  *%rax
  8037fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803801:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803805:	78 79                	js     803880 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803812:	00 00 00 
  803815:	8b 12                	mov    (%rdx),%edx
  803817:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803824:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803828:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80382f:	00 00 00 
  803832:	8b 12                	mov    (%rdx),%edx
  803834:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803836:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80383a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803845:	48 89 c7             	mov    %rax,%rdi
  803848:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  80384f:	00 00 00 
  803852:	ff d0                	callq  *%rax
  803854:	89 c2                	mov    %eax,%edx
  803856:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80385a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80385c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803860:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803864:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803868:	48 89 c7             	mov    %rax,%rdi
  80386b:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
  803877:	89 03                	mov    %eax,(%rbx)
	return 0;
  803879:	b8 00 00 00 00       	mov    $0x0,%eax
  80387e:	eb 4f                	jmp    8038cf <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803880:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803885:	48 89 c6             	mov    %rax,%rsi
  803888:	bf 00 00 00 00       	mov    $0x0,%edi
  80388d:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  803894:	00 00 00 
  803897:	ff d0                	callq  *%rax
  803899:	eb 01                	jmp    80389c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80389b:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80389c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038a0:	48 89 c6             	mov    %rax,%rsi
  8038a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a8:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  8038af:	00 00 00 
  8038b2:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8038b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b8:	48 89 c6             	mov    %rax,%rsi
  8038bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c0:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  8038c7:	00 00 00 
  8038ca:	ff d0                	callq  *%rax
    err:
	return r;
  8038cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038cf:	48 83 c4 38          	add    $0x38,%rsp
  8038d3:	5b                   	pop    %rbx
  8038d4:	5d                   	pop    %rbp
  8038d5:	c3                   	retq   

00000000008038d6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038d6:	55                   	push   %rbp
  8038d7:	48 89 e5             	mov    %rsp,%rbp
  8038da:	53                   	push   %rbx
  8038db:	48 83 ec 28          	sub    $0x28,%rsp
  8038df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038e7:	eb 01                	jmp    8038ea <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8038e9:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8038ea:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8038f1:	00 00 00 
  8038f4:	48 8b 00             	mov    (%rax),%rax
  8038f7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803900:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803904:	48 89 c7             	mov    %rax,%rdi
  803907:	48 b8 78 42 80 00 00 	movabs $0x804278,%rax
  80390e:	00 00 00 
  803911:	ff d0                	callq  *%rax
  803913:	89 c3                	mov    %eax,%ebx
  803915:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803919:	48 89 c7             	mov    %rax,%rdi
  80391c:	48 b8 78 42 80 00 00 	movabs $0x804278,%rax
  803923:	00 00 00 
  803926:	ff d0                	callq  *%rax
  803928:	39 c3                	cmp    %eax,%ebx
  80392a:	0f 94 c0             	sete   %al
  80392d:	0f b6 c0             	movzbl %al,%eax
  803930:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803933:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80393a:	00 00 00 
  80393d:	48 8b 00             	mov    (%rax),%rax
  803940:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803946:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803949:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80394c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80394f:	75 0a                	jne    80395b <_pipeisclosed+0x85>
			return ret;
  803951:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803954:	48 83 c4 28          	add    $0x28,%rsp
  803958:	5b                   	pop    %rbx
  803959:	5d                   	pop    %rbp
  80395a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80395b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80395e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803961:	74 86                	je     8038e9 <_pipeisclosed+0x13>
  803963:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803967:	75 80                	jne    8038e9 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803969:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803970:	00 00 00 
  803973:	48 8b 00             	mov    (%rax),%rax
  803976:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80397c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80397f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803982:	89 c6                	mov    %eax,%esi
  803984:	48 bf 21 49 80 00 00 	movabs $0x804921,%rdi
  80398b:	00 00 00 
  80398e:	b8 00 00 00 00       	mov    $0x0,%eax
  803993:	49 b8 af 03 80 00 00 	movabs $0x8003af,%r8
  80399a:	00 00 00 
  80399d:	41 ff d0             	callq  *%r8
	}
  8039a0:	e9 44 ff ff ff       	jmpq   8038e9 <_pipeisclosed+0x13>

00000000008039a5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8039a5:	55                   	push   %rbp
  8039a6:	48 89 e5             	mov    %rsp,%rbp
  8039a9:	48 83 ec 30          	sub    $0x30,%rsp
  8039ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039b0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8039b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8039b7:	48 89 d6             	mov    %rdx,%rsi
  8039ba:	89 c7                	mov    %eax,%edi
  8039bc:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  8039c3:	00 00 00 
  8039c6:	ff d0                	callq  *%rax
  8039c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cf:	79 05                	jns    8039d6 <pipeisclosed+0x31>
		return r;
  8039d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d4:	eb 31                	jmp    803a07 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8039d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039da:	48 89 c7             	mov    %rax,%rdi
  8039dd:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  8039e4:	00 00 00 
  8039e7:	ff d0                	callq  *%rax
  8039e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8039ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039f5:	48 89 d6             	mov    %rdx,%rsi
  8039f8:	48 89 c7             	mov    %rax,%rdi
  8039fb:	48 b8 d6 38 80 00 00 	movabs $0x8038d6,%rax
  803a02:	00 00 00 
  803a05:	ff d0                	callq  *%rax
}
  803a07:	c9                   	leaveq 
  803a08:	c3                   	retq   

0000000000803a09 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a09:	55                   	push   %rbp
  803a0a:	48 89 e5             	mov    %rsp,%rbp
  803a0d:	48 83 ec 40          	sub    $0x40,%rsp
  803a11:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a15:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a19:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a21:	48 89 c7             	mov    %rax,%rdi
  803a24:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
  803a30:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a3c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a43:	00 
  803a44:	e9 97 00 00 00       	jmpq   803ae0 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a49:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a4e:	74 09                	je     803a59 <devpipe_read+0x50>
				return i;
  803a50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a54:	e9 95 00 00 00       	jmpq   803aee <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a61:	48 89 d6             	mov    %rdx,%rsi
  803a64:	48 89 c7             	mov    %rax,%rdi
  803a67:	48 b8 d6 38 80 00 00 	movabs $0x8038d6,%rax
  803a6e:	00 00 00 
  803a71:	ff d0                	callq  *%rax
  803a73:	85 c0                	test   %eax,%eax
  803a75:	74 07                	je     803a7e <devpipe_read+0x75>
				return 0;
  803a77:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7c:	eb 70                	jmp    803aee <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a7e:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  803a85:	00 00 00 
  803a88:	ff d0                	callq  *%rax
  803a8a:	eb 01                	jmp    803a8d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a8c:	90                   	nop
  803a8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a91:	8b 10                	mov    (%rax),%edx
  803a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a97:	8b 40 04             	mov    0x4(%rax),%eax
  803a9a:	39 c2                	cmp    %eax,%edx
  803a9c:	74 ab                	je     803a49 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aa2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803aa6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aae:	8b 00                	mov    (%rax),%eax
  803ab0:	89 c2                	mov    %eax,%edx
  803ab2:	c1 fa 1f             	sar    $0x1f,%edx
  803ab5:	c1 ea 1b             	shr    $0x1b,%edx
  803ab8:	01 d0                	add    %edx,%eax
  803aba:	83 e0 1f             	and    $0x1f,%eax
  803abd:	29 d0                	sub    %edx,%eax
  803abf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac3:	48 98                	cltq   
  803ac5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803aca:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803acc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad0:	8b 00                	mov    (%rax),%eax
  803ad2:	8d 50 01             	lea    0x1(%rax),%edx
  803ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803adb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ae8:	72 a2                	jb     803a8c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803aea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803aee:	c9                   	leaveq 
  803aef:	c3                   	retq   

0000000000803af0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803af0:	55                   	push   %rbp
  803af1:	48 89 e5             	mov    %rsp,%rbp
  803af4:	48 83 ec 40          	sub    $0x40,%rsp
  803af8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803afc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b00:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b08:	48 89 c7             	mov    %rax,%rdi
  803b0b:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  803b12:	00 00 00 
  803b15:	ff d0                	callq  *%rax
  803b17:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b23:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b2a:	00 
  803b2b:	e9 93 00 00 00       	jmpq   803bc3 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b38:	48 89 d6             	mov    %rdx,%rsi
  803b3b:	48 89 c7             	mov    %rax,%rdi
  803b3e:	48 b8 d6 38 80 00 00 	movabs $0x8038d6,%rax
  803b45:	00 00 00 
  803b48:	ff d0                	callq  *%rax
  803b4a:	85 c0                	test   %eax,%eax
  803b4c:	74 07                	je     803b55 <devpipe_write+0x65>
				return 0;
  803b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803b53:	eb 7c                	jmp    803bd1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b55:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  803b5c:	00 00 00 
  803b5f:	ff d0                	callq  *%rax
  803b61:	eb 01                	jmp    803b64 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b63:	90                   	nop
  803b64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b68:	8b 40 04             	mov    0x4(%rax),%eax
  803b6b:	48 63 d0             	movslq %eax,%rdx
  803b6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b72:	8b 00                	mov    (%rax),%eax
  803b74:	48 98                	cltq   
  803b76:	48 83 c0 20          	add    $0x20,%rax
  803b7a:	48 39 c2             	cmp    %rax,%rdx
  803b7d:	73 b1                	jae    803b30 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b83:	8b 40 04             	mov    0x4(%rax),%eax
  803b86:	89 c2                	mov    %eax,%edx
  803b88:	c1 fa 1f             	sar    $0x1f,%edx
  803b8b:	c1 ea 1b             	shr    $0x1b,%edx
  803b8e:	01 d0                	add    %edx,%eax
  803b90:	83 e0 1f             	and    $0x1f,%eax
  803b93:	29 d0                	sub    %edx,%eax
  803b95:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b9d:	48 01 ca             	add    %rcx,%rdx
  803ba0:	0f b6 0a             	movzbl (%rdx),%ecx
  803ba3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ba7:	48 98                	cltq   
  803ba9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803bad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb1:	8b 40 04             	mov    0x4(%rax),%eax
  803bb4:	8d 50 01             	lea    0x1(%rax),%edx
  803bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803bbe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803bc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bcb:	72 96                	jb     803b63 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bd1:	c9                   	leaveq 
  803bd2:	c3                   	retq   

0000000000803bd3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803bd3:	55                   	push   %rbp
  803bd4:	48 89 e5             	mov    %rsp,%rbp
  803bd7:	48 83 ec 20          	sub    $0x20,%rsp
  803bdb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bdf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803be7:	48 89 c7             	mov    %rax,%rdi
  803bea:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  803bf1:	00 00 00 
  803bf4:	ff d0                	callq  *%rax
  803bf6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803bfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bfe:	48 be 34 49 80 00 00 	movabs $0x804934,%rsi
  803c05:	00 00 00 
  803c08:	48 89 c7             	mov    %rax,%rdi
  803c0b:	48 b8 6c 0f 80 00 00 	movabs $0x800f6c,%rax
  803c12:	00 00 00 
  803c15:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c1b:	8b 50 04             	mov    0x4(%rax),%edx
  803c1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c22:	8b 00                	mov    (%rax),%eax
  803c24:	29 c2                	sub    %eax,%edx
  803c26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c2a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c34:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c3b:	00 00 00 
	stat->st_dev = &devpipe;
  803c3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c42:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c49:	00 00 00 
  803c4c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803c53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c58:	c9                   	leaveq 
  803c59:	c3                   	retq   

0000000000803c5a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c5a:	55                   	push   %rbp
  803c5b:	48 89 e5             	mov    %rsp,%rbp
  803c5e:	48 83 ec 10          	sub    $0x10,%rsp
  803c62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c6a:	48 89 c6             	mov    %rax,%rsi
  803c6d:	bf 00 00 00 00       	mov    $0x0,%edi
  803c72:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  803c79:	00 00 00 
  803c7c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c82:	48 89 c7             	mov    %rax,%rdi
  803c85:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  803c8c:	00 00 00 
  803c8f:	ff d0                	callq  *%rax
  803c91:	48 89 c6             	mov    %rax,%rsi
  803c94:	bf 00 00 00 00       	mov    $0x0,%edi
  803c99:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  803ca0:	00 00 00 
  803ca3:	ff d0                	callq  *%rax
}
  803ca5:	c9                   	leaveq 
  803ca6:	c3                   	retq   
	...

0000000000803ca8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ca8:	55                   	push   %rbp
  803ca9:	48 89 e5             	mov    %rsp,%rbp
  803cac:	48 83 ec 20          	sub    $0x20,%rsp
  803cb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803cb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803cb9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803cbd:	be 01 00 00 00       	mov    $0x1,%esi
  803cc2:	48 89 c7             	mov    %rax,%rdi
  803cc5:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  803ccc:	00 00 00 
  803ccf:	ff d0                	callq  *%rax
}
  803cd1:	c9                   	leaveq 
  803cd2:	c3                   	retq   

0000000000803cd3 <getchar>:

int
getchar(void)
{
  803cd3:	55                   	push   %rbp
  803cd4:	48 89 e5             	mov    %rsp,%rbp
  803cd7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803cdb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803cdf:	ba 01 00 00 00       	mov    $0x1,%edx
  803ce4:	48 89 c6             	mov    %rax,%rsi
  803ce7:	bf 00 00 00 00       	mov    $0x0,%edi
  803cec:	48 b8 dc 23 80 00 00 	movabs $0x8023dc,%rax
  803cf3:	00 00 00 
  803cf6:	ff d0                	callq  *%rax
  803cf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803cfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cff:	79 05                	jns    803d06 <getchar+0x33>
		return r;
  803d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d04:	eb 14                	jmp    803d1a <getchar+0x47>
	if (r < 1)
  803d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0a:	7f 07                	jg     803d13 <getchar+0x40>
		return -E_EOF;
  803d0c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d11:	eb 07                	jmp    803d1a <getchar+0x47>
	return c;
  803d13:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d17:	0f b6 c0             	movzbl %al,%eax
}
  803d1a:	c9                   	leaveq 
  803d1b:	c3                   	retq   

0000000000803d1c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d1c:	55                   	push   %rbp
  803d1d:	48 89 e5             	mov    %rsp,%rbp
  803d20:	48 83 ec 20          	sub    $0x20,%rsp
  803d24:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d27:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d2e:	48 89 d6             	mov    %rdx,%rsi
  803d31:	89 c7                	mov    %eax,%edi
  803d33:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  803d3a:	00 00 00 
  803d3d:	ff d0                	callq  *%rax
  803d3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d46:	79 05                	jns    803d4d <iscons+0x31>
		return r;
  803d48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4b:	eb 1a                	jmp    803d67 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d51:	8b 10                	mov    (%rax),%edx
  803d53:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803d5a:	00 00 00 
  803d5d:	8b 00                	mov    (%rax),%eax
  803d5f:	39 c2                	cmp    %eax,%edx
  803d61:	0f 94 c0             	sete   %al
  803d64:	0f b6 c0             	movzbl %al,%eax
}
  803d67:	c9                   	leaveq 
  803d68:	c3                   	retq   

0000000000803d69 <opencons>:

int
opencons(void)
{
  803d69:	55                   	push   %rbp
  803d6a:	48 89 e5             	mov    %rsp,%rbp
  803d6d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d71:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d75:	48 89 c7             	mov    %rax,%rdi
  803d78:	48 b8 12 1f 80 00 00 	movabs $0x801f12,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
  803d84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d8b:	79 05                	jns    803d92 <opencons+0x29>
		return r;
  803d8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d90:	eb 5b                	jmp    803ded <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d96:	ba 07 04 00 00       	mov    $0x407,%edx
  803d9b:	48 89 c6             	mov    %rax,%rsi
  803d9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803da3:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
  803daf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db6:	79 05                	jns    803dbd <opencons+0x54>
		return r;
  803db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbb:	eb 30                	jmp    803ded <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803dbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803dc8:	00 00 00 
  803dcb:	8b 12                	mov    (%rdx),%edx
  803dcd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803dcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dde:	48 89 c7             	mov    %rax,%rdi
  803de1:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803de8:	00 00 00 
  803deb:	ff d0                	callq  *%rax
}
  803ded:	c9                   	leaveq 
  803dee:	c3                   	retq   

0000000000803def <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803def:	55                   	push   %rbp
  803df0:	48 89 e5             	mov    %rsp,%rbp
  803df3:	48 83 ec 30          	sub    $0x30,%rsp
  803df7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803dfb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e03:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e08:	75 13                	jne    803e1d <devcons_read+0x2e>
		return 0;
  803e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0f:	eb 49                	jmp    803e5a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e11:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  803e18:	00 00 00 
  803e1b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e1d:	48 b8 a6 17 80 00 00 	movabs $0x8017a6,%rax
  803e24:	00 00 00 
  803e27:	ff d0                	callq  *%rax
  803e29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e30:	74 df                	je     803e11 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803e32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e36:	79 05                	jns    803e3d <devcons_read+0x4e>
		return c;
  803e38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3b:	eb 1d                	jmp    803e5a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803e3d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803e41:	75 07                	jne    803e4a <devcons_read+0x5b>
		return 0;
  803e43:	b8 00 00 00 00       	mov    $0x0,%eax
  803e48:	eb 10                	jmp    803e5a <devcons_read+0x6b>
	*(char*)vbuf = c;
  803e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e4d:	89 c2                	mov    %eax,%edx
  803e4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e53:	88 10                	mov    %dl,(%rax)
	return 1;
  803e55:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e5a:	c9                   	leaveq 
  803e5b:	c3                   	retq   

0000000000803e5c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e5c:	55                   	push   %rbp
  803e5d:	48 89 e5             	mov    %rsp,%rbp
  803e60:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e67:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e6e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e75:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e83:	eb 77                	jmp    803efc <devcons_write+0xa0>
		m = n - tot;
  803e85:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e8c:	89 c2                	mov    %eax,%edx
  803e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e91:	89 d1                	mov    %edx,%ecx
  803e93:	29 c1                	sub    %eax,%ecx
  803e95:	89 c8                	mov    %ecx,%eax
  803e97:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e9d:	83 f8 7f             	cmp    $0x7f,%eax
  803ea0:	76 07                	jbe    803ea9 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803ea2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ea9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803eac:	48 63 d0             	movslq %eax,%rdx
  803eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb2:	48 98                	cltq   
  803eb4:	48 89 c1             	mov    %rax,%rcx
  803eb7:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803ebe:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ec5:	48 89 ce             	mov    %rcx,%rsi
  803ec8:	48 89 c7             	mov    %rax,%rdi
  803ecb:	48 b8 8e 12 80 00 00 	movabs $0x80128e,%rax
  803ed2:	00 00 00 
  803ed5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ed7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803eda:	48 63 d0             	movslq %eax,%rdx
  803edd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ee4:	48 89 d6             	mov    %rdx,%rsi
  803ee7:	48 89 c7             	mov    %rax,%rdi
  803eea:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  803ef1:	00 00 00 
  803ef4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ef6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ef9:	01 45 fc             	add    %eax,-0x4(%rbp)
  803efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eff:	48 98                	cltq   
  803f01:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f08:	0f 82 77 ff ff ff    	jb     803e85 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f11:	c9                   	leaveq 
  803f12:	c3                   	retq   

0000000000803f13 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f13:	55                   	push   %rbp
  803f14:	48 89 e5             	mov    %rsp,%rbp
  803f17:	48 83 ec 08          	sub    $0x8,%rsp
  803f1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f24:	c9                   	leaveq 
  803f25:	c3                   	retq   

0000000000803f26 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f26:	55                   	push   %rbp
  803f27:	48 89 e5             	mov    %rsp,%rbp
  803f2a:	48 83 ec 10          	sub    $0x10,%rsp
  803f2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803f36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f3a:	48 be 40 49 80 00 00 	movabs $0x804940,%rsi
  803f41:	00 00 00 
  803f44:	48 89 c7             	mov    %rax,%rdi
  803f47:	48 b8 6c 0f 80 00 00 	movabs $0x800f6c,%rax
  803f4e:	00 00 00 
  803f51:	ff d0                	callq  *%rax
	return 0;
  803f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f58:	c9                   	leaveq 
  803f59:	c3                   	retq   
	...

0000000000803f5c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803f5c:	55                   	push   %rbp
  803f5d:	48 89 e5             	mov    %rsp,%rbp
  803f60:	53                   	push   %rbx
  803f61:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803f68:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803f6f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803f75:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803f7c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803f83:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803f8a:	84 c0                	test   %al,%al
  803f8c:	74 23                	je     803fb1 <_panic+0x55>
  803f8e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803f95:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803f99:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803f9d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803fa1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803fa5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803fa9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803fad:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803fb1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803fb8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803fbf:	00 00 00 
  803fc2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803fc9:	00 00 00 
  803fcc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803fd0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803fd7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803fde:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803fe5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803fec:	00 00 00 
  803fef:	48 8b 18             	mov    (%rax),%rbx
  803ff2:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  803ff9:	00 00 00 
  803ffc:	ff d0                	callq  *%rax
  803ffe:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804004:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80400b:	41 89 c8             	mov    %ecx,%r8d
  80400e:	48 89 d1             	mov    %rdx,%rcx
  804011:	48 89 da             	mov    %rbx,%rdx
  804014:	89 c6                	mov    %eax,%esi
  804016:	48 bf 48 49 80 00 00 	movabs $0x804948,%rdi
  80401d:	00 00 00 
  804020:	b8 00 00 00 00       	mov    $0x0,%eax
  804025:	49 b9 af 03 80 00 00 	movabs $0x8003af,%r9
  80402c:	00 00 00 
  80402f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  804032:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804039:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804040:	48 89 d6             	mov    %rdx,%rsi
  804043:	48 89 c7             	mov    %rax,%rdi
  804046:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  80404d:	00 00 00 
  804050:	ff d0                	callq  *%rax
	cprintf("\n");
  804052:	48 bf 6b 49 80 00 00 	movabs $0x80496b,%rdi
  804059:	00 00 00 
  80405c:	b8 00 00 00 00       	mov    $0x0,%eax
  804061:	48 ba af 03 80 00 00 	movabs $0x8003af,%rdx
  804068:	00 00 00 
  80406b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80406d:	cc                   	int3   
  80406e:	eb fd                	jmp    80406d <_panic+0x111>

0000000000804070 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804070:	55                   	push   %rbp
  804071:	48 89 e5             	mov    %rsp,%rbp
  804074:	48 83 ec 30          	sub    $0x30,%rsp
  804078:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80407c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804080:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  804084:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804089:	74 18                	je     8040a3 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80408b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80408f:	48 89 c7             	mov    %rax,%rdi
  804092:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  804099:	00 00 00 
  80409c:	ff d0                	callq  *%rax
  80409e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a1:	eb 19                	jmp    8040bc <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  8040a3:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8040aa:	00 00 00 
  8040ad:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  8040b4:	00 00 00 
  8040b7:	ff d0                	callq  *%rax
  8040b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8040bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040c0:	79 19                	jns    8040db <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8040c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040c6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8040cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8040d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d9:	eb 53                	jmp    80412e <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8040db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040e0:	74 19                	je     8040fb <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8040e2:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8040e9:	00 00 00 
  8040ec:	48 8b 00             	mov    (%rax),%rax
  8040ef:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8040f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f9:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8040fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804100:	74 19                	je     80411b <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  804102:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  804109:	00 00 00 
  80410c:	48 8b 00             	mov    (%rax),%rax
  80410f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804115:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804119:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80411b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  804122:	00 00 00 
  804125:	48 8b 00             	mov    (%rax),%rax
  804128:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80412e:	c9                   	leaveq 
  80412f:	c3                   	retq   

0000000000804130 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804130:	55                   	push   %rbp
  804131:	48 89 e5             	mov    %rsp,%rbp
  804134:	48 83 ec 30          	sub    $0x30,%rsp
  804138:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80413b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80413e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804142:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  804145:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  80414c:	e9 96 00 00 00       	jmpq   8041e7 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  804151:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804156:	74 20                	je     804178 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  804158:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80415b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80415e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804165:	89 c7                	mov    %eax,%edi
  804167:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80416e:	00 00 00 
  804171:	ff d0                	callq  *%rax
  804173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804176:	eb 2d                	jmp    8041a5 <ipc_send+0x75>
		else if(pg==NULL)
  804178:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80417d:	75 26                	jne    8041a5 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80417f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804182:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804185:	b9 00 00 00 00       	mov    $0x0,%ecx
  80418a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804191:	00 00 00 
  804194:	89 c7                	mov    %eax,%edi
  804196:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80419d:	00 00 00 
  8041a0:	ff d0                	callq  *%rax
  8041a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8041a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041a9:	79 30                	jns    8041db <ipc_send+0xab>
  8041ab:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8041af:	74 2a                	je     8041db <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8041b1:	48 ba 6d 49 80 00 00 	movabs $0x80496d,%rdx
  8041b8:	00 00 00 
  8041bb:	be 40 00 00 00       	mov    $0x40,%esi
  8041c0:	48 bf 85 49 80 00 00 	movabs $0x804985,%rdi
  8041c7:	00 00 00 
  8041ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8041cf:	48 b9 5c 3f 80 00 00 	movabs $0x803f5c,%rcx
  8041d6:	00 00 00 
  8041d9:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8041db:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  8041e2:	00 00 00 
  8041e5:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8041e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041eb:	0f 85 60 ff ff ff    	jne    804151 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8041f1:	c9                   	leaveq 
  8041f2:	c3                   	retq   

00000000008041f3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041f3:	55                   	push   %rbp
  8041f4:	48 89 e5             	mov    %rsp,%rbp
  8041f7:	48 83 ec 18          	sub    $0x18,%rsp
  8041fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8041fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804205:	eb 5e                	jmp    804265 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804207:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80420e:	00 00 00 
  804211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804214:	48 63 d0             	movslq %eax,%rdx
  804217:	48 89 d0             	mov    %rdx,%rax
  80421a:	48 c1 e0 03          	shl    $0x3,%rax
  80421e:	48 01 d0             	add    %rdx,%rax
  804221:	48 c1 e0 05          	shl    $0x5,%rax
  804225:	48 01 c8             	add    %rcx,%rax
  804228:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80422e:	8b 00                	mov    (%rax),%eax
  804230:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804233:	75 2c                	jne    804261 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804235:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80423c:	00 00 00 
  80423f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804242:	48 63 d0             	movslq %eax,%rdx
  804245:	48 89 d0             	mov    %rdx,%rax
  804248:	48 c1 e0 03          	shl    $0x3,%rax
  80424c:	48 01 d0             	add    %rdx,%rax
  80424f:	48 c1 e0 05          	shl    $0x5,%rax
  804253:	48 01 c8             	add    %rcx,%rax
  804256:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80425c:	8b 40 08             	mov    0x8(%rax),%eax
  80425f:	eb 12                	jmp    804273 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804261:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804265:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80426c:	7e 99                	jle    804207 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80426e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804273:	c9                   	leaveq 
  804274:	c3                   	retq   
  804275:	00 00                	add    %al,(%rax)
	...

0000000000804278 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804278:	55                   	push   %rbp
  804279:	48 89 e5             	mov    %rsp,%rbp
  80427c:	48 83 ec 18          	sub    $0x18,%rsp
  804280:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804288:	48 89 c2             	mov    %rax,%rdx
  80428b:	48 c1 ea 15          	shr    $0x15,%rdx
  80428f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804296:	01 00 00 
  804299:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80429d:	83 e0 01             	and    $0x1,%eax
  8042a0:	48 85 c0             	test   %rax,%rax
  8042a3:	75 07                	jne    8042ac <pageref+0x34>
		return 0;
  8042a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8042aa:	eb 53                	jmp    8042ff <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8042ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042b0:	48 89 c2             	mov    %rax,%rdx
  8042b3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8042b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8042be:	01 00 00 
  8042c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8042c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042cd:	83 e0 01             	and    $0x1,%eax
  8042d0:	48 85 c0             	test   %rax,%rax
  8042d3:	75 07                	jne    8042dc <pageref+0x64>
		return 0;
  8042d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8042da:	eb 23                	jmp    8042ff <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e0:	48 89 c2             	mov    %rax,%rdx
  8042e3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8042e7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042ee:	00 00 00 
  8042f1:	48 c1 e2 04          	shl    $0x4,%rdx
  8042f5:	48 01 d0             	add    %rdx,%rax
  8042f8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042fc:	0f b7 c0             	movzwl %ax,%eax
}
  8042ff:	c9                   	leaveq 
  804300:	c3                   	retq   
