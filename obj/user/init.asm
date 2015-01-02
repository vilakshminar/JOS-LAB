
obj/user/init.debug:     file format elf64-x86-64


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
  80003c:	e8 47 06 00 00       	callq  800688 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800050:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800053:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  80005a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800061:	eb 1a                	jmp    80007d <sum+0x39>
		tot ^= i * s[i];
  800063:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800066:	48 98                	cltq   
  800068:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80006c:	0f b6 00             	movzbl (%rax),%eax
  80006f:	0f be c0             	movsbl %al,%eax
  800072:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800076:	31 45 f8             	xor    %eax,-0x8(%rbp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800079:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80007d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800080:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800083:	7c de                	jl     800063 <sum+0x1f>
		tot ^= i * s[i];
	return tot;
  800085:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800088:	c9                   	leaveq 
  800089:	c3                   	retq   

000000000080008a <umain>:

void
umain(int argc, char **argv)
{
  80008a:	55                   	push   %rbp
  80008b:	48 89 e5             	mov    %rsp,%rbp
  80008e:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800095:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009b:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a2:	48 bf e0 4b 80 00 00 	movabs $0x804be0,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  8000b8:	00 00 00 
  8000bb:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000bd:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c4:	be 70 17 00 00       	mov    $0x1770,%esi
  8000c9:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8000d0:	00 00 00 
  8000d3:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8000da:	00 00 00 
  8000dd:	ff d0                	callq  *%rax
  8000df:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e5:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000e8:	74 25                	je     80010f <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f0:	89 c6                	mov    %eax,%esi
  8000f2:	48 bf f0 4b 80 00 00 	movabs $0x804bf0,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 b9 8b 09 80 00 00 	movabs $0x80098b,%rcx
  800108:	00 00 00 
  80010b:	ff d1                	callq  *%rcx
  80010d:	eb 1b                	jmp    80012a <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  80010f:	48 bf 29 4c 80 00 00 	movabs $0x804c29,%rdi
  800116:	00 00 00 
  800119:	b8 00 00 00 00       	mov    $0x0,%eax
  80011e:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  800125:	00 00 00 
  800128:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012a:	be 70 17 00 00       	mov    $0x1770,%esi
  80012f:	48 bf 60 90 80 00 00 	movabs $0x809060,%rdi
  800136:	00 00 00 
  800139:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800140:	00 00 00 
  800143:	ff d0                	callq  *%rax
  800145:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800148:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014c:	74 22                	je     800170 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  80014e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800151:	89 c6                	mov    %eax,%esi
  800153:	48 bf 40 4c 80 00 00 	movabs $0x804c40,%rdi
  80015a:	00 00 00 
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  800169:	00 00 00 
  80016c:	ff d2                	callq  *%rdx
  80016e:	eb 1b                	jmp    80018b <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800170:	48 bf 6f 4c 80 00 00 	movabs $0x804c6f,%rdi
  800177:	00 00 00 
  80017a:	b8 00 00 00 00       	mov    $0x0,%eax
  80017f:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  800186:	00 00 00 
  800189:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800192:	48 be 85 4c 80 00 00 	movabs $0x804c85,%rsi
  800199:	00 00 00 
  80019c:	48 89 c7             	mov    %rax,%rdi
  80019f:	48 b8 8e 15 80 00 00 	movabs $0x80158e,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b2:	eb 70                	jmp    800224 <umain+0x19a>
		strcat(args, " '");
  8001b4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001bb:	48 be 91 4c 80 00 00 	movabs $0x804c91,%rsi
  8001c2:	00 00 00 
  8001c5:	48 89 c7             	mov    %rax,%rdi
  8001c8:	48 b8 8e 15 80 00 00 	movabs $0x80158e,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d7:	48 98                	cltq   
  8001d9:	48 c1 e0 03          	shl    $0x3,%rax
  8001dd:	48 03 85 e0 fe ff ff 	add    -0x120(%rbp),%rax
  8001e4:	48 8b 10             	mov    (%rax),%rdx
  8001e7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001ee:	48 89 d6             	mov    %rdx,%rsi
  8001f1:	48 89 c7             	mov    %rax,%rdi
  8001f4:	48 b8 8e 15 80 00 00 	movabs $0x80158e,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
		strcat(args, "'");
  800200:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800207:	48 be 94 4c 80 00 00 	movabs $0x804c94,%rsi
  80020e:	00 00 00 
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 8e 15 80 00 00 	movabs $0x80158e,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  800220:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800227:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  80022d:	7c 85                	jl     8001b4 <umain+0x12a>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80022f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800236:	48 89 c6             	mov    %rax,%rsi
  800239:	48 bf 96 4c 80 00 00 	movabs $0x804c96,%rdi
  800240:	00 00 00 
  800243:	b8 00 00 00 00       	mov    $0x0,%eax
  800248:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  80024f:	00 00 00 
  800252:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800254:	48 bf 9a 4c 80 00 00 	movabs $0x804c9a,%rdi
  80025b:	00 00 00 
  80025e:	b8 00 00 00 00       	mov    $0x0,%eax
  800263:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  80026a:	00 00 00 
  80026d:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80026f:	bf 00 00 00 00       	mov    $0x0,%edi
  800274:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800280:	48 b8 95 04 80 00 00 	movabs $0x800495,%rax
  800287:	00 00 00 
  80028a:	ff d0                	callq  *%rax
  80028c:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80028f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800293:	79 30                	jns    8002c5 <umain+0x23b>
		panic("opencons: %e", r);
  800295:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	48 ba ac 4c 80 00 00 	movabs $0x804cac,%rdx
  8002a1:	00 00 00 
  8002a4:	be 37 00 00 00       	mov    $0x37,%esi
  8002a9:	48 bf b9 4c 80 00 00 	movabs $0x804cb9,%rdi
  8002b0:	00 00 00 
  8002b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b8:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8002bf:	00 00 00 
  8002c2:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002c9:	74 30                	je     8002fb <umain+0x271>
		panic("first opencons used fd %d", r);
  8002cb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	48 ba c5 4c 80 00 00 	movabs $0x804cc5,%rdx
  8002d7:	00 00 00 
  8002da:	be 39 00 00 00       	mov    $0x39,%esi
  8002df:	48 bf b9 4c 80 00 00 	movabs $0x804cb9,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8002f5:	00 00 00 
  8002f8:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8002fb:	be 01 00 00 00       	mov    $0x1,%esi
  800300:	bf 00 00 00 00       	mov    $0x0,%edi
  800305:	48 b8 2f 25 80 00 00 	movabs $0x80252f,%rax
  80030c:	00 00 00 
  80030f:	ff d0                	callq  *%rax
  800311:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800314:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800318:	79 30                	jns    80034a <umain+0x2c0>
		panic("dup: %e", r);
  80031a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80031d:	89 c1                	mov    %eax,%ecx
  80031f:	48 ba df 4c 80 00 00 	movabs $0x804cdf,%rdx
  800326:	00 00 00 
  800329:	be 3b 00 00 00       	mov    $0x3b,%esi
  80032e:	48 bf b9 4c 80 00 00 	movabs $0x804cb9,%rdi
  800335:	00 00 00 
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  800344:	00 00 00 
  800347:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  80034a:	48 bf e7 4c 80 00 00 	movabs $0x804ce7,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  800360:	00 00 00 
  800363:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800365:	ba 00 00 00 00       	mov    $0x0,%edx
  80036a:	48 be fa 4c 80 00 00 	movabs $0x804cfa,%rsi
  800371:	00 00 00 
  800374:	48 bf fd 4c 80 00 00 	movabs $0x804cfd,%rdi
  80037b:	00 00 00 
  80037e:	b8 00 00 00 00       	mov    $0x0,%eax
  800383:	48 b9 35 32 80 00 00 	movabs $0x803235,%rcx
  80038a:	00 00 00 
  80038d:	ff d1                	callq  *%rcx
  80038f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  800392:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800396:	79 23                	jns    8003bb <umain+0x331>
			cprintf("init: spawn sh: %e\n", r);
  800398:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80039b:	89 c6                	mov    %eax,%esi
  80039d:	48 bf 05 4d 80 00 00 	movabs $0x804d05,%rdi
  8003a4:	00 00 00 
  8003a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ac:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  8003b3:	00 00 00 
  8003b6:	ff d2                	callq  *%rdx
			continue;
  8003b8:	90                   	nop
		}
		wait(r);
	}
  8003b9:	eb 8f                	jmp    80034a <umain+0x2c0>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		wait(r);
  8003bb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 a8 48 80 00 00 	movabs $0x8048a8,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
	}
  8003cc:	e9 79 ff ff ff       	jmpq   80034a <umain+0x2c0>
  8003d1:	00 00                	add    %al,(%rax)
	...

00000000008003d4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003d4:	55                   	push   %rbp
  8003d5:	48 89 e5             	mov    %rsp,%rbp
  8003d8:	48 83 ec 20          	sub    $0x20,%rsp
  8003dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8003e5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8003e9:	be 01 00 00 00       	mov    $0x1,%esi
  8003ee:	48 89 c7             	mov    %rax,%rdi
  8003f1:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  8003f8:	00 00 00 
  8003fb:	ff d0                	callq  *%rax
}
  8003fd:	c9                   	leaveq 
  8003fe:	c3                   	retq   

00000000008003ff <getchar>:

int
getchar(void)
{
  8003ff:	55                   	push   %rbp
  800400:	48 89 e5             	mov    %rsp,%rbp
  800403:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800407:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80040b:	ba 01 00 00 00       	mov    $0x1,%edx
  800410:	48 89 c6             	mov    %rax,%rsi
  800413:	bf 00 00 00 00       	mov    $0x0,%edi
  800418:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  80041f:	00 00 00 
  800422:	ff d0                	callq  *%rax
  800424:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800427:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80042b:	79 05                	jns    800432 <getchar+0x33>
		return r;
  80042d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800430:	eb 14                	jmp    800446 <getchar+0x47>
	if (r < 1)
  800432:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800436:	7f 07                	jg     80043f <getchar+0x40>
		return -E_EOF;
  800438:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80043d:	eb 07                	jmp    800446 <getchar+0x47>
	return c;
  80043f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800443:	0f b6 c0             	movzbl %al,%eax
}
  800446:	c9                   	leaveq 
  800447:	c3                   	retq   

0000000000800448 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800448:	55                   	push   %rbp
  800449:	48 89 e5             	mov    %rsp,%rbp
  80044c:	48 83 ec 20          	sub    $0x20,%rsp
  800450:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800453:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800457:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80045a:	48 89 d6             	mov    %rdx,%rsi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
  80046b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80046e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800472:	79 05                	jns    800479 <iscons+0x31>
		return r;
  800474:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800477:	eb 1a                	jmp    800493 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047d:	8b 10                	mov    (%rax),%edx
  80047f:	48 b8 80 87 80 00 00 	movabs $0x808780,%rax
  800486:	00 00 00 
  800489:	8b 00                	mov    (%rax),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	0f 94 c0             	sete   %al
  800490:	0f b6 c0             	movzbl %al,%eax
}
  800493:	c9                   	leaveq 
  800494:	c3                   	retq   

0000000000800495 <opencons>:

int
opencons(void)
{
  800495:	55                   	push   %rbp
  800496:	48 89 e5             	mov    %rsp,%rbp
  800499:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80049d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004a1:	48 89 c7             	mov    %rax,%rdi
  8004a4:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004b7:	79 05                	jns    8004be <opencons+0x29>
		return r;
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	eb 5b                	jmp    800519 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c2:	ba 07 04 00 00       	mov    $0x407,%edx
  8004c7:	48 89 c6             	mov    %rax,%rsi
  8004ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8004cf:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8004d6:	00 00 00 
  8004d9:	ff d0                	callq  *%rax
  8004db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004e2:	79 05                	jns    8004e9 <opencons+0x54>
		return r;
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	eb 30                	jmp    800519 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8004e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ed:	48 ba 80 87 80 00 00 	movabs $0x808780,%rdx
  8004f4:	00 00 00 
  8004f7:	8b 12                	mov    (%rdx),%edx
  8004f9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8004fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050a:	48 89 c7             	mov    %rax,%rdi
  80050d:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  800514:	00 00 00 
  800517:	ff d0                	callq  *%rax
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 30          	sub    $0x30,%rsp
  800523:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800527:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80052b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80052f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800534:	75 13                	jne    800549 <devcons_read+0x2e>
		return 0;
  800536:	b8 00 00 00 00       	mov    $0x0,%eax
  80053b:	eb 49                	jmp    800586 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80053d:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  800544:	00 00 00 
  800547:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800549:	48 b8 82 1d 80 00 00 	movabs $0x801d82,%rax
  800550:	00 00 00 
  800553:	ff d0                	callq  *%rax
  800555:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800558:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80055c:	74 df                	je     80053d <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80055e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800562:	79 05                	jns    800569 <devcons_read+0x4e>
		return c;
  800564:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800567:	eb 1d                	jmp    800586 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  800569:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80056d:	75 07                	jne    800576 <devcons_read+0x5b>
		return 0;
  80056f:	b8 00 00 00 00       	mov    $0x0,%eax
  800574:	eb 10                	jmp    800586 <devcons_read+0x6b>
	*(char*)vbuf = c;
  800576:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800579:	89 c2                	mov    %eax,%edx
  80057b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80057f:	88 10                	mov    %dl,(%rax)
	return 1;
  800581:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800586:	c9                   	leaveq 
  800587:	c3                   	retq   

0000000000800588 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800588:	55                   	push   %rbp
  800589:	48 89 e5             	mov    %rsp,%rbp
  80058c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800593:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80059a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005a1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005af:	eb 77                	jmp    800628 <devcons_write+0xa0>
		m = n - tot;
  8005b1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005b8:	89 c2                	mov    %eax,%edx
  8005ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005bd:	89 d1                	mov    %edx,%ecx
  8005bf:	29 c1                	sub    %eax,%ecx
  8005c1:	89 c8                	mov    %ecx,%eax
  8005c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005c9:	83 f8 7f             	cmp    $0x7f,%eax
  8005cc:	76 07                	jbe    8005d5 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8005ce:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005d8:	48 63 d0             	movslq %eax,%rdx
  8005db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005de:	48 98                	cltq   
  8005e0:	48 89 c1             	mov    %rax,%rcx
  8005e3:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8005ea:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8005f1:	48 89 ce             	mov    %rcx,%rsi
  8005f4:	48 89 c7             	mov    %rax,%rdi
  8005f7:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  8005fe:	00 00 00 
  800601:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  800603:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800606:	48 63 d0             	movslq %eax,%rdx
  800609:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800610:	48 89 d6             	mov    %rdx,%rsi
  800613:	48 89 c7             	mov    %rax,%rdi
  800616:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  80061d:	00 00 00 
  800620:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800622:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800625:	01 45 fc             	add    %eax,-0x4(%rbp)
  800628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80062b:	48 98                	cltq   
  80062d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800634:	0f 82 77 ff ff ff    	jb     8005b1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80063a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80063d:	c9                   	leaveq 
  80063e:	c3                   	retq   

000000000080063f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80063f:	55                   	push   %rbp
  800640:	48 89 e5             	mov    %rsp,%rbp
  800643:	48 83 ec 08          	sub    $0x8,%rsp
  800647:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80064b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800650:	c9                   	leaveq 
  800651:	c3                   	retq   

0000000000800652 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800652:	55                   	push   %rbp
  800653:	48 89 e5             	mov    %rsp,%rbp
  800656:	48 83 ec 10          	sub    $0x10,%rsp
  80065a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80065e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800666:	48 be 1e 4d 80 00 00 	movabs $0x804d1e,%rsi
  80066d:	00 00 00 
  800670:	48 89 c7             	mov    %rax,%rdi
  800673:	48 b8 48 15 80 00 00 	movabs $0x801548,%rax
  80067a:	00 00 00 
  80067d:	ff d0                	callq  *%rax
	return 0;
  80067f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800684:	c9                   	leaveq 
  800685:	c3                   	retq   
	...

0000000000800688 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800688:	55                   	push   %rbp
  800689:	48 89 e5             	mov    %rsp,%rbp
  80068c:	48 83 ec 10          	sub    $0x10,%rsp
  800690:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800693:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800697:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  80069e:	00 00 00 
  8006a1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8006a8:	48 b8 04 1e 80 00 00 	movabs $0x801e04,%rax
  8006af:	00 00 00 
  8006b2:	ff d0                	callq  *%rax
  8006b4:	48 98                	cltq   
  8006b6:	48 89 c2             	mov    %rax,%rdx
  8006b9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8006bf:	48 89 d0             	mov    %rdx,%rax
  8006c2:	48 c1 e0 03          	shl    $0x3,%rax
  8006c6:	48 01 d0             	add    %rdx,%rax
  8006c9:	48 c1 e0 05          	shl    $0x5,%rax
  8006cd:	48 89 c2             	mov    %rax,%rdx
  8006d0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8006d7:	00 00 00 
  8006da:	48 01 c2             	add    %rax,%rdx
  8006dd:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  8006e4:	00 00 00 
  8006e7:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006ee:	7e 14                	jle    800704 <libmain+0x7c>
		binaryname = argv[0];
  8006f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f4:	48 8b 10             	mov    (%rax),%rdx
  8006f7:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  8006fe:	00 00 00 
  800701:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800704:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80070b:	48 89 d6             	mov    %rdx,%rsi
  80070e:	89 c7                	mov    %eax,%edi
  800710:	48 b8 8a 00 80 00 00 	movabs $0x80008a,%rax
  800717:	00 00 00 
  80071a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80071c:	48 b8 2c 07 80 00 00 	movabs $0x80072c,%rax
  800723:	00 00 00 
  800726:	ff d0                	callq  *%rax
}
  800728:	c9                   	leaveq 
  800729:	c3                   	retq   
	...

000000000080072c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80072c:	55                   	push   %rbp
  80072d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800730:	48 b8 01 25 80 00 00 	movabs $0x802501,%rax
  800737:	00 00 00 
  80073a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80073c:	bf 00 00 00 00       	mov    $0x0,%edi
  800741:	48 b8 c0 1d 80 00 00 	movabs $0x801dc0,%rax
  800748:	00 00 00 
  80074b:	ff d0                	callq  *%rax
}
  80074d:	5d                   	pop    %rbp
  80074e:	c3                   	retq   
	...

0000000000800750 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800750:	55                   	push   %rbp
  800751:	48 89 e5             	mov    %rsp,%rbp
  800754:	53                   	push   %rbx
  800755:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80075c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800763:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800769:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800770:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800777:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80077e:	84 c0                	test   %al,%al
  800780:	74 23                	je     8007a5 <_panic+0x55>
  800782:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800789:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80078d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800791:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800795:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800799:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80079d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007a1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8007a5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007ac:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007b3:	00 00 00 
  8007b6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007bd:	00 00 00 
  8007c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007cb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007d2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007d9:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  8007e0:	00 00 00 
  8007e3:	48 8b 18             	mov    (%rax),%rbx
  8007e6:	48 b8 04 1e 80 00 00 	movabs $0x801e04,%rax
  8007ed:	00 00 00 
  8007f0:	ff d0                	callq  *%rax
  8007f2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8007f8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8007ff:	41 89 c8             	mov    %ecx,%r8d
  800802:	48 89 d1             	mov    %rdx,%rcx
  800805:	48 89 da             	mov    %rbx,%rdx
  800808:	89 c6                	mov    %eax,%esi
  80080a:	48 bf 30 4d 80 00 00 	movabs $0x804d30,%rdi
  800811:	00 00 00 
  800814:	b8 00 00 00 00       	mov    $0x0,%eax
  800819:	49 b9 8b 09 80 00 00 	movabs $0x80098b,%r9
  800820:	00 00 00 
  800823:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800826:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80082d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800834:	48 89 d6             	mov    %rdx,%rsi
  800837:	48 89 c7             	mov    %rax,%rdi
  80083a:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  800841:	00 00 00 
  800844:	ff d0                	callq  *%rax
	cprintf("\n");
  800846:	48 bf 53 4d 80 00 00 	movabs $0x804d53,%rdi
  80084d:	00 00 00 
  800850:	b8 00 00 00 00       	mov    $0x0,%eax
  800855:	48 ba 8b 09 80 00 00 	movabs $0x80098b,%rdx
  80085c:	00 00 00 
  80085f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800861:	cc                   	int3   
  800862:	eb fd                	jmp    800861 <_panic+0x111>

0000000000800864 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800864:	55                   	push   %rbp
  800865:	48 89 e5             	mov    %rsp,%rbp
  800868:	48 83 ec 10          	sub    $0x10,%rsp
  80086c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80086f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800873:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800877:	8b 00                	mov    (%rax),%eax
  800879:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80087c:	89 d6                	mov    %edx,%esi
  80087e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800882:	48 63 d0             	movslq %eax,%rdx
  800885:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80088a:	8d 50 01             	lea    0x1(%rax),%edx
  80088d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800891:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800897:	8b 00                	mov    (%rax),%eax
  800899:	3d ff 00 00 00       	cmp    $0xff,%eax
  80089e:	75 2c                	jne    8008cc <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8008a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	48 98                	cltq   
  8008a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008ac:	48 83 c2 08          	add    $0x8,%rdx
  8008b0:	48 89 c6             	mov    %rax,%rsi
  8008b3:	48 89 d7             	mov    %rdx,%rdi
  8008b6:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  8008bd:	00 00 00 
  8008c0:	ff d0                	callq  *%rax
		b->idx = 0;
  8008c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8008cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d0:	8b 40 04             	mov    0x4(%rax),%eax
  8008d3:	8d 50 01             	lea    0x1(%rax),%edx
  8008d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008da:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008dd:	c9                   	leaveq 
  8008de:	c3                   	retq   

00000000008008df <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8008df:	55                   	push   %rbp
  8008e0:	48 89 e5             	mov    %rsp,%rbp
  8008e3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008ea:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008f1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8008f8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8008ff:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800906:	48 8b 0a             	mov    (%rdx),%rcx
  800909:	48 89 08             	mov    %rcx,(%rax)
  80090c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800910:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800914:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800918:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80091c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800923:	00 00 00 
	b.cnt = 0;
  800926:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80092d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800930:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800937:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80093e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800945:	48 89 c6             	mov    %rax,%rsi
  800948:	48 bf 64 08 80 00 00 	movabs $0x800864,%rdi
  80094f:	00 00 00 
  800952:	48 b8 3c 0d 80 00 00 	movabs $0x800d3c,%rax
  800959:	00 00 00 
  80095c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80095e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800964:	48 98                	cltq   
  800966:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80096d:	48 83 c2 08          	add    $0x8,%rdx
  800971:	48 89 c6             	mov    %rax,%rsi
  800974:	48 89 d7             	mov    %rdx,%rdi
  800977:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  80097e:	00 00 00 
  800981:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800983:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800989:	c9                   	leaveq 
  80098a:	c3                   	retq   

000000000080098b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80098b:	55                   	push   %rbp
  80098c:	48 89 e5             	mov    %rsp,%rbp
  80098f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800996:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80099d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009a4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009ab:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009b2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009b9:	84 c0                	test   %al,%al
  8009bb:	74 20                	je     8009dd <cprintf+0x52>
  8009bd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009c1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009c5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009c9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009cd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009d1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009d5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009d9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009dd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8009e4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009eb:	00 00 00 
  8009ee:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009f5:	00 00 00 
  8009f8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009fc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a03:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a0a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800a11:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a18:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a1f:	48 8b 0a             	mov    (%rdx),%rcx
  800a22:	48 89 08             	mov    %rcx,(%rax)
  800a25:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a29:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a2d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a31:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800a35:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a3c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a43:	48 89 d6             	mov    %rdx,%rsi
  800a46:	48 89 c7             	mov    %rax,%rdi
  800a49:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  800a50:	00 00 00 
  800a53:	ff d0                	callq  *%rax
  800a55:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800a5b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a61:	c9                   	leaveq 
  800a62:	c3                   	retq   
	...

0000000000800a64 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a64:	55                   	push   %rbp
  800a65:	48 89 e5             	mov    %rsp,%rbp
  800a68:	48 83 ec 30          	sub    $0x30,%rsp
  800a6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800a74:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800a78:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800a7b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800a7f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a83:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800a86:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800a8a:	77 52                	ja     800ade <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800a8f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800a93:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800a96:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa3:	48 f7 75 d0          	divq   -0x30(%rbp)
  800aa7:	48 89 c2             	mov    %rax,%rdx
  800aaa:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800aad:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ab0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800ab4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ab8:	41 89 f9             	mov    %edi,%r9d
  800abb:	48 89 c7             	mov    %rax,%rdi
  800abe:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  800ac5:	00 00 00 
  800ac8:	ff d0                	callq  *%rax
  800aca:	eb 1c                	jmp    800ae8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800acc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ad0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ad3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800ad7:	48 89 d6             	mov    %rdx,%rsi
  800ada:	89 c7                	mov    %eax,%edi
  800adc:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ade:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800ae2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800ae6:	7f e4                	jg     800acc <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800aeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aef:	ba 00 00 00 00       	mov    $0x0,%edx
  800af4:	48 f7 f1             	div    %rcx
  800af7:	48 89 d0             	mov    %rdx,%rax
  800afa:	48 ba 28 4f 80 00 00 	movabs $0x804f28,%rdx
  800b01:	00 00 00 
  800b04:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800b08:	0f be c0             	movsbl %al,%eax
  800b0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b0f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800b13:	48 89 d6             	mov    %rdx,%rsi
  800b16:	89 c7                	mov    %eax,%edi
  800b18:	ff d1                	callq  *%rcx
}
  800b1a:	c9                   	leaveq 
  800b1b:	c3                   	retq   

0000000000800b1c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b1c:	55                   	push   %rbp
  800b1d:	48 89 e5             	mov    %rsp,%rbp
  800b20:	48 83 ec 20          	sub    $0x20,%rsp
  800b24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b28:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b2b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b2f:	7e 52                	jle    800b83 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b35:	8b 00                	mov    (%rax),%eax
  800b37:	83 f8 30             	cmp    $0x30,%eax
  800b3a:	73 24                	jae    800b60 <getuint+0x44>
  800b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b40:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b48:	8b 00                	mov    (%rax),%eax
  800b4a:	89 c0                	mov    %eax,%eax
  800b4c:	48 01 d0             	add    %rdx,%rax
  800b4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b53:	8b 12                	mov    (%rdx),%edx
  800b55:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5c:	89 0a                	mov    %ecx,(%rdx)
  800b5e:	eb 17                	jmp    800b77 <getuint+0x5b>
  800b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b64:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b68:	48 89 d0             	mov    %rdx,%rax
  800b6b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b73:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b77:	48 8b 00             	mov    (%rax),%rax
  800b7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b7e:	e9 a3 00 00 00       	jmpq   800c26 <getuint+0x10a>
	else if (lflag)
  800b83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b87:	74 4f                	je     800bd8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8d:	8b 00                	mov    (%rax),%eax
  800b8f:	83 f8 30             	cmp    $0x30,%eax
  800b92:	73 24                	jae    800bb8 <getuint+0x9c>
  800b94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b98:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba0:	8b 00                	mov    (%rax),%eax
  800ba2:	89 c0                	mov    %eax,%eax
  800ba4:	48 01 d0             	add    %rdx,%rax
  800ba7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bab:	8b 12                	mov    (%rdx),%edx
  800bad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb4:	89 0a                	mov    %ecx,(%rdx)
  800bb6:	eb 17                	jmp    800bcf <getuint+0xb3>
  800bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bc0:	48 89 d0             	mov    %rdx,%rax
  800bc3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bcb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bcf:	48 8b 00             	mov    (%rax),%rax
  800bd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bd6:	eb 4e                	jmp    800c26 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdc:	8b 00                	mov    (%rax),%eax
  800bde:	83 f8 30             	cmp    $0x30,%eax
  800be1:	73 24                	jae    800c07 <getuint+0xeb>
  800be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800beb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bef:	8b 00                	mov    (%rax),%eax
  800bf1:	89 c0                	mov    %eax,%eax
  800bf3:	48 01 d0             	add    %rdx,%rax
  800bf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bfa:	8b 12                	mov    (%rdx),%edx
  800bfc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c03:	89 0a                	mov    %ecx,(%rdx)
  800c05:	eb 17                	jmp    800c1e <getuint+0x102>
  800c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c0f:	48 89 d0             	mov    %rdx,%rax
  800c12:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c1e:	8b 00                	mov    (%rax),%eax
  800c20:	89 c0                	mov    %eax,%eax
  800c22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c2a:	c9                   	leaveq 
  800c2b:	c3                   	retq   

0000000000800c2c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c2c:	55                   	push   %rbp
  800c2d:	48 89 e5             	mov    %rsp,%rbp
  800c30:	48 83 ec 20          	sub    $0x20,%rsp
  800c34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c38:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c3b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c3f:	7e 52                	jle    800c93 <getint+0x67>
		x=va_arg(*ap, long long);
  800c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c45:	8b 00                	mov    (%rax),%eax
  800c47:	83 f8 30             	cmp    $0x30,%eax
  800c4a:	73 24                	jae    800c70 <getint+0x44>
  800c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c50:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c58:	8b 00                	mov    (%rax),%eax
  800c5a:	89 c0                	mov    %eax,%eax
  800c5c:	48 01 d0             	add    %rdx,%rax
  800c5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c63:	8b 12                	mov    (%rdx),%edx
  800c65:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c6c:	89 0a                	mov    %ecx,(%rdx)
  800c6e:	eb 17                	jmp    800c87 <getint+0x5b>
  800c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c74:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c78:	48 89 d0             	mov    %rdx,%rax
  800c7b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c83:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c87:	48 8b 00             	mov    (%rax),%rax
  800c8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c8e:	e9 a3 00 00 00       	jmpq   800d36 <getint+0x10a>
	else if (lflag)
  800c93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c97:	74 4f                	je     800ce8 <getint+0xbc>
		x=va_arg(*ap, long);
  800c99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9d:	8b 00                	mov    (%rax),%eax
  800c9f:	83 f8 30             	cmp    $0x30,%eax
  800ca2:	73 24                	jae    800cc8 <getint+0x9c>
  800ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb0:	8b 00                	mov    (%rax),%eax
  800cb2:	89 c0                	mov    %eax,%eax
  800cb4:	48 01 d0             	add    %rdx,%rax
  800cb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cbb:	8b 12                	mov    (%rdx),%edx
  800cbd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc4:	89 0a                	mov    %ecx,(%rdx)
  800cc6:	eb 17                	jmp    800cdf <getint+0xb3>
  800cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cd0:	48 89 d0             	mov    %rdx,%rax
  800cd3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800cd7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cdb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cdf:	48 8b 00             	mov    (%rax),%rax
  800ce2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ce6:	eb 4e                	jmp    800d36 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ce8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cec:	8b 00                	mov    (%rax),%eax
  800cee:	83 f8 30             	cmp    $0x30,%eax
  800cf1:	73 24                	jae    800d17 <getint+0xeb>
  800cf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cff:	8b 00                	mov    (%rax),%eax
  800d01:	89 c0                	mov    %eax,%eax
  800d03:	48 01 d0             	add    %rdx,%rax
  800d06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0a:	8b 12                	mov    (%rdx),%edx
  800d0c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d13:	89 0a                	mov    %ecx,(%rdx)
  800d15:	eb 17                	jmp    800d2e <getint+0x102>
  800d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d1f:	48 89 d0             	mov    %rdx,%rax
  800d22:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d2a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d2e:	8b 00                	mov    (%rax),%eax
  800d30:	48 98                	cltq   
  800d32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d3a:	c9                   	leaveq 
  800d3b:	c3                   	retq   

0000000000800d3c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d3c:	55                   	push   %rbp
  800d3d:	48 89 e5             	mov    %rsp,%rbp
  800d40:	41 54                	push   %r12
  800d42:	53                   	push   %rbx
  800d43:	48 83 ec 60          	sub    $0x60,%rsp
  800d47:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d4b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d4f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d53:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d57:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d5b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d5f:	48 8b 0a             	mov    (%rdx),%rcx
  800d62:	48 89 08             	mov    %rcx,(%rax)
  800d65:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d69:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d6d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d71:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d75:	eb 17                	jmp    800d8e <vprintfmt+0x52>
			if (ch == '\0')
  800d77:	85 db                	test   %ebx,%ebx
  800d79:	0f 84 d7 04 00 00    	je     801256 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800d7f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d83:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d87:	48 89 c6             	mov    %rax,%rsi
  800d8a:	89 df                	mov    %ebx,%edi
  800d8c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d8e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d92:	0f b6 00             	movzbl (%rax),%eax
  800d95:	0f b6 d8             	movzbl %al,%ebx
  800d98:	83 fb 25             	cmp    $0x25,%ebx
  800d9b:	0f 95 c0             	setne  %al
  800d9e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800da3:	84 c0                	test   %al,%al
  800da5:	75 d0                	jne    800d77 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800da7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800dab:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800db2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800db9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dc0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800dc7:	eb 04                	jmp    800dcd <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800dc9:	90                   	nop
  800dca:	eb 01                	jmp    800dcd <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800dcc:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dcd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dd1:	0f b6 00             	movzbl (%rax),%eax
  800dd4:	0f b6 d8             	movzbl %al,%ebx
  800dd7:	89 d8                	mov    %ebx,%eax
  800dd9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800dde:	83 e8 23             	sub    $0x23,%eax
  800de1:	83 f8 55             	cmp    $0x55,%eax
  800de4:	0f 87 38 04 00 00    	ja     801222 <vprintfmt+0x4e6>
  800dea:	89 c0                	mov    %eax,%eax
  800dec:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800df3:	00 
  800df4:	48 b8 50 4f 80 00 00 	movabs $0x804f50,%rax
  800dfb:	00 00 00 
  800dfe:	48 01 d0             	add    %rdx,%rax
  800e01:	48 8b 00             	mov    (%rax),%rax
  800e04:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e06:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e0a:	eb c1                	jmp    800dcd <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e0c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e10:	eb bb                	jmp    800dcd <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e12:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e19:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d8                	add    %ebx,%eax
  800e27:	83 e8 30             	sub    $0x30,%eax
  800e2a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e2d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e31:	0f b6 00             	movzbl (%rax),%eax
  800e34:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e37:	83 fb 2f             	cmp    $0x2f,%ebx
  800e3a:	7e 63                	jle    800e9f <vprintfmt+0x163>
  800e3c:	83 fb 39             	cmp    $0x39,%ebx
  800e3f:	7f 5e                	jg     800e9f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e41:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e46:	eb d1                	jmp    800e19 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800e48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4b:	83 f8 30             	cmp    $0x30,%eax
  800e4e:	73 17                	jae    800e67 <vprintfmt+0x12b>
  800e50:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e57:	89 c0                	mov    %eax,%eax
  800e59:	48 01 d0             	add    %rdx,%rax
  800e5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e5f:	83 c2 08             	add    $0x8,%edx
  800e62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e65:	eb 0f                	jmp    800e76 <vprintfmt+0x13a>
  800e67:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6b:	48 89 d0             	mov    %rdx,%rax
  800e6e:	48 83 c2 08          	add    $0x8,%rdx
  800e72:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e76:	8b 00                	mov    (%rax),%eax
  800e78:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e7b:	eb 23                	jmp    800ea0 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800e7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e81:	0f 89 42 ff ff ff    	jns    800dc9 <vprintfmt+0x8d>
				width = 0;
  800e87:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e8e:	e9 36 ff ff ff       	jmpq   800dc9 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800e93:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e9a:	e9 2e ff ff ff       	jmpq   800dcd <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e9f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ea0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ea4:	0f 89 22 ff ff ff    	jns    800dcc <vprintfmt+0x90>
				width = precision, precision = -1;
  800eaa:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ead:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800eb0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800eb7:	e9 10 ff ff ff       	jmpq   800dcc <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ebc:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ec0:	e9 08 ff ff ff       	jmpq   800dcd <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ec5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec8:	83 f8 30             	cmp    $0x30,%eax
  800ecb:	73 17                	jae    800ee4 <vprintfmt+0x1a8>
  800ecd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ed1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ed4:	89 c0                	mov    %eax,%eax
  800ed6:	48 01 d0             	add    %rdx,%rax
  800ed9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800edc:	83 c2 08             	add    $0x8,%edx
  800edf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ee2:	eb 0f                	jmp    800ef3 <vprintfmt+0x1b7>
  800ee4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ee8:	48 89 d0             	mov    %rdx,%rax
  800eeb:	48 83 c2 08          	add    $0x8,%rdx
  800eef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ef3:	8b 00                	mov    (%rax),%eax
  800ef5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800efd:	48 89 d6             	mov    %rdx,%rsi
  800f00:	89 c7                	mov    %eax,%edi
  800f02:	ff d1                	callq  *%rcx
			break;
  800f04:	e9 47 03 00 00       	jmpq   801250 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800f09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f0c:	83 f8 30             	cmp    $0x30,%eax
  800f0f:	73 17                	jae    800f28 <vprintfmt+0x1ec>
  800f11:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f18:	89 c0                	mov    %eax,%eax
  800f1a:	48 01 d0             	add    %rdx,%rax
  800f1d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f20:	83 c2 08             	add    $0x8,%edx
  800f23:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f26:	eb 0f                	jmp    800f37 <vprintfmt+0x1fb>
  800f28:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f2c:	48 89 d0             	mov    %rdx,%rax
  800f2f:	48 83 c2 08          	add    $0x8,%rdx
  800f33:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f37:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f39:	85 db                	test   %ebx,%ebx
  800f3b:	79 02                	jns    800f3f <vprintfmt+0x203>
				err = -err;
  800f3d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f3f:	83 fb 10             	cmp    $0x10,%ebx
  800f42:	7f 16                	jg     800f5a <vprintfmt+0x21e>
  800f44:	48 b8 a0 4e 80 00 00 	movabs $0x804ea0,%rax
  800f4b:	00 00 00 
  800f4e:	48 63 d3             	movslq %ebx,%rdx
  800f51:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f55:	4d 85 e4             	test   %r12,%r12
  800f58:	75 2e                	jne    800f88 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800f5a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f62:	89 d9                	mov    %ebx,%ecx
  800f64:	48 ba 39 4f 80 00 00 	movabs $0x804f39,%rdx
  800f6b:	00 00 00 
  800f6e:	48 89 c7             	mov    %rax,%rdi
  800f71:	b8 00 00 00 00       	mov    $0x0,%eax
  800f76:	49 b8 60 12 80 00 00 	movabs $0x801260,%r8
  800f7d:	00 00 00 
  800f80:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f83:	e9 c8 02 00 00       	jmpq   801250 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f88:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f90:	4c 89 e1             	mov    %r12,%rcx
  800f93:	48 ba 42 4f 80 00 00 	movabs $0x804f42,%rdx
  800f9a:	00 00 00 
  800f9d:	48 89 c7             	mov    %rax,%rdi
  800fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa5:	49 b8 60 12 80 00 00 	movabs $0x801260,%r8
  800fac:	00 00 00 
  800faf:	41 ff d0             	callq  *%r8
			break;
  800fb2:	e9 99 02 00 00       	jmpq   801250 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fb7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fba:	83 f8 30             	cmp    $0x30,%eax
  800fbd:	73 17                	jae    800fd6 <vprintfmt+0x29a>
  800fbf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fc3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fc6:	89 c0                	mov    %eax,%eax
  800fc8:	48 01 d0             	add    %rdx,%rax
  800fcb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fce:	83 c2 08             	add    $0x8,%edx
  800fd1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fd4:	eb 0f                	jmp    800fe5 <vprintfmt+0x2a9>
  800fd6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fda:	48 89 d0             	mov    %rdx,%rax
  800fdd:	48 83 c2 08          	add    $0x8,%rdx
  800fe1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fe5:	4c 8b 20             	mov    (%rax),%r12
  800fe8:	4d 85 e4             	test   %r12,%r12
  800feb:	75 0a                	jne    800ff7 <vprintfmt+0x2bb>
				p = "(null)";
  800fed:	49 bc 45 4f 80 00 00 	movabs $0x804f45,%r12
  800ff4:	00 00 00 
			if (width > 0 && padc != '-')
  800ff7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ffb:	7e 7a                	jle    801077 <vprintfmt+0x33b>
  800ffd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801001:	74 74                	je     801077 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  801003:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801006:	48 98                	cltq   
  801008:	48 89 c6             	mov    %rax,%rsi
  80100b:	4c 89 e7             	mov    %r12,%rdi
  80100e:	48 b8 0a 15 80 00 00 	movabs $0x80150a,%rax
  801015:	00 00 00 
  801018:	ff d0                	callq  *%rax
  80101a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80101d:	eb 17                	jmp    801036 <vprintfmt+0x2fa>
					putch(padc, putdat);
  80101f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  801023:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801027:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80102b:	48 89 d6             	mov    %rdx,%rsi
  80102e:	89 c7                	mov    %eax,%edi
  801030:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801032:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801036:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80103a:	7f e3                	jg     80101f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80103c:	eb 39                	jmp    801077 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  80103e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801042:	74 1e                	je     801062 <vprintfmt+0x326>
  801044:	83 fb 1f             	cmp    $0x1f,%ebx
  801047:	7e 05                	jle    80104e <vprintfmt+0x312>
  801049:	83 fb 7e             	cmp    $0x7e,%ebx
  80104c:	7e 14                	jle    801062 <vprintfmt+0x326>
					putch('?', putdat);
  80104e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801052:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801056:	48 89 c6             	mov    %rax,%rsi
  801059:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80105e:	ff d2                	callq  *%rdx
  801060:	eb 0f                	jmp    801071 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801062:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801066:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80106a:	48 89 c6             	mov    %rax,%rsi
  80106d:	89 df                	mov    %ebx,%edi
  80106f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801071:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801075:	eb 01                	jmp    801078 <vprintfmt+0x33c>
  801077:	90                   	nop
  801078:	41 0f b6 04 24       	movzbl (%r12),%eax
  80107d:	0f be d8             	movsbl %al,%ebx
  801080:	85 db                	test   %ebx,%ebx
  801082:	0f 95 c0             	setne  %al
  801085:	49 83 c4 01          	add    $0x1,%r12
  801089:	84 c0                	test   %al,%al
  80108b:	74 28                	je     8010b5 <vprintfmt+0x379>
  80108d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801091:	78 ab                	js     80103e <vprintfmt+0x302>
  801093:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801097:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80109b:	79 a1                	jns    80103e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80109d:	eb 16                	jmp    8010b5 <vprintfmt+0x379>
				putch(' ', putdat);
  80109f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010a3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010a7:	48 89 c6             	mov    %rax,%rsi
  8010aa:	bf 20 00 00 00       	mov    $0x20,%edi
  8010af:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010b1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010b9:	7f e4                	jg     80109f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  8010bb:	e9 90 01 00 00       	jmpq   801250 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8010c0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010c4:	be 03 00 00 00       	mov    $0x3,%esi
  8010c9:	48 89 c7             	mov    %rax,%rdi
  8010cc:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  8010d3:	00 00 00 
  8010d6:	ff d0                	callq  *%rax
  8010d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e0:	48 85 c0             	test   %rax,%rax
  8010e3:	79 1d                	jns    801102 <vprintfmt+0x3c6>
				putch('-', putdat);
  8010e5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010e9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010ed:	48 89 c6             	mov    %rax,%rsi
  8010f0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010f5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8010f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fb:	48 f7 d8             	neg    %rax
  8010fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801102:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801109:	e9 d5 00 00 00       	jmpq   8011e3 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80110e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801112:	be 03 00 00 00       	mov    $0x3,%esi
  801117:	48 89 c7             	mov    %rax,%rdi
  80111a:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  801121:	00 00 00 
  801124:	ff d0                	callq  *%rax
  801126:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80112a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801131:	e9 ad 00 00 00       	jmpq   8011e3 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  801136:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80113a:	be 03 00 00 00       	mov    $0x3,%esi
  80113f:	48 89 c7             	mov    %rax,%rdi
  801142:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  801149:	00 00 00 
  80114c:	ff d0                	callq  *%rax
  80114e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  801152:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801159:	e9 85 00 00 00       	jmpq   8011e3 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  80115e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801162:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801166:	48 89 c6             	mov    %rax,%rsi
  801169:	bf 30 00 00 00       	mov    $0x30,%edi
  80116e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801170:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801174:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801178:	48 89 c6             	mov    %rax,%rsi
  80117b:	bf 78 00 00 00       	mov    $0x78,%edi
  801180:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801182:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801185:	83 f8 30             	cmp    $0x30,%eax
  801188:	73 17                	jae    8011a1 <vprintfmt+0x465>
  80118a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80118e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801191:	89 c0                	mov    %eax,%eax
  801193:	48 01 d0             	add    %rdx,%rax
  801196:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801199:	83 c2 08             	add    $0x8,%edx
  80119c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80119f:	eb 0f                	jmp    8011b0 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  8011a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011a5:	48 89 d0             	mov    %rdx,%rax
  8011a8:	48 83 c2 08          	add    $0x8,%rdx
  8011ac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011b0:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8011b7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8011be:	eb 23                	jmp    8011e3 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8011c0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011c4:	be 03 00 00 00       	mov    $0x3,%esi
  8011c9:	48 89 c7             	mov    %rax,%rdi
  8011cc:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  8011d3:	00 00 00 
  8011d6:	ff d0                	callq  *%rax
  8011d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011dc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011e3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011e8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011eb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011fa:	45 89 c1             	mov    %r8d,%r9d
  8011fd:	41 89 f8             	mov    %edi,%r8d
  801200:	48 89 c7             	mov    %rax,%rdi
  801203:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  80120a:	00 00 00 
  80120d:	ff d0                	callq  *%rax
			break;
  80120f:	eb 3f                	jmp    801250 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801211:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801215:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801219:	48 89 c6             	mov    %rax,%rsi
  80121c:	89 df                	mov    %ebx,%edi
  80121e:	ff d2                	callq  *%rdx
			break;
  801220:	eb 2e                	jmp    801250 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801222:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801226:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80122a:	48 89 c6             	mov    %rax,%rsi
  80122d:	bf 25 00 00 00       	mov    $0x25,%edi
  801232:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801234:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801239:	eb 05                	jmp    801240 <vprintfmt+0x504>
  80123b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801240:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801244:	48 83 e8 01          	sub    $0x1,%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	3c 25                	cmp    $0x25,%al
  80124d:	75 ec                	jne    80123b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  80124f:	90                   	nop
		}
	}
  801250:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801251:	e9 38 fb ff ff       	jmpq   800d8e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801256:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  801257:	48 83 c4 60          	add    $0x60,%rsp
  80125b:	5b                   	pop    %rbx
  80125c:	41 5c                	pop    %r12
  80125e:	5d                   	pop    %rbp
  80125f:	c3                   	retq   

0000000000801260 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80126b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801272:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801279:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801280:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801287:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80128e:	84 c0                	test   %al,%al
  801290:	74 20                	je     8012b2 <printfmt+0x52>
  801292:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801296:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80129a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80129e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012a2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012a6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012aa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012ae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012b2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8012b9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8012c0:	00 00 00 
  8012c3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8012ca:	00 00 00 
  8012cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012d1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012df:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012e6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012ed:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012f4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012fb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801302:	48 89 c7             	mov    %rax,%rdi
  801305:	48 b8 3c 0d 80 00 00 	movabs $0x800d3c,%rax
  80130c:	00 00 00 
  80130f:	ff d0                	callq  *%rax
	va_end(ap);
}
  801311:	c9                   	leaveq 
  801312:	c3                   	retq   

0000000000801313 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801313:	55                   	push   %rbp
  801314:	48 89 e5             	mov    %rsp,%rbp
  801317:	48 83 ec 10          	sub    $0x10,%rsp
  80131b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80131e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801326:	8b 40 10             	mov    0x10(%rax),%eax
  801329:	8d 50 01             	lea    0x1(%rax),%edx
  80132c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801330:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801337:	48 8b 10             	mov    (%rax),%rdx
  80133a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801342:	48 39 c2             	cmp    %rax,%rdx
  801345:	73 17                	jae    80135e <sprintputch+0x4b>
		*b->buf++ = ch;
  801347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134b:	48 8b 00             	mov    (%rax),%rax
  80134e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801351:	88 10                	mov    %dl,(%rax)
  801353:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135b:	48 89 10             	mov    %rdx,(%rax)
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 50          	sub    $0x50,%rsp
  801368:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80136c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80136f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801373:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801377:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80137b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80137f:	48 8b 0a             	mov    (%rdx),%rcx
  801382:	48 89 08             	mov    %rcx,(%rax)
  801385:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801389:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80138d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801391:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801395:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801399:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80139d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8013a0:	48 98                	cltq   
  8013a2:	48 83 e8 01          	sub    $0x1,%rax
  8013a6:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8013aa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8013ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8013b5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013ba:	74 06                	je     8013c2 <vsnprintf+0x62>
  8013bc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8013c0:	7f 07                	jg     8013c9 <vsnprintf+0x69>
		return -E_INVAL;
  8013c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c7:	eb 2f                	jmp    8013f8 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8013c9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013cd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013d1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013d5:	48 89 c6             	mov    %rax,%rsi
  8013d8:	48 bf 13 13 80 00 00 	movabs $0x801313,%rdi
  8013df:	00 00 00 
  8013e2:	48 b8 3c 0d 80 00 00 	movabs $0x800d3c,%rax
  8013e9:	00 00 00 
  8013ec:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013f2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013f5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013f8:	c9                   	leaveq 
  8013f9:	c3                   	retq   

00000000008013fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013fa:	55                   	push   %rbp
  8013fb:	48 89 e5             	mov    %rsp,%rbp
  8013fe:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801405:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80140c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801412:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801419:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801420:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801427:	84 c0                	test   %al,%al
  801429:	74 20                	je     80144b <snprintf+0x51>
  80142b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80142f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801433:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801437:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80143b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80143f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801443:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801447:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80144b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801452:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801459:	00 00 00 
  80145c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801463:	00 00 00 
  801466:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80146a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801471:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801478:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80147f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801486:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80148d:	48 8b 0a             	mov    (%rdx),%rcx
  801490:	48 89 08             	mov    %rcx,(%rax)
  801493:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801497:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80149b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80149f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8014a3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8014aa:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8014b1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8014b7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014be:	48 89 c7             	mov    %rax,%rdi
  8014c1:	48 b8 60 13 80 00 00 	movabs $0x801360,%rax
  8014c8:	00 00 00 
  8014cb:	ff d0                	callq  *%rax
  8014cd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014d3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014d9:	c9                   	leaveq 
  8014da:	c3                   	retq   
	...

00000000008014dc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014dc:	55                   	push   %rbp
  8014dd:	48 89 e5             	mov    %rsp,%rbp
  8014e0:	48 83 ec 18          	sub    $0x18,%rsp
  8014e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014ef:	eb 09                	jmp    8014fa <strlen+0x1e>
		n++;
  8014f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	84 c0                	test   %al,%al
  801503:	75 ec                	jne    8014f1 <strlen+0x15>
		n++;
	return n;
  801505:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801508:	c9                   	leaveq 
  801509:	c3                   	retq   

000000000080150a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80150a:	55                   	push   %rbp
  80150b:	48 89 e5             	mov    %rsp,%rbp
  80150e:	48 83 ec 20          	sub    $0x20,%rsp
  801512:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801516:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80151a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801521:	eb 0e                	jmp    801531 <strnlen+0x27>
		n++;
  801523:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801527:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80152c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801531:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801536:	74 0b                	je     801543 <strnlen+0x39>
  801538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153c:	0f b6 00             	movzbl (%rax),%eax
  80153f:	84 c0                	test   %al,%al
  801541:	75 e0                	jne    801523 <strnlen+0x19>
		n++;
	return n;
  801543:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801546:	c9                   	leaveq 
  801547:	c3                   	retq   

0000000000801548 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801548:	55                   	push   %rbp
  801549:	48 89 e5             	mov    %rsp,%rbp
  80154c:	48 83 ec 20          	sub    $0x20,%rsp
  801550:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801554:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801560:	90                   	nop
  801561:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801565:	0f b6 10             	movzbl (%rax),%edx
  801568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156c:	88 10                	mov    %dl,(%rax)
  80156e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	84 c0                	test   %al,%al
  801577:	0f 95 c0             	setne  %al
  80157a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80157f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801584:	84 c0                	test   %al,%al
  801586:	75 d9                	jne    801561 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80158c:	c9                   	leaveq 
  80158d:	c3                   	retq   

000000000080158e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80158e:	55                   	push   %rbp
  80158f:	48 89 e5             	mov    %rsp,%rbp
  801592:	48 83 ec 20          	sub    $0x20,%rsp
  801596:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80159a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80159e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a2:	48 89 c7             	mov    %rax,%rdi
  8015a5:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  8015ac:	00 00 00 
  8015af:	ff d0                	callq  *%rax
  8015b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8015b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015b7:	48 98                	cltq   
  8015b9:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8015bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015c1:	48 89 d6             	mov    %rdx,%rsi
  8015c4:	48 89 c7             	mov    %rax,%rdi
  8015c7:	48 b8 48 15 80 00 00 	movabs $0x801548,%rax
  8015ce:	00 00 00 
  8015d1:	ff d0                	callq  *%rax
	return dst;
  8015d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d7:	c9                   	leaveq 
  8015d8:	c3                   	retq   

00000000008015d9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015d9:	55                   	push   %rbp
  8015da:	48 89 e5             	mov    %rsp,%rbp
  8015dd:	48 83 ec 28          	sub    $0x28,%rsp
  8015e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015f5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015fc:	00 
  8015fd:	eb 27                	jmp    801626 <strncpy+0x4d>
		*dst++ = *src;
  8015ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801603:	0f b6 10             	movzbl (%rax),%edx
  801606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160a:	88 10                	mov    %dl,(%rax)
  80160c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801611:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801615:	0f b6 00             	movzbl (%rax),%eax
  801618:	84 c0                	test   %al,%al
  80161a:	74 05                	je     801621 <strncpy+0x48>
			src++;
  80161c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801621:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80162e:	72 cf                	jb     8015ff <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801630:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801634:	c9                   	leaveq 
  801635:	c3                   	retq   

0000000000801636 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	48 83 ec 28          	sub    $0x28,%rsp
  80163e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801642:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801646:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80164a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801652:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801657:	74 37                	je     801690 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801659:	eb 17                	jmp    801672 <strlcpy+0x3c>
			*dst++ = *src++;
  80165b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80165f:	0f b6 10             	movzbl (%rax),%edx
  801662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801666:	88 10                	mov    %dl,(%rax)
  801668:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80166d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801672:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801677:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80167c:	74 0b                	je     801689 <strlcpy+0x53>
  80167e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	84 c0                	test   %al,%al
  801687:	75 d2                	jne    80165b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801690:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801694:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801698:	48 89 d1             	mov    %rdx,%rcx
  80169b:	48 29 c1             	sub    %rax,%rcx
  80169e:	48 89 c8             	mov    %rcx,%rax
}
  8016a1:	c9                   	leaveq 
  8016a2:	c3                   	retq   

00000000008016a3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016a3:	55                   	push   %rbp
  8016a4:	48 89 e5             	mov    %rsp,%rbp
  8016a7:	48 83 ec 10          	sub    $0x10,%rsp
  8016ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8016b3:	eb 0a                	jmp    8016bf <strcmp+0x1c>
		p++, q++;
  8016b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c3:	0f b6 00             	movzbl (%rax),%eax
  8016c6:	84 c0                	test   %al,%al
  8016c8:	74 12                	je     8016dc <strcmp+0x39>
  8016ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ce:	0f b6 10             	movzbl (%rax),%edx
  8016d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	38 c2                	cmp    %al,%dl
  8016da:	74 d9                	je     8016b5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	0f b6 d0             	movzbl %al,%edx
  8016e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	0f b6 c0             	movzbl %al,%eax
  8016f0:	89 d1                	mov    %edx,%ecx
  8016f2:	29 c1                	sub    %eax,%ecx
  8016f4:	89 c8                	mov    %ecx,%eax
}
  8016f6:	c9                   	leaveq 
  8016f7:	c3                   	retq   

00000000008016f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016f8:	55                   	push   %rbp
  8016f9:	48 89 e5             	mov    %rsp,%rbp
  8016fc:	48 83 ec 18          	sub    $0x18,%rsp
  801700:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801704:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801708:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80170c:	eb 0f                	jmp    80171d <strncmp+0x25>
		n--, p++, q++;
  80170e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801713:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801718:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80171d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801722:	74 1d                	je     801741 <strncmp+0x49>
  801724:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801728:	0f b6 00             	movzbl (%rax),%eax
  80172b:	84 c0                	test   %al,%al
  80172d:	74 12                	je     801741 <strncmp+0x49>
  80172f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801733:	0f b6 10             	movzbl (%rax),%edx
  801736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173a:	0f b6 00             	movzbl (%rax),%eax
  80173d:	38 c2                	cmp    %al,%dl
  80173f:	74 cd                	je     80170e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801741:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801746:	75 07                	jne    80174f <strncmp+0x57>
		return 0;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
  80174d:	eb 1a                	jmp    801769 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80174f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801753:	0f b6 00             	movzbl (%rax),%eax
  801756:	0f b6 d0             	movzbl %al,%edx
  801759:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175d:	0f b6 00             	movzbl (%rax),%eax
  801760:	0f b6 c0             	movzbl %al,%eax
  801763:	89 d1                	mov    %edx,%ecx
  801765:	29 c1                	sub    %eax,%ecx
  801767:	89 c8                	mov    %ecx,%eax
}
  801769:	c9                   	leaveq 
  80176a:	c3                   	retq   

000000000080176b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80176b:	55                   	push   %rbp
  80176c:	48 89 e5             	mov    %rsp,%rbp
  80176f:	48 83 ec 10          	sub    $0x10,%rsp
  801773:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801777:	89 f0                	mov    %esi,%eax
  801779:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80177c:	eb 17                	jmp    801795 <strchr+0x2a>
		if (*s == c)
  80177e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801788:	75 06                	jne    801790 <strchr+0x25>
			return (char *) s;
  80178a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178e:	eb 15                	jmp    8017a5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801790:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	84 c0                	test   %al,%al
  80179e:	75 de                	jne    80177e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a5:	c9                   	leaveq 
  8017a6:	c3                   	retq   

00000000008017a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a7:	55                   	push   %rbp
  8017a8:	48 89 e5             	mov    %rsp,%rbp
  8017ab:	48 83 ec 10          	sub    $0x10,%rsp
  8017af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017b3:	89 f0                	mov    %esi,%eax
  8017b5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017b8:	eb 11                	jmp    8017cb <strfind+0x24>
		if (*s == c)
  8017ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017be:	0f b6 00             	movzbl (%rax),%eax
  8017c1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017c4:	74 12                	je     8017d8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017cf:	0f b6 00             	movzbl (%rax),%eax
  8017d2:	84 c0                	test   %al,%al
  8017d4:	75 e4                	jne    8017ba <strfind+0x13>
  8017d6:	eb 01                	jmp    8017d9 <strfind+0x32>
		if (*s == c)
			break;
  8017d8:	90                   	nop
	return (char *) s;
  8017d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017dd:	c9                   	leaveq 
  8017de:	c3                   	retq   

00000000008017df <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017df:	55                   	push   %rbp
  8017e0:	48 89 e5             	mov    %rsp,%rbp
  8017e3:	48 83 ec 18          	sub    $0x18,%rsp
  8017e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017eb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017f2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017f7:	75 06                	jne    8017ff <memset+0x20>
		return v;
  8017f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fd:	eb 69                	jmp    801868 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8017ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801803:	83 e0 03             	and    $0x3,%eax
  801806:	48 85 c0             	test   %rax,%rax
  801809:	75 48                	jne    801853 <memset+0x74>
  80180b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180f:	83 e0 03             	and    $0x3,%eax
  801812:	48 85 c0             	test   %rax,%rax
  801815:	75 3c                	jne    801853 <memset+0x74>
		c &= 0xFF;
  801817:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80181e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801821:	89 c2                	mov    %eax,%edx
  801823:	c1 e2 18             	shl    $0x18,%edx
  801826:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801829:	c1 e0 10             	shl    $0x10,%eax
  80182c:	09 c2                	or     %eax,%edx
  80182e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801831:	c1 e0 08             	shl    $0x8,%eax
  801834:	09 d0                	or     %edx,%eax
  801836:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183d:	48 89 c1             	mov    %rax,%rcx
  801840:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801844:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801848:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80184b:	48 89 d7             	mov    %rdx,%rdi
  80184e:	fc                   	cld    
  80184f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801851:	eb 11                	jmp    801864 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801853:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801857:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80185a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80185e:	48 89 d7             	mov    %rdx,%rdi
  801861:	fc                   	cld    
  801862:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801864:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801868:	c9                   	leaveq 
  801869:	c3                   	retq   

000000000080186a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80186a:	55                   	push   %rbp
  80186b:	48 89 e5             	mov    %rsp,%rbp
  80186e:	48 83 ec 28          	sub    $0x28,%rsp
  801872:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801876:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80187a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80187e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801882:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80188a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80188e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801892:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801896:	0f 83 88 00 00 00    	jae    801924 <memmove+0xba>
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018a4:	48 01 d0             	add    %rdx,%rax
  8018a7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018ab:	76 77                	jbe    801924 <memmove+0xba>
		s += n;
  8018ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8018b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c1:	83 e0 03             	and    $0x3,%eax
  8018c4:	48 85 c0             	test   %rax,%rax
  8018c7:	75 3b                	jne    801904 <memmove+0x9a>
  8018c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cd:	83 e0 03             	and    $0x3,%eax
  8018d0:	48 85 c0             	test   %rax,%rax
  8018d3:	75 2f                	jne    801904 <memmove+0x9a>
  8018d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d9:	83 e0 03             	and    $0x3,%eax
  8018dc:	48 85 c0             	test   %rax,%rax
  8018df:	75 23                	jne    801904 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e5:	48 83 e8 04          	sub    $0x4,%rax
  8018e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018ed:	48 83 ea 04          	sub    $0x4,%rdx
  8018f1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018f5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8018f9:	48 89 c7             	mov    %rax,%rdi
  8018fc:	48 89 d6             	mov    %rdx,%rsi
  8018ff:	fd                   	std    
  801900:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801902:	eb 1d                	jmp    801921 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801904:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801908:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80190c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801910:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801914:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801918:	48 89 d7             	mov    %rdx,%rdi
  80191b:	48 89 c1             	mov    %rax,%rcx
  80191e:	fd                   	std    
  80191f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801921:	fc                   	cld    
  801922:	eb 57                	jmp    80197b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801924:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801928:	83 e0 03             	and    $0x3,%eax
  80192b:	48 85 c0             	test   %rax,%rax
  80192e:	75 36                	jne    801966 <memmove+0xfc>
  801930:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801934:	83 e0 03             	and    $0x3,%eax
  801937:	48 85 c0             	test   %rax,%rax
  80193a:	75 2a                	jne    801966 <memmove+0xfc>
  80193c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801940:	83 e0 03             	and    $0x3,%eax
  801943:	48 85 c0             	test   %rax,%rax
  801946:	75 1e                	jne    801966 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194c:	48 89 c1             	mov    %rax,%rcx
  80194f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801953:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801957:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80195b:	48 89 c7             	mov    %rax,%rdi
  80195e:	48 89 d6             	mov    %rdx,%rsi
  801961:	fc                   	cld    
  801962:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801964:	eb 15                	jmp    80197b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801966:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80196a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80196e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801972:	48 89 c7             	mov    %rax,%rdi
  801975:	48 89 d6             	mov    %rdx,%rsi
  801978:	fc                   	cld    
  801979:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80197b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80197f:	c9                   	leaveq 
  801980:	c3                   	retq   

0000000000801981 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801981:	55                   	push   %rbp
  801982:	48 89 e5             	mov    %rsp,%rbp
  801985:	48 83 ec 18          	sub    $0x18,%rsp
  801989:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80198d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801991:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801999:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80199d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a1:	48 89 ce             	mov    %rcx,%rsi
  8019a4:	48 89 c7             	mov    %rax,%rdi
  8019a7:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  8019ae:	00 00 00 
  8019b1:	ff d0                	callq  *%rax
}
  8019b3:	c9                   	leaveq 
  8019b4:	c3                   	retq   

00000000008019b5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019b5:	55                   	push   %rbp
  8019b6:	48 89 e5             	mov    %rsp,%rbp
  8019b9:	48 83 ec 28          	sub    $0x28,%rsp
  8019bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019d9:	eb 38                	jmp    801a13 <memcmp+0x5e>
		if (*s1 != *s2)
  8019db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019df:	0f b6 10             	movzbl (%rax),%edx
  8019e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e6:	0f b6 00             	movzbl (%rax),%eax
  8019e9:	38 c2                	cmp    %al,%dl
  8019eb:	74 1c                	je     801a09 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8019ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f1:	0f b6 00             	movzbl (%rax),%eax
  8019f4:	0f b6 d0             	movzbl %al,%edx
  8019f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019fb:	0f b6 00             	movzbl (%rax),%eax
  8019fe:	0f b6 c0             	movzbl %al,%eax
  801a01:	89 d1                	mov    %edx,%ecx
  801a03:	29 c1                	sub    %eax,%ecx
  801a05:	89 c8                	mov    %ecx,%eax
  801a07:	eb 20                	jmp    801a29 <memcmp+0x74>
		s1++, s2++;
  801a09:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a0e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a13:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a18:	0f 95 c0             	setne  %al
  801a1b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a20:	84 c0                	test   %al,%al
  801a22:	75 b7                	jne    8019db <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a29:	c9                   	leaveq 
  801a2a:	c3                   	retq   

0000000000801a2b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a2b:	55                   	push   %rbp
  801a2c:	48 89 e5             	mov    %rsp,%rbp
  801a2f:	48 83 ec 28          	sub    $0x28,%rsp
  801a33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a37:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a3a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a42:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a46:	48 01 d0             	add    %rdx,%rax
  801a49:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a4d:	eb 13                	jmp    801a62 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a53:	0f b6 10             	movzbl (%rax),%edx
  801a56:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a59:	38 c2                	cmp    %al,%dl
  801a5b:	74 11                	je     801a6e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a5d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a66:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a6a:	72 e3                	jb     801a4f <memfind+0x24>
  801a6c:	eb 01                	jmp    801a6f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a6e:	90                   	nop
	return (void *) s;
  801a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 38          	sub    $0x38,%rsp
  801a7d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a81:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a85:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a8f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a96:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a97:	eb 05                	jmp    801a9e <strtol+0x29>
		s++;
  801a99:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa2:	0f b6 00             	movzbl (%rax),%eax
  801aa5:	3c 20                	cmp    $0x20,%al
  801aa7:	74 f0                	je     801a99 <strtol+0x24>
  801aa9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aad:	0f b6 00             	movzbl (%rax),%eax
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 e5                	je     801a99 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab8:	0f b6 00             	movzbl (%rax),%eax
  801abb:	3c 2b                	cmp    $0x2b,%al
  801abd:	75 07                	jne    801ac6 <strtol+0x51>
		s++;
  801abf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ac4:	eb 17                	jmp    801add <strtol+0x68>
	else if (*s == '-')
  801ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aca:	0f b6 00             	movzbl (%rax),%eax
  801acd:	3c 2d                	cmp    $0x2d,%al
  801acf:	75 0c                	jne    801add <strtol+0x68>
		s++, neg = 1;
  801ad1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ad6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801add:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ae1:	74 06                	je     801ae9 <strtol+0x74>
  801ae3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801ae7:	75 28                	jne    801b11 <strtol+0x9c>
  801ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aed:	0f b6 00             	movzbl (%rax),%eax
  801af0:	3c 30                	cmp    $0x30,%al
  801af2:	75 1d                	jne    801b11 <strtol+0x9c>
  801af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af8:	48 83 c0 01          	add    $0x1,%rax
  801afc:	0f b6 00             	movzbl (%rax),%eax
  801aff:	3c 78                	cmp    $0x78,%al
  801b01:	75 0e                	jne    801b11 <strtol+0x9c>
		s += 2, base = 16;
  801b03:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801b08:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b0f:	eb 2c                	jmp    801b3d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b11:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b15:	75 19                	jne    801b30 <strtol+0xbb>
  801b17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b1b:	0f b6 00             	movzbl (%rax),%eax
  801b1e:	3c 30                	cmp    $0x30,%al
  801b20:	75 0e                	jne    801b30 <strtol+0xbb>
		s++, base = 8;
  801b22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b27:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b2e:	eb 0d                	jmp    801b3d <strtol+0xc8>
	else if (base == 0)
  801b30:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b34:	75 07                	jne    801b3d <strtol+0xc8>
		base = 10;
  801b36:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b41:	0f b6 00             	movzbl (%rax),%eax
  801b44:	3c 2f                	cmp    $0x2f,%al
  801b46:	7e 1d                	jle    801b65 <strtol+0xf0>
  801b48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4c:	0f b6 00             	movzbl (%rax),%eax
  801b4f:	3c 39                	cmp    $0x39,%al
  801b51:	7f 12                	jg     801b65 <strtol+0xf0>
			dig = *s - '0';
  801b53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b57:	0f b6 00             	movzbl (%rax),%eax
  801b5a:	0f be c0             	movsbl %al,%eax
  801b5d:	83 e8 30             	sub    $0x30,%eax
  801b60:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b63:	eb 4e                	jmp    801bb3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b69:	0f b6 00             	movzbl (%rax),%eax
  801b6c:	3c 60                	cmp    $0x60,%al
  801b6e:	7e 1d                	jle    801b8d <strtol+0x118>
  801b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b74:	0f b6 00             	movzbl (%rax),%eax
  801b77:	3c 7a                	cmp    $0x7a,%al
  801b79:	7f 12                	jg     801b8d <strtol+0x118>
			dig = *s - 'a' + 10;
  801b7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b7f:	0f b6 00             	movzbl (%rax),%eax
  801b82:	0f be c0             	movsbl %al,%eax
  801b85:	83 e8 57             	sub    $0x57,%eax
  801b88:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b8b:	eb 26                	jmp    801bb3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b91:	0f b6 00             	movzbl (%rax),%eax
  801b94:	3c 40                	cmp    $0x40,%al
  801b96:	7e 47                	jle    801bdf <strtol+0x16a>
  801b98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9c:	0f b6 00             	movzbl (%rax),%eax
  801b9f:	3c 5a                	cmp    $0x5a,%al
  801ba1:	7f 3c                	jg     801bdf <strtol+0x16a>
			dig = *s - 'A' + 10;
  801ba3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba7:	0f b6 00             	movzbl (%rax),%eax
  801baa:	0f be c0             	movsbl %al,%eax
  801bad:	83 e8 37             	sub    $0x37,%eax
  801bb0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801bb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bb6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801bb9:	7d 23                	jge    801bde <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801bbb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bc0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801bc3:	48 98                	cltq   
  801bc5:	48 89 c2             	mov    %rax,%rdx
  801bc8:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801bcd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bd0:	48 98                	cltq   
  801bd2:	48 01 d0             	add    %rdx,%rax
  801bd5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801bd9:	e9 5f ff ff ff       	jmpq   801b3d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bde:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801bdf:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801be4:	74 0b                	je     801bf1 <strtol+0x17c>
		*endptr = (char *) s;
  801be6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bee:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bf5:	74 09                	je     801c00 <strtol+0x18b>
  801bf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bfb:	48 f7 d8             	neg    %rax
  801bfe:	eb 04                	jmp    801c04 <strtol+0x18f>
  801c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c04:	c9                   	leaveq 
  801c05:	c3                   	retq   

0000000000801c06 <strstr>:

char * strstr(const char *in, const char *str)
{
  801c06:	55                   	push   %rbp
  801c07:	48 89 e5             	mov    %rsp,%rbp
  801c0a:	48 83 ec 30          	sub    $0x30,%rsp
  801c0e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c12:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801c16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c1a:	0f b6 00             	movzbl (%rax),%eax
  801c1d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801c20:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801c25:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c29:	75 06                	jne    801c31 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801c2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2f:	eb 68                	jmp    801c99 <strstr+0x93>

    len = strlen(str);
  801c31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c35:	48 89 c7             	mov    %rax,%rdi
  801c38:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
  801c44:	48 98                	cltq   
  801c46:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801c4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4e:	0f b6 00             	movzbl (%rax),%eax
  801c51:	88 45 ef             	mov    %al,-0x11(%rbp)
  801c54:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801c59:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c5d:	75 07                	jne    801c66 <strstr+0x60>
                return (char *) 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c64:	eb 33                	jmp    801c99 <strstr+0x93>
        } while (sc != c);
  801c66:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c6a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c6d:	75 db                	jne    801c4a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801c6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c73:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7b:	48 89 ce             	mov    %rcx,%rsi
  801c7e:	48 89 c7             	mov    %rax,%rdi
  801c81:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  801c88:	00 00 00 
  801c8b:	ff d0                	callq  *%rax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	75 b9                	jne    801c4a <strstr+0x44>

    return (char *) (in - 1);
  801c91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c95:	48 83 e8 01          	sub    $0x1,%rax
}
  801c99:	c9                   	leaveq 
  801c9a:	c3                   	retq   
	...

0000000000801c9c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c9c:	55                   	push   %rbp
  801c9d:	48 89 e5             	mov    %rsp,%rbp
  801ca0:	53                   	push   %rbx
  801ca1:	48 83 ec 58          	sub    $0x58,%rsp
  801ca5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ca8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801cab:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801caf:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801cb3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801cb7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cbb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cbe:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801cc1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801cc5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801cc9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ccd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801cd1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801cd5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801cd8:	4c 89 c3             	mov    %r8,%rbx
  801cdb:	cd 30                	int    $0x30
  801cdd:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801ce1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801ce5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801ce9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ced:	74 3e                	je     801d2d <syscall+0x91>
  801cef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cf4:	7e 37                	jle    801d2d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801cf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cfa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cfd:	49 89 d0             	mov    %rdx,%r8
  801d00:	89 c1                	mov    %eax,%ecx
  801d02:	48 ba 00 52 80 00 00 	movabs $0x805200,%rdx
  801d09:	00 00 00 
  801d0c:	be 23 00 00 00       	mov    $0x23,%esi
  801d11:	48 bf 1d 52 80 00 00 	movabs $0x80521d,%rdi
  801d18:	00 00 00 
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	49 b9 50 07 80 00 00 	movabs $0x800750,%r9
  801d27:	00 00 00 
  801d2a:	41 ff d1             	callq  *%r9

	return ret;
  801d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d31:	48 83 c4 58          	add    $0x58,%rsp
  801d35:	5b                   	pop    %rbx
  801d36:	5d                   	pop    %rbp
  801d37:	c3                   	retq   

0000000000801d38 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d38:	55                   	push   %rbp
  801d39:	48 89 e5             	mov    %rsp,%rbp
  801d3c:	48 83 ec 20          	sub    $0x20,%rsp
  801d40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d44:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d57:	00 
  801d58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d64:	48 89 d1             	mov    %rdx,%rcx
  801d67:	48 89 c2             	mov    %rax,%rdx
  801d6a:	be 00 00 00 00       	mov    $0x0,%esi
  801d6f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d74:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	callq  *%rax
}
  801d80:	c9                   	leaveq 
  801d81:	c3                   	retq   

0000000000801d82 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d82:	55                   	push   %rbp
  801d83:	48 89 e5             	mov    %rsp,%rbp
  801d86:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d91:	00 
  801d92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
  801da8:	be 00 00 00 00       	mov    $0x0,%esi
  801dad:	bf 01 00 00 00       	mov    $0x1,%edi
  801db2:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	callq  *%rax
}
  801dbe:	c9                   	leaveq 
  801dbf:	c3                   	retq   

0000000000801dc0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801dc0:	55                   	push   %rbp
  801dc1:	48 89 e5             	mov    %rsp,%rbp
  801dc4:	48 83 ec 20          	sub    $0x20,%rsp
  801dc8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dce:	48 98                	cltq   
  801dd0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd7:	00 
  801dd8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de9:	48 89 c2             	mov    %rax,%rdx
  801dec:	be 01 00 00 00       	mov    $0x1,%esi
  801df1:	bf 03 00 00 00       	mov    $0x3,%edi
  801df6:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
}
  801e02:	c9                   	leaveq 
  801e03:	c3                   	retq   

0000000000801e04 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801e04:	55                   	push   %rbp
  801e05:	48 89 e5             	mov    %rsp,%rbp
  801e08:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801e0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e13:	00 
  801e14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e20:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e25:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2a:	be 00 00 00 00       	mov    $0x0,%esi
  801e2f:	bf 02 00 00 00       	mov    $0x2,%edi
  801e34:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
}
  801e40:	c9                   	leaveq 
  801e41:	c3                   	retq   

0000000000801e42 <sys_yield>:

void
sys_yield(void)
{
  801e42:	55                   	push   %rbp
  801e43:	48 89 e5             	mov    %rsp,%rbp
  801e46:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e4a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e51:	00 
  801e52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e63:	ba 00 00 00 00       	mov    $0x0,%edx
  801e68:	be 00 00 00 00       	mov    $0x0,%esi
  801e6d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e72:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801e79:	00 00 00 
  801e7c:	ff d0                	callq  *%rax
}
  801e7e:	c9                   	leaveq 
  801e7f:	c3                   	retq   

0000000000801e80 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e80:	55                   	push   %rbp
  801e81:	48 89 e5             	mov    %rsp,%rbp
  801e84:	48 83 ec 20          	sub    $0x20,%rsp
  801e88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e8f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e95:	48 63 c8             	movslq %eax,%rcx
  801e98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e9f:	48 98                	cltq   
  801ea1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea8:	00 
  801ea9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eaf:	49 89 c8             	mov    %rcx,%r8
  801eb2:	48 89 d1             	mov    %rdx,%rcx
  801eb5:	48 89 c2             	mov    %rax,%rdx
  801eb8:	be 01 00 00 00       	mov    $0x1,%esi
  801ebd:	bf 04 00 00 00       	mov    $0x4,%edi
  801ec2:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801ec9:	00 00 00 
  801ecc:	ff d0                	callq  *%rax
}
  801ece:	c9                   	leaveq 
  801ecf:	c3                   	retq   

0000000000801ed0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	48 83 ec 30          	sub    $0x30,%rsp
  801ed8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801edb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801edf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ee2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ee6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801eea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801eed:	48 63 c8             	movslq %eax,%rcx
  801ef0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ef4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ef7:	48 63 f0             	movslq %eax,%rsi
  801efa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f01:	48 98                	cltq   
  801f03:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f07:	49 89 f9             	mov    %rdi,%r9
  801f0a:	49 89 f0             	mov    %rsi,%r8
  801f0d:	48 89 d1             	mov    %rdx,%rcx
  801f10:	48 89 c2             	mov    %rax,%rdx
  801f13:	be 01 00 00 00       	mov    $0x1,%esi
  801f18:	bf 05 00 00 00       	mov    $0x5,%edi
  801f1d:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801f24:	00 00 00 
  801f27:	ff d0                	callq  *%rax
}
  801f29:	c9                   	leaveq 
  801f2a:	c3                   	retq   

0000000000801f2b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f2b:	55                   	push   %rbp
  801f2c:	48 89 e5             	mov    %rsp,%rbp
  801f2f:	48 83 ec 20          	sub    $0x20,%rsp
  801f33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f41:	48 98                	cltq   
  801f43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f4a:	00 
  801f4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f57:	48 89 d1             	mov    %rdx,%rcx
  801f5a:	48 89 c2             	mov    %rax,%rdx
  801f5d:	be 01 00 00 00       	mov    $0x1,%esi
  801f62:	bf 06 00 00 00       	mov    $0x6,%edi
  801f67:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801f6e:	00 00 00 
  801f71:	ff d0                	callq  *%rax
}
  801f73:	c9                   	leaveq 
  801f74:	c3                   	retq   

0000000000801f75 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f75:	55                   	push   %rbp
  801f76:	48 89 e5             	mov    %rsp,%rbp
  801f79:	48 83 ec 20          	sub    $0x20,%rsp
  801f7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f80:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f86:	48 63 d0             	movslq %eax,%rdx
  801f89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8c:	48 98                	cltq   
  801f8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f95:	00 
  801f96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa2:	48 89 d1             	mov    %rdx,%rcx
  801fa5:	48 89 c2             	mov    %rax,%rdx
  801fa8:	be 01 00 00 00       	mov    $0x1,%esi
  801fad:	bf 08 00 00 00       	mov    $0x8,%edi
  801fb2:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  801fb9:	00 00 00 
  801fbc:	ff d0                	callq  *%rax
}
  801fbe:	c9                   	leaveq 
  801fbf:	c3                   	retq   

0000000000801fc0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801fc0:	55                   	push   %rbp
  801fc1:	48 89 e5             	mov    %rsp,%rbp
  801fc4:	48 83 ec 20          	sub    $0x20,%rsp
  801fc8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fcb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fcf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd6:	48 98                	cltq   
  801fd8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fdf:	00 
  801fe0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fe6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fec:	48 89 d1             	mov    %rdx,%rcx
  801fef:	48 89 c2             	mov    %rax,%rdx
  801ff2:	be 01 00 00 00       	mov    $0x1,%esi
  801ff7:	bf 09 00 00 00       	mov    $0x9,%edi
  801ffc:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  802003:	00 00 00 
  802006:	ff d0                	callq  *%rax
}
  802008:	c9                   	leaveq 
  802009:	c3                   	retq   

000000000080200a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80200a:	55                   	push   %rbp
  80200b:	48 89 e5             	mov    %rsp,%rbp
  80200e:	48 83 ec 20          	sub    $0x20,%rsp
  802012:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802015:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802019:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802020:	48 98                	cltq   
  802022:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802029:	00 
  80202a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802030:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802036:	48 89 d1             	mov    %rdx,%rcx
  802039:	48 89 c2             	mov    %rax,%rdx
  80203c:	be 01 00 00 00       	mov    $0x1,%esi
  802041:	bf 0a 00 00 00       	mov    $0xa,%edi
  802046:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  80204d:	00 00 00 
  802050:	ff d0                	callq  *%rax
}
  802052:	c9                   	leaveq 
  802053:	c3                   	retq   

0000000000802054 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802054:	55                   	push   %rbp
  802055:	48 89 e5             	mov    %rsp,%rbp
  802058:	48 83 ec 30          	sub    $0x30,%rsp
  80205c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80205f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802063:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802067:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80206a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80206d:	48 63 f0             	movslq %eax,%rsi
  802070:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802077:	48 98                	cltq   
  802079:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80207d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802084:	00 
  802085:	49 89 f1             	mov    %rsi,%r9
  802088:	49 89 c8             	mov    %rcx,%r8
  80208b:	48 89 d1             	mov    %rdx,%rcx
  80208e:	48 89 c2             	mov    %rax,%rdx
  802091:	be 00 00 00 00       	mov    $0x0,%esi
  802096:	bf 0c 00 00 00       	mov    $0xc,%edi
  80209b:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  8020a2:	00 00 00 
  8020a5:	ff d0                	callq  *%rax
}
  8020a7:	c9                   	leaveq 
  8020a8:	c3                   	retq   

00000000008020a9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8020a9:	55                   	push   %rbp
  8020aa:	48 89 e5             	mov    %rsp,%rbp
  8020ad:	48 83 ec 20          	sub    $0x20,%rsp
  8020b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8020b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020c0:	00 
  8020c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020d2:	48 89 c2             	mov    %rax,%rdx
  8020d5:	be 01 00 00 00       	mov    $0x1,%esi
  8020da:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020df:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  8020e6:	00 00 00 
  8020e9:	ff d0                	callq  *%rax
}
  8020eb:	c9                   	leaveq 
  8020ec:	c3                   	retq   

00000000008020ed <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8020ed:	55                   	push   %rbp
  8020ee:	48 89 e5             	mov    %rsp,%rbp
  8020f1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8020f5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020fc:	00 
  8020fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802103:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802109:	b9 00 00 00 00       	mov    $0x0,%ecx
  80210e:	ba 00 00 00 00       	mov    $0x0,%edx
  802113:	be 00 00 00 00       	mov    $0x0,%esi
  802118:	bf 0e 00 00 00       	mov    $0xe,%edi
  80211d:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 20          	sub    $0x20,%rsp
  802133:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802137:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  80213b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802143:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80214a:	00 
  80214b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802151:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802157:	48 89 d1             	mov    %rdx,%rcx
  80215a:	48 89 c2             	mov    %rax,%rdx
  80215d:	be 00 00 00 00       	mov    $0x0,%esi
  802162:	bf 0f 00 00 00       	mov    $0xf,%edi
  802167:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  80216e:	00 00 00 
  802171:	ff d0                	callq  *%rax
}
  802173:	c9                   	leaveq 
  802174:	c3                   	retq   

0000000000802175 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802175:	55                   	push   %rbp
  802176:	48 89 e5             	mov    %rsp,%rbp
  802179:	48 83 ec 20          	sub    $0x20,%rsp
  80217d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802181:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802185:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802189:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80218d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802194:	00 
  802195:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80219b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021a1:	48 89 d1             	mov    %rdx,%rcx
  8021a4:	48 89 c2             	mov    %rax,%rdx
  8021a7:	be 00 00 00 00       	mov    $0x0,%esi
  8021ac:	bf 10 00 00 00       	mov    $0x10,%edi
  8021b1:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	callq  *%rax
}
  8021bd:	c9                   	leaveq 
  8021be:	c3                   	retq   
	...

00000000008021c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021c0:	55                   	push   %rbp
  8021c1:	48 89 e5             	mov    %rsp,%rbp
  8021c4:	48 83 ec 08          	sub    $0x8,%rsp
  8021c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021d0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021d7:	ff ff ff 
  8021da:	48 01 d0             	add    %rdx,%rax
  8021dd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021e1:	c9                   	leaveq 
  8021e2:	c3                   	retq   

00000000008021e3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021e3:	55                   	push   %rbp
  8021e4:	48 89 e5             	mov    %rsp,%rbp
  8021e7:	48 83 ec 08          	sub    $0x8,%rsp
  8021eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f3:	48 89 c7             	mov    %rax,%rdi
  8021f6:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  8021fd:	00 00 00 
  802200:	ff d0                	callq  *%rax
  802202:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802208:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80220c:	c9                   	leaveq 
  80220d:	c3                   	retq   

000000000080220e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80220e:	55                   	push   %rbp
  80220f:	48 89 e5             	mov    %rsp,%rbp
  802212:	48 83 ec 18          	sub    $0x18,%rsp
  802216:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80221a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802221:	eb 6b                	jmp    80228e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802226:	48 98                	cltq   
  802228:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80222e:	48 c1 e0 0c          	shl    $0xc,%rax
  802232:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223a:	48 89 c2             	mov    %rax,%rdx
  80223d:	48 c1 ea 15          	shr    $0x15,%rdx
  802241:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802248:	01 00 00 
  80224b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224f:	83 e0 01             	and    $0x1,%eax
  802252:	48 85 c0             	test   %rax,%rax
  802255:	74 21                	je     802278 <fd_alloc+0x6a>
  802257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225b:	48 89 c2             	mov    %rax,%rdx
  80225e:	48 c1 ea 0c          	shr    $0xc,%rdx
  802262:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802269:	01 00 00 
  80226c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802270:	83 e0 01             	and    $0x1,%eax
  802273:	48 85 c0             	test   %rax,%rax
  802276:	75 12                	jne    80228a <fd_alloc+0x7c>
			*fd_store = fd;
  802278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802280:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	eb 1a                	jmp    8022a4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80228a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80228e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802292:	7e 8f                	jle    802223 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802298:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80229f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022a4:	c9                   	leaveq 
  8022a5:	c3                   	retq   

00000000008022a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022a6:	55                   	push   %rbp
  8022a7:	48 89 e5             	mov    %rsp,%rbp
  8022aa:	48 83 ec 20          	sub    $0x20,%rsp
  8022ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022b9:	78 06                	js     8022c1 <fd_lookup+0x1b>
  8022bb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022bf:	7e 07                	jle    8022c8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c6:	eb 6c                	jmp    802334 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022cb:	48 98                	cltq   
  8022cd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022d3:	48 c1 e0 0c          	shl    $0xc,%rax
  8022d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022df:	48 89 c2             	mov    %rax,%rdx
  8022e2:	48 c1 ea 15          	shr    $0x15,%rdx
  8022e6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ed:	01 00 00 
  8022f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f4:	83 e0 01             	and    $0x1,%eax
  8022f7:	48 85 c0             	test   %rax,%rax
  8022fa:	74 21                	je     80231d <fd_lookup+0x77>
  8022fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802300:	48 89 c2             	mov    %rax,%rdx
  802303:	48 c1 ea 0c          	shr    $0xc,%rdx
  802307:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80230e:	01 00 00 
  802311:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802315:	83 e0 01             	and    $0x1,%eax
  802318:	48 85 c0             	test   %rax,%rax
  80231b:	75 07                	jne    802324 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80231d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802322:	eb 10                	jmp    802334 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802324:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802328:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80232c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802334:	c9                   	leaveq 
  802335:	c3                   	retq   

0000000000802336 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802336:	55                   	push   %rbp
  802337:	48 89 e5             	mov    %rsp,%rbp
  80233a:	48 83 ec 30          	sub    $0x30,%rsp
  80233e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802342:	89 f0                	mov    %esi,%eax
  802344:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802347:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80234b:	48 89 c7             	mov    %rax,%rdi
  80234e:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802355:	00 00 00 
  802358:	ff d0                	callq  *%rax
  80235a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80235e:	48 89 d6             	mov    %rdx,%rsi
  802361:	89 c7                	mov    %eax,%edi
  802363:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  80236a:	00 00 00 
  80236d:	ff d0                	callq  *%rax
  80236f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802372:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802376:	78 0a                	js     802382 <fd_close+0x4c>
	    || fd != fd2)
  802378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802380:	74 12                	je     802394 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802382:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802386:	74 05                	je     80238d <fd_close+0x57>
  802388:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238b:	eb 05                	jmp    802392 <fd_close+0x5c>
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
  802392:	eb 69                	jmp    8023fd <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802394:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802398:	8b 00                	mov    (%rax),%eax
  80239a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80239e:	48 89 d6             	mov    %rdx,%rsi
  8023a1:	89 c7                	mov    %eax,%edi
  8023a3:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  8023aa:	00 00 00 
  8023ad:	ff d0                	callq  *%rax
  8023af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b6:	78 2a                	js     8023e2 <fd_close+0xac>
		if (dev->dev_close)
  8023b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bc:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023c0:	48 85 c0             	test   %rax,%rax
  8023c3:	74 16                	je     8023db <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c9:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8023cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023d1:	48 89 c7             	mov    %rax,%rdi
  8023d4:	ff d2                	callq  *%rdx
  8023d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d9:	eb 07                	jmp    8023e2 <fd_close+0xac>
		else
			r = 0;
  8023db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e6:	48 89 c6             	mov    %rax,%rsi
  8023e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ee:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8023f5:	00 00 00 
  8023f8:	ff d0                	callq  *%rax
	return r;
  8023fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023fd:	c9                   	leaveq 
  8023fe:	c3                   	retq   

00000000008023ff <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023ff:	55                   	push   %rbp
  802400:	48 89 e5             	mov    %rsp,%rbp
  802403:	48 83 ec 20          	sub    $0x20,%rsp
  802407:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80240a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80240e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802415:	eb 41                	jmp    802458 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802417:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  80241e:	00 00 00 
  802421:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802424:	48 63 d2             	movslq %edx,%rdx
  802427:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242b:	8b 00                	mov    (%rax),%eax
  80242d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802430:	75 22                	jne    802454 <dev_lookup+0x55>
			*dev = devtab[i];
  802432:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  802439:	00 00 00 
  80243c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80243f:	48 63 d2             	movslq %edx,%rdx
  802442:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802446:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80244a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	eb 60                	jmp    8024b4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802454:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802458:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  80245f:	00 00 00 
  802462:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802465:	48 63 d2             	movslq %edx,%rdx
  802468:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246c:	48 85 c0             	test   %rax,%rax
  80246f:	75 a6                	jne    802417 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802471:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  802478:	00 00 00 
  80247b:	48 8b 00             	mov    (%rax),%rax
  80247e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802484:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802487:	89 c6                	mov    %eax,%esi
  802489:	48 bf 30 52 80 00 00 	movabs $0x805230,%rdi
  802490:	00 00 00 
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
  802498:	48 b9 8b 09 80 00 00 	movabs $0x80098b,%rcx
  80249f:	00 00 00 
  8024a2:	ff d1                	callq  *%rcx
	*dev = 0;
  8024a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024b4:	c9                   	leaveq 
  8024b5:	c3                   	retq   

00000000008024b6 <close>:

int
close(int fdnum)
{
  8024b6:	55                   	push   %rbp
  8024b7:	48 89 e5             	mov    %rsp,%rbp
  8024ba:	48 83 ec 20          	sub    $0x20,%rsp
  8024be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024c8:	48 89 d6             	mov    %rdx,%rsi
  8024cb:	89 c7                	mov    %eax,%edi
  8024cd:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  8024d4:	00 00 00 
  8024d7:	ff d0                	callq  *%rax
  8024d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e0:	79 05                	jns    8024e7 <close+0x31>
		return r;
  8024e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e5:	eb 18                	jmp    8024ff <close+0x49>
	else
		return fd_close(fd, 1);
  8024e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024eb:	be 01 00 00 00       	mov    $0x1,%esi
  8024f0:	48 89 c7             	mov    %rax,%rdi
  8024f3:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8024fa:	00 00 00 
  8024fd:	ff d0                	callq  *%rax
}
  8024ff:	c9                   	leaveq 
  802500:	c3                   	retq   

0000000000802501 <close_all>:

void
close_all(void)
{
  802501:	55                   	push   %rbp
  802502:	48 89 e5             	mov    %rsp,%rbp
  802505:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802509:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802510:	eb 15                	jmp    802527 <close_all+0x26>
		close(i);
  802512:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802515:	89 c7                	mov    %eax,%edi
  802517:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  80251e:	00 00 00 
  802521:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802523:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802527:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80252b:	7e e5                	jle    802512 <close_all+0x11>
		close(i);
}
  80252d:	c9                   	leaveq 
  80252e:	c3                   	retq   

000000000080252f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80252f:	55                   	push   %rbp
  802530:	48 89 e5             	mov    %rsp,%rbp
  802533:	48 83 ec 40          	sub    $0x40,%rsp
  802537:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80253a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80253d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802541:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802544:	48 89 d6             	mov    %rdx,%rsi
  802547:	89 c7                	mov    %eax,%edi
  802549:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax
  802555:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802558:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255c:	79 08                	jns    802566 <dup+0x37>
		return r;
  80255e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802561:	e9 70 01 00 00       	jmpq   8026d6 <dup+0x1a7>
	close(newfdnum);
  802566:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802569:	89 c7                	mov    %eax,%edi
  80256b:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  802572:	00 00 00 
  802575:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802577:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80257a:	48 98                	cltq   
  80257c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802582:	48 c1 e0 0c          	shl    $0xc,%rax
  802586:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80258a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258e:	48 89 c7             	mov    %rax,%rdi
  802591:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  802598:	00 00 00 
  80259b:	ff d0                	callq  *%rax
  80259d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a5:	48 89 c7             	mov    %rax,%rdi
  8025a8:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  8025af:	00 00 00 
  8025b2:	ff d0                	callq  *%rax
  8025b4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bc:	48 89 c2             	mov    %rax,%rdx
  8025bf:	48 c1 ea 15          	shr    $0x15,%rdx
  8025c3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025ca:	01 00 00 
  8025cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d1:	83 e0 01             	and    $0x1,%eax
  8025d4:	84 c0                	test   %al,%al
  8025d6:	74 71                	je     802649 <dup+0x11a>
  8025d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025dc:	48 89 c2             	mov    %rax,%rdx
  8025df:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ea:	01 00 00 
  8025ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f1:	83 e0 01             	and    $0x1,%eax
  8025f4:	84 c0                	test   %al,%al
  8025f6:	74 51                	je     802649 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fc:	48 89 c2             	mov    %rax,%rdx
  8025ff:	48 c1 ea 0c          	shr    $0xc,%rdx
  802603:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80260a:	01 00 00 
  80260d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802611:	89 c1                	mov    %eax,%ecx
  802613:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802619:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80261d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802621:	41 89 c8             	mov    %ecx,%r8d
  802624:	48 89 d1             	mov    %rdx,%rcx
  802627:	ba 00 00 00 00       	mov    $0x0,%edx
  80262c:	48 89 c6             	mov    %rax,%rsi
  80262f:	bf 00 00 00 00       	mov    $0x0,%edi
  802634:	48 b8 d0 1e 80 00 00 	movabs $0x801ed0,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802643:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802647:	78 56                	js     80269f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80264d:	48 89 c2             	mov    %rax,%rdx
  802650:	48 c1 ea 0c          	shr    $0xc,%rdx
  802654:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80265b:	01 00 00 
  80265e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802662:	89 c1                	mov    %eax,%ecx
  802664:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80266a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802672:	41 89 c8             	mov    %ecx,%r8d
  802675:	48 89 d1             	mov    %rdx,%rcx
  802678:	ba 00 00 00 00       	mov    $0x0,%edx
  80267d:	48 89 c6             	mov    %rax,%rsi
  802680:	bf 00 00 00 00       	mov    $0x0,%edi
  802685:	48 b8 d0 1e 80 00 00 	movabs $0x801ed0,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802698:	78 08                	js     8026a2 <dup+0x173>
		goto err;

	return newfdnum;
  80269a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80269d:	eb 37                	jmp    8026d6 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80269f:	90                   	nop
  8026a0:	eb 01                	jmp    8026a3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8026a2:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8026a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a7:	48 89 c6             	mov    %rax,%rsi
  8026aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8026af:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8026b6:	00 00 00 
  8026b9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026bf:	48 89 c6             	mov    %rax,%rsi
  8026c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c7:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8026ce:	00 00 00 
  8026d1:	ff d0                	callq  *%rax
	return r;
  8026d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026d6:	c9                   	leaveq 
  8026d7:	c3                   	retq   

00000000008026d8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026d8:	55                   	push   %rbp
  8026d9:	48 89 e5             	mov    %rsp,%rbp
  8026dc:	48 83 ec 40          	sub    $0x40,%rsp
  8026e0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026eb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026f2:	48 89 d6             	mov    %rdx,%rsi
  8026f5:	89 c7                	mov    %eax,%edi
  8026f7:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  8026fe:	00 00 00 
  802701:	ff d0                	callq  *%rax
  802703:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802706:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270a:	78 24                	js     802730 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80270c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802710:	8b 00                	mov    (%rax),%eax
  802712:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802716:	48 89 d6             	mov    %rdx,%rsi
  802719:	89 c7                	mov    %eax,%edi
  80271b:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802722:	00 00 00 
  802725:	ff d0                	callq  *%rax
  802727:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272e:	79 05                	jns    802735 <read+0x5d>
		return r;
  802730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802733:	eb 7a                	jmp    8027af <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802739:	8b 40 08             	mov    0x8(%rax),%eax
  80273c:	83 e0 03             	and    $0x3,%eax
  80273f:	83 f8 01             	cmp    $0x1,%eax
  802742:	75 3a                	jne    80277e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802744:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  80274b:	00 00 00 
  80274e:	48 8b 00             	mov    (%rax),%rax
  802751:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802757:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80275a:	89 c6                	mov    %eax,%esi
  80275c:	48 bf 4f 52 80 00 00 	movabs $0x80524f,%rdi
  802763:	00 00 00 
  802766:	b8 00 00 00 00       	mov    $0x0,%eax
  80276b:	48 b9 8b 09 80 00 00 	movabs $0x80098b,%rcx
  802772:	00 00 00 
  802775:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802777:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80277c:	eb 31                	jmp    8027af <read+0xd7>
	}
	if (!dev->dev_read)
  80277e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802782:	48 8b 40 10          	mov    0x10(%rax),%rax
  802786:	48 85 c0             	test   %rax,%rax
  802789:	75 07                	jne    802792 <read+0xba>
		return -E_NOT_SUPP;
  80278b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802790:	eb 1d                	jmp    8027af <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802796:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80279a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027a2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027a6:	48 89 ce             	mov    %rcx,%rsi
  8027a9:	48 89 c7             	mov    %rax,%rdi
  8027ac:	41 ff d0             	callq  *%r8
}
  8027af:	c9                   	leaveq 
  8027b0:	c3                   	retq   

00000000008027b1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027b1:	55                   	push   %rbp
  8027b2:	48 89 e5             	mov    %rsp,%rbp
  8027b5:	48 83 ec 30          	sub    $0x30,%rsp
  8027b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027cb:	eb 46                	jmp    802813 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d0:	48 98                	cltq   
  8027d2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d6:	48 29 c2             	sub    %rax,%rdx
  8027d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027dc:	48 98                	cltq   
  8027de:	48 89 c1             	mov    %rax,%rcx
  8027e1:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8027e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027e8:	48 89 ce             	mov    %rcx,%rsi
  8027eb:	89 c7                	mov    %eax,%edi
  8027ed:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	callq  *%rax
  8027f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802800:	79 05                	jns    802807 <readn+0x56>
			return m;
  802802:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802805:	eb 1d                	jmp    802824 <readn+0x73>
		if (m == 0)
  802807:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80280b:	74 13                	je     802820 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80280d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802810:	01 45 fc             	add    %eax,-0x4(%rbp)
  802813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802816:	48 98                	cltq   
  802818:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80281c:	72 af                	jb     8027cd <readn+0x1c>
  80281e:	eb 01                	jmp    802821 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802820:	90                   	nop
	}
	return tot;
  802821:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802824:	c9                   	leaveq 
  802825:	c3                   	retq   

0000000000802826 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802826:	55                   	push   %rbp
  802827:	48 89 e5             	mov    %rsp,%rbp
  80282a:	48 83 ec 40          	sub    $0x40,%rsp
  80282e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802831:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802835:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802839:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80283d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802840:	48 89 d6             	mov    %rdx,%rsi
  802843:	89 c7                	mov    %eax,%edi
  802845:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	callq  *%rax
  802851:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802854:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802858:	78 24                	js     80287e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80285a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285e:	8b 00                	mov    (%rax),%eax
  802860:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802864:	48 89 d6             	mov    %rdx,%rsi
  802867:	89 c7                	mov    %eax,%edi
  802869:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802870:	00 00 00 
  802873:	ff d0                	callq  *%rax
  802875:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802878:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287c:	79 05                	jns    802883 <write+0x5d>
		return r;
  80287e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802881:	eb 79                	jmp    8028fc <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802887:	8b 40 08             	mov    0x8(%rax),%eax
  80288a:	83 e0 03             	and    $0x3,%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	75 3a                	jne    8028cb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802891:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  802898:	00 00 00 
  80289b:	48 8b 00             	mov    (%rax),%rax
  80289e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028a7:	89 c6                	mov    %eax,%esi
  8028a9:	48 bf 6b 52 80 00 00 	movabs $0x80526b,%rdi
  8028b0:	00 00 00 
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	48 b9 8b 09 80 00 00 	movabs $0x80098b,%rcx
  8028bf:	00 00 00 
  8028c2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c9:	eb 31                	jmp    8028fc <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8028cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cf:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028d3:	48 85 c0             	test   %rax,%rax
  8028d6:	75 07                	jne    8028df <write+0xb9>
		return -E_NOT_SUPP;
  8028d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028dd:	eb 1d                	jmp    8028fc <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8028df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e3:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8028e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028eb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028ef:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028f3:	48 89 ce             	mov    %rcx,%rsi
  8028f6:	48 89 c7             	mov    %rax,%rdi
  8028f9:	41 ff d0             	callq  *%r8
}
  8028fc:	c9                   	leaveq 
  8028fd:	c3                   	retq   

00000000008028fe <seek>:

int
seek(int fdnum, off_t offset)
{
  8028fe:	55                   	push   %rbp
  8028ff:	48 89 e5             	mov    %rsp,%rbp
  802902:	48 83 ec 18          	sub    $0x18,%rsp
  802906:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802909:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80290c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802910:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802913:	48 89 d6             	mov    %rdx,%rsi
  802916:	89 c7                	mov    %eax,%edi
  802918:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
  802924:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802927:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80292b:	79 05                	jns    802932 <seek+0x34>
		return r;
  80292d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802930:	eb 0f                	jmp    802941 <seek+0x43>
	fd->fd_offset = offset;
  802932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802936:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802939:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802941:	c9                   	leaveq 
  802942:	c3                   	retq   

0000000000802943 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802943:	55                   	push   %rbp
  802944:	48 89 e5             	mov    %rsp,%rbp
  802947:	48 83 ec 30          	sub    $0x30,%rsp
  80294b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80294e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802951:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802955:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802958:	48 89 d6             	mov    %rdx,%rsi
  80295b:	89 c7                	mov    %eax,%edi
  80295d:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  802964:	00 00 00 
  802967:	ff d0                	callq  *%rax
  802969:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802970:	78 24                	js     802996 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802976:	8b 00                	mov    (%rax),%eax
  802978:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80297c:	48 89 d6             	mov    %rdx,%rsi
  80297f:	89 c7                	mov    %eax,%edi
  802981:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802988:	00 00 00 
  80298b:	ff d0                	callq  *%rax
  80298d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802990:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802994:	79 05                	jns    80299b <ftruncate+0x58>
		return r;
  802996:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802999:	eb 72                	jmp    802a0d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80299b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299f:	8b 40 08             	mov    0x8(%rax),%eax
  8029a2:	83 e0 03             	and    $0x3,%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	75 3a                	jne    8029e3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029a9:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  8029b0:	00 00 00 
  8029b3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029bf:	89 c6                	mov    %eax,%esi
  8029c1:	48 bf 88 52 80 00 00 	movabs $0x805288,%rdi
  8029c8:	00 00 00 
  8029cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d0:	48 b9 8b 09 80 00 00 	movabs $0x80098b,%rcx
  8029d7:	00 00 00 
  8029da:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8029dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029e1:	eb 2a                	jmp    802a0d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029eb:	48 85 c0             	test   %rax,%rax
  8029ee:	75 07                	jne    8029f7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029f5:	eb 16                	jmp    802a0d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fb:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8029ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a03:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802a06:	89 d6                	mov    %edx,%esi
  802a08:	48 89 c7             	mov    %rax,%rdi
  802a0b:	ff d1                	callq  *%rcx
}
  802a0d:	c9                   	leaveq 
  802a0e:	c3                   	retq   

0000000000802a0f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a0f:	55                   	push   %rbp
  802a10:	48 89 e5             	mov    %rsp,%rbp
  802a13:	48 83 ec 30          	sub    $0x30,%rsp
  802a17:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a1a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a1e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a22:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a25:	48 89 d6             	mov    %rdx,%rsi
  802a28:	89 c7                	mov    %eax,%edi
  802a2a:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3d:	78 24                	js     802a63 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a43:	8b 00                	mov    (%rax),%eax
  802a45:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a49:	48 89 d6             	mov    %rdx,%rsi
  802a4c:	89 c7                	mov    %eax,%edi
  802a4e:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
  802a5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a61:	79 05                	jns    802a68 <fstat+0x59>
		return r;
  802a63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a66:	eb 5e                	jmp    802ac6 <fstat+0xb7>
	if (!dev->dev_stat)
  802a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a70:	48 85 c0             	test   %rax,%rax
  802a73:	75 07                	jne    802a7c <fstat+0x6d>
		return -E_NOT_SUPP;
  802a75:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a7a:	eb 4a                	jmp    802ac6 <fstat+0xb7>
	stat->st_name[0] = 0;
  802a7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a80:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a87:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a8e:	00 00 00 
	stat->st_isdir = 0;
  802a91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a95:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a9c:	00 00 00 
	stat->st_dev = dev;
  802a9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aa3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aa7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802aae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab2:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aba:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802abe:	48 89 d6             	mov    %rdx,%rsi
  802ac1:	48 89 c7             	mov    %rax,%rdi
  802ac4:	ff d1                	callq  *%rcx
}
  802ac6:	c9                   	leaveq 
  802ac7:	c3                   	retq   

0000000000802ac8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ac8:	55                   	push   %rbp
  802ac9:	48 89 e5             	mov    %rsp,%rbp
  802acc:	48 83 ec 20          	sub    $0x20,%rsp
  802ad0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ad4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802adc:	be 00 00 00 00       	mov    $0x0,%esi
  802ae1:	48 89 c7             	mov    %rax,%rdi
  802ae4:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	callq  *%rax
  802af0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af7:	79 05                	jns    802afe <stat+0x36>
		return fd;
  802af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afc:	eb 2f                	jmp    802b2d <stat+0x65>
	r = fstat(fd, stat);
  802afe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b05:	48 89 d6             	mov    %rdx,%rsi
  802b08:	89 c7                	mov    %eax,%edi
  802b0a:	48 b8 0f 2a 80 00 00 	movabs $0x802a0f,%rax
  802b11:	00 00 00 
  802b14:	ff d0                	callq  *%rax
  802b16:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1c:	89 c7                	mov    %eax,%edi
  802b1e:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  802b25:	00 00 00 
  802b28:	ff d0                	callq  *%rax
	return r;
  802b2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b2d:	c9                   	leaveq 
  802b2e:	c3                   	retq   
	...

0000000000802b30 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b30:	55                   	push   %rbp
  802b31:	48 89 e5             	mov    %rsp,%rbp
  802b34:	48 83 ec 10          	sub    $0x10,%rsp
  802b38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b3f:	48 b8 24 90 80 00 00 	movabs $0x809024,%rax
  802b46:	00 00 00 
  802b49:	8b 00                	mov    (%rax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	75 1d                	jne    802b6c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b4f:	bf 01 00 00 00       	mov    $0x1,%edi
  802b54:	48 b8 cf 4a 80 00 00 	movabs $0x804acf,%rax
  802b5b:	00 00 00 
  802b5e:	ff d0                	callq  *%rax
  802b60:	48 ba 24 90 80 00 00 	movabs $0x809024,%rdx
  802b67:	00 00 00 
  802b6a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b6c:	48 b8 24 90 80 00 00 	movabs $0x809024,%rax
  802b73:	00 00 00 
  802b76:	8b 00                	mov    (%rax),%eax
  802b78:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b7b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b80:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  802b87:	00 00 00 
  802b8a:	89 c7                	mov    %eax,%edi
  802b8c:	48 b8 0c 4a 80 00 00 	movabs $0x804a0c,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba1:	48 89 c6             	mov    %rax,%rsi
  802ba4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba9:	48 b8 4c 49 80 00 00 	movabs $0x80494c,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
}
  802bb5:	c9                   	leaveq 
  802bb6:	c3                   	retq   

0000000000802bb7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802bb7:	55                   	push   %rbp
  802bb8:	48 89 e5             	mov    %rsp,%rbp
  802bbb:	48 83 ec 20          	sub    $0x20,%rsp
  802bbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bc3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bca:	48 89 c7             	mov    %rax,%rdi
  802bcd:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
  802bd9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bde:	7e 0a                	jle    802bea <open+0x33>
                return -E_BAD_PATH;
  802be0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802be5:	e9 a5 00 00 00       	jmpq   802c8f <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802bea:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802bee:	48 89 c7             	mov    %rax,%rdi
  802bf1:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  802bf8:	00 00 00 
  802bfb:	ff d0                	callq  *%rax
  802bfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c04:	79 08                	jns    802c0e <open+0x57>
		return r;
  802c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c09:	e9 81 00 00 00       	jmpq   802c8f <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802c0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c12:	48 89 c6             	mov    %rax,%rsi
  802c15:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  802c1c:	00 00 00 
  802c1f:	48 b8 48 15 80 00 00 	movabs $0x801548,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802c2b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802c32:	00 00 00 
  802c35:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802c38:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802c3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c42:	48 89 c6             	mov    %rax,%rsi
  802c45:	bf 01 00 00 00       	mov    $0x1,%edi
  802c4a:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802c59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5d:	79 1d                	jns    802c7c <open+0xc5>
	{
		fd_close(fd,0);
  802c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c63:	be 00 00 00 00       	mov    $0x0,%esi
  802c68:	48 89 c7             	mov    %rax,%rdi
  802c6b:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
		return r;
  802c77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7a:	eb 13                	jmp    802c8f <open+0xd8>
	}
	return fd2num(fd);
  802c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c80:	48 89 c7             	mov    %rax,%rdi
  802c83:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
	


}
  802c8f:	c9                   	leaveq 
  802c90:	c3                   	retq   

0000000000802c91 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c91:	55                   	push   %rbp
  802c92:	48 89 e5             	mov    %rsp,%rbp
  802c95:	48 83 ec 10          	sub    $0x10,%rsp
  802c99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca1:	8b 50 0c             	mov    0xc(%rax),%edx
  802ca4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802cab:	00 00 00 
  802cae:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802cb0:	be 00 00 00 00       	mov    $0x0,%esi
  802cb5:	bf 06 00 00 00       	mov    $0x6,%edi
  802cba:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802cc1:	00 00 00 
  802cc4:	ff d0                	callq  *%rax
}
  802cc6:	c9                   	leaveq 
  802cc7:	c3                   	retq   

0000000000802cc8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802cc8:	55                   	push   %rbp
  802cc9:	48 89 e5             	mov    %rsp,%rbp
  802ccc:	48 83 ec 30          	sub    $0x30,%rsp
  802cd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cd4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802cdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce0:	8b 50 0c             	mov    0xc(%rax),%edx
  802ce3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802cea:	00 00 00 
  802ced:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802cef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802cf6:	00 00 00 
  802cf9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cfd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802d01:	be 00 00 00 00       	mov    $0x0,%esi
  802d06:	bf 03 00 00 00       	mov    $0x3,%edi
  802d0b:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802d12:	00 00 00 
  802d15:	ff d0                	callq  *%rax
  802d17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d1e:	79 05                	jns    802d25 <devfile_read+0x5d>
	{
		return r;
  802d20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d23:	eb 2c                	jmp    802d51 <devfile_read+0x89>
	}
	if(r > 0)
  802d25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d29:	7e 23                	jle    802d4e <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2e:	48 63 d0             	movslq %eax,%rdx
  802d31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d35:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802d3c:	00 00 00 
  802d3f:	48 89 c7             	mov    %rax,%rdi
  802d42:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
	return r;
  802d4e:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802d51:	c9                   	leaveq 
  802d52:	c3                   	retq   

0000000000802d53 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d53:	55                   	push   %rbp
  802d54:	48 89 e5             	mov    %rsp,%rbp
  802d57:	48 83 ec 30          	sub    $0x30,%rsp
  802d5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d63:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802d67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6b:	8b 50 0c             	mov    0xc(%rax),%edx
  802d6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d75:	00 00 00 
  802d78:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802d7a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d81:	00 
  802d82:	76 08                	jbe    802d8c <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802d84:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d8b:	00 
	fsipcbuf.write.req_n=n;
  802d8c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d93:	00 00 00 
  802d96:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d9a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802d9e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802da2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802da6:	48 89 c6             	mov    %rax,%rsi
  802da9:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  802db0:	00 00 00 
  802db3:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802dbf:	be 00 00 00 00       	mov    $0x0,%esi
  802dc4:	bf 04 00 00 00       	mov    $0x4,%edi
  802dc9:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
  802dd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ddb:	c9                   	leaveq 
  802ddc:	c3                   	retq   

0000000000802ddd <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802ddd:	55                   	push   %rbp
  802dde:	48 89 e5             	mov    %rsp,%rbp
  802de1:	48 83 ec 10          	sub    $0x10,%rsp
  802de5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802de9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df0:	8b 50 0c             	mov    0xc(%rax),%edx
  802df3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802dfa:	00 00 00 
  802dfd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802dff:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e06:	00 00 00 
  802e09:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e0c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e0f:	be 00 00 00 00       	mov    $0x0,%esi
  802e14:	bf 02 00 00 00       	mov    $0x2,%edi
  802e19:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
}
  802e25:	c9                   	leaveq 
  802e26:	c3                   	retq   

0000000000802e27 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e27:	55                   	push   %rbp
  802e28:	48 89 e5             	mov    %rsp,%rbp
  802e2b:	48 83 ec 20          	sub    $0x20,%rsp
  802e2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3b:	8b 50 0c             	mov    0xc(%rax),%edx
  802e3e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e45:	00 00 00 
  802e48:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e4a:	be 00 00 00 00       	mov    $0x0,%esi
  802e4f:	bf 05 00 00 00       	mov    $0x5,%edi
  802e54:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802e5b:	00 00 00 
  802e5e:	ff d0                	callq  *%rax
  802e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e67:	79 05                	jns    802e6e <devfile_stat+0x47>
		return r;
  802e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6c:	eb 56                	jmp    802ec4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e72:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802e79:	00 00 00 
  802e7c:	48 89 c7             	mov    %rax,%rdi
  802e7f:	48 b8 48 15 80 00 00 	movabs $0x801548,%rax
  802e86:	00 00 00 
  802e89:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e8b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e92:	00 00 00 
  802e95:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e9f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ea5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802eac:	00 00 00 
  802eaf:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802eb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eb9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ec4:	c9                   	leaveq 
  802ec5:	c3                   	retq   
	...

0000000000802ec8 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802ec8:	55                   	push   %rbp
  802ec9:	48 89 e5             	mov    %rsp,%rbp
  802ecc:	53                   	push   %rbx
  802ecd:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  802ed4:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  802edb:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802ee2:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  802ee9:	be 00 00 00 00       	mov    $0x0,%esi
  802eee:	48 89 c7             	mov    %rax,%rdi
  802ef1:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802ef8:	00 00 00 
  802efb:	ff d0                	callq  *%rax
  802efd:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802f00:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802f04:	79 08                	jns    802f0e <spawn+0x46>
		return r;
  802f06:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f09:	e9 1d 03 00 00       	jmpq   80322b <spawn+0x363>
	fd = r;
  802f0e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f11:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802f14:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  802f1b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802f1f:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  802f26:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f29:	ba 00 02 00 00       	mov    $0x200,%edx
  802f2e:	48 89 ce             	mov    %rcx,%rsi
  802f31:	89 c7                	mov    %eax,%edi
  802f33:	48 b8 b1 27 80 00 00 	movabs $0x8027b1,%rax
  802f3a:	00 00 00 
  802f3d:	ff d0                	callq  *%rax
  802f3f:	3d 00 02 00 00       	cmp    $0x200,%eax
  802f44:	75 0d                	jne    802f53 <spawn+0x8b>
	    || elf->e_magic != ELF_MAGIC) {
  802f46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f4a:	8b 00                	mov    (%rax),%eax
  802f4c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802f51:	74 43                	je     802f96 <spawn+0xce>
		close(fd);
  802f53:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f56:	89 c7                	mov    %eax,%edi
  802f58:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  802f5f:	00 00 00 
  802f62:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802f64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f68:	8b 00                	mov    (%rax),%eax
  802f6a:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802f6f:	89 c6                	mov    %eax,%esi
  802f71:	48 bf b0 52 80 00 00 	movabs $0x8052b0,%rdi
  802f78:	00 00 00 
  802f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f80:	48 b9 8b 09 80 00 00 	movabs $0x80098b,%rcx
  802f87:	00 00 00 
  802f8a:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802f8c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f91:	e9 95 02 00 00       	jmpq   80322b <spawn+0x363>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802f96:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  802f9d:	00 00 00 
  802fa0:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  802fa6:	cd 30                	int    $0x30
  802fa8:	89 c3                	mov    %eax,%ebx
  802faa:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802fad:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802fb0:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802fb3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802fb7:	79 08                	jns    802fc1 <spawn+0xf9>
		return r;
  802fb9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802fbc:	e9 6a 02 00 00       	jmpq   80322b <spawn+0x363>
	child = r;
  802fc1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802fc4:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802fc7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802fca:	25 ff 03 00 00       	and    $0x3ff,%eax
  802fcf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802fd6:	00 00 00 
  802fd9:	48 63 d0             	movslq %eax,%rdx
  802fdc:	48 89 d0             	mov    %rdx,%rax
  802fdf:	48 c1 e0 03          	shl    $0x3,%rax
  802fe3:	48 01 d0             	add    %rdx,%rax
  802fe6:	48 c1 e0 05          	shl    $0x5,%rax
  802fea:	48 01 c8             	add    %rcx,%rax
  802fed:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802ff4:	48 89 c6             	mov    %rax,%rsi
  802ff7:	b8 18 00 00 00       	mov    $0x18,%eax
  802ffc:	48 89 d7             	mov    %rdx,%rdi
  802fff:	48 89 c1             	mov    %rax,%rcx
  803002:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803005:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803009:	48 8b 40 18          	mov    0x18(%rax),%rax
  80300d:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803014:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  80301b:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803022:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  803029:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80302c:	48 89 ce             	mov    %rcx,%rsi
  80302f:	89 c7                	mov    %eax,%edi
  803031:	48 b8 83 34 80 00 00 	movabs $0x803483,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
  80303d:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803040:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803044:	79 08                	jns    80304e <spawn+0x186>
		return r;
  803046:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803049:	e9 dd 01 00 00       	jmpq   80322b <spawn+0x363>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80304e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803052:	48 8b 40 20          	mov    0x20(%rax),%rax
  803056:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  80305d:	48 01 d0             	add    %rdx,%rax
  803060:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803064:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80306b:	eb 7a                	jmp    8030e7 <spawn+0x21f>
		if (ph->p_type != ELF_PROG_LOAD)
  80306d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803071:	8b 00                	mov    (%rax),%eax
  803073:	83 f8 01             	cmp    $0x1,%eax
  803076:	75 65                	jne    8030dd <spawn+0x215>
			continue;
		perm = PTE_P | PTE_U;
  803078:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80307f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803083:	8b 40 04             	mov    0x4(%rax),%eax
  803086:	83 e0 02             	and    $0x2,%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	74 04                	je     803091 <spawn+0x1c9>
			perm |= PTE_W;
  80308d:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803091:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803095:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803099:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80309c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8030a0:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8030a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a8:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8030ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b0:	48 8b 70 10          	mov    0x10(%rax),%rsi
  8030b4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8030b7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8030ba:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8030bd:	89 3c 24             	mov    %edi,(%rsp)
  8030c0:	89 c7                	mov    %eax,%edi
  8030c2:	48 b8 f3 36 80 00 00 	movabs $0x8036f3,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	callq  *%rax
  8030ce:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8030d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8030d5:	0f 88 2a 01 00 00    	js     803205 <spawn+0x33d>
  8030db:	eb 01                	jmp    8030de <spawn+0x216>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  8030dd:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8030de:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8030e2:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  8030e7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030eb:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8030ef:	0f b7 c0             	movzwl %ax,%eax
  8030f2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8030f5:	0f 8f 72 ff ff ff    	jg     80306d <spawn+0x1a5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8030fb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8030fe:	89 c7                	mov    %eax,%edi
  803100:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
	fd = -1;
  80310c:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803113:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803116:	89 c7                	mov    %eax,%edi
  803118:	48 b8 da 38 80 00 00 	movabs $0x8038da,%rax
  80311f:	00 00 00 
  803122:	ff d0                	callq  *%rax
  803124:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803127:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80312b:	79 30                	jns    80315d <spawn+0x295>
		panic("copy_shared_pages: %e", r);
  80312d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803130:	89 c1                	mov    %eax,%ecx
  803132:	48 ba ca 52 80 00 00 	movabs $0x8052ca,%rdx
  803139:	00 00 00 
  80313c:	be 82 00 00 00       	mov    $0x82,%esi
  803141:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  803148:	00 00 00 
  80314b:	b8 00 00 00 00       	mov    $0x0,%eax
  803150:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  803157:	00 00 00 
  80315a:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80315d:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  803164:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803167:	48 89 d6             	mov    %rdx,%rsi
  80316a:	89 c7                	mov    %eax,%edi
  80316c:	48 b8 c0 1f 80 00 00 	movabs $0x801fc0,%rax
  803173:	00 00 00 
  803176:	ff d0                	callq  *%rax
  803178:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80317b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80317f:	79 30                	jns    8031b1 <spawn+0x2e9>
		panic("sys_env_set_trapframe: %e", r);
  803181:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803184:	89 c1                	mov    %eax,%ecx
  803186:	48 ba ec 52 80 00 00 	movabs $0x8052ec,%rdx
  80318d:	00 00 00 
  803190:	be 85 00 00 00       	mov    $0x85,%esi
  803195:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  80319c:	00 00 00 
  80319f:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a4:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8031ab:	00 00 00 
  8031ae:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8031b1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8031b4:	be 02 00 00 00       	mov    $0x2,%esi
  8031b9:	89 c7                	mov    %eax,%edi
  8031bb:	48 b8 75 1f 80 00 00 	movabs $0x801f75,%rax
  8031c2:	00 00 00 
  8031c5:	ff d0                	callq  *%rax
  8031c7:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8031ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8031ce:	79 30                	jns    803200 <spawn+0x338>
		panic("sys_env_set_status: %e", r);
  8031d0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8031d3:	89 c1                	mov    %eax,%ecx
  8031d5:	48 ba 06 53 80 00 00 	movabs $0x805306,%rdx
  8031dc:	00 00 00 
  8031df:	be 88 00 00 00       	mov    $0x88,%esi
  8031e4:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  8031eb:	00 00 00 
  8031ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f3:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8031fa:	00 00 00 
  8031fd:	41 ff d0             	callq  *%r8

	return child;
  803200:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803203:	eb 26                	jmp    80322b <spawn+0x363>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803205:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803206:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803209:	89 c7                	mov    %eax,%edi
  80320b:	48 b8 c0 1d 80 00 00 	movabs $0x801dc0,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
	close(fd);
  803217:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80321a:	89 c7                	mov    %eax,%edi
  80321c:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
	return r;
  803228:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  80322b:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  803232:	5b                   	pop    %rbx
  803233:	5d                   	pop    %rbp
  803234:	c3                   	retq   

0000000000803235 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803235:	55                   	push   %rbp
  803236:	48 89 e5             	mov    %rsp,%rbp
  803239:	53                   	push   %rbx
  80323a:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  803241:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803248:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  80324f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803256:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80325d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803264:	84 c0                	test   %al,%al
  803266:	74 23                	je     80328b <spawnl+0x56>
  803268:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80326f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803273:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803277:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80327b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80327f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803283:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803287:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80328b:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803292:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  803299:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80329c:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  8032a3:	00 00 00 
  8032a6:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  8032ad:	00 00 00 
  8032b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032b4:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  8032bb:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  8032c2:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8032c9:	eb 07                	jmp    8032d2 <spawnl+0x9d>
		argc++;
  8032cb:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8032d2:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8032d8:	83 f8 30             	cmp    $0x30,%eax
  8032db:	73 23                	jae    803300 <spawnl+0xcb>
  8032dd:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  8032e4:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8032ea:	89 c0                	mov    %eax,%eax
  8032ec:	48 01 d0             	add    %rdx,%rax
  8032ef:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  8032f5:	83 c2 08             	add    $0x8,%edx
  8032f8:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  8032fe:	eb 15                	jmp    803315 <spawnl+0xe0>
  803300:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803307:	48 89 d0             	mov    %rdx,%rax
  80330a:	48 83 c2 08          	add    $0x8,%rdx
  80330e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803315:	48 8b 00             	mov    (%rax),%rax
  803318:	48 85 c0             	test   %rax,%rax
  80331b:	75 ae                	jne    8032cb <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80331d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803323:	83 c0 02             	add    $0x2,%eax
  803326:	48 89 e2             	mov    %rsp,%rdx
  803329:	48 89 d3             	mov    %rdx,%rbx
  80332c:	48 63 d0             	movslq %eax,%rdx
  80332f:	48 83 ea 01          	sub    $0x1,%rdx
  803333:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  80333a:	48 98                	cltq   
  80333c:	48 c1 e0 03          	shl    $0x3,%rax
  803340:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  803344:	b8 10 00 00 00       	mov    $0x10,%eax
  803349:	48 83 e8 01          	sub    $0x1,%rax
  80334d:	48 01 d0             	add    %rdx,%rax
  803350:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  803357:	10 00 00 00 
  80335b:	ba 00 00 00 00       	mov    $0x0,%edx
  803360:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  803367:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80336b:	48 29 c4             	sub    %rax,%rsp
  80336e:	48 89 e0             	mov    %rsp,%rax
  803371:	48 83 c0 0f          	add    $0xf,%rax
  803375:	48 c1 e8 04          	shr    $0x4,%rax
  803379:	48 c1 e0 04          	shl    $0x4,%rax
  80337d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  803384:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80338b:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  803392:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803395:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  80339b:	8d 50 01             	lea    0x1(%rax),%edx
  80339e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8033a5:	48 63 d2             	movslq %edx,%rdx
  8033a8:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8033af:	00 

	va_start(vl, arg0);
  8033b0:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  8033b7:	00 00 00 
  8033ba:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  8033c1:	00 00 00 
  8033c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033c8:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  8033cf:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  8033d6:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8033dd:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  8033e4:	00 00 00 
  8033e7:	eb 63                	jmp    80344c <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  8033e9:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  8033ef:	8d 70 01             	lea    0x1(%rax),%esi
  8033f2:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8033f8:	83 f8 30             	cmp    $0x30,%eax
  8033fb:	73 23                	jae    803420 <spawnl+0x1eb>
  8033fd:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  803404:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  80340a:	89 c0                	mov    %eax,%eax
  80340c:	48 01 d0             	add    %rdx,%rax
  80340f:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  803415:	83 c2 08             	add    $0x8,%edx
  803418:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  80341e:	eb 15                	jmp    803435 <spawnl+0x200>
  803420:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803427:	48 89 d0             	mov    %rdx,%rax
  80342a:	48 83 c2 08          	add    $0x8,%rdx
  80342e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803435:	48 8b 08             	mov    (%rax),%rcx
  803438:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80343f:	89 f2                	mov    %esi,%edx
  803441:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803445:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  80344c:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803452:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  803458:	77 8f                	ja     8033e9 <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80345a:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  803461:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803468:	48 89 d6             	mov    %rdx,%rsi
  80346b:	48 89 c7             	mov    %rax,%rdi
  80346e:	48 b8 c8 2e 80 00 00 	movabs $0x802ec8,%rax
  803475:	00 00 00 
  803478:	ff d0                	callq  *%rax
  80347a:	48 89 dc             	mov    %rbx,%rsp
}
  80347d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803481:	c9                   	leaveq 
  803482:	c3                   	retq   

0000000000803483 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803483:	55                   	push   %rbp
  803484:	48 89 e5             	mov    %rsp,%rbp
  803487:	48 83 ec 50          	sub    $0x50,%rsp
  80348b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80348e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803492:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803496:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80349d:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80349e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8034a5:	eb 2c                	jmp    8034d3 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  8034a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034aa:	48 98                	cltq   
  8034ac:	48 c1 e0 03          	shl    $0x3,%rax
  8034b0:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8034b4:	48 8b 00             	mov    (%rax),%rax
  8034b7:	48 89 c7             	mov    %rax,%rdi
  8034ba:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  8034c1:	00 00 00 
  8034c4:	ff d0                	callq  *%rax
  8034c6:	83 c0 01             	add    $0x1,%eax
  8034c9:	48 98                	cltq   
  8034cb:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8034cf:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8034d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034d6:	48 98                	cltq   
  8034d8:	48 c1 e0 03          	shl    $0x3,%rax
  8034dc:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8034e0:	48 8b 00             	mov    (%rax),%rax
  8034e3:	48 85 c0             	test   %rax,%rax
  8034e6:	75 bf                	jne    8034a7 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8034e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ec:	48 f7 d8             	neg    %rax
  8034ef:	48 05 00 10 40 00    	add    $0x401000,%rax
  8034f5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8034f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034fd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803505:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803509:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80350c:	83 c2 01             	add    $0x1,%edx
  80350f:	c1 e2 03             	shl    $0x3,%edx
  803512:	48 63 d2             	movslq %edx,%rdx
  803515:	48 f7 da             	neg    %rdx
  803518:	48 01 d0             	add    %rdx,%rax
  80351b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80351f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803523:	48 83 e8 10          	sub    $0x10,%rax
  803527:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80352d:	77 0a                	ja     803539 <init_stack+0xb6>
		return -E_NO_MEM;
  80352f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803534:	e9 b8 01 00 00       	jmpq   8036f1 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803539:	ba 07 00 00 00       	mov    $0x7,%edx
  80353e:	be 00 00 40 00       	mov    $0x400000,%esi
  803543:	bf 00 00 00 00       	mov    $0x0,%edi
  803548:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  80354f:	00 00 00 
  803552:	ff d0                	callq  *%rax
  803554:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803557:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80355b:	79 08                	jns    803565 <init_stack+0xe2>
		return r;
  80355d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803560:	e9 8c 01 00 00       	jmpq   8036f1 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803565:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80356c:	eb 73                	jmp    8035e1 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  80356e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803571:	48 98                	cltq   
  803573:	48 c1 e0 03          	shl    $0x3,%rax
  803577:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80357b:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  803580:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  803584:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  80358b:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  80358e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803591:	48 98                	cltq   
  803593:	48 c1 e0 03          	shl    $0x3,%rax
  803597:	48 03 45 c0          	add    -0x40(%rbp),%rax
  80359b:	48 8b 10             	mov    (%rax),%rdx
  80359e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a2:	48 89 d6             	mov    %rdx,%rsi
  8035a5:	48 89 c7             	mov    %rax,%rdi
  8035a8:	48 b8 48 15 80 00 00 	movabs $0x801548,%rax
  8035af:	00 00 00 
  8035b2:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8035b4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035b7:	48 98                	cltq   
  8035b9:	48 c1 e0 03          	shl    $0x3,%rax
  8035bd:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8035c1:	48 8b 00             	mov    (%rax),%rax
  8035c4:	48 89 c7             	mov    %rax,%rdi
  8035c7:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
  8035d3:	48 98                	cltq   
  8035d5:	48 83 c0 01          	add    $0x1,%rax
  8035d9:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8035dd:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8035e1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035e4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8035e7:	7c 85                	jl     80356e <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8035e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035ec:	48 98                	cltq   
  8035ee:	48 c1 e0 03          	shl    $0x3,%rax
  8035f2:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8035f6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8035fd:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803604:	00 
  803605:	74 35                	je     80363c <init_stack+0x1b9>
  803607:	48 b9 20 53 80 00 00 	movabs $0x805320,%rcx
  80360e:	00 00 00 
  803611:	48 ba 46 53 80 00 00 	movabs $0x805346,%rdx
  803618:	00 00 00 
  80361b:	be f1 00 00 00       	mov    $0xf1,%esi
  803620:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  803627:	00 00 00 
  80362a:	b8 00 00 00 00       	mov    $0x0,%eax
  80362f:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  803636:	00 00 00 
  803639:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80363c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803640:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803644:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803649:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80364d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803653:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803656:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80365a:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80365e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803661:	48 98                	cltq   
  803663:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803666:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  80366b:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80366f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803675:	48 89 c2             	mov    %rax,%rdx
  803678:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80367c:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80367f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803682:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803688:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80368d:	89 c2                	mov    %eax,%edx
  80368f:	be 00 00 40 00       	mov    $0x400000,%esi
  803694:	bf 00 00 00 00       	mov    $0x0,%edi
  803699:	48 b8 d0 1e 80 00 00 	movabs $0x801ed0,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
  8036a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036ac:	78 26                	js     8036d4 <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8036ae:	be 00 00 40 00       	mov    $0x400000,%esi
  8036b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b8:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
  8036c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036cb:	78 0a                	js     8036d7 <init_stack+0x254>
		goto error;

	return 0;
  8036cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d2:	eb 1d                	jmp    8036f1 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  8036d4:	90                   	nop
  8036d5:	eb 01                	jmp    8036d8 <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  8036d7:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8036d8:	be 00 00 40 00       	mov    $0x400000,%esi
  8036dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e2:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8036e9:	00 00 00 
  8036ec:	ff d0                	callq  *%rax
	return r;
  8036ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036f1:	c9                   	leaveq 
  8036f2:	c3                   	retq   

00000000008036f3 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  8036f3:	55                   	push   %rbp
  8036f4:	48 89 e5             	mov    %rsp,%rbp
  8036f7:	48 83 ec 50          	sub    $0x50,%rsp
  8036fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8036fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803702:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803706:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803709:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80370d:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803711:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803715:	25 ff 0f 00 00       	and    $0xfff,%eax
  80371a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803721:	74 21                	je     803744 <map_segment+0x51>
		va -= i;
  803723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803726:	48 98                	cltq   
  803728:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80372c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372f:	48 98                	cltq   
  803731:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803735:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803738:	48 98                	cltq   
  80373a:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80373e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803741:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803744:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80374b:	e9 74 01 00 00       	jmpq   8038c4 <map_segment+0x1d1>
		if (i >= filesz) {
  803750:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803753:	48 98                	cltq   
  803755:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803759:	72 38                	jb     803793 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80375b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375e:	48 98                	cltq   
  803760:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803764:	48 89 c1             	mov    %rax,%rcx
  803767:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80376a:	8b 55 10             	mov    0x10(%rbp),%edx
  80376d:	48 89 ce             	mov    %rcx,%rsi
  803770:	89 c7                	mov    %eax,%edi
  803772:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  803779:	00 00 00 
  80377c:	ff d0                	callq  *%rax
  80377e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803781:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803785:	0f 89 32 01 00 00    	jns    8038bd <map_segment+0x1ca>
				return r;
  80378b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80378e:	e9 45 01 00 00       	jmpq   8038d8 <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803793:	ba 07 00 00 00       	mov    $0x7,%edx
  803798:	be 00 00 40 00       	mov    $0x400000,%esi
  80379d:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a2:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8037a9:	00 00 00 
  8037ac:	ff d0                	callq  *%rax
  8037ae:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8037b1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8037b5:	79 08                	jns    8037bf <map_segment+0xcc>
				return r;
  8037b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037ba:	e9 19 01 00 00       	jmpq   8038d8 <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8037bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c2:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8037c5:	01 c2                	add    %eax,%edx
  8037c7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8037ca:	89 d6                	mov    %edx,%esi
  8037cc:	89 c7                	mov    %eax,%edi
  8037ce:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  8037d5:	00 00 00 
  8037d8:	ff d0                	callq  *%rax
  8037da:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8037dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8037e1:	79 08                	jns    8037eb <map_segment+0xf8>
				return r;
  8037e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037e6:	e9 ed 00 00 00       	jmpq   8038d8 <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8037eb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8037f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f5:	48 98                	cltq   
  8037f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8037fb:	48 89 d1             	mov    %rdx,%rcx
  8037fe:	48 29 c1             	sub    %rax,%rcx
  803801:	48 89 c8             	mov    %rcx,%rax
  803804:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803808:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80380b:	48 63 d0             	movslq %eax,%rdx
  80380e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803812:	48 39 c2             	cmp    %rax,%rdx
  803815:	48 0f 47 d0          	cmova  %rax,%rdx
  803819:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80381c:	be 00 00 40 00       	mov    $0x400000,%esi
  803821:	89 c7                	mov    %eax,%edi
  803823:	48 b8 b1 27 80 00 00 	movabs $0x8027b1,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
  80382f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803832:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803836:	79 08                	jns    803840 <map_segment+0x14d>
				return r;
  803838:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80383b:	e9 98 00 00 00       	jmpq   8038d8 <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803840:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803843:	48 98                	cltq   
  803845:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803849:	48 89 c2             	mov    %rax,%rdx
  80384c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80384f:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803853:	48 89 d1             	mov    %rdx,%rcx
  803856:	89 c2                	mov    %eax,%edx
  803858:	be 00 00 40 00       	mov    $0x400000,%esi
  80385d:	bf 00 00 00 00       	mov    $0x0,%edi
  803862:	48 b8 d0 1e 80 00 00 	movabs $0x801ed0,%rax
  803869:	00 00 00 
  80386c:	ff d0                	callq  *%rax
  80386e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803871:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803875:	79 30                	jns    8038a7 <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  803877:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80387a:	89 c1                	mov    %eax,%ecx
  80387c:	48 ba 5b 53 80 00 00 	movabs $0x80535b,%rdx
  803883:	00 00 00 
  803886:	be 24 01 00 00       	mov    $0x124,%esi
  80388b:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  803892:	00 00 00 
  803895:	b8 00 00 00 00       	mov    $0x0,%eax
  80389a:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8038a1:	00 00 00 
  8038a4:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8038a7:	be 00 00 40 00       	mov    $0x400000,%esi
  8038ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b1:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8038bd:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8038c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c7:	48 98                	cltq   
  8038c9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038cd:	0f 82 7d fe ff ff    	jb     803750 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8038d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038d8:	c9                   	leaveq 
  8038d9:	c3                   	retq   

00000000008038da <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8038da:	55                   	push   %rbp
  8038db:	48 89 e5             	mov    %rsp,%rbp
  8038de:	48 83 ec 60          	sub    $0x60,%rsp
  8038e2:	89 7d ac             	mov    %edi,-0x54(%rbp)
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
  8038e5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
        vpdpe_entries = VPDPE(UTOP);
  8038ec:	c7 45 c0 00 02 00 00 	movl   $0x200,-0x40(%rbp)
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  8038f3:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8038fa:	00 
  8038fb:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803902:	00 
  803903:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80390a:	00 
  80390b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803912:	00 
  803913:	e9 a6 01 00 00       	jmpq   803abe <copy_shared_pages+0x1e4>
        {
                if(uvpml4e[a] & PTE_P)
  803918:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80391f:	01 00 00 
  803922:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803926:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80392a:	83 e0 01             	and    $0x1,%eax
  80392d:	84 c0                	test   %al,%al
  80392f:	0f 84 74 01 00 00    	je     803aa9 <copy_shared_pages+0x1cf>
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  803935:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80393c:	00 
  80393d:	e9 56 01 00 00       	jmpq   803a98 <copy_shared_pages+0x1be>
                        {
                                if(uvpde[b1] & PTE_P)
  803942:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803949:	01 00 00 
  80394c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803950:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803954:	83 e0 01             	and    $0x1,%eax
  803957:	84 c0                	test   %al,%al
  803959:	0f 84 1f 01 00 00    	je     803a7e <copy_shared_pages+0x1a4>
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  80395f:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803966:	00 
  803967:	e9 02 01 00 00       	jmpq   803a6e <copy_shared_pages+0x194>
                                        {
                                                if(uvpd[c1] & PTE_P)
  80396c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803973:	01 00 00 
  803976:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80397a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80397e:	83 e0 01             	and    $0x1,%eax
  803981:	84 c0                	test   %al,%al
  803983:	0f 84 cb 00 00 00    	je     803a54 <copy_shared_pages+0x17a>
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  803989:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803990:	00 
  803991:	e9 ae 00 00 00       	jmpq   803a44 <copy_shared_pages+0x16a>
                                                        {
                                                                if((uvpt[d1] & PTE_SHARE))// && (f != VPN(UXSTACKTOP-PGSIZE)))
  803996:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80399d:	01 00 00 
  8039a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8039a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039a8:	25 00 04 00 00       	and    $0x400,%eax
  8039ad:	48 85 c0             	test   %rax,%rax
  8039b0:	0f 84 84 00 00 00    	je     803a3a <copy_shared_pages+0x160>
                                                                {
                                                                        void* addr=(void *)(d1 << PGSHIFT);
  8039b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8039be:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
                                                                        perm=uvpt[d1] & PTE_USER;
  8039c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8039c9:	01 00 00 
  8039cc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8039d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8039d9:	89 45 b4             	mov    %eax,-0x4c(%rbp)
                                                                        //cprintf("f:%08x\tUTOP:%08x\taddr:%08x\tuvpt[f]:%08x\tperm:%08x\n",f,UTOP,addr,uvpt[f],perm);
                                                                        r = sys_page_map(0, addr, child, addr, perm);
  8039dc:	8b 75 b4             	mov    -0x4c(%rbp),%esi
  8039df:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  8039e3:	8b 55 ac             	mov    -0x54(%rbp),%edx
  8039e6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8039ea:	41 89 f0             	mov    %esi,%r8d
  8039ed:	48 89 c6             	mov    %rax,%rsi
  8039f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8039f5:	48 b8 d0 1e 80 00 00 	movabs $0x801ed0,%rax
  8039fc:	00 00 00 
  8039ff:	ff d0                	callq  *%rax
  803a01:	89 45 b0             	mov    %eax,-0x50(%rbp)
                                                                        if (r < 0)
  803a04:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  803a08:	79 30                	jns    803a3a <copy_shared_pages+0x160>
                                                                                panic("sys_page_map failed:%e",r);
  803a0a:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803a0d:	89 c1                	mov    %eax,%ecx
  803a0f:	48 ba 78 53 80 00 00 	movabs $0x805378,%rdx
  803a16:	00 00 00 
  803a19:	be 48 01 00 00       	mov    $0x148,%esi
  803a1e:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  803a25:	00 00 00 
  803a28:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2d:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  803a34:	00 00 00 
  803a37:	41 ff d0             	callq  *%r8
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
                                        {
                                                if(uvpd[c1] & PTE_P)
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  803a3a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803a3f:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  803a44:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803a4b:	00 
  803a4c:	0f 86 44 ff ff ff    	jbe    803996 <copy_shared_pages+0xbc>
  803a52:	eb 10                	jmp    803a64 <copy_shared_pages+0x18a>
                                                                                panic("sys_page_map failed:%e",r);
                                                                }
                                                        }
                                                }
                                                else {
                                                        d1 = (c1+1)*NPTENTRIES;
  803a54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a58:	48 83 c0 01          	add    $0x1,%rax
  803a5c:	48 c1 e0 09          	shl    $0x9,%rax
  803a60:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
                        {
                                if(uvpde[b1] & PTE_P)
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  803a64:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803a69:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  803a6e:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803a75:	00 
  803a76:	0f 86 f0 fe ff ff    	jbe    80396c <copy_shared_pages+0x92>
  803a7c:	eb 10                	jmp    803a8e <copy_shared_pages+0x1b4>
                                                        d1 = (c1+1)*NPTENTRIES;
                                                }
                                        }
                                }
                                else {
                                        c1 = (b+1) * NPDENTRIES;
  803a7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a82:	48 83 c0 01          	add    $0x1,%rax
  803a86:	48 c1 e0 09          	shl    $0x9,%rax
  803a8a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
        {
                if(uvpml4e[a] & PTE_P)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  803a8e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  803a93:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a98:	8b 45 c0             	mov    -0x40(%rbp),%eax
  803a9b:	48 98                	cltq   
  803a9d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803aa1:	0f 87 9b fe ff ff    	ja     803942 <copy_shared_pages+0x68>
  803aa7:	eb 10                	jmp    803ab9 <copy_shared_pages+0x1df>
                                }
                        }
                }
                else
                {
                        b1=(a+1)*NPDPENTRIES;
  803aa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aad:	48 83 c0 01          	add    $0x1,%rax
  803ab1:	48 c1 e0 09          	shl    $0x9,%rax
  803ab5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
{
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  803ab9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803abe:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803ac1:	48 98                	cltq   
  803ac3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803ac7:	0f 87 4b fe ff ff    	ja     803918 <copy_shared_pages+0x3e>
                else
                {
                        b1=(a+1)*NPDPENTRIES;
                }
	}	
        return 0;
  803acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad2:	c9                   	leaveq 
  803ad3:	c3                   	retq   

0000000000803ad4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803ad4:	55                   	push   %rbp
  803ad5:	48 89 e5             	mov    %rsp,%rbp
  803ad8:	48 83 ec 20          	sub    $0x20,%rsp
  803adc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803adf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ae3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ae6:	48 89 d6             	mov    %rdx,%rsi
  803ae9:	89 c7                	mov    %eax,%edi
  803aeb:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  803af2:	00 00 00 
  803af5:	ff d0                	callq  *%rax
  803af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803afe:	79 05                	jns    803b05 <fd2sockid+0x31>
		return r;
  803b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b03:	eb 24                	jmp    803b29 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803b05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b09:	8b 10                	mov    (%rax),%edx
  803b0b:	48 b8 40 88 80 00 00 	movabs $0x808840,%rax
  803b12:	00 00 00 
  803b15:	8b 00                	mov    (%rax),%eax
  803b17:	39 c2                	cmp    %eax,%edx
  803b19:	74 07                	je     803b22 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803b1b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803b20:	eb 07                	jmp    803b29 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803b22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b26:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803b29:	c9                   	leaveq 
  803b2a:	c3                   	retq   

0000000000803b2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803b2b:	55                   	push   %rbp
  803b2c:	48 89 e5             	mov    %rsp,%rbp
  803b2f:	48 83 ec 20          	sub    $0x20,%rsp
  803b33:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803b36:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b3a:	48 89 c7             	mov    %rax,%rdi
  803b3d:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  803b44:	00 00 00 
  803b47:	ff d0                	callq  *%rax
  803b49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b50:	78 26                	js     803b78 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803b52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b56:	ba 07 04 00 00       	mov    $0x407,%edx
  803b5b:	48 89 c6             	mov    %rax,%rsi
  803b5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b63:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  803b6a:	00 00 00 
  803b6d:	ff d0                	callq  *%rax
  803b6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b76:	79 16                	jns    803b8e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803b78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b7b:	89 c7                	mov    %eax,%edi
  803b7d:	48 b8 38 40 80 00 00 	movabs $0x804038,%rax
  803b84:	00 00 00 
  803b87:	ff d0                	callq  *%rax
		return r;
  803b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8c:	eb 3a                	jmp    803bc8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803b8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b92:	48 ba 40 88 80 00 00 	movabs $0x808840,%rdx
  803b99:	00 00 00 
  803b9c:	8b 12                	mov    (%rdx),%edx
  803b9e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803ba0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803bab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803baf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803bb2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803bb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb9:	48 89 c7             	mov    %rax,%rdi
  803bbc:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  803bc3:	00 00 00 
  803bc6:	ff d0                	callq  *%rax
}
  803bc8:	c9                   	leaveq 
  803bc9:	c3                   	retq   

0000000000803bca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803bca:	55                   	push   %rbp
  803bcb:	48 89 e5             	mov    %rsp,%rbp
  803bce:	48 83 ec 30          	sub    $0x30,%rsp
  803bd2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bd5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bd9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bdd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803be0:	89 c7                	mov    %eax,%edi
  803be2:	48 b8 d4 3a 80 00 00 	movabs $0x803ad4,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
  803bee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf5:	79 05                	jns    803bfc <accept+0x32>
		return r;
  803bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfa:	eb 3b                	jmp    803c37 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803bfc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c00:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c07:	48 89 ce             	mov    %rcx,%rsi
  803c0a:	89 c7                	mov    %eax,%edi
  803c0c:	48 b8 15 3f 80 00 00 	movabs $0x803f15,%rax
  803c13:	00 00 00 
  803c16:	ff d0                	callq  *%rax
  803c18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1f:	79 05                	jns    803c26 <accept+0x5c>
		return r;
  803c21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c24:	eb 11                	jmp    803c37 <accept+0x6d>
	return alloc_sockfd(r);
  803c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c29:	89 c7                	mov    %eax,%edi
  803c2b:	48 b8 2b 3b 80 00 00 	movabs $0x803b2b,%rax
  803c32:	00 00 00 
  803c35:	ff d0                	callq  *%rax
}
  803c37:	c9                   	leaveq 
  803c38:	c3                   	retq   

0000000000803c39 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c39:	55                   	push   %rbp
  803c3a:	48 89 e5             	mov    %rsp,%rbp
  803c3d:	48 83 ec 20          	sub    $0x20,%rsp
  803c41:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c48:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4e:	89 c7                	mov    %eax,%edi
  803c50:	48 b8 d4 3a 80 00 00 	movabs $0x803ad4,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
  803c5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c63:	79 05                	jns    803c6a <bind+0x31>
		return r;
  803c65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c68:	eb 1b                	jmp    803c85 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803c6a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c6d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c74:	48 89 ce             	mov    %rcx,%rsi
  803c77:	89 c7                	mov    %eax,%edi
  803c79:	48 b8 94 3f 80 00 00 	movabs $0x803f94,%rax
  803c80:	00 00 00 
  803c83:	ff d0                	callq  *%rax
}
  803c85:	c9                   	leaveq 
  803c86:	c3                   	retq   

0000000000803c87 <shutdown>:

int
shutdown(int s, int how)
{
  803c87:	55                   	push   %rbp
  803c88:	48 89 e5             	mov    %rsp,%rbp
  803c8b:	48 83 ec 20          	sub    $0x20,%rsp
  803c8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c92:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c98:	89 c7                	mov    %eax,%edi
  803c9a:	48 b8 d4 3a 80 00 00 	movabs $0x803ad4,%rax
  803ca1:	00 00 00 
  803ca4:	ff d0                	callq  *%rax
  803ca6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cad:	79 05                	jns    803cb4 <shutdown+0x2d>
		return r;
  803caf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb2:	eb 16                	jmp    803cca <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803cb4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cba:	89 d6                	mov    %edx,%esi
  803cbc:	89 c7                	mov    %eax,%edi
  803cbe:	48 b8 f8 3f 80 00 00 	movabs $0x803ff8,%rax
  803cc5:	00 00 00 
  803cc8:	ff d0                	callq  *%rax
}
  803cca:	c9                   	leaveq 
  803ccb:	c3                   	retq   

0000000000803ccc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803ccc:	55                   	push   %rbp
  803ccd:	48 89 e5             	mov    %rsp,%rbp
  803cd0:	48 83 ec 10          	sub    $0x10,%rsp
  803cd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cdc:	48 89 c7             	mov    %rax,%rdi
  803cdf:	48 b8 54 4b 80 00 00 	movabs $0x804b54,%rax
  803ce6:	00 00 00 
  803ce9:	ff d0                	callq  *%rax
  803ceb:	83 f8 01             	cmp    $0x1,%eax
  803cee:	75 17                	jne    803d07 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803cf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf4:	8b 40 0c             	mov    0xc(%rax),%eax
  803cf7:	89 c7                	mov    %eax,%edi
  803cf9:	48 b8 38 40 80 00 00 	movabs $0x804038,%rax
  803d00:	00 00 00 
  803d03:	ff d0                	callq  *%rax
  803d05:	eb 05                	jmp    803d0c <devsock_close+0x40>
	else
		return 0;
  803d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d0c:	c9                   	leaveq 
  803d0d:	c3                   	retq   

0000000000803d0e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d0e:	55                   	push   %rbp
  803d0f:	48 89 e5             	mov    %rsp,%rbp
  803d12:	48 83 ec 20          	sub    $0x20,%rsp
  803d16:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d1d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d23:	89 c7                	mov    %eax,%edi
  803d25:	48 b8 d4 3a 80 00 00 	movabs $0x803ad4,%rax
  803d2c:	00 00 00 
  803d2f:	ff d0                	callq  *%rax
  803d31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d38:	79 05                	jns    803d3f <connect+0x31>
		return r;
  803d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3d:	eb 1b                	jmp    803d5a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803d3f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d42:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d49:	48 89 ce             	mov    %rcx,%rsi
  803d4c:	89 c7                	mov    %eax,%edi
  803d4e:	48 b8 65 40 80 00 00 	movabs $0x804065,%rax
  803d55:	00 00 00 
  803d58:	ff d0                	callq  *%rax
}
  803d5a:	c9                   	leaveq 
  803d5b:	c3                   	retq   

0000000000803d5c <listen>:

int
listen(int s, int backlog)
{
  803d5c:	55                   	push   %rbp
  803d5d:	48 89 e5             	mov    %rsp,%rbp
  803d60:	48 83 ec 20          	sub    $0x20,%rsp
  803d64:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d67:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d6d:	89 c7                	mov    %eax,%edi
  803d6f:	48 b8 d4 3a 80 00 00 	movabs $0x803ad4,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
  803d7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d82:	79 05                	jns    803d89 <listen+0x2d>
		return r;
  803d84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d87:	eb 16                	jmp    803d9f <listen+0x43>
	return nsipc_listen(r, backlog);
  803d89:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8f:	89 d6                	mov    %edx,%esi
  803d91:	89 c7                	mov    %eax,%edi
  803d93:	48 b8 c9 40 80 00 00 	movabs $0x8040c9,%rax
  803d9a:	00 00 00 
  803d9d:	ff d0                	callq  *%rax
}
  803d9f:	c9                   	leaveq 
  803da0:	c3                   	retq   

0000000000803da1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803da1:	55                   	push   %rbp
  803da2:	48 89 e5             	mov    %rsp,%rbp
  803da5:	48 83 ec 20          	sub    $0x20,%rsp
  803da9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803db1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803db5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db9:	89 c2                	mov    %eax,%edx
  803dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dbf:	8b 40 0c             	mov    0xc(%rax),%eax
  803dc2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803dc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  803dcb:	89 c7                	mov    %eax,%edi
  803dcd:	48 b8 09 41 80 00 00 	movabs $0x804109,%rax
  803dd4:	00 00 00 
  803dd7:	ff d0                	callq  *%rax
}
  803dd9:	c9                   	leaveq 
  803dda:	c3                   	retq   

0000000000803ddb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803ddb:	55                   	push   %rbp
  803ddc:	48 89 e5             	mov    %rsp,%rbp
  803ddf:	48 83 ec 20          	sub    $0x20,%rsp
  803de3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803de7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803deb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df3:	89 c2                	mov    %eax,%edx
  803df5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df9:	8b 40 0c             	mov    0xc(%rax),%eax
  803dfc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803e00:	b9 00 00 00 00       	mov    $0x0,%ecx
  803e05:	89 c7                	mov    %eax,%edi
  803e07:	48 b8 d5 41 80 00 00 	movabs $0x8041d5,%rax
  803e0e:	00 00 00 
  803e11:	ff d0                	callq  *%rax
}
  803e13:	c9                   	leaveq 
  803e14:	c3                   	retq   

0000000000803e15 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803e15:	55                   	push   %rbp
  803e16:	48 89 e5             	mov    %rsp,%rbp
  803e19:	48 83 ec 10          	sub    $0x10,%rsp
  803e1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e29:	48 be 94 53 80 00 00 	movabs $0x805394,%rsi
  803e30:	00 00 00 
  803e33:	48 89 c7             	mov    %rax,%rdi
  803e36:	48 b8 48 15 80 00 00 	movabs $0x801548,%rax
  803e3d:	00 00 00 
  803e40:	ff d0                	callq  *%rax
	return 0;
  803e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e47:	c9                   	leaveq 
  803e48:	c3                   	retq   

0000000000803e49 <socket>:

int
socket(int domain, int type, int protocol)
{
  803e49:	55                   	push   %rbp
  803e4a:	48 89 e5             	mov    %rsp,%rbp
  803e4d:	48 83 ec 20          	sub    $0x20,%rsp
  803e51:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e54:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e57:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803e5a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803e5d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e63:	89 ce                	mov    %ecx,%esi
  803e65:	89 c7                	mov    %eax,%edi
  803e67:	48 b8 8d 42 80 00 00 	movabs $0x80428d,%rax
  803e6e:	00 00 00 
  803e71:	ff d0                	callq  *%rax
  803e73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e7a:	79 05                	jns    803e81 <socket+0x38>
		return r;
  803e7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7f:	eb 11                	jmp    803e92 <socket+0x49>
	return alloc_sockfd(r);
  803e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e84:	89 c7                	mov    %eax,%edi
  803e86:	48 b8 2b 3b 80 00 00 	movabs $0x803b2b,%rax
  803e8d:	00 00 00 
  803e90:	ff d0                	callq  *%rax
}
  803e92:	c9                   	leaveq 
  803e93:	c3                   	retq   

0000000000803e94 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803e94:	55                   	push   %rbp
  803e95:	48 89 e5             	mov    %rsp,%rbp
  803e98:	48 83 ec 10          	sub    $0x10,%rsp
  803e9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803e9f:	48 b8 34 90 80 00 00 	movabs $0x809034,%rax
  803ea6:	00 00 00 
  803ea9:	8b 00                	mov    (%rax),%eax
  803eab:	85 c0                	test   %eax,%eax
  803ead:	75 1d                	jne    803ecc <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803eaf:	bf 02 00 00 00       	mov    $0x2,%edi
  803eb4:	48 b8 cf 4a 80 00 00 	movabs $0x804acf,%rax
  803ebb:	00 00 00 
  803ebe:	ff d0                	callq  *%rax
  803ec0:	48 ba 34 90 80 00 00 	movabs $0x809034,%rdx
  803ec7:	00 00 00 
  803eca:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803ecc:	48 b8 34 90 80 00 00 	movabs $0x809034,%rax
  803ed3:	00 00 00 
  803ed6:	8b 00                	mov    (%rax),%eax
  803ed8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803edb:	b9 07 00 00 00       	mov    $0x7,%ecx
  803ee0:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  803ee7:	00 00 00 
  803eea:	89 c7                	mov    %eax,%edi
  803eec:	48 b8 0c 4a 80 00 00 	movabs $0x804a0c,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803ef8:	ba 00 00 00 00       	mov    $0x0,%edx
  803efd:	be 00 00 00 00       	mov    $0x0,%esi
  803f02:	bf 00 00 00 00       	mov    $0x0,%edi
  803f07:	48 b8 4c 49 80 00 00 	movabs $0x80494c,%rax
  803f0e:	00 00 00 
  803f11:	ff d0                	callq  *%rax
}
  803f13:	c9                   	leaveq 
  803f14:	c3                   	retq   

0000000000803f15 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803f15:	55                   	push   %rbp
  803f16:	48 89 e5             	mov    %rsp,%rbp
  803f19:	48 83 ec 30          	sub    $0x30,%rsp
  803f1d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f20:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f24:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803f28:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f2f:	00 00 00 
  803f32:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f35:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803f37:	bf 01 00 00 00       	mov    $0x1,%edi
  803f3c:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  803f43:	00 00 00 
  803f46:	ff d0                	callq  *%rax
  803f48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f4f:	78 3e                	js     803f8f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803f51:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f58:	00 00 00 
  803f5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f63:	8b 40 10             	mov    0x10(%rax),%eax
  803f66:	89 c2                	mov    %eax,%edx
  803f68:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803f6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f70:	48 89 ce             	mov    %rcx,%rsi
  803f73:	48 89 c7             	mov    %rax,%rdi
  803f76:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803f7d:	00 00 00 
  803f80:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f86:	8b 50 10             	mov    0x10(%rax),%edx
  803f89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f8d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f92:	c9                   	leaveq 
  803f93:	c3                   	retq   

0000000000803f94 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f94:	55                   	push   %rbp
  803f95:	48 89 e5             	mov    %rsp,%rbp
  803f98:	48 83 ec 10          	sub    $0x10,%rsp
  803f9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803fa3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803fa6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803fad:	00 00 00 
  803fb0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fb3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803fb5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fbc:	48 89 c6             	mov    %rax,%rsi
  803fbf:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  803fc6:	00 00 00 
  803fc9:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803fd0:	00 00 00 
  803fd3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803fd5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803fdc:	00 00 00 
  803fdf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fe2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803fe5:	bf 02 00 00 00       	mov    $0x2,%edi
  803fea:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  803ff1:	00 00 00 
  803ff4:	ff d0                	callq  *%rax
}
  803ff6:	c9                   	leaveq 
  803ff7:	c3                   	retq   

0000000000803ff8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ff8:	55                   	push   %rbp
  803ff9:	48 89 e5             	mov    %rsp,%rbp
  803ffc:	48 83 ec 10          	sub    $0x10,%rsp
  804000:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804003:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804006:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80400d:	00 00 00 
  804010:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804013:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804015:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80401c:	00 00 00 
  80401f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804022:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804025:	bf 03 00 00 00       	mov    $0x3,%edi
  80402a:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  804031:	00 00 00 
  804034:	ff d0                	callq  *%rax
}
  804036:	c9                   	leaveq 
  804037:	c3                   	retq   

0000000000804038 <nsipc_close>:

int
nsipc_close(int s)
{
  804038:	55                   	push   %rbp
  804039:	48 89 e5             	mov    %rsp,%rbp
  80403c:	48 83 ec 10          	sub    $0x10,%rsp
  804040:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804043:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80404a:	00 00 00 
  80404d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804050:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804052:	bf 04 00 00 00       	mov    $0x4,%edi
  804057:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  80405e:	00 00 00 
  804061:	ff d0                	callq  *%rax
}
  804063:	c9                   	leaveq 
  804064:	c3                   	retq   

0000000000804065 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804065:	55                   	push   %rbp
  804066:	48 89 e5             	mov    %rsp,%rbp
  804069:	48 83 ec 10          	sub    $0x10,%rsp
  80406d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804070:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804074:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804077:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80407e:	00 00 00 
  804081:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804084:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804086:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408d:	48 89 c6             	mov    %rax,%rsi
  804090:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  804097:	00 00 00 
  80409a:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  8040a1:	00 00 00 
  8040a4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8040a6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8040ad:	00 00 00 
  8040b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040b3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8040b6:	bf 05 00 00 00       	mov    $0x5,%edi
  8040bb:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  8040c2:	00 00 00 
  8040c5:	ff d0                	callq  *%rax
}
  8040c7:	c9                   	leaveq 
  8040c8:	c3                   	retq   

00000000008040c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8040c9:	55                   	push   %rbp
  8040ca:	48 89 e5             	mov    %rsp,%rbp
  8040cd:	48 83 ec 10          	sub    $0x10,%rsp
  8040d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040d4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8040d7:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8040de:	00 00 00 
  8040e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040e4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8040e6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8040ed:	00 00 00 
  8040f0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040f3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8040f6:	bf 06 00 00 00       	mov    $0x6,%edi
  8040fb:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  804102:	00 00 00 
  804105:	ff d0                	callq  *%rax
}
  804107:	c9                   	leaveq 
  804108:	c3                   	retq   

0000000000804109 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804109:	55                   	push   %rbp
  80410a:	48 89 e5             	mov    %rsp,%rbp
  80410d:	48 83 ec 30          	sub    $0x30,%rsp
  804111:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804114:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804118:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80411b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80411e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804125:	00 00 00 
  804128:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80412b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80412d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804134:	00 00 00 
  804137:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80413a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80413d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804144:	00 00 00 
  804147:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80414a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80414d:	bf 07 00 00 00       	mov    $0x7,%edi
  804152:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  804159:	00 00 00 
  80415c:	ff d0                	callq  *%rax
  80415e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804161:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804165:	78 69                	js     8041d0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804167:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80416e:	7f 08                	jg     804178 <nsipc_recv+0x6f>
  804170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804173:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804176:	7e 35                	jle    8041ad <nsipc_recv+0xa4>
  804178:	48 b9 9b 53 80 00 00 	movabs $0x80539b,%rcx
  80417f:	00 00 00 
  804182:	48 ba b0 53 80 00 00 	movabs $0x8053b0,%rdx
  804189:	00 00 00 
  80418c:	be 61 00 00 00       	mov    $0x61,%esi
  804191:	48 bf c5 53 80 00 00 	movabs $0x8053c5,%rdi
  804198:	00 00 00 
  80419b:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a0:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8041a7:	00 00 00 
  8041aa:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8041ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b0:	48 63 d0             	movslq %eax,%rdx
  8041b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041b7:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  8041be:	00 00 00 
  8041c1:	48 89 c7             	mov    %rax,%rdi
  8041c4:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  8041cb:	00 00 00 
  8041ce:	ff d0                	callq  *%rax
	}

	return r;
  8041d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041d3:	c9                   	leaveq 
  8041d4:	c3                   	retq   

00000000008041d5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8041d5:	55                   	push   %rbp
  8041d6:	48 89 e5             	mov    %rsp,%rbp
  8041d9:	48 83 ec 20          	sub    $0x20,%rsp
  8041dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8041e7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8041ea:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8041f1:	00 00 00 
  8041f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041f7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8041f9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804200:	7e 35                	jle    804237 <nsipc_send+0x62>
  804202:	48 b9 d1 53 80 00 00 	movabs $0x8053d1,%rcx
  804209:	00 00 00 
  80420c:	48 ba b0 53 80 00 00 	movabs $0x8053b0,%rdx
  804213:	00 00 00 
  804216:	be 6c 00 00 00       	mov    $0x6c,%esi
  80421b:	48 bf c5 53 80 00 00 	movabs $0x8053c5,%rdi
  804222:	00 00 00 
  804225:	b8 00 00 00 00       	mov    $0x0,%eax
  80422a:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  804231:	00 00 00 
  804234:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804237:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80423a:	48 63 d0             	movslq %eax,%rdx
  80423d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804241:	48 89 c6             	mov    %rax,%rsi
  804244:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  80424b:	00 00 00 
  80424e:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  804255:	00 00 00 
  804258:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80425a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804261:	00 00 00 
  804264:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804267:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80426a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804271:	00 00 00 
  804274:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804277:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80427a:	bf 08 00 00 00       	mov    $0x8,%edi
  80427f:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  804286:	00 00 00 
  804289:	ff d0                	callq  *%rax
}
  80428b:	c9                   	leaveq 
  80428c:	c3                   	retq   

000000000080428d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80428d:	55                   	push   %rbp
  80428e:	48 89 e5             	mov    %rsp,%rbp
  804291:	48 83 ec 10          	sub    $0x10,%rsp
  804295:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804298:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80429b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80429e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8042a5:	00 00 00 
  8042a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042ab:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8042ad:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8042b4:	00 00 00 
  8042b7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042ba:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8042bd:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8042c4:	00 00 00 
  8042c7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8042ca:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8042cd:	bf 09 00 00 00       	mov    $0x9,%edi
  8042d2:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  8042d9:	00 00 00 
  8042dc:	ff d0                	callq  *%rax
}
  8042de:	c9                   	leaveq 
  8042df:	c3                   	retq   

00000000008042e0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8042e0:	55                   	push   %rbp
  8042e1:	48 89 e5             	mov    %rsp,%rbp
  8042e4:	53                   	push   %rbx
  8042e5:	48 83 ec 38          	sub    $0x38,%rsp
  8042e9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8042ed:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8042f1:	48 89 c7             	mov    %rax,%rdi
  8042f4:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  8042fb:	00 00 00 
  8042fe:	ff d0                	callq  *%rax
  804300:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804303:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804307:	0f 88 bf 01 00 00    	js     8044cc <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80430d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804311:	ba 07 04 00 00       	mov    $0x407,%edx
  804316:	48 89 c6             	mov    %rax,%rsi
  804319:	bf 00 00 00 00       	mov    $0x0,%edi
  80431e:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  804325:	00 00 00 
  804328:	ff d0                	callq  *%rax
  80432a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80432d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804331:	0f 88 95 01 00 00    	js     8044cc <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804337:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80433b:	48 89 c7             	mov    %rax,%rdi
  80433e:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  804345:	00 00 00 
  804348:	ff d0                	callq  *%rax
  80434a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80434d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804351:	0f 88 5d 01 00 00    	js     8044b4 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804357:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80435b:	ba 07 04 00 00       	mov    $0x407,%edx
  804360:	48 89 c6             	mov    %rax,%rsi
  804363:	bf 00 00 00 00       	mov    $0x0,%edi
  804368:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  80436f:	00 00 00 
  804372:	ff d0                	callq  *%rax
  804374:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804377:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80437b:	0f 88 33 01 00 00    	js     8044b4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804385:	48 89 c7             	mov    %rax,%rdi
  804388:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  80438f:	00 00 00 
  804392:	ff d0                	callq  *%rax
  804394:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804398:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80439c:	ba 07 04 00 00       	mov    $0x407,%edx
  8043a1:	48 89 c6             	mov    %rax,%rsi
  8043a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8043a9:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8043b0:	00 00 00 
  8043b3:	ff d0                	callq  *%rax
  8043b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043bc:	0f 88 d9 00 00 00    	js     80449b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043c6:	48 89 c7             	mov    %rax,%rdi
  8043c9:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  8043d0:	00 00 00 
  8043d3:	ff d0                	callq  *%rax
  8043d5:	48 89 c2             	mov    %rax,%rdx
  8043d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043dc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8043e2:	48 89 d1             	mov    %rdx,%rcx
  8043e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8043ea:	48 89 c6             	mov    %rax,%rsi
  8043ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8043f2:	48 b8 d0 1e 80 00 00 	movabs $0x801ed0,%rax
  8043f9:	00 00 00 
  8043fc:	ff d0                	callq  *%rax
  8043fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804401:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804405:	78 79                	js     804480 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80440b:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  804412:	00 00 00 
  804415:	8b 12                	mov    (%rdx),%edx
  804417:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804419:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80441d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804424:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804428:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  80442f:	00 00 00 
  804432:	8b 12                	mov    (%rdx),%edx
  804434:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804436:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80443a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804441:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804445:	48 89 c7             	mov    %rax,%rdi
  804448:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  80444f:	00 00 00 
  804452:	ff d0                	callq  *%rax
  804454:	89 c2                	mov    %eax,%edx
  804456:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80445a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80445c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804460:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804464:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804468:	48 89 c7             	mov    %rax,%rdi
  80446b:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  804472:	00 00 00 
  804475:	ff d0                	callq  *%rax
  804477:	89 03                	mov    %eax,(%rbx)
	return 0;
  804479:	b8 00 00 00 00       	mov    $0x0,%eax
  80447e:	eb 4f                	jmp    8044cf <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804480:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  804481:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804485:	48 89 c6             	mov    %rax,%rsi
  804488:	bf 00 00 00 00       	mov    $0x0,%edi
  80448d:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  804494:	00 00 00 
  804497:	ff d0                	callq  *%rax
  804499:	eb 01                	jmp    80449c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80449b:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80449c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044a0:	48 89 c6             	mov    %rax,%rsi
  8044a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8044a8:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8044af:	00 00 00 
  8044b2:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8044b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b8:	48 89 c6             	mov    %rax,%rsi
  8044bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8044c0:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8044c7:	00 00 00 
  8044ca:	ff d0                	callq  *%rax
    err:
	return r;
  8044cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8044cf:	48 83 c4 38          	add    $0x38,%rsp
  8044d3:	5b                   	pop    %rbx
  8044d4:	5d                   	pop    %rbp
  8044d5:	c3                   	retq   

00000000008044d6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8044d6:	55                   	push   %rbp
  8044d7:	48 89 e5             	mov    %rsp,%rbp
  8044da:	53                   	push   %rbx
  8044db:	48 83 ec 28          	sub    $0x28,%rsp
  8044df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8044e7:	eb 01                	jmp    8044ea <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8044e9:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8044ea:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  8044f1:	00 00 00 
  8044f4:	48 8b 00             	mov    (%rax),%rax
  8044f7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804504:	48 89 c7             	mov    %rax,%rdi
  804507:	48 b8 54 4b 80 00 00 	movabs $0x804b54,%rax
  80450e:	00 00 00 
  804511:	ff d0                	callq  *%rax
  804513:	89 c3                	mov    %eax,%ebx
  804515:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804519:	48 89 c7             	mov    %rax,%rdi
  80451c:	48 b8 54 4b 80 00 00 	movabs $0x804b54,%rax
  804523:	00 00 00 
  804526:	ff d0                	callq  *%rax
  804528:	39 c3                	cmp    %eax,%ebx
  80452a:	0f 94 c0             	sete   %al
  80452d:	0f b6 c0             	movzbl %al,%eax
  804530:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804533:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  80453a:	00 00 00 
  80453d:	48 8b 00             	mov    (%rax),%rax
  804540:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804546:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80454c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80454f:	75 0a                	jne    80455b <_pipeisclosed+0x85>
			return ret;
  804551:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  804554:	48 83 c4 28          	add    $0x28,%rsp
  804558:	5b                   	pop    %rbx
  804559:	5d                   	pop    %rbp
  80455a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80455b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80455e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804561:	74 86                	je     8044e9 <_pipeisclosed+0x13>
  804563:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804567:	75 80                	jne    8044e9 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804569:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  804570:	00 00 00 
  804573:	48 8b 00             	mov    (%rax),%rax
  804576:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80457c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80457f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804582:	89 c6                	mov    %eax,%esi
  804584:	48 bf e2 53 80 00 00 	movabs $0x8053e2,%rdi
  80458b:	00 00 00 
  80458e:	b8 00 00 00 00       	mov    $0x0,%eax
  804593:	49 b8 8b 09 80 00 00 	movabs $0x80098b,%r8
  80459a:	00 00 00 
  80459d:	41 ff d0             	callq  *%r8
	}
  8045a0:	e9 44 ff ff ff       	jmpq   8044e9 <_pipeisclosed+0x13>

00000000008045a5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8045a5:	55                   	push   %rbp
  8045a6:	48 89 e5             	mov    %rsp,%rbp
  8045a9:	48 83 ec 30          	sub    $0x30,%rsp
  8045ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045b0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8045b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8045b7:	48 89 d6             	mov    %rdx,%rsi
  8045ba:	89 c7                	mov    %eax,%edi
  8045bc:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  8045c3:	00 00 00 
  8045c6:	ff d0                	callq  *%rax
  8045c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045cf:	79 05                	jns    8045d6 <pipeisclosed+0x31>
		return r;
  8045d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d4:	eb 31                	jmp    804607 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8045d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045da:	48 89 c7             	mov    %rax,%rdi
  8045dd:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  8045e4:	00 00 00 
  8045e7:	ff d0                	callq  *%rax
  8045e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8045ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045f5:	48 89 d6             	mov    %rdx,%rsi
  8045f8:	48 89 c7             	mov    %rax,%rdi
  8045fb:	48 b8 d6 44 80 00 00 	movabs $0x8044d6,%rax
  804602:	00 00 00 
  804605:	ff d0                	callq  *%rax
}
  804607:	c9                   	leaveq 
  804608:	c3                   	retq   

0000000000804609 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804609:	55                   	push   %rbp
  80460a:	48 89 e5             	mov    %rsp,%rbp
  80460d:	48 83 ec 40          	sub    $0x40,%rsp
  804611:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804615:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804619:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80461d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804621:	48 89 c7             	mov    %rax,%rdi
  804624:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  80462b:	00 00 00 
  80462e:	ff d0                	callq  *%rax
  804630:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804634:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804638:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80463c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804643:	00 
  804644:	e9 97 00 00 00       	jmpq   8046e0 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804649:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80464e:	74 09                	je     804659 <devpipe_read+0x50>
				return i;
  804650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804654:	e9 95 00 00 00       	jmpq   8046ee <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804659:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80465d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804661:	48 89 d6             	mov    %rdx,%rsi
  804664:	48 89 c7             	mov    %rax,%rdi
  804667:	48 b8 d6 44 80 00 00 	movabs $0x8044d6,%rax
  80466e:	00 00 00 
  804671:	ff d0                	callq  *%rax
  804673:	85 c0                	test   %eax,%eax
  804675:	74 07                	je     80467e <devpipe_read+0x75>
				return 0;
  804677:	b8 00 00 00 00       	mov    $0x0,%eax
  80467c:	eb 70                	jmp    8046ee <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80467e:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  804685:	00 00 00 
  804688:	ff d0                	callq  *%rax
  80468a:	eb 01                	jmp    80468d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80468c:	90                   	nop
  80468d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804691:	8b 10                	mov    (%rax),%edx
  804693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804697:	8b 40 04             	mov    0x4(%rax),%eax
  80469a:	39 c2                	cmp    %eax,%edx
  80469c:	74 ab                	je     804649 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80469e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046a6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8046aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ae:	8b 00                	mov    (%rax),%eax
  8046b0:	89 c2                	mov    %eax,%edx
  8046b2:	c1 fa 1f             	sar    $0x1f,%edx
  8046b5:	c1 ea 1b             	shr    $0x1b,%edx
  8046b8:	01 d0                	add    %edx,%eax
  8046ba:	83 e0 1f             	and    $0x1f,%eax
  8046bd:	29 d0                	sub    %edx,%eax
  8046bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046c3:	48 98                	cltq   
  8046c5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8046ca:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8046cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d0:	8b 00                	mov    (%rax),%eax
  8046d2:	8d 50 01             	lea    0x1(%rax),%edx
  8046d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8046db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8046e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046e4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8046e8:	72 a2                	jb     80468c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8046ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8046ee:	c9                   	leaveq 
  8046ef:	c3                   	retq   

00000000008046f0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8046f0:	55                   	push   %rbp
  8046f1:	48 89 e5             	mov    %rsp,%rbp
  8046f4:	48 83 ec 40          	sub    $0x40,%rsp
  8046f8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046fc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804700:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804708:	48 89 c7             	mov    %rax,%rdi
  80470b:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  804712:	00 00 00 
  804715:	ff d0                	callq  *%rax
  804717:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80471b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80471f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804723:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80472a:	00 
  80472b:	e9 93 00 00 00       	jmpq   8047c3 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804730:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804738:	48 89 d6             	mov    %rdx,%rsi
  80473b:	48 89 c7             	mov    %rax,%rdi
  80473e:	48 b8 d6 44 80 00 00 	movabs $0x8044d6,%rax
  804745:	00 00 00 
  804748:	ff d0                	callq  *%rax
  80474a:	85 c0                	test   %eax,%eax
  80474c:	74 07                	je     804755 <devpipe_write+0x65>
				return 0;
  80474e:	b8 00 00 00 00       	mov    $0x0,%eax
  804753:	eb 7c                	jmp    8047d1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804755:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  80475c:	00 00 00 
  80475f:	ff d0                	callq  *%rax
  804761:	eb 01                	jmp    804764 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804763:	90                   	nop
  804764:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804768:	8b 40 04             	mov    0x4(%rax),%eax
  80476b:	48 63 d0             	movslq %eax,%rdx
  80476e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804772:	8b 00                	mov    (%rax),%eax
  804774:	48 98                	cltq   
  804776:	48 83 c0 20          	add    $0x20,%rax
  80477a:	48 39 c2             	cmp    %rax,%rdx
  80477d:	73 b1                	jae    804730 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80477f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804783:	8b 40 04             	mov    0x4(%rax),%eax
  804786:	89 c2                	mov    %eax,%edx
  804788:	c1 fa 1f             	sar    $0x1f,%edx
  80478b:	c1 ea 1b             	shr    $0x1b,%edx
  80478e:	01 d0                	add    %edx,%eax
  804790:	83 e0 1f             	and    $0x1f,%eax
  804793:	29 d0                	sub    %edx,%eax
  804795:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804799:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80479d:	48 01 ca             	add    %rcx,%rdx
  8047a0:	0f b6 0a             	movzbl (%rdx),%ecx
  8047a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047a7:	48 98                	cltq   
  8047a9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8047ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047b1:	8b 40 04             	mov    0x4(%rax),%eax
  8047b4:	8d 50 01             	lea    0x1(%rax),%edx
  8047b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047bb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8047be:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047c7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8047cb:	72 96                	jb     804763 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8047cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8047d1:	c9                   	leaveq 
  8047d2:	c3                   	retq   

00000000008047d3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8047d3:	55                   	push   %rbp
  8047d4:	48 89 e5             	mov    %rsp,%rbp
  8047d7:	48 83 ec 20          	sub    $0x20,%rsp
  8047db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8047e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047e7:	48 89 c7             	mov    %rax,%rdi
  8047ea:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  8047f1:	00 00 00 
  8047f4:	ff d0                	callq  *%rax
  8047f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8047fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047fe:	48 be f5 53 80 00 00 	movabs $0x8053f5,%rsi
  804805:	00 00 00 
  804808:	48 89 c7             	mov    %rax,%rdi
  80480b:	48 b8 48 15 80 00 00 	movabs $0x801548,%rax
  804812:	00 00 00 
  804815:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804817:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80481b:	8b 50 04             	mov    0x4(%rax),%edx
  80481e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804822:	8b 00                	mov    (%rax),%eax
  804824:	29 c2                	sub    %eax,%edx
  804826:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80482a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804830:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804834:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80483b:	00 00 00 
	stat->st_dev = &devpipe;
  80483e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804842:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  804849:	00 00 00 
  80484c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  804853:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804858:	c9                   	leaveq 
  804859:	c3                   	retq   

000000000080485a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80485a:	55                   	push   %rbp
  80485b:	48 89 e5             	mov    %rsp,%rbp
  80485e:	48 83 ec 10          	sub    $0x10,%rsp
  804862:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80486a:	48 89 c6             	mov    %rax,%rsi
  80486d:	bf 00 00 00 00       	mov    $0x0,%edi
  804872:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  804879:	00 00 00 
  80487c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80487e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804882:	48 89 c7             	mov    %rax,%rdi
  804885:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  80488c:	00 00 00 
  80488f:	ff d0                	callq  *%rax
  804891:	48 89 c6             	mov    %rax,%rsi
  804894:	bf 00 00 00 00       	mov    $0x0,%edi
  804899:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8048a0:	00 00 00 
  8048a3:	ff d0                	callq  *%rax
}
  8048a5:	c9                   	leaveq 
  8048a6:	c3                   	retq   
	...

00000000008048a8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8048a8:	55                   	push   %rbp
  8048a9:	48 89 e5             	mov    %rsp,%rbp
  8048ac:	48 83 ec 20          	sub    $0x20,%rsp
  8048b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8048b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048b7:	75 35                	jne    8048ee <wait+0x46>
  8048b9:	48 b9 fc 53 80 00 00 	movabs $0x8053fc,%rcx
  8048c0:	00 00 00 
  8048c3:	48 ba 07 54 80 00 00 	movabs $0x805407,%rdx
  8048ca:	00 00 00 
  8048cd:	be 09 00 00 00       	mov    $0x9,%esi
  8048d2:	48 bf 1c 54 80 00 00 	movabs $0x80541c,%rdi
  8048d9:	00 00 00 
  8048dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8048e1:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8048e8:	00 00 00 
  8048eb:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8048ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048f1:	48 98                	cltq   
  8048f3:	48 89 c2             	mov    %rax,%rdx
  8048f6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8048fc:	48 89 d0             	mov    %rdx,%rax
  8048ff:	48 c1 e0 03          	shl    $0x3,%rax
  804903:	48 01 d0             	add    %rdx,%rax
  804906:	48 c1 e0 05          	shl    $0x5,%rax
  80490a:	48 89 c2             	mov    %rax,%rdx
  80490d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804914:	00 00 00 
  804917:	48 01 d0             	add    %rdx,%rax
  80491a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80491e:	eb 0c                	jmp    80492c <wait+0x84>
		sys_yield();
  804920:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  804927:	00 00 00 
  80492a:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80492c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804930:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804936:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804939:	75 0e                	jne    804949 <wait+0xa1>
  80493b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80493f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804945:	85 c0                	test   %eax,%eax
  804947:	75 d7                	jne    804920 <wait+0x78>
		sys_yield();
}
  804949:	c9                   	leaveq 
  80494a:	c3                   	retq   
	...

000000000080494c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80494c:	55                   	push   %rbp
  80494d:	48 89 e5             	mov    %rsp,%rbp
  804950:	48 83 ec 30          	sub    $0x30,%rsp
  804954:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804958:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80495c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  804960:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804965:	74 18                	je     80497f <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  804967:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80496b:	48 89 c7             	mov    %rax,%rdi
  80496e:	48 b8 a9 20 80 00 00 	movabs $0x8020a9,%rax
  804975:	00 00 00 
  804978:	ff d0                	callq  *%rax
  80497a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80497d:	eb 19                	jmp    804998 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80497f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  804986:	00 00 00 
  804989:	48 b8 a9 20 80 00 00 	movabs $0x8020a9,%rax
  804990:	00 00 00 
  804993:	ff d0                	callq  *%rax
  804995:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804998:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80499c:	79 19                	jns    8049b7 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  80499e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8049a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049ac:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8049b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049b5:	eb 53                	jmp    804a0a <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8049b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8049bc:	74 19                	je     8049d7 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8049be:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  8049c5:	00 00 00 
  8049c8:	48 8b 00             	mov    (%rax),%rax
  8049cb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8049d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049d5:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8049d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8049dc:	74 19                	je     8049f7 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8049de:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  8049e5:	00 00 00 
  8049e8:	48 8b 00             	mov    (%rax),%rax
  8049eb:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8049f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049f5:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8049f7:	48 b8 d0 a7 80 00 00 	movabs $0x80a7d0,%rax
  8049fe:	00 00 00 
  804a01:	48 8b 00             	mov    (%rax),%rax
  804a04:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  804a0a:	c9                   	leaveq 
  804a0b:	c3                   	retq   

0000000000804a0c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804a0c:	55                   	push   %rbp
  804a0d:	48 89 e5             	mov    %rsp,%rbp
  804a10:	48 83 ec 30          	sub    $0x30,%rsp
  804a14:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804a17:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804a1a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804a1e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  804a21:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804a28:	e9 96 00 00 00       	jmpq   804ac3 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  804a2d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a32:	74 20                	je     804a54 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  804a34:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804a37:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804a3a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a3e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a41:	89 c7                	mov    %eax,%edi
  804a43:	48 b8 54 20 80 00 00 	movabs $0x802054,%rax
  804a4a:	00 00 00 
  804a4d:	ff d0                	callq  *%rax
  804a4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a52:	eb 2d                	jmp    804a81 <ipc_send+0x75>
		else if(pg==NULL)
  804a54:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a59:	75 26                	jne    804a81 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  804a5b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804a5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a61:	b9 00 00 00 00       	mov    $0x0,%ecx
  804a66:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a6d:	00 00 00 
  804a70:	89 c7                	mov    %eax,%edi
  804a72:	48 b8 54 20 80 00 00 	movabs $0x802054,%rax
  804a79:	00 00 00 
  804a7c:	ff d0                	callq  *%rax
  804a7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  804a81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a85:	79 30                	jns    804ab7 <ipc_send+0xab>
  804a87:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804a8b:	74 2a                	je     804ab7 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  804a8d:	48 ba 27 54 80 00 00 	movabs $0x805427,%rdx
  804a94:	00 00 00 
  804a97:	be 40 00 00 00       	mov    $0x40,%esi
  804a9c:	48 bf 3f 54 80 00 00 	movabs $0x80543f,%rdi
  804aa3:	00 00 00 
  804aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  804aab:	48 b9 50 07 80 00 00 	movabs $0x800750,%rcx
  804ab2:	00 00 00 
  804ab5:	ff d1                	callq  *%rcx
		}
		sys_yield();
  804ab7:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  804abe:	00 00 00 
  804ac1:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  804ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ac7:	0f 85 60 ff ff ff    	jne    804a2d <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  804acd:	c9                   	leaveq 
  804ace:	c3                   	retq   

0000000000804acf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804acf:	55                   	push   %rbp
  804ad0:	48 89 e5             	mov    %rsp,%rbp
  804ad3:	48 83 ec 18          	sub    $0x18,%rsp
  804ad7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804ada:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804ae1:	eb 5e                	jmp    804b41 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804ae3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804aea:	00 00 00 
  804aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804af0:	48 63 d0             	movslq %eax,%rdx
  804af3:	48 89 d0             	mov    %rdx,%rax
  804af6:	48 c1 e0 03          	shl    $0x3,%rax
  804afa:	48 01 d0             	add    %rdx,%rax
  804afd:	48 c1 e0 05          	shl    $0x5,%rax
  804b01:	48 01 c8             	add    %rcx,%rax
  804b04:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804b0a:	8b 00                	mov    (%rax),%eax
  804b0c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804b0f:	75 2c                	jne    804b3d <ipc_find_env+0x6e>
			return envs[i].env_id;
  804b11:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804b18:	00 00 00 
  804b1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b1e:	48 63 d0             	movslq %eax,%rdx
  804b21:	48 89 d0             	mov    %rdx,%rax
  804b24:	48 c1 e0 03          	shl    $0x3,%rax
  804b28:	48 01 d0             	add    %rdx,%rax
  804b2b:	48 c1 e0 05          	shl    $0x5,%rax
  804b2f:	48 01 c8             	add    %rcx,%rax
  804b32:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804b38:	8b 40 08             	mov    0x8(%rax),%eax
  804b3b:	eb 12                	jmp    804b4f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804b3d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804b41:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804b48:	7e 99                	jle    804ae3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b4f:	c9                   	leaveq 
  804b50:	c3                   	retq   
  804b51:	00 00                	add    %al,(%rax)
	...

0000000000804b54 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804b54:	55                   	push   %rbp
  804b55:	48 89 e5             	mov    %rsp,%rbp
  804b58:	48 83 ec 18          	sub    $0x18,%rsp
  804b5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b64:	48 89 c2             	mov    %rax,%rdx
  804b67:	48 c1 ea 15          	shr    $0x15,%rdx
  804b6b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b72:	01 00 00 
  804b75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b79:	83 e0 01             	and    $0x1,%eax
  804b7c:	48 85 c0             	test   %rax,%rax
  804b7f:	75 07                	jne    804b88 <pageref+0x34>
		return 0;
  804b81:	b8 00 00 00 00       	mov    $0x0,%eax
  804b86:	eb 53                	jmp    804bdb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b8c:	48 89 c2             	mov    %rax,%rdx
  804b8f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804b93:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b9a:	01 00 00 
  804b9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ba1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804ba5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ba9:	83 e0 01             	and    $0x1,%eax
  804bac:	48 85 c0             	test   %rax,%rax
  804baf:	75 07                	jne    804bb8 <pageref+0x64>
		return 0;
  804bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  804bb6:	eb 23                	jmp    804bdb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804bb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bbc:	48 89 c2             	mov    %rax,%rdx
  804bbf:	48 c1 ea 0c          	shr    $0xc,%rdx
  804bc3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804bca:	00 00 00 
  804bcd:	48 c1 e2 04          	shl    $0x4,%rdx
  804bd1:	48 01 d0             	add    %rdx,%rax
  804bd4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804bd8:	0f b7 c0             	movzwl %ax,%eax
}
  804bdb:	c9                   	leaveq 
  804bdc:	c3                   	retq   
