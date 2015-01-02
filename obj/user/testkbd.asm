
obj/user/testkbd.debug:     file format elf64-x86-64


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
  80003c:	e8 2f 04 00 00       	callq  800470 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80005a:	eb 10                	jmp    80006c <umain+0x28>
		sys_yield();
  80005c:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800068:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006c:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800070:	7e ea                	jle    80005c <umain+0x18>
		sys_yield();

	close(0);
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800083:	48 b8 7d 02 80 00 00 	movabs $0x80027d,%rax
  80008a:	00 00 00 
  80008d:	ff d0                	callq  *%rax
  80008f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800092:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800096:	79 30                	jns    8000c8 <umain+0x84>
		panic("opencons: %e", r);
  800098:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009b:	89 c1                	mov    %eax,%ecx
  80009d:	48 ba 80 41 80 00 00 	movabs $0x804180,%rdx
  8000a4:	00 00 00 
  8000a7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ac:	48 bf 8d 41 80 00 00 	movabs $0x80418d,%rdi
  8000b3:	00 00 00 
  8000b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bb:	49 b8 38 05 80 00 00 	movabs $0x800538,%r8
  8000c2:	00 00 00 
  8000c5:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	74 30                	je     8000fe <umain+0xba>
		panic("first opencons used fd %d", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 9c 41 80 00 00 	movabs $0x80419c,%rdx
  8000da:	00 00 00 
  8000dd:	be 11 00 00 00       	mov    $0x11,%esi
  8000e2:	48 bf 8d 41 80 00 00 	movabs $0x80418d,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 38 05 80 00 00 	movabs $0x800538,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fe:	be 01 00 00 00       	mov    $0x1,%esi
  800103:	bf 00 00 00 00       	mov    $0x0,%edi
  800108:	48 b8 77 24 80 00 00 	movabs $0x802477,%rax
  80010f:	00 00 00 
  800112:	ff d0                	callq  *%rax
  800114:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800117:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011b:	79 30                	jns    80014d <umain+0x109>
		panic("dup: %e", r);
  80011d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800120:	89 c1                	mov    %eax,%ecx
  800122:	48 ba b6 41 80 00 00 	movabs $0x8041b6,%rdx
  800129:	00 00 00 
  80012c:	be 13 00 00 00       	mov    $0x13,%esi
  800131:	48 bf 8d 41 80 00 00 	movabs $0x80418d,%rdi
  800138:	00 00 00 
  80013b:	b8 00 00 00 00       	mov    $0x0,%eax
  800140:	49 b8 38 05 80 00 00 	movabs $0x800538,%r8
  800147:	00 00 00 
  80014a:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014d:	48 bf be 41 80 00 00 	movabs $0x8041be,%rdi
  800154:	00 00 00 
  800157:	48 b8 c4 12 80 00 00 	movabs $0x8012c4,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800167:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016c:	74 29                	je     800197 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800172:	48 89 c2             	mov    %rax,%rdx
  800175:	48 be cc 41 80 00 00 	movabs $0x8041cc,%rsi
  80017c:	00 00 00 
  80017f:	bf 01 00 00 00       	mov    $0x1,%edi
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 b9 a8 2f 80 00 00 	movabs $0x802fa8,%rcx
  800190:	00 00 00 
  800193:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800195:	eb b6                	jmp    80014d <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800197:	48 be d0 41 80 00 00 	movabs $0x8041d0,%rsi
  80019e:	00 00 00 
  8001a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ab:	48 ba a8 2f 80 00 00 	movabs $0x802fa8,%rdx
  8001b2:	00 00 00 
  8001b5:	ff d2                	callq  *%rdx
	}
  8001b7:	eb 94                	jmp    80014d <umain+0x109>
  8001b9:	00 00                	add    %al,(%rax)
	...

00000000008001bc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001bc:	55                   	push   %rbp
  8001bd:	48 89 e5             	mov    %rsp,%rbp
  8001c0:	48 83 ec 20          	sub    $0x20,%rsp
  8001c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ca:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001cd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001d1:	be 01 00 00 00       	mov    $0x1,%esi
  8001d6:	48 89 c7             	mov    %rax,%rdi
  8001d9:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	callq  *%rax
}
  8001e5:	c9                   	leaveq 
  8001e6:	c3                   	retq   

00000000008001e7 <getchar>:

int
getchar(void)
{
  8001e7:	55                   	push   %rbp
  8001e8:	48 89 e5             	mov    %rsp,%rbp
  8001eb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001ef:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001f3:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f8:	48 89 c6             	mov    %rax,%rsi
  8001fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800200:	48 b8 20 26 80 00 00 	movabs $0x802620,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
  80020c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800213:	79 05                	jns    80021a <getchar+0x33>
		return r;
  800215:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800218:	eb 14                	jmp    80022e <getchar+0x47>
	if (r < 1)
  80021a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021e:	7f 07                	jg     800227 <getchar+0x40>
		return -E_EOF;
  800220:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800225:	eb 07                	jmp    80022e <getchar+0x47>
	return c;
  800227:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80022b:	0f b6 c0             	movzbl %al,%eax
}
  80022e:	c9                   	leaveq 
  80022f:	c3                   	retq   

0000000000800230 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800230:	55                   	push   %rbp
  800231:	48 89 e5             	mov    %rsp,%rbp
  800234:	48 83 ec 20          	sub    $0x20,%rsp
  800238:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80023b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800242:	48 89 d6             	mov    %rdx,%rsi
  800245:	89 c7                	mov    %eax,%edi
  800247:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  80024e:	00 00 00 
  800251:	ff d0                	callq  *%rax
  800253:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800256:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80025a:	79 05                	jns    800261 <iscons+0x31>
		return r;
  80025c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025f:	eb 1a                	jmp    80027b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800265:	8b 10                	mov    (%rax),%edx
  800267:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80026e:	00 00 00 
  800271:	8b 00                	mov    (%rax),%eax
  800273:	39 c2                	cmp    %eax,%edx
  800275:	0f 94 c0             	sete   %al
  800278:	0f b6 c0             	movzbl %al,%eax
}
  80027b:	c9                   	leaveq 
  80027c:	c3                   	retq   

000000000080027d <opencons>:

int
opencons(void)
{
  80027d:	55                   	push   %rbp
  80027e:	48 89 e5             	mov    %rsp,%rbp
  800281:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800285:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800289:	48 89 c7             	mov    %rax,%rdi
  80028c:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80029b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029f:	79 05                	jns    8002a6 <opencons+0x29>
		return r;
  8002a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a4:	eb 5b                	jmp    800301 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8002af:	48 89 c6             	mov    %rax,%rsi
  8002b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b7:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002ca:	79 05                	jns    8002d1 <opencons+0x54>
		return r;
  8002cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cf:	eb 30                	jmp    800301 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d5:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002dc:	00 00 00 
  8002df:	8b 12                	mov    (%rdx),%edx
  8002e1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f2:	48 89 c7             	mov    %rax,%rdi
  8002f5:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  8002fc:	00 00 00 
  8002ff:	ff d0                	callq  *%rax
}
  800301:	c9                   	leaveq 
  800302:	c3                   	retq   

0000000000800303 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800303:	55                   	push   %rbp
  800304:	48 89 e5             	mov    %rsp,%rbp
  800307:	48 83 ec 30          	sub    $0x30,%rsp
  80030b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800313:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800317:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80031c:	75 13                	jne    800331 <devcons_read+0x2e>
		return 0;
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
  800323:	eb 49                	jmp    80036e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800325:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800331:	48 b8 ca 1c 80 00 00 	movabs $0x801cca,%rax
  800338:	00 00 00 
  80033b:	ff d0                	callq  *%rax
  80033d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800340:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800344:	74 df                	je     800325 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  800346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80034a:	79 05                	jns    800351 <devcons_read+0x4e>
		return c;
  80034c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034f:	eb 1d                	jmp    80036e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  800351:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800355:	75 07                	jne    80035e <devcons_read+0x5b>
		return 0;
  800357:	b8 00 00 00 00       	mov    $0x0,%eax
  80035c:	eb 10                	jmp    80036e <devcons_read+0x6b>
	*(char*)vbuf = c;
  80035e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800361:	89 c2                	mov    %eax,%edx
  800363:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800367:	88 10                	mov    %dl,(%rax)
	return 1;
  800369:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036e:	c9                   	leaveq 
  80036f:	c3                   	retq   

0000000000800370 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800370:	55                   	push   %rbp
  800371:	48 89 e5             	mov    %rsp,%rbp
  800374:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80037b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800382:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800389:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800397:	eb 77                	jmp    800410 <devcons_write+0xa0>
		m = n - tot;
  800399:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a5:	89 d1                	mov    %edx,%ecx
  8003a7:	29 c1                	sub    %eax,%ecx
  8003a9:	89 c8                	mov    %ecx,%eax
  8003ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003b1:	83 f8 7f             	cmp    $0x7f,%eax
  8003b4:	76 07                	jbe    8003bd <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8003b6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003c0:	48 63 d0             	movslq %eax,%rdx
  8003c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c6:	48 98                	cltq   
  8003c8:	48 89 c1             	mov    %rax,%rcx
  8003cb:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8003d2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d9:	48 89 ce             	mov    %rcx,%rsi
  8003dc:	48 89 c7             	mov    %rax,%rdi
  8003df:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  8003e6:	00 00 00 
  8003e9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ee:	48 63 d0             	movslq %eax,%rdx
  8003f1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f8:	48 89 d6             	mov    %rdx,%rsi
  8003fb:	48 89 c7             	mov    %rax,%rdi
  8003fe:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  800405:	00 00 00 
  800408:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80040a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040d:	01 45 fc             	add    %eax,-0x4(%rbp)
  800410:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800413:	48 98                	cltq   
  800415:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80041c:	0f 82 77 ff ff ff    	jb     800399 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800422:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800425:	c9                   	leaveq 
  800426:	c3                   	retq   

0000000000800427 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800427:	55                   	push   %rbp
  800428:	48 89 e5             	mov    %rsp,%rbp
  80042b:	48 83 ec 08          	sub    $0x8,%rsp
  80042f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800433:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800438:	c9                   	leaveq 
  800439:	c3                   	retq   

000000000080043a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80043a:	55                   	push   %rbp
  80043b:	48 89 e5             	mov    %rsp,%rbp
  80043e:	48 83 ec 10          	sub    $0x10,%rsp
  800442:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80044a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044e:	48 be ed 41 80 00 00 	movabs $0x8041ed,%rsi
  800455:	00 00 00 
  800458:	48 89 c7             	mov    %rax,%rdi
  80045b:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
	return 0;
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   
	...

0000000000800470 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800470:	55                   	push   %rbp
  800471:	48 89 e5             	mov    %rsp,%rbp
  800474:	48 83 ec 10          	sub    $0x10,%rsp
  800478:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80047f:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  800486:	00 00 00 
  800489:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800490:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  800497:	00 00 00 
  80049a:	ff d0                	callq  *%rax
  80049c:	48 98                	cltq   
  80049e:	48 89 c2             	mov    %rax,%rdx
  8004a1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8004a7:	48 89 d0             	mov    %rdx,%rax
  8004aa:	48 c1 e0 03          	shl    $0x3,%rax
  8004ae:	48 01 d0             	add    %rdx,%rax
  8004b1:	48 c1 e0 05          	shl    $0x5,%rax
  8004b5:	48 89 c2             	mov    %rax,%rdx
  8004b8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8004bf:	00 00 00 
  8004c2:	48 01 c2             	add    %rax,%rdx
  8004c5:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  8004cc:	00 00 00 
  8004cf:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004d6:	7e 14                	jle    8004ec <libmain+0x7c>
		binaryname = argv[0];
  8004d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004dc:	48 8b 10             	mov    (%rax),%rdx
  8004df:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8004e6:	00 00 00 
  8004e9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f3:	48 89 d6             	mov    %rdx,%rsi
  8004f6:	89 c7                	mov    %eax,%edi
  8004f8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8004ff:	00 00 00 
  800502:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800504:	48 b8 14 05 80 00 00 	movabs $0x800514,%rax
  80050b:	00 00 00 
  80050e:	ff d0                	callq  *%rax
}
  800510:	c9                   	leaveq 
  800511:	c3                   	retq   
	...

0000000000800514 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800514:	55                   	push   %rbp
  800515:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800518:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  80051f:	00 00 00 
  800522:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800524:	bf 00 00 00 00       	mov    $0x0,%edi
  800529:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  800530:	00 00 00 
  800533:	ff d0                	callq  *%rax
}
  800535:	5d                   	pop    %rbp
  800536:	c3                   	retq   
	...

0000000000800538 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800538:	55                   	push   %rbp
  800539:	48 89 e5             	mov    %rsp,%rbp
  80053c:	53                   	push   %rbx
  80053d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800544:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80054b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800551:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800558:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80055f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800566:	84 c0                	test   %al,%al
  800568:	74 23                	je     80058d <_panic+0x55>
  80056a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800571:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800575:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800579:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80057d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800581:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800585:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800589:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80058d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800594:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80059b:	00 00 00 
  80059e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8005a5:	00 00 00 
  8005a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005ac:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8005b3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005ba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005c1:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8005c8:	00 00 00 
  8005cb:	48 8b 18             	mov    (%rax),%rbx
  8005ce:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  8005d5:	00 00 00 
  8005d8:	ff d0                	callq  *%rax
  8005da:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005e0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005e7:	41 89 c8             	mov    %ecx,%r8d
  8005ea:	48 89 d1             	mov    %rdx,%rcx
  8005ed:	48 89 da             	mov    %rbx,%rdx
  8005f0:	89 c6                	mov    %eax,%esi
  8005f2:	48 bf 00 42 80 00 00 	movabs $0x804200,%rdi
  8005f9:	00 00 00 
  8005fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800601:	49 b9 73 07 80 00 00 	movabs $0x800773,%r9
  800608:	00 00 00 
  80060b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80060e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800615:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80061c:	48 89 d6             	mov    %rdx,%rsi
  80061f:	48 89 c7             	mov    %rax,%rdi
  800622:	48 b8 c7 06 80 00 00 	movabs $0x8006c7,%rax
  800629:	00 00 00 
  80062c:	ff d0                	callq  *%rax
	cprintf("\n");
  80062e:	48 bf 23 42 80 00 00 	movabs $0x804223,%rdi
  800635:	00 00 00 
  800638:	b8 00 00 00 00       	mov    $0x0,%eax
  80063d:	48 ba 73 07 80 00 00 	movabs $0x800773,%rdx
  800644:	00 00 00 
  800647:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800649:	cc                   	int3   
  80064a:	eb fd                	jmp    800649 <_panic+0x111>

000000000080064c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80064c:	55                   	push   %rbp
  80064d:	48 89 e5             	mov    %rsp,%rbp
  800650:	48 83 ec 10          	sub    $0x10,%rsp
  800654:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800657:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80065b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065f:	8b 00                	mov    (%rax),%eax
  800661:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800664:	89 d6                	mov    %edx,%esi
  800666:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80066a:	48 63 d0             	movslq %eax,%rdx
  80066d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800672:	8d 50 01             	lea    0x1(%rax),%edx
  800675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800679:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80067b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067f:	8b 00                	mov    (%rax),%eax
  800681:	3d ff 00 00 00       	cmp    $0xff,%eax
  800686:	75 2c                	jne    8006b4 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068c:	8b 00                	mov    (%rax),%eax
  80068e:	48 98                	cltq   
  800690:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800694:	48 83 c2 08          	add    $0x8,%rdx
  800698:	48 89 c6             	mov    %rax,%rsi
  80069b:	48 89 d7             	mov    %rdx,%rdi
  80069e:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  8006a5:	00 00 00 
  8006a8:	ff d0                	callq  *%rax
		b->idx = 0;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8006b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b8:	8b 40 04             	mov    0x4(%rax),%eax
  8006bb:	8d 50 01             	lea    0x1(%rax),%edx
  8006be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006c5:	c9                   	leaveq 
  8006c6:	c3                   	retq   

00000000008006c7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006c7:	55                   	push   %rbp
  8006c8:	48 89 e5             	mov    %rsp,%rbp
  8006cb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006d2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006d9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006e0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006e7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006ee:	48 8b 0a             	mov    (%rdx),%rcx
  8006f1:	48 89 08             	mov    %rcx,(%rax)
  8006f4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006f8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006fc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800700:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800704:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80070b:	00 00 00 
	b.cnt = 0;
  80070e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800715:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800718:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80071f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800726:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80072d:	48 89 c6             	mov    %rax,%rsi
  800730:	48 bf 4c 06 80 00 00 	movabs $0x80064c,%rdi
  800737:	00 00 00 
  80073a:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  800741:	00 00 00 
  800744:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800746:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80074c:	48 98                	cltq   
  80074e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800755:	48 83 c2 08          	add    $0x8,%rdx
  800759:	48 89 c6             	mov    %rax,%rsi
  80075c:	48 89 d7             	mov    %rdx,%rdi
  80075f:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  800766:	00 00 00 
  800769:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80076b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800771:	c9                   	leaveq 
  800772:	c3                   	retq   

0000000000800773 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800773:	55                   	push   %rbp
  800774:	48 89 e5             	mov    %rsp,%rbp
  800777:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80077e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800785:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80078c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800793:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80079a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8007a1:	84 c0                	test   %al,%al
  8007a3:	74 20                	je     8007c5 <cprintf+0x52>
  8007a5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8007a9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8007ad:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007b1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007b5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007b9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007bd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007c1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007c5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007cc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007d3:	00 00 00 
  8007d6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007dd:	00 00 00 
  8007e0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007e4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007eb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007f2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007f9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800800:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800807:	48 8b 0a             	mov    (%rdx),%rcx
  80080a:	48 89 08             	mov    %rcx,(%rax)
  80080d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800811:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800815:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800819:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80081d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800824:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80082b:	48 89 d6             	mov    %rdx,%rsi
  80082e:	48 89 c7             	mov    %rax,%rdi
  800831:	48 b8 c7 06 80 00 00 	movabs $0x8006c7,%rax
  800838:	00 00 00 
  80083b:	ff d0                	callq  *%rax
  80083d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800843:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800849:	c9                   	leaveq 
  80084a:	c3                   	retq   
	...

000000000080084c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80084c:	55                   	push   %rbp
  80084d:	48 89 e5             	mov    %rsp,%rbp
  800850:	48 83 ec 30          	sub    $0x30,%rsp
  800854:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800858:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80085c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800860:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800863:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800867:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80086e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800872:	77 52                	ja     8008c6 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800874:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800877:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80087b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80087e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	ba 00 00 00 00       	mov    $0x0,%edx
  80088b:	48 f7 75 d0          	divq   -0x30(%rbp)
  80088f:	48 89 c2             	mov    %rax,%rdx
  800892:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800895:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800898:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80089c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008a0:	41 89 f9             	mov    %edi,%r9d
  8008a3:	48 89 c7             	mov    %rax,%rdi
  8008a6:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  8008ad:	00 00 00 
  8008b0:	ff d0                	callq  *%rax
  8008b2:	eb 1c                	jmp    8008d0 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008b8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8008bb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8008bf:	48 89 d6             	mov    %rdx,%rsi
  8008c2:	89 c7                	mov    %eax,%edi
  8008c4:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008c6:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008ce:	7f e4                	jg     8008b4 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	48 f7 f1             	div    %rcx
  8008df:	48 89 d0             	mov    %rdx,%rax
  8008e2:	48 ba 08 44 80 00 00 	movabs $0x804408,%rdx
  8008e9:	00 00 00 
  8008ec:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008f0:	0f be c0             	movsbl %al,%eax
  8008f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008f7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8008fb:	48 89 d6             	mov    %rdx,%rsi
  8008fe:	89 c7                	mov    %eax,%edi
  800900:	ff d1                	callq  *%rcx
}
  800902:	c9                   	leaveq 
  800903:	c3                   	retq   

0000000000800904 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800904:	55                   	push   %rbp
  800905:	48 89 e5             	mov    %rsp,%rbp
  800908:	48 83 ec 20          	sub    $0x20,%rsp
  80090c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800910:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800913:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800917:	7e 52                	jle    80096b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091d:	8b 00                	mov    (%rax),%eax
  80091f:	83 f8 30             	cmp    $0x30,%eax
  800922:	73 24                	jae    800948 <getuint+0x44>
  800924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800928:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80092c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800930:	8b 00                	mov    (%rax),%eax
  800932:	89 c0                	mov    %eax,%eax
  800934:	48 01 d0             	add    %rdx,%rax
  800937:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093b:	8b 12                	mov    (%rdx),%edx
  80093d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800940:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800944:	89 0a                	mov    %ecx,(%rdx)
  800946:	eb 17                	jmp    80095f <getuint+0x5b>
  800948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800950:	48 89 d0             	mov    %rdx,%rax
  800953:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800957:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80095f:	48 8b 00             	mov    (%rax),%rax
  800962:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800966:	e9 a3 00 00 00       	jmpq   800a0e <getuint+0x10a>
	else if (lflag)
  80096b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80096f:	74 4f                	je     8009c0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	8b 00                	mov    (%rax),%eax
  800977:	83 f8 30             	cmp    $0x30,%eax
  80097a:	73 24                	jae    8009a0 <getuint+0x9c>
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 01 d0             	add    %rdx,%rax
  80098f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800993:	8b 12                	mov    (%rdx),%edx
  800995:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800998:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099c:	89 0a                	mov    %ecx,(%rdx)
  80099e:	eb 17                	jmp    8009b7 <getuint+0xb3>
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009a8:	48 89 d0             	mov    %rdx,%rax
  8009ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b7:	48 8b 00             	mov    (%rax),%rax
  8009ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009be:	eb 4e                	jmp    800a0e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	8b 00                	mov    (%rax),%eax
  8009c6:	83 f8 30             	cmp    $0x30,%eax
  8009c9:	73 24                	jae    8009ef <getuint+0xeb>
  8009cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	8b 00                	mov    (%rax),%eax
  8009d9:	89 c0                	mov    %eax,%eax
  8009db:	48 01 d0             	add    %rdx,%rax
  8009de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e2:	8b 12                	mov    (%rdx),%edx
  8009e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009eb:	89 0a                	mov    %ecx,(%rdx)
  8009ed:	eb 17                	jmp    800a06 <getuint+0x102>
  8009ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009f7:	48 89 d0             	mov    %rdx,%rax
  8009fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a02:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a06:	8b 00                	mov    (%rax),%eax
  800a08:	89 c0                	mov    %eax,%eax
  800a0a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a12:	c9                   	leaveq 
  800a13:	c3                   	retq   

0000000000800a14 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a14:	55                   	push   %rbp
  800a15:	48 89 e5             	mov    %rsp,%rbp
  800a18:	48 83 ec 20          	sub    $0x20,%rsp
  800a1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a20:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a23:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a27:	7e 52                	jle    800a7b <getint+0x67>
		x=va_arg(*ap, long long);
  800a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2d:	8b 00                	mov    (%rax),%eax
  800a2f:	83 f8 30             	cmp    $0x30,%eax
  800a32:	73 24                	jae    800a58 <getint+0x44>
  800a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a38:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	8b 00                	mov    (%rax),%eax
  800a42:	89 c0                	mov    %eax,%eax
  800a44:	48 01 d0             	add    %rdx,%rax
  800a47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4b:	8b 12                	mov    (%rdx),%edx
  800a4d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a54:	89 0a                	mov    %ecx,(%rdx)
  800a56:	eb 17                	jmp    800a6f <getint+0x5b>
  800a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a60:	48 89 d0             	mov    %rdx,%rax
  800a63:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a6f:	48 8b 00             	mov    (%rax),%rax
  800a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a76:	e9 a3 00 00 00       	jmpq   800b1e <getint+0x10a>
	else if (lflag)
  800a7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a7f:	74 4f                	je     800ad0 <getint+0xbc>
		x=va_arg(*ap, long);
  800a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a85:	8b 00                	mov    (%rax),%eax
  800a87:	83 f8 30             	cmp    $0x30,%eax
  800a8a:	73 24                	jae    800ab0 <getint+0x9c>
  800a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a98:	8b 00                	mov    (%rax),%eax
  800a9a:	89 c0                	mov    %eax,%eax
  800a9c:	48 01 d0             	add    %rdx,%rax
  800a9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa3:	8b 12                	mov    (%rdx),%edx
  800aa5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aac:	89 0a                	mov    %ecx,(%rdx)
  800aae:	eb 17                	jmp    800ac7 <getint+0xb3>
  800ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ab8:	48 89 d0             	mov    %rdx,%rax
  800abb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800abf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ac7:	48 8b 00             	mov    (%rax),%rax
  800aca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ace:	eb 4e                	jmp    800b1e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad4:	8b 00                	mov    (%rax),%eax
  800ad6:	83 f8 30             	cmp    $0x30,%eax
  800ad9:	73 24                	jae    800aff <getint+0xeb>
  800adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae7:	8b 00                	mov    (%rax),%eax
  800ae9:	89 c0                	mov    %eax,%eax
  800aeb:	48 01 d0             	add    %rdx,%rax
  800aee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af2:	8b 12                	mov    (%rdx),%edx
  800af4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800af7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800afb:	89 0a                	mov    %ecx,(%rdx)
  800afd:	eb 17                	jmp    800b16 <getint+0x102>
  800aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b03:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b07:	48 89 d0             	mov    %rdx,%rax
  800b0a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b12:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b16:	8b 00                	mov    (%rax),%eax
  800b18:	48 98                	cltq   
  800b1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b22:	c9                   	leaveq 
  800b23:	c3                   	retq   

0000000000800b24 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b24:	55                   	push   %rbp
  800b25:	48 89 e5             	mov    %rsp,%rbp
  800b28:	41 54                	push   %r12
  800b2a:	53                   	push   %rbx
  800b2b:	48 83 ec 60          	sub    $0x60,%rsp
  800b2f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b33:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b37:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b3b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b43:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b47:	48 8b 0a             	mov    (%rdx),%rcx
  800b4a:	48 89 08             	mov    %rcx,(%rax)
  800b4d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b51:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b55:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b59:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b5d:	eb 17                	jmp    800b76 <vprintfmt+0x52>
			if (ch == '\0')
  800b5f:	85 db                	test   %ebx,%ebx
  800b61:	0f 84 d7 04 00 00    	je     80103e <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800b67:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b6b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b6f:	48 89 c6             	mov    %rax,%rsi
  800b72:	89 df                	mov    %ebx,%edi
  800b74:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b76:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b7a:	0f b6 00             	movzbl (%rax),%eax
  800b7d:	0f b6 d8             	movzbl %al,%ebx
  800b80:	83 fb 25             	cmp    $0x25,%ebx
  800b83:	0f 95 c0             	setne  %al
  800b86:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b8b:	84 c0                	test   %al,%al
  800b8d:	75 d0                	jne    800b5f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b8f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b93:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b9a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800ba1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800ba8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800baf:	eb 04                	jmp    800bb5 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800bb1:	90                   	nop
  800bb2:	eb 01                	jmp    800bb5 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800bb4:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bb9:	0f b6 00             	movzbl (%rax),%eax
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	89 d8                	mov    %ebx,%eax
  800bc1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800bc6:	83 e8 23             	sub    $0x23,%eax
  800bc9:	83 f8 55             	cmp    $0x55,%eax
  800bcc:	0f 87 38 04 00 00    	ja     80100a <vprintfmt+0x4e6>
  800bd2:	89 c0                	mov    %eax,%eax
  800bd4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bdb:	00 
  800bdc:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  800be3:	00 00 00 
  800be6:	48 01 d0             	add    %rdx,%rax
  800be9:	48 8b 00             	mov    (%rax),%rax
  800bec:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bee:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bf2:	eb c1                	jmp    800bb5 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bf4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bf8:	eb bb                	jmp    800bb5 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c01:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c04:	89 d0                	mov    %edx,%eax
  800c06:	c1 e0 02             	shl    $0x2,%eax
  800c09:	01 d0                	add    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d8                	add    %ebx,%eax
  800c0f:	83 e8 30             	sub    $0x30,%eax
  800c12:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c15:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c19:	0f b6 00             	movzbl (%rax),%eax
  800c1c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c1f:	83 fb 2f             	cmp    $0x2f,%ebx
  800c22:	7e 63                	jle    800c87 <vprintfmt+0x163>
  800c24:	83 fb 39             	cmp    $0x39,%ebx
  800c27:	7f 5e                	jg     800c87 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c29:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c2e:	eb d1                	jmp    800c01 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c33:	83 f8 30             	cmp    $0x30,%eax
  800c36:	73 17                	jae    800c4f <vprintfmt+0x12b>
  800c38:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3f:	89 c0                	mov    %eax,%eax
  800c41:	48 01 d0             	add    %rdx,%rax
  800c44:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c47:	83 c2 08             	add    $0x8,%edx
  800c4a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c4d:	eb 0f                	jmp    800c5e <vprintfmt+0x13a>
  800c4f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c53:	48 89 d0             	mov    %rdx,%rax
  800c56:	48 83 c2 08          	add    $0x8,%rdx
  800c5a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c5e:	8b 00                	mov    (%rax),%eax
  800c60:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c63:	eb 23                	jmp    800c88 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800c65:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c69:	0f 89 42 ff ff ff    	jns    800bb1 <vprintfmt+0x8d>
				width = 0;
  800c6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c76:	e9 36 ff ff ff       	jmpq   800bb1 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800c7b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c82:	e9 2e ff ff ff       	jmpq   800bb5 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c87:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c88:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c8c:	0f 89 22 ff ff ff    	jns    800bb4 <vprintfmt+0x90>
				width = precision, precision = -1;
  800c92:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c95:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c98:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c9f:	e9 10 ff ff ff       	jmpq   800bb4 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ca4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ca8:	e9 08 ff ff ff       	jmpq   800bb5 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800cad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb0:	83 f8 30             	cmp    $0x30,%eax
  800cb3:	73 17                	jae    800ccc <vprintfmt+0x1a8>
  800cb5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbc:	89 c0                	mov    %eax,%eax
  800cbe:	48 01 d0             	add    %rdx,%rax
  800cc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc4:	83 c2 08             	add    $0x8,%edx
  800cc7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cca:	eb 0f                	jmp    800cdb <vprintfmt+0x1b7>
  800ccc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd0:	48 89 d0             	mov    %rdx,%rax
  800cd3:	48 83 c2 08          	add    $0x8,%rdx
  800cd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cdb:	8b 00                	mov    (%rax),%eax
  800cdd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800ce5:	48 89 d6             	mov    %rdx,%rsi
  800ce8:	89 c7                	mov    %eax,%edi
  800cea:	ff d1                	callq  *%rcx
			break;
  800cec:	e9 47 03 00 00       	jmpq   801038 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800cf1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf4:	83 f8 30             	cmp    $0x30,%eax
  800cf7:	73 17                	jae    800d10 <vprintfmt+0x1ec>
  800cf9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cfd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d00:	89 c0                	mov    %eax,%eax
  800d02:	48 01 d0             	add    %rdx,%rax
  800d05:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d08:	83 c2 08             	add    $0x8,%edx
  800d0b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d0e:	eb 0f                	jmp    800d1f <vprintfmt+0x1fb>
  800d10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d14:	48 89 d0             	mov    %rdx,%rax
  800d17:	48 83 c2 08          	add    $0x8,%rdx
  800d1b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d1f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d21:	85 db                	test   %ebx,%ebx
  800d23:	79 02                	jns    800d27 <vprintfmt+0x203>
				err = -err;
  800d25:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d27:	83 fb 10             	cmp    $0x10,%ebx
  800d2a:	7f 16                	jg     800d42 <vprintfmt+0x21e>
  800d2c:	48 b8 80 43 80 00 00 	movabs $0x804380,%rax
  800d33:	00 00 00 
  800d36:	48 63 d3             	movslq %ebx,%rdx
  800d39:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d3d:	4d 85 e4             	test   %r12,%r12
  800d40:	75 2e                	jne    800d70 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800d42:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4a:	89 d9                	mov    %ebx,%ecx
  800d4c:	48 ba 19 44 80 00 00 	movabs $0x804419,%rdx
  800d53:	00 00 00 
  800d56:	48 89 c7             	mov    %rax,%rdi
  800d59:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5e:	49 b8 48 10 80 00 00 	movabs $0x801048,%r8
  800d65:	00 00 00 
  800d68:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d6b:	e9 c8 02 00 00       	jmpq   801038 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d70:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d78:	4c 89 e1             	mov    %r12,%rcx
  800d7b:	48 ba 22 44 80 00 00 	movabs $0x804422,%rdx
  800d82:	00 00 00 
  800d85:	48 89 c7             	mov    %rax,%rdi
  800d88:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8d:	49 b8 48 10 80 00 00 	movabs $0x801048,%r8
  800d94:	00 00 00 
  800d97:	41 ff d0             	callq  *%r8
			break;
  800d9a:	e9 99 02 00 00       	jmpq   801038 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da2:	83 f8 30             	cmp    $0x30,%eax
  800da5:	73 17                	jae    800dbe <vprintfmt+0x29a>
  800da7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dae:	89 c0                	mov    %eax,%eax
  800db0:	48 01 d0             	add    %rdx,%rax
  800db3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800db6:	83 c2 08             	add    $0x8,%edx
  800db9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dbc:	eb 0f                	jmp    800dcd <vprintfmt+0x2a9>
  800dbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc2:	48 89 d0             	mov    %rdx,%rax
  800dc5:	48 83 c2 08          	add    $0x8,%rdx
  800dc9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dcd:	4c 8b 20             	mov    (%rax),%r12
  800dd0:	4d 85 e4             	test   %r12,%r12
  800dd3:	75 0a                	jne    800ddf <vprintfmt+0x2bb>
				p = "(null)";
  800dd5:	49 bc 25 44 80 00 00 	movabs $0x804425,%r12
  800ddc:	00 00 00 
			if (width > 0 && padc != '-')
  800ddf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800de3:	7e 7a                	jle    800e5f <vprintfmt+0x33b>
  800de5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800de9:	74 74                	je     800e5f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800deb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dee:	48 98                	cltq   
  800df0:	48 89 c6             	mov    %rax,%rsi
  800df3:	4c 89 e7             	mov    %r12,%rdi
  800df6:	48 b8 52 14 80 00 00 	movabs $0x801452,%rax
  800dfd:	00 00 00 
  800e00:	ff d0                	callq  *%rax
  800e02:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e05:	eb 17                	jmp    800e1e <vprintfmt+0x2fa>
					putch(padc, putdat);
  800e07:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800e0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0f:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800e13:	48 89 d6             	mov    %rdx,%rsi
  800e16:	89 c7                	mov    %eax,%edi
  800e18:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e1a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e22:	7f e3                	jg     800e07 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e24:	eb 39                	jmp    800e5f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800e26:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e2a:	74 1e                	je     800e4a <vprintfmt+0x326>
  800e2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800e2f:	7e 05                	jle    800e36 <vprintfmt+0x312>
  800e31:	83 fb 7e             	cmp    $0x7e,%ebx
  800e34:	7e 14                	jle    800e4a <vprintfmt+0x326>
					putch('?', putdat);
  800e36:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e3a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e3e:	48 89 c6             	mov    %rax,%rsi
  800e41:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e46:	ff d2                	callq  *%rdx
  800e48:	eb 0f                	jmp    800e59 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800e4a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e4e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e52:	48 89 c6             	mov    %rax,%rsi
  800e55:	89 df                	mov    %ebx,%edi
  800e57:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e59:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e5d:	eb 01                	jmp    800e60 <vprintfmt+0x33c>
  800e5f:	90                   	nop
  800e60:	41 0f b6 04 24       	movzbl (%r12),%eax
  800e65:	0f be d8             	movsbl %al,%ebx
  800e68:	85 db                	test   %ebx,%ebx
  800e6a:	0f 95 c0             	setne  %al
  800e6d:	49 83 c4 01          	add    $0x1,%r12
  800e71:	84 c0                	test   %al,%al
  800e73:	74 28                	je     800e9d <vprintfmt+0x379>
  800e75:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e79:	78 ab                	js     800e26 <vprintfmt+0x302>
  800e7b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e7f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e83:	79 a1                	jns    800e26 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e85:	eb 16                	jmp    800e9d <vprintfmt+0x379>
				putch(' ', putdat);
  800e87:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e8b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e8f:	48 89 c6             	mov    %rax,%rsi
  800e92:	bf 20 00 00 00       	mov    $0x20,%edi
  800e97:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e99:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e9d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ea1:	7f e4                	jg     800e87 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800ea3:	e9 90 01 00 00       	jmpq   801038 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ea8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eac:	be 03 00 00 00       	mov    $0x3,%esi
  800eb1:	48 89 c7             	mov    %rax,%rdi
  800eb4:	48 b8 14 0a 80 00 00 	movabs $0x800a14,%rax
  800ebb:	00 00 00 
  800ebe:	ff d0                	callq  *%rax
  800ec0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec8:	48 85 c0             	test   %rax,%rax
  800ecb:	79 1d                	jns    800eea <vprintfmt+0x3c6>
				putch('-', putdat);
  800ecd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ed1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ed5:	48 89 c6             	mov    %rax,%rsi
  800ed8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800edd:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee3:	48 f7 d8             	neg    %rax
  800ee6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eea:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ef1:	e9 d5 00 00 00       	jmpq   800fcb <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ef6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800efa:	be 03 00 00 00       	mov    $0x3,%esi
  800eff:	48 89 c7             	mov    %rax,%rdi
  800f02:	48 b8 04 09 80 00 00 	movabs $0x800904,%rax
  800f09:	00 00 00 
  800f0c:	ff d0                	callq  *%rax
  800f0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f12:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f19:	e9 ad 00 00 00       	jmpq   800fcb <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800f1e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f22:	be 03 00 00 00       	mov    $0x3,%esi
  800f27:	48 89 c7             	mov    %rax,%rdi
  800f2a:	48 b8 04 09 80 00 00 	movabs $0x800904,%rax
  800f31:	00 00 00 
  800f34:	ff d0                	callq  *%rax
  800f36:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800f3a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f41:	e9 85 00 00 00       	jmpq   800fcb <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800f46:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f4a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f4e:	48 89 c6             	mov    %rax,%rsi
  800f51:	bf 30 00 00 00       	mov    $0x30,%edi
  800f56:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800f58:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f5c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f60:	48 89 c6             	mov    %rax,%rsi
  800f63:	bf 78 00 00 00       	mov    $0x78,%edi
  800f68:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f6d:	83 f8 30             	cmp    $0x30,%eax
  800f70:	73 17                	jae    800f89 <vprintfmt+0x465>
  800f72:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f79:	89 c0                	mov    %eax,%eax
  800f7b:	48 01 d0             	add    %rdx,%rax
  800f7e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f81:	83 c2 08             	add    $0x8,%edx
  800f84:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f87:	eb 0f                	jmp    800f98 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800f89:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f8d:	48 89 d0             	mov    %rdx,%rax
  800f90:	48 83 c2 08          	add    $0x8,%rdx
  800f94:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f98:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f9f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fa6:	eb 23                	jmp    800fcb <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fa8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fac:	be 03 00 00 00       	mov    $0x3,%esi
  800fb1:	48 89 c7             	mov    %rax,%rdi
  800fb4:	48 b8 04 09 80 00 00 	movabs $0x800904,%rax
  800fbb:	00 00 00 
  800fbe:	ff d0                	callq  *%rax
  800fc0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fc4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fcb:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fd0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fd3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fda:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe2:	45 89 c1             	mov    %r8d,%r9d
  800fe5:	41 89 f8             	mov    %edi,%r8d
  800fe8:	48 89 c7             	mov    %rax,%rdi
  800feb:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  800ff2:	00 00 00 
  800ff5:	ff d0                	callq  *%rax
			break;
  800ff7:	eb 3f                	jmp    801038 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ff9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ffd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801001:	48 89 c6             	mov    %rax,%rsi
  801004:	89 df                	mov    %ebx,%edi
  801006:	ff d2                	callq  *%rdx
			break;
  801008:	eb 2e                	jmp    801038 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80100a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80100e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801012:	48 89 c6             	mov    %rax,%rsi
  801015:	bf 25 00 00 00       	mov    $0x25,%edi
  80101a:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  80101c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801021:	eb 05                	jmp    801028 <vprintfmt+0x504>
  801023:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801028:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80102c:	48 83 e8 01          	sub    $0x1,%rax
  801030:	0f b6 00             	movzbl (%rax),%eax
  801033:	3c 25                	cmp    $0x25,%al
  801035:	75 ec                	jne    801023 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  801037:	90                   	nop
		}
	}
  801038:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801039:	e9 38 fb ff ff       	jmpq   800b76 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  80103e:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  80103f:	48 83 c4 60          	add    $0x60,%rsp
  801043:	5b                   	pop    %rbx
  801044:	41 5c                	pop    %r12
  801046:	5d                   	pop    %rbp
  801047:	c3                   	retq   

0000000000801048 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801048:	55                   	push   %rbp
  801049:	48 89 e5             	mov    %rsp,%rbp
  80104c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801053:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80105a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801061:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801068:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80106f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801076:	84 c0                	test   %al,%al
  801078:	74 20                	je     80109a <printfmt+0x52>
  80107a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80107e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801082:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801086:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80108a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80108e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801092:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801096:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80109a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010a1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010a8:	00 00 00 
  8010ab:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010b2:	00 00 00 
  8010b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010b9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010c0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010c7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010ce:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010d5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010dc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010e3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010ea:	48 89 c7             	mov    %rax,%rdi
  8010ed:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  8010f4:	00 00 00 
  8010f7:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010f9:	c9                   	leaveq 
  8010fa:	c3                   	retq   

00000000008010fb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010fb:	55                   	push   %rbp
  8010fc:	48 89 e5             	mov    %rsp,%rbp
  8010ff:	48 83 ec 10          	sub    $0x10,%rsp
  801103:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801106:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80110a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110e:	8b 40 10             	mov    0x10(%rax),%eax
  801111:	8d 50 01             	lea    0x1(%rax),%edx
  801114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801118:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80111b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111f:	48 8b 10             	mov    (%rax),%rdx
  801122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801126:	48 8b 40 08          	mov    0x8(%rax),%rax
  80112a:	48 39 c2             	cmp    %rax,%rdx
  80112d:	73 17                	jae    801146 <sprintputch+0x4b>
		*b->buf++ = ch;
  80112f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801133:	48 8b 00             	mov    (%rax),%rax
  801136:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801139:	88 10                	mov    %dl,(%rax)
  80113b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801143:	48 89 10             	mov    %rdx,(%rax)
}
  801146:	c9                   	leaveq 
  801147:	c3                   	retq   

0000000000801148 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801148:	55                   	push   %rbp
  801149:	48 89 e5             	mov    %rsp,%rbp
  80114c:	48 83 ec 50          	sub    $0x50,%rsp
  801150:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801154:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801157:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80115b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80115f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801163:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801167:	48 8b 0a             	mov    (%rdx),%rcx
  80116a:	48 89 08             	mov    %rcx,(%rax)
  80116d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801171:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801175:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801179:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80117d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801181:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801185:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801188:	48 98                	cltq   
  80118a:	48 83 e8 01          	sub    $0x1,%rax
  80118e:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801192:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801196:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80119d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011a2:	74 06                	je     8011aa <vsnprintf+0x62>
  8011a4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011a8:	7f 07                	jg     8011b1 <vsnprintf+0x69>
		return -E_INVAL;
  8011aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011af:	eb 2f                	jmp    8011e0 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011b1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011b5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011b9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011bd:	48 89 c6             	mov    %rax,%rsi
  8011c0:	48 bf fb 10 80 00 00 	movabs $0x8010fb,%rdi
  8011c7:	00 00 00 
  8011ca:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  8011d1:	00 00 00 
  8011d4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011da:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011dd:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011e0:	c9                   	leaveq 
  8011e1:	c3                   	retq   

00000000008011e2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e2:	55                   	push   %rbp
  8011e3:	48 89 e5             	mov    %rsp,%rbp
  8011e6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011ed:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011f4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011fa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801201:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801208:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80120f:	84 c0                	test   %al,%al
  801211:	74 20                	je     801233 <snprintf+0x51>
  801213:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801217:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80121b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80121f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801223:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801227:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80122b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80122f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801233:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80123a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801241:	00 00 00 
  801244:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80124b:	00 00 00 
  80124e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801252:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801259:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801260:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801267:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80126e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801275:	48 8b 0a             	mov    (%rdx),%rcx
  801278:	48 89 08             	mov    %rcx,(%rax)
  80127b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80127f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801283:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801287:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80128b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801292:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801299:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80129f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012a6:	48 89 c7             	mov    %rax,%rdi
  8012a9:	48 b8 48 11 80 00 00 	movabs $0x801148,%rax
  8012b0:	00 00 00 
  8012b3:	ff d0                	callq  *%rax
  8012b5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012bb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012c1:	c9                   	leaveq 
  8012c2:	c3                   	retq   
	...

00000000008012c4 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8012c4:	55                   	push   %rbp
  8012c5:	48 89 e5             	mov    %rsp,%rbp
  8012c8:	48 83 ec 20          	sub    $0x20,%rsp
  8012cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012d0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d5:	74 27                	je     8012fe <readline+0x3a>
		fprintf(1, "%s", prompt);
  8012d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012db:	48 89 c2             	mov    %rax,%rdx
  8012de:	48 be e0 46 80 00 00 	movabs $0x8046e0,%rsi
  8012e5:	00 00 00 
  8012e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f2:	48 b9 a8 2f 80 00 00 	movabs $0x802fa8,%rcx
  8012f9:	00 00 00 
  8012fc:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8012fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  801305:	bf 00 00 00 00       	mov    $0x0,%edi
  80130a:	48 b8 30 02 80 00 00 	movabs $0x800230,%rax
  801311:	00 00 00 
  801314:	ff d0                	callq  *%rax
  801316:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801319:	eb 01                	jmp    80131c <readline+0x58>
			if (echoing)
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
  80131b:	90                   	nop
#endif

	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
  80131c:	48 b8 e7 01 80 00 00 	movabs $0x8001e7,%rax
  801323:	00 00 00 
  801326:	ff d0                	callq  *%rax
  801328:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  80132b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80132f:	79 30                	jns    801361 <readline+0x9d>
			if (c != -E_EOF)
  801331:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  801335:	74 20                	je     801357 <readline+0x93>
				cprintf("read error: %e\n", c);
  801337:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133a:	89 c6                	mov    %eax,%esi
  80133c:	48 bf e3 46 80 00 00 	movabs $0x8046e3,%rdi
  801343:	00 00 00 
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
  80134b:	48 ba 73 07 80 00 00 	movabs $0x800773,%rdx
  801352:	00 00 00 
  801355:	ff d2                	callq  *%rdx
			return NULL;
  801357:	b8 00 00 00 00       	mov    $0x0,%eax
  80135c:	e9 c0 00 00 00       	jmpq   801421 <readline+0x15d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801361:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  801365:	74 06                	je     80136d <readline+0xa9>
  801367:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  80136b:	75 26                	jne    801393 <readline+0xcf>
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801371:	7e 20                	jle    801393 <readline+0xcf>
			if (echoing)
  801373:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801377:	74 11                	je     80138a <readline+0xc6>
				cputchar('\b');
  801379:	bf 08 00 00 00       	mov    $0x8,%edi
  80137e:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  801385:	00 00 00 
  801388:	ff d0                	callq  *%rax
			i--;
  80138a:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80138e:	e9 89 00 00 00       	jmpq   80141c <readline+0x158>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801393:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  801397:	7e 3d                	jle    8013d6 <readline+0x112>
  801399:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  8013a0:	7f 34                	jg     8013d6 <readline+0x112>
			if (echoing)
  8013a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013a6:	74 11                	je     8013b9 <readline+0xf5>
				cputchar(c);
  8013a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ab:	89 c7                	mov    %eax,%edi
  8013ad:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  8013b4:	00 00 00 
  8013b7:	ff d0                	callq  *%rax
			buf[i++] = c;
  8013b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013bc:	89 c1                	mov    %eax,%ecx
  8013be:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  8013c5:	00 00 00 
  8013c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013cb:	48 98                	cltq   
  8013cd:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8013d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8013d4:	eb 46                	jmp    80141c <readline+0x158>
		} else if (c == '\n' || c == '\r') {
  8013d6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8013da:	74 0a                	je     8013e6 <readline+0x122>
  8013dc:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8013e0:	0f 85 35 ff ff ff    	jne    80131b <readline+0x57>
			if (echoing)
  8013e6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013ea:	74 11                	je     8013fd <readline+0x139>
				cputchar('\n');
  8013ec:	bf 0a 00 00 00       	mov    $0xa,%edi
  8013f1:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  8013f8:	00 00 00 
  8013fb:	ff d0                	callq  *%rax
			buf[i] = 0;
  8013fd:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  801404:	00 00 00 
  801407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80140a:	48 98                	cltq   
  80140c:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  801410:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801417:	00 00 00 
  80141a:	eb 05                	jmp    801421 <readline+0x15d>
		}
	}
  80141c:	e9 fa fe ff ff       	jmpq   80131b <readline+0x57>
}
  801421:	c9                   	leaveq 
  801422:	c3                   	retq   
	...

0000000000801424 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801424:	55                   	push   %rbp
  801425:	48 89 e5             	mov    %rsp,%rbp
  801428:	48 83 ec 18          	sub    $0x18,%rsp
  80142c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801430:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801437:	eb 09                	jmp    801442 <strlen+0x1e>
		n++;
  801439:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80143d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	84 c0                	test   %al,%al
  80144b:	75 ec                	jne    801439 <strlen+0x15>
		n++;
	return n;
  80144d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801450:	c9                   	leaveq 
  801451:	c3                   	retq   

0000000000801452 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801452:	55                   	push   %rbp
  801453:	48 89 e5             	mov    %rsp,%rbp
  801456:	48 83 ec 20          	sub    $0x20,%rsp
  80145a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80145e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801469:	eb 0e                	jmp    801479 <strnlen+0x27>
		n++;
  80146b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80146f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801474:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801479:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80147e:	74 0b                	je     80148b <strnlen+0x39>
  801480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801484:	0f b6 00             	movzbl (%rax),%eax
  801487:	84 c0                	test   %al,%al
  801489:	75 e0                	jne    80146b <strnlen+0x19>
		n++;
	return n;
  80148b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80148e:	c9                   	leaveq 
  80148f:	c3                   	retq   

0000000000801490 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801490:	55                   	push   %rbp
  801491:	48 89 e5             	mov    %rsp,%rbp
  801494:	48 83 ec 20          	sub    $0x20,%rsp
  801498:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8014a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8014a8:	90                   	nop
  8014a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ad:	0f b6 10             	movzbl (%rax),%edx
  8014b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b4:	88 10                	mov    %dl,(%rax)
  8014b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	84 c0                	test   %al,%al
  8014bf:	0f 95 c0             	setne  %al
  8014c2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014c7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8014cc:	84 c0                	test   %al,%al
  8014ce:	75 d9                	jne    8014a9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8014d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014d4:	c9                   	leaveq 
  8014d5:	c3                   	retq   

00000000008014d6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014d6:	55                   	push   %rbp
  8014d7:	48 89 e5             	mov    %rsp,%rbp
  8014da:	48 83 ec 20          	sub    $0x20,%rsp
  8014de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ea:	48 89 c7             	mov    %rax,%rdi
  8014ed:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  8014f4:	00 00 00 
  8014f7:	ff d0                	callq  *%rax
  8014f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8014fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014ff:	48 98                	cltq   
  801501:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801505:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801509:	48 89 d6             	mov    %rdx,%rsi
  80150c:	48 89 c7             	mov    %rax,%rdi
  80150f:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  801516:	00 00 00 
  801519:	ff d0                	callq  *%rax
	return dst;
  80151b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80151f:	c9                   	leaveq 
  801520:	c3                   	retq   

0000000000801521 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801521:	55                   	push   %rbp
  801522:	48 89 e5             	mov    %rsp,%rbp
  801525:	48 83 ec 28          	sub    $0x28,%rsp
  801529:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801531:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801539:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80153d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801544:	00 
  801545:	eb 27                	jmp    80156e <strncpy+0x4d>
		*dst++ = *src;
  801547:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154b:	0f b6 10             	movzbl (%rax),%edx
  80154e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801552:	88 10                	mov    %dl,(%rax)
  801554:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801559:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80155d:	0f b6 00             	movzbl (%rax),%eax
  801560:	84 c0                	test   %al,%al
  801562:	74 05                	je     801569 <strncpy+0x48>
			src++;
  801564:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801569:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80156e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801572:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801576:	72 cf                	jb     801547 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80157c:	c9                   	leaveq 
  80157d:	c3                   	retq   

000000000080157e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80157e:	55                   	push   %rbp
  80157f:	48 89 e5             	mov    %rsp,%rbp
  801582:	48 83 ec 28          	sub    $0x28,%rsp
  801586:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80158a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80158e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801596:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80159a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80159f:	74 37                	je     8015d8 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8015a1:	eb 17                	jmp    8015ba <strlcpy+0x3c>
			*dst++ = *src++;
  8015a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015a7:	0f b6 10             	movzbl (%rax),%edx
  8015aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ae:	88 10                	mov    %dl,(%rax)
  8015b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015b5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015ba:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015bf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015c4:	74 0b                	je     8015d1 <strlcpy+0x53>
  8015c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 d2                	jne    8015a3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e0:	48 89 d1             	mov    %rdx,%rcx
  8015e3:	48 29 c1             	sub    %rax,%rcx
  8015e6:	48 89 c8             	mov    %rcx,%rax
}
  8015e9:	c9                   	leaveq 
  8015ea:	c3                   	retq   

00000000008015eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015eb:	55                   	push   %rbp
  8015ec:	48 89 e5             	mov    %rsp,%rbp
  8015ef:	48 83 ec 10          	sub    $0x10,%rsp
  8015f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015fb:	eb 0a                	jmp    801607 <strcmp+0x1c>
		p++, q++;
  8015fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801602:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160b:	0f b6 00             	movzbl (%rax),%eax
  80160e:	84 c0                	test   %al,%al
  801610:	74 12                	je     801624 <strcmp+0x39>
  801612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801616:	0f b6 10             	movzbl (%rax),%edx
  801619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	38 c2                	cmp    %al,%dl
  801622:	74 d9                	je     8015fd <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801628:	0f b6 00             	movzbl (%rax),%eax
  80162b:	0f b6 d0             	movzbl %al,%edx
  80162e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801632:	0f b6 00             	movzbl (%rax),%eax
  801635:	0f b6 c0             	movzbl %al,%eax
  801638:	89 d1                	mov    %edx,%ecx
  80163a:	29 c1                	sub    %eax,%ecx
  80163c:	89 c8                	mov    %ecx,%eax
}
  80163e:	c9                   	leaveq 
  80163f:	c3                   	retq   

0000000000801640 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801640:	55                   	push   %rbp
  801641:	48 89 e5             	mov    %rsp,%rbp
  801644:	48 83 ec 18          	sub    $0x18,%rsp
  801648:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80164c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801650:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801654:	eb 0f                	jmp    801665 <strncmp+0x25>
		n--, p++, q++;
  801656:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80165b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801660:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801665:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80166a:	74 1d                	je     801689 <strncmp+0x49>
  80166c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	84 c0                	test   %al,%al
  801675:	74 12                	je     801689 <strncmp+0x49>
  801677:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167b:	0f b6 10             	movzbl (%rax),%edx
  80167e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	38 c2                	cmp    %al,%dl
  801687:	74 cd                	je     801656 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801689:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80168e:	75 07                	jne    801697 <strncmp+0x57>
		return 0;
  801690:	b8 00 00 00 00       	mov    $0x0,%eax
  801695:	eb 1a                	jmp    8016b1 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169b:	0f b6 00             	movzbl (%rax),%eax
  80169e:	0f b6 d0             	movzbl %al,%edx
  8016a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	0f b6 c0             	movzbl %al,%eax
  8016ab:	89 d1                	mov    %edx,%ecx
  8016ad:	29 c1                	sub    %eax,%ecx
  8016af:	89 c8                	mov    %ecx,%eax
}
  8016b1:	c9                   	leaveq 
  8016b2:	c3                   	retq   

00000000008016b3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016b3:	55                   	push   %rbp
  8016b4:	48 89 e5             	mov    %rsp,%rbp
  8016b7:	48 83 ec 10          	sub    $0x10,%rsp
  8016bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016bf:	89 f0                	mov    %esi,%eax
  8016c1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016c4:	eb 17                	jmp    8016dd <strchr+0x2a>
		if (*s == c)
  8016c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ca:	0f b6 00             	movzbl (%rax),%eax
  8016cd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016d0:	75 06                	jne    8016d8 <strchr+0x25>
			return (char *) s;
  8016d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d6:	eb 15                	jmp    8016ed <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	84 c0                	test   %al,%al
  8016e6:	75 de                	jne    8016c6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ed:	c9                   	leaveq 
  8016ee:	c3                   	retq   

00000000008016ef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016ef:	55                   	push   %rbp
  8016f0:	48 89 e5             	mov    %rsp,%rbp
  8016f3:	48 83 ec 10          	sub    $0x10,%rsp
  8016f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016fb:	89 f0                	mov    %esi,%eax
  8016fd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801700:	eb 11                	jmp    801713 <strfind+0x24>
		if (*s == c)
  801702:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801706:	0f b6 00             	movzbl (%rax),%eax
  801709:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80170c:	74 12                	je     801720 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80170e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801717:	0f b6 00             	movzbl (%rax),%eax
  80171a:	84 c0                	test   %al,%al
  80171c:	75 e4                	jne    801702 <strfind+0x13>
  80171e:	eb 01                	jmp    801721 <strfind+0x32>
		if (*s == c)
			break;
  801720:	90                   	nop
	return (char *) s;
  801721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801725:	c9                   	leaveq 
  801726:	c3                   	retq   

0000000000801727 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801727:	55                   	push   %rbp
  801728:	48 89 e5             	mov    %rsp,%rbp
  80172b:	48 83 ec 18          	sub    $0x18,%rsp
  80172f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801733:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801736:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80173a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80173f:	75 06                	jne    801747 <memset+0x20>
		return v;
  801741:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801745:	eb 69                	jmp    8017b0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801747:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174b:	83 e0 03             	and    $0x3,%eax
  80174e:	48 85 c0             	test   %rax,%rax
  801751:	75 48                	jne    80179b <memset+0x74>
  801753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801757:	83 e0 03             	and    $0x3,%eax
  80175a:	48 85 c0             	test   %rax,%rax
  80175d:	75 3c                	jne    80179b <memset+0x74>
		c &= 0xFF;
  80175f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801766:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801769:	89 c2                	mov    %eax,%edx
  80176b:	c1 e2 18             	shl    $0x18,%edx
  80176e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801771:	c1 e0 10             	shl    $0x10,%eax
  801774:	09 c2                	or     %eax,%edx
  801776:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801779:	c1 e0 08             	shl    $0x8,%eax
  80177c:	09 d0                	or     %edx,%eax
  80177e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801785:	48 89 c1             	mov    %rax,%rcx
  801788:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80178c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801790:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801793:	48 89 d7             	mov    %rdx,%rdi
  801796:	fc                   	cld    
  801797:	f3 ab                	rep stos %eax,%es:(%rdi)
  801799:	eb 11                	jmp    8017ac <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80179b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80179f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017a6:	48 89 d7             	mov    %rdx,%rdi
  8017a9:	fc                   	cld    
  8017aa:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8017ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017b0:	c9                   	leaveq 
  8017b1:	c3                   	retq   

00000000008017b2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017b2:	55                   	push   %rbp
  8017b3:	48 89 e5             	mov    %rsp,%rbp
  8017b6:	48 83 ec 28          	sub    $0x28,%rsp
  8017ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8017c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017da:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017de:	0f 83 88 00 00 00    	jae    80186c <memmove+0xba>
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017ec:	48 01 d0             	add    %rdx,%rax
  8017ef:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017f3:	76 77                	jbe    80186c <memmove+0xba>
		s += n;
  8017f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801801:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801805:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801809:	83 e0 03             	and    $0x3,%eax
  80180c:	48 85 c0             	test   %rax,%rax
  80180f:	75 3b                	jne    80184c <memmove+0x9a>
  801811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801815:	83 e0 03             	and    $0x3,%eax
  801818:	48 85 c0             	test   %rax,%rax
  80181b:	75 2f                	jne    80184c <memmove+0x9a>
  80181d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801821:	83 e0 03             	and    $0x3,%eax
  801824:	48 85 c0             	test   %rax,%rax
  801827:	75 23                	jne    80184c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801829:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182d:	48 83 e8 04          	sub    $0x4,%rax
  801831:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801835:	48 83 ea 04          	sub    $0x4,%rdx
  801839:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80183d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801841:	48 89 c7             	mov    %rax,%rdi
  801844:	48 89 d6             	mov    %rdx,%rsi
  801847:	fd                   	std    
  801848:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80184a:	eb 1d                	jmp    801869 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80184c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801850:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801858:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80185c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801860:	48 89 d7             	mov    %rdx,%rdi
  801863:	48 89 c1             	mov    %rax,%rcx
  801866:	fd                   	std    
  801867:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801869:	fc                   	cld    
  80186a:	eb 57                	jmp    8018c3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80186c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801870:	83 e0 03             	and    $0x3,%eax
  801873:	48 85 c0             	test   %rax,%rax
  801876:	75 36                	jne    8018ae <memmove+0xfc>
  801878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187c:	83 e0 03             	and    $0x3,%eax
  80187f:	48 85 c0             	test   %rax,%rax
  801882:	75 2a                	jne    8018ae <memmove+0xfc>
  801884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801888:	83 e0 03             	and    $0x3,%eax
  80188b:	48 85 c0             	test   %rax,%rax
  80188e:	75 1e                	jne    8018ae <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801894:	48 89 c1             	mov    %rax,%rcx
  801897:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80189b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018a3:	48 89 c7             	mov    %rax,%rdi
  8018a6:	48 89 d6             	mov    %rdx,%rsi
  8018a9:	fc                   	cld    
  8018aa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018ac:	eb 15                	jmp    8018c3 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018ba:	48 89 c7             	mov    %rax,%rdi
  8018bd:	48 89 d6             	mov    %rdx,%rsi
  8018c0:	fc                   	cld    
  8018c1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8018c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018c7:	c9                   	leaveq 
  8018c8:	c3                   	retq   

00000000008018c9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018c9:	55                   	push   %rbp
  8018ca:	48 89 e5             	mov    %rsp,%rbp
  8018cd:	48 83 ec 18          	sub    $0x18,%rsp
  8018d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e9:	48 89 ce             	mov    %rcx,%rsi
  8018ec:	48 89 c7             	mov    %rax,%rdi
  8018ef:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	callq  *%rax
}
  8018fb:	c9                   	leaveq 
  8018fc:	c3                   	retq   

00000000008018fd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	48 83 ec 28          	sub    $0x28,%rsp
  801905:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801909:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80190d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801911:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801915:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801919:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80191d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801921:	eb 38                	jmp    80195b <memcmp+0x5e>
		if (*s1 != *s2)
  801923:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801927:	0f b6 10             	movzbl (%rax),%edx
  80192a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192e:	0f b6 00             	movzbl (%rax),%eax
  801931:	38 c2                	cmp    %al,%dl
  801933:	74 1c                	je     801951 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801935:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801939:	0f b6 00             	movzbl (%rax),%eax
  80193c:	0f b6 d0             	movzbl %al,%edx
  80193f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801943:	0f b6 00             	movzbl (%rax),%eax
  801946:	0f b6 c0             	movzbl %al,%eax
  801949:	89 d1                	mov    %edx,%ecx
  80194b:	29 c1                	sub    %eax,%ecx
  80194d:	89 c8                	mov    %ecx,%eax
  80194f:	eb 20                	jmp    801971 <memcmp+0x74>
		s1++, s2++;
  801951:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801956:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80195b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801960:	0f 95 c0             	setne  %al
  801963:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801968:	84 c0                	test   %al,%al
  80196a:	75 b7                	jne    801923 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80196c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801971:	c9                   	leaveq 
  801972:	c3                   	retq   

0000000000801973 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801973:	55                   	push   %rbp
  801974:	48 89 e5             	mov    %rsp,%rbp
  801977:	48 83 ec 28          	sub    $0x28,%rsp
  80197b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80197f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801982:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801986:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80198e:	48 01 d0             	add    %rdx,%rax
  801991:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801995:	eb 13                	jmp    8019aa <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199b:	0f b6 10             	movzbl (%rax),%edx
  80199e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019a1:	38 c2                	cmp    %al,%dl
  8019a3:	74 11                	je     8019b6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ae:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8019b2:	72 e3                	jb     801997 <memfind+0x24>
  8019b4:	eb 01                	jmp    8019b7 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019b6:	90                   	nop
	return (void *) s;
  8019b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 38          	sub    $0x38,%rsp
  8019c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019cd:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019d7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019de:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019df:	eb 05                	jmp    8019e6 <strtol+0x29>
		s++;
  8019e1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ea:	0f b6 00             	movzbl (%rax),%eax
  8019ed:	3c 20                	cmp    $0x20,%al
  8019ef:	74 f0                	je     8019e1 <strtol+0x24>
  8019f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f5:	0f b6 00             	movzbl (%rax),%eax
  8019f8:	3c 09                	cmp    $0x9,%al
  8019fa:	74 e5                	je     8019e1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a00:	0f b6 00             	movzbl (%rax),%eax
  801a03:	3c 2b                	cmp    $0x2b,%al
  801a05:	75 07                	jne    801a0e <strtol+0x51>
		s++;
  801a07:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a0c:	eb 17                	jmp    801a25 <strtol+0x68>
	else if (*s == '-')
  801a0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a12:	0f b6 00             	movzbl (%rax),%eax
  801a15:	3c 2d                	cmp    $0x2d,%al
  801a17:	75 0c                	jne    801a25 <strtol+0x68>
		s++, neg = 1;
  801a19:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a25:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a29:	74 06                	je     801a31 <strtol+0x74>
  801a2b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a2f:	75 28                	jne    801a59 <strtol+0x9c>
  801a31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a35:	0f b6 00             	movzbl (%rax),%eax
  801a38:	3c 30                	cmp    $0x30,%al
  801a3a:	75 1d                	jne    801a59 <strtol+0x9c>
  801a3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a40:	48 83 c0 01          	add    $0x1,%rax
  801a44:	0f b6 00             	movzbl (%rax),%eax
  801a47:	3c 78                	cmp    $0x78,%al
  801a49:	75 0e                	jne    801a59 <strtol+0x9c>
		s += 2, base = 16;
  801a4b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a50:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a57:	eb 2c                	jmp    801a85 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a59:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a5d:	75 19                	jne    801a78 <strtol+0xbb>
  801a5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a63:	0f b6 00             	movzbl (%rax),%eax
  801a66:	3c 30                	cmp    $0x30,%al
  801a68:	75 0e                	jne    801a78 <strtol+0xbb>
		s++, base = 8;
  801a6a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a6f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a76:	eb 0d                	jmp    801a85 <strtol+0xc8>
	else if (base == 0)
  801a78:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a7c:	75 07                	jne    801a85 <strtol+0xc8>
		base = 10;
  801a7e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a89:	0f b6 00             	movzbl (%rax),%eax
  801a8c:	3c 2f                	cmp    $0x2f,%al
  801a8e:	7e 1d                	jle    801aad <strtol+0xf0>
  801a90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a94:	0f b6 00             	movzbl (%rax),%eax
  801a97:	3c 39                	cmp    $0x39,%al
  801a99:	7f 12                	jg     801aad <strtol+0xf0>
			dig = *s - '0';
  801a9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9f:	0f b6 00             	movzbl (%rax),%eax
  801aa2:	0f be c0             	movsbl %al,%eax
  801aa5:	83 e8 30             	sub    $0x30,%eax
  801aa8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801aab:	eb 4e                	jmp    801afb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801aad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab1:	0f b6 00             	movzbl (%rax),%eax
  801ab4:	3c 60                	cmp    $0x60,%al
  801ab6:	7e 1d                	jle    801ad5 <strtol+0x118>
  801ab8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abc:	0f b6 00             	movzbl (%rax),%eax
  801abf:	3c 7a                	cmp    $0x7a,%al
  801ac1:	7f 12                	jg     801ad5 <strtol+0x118>
			dig = *s - 'a' + 10;
  801ac3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac7:	0f b6 00             	movzbl (%rax),%eax
  801aca:	0f be c0             	movsbl %al,%eax
  801acd:	83 e8 57             	sub    $0x57,%eax
  801ad0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ad3:	eb 26                	jmp    801afb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801ad5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad9:	0f b6 00             	movzbl (%rax),%eax
  801adc:	3c 40                	cmp    $0x40,%al
  801ade:	7e 47                	jle    801b27 <strtol+0x16a>
  801ae0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae4:	0f b6 00             	movzbl (%rax),%eax
  801ae7:	3c 5a                	cmp    $0x5a,%al
  801ae9:	7f 3c                	jg     801b27 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801aeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aef:	0f b6 00             	movzbl (%rax),%eax
  801af2:	0f be c0             	movsbl %al,%eax
  801af5:	83 e8 37             	sub    $0x37,%eax
  801af8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801afb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801afe:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b01:	7d 23                	jge    801b26 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801b03:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b08:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b0b:	48 98                	cltq   
  801b0d:	48 89 c2             	mov    %rax,%rdx
  801b10:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801b15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 01 d0             	add    %rdx,%rax
  801b1d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801b21:	e9 5f ff ff ff       	jmpq   801a85 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b26:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b27:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b2c:	74 0b                	je     801b39 <strtol+0x17c>
		*endptr = (char *) s;
  801b2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b32:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b36:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b3d:	74 09                	je     801b48 <strtol+0x18b>
  801b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b43:	48 f7 d8             	neg    %rax
  801b46:	eb 04                	jmp    801b4c <strtol+0x18f>
  801b48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b4c:	c9                   	leaveq 
  801b4d:	c3                   	retq   

0000000000801b4e <strstr>:

char * strstr(const char *in, const char *str)
{
  801b4e:	55                   	push   %rbp
  801b4f:	48 89 e5             	mov    %rsp,%rbp
  801b52:	48 83 ec 30          	sub    $0x30,%rsp
  801b56:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b5a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801b5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b62:	0f b6 00             	movzbl (%rax),%eax
  801b65:	88 45 ff             	mov    %al,-0x1(%rbp)
  801b68:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801b6d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b71:	75 06                	jne    801b79 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801b73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b77:	eb 68                	jmp    801be1 <strstr+0x93>

    len = strlen(str);
  801b79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b7d:	48 89 c7             	mov    %rax,%rdi
  801b80:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	callq  *%rax
  801b8c:	48 98                	cltq   
  801b8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801b92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b96:	0f b6 00             	movzbl (%rax),%eax
  801b99:	88 45 ef             	mov    %al,-0x11(%rbp)
  801b9c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801ba1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ba5:	75 07                	jne    801bae <strstr+0x60>
                return (char *) 0;
  801ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bac:	eb 33                	jmp    801be1 <strstr+0x93>
        } while (sc != c);
  801bae:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801bb2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801bb5:	75 db                	jne    801b92 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801bb7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801bbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc3:	48 89 ce             	mov    %rcx,%rsi
  801bc6:	48 89 c7             	mov    %rax,%rdi
  801bc9:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	callq  *%rax
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	75 b9                	jne    801b92 <strstr+0x44>

    return (char *) (in - 1);
  801bd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bdd:	48 83 e8 01          	sub    $0x1,%rax
}
  801be1:	c9                   	leaveq 
  801be2:	c3                   	retq   
	...

0000000000801be4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801be4:	55                   	push   %rbp
  801be5:	48 89 e5             	mov    %rsp,%rbp
  801be8:	53                   	push   %rbx
  801be9:	48 83 ec 58          	sub    $0x58,%rsp
  801bed:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bf0:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801bf3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bf7:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bfb:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bff:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c03:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c06:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801c09:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c0d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801c11:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801c15:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801c19:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801c1d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801c20:	4c 89 c3             	mov    %r8,%rbx
  801c23:	cd 30                	int    $0x30
  801c25:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801c29:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801c2d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801c31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c35:	74 3e                	je     801c75 <syscall+0x91>
  801c37:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c3c:	7e 37                	jle    801c75 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c45:	49 89 d0             	mov    %rdx,%r8
  801c48:	89 c1                	mov    %eax,%ecx
  801c4a:	48 ba f3 46 80 00 00 	movabs $0x8046f3,%rdx
  801c51:	00 00 00 
  801c54:	be 23 00 00 00       	mov    $0x23,%esi
  801c59:	48 bf 10 47 80 00 00 	movabs $0x804710,%rdi
  801c60:	00 00 00 
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
  801c68:	49 b9 38 05 80 00 00 	movabs $0x800538,%r9
  801c6f:	00 00 00 
  801c72:	41 ff d1             	callq  *%r9

	return ret;
  801c75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c79:	48 83 c4 58          	add    $0x58,%rsp
  801c7d:	5b                   	pop    %rbx
  801c7e:	5d                   	pop    %rbp
  801c7f:	c3                   	retq   

0000000000801c80 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	48 83 ec 20          	sub    $0x20,%rsp
  801c88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9f:	00 
  801ca0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cac:	48 89 d1             	mov    %rdx,%rcx
  801caf:	48 89 c2             	mov    %rax,%rdx
  801cb2:	be 00 00 00 00       	mov    $0x0,%esi
  801cb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbc:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
}
  801cc8:	c9                   	leaveq 
  801cc9:	c3                   	retq   

0000000000801cca <sys_cgetc>:

int
sys_cgetc(void)
{
  801cca:	55                   	push   %rbp
  801ccb:	48 89 e5             	mov    %rsp,%rbp
  801cce:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801cd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd9:	00 
  801cda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf0:	be 00 00 00 00       	mov    $0x0,%esi
  801cf5:	bf 01 00 00 00       	mov    $0x1,%edi
  801cfa:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	callq  *%rax
}
  801d06:	c9                   	leaveq 
  801d07:	c3                   	retq   

0000000000801d08 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	48 83 ec 20          	sub    $0x20,%rsp
  801d10:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d16:	48 98                	cltq   
  801d18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d1f:	00 
  801d20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d31:	48 89 c2             	mov    %rax,%rdx
  801d34:	be 01 00 00 00       	mov    $0x1,%esi
  801d39:	bf 03 00 00 00       	mov    $0x3,%edi
  801d3e:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801d45:	00 00 00 
  801d48:	ff d0                	callq  *%rax
}
  801d4a:	c9                   	leaveq 
  801d4b:	c3                   	retq   

0000000000801d4c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d4c:	55                   	push   %rbp
  801d4d:	48 89 e5             	mov    %rsp,%rbp
  801d50:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5b:	00 
  801d5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d68:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d72:	be 00 00 00 00       	mov    $0x0,%esi
  801d77:	bf 02 00 00 00       	mov    $0x2,%edi
  801d7c:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801d83:	00 00 00 
  801d86:	ff d0                	callq  *%rax
}
  801d88:	c9                   	leaveq 
  801d89:	c3                   	retq   

0000000000801d8a <sys_yield>:

void
sys_yield(void)
{
  801d8a:	55                   	push   %rbp
  801d8b:	48 89 e5             	mov    %rsp,%rbp
  801d8e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d99:	00 
  801d9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801da6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dab:	ba 00 00 00 00       	mov    $0x0,%edx
  801db0:	be 00 00 00 00       	mov    $0x0,%esi
  801db5:	bf 0b 00 00 00       	mov    $0xb,%edi
  801dba:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
}
  801dc6:	c9                   	leaveq 
  801dc7:	c3                   	retq   

0000000000801dc8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801dc8:	55                   	push   %rbp
  801dc9:	48 89 e5             	mov    %rsp,%rbp
  801dcc:	48 83 ec 20          	sub    $0x20,%rsp
  801dd0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dd7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801dda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ddd:	48 63 c8             	movslq %eax,%rcx
  801de0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de7:	48 98                	cltq   
  801de9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df0:	00 
  801df1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df7:	49 89 c8             	mov    %rcx,%r8
  801dfa:	48 89 d1             	mov    %rdx,%rcx
  801dfd:	48 89 c2             	mov    %rax,%rdx
  801e00:	be 01 00 00 00       	mov    $0x1,%esi
  801e05:	bf 04 00 00 00       	mov    $0x4,%edi
  801e0a:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801e11:	00 00 00 
  801e14:	ff d0                	callq  *%rax
}
  801e16:	c9                   	leaveq 
  801e17:	c3                   	retq   

0000000000801e18 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801e18:	55                   	push   %rbp
  801e19:	48 89 e5             	mov    %rsp,%rbp
  801e1c:	48 83 ec 30          	sub    $0x30,%rsp
  801e20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e27:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e2a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e2e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801e32:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e35:	48 63 c8             	movslq %eax,%rcx
  801e38:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e3f:	48 63 f0             	movslq %eax,%rsi
  801e42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e49:	48 98                	cltq   
  801e4b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e4f:	49 89 f9             	mov    %rdi,%r9
  801e52:	49 89 f0             	mov    %rsi,%r8
  801e55:	48 89 d1             	mov    %rdx,%rcx
  801e58:	48 89 c2             	mov    %rax,%rdx
  801e5b:	be 01 00 00 00       	mov    $0x1,%esi
  801e60:	bf 05 00 00 00       	mov    $0x5,%edi
  801e65:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801e6c:	00 00 00 
  801e6f:	ff d0                	callq  *%rax
}
  801e71:	c9                   	leaveq 
  801e72:	c3                   	retq   

0000000000801e73 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e73:	55                   	push   %rbp
  801e74:	48 89 e5             	mov    %rsp,%rbp
  801e77:	48 83 ec 20          	sub    $0x20,%rsp
  801e7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e89:	48 98                	cltq   
  801e8b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e92:	00 
  801e93:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e99:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e9f:	48 89 d1             	mov    %rdx,%rcx
  801ea2:	48 89 c2             	mov    %rax,%rdx
  801ea5:	be 01 00 00 00       	mov    $0x1,%esi
  801eaa:	bf 06 00 00 00       	mov    $0x6,%edi
  801eaf:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801eb6:	00 00 00 
  801eb9:	ff d0                	callq  *%rax
}
  801ebb:	c9                   	leaveq 
  801ebc:	c3                   	retq   

0000000000801ebd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ebd:	55                   	push   %rbp
  801ebe:	48 89 e5             	mov    %rsp,%rbp
  801ec1:	48 83 ec 20          	sub    $0x20,%rsp
  801ec5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ecb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ece:	48 63 d0             	movslq %eax,%rdx
  801ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed4:	48 98                	cltq   
  801ed6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801edd:	00 
  801ede:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eea:	48 89 d1             	mov    %rdx,%rcx
  801eed:	48 89 c2             	mov    %rax,%rdx
  801ef0:	be 01 00 00 00       	mov    $0x1,%esi
  801ef5:	bf 08 00 00 00       	mov    $0x8,%edi
  801efa:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
}
  801f06:	c9                   	leaveq 
  801f07:	c3                   	retq   

0000000000801f08 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
  801f0c:	48 83 ec 20          	sub    $0x20,%rsp
  801f10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801f17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1e:	48 98                	cltq   
  801f20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f27:	00 
  801f28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f34:	48 89 d1             	mov    %rdx,%rcx
  801f37:	48 89 c2             	mov    %rax,%rdx
  801f3a:	be 01 00 00 00       	mov    $0x1,%esi
  801f3f:	bf 09 00 00 00       	mov    $0x9,%edi
  801f44:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801f4b:	00 00 00 
  801f4e:	ff d0                	callq  *%rax
}
  801f50:	c9                   	leaveq 
  801f51:	c3                   	retq   

0000000000801f52 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f52:	55                   	push   %rbp
  801f53:	48 89 e5             	mov    %rsp,%rbp
  801f56:	48 83 ec 20          	sub    $0x20,%rsp
  801f5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f68:	48 98                	cltq   
  801f6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f71:	00 
  801f72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7e:	48 89 d1             	mov    %rdx,%rcx
  801f81:	48 89 c2             	mov    %rax,%rdx
  801f84:	be 01 00 00 00       	mov    $0x1,%esi
  801f89:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f8e:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	callq  *%rax
}
  801f9a:	c9                   	leaveq 
  801f9b:	c3                   	retq   

0000000000801f9c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f9c:	55                   	push   %rbp
  801f9d:	48 89 e5             	mov    %rsp,%rbp
  801fa0:	48 83 ec 30          	sub    $0x30,%rsp
  801fa4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fa7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801faf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801fb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fb5:	48 63 f0             	movslq %eax,%rsi
  801fb8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fbf:	48 98                	cltq   
  801fc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fcc:	00 
  801fcd:	49 89 f1             	mov    %rsi,%r9
  801fd0:	49 89 c8             	mov    %rcx,%r8
  801fd3:	48 89 d1             	mov    %rdx,%rcx
  801fd6:	48 89 c2             	mov    %rax,%rdx
  801fd9:	be 00 00 00 00       	mov    $0x0,%esi
  801fde:	bf 0c 00 00 00       	mov    $0xc,%edi
  801fe3:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801fea:	00 00 00 
  801fed:	ff d0                	callq  *%rax
}
  801fef:	c9                   	leaveq 
  801ff0:	c3                   	retq   

0000000000801ff1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ff1:	55                   	push   %rbp
  801ff2:	48 89 e5             	mov    %rsp,%rbp
  801ff5:	48 83 ec 20          	sub    $0x20,%rsp
  801ff9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ffd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802001:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802008:	00 
  802009:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80200f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802015:	b9 00 00 00 00       	mov    $0x0,%ecx
  80201a:	48 89 c2             	mov    %rax,%rdx
  80201d:	be 01 00 00 00       	mov    $0x1,%esi
  802022:	bf 0d 00 00 00       	mov    $0xd,%edi
  802027:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  80202e:	00 00 00 
  802031:	ff d0                	callq  *%rax
}
  802033:	c9                   	leaveq 
  802034:	c3                   	retq   

0000000000802035 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802035:	55                   	push   %rbp
  802036:	48 89 e5             	mov    %rsp,%rbp
  802039:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80203d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802044:	00 
  802045:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80204b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802051:	b9 00 00 00 00       	mov    $0x0,%ecx
  802056:	ba 00 00 00 00       	mov    $0x0,%edx
  80205b:	be 00 00 00 00       	mov    $0x0,%esi
  802060:	bf 0e 00 00 00       	mov    $0xe,%edi
  802065:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  80206c:	00 00 00 
  80206f:	ff d0                	callq  *%rax
}
  802071:	c9                   	leaveq 
  802072:	c3                   	retq   

0000000000802073 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  802073:	55                   	push   %rbp
  802074:	48 89 e5             	mov    %rsp,%rbp
  802077:	48 83 ec 20          	sub    $0x20,%rsp
  80207b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80207f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802083:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802087:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80208b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802092:	00 
  802093:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802099:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80209f:	48 89 d1             	mov    %rdx,%rcx
  8020a2:	48 89 c2             	mov    %rax,%rdx
  8020a5:	be 00 00 00 00       	mov    $0x0,%esi
  8020aa:	bf 0f 00 00 00       	mov    $0xf,%edi
  8020af:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  8020b6:	00 00 00 
  8020b9:	ff d0                	callq  *%rax
}
  8020bb:	c9                   	leaveq 
  8020bc:	c3                   	retq   

00000000008020bd <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  8020bd:	55                   	push   %rbp
  8020be:	48 89 e5             	mov    %rsp,%rbp
  8020c1:	48 83 ec 20          	sub    $0x20,%rsp
  8020c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8020cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020dc:	00 
  8020dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020e9:	48 89 d1             	mov    %rdx,%rcx
  8020ec:	48 89 c2             	mov    %rax,%rdx
  8020ef:	be 00 00 00 00       	mov    $0x0,%esi
  8020f4:	bf 10 00 00 00       	mov    $0x10,%edi
  8020f9:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
}
  802105:	c9                   	leaveq 
  802106:	c3                   	retq   
	...

0000000000802108 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802108:	55                   	push   %rbp
  802109:	48 89 e5             	mov    %rsp,%rbp
  80210c:	48 83 ec 08          	sub    $0x8,%rsp
  802110:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802114:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802118:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80211f:	ff ff ff 
  802122:	48 01 d0             	add    %rdx,%rax
  802125:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 08          	sub    $0x8,%rsp
  802133:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213b:	48 89 c7             	mov    %rax,%rdi
  80213e:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  802145:	00 00 00 
  802148:	ff d0                	callq  *%rax
  80214a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802150:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802154:	c9                   	leaveq 
  802155:	c3                   	retq   

0000000000802156 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802156:	55                   	push   %rbp
  802157:	48 89 e5             	mov    %rsp,%rbp
  80215a:	48 83 ec 18          	sub    $0x18,%rsp
  80215e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802169:	eb 6b                	jmp    8021d6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80216b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216e:	48 98                	cltq   
  802170:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802176:	48 c1 e0 0c          	shl    $0xc,%rax
  80217a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80217e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802182:	48 89 c2             	mov    %rax,%rdx
  802185:	48 c1 ea 15          	shr    $0x15,%rdx
  802189:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802190:	01 00 00 
  802193:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802197:	83 e0 01             	and    $0x1,%eax
  80219a:	48 85 c0             	test   %rax,%rax
  80219d:	74 21                	je     8021c0 <fd_alloc+0x6a>
  80219f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a3:	48 89 c2             	mov    %rax,%rdx
  8021a6:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b1:	01 00 00 
  8021b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b8:	83 e0 01             	and    $0x1,%eax
  8021bb:	48 85 c0             	test   %rax,%rax
  8021be:	75 12                	jne    8021d2 <fd_alloc+0x7c>
			*fd_store = fd;
  8021c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d0:	eb 1a                	jmp    8021ec <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021d6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021da:	7e 8f                	jle    80216b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021e7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021ec:	c9                   	leaveq 
  8021ed:	c3                   	retq   

00000000008021ee <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021ee:	55                   	push   %rbp
  8021ef:	48 89 e5             	mov    %rsp,%rbp
  8021f2:	48 83 ec 20          	sub    $0x20,%rsp
  8021f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802201:	78 06                	js     802209 <fd_lookup+0x1b>
  802203:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802207:	7e 07                	jle    802210 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802209:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80220e:	eb 6c                	jmp    80227c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802210:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802213:	48 98                	cltq   
  802215:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80221b:	48 c1 e0 0c          	shl    $0xc,%rax
  80221f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802227:	48 89 c2             	mov    %rax,%rdx
  80222a:	48 c1 ea 15          	shr    $0x15,%rdx
  80222e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802235:	01 00 00 
  802238:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223c:	83 e0 01             	and    $0x1,%eax
  80223f:	48 85 c0             	test   %rax,%rax
  802242:	74 21                	je     802265 <fd_lookup+0x77>
  802244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802248:	48 89 c2             	mov    %rax,%rdx
  80224b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80224f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802256:	01 00 00 
  802259:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80225d:	83 e0 01             	and    $0x1,%eax
  802260:	48 85 c0             	test   %rax,%rax
  802263:	75 07                	jne    80226c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226a:	eb 10                	jmp    80227c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80226c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802270:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802274:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227c:	c9                   	leaveq 
  80227d:	c3                   	retq   

000000000080227e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80227e:	55                   	push   %rbp
  80227f:	48 89 e5             	mov    %rsp,%rbp
  802282:	48 83 ec 30          	sub    $0x30,%rsp
  802286:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80228a:	89 f0                	mov    %esi,%eax
  80228c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80228f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802293:	48 89 c7             	mov    %rax,%rdi
  802296:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	callq  *%rax
  8022a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022a6:	48 89 d6             	mov    %rdx,%rsi
  8022a9:	89 c7                	mov    %eax,%edi
  8022ab:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  8022b2:	00 00 00 
  8022b5:	ff d0                	callq  *%rax
  8022b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022be:	78 0a                	js     8022ca <fd_close+0x4c>
	    || fd != fd2)
  8022c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8022c8:	74 12                	je     8022dc <fd_close+0x5e>
		return (must_exist ? r : 0);
  8022ca:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8022ce:	74 05                	je     8022d5 <fd_close+0x57>
  8022d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d3:	eb 05                	jmp    8022da <fd_close+0x5c>
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	eb 69                	jmp    802345 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022e0:	8b 00                	mov    (%rax),%eax
  8022e2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022e6:	48 89 d6             	mov    %rdx,%rsi
  8022e9:	89 c7                	mov    %eax,%edi
  8022eb:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  8022f2:	00 00 00 
  8022f5:	ff d0                	callq  *%rax
  8022f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fe:	78 2a                	js     80232a <fd_close+0xac>
		if (dev->dev_close)
  802300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802304:	48 8b 40 20          	mov    0x20(%rax),%rax
  802308:	48 85 c0             	test   %rax,%rax
  80230b:	74 16                	je     802323 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80230d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802311:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802315:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802319:	48 89 c7             	mov    %rax,%rdi
  80231c:	ff d2                	callq  *%rdx
  80231e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802321:	eb 07                	jmp    80232a <fd_close+0xac>
		else
			r = 0;
  802323:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80232a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232e:	48 89 c6             	mov    %rax,%rsi
  802331:	bf 00 00 00 00       	mov    $0x0,%edi
  802336:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  80233d:	00 00 00 
  802340:	ff d0                	callq  *%rax
	return r;
  802342:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802345:	c9                   	leaveq 
  802346:	c3                   	retq   

0000000000802347 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802347:	55                   	push   %rbp
  802348:	48 89 e5             	mov    %rsp,%rbp
  80234b:	48 83 ec 20          	sub    $0x20,%rsp
  80234f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802352:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80235d:	eb 41                	jmp    8023a0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80235f:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802366:	00 00 00 
  802369:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80236c:	48 63 d2             	movslq %edx,%rdx
  80236f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802373:	8b 00                	mov    (%rax),%eax
  802375:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802378:	75 22                	jne    80239c <dev_lookup+0x55>
			*dev = devtab[i];
  80237a:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802381:	00 00 00 
  802384:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802387:	48 63 d2             	movslq %edx,%rdx
  80238a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80238e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802392:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
  80239a:	eb 60                	jmp    8023fc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80239c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023a0:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8023a7:	00 00 00 
  8023aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023ad:	48 63 d2             	movslq %edx,%rdx
  8023b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b4:	48 85 c0             	test   %rax,%rax
  8023b7:	75 a6                	jne    80235f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8023b9:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  8023c0:	00 00 00 
  8023c3:	48 8b 00             	mov    (%rax),%rax
  8023c6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023cc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023cf:	89 c6                	mov    %eax,%esi
  8023d1:	48 bf 20 47 80 00 00 	movabs $0x804720,%rdi
  8023d8:	00 00 00 
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	48 b9 73 07 80 00 00 	movabs $0x800773,%rcx
  8023e7:	00 00 00 
  8023ea:	ff d1                	callq  *%rcx
	*dev = 0;
  8023ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023fc:	c9                   	leaveq 
  8023fd:	c3                   	retq   

00000000008023fe <close>:

int
close(int fdnum)
{
  8023fe:	55                   	push   %rbp
  8023ff:	48 89 e5             	mov    %rsp,%rbp
  802402:	48 83 ec 20          	sub    $0x20,%rsp
  802406:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802409:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80240d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802410:	48 89 d6             	mov    %rdx,%rsi
  802413:	89 c7                	mov    %eax,%edi
  802415:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802424:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802428:	79 05                	jns    80242f <close+0x31>
		return r;
  80242a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242d:	eb 18                	jmp    802447 <close+0x49>
	else
		return fd_close(fd, 1);
  80242f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802433:	be 01 00 00 00       	mov    $0x1,%esi
  802438:	48 89 c7             	mov    %rax,%rdi
  80243b:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax
}
  802447:	c9                   	leaveq 
  802448:	c3                   	retq   

0000000000802449 <close_all>:

void
close_all(void)
{
  802449:	55                   	push   %rbp
  80244a:	48 89 e5             	mov    %rsp,%rbp
  80244d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802451:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802458:	eb 15                	jmp    80246f <close_all+0x26>
		close(i);
  80245a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245d:	89 c7                	mov    %eax,%edi
  80245f:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  802466:	00 00 00 
  802469:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80246b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80246f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802473:	7e e5                	jle    80245a <close_all+0x11>
		close(i);
}
  802475:	c9                   	leaveq 
  802476:	c3                   	retq   

0000000000802477 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802477:	55                   	push   %rbp
  802478:	48 89 e5             	mov    %rsp,%rbp
  80247b:	48 83 ec 40          	sub    $0x40,%rsp
  80247f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802482:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802485:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802489:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80248c:	48 89 d6             	mov    %rdx,%rsi
  80248f:	89 c7                	mov    %eax,%edi
  802491:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
  80249d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a4:	79 08                	jns    8024ae <dup+0x37>
		return r;
  8024a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a9:	e9 70 01 00 00       	jmpq   80261e <dup+0x1a7>
	close(newfdnum);
  8024ae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024b1:	89 c7                	mov    %eax,%edi
  8024b3:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  8024ba:	00 00 00 
  8024bd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8024bf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024c2:	48 98                	cltq   
  8024c4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024ca:	48 c1 e0 0c          	shl    $0xc,%rax
  8024ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8024d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d6:	48 89 c7             	mov    %rax,%rdi
  8024d9:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	callq  *%rax
  8024e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ed:	48 89 c7             	mov    %rax,%rdi
  8024f0:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	callq  *%rax
  8024fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802500:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802504:	48 89 c2             	mov    %rax,%rdx
  802507:	48 c1 ea 15          	shr    $0x15,%rdx
  80250b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802512:	01 00 00 
  802515:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802519:	83 e0 01             	and    $0x1,%eax
  80251c:	84 c0                	test   %al,%al
  80251e:	74 71                	je     802591 <dup+0x11a>
  802520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802524:	48 89 c2             	mov    %rax,%rdx
  802527:	48 c1 ea 0c          	shr    $0xc,%rdx
  80252b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802532:	01 00 00 
  802535:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802539:	83 e0 01             	and    $0x1,%eax
  80253c:	84 c0                	test   %al,%al
  80253e:	74 51                	je     802591 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802544:	48 89 c2             	mov    %rax,%rdx
  802547:	48 c1 ea 0c          	shr    $0xc,%rdx
  80254b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802552:	01 00 00 
  802555:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802559:	89 c1                	mov    %eax,%ecx
  80255b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802561:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802569:	41 89 c8             	mov    %ecx,%r8d
  80256c:	48 89 d1             	mov    %rdx,%rcx
  80256f:	ba 00 00 00 00       	mov    $0x0,%edx
  802574:	48 89 c6             	mov    %rax,%rsi
  802577:	bf 00 00 00 00       	mov    $0x0,%edi
  80257c:	48 b8 18 1e 80 00 00 	movabs $0x801e18,%rax
  802583:	00 00 00 
  802586:	ff d0                	callq  *%rax
  802588:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258f:	78 56                	js     8025e7 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802591:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802595:	48 89 c2             	mov    %rax,%rdx
  802598:	48 c1 ea 0c          	shr    $0xc,%rdx
  80259c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025a3:	01 00 00 
  8025a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025aa:	89 c1                	mov    %eax,%ecx
  8025ac:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8025b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ba:	41 89 c8             	mov    %ecx,%r8d
  8025bd:	48 89 d1             	mov    %rdx,%rcx
  8025c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c5:	48 89 c6             	mov    %rax,%rsi
  8025c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cd:	48 b8 18 1e 80 00 00 	movabs $0x801e18,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
  8025d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e0:	78 08                	js     8025ea <dup+0x173>
		goto err;

	return newfdnum;
  8025e2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025e5:	eb 37                	jmp    80261e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8025e7:	90                   	nop
  8025e8:	eb 01                	jmp    8025eb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8025ea:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8025eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ef:	48 89 c6             	mov    %rax,%rsi
  8025f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f7:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  8025fe:	00 00 00 
  802601:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802603:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802607:	48 89 c6             	mov    %rax,%rsi
  80260a:	bf 00 00 00 00       	mov    $0x0,%edi
  80260f:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
	return r;
  80261b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80261e:	c9                   	leaveq 
  80261f:	c3                   	retq   

0000000000802620 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802620:	55                   	push   %rbp
  802621:	48 89 e5             	mov    %rsp,%rbp
  802624:	48 83 ec 40          	sub    $0x40,%rsp
  802628:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80262b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80262f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802633:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802637:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80263a:	48 89 d6             	mov    %rdx,%rsi
  80263d:	89 c7                	mov    %eax,%edi
  80263f:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  802646:	00 00 00 
  802649:	ff d0                	callq  *%rax
  80264b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802652:	78 24                	js     802678 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802658:	8b 00                	mov    (%rax),%eax
  80265a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80265e:	48 89 d6             	mov    %rdx,%rsi
  802661:	89 c7                	mov    %eax,%edi
  802663:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  80266a:	00 00 00 
  80266d:	ff d0                	callq  *%rax
  80266f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802672:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802676:	79 05                	jns    80267d <read+0x5d>
		return r;
  802678:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267b:	eb 7a                	jmp    8026f7 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80267d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802681:	8b 40 08             	mov    0x8(%rax),%eax
  802684:	83 e0 03             	and    $0x3,%eax
  802687:	83 f8 01             	cmp    $0x1,%eax
  80268a:	75 3a                	jne    8026c6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80268c:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  802693:	00 00 00 
  802696:	48 8b 00             	mov    (%rax),%rax
  802699:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80269f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026a2:	89 c6                	mov    %eax,%esi
  8026a4:	48 bf 3f 47 80 00 00 	movabs $0x80473f,%rdi
  8026ab:	00 00 00 
  8026ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b3:	48 b9 73 07 80 00 00 	movabs $0x800773,%rcx
  8026ba:	00 00 00 
  8026bd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026c4:	eb 31                	jmp    8026f7 <read+0xd7>
	}
	if (!dev->dev_read)
  8026c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ca:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026ce:	48 85 c0             	test   %rax,%rax
  8026d1:	75 07                	jne    8026da <read+0xba>
		return -E_NOT_SUPP;
  8026d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026d8:	eb 1d                	jmp    8026f7 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8026da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026de:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8026e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026ea:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026ee:	48 89 ce             	mov    %rcx,%rsi
  8026f1:	48 89 c7             	mov    %rax,%rdi
  8026f4:	41 ff d0             	callq  *%r8
}
  8026f7:	c9                   	leaveq 
  8026f8:	c3                   	retq   

00000000008026f9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026f9:	55                   	push   %rbp
  8026fa:	48 89 e5             	mov    %rsp,%rbp
  8026fd:	48 83 ec 30          	sub    $0x30,%rsp
  802701:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802704:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802708:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80270c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802713:	eb 46                	jmp    80275b <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802718:	48 98                	cltq   
  80271a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80271e:	48 29 c2             	sub    %rax,%rdx
  802721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802724:	48 98                	cltq   
  802726:	48 89 c1             	mov    %rax,%rcx
  802729:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  80272d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802730:	48 89 ce             	mov    %rcx,%rsi
  802733:	89 c7                	mov    %eax,%edi
  802735:	48 b8 20 26 80 00 00 	movabs $0x802620,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
  802741:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802744:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802748:	79 05                	jns    80274f <readn+0x56>
			return m;
  80274a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80274d:	eb 1d                	jmp    80276c <readn+0x73>
		if (m == 0)
  80274f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802753:	74 13                	je     802768 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802755:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802758:	01 45 fc             	add    %eax,-0x4(%rbp)
  80275b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275e:	48 98                	cltq   
  802760:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802764:	72 af                	jb     802715 <readn+0x1c>
  802766:	eb 01                	jmp    802769 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802768:	90                   	nop
	}
	return tot;
  802769:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80276c:	c9                   	leaveq 
  80276d:	c3                   	retq   

000000000080276e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80276e:	55                   	push   %rbp
  80276f:	48 89 e5             	mov    %rsp,%rbp
  802772:	48 83 ec 40          	sub    $0x40,%rsp
  802776:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802779:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80277d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802781:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802785:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802788:	48 89 d6             	mov    %rdx,%rsi
  80278b:	89 c7                	mov    %eax,%edi
  80278d:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
  802799:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a0:	78 24                	js     8027c6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a6:	8b 00                	mov    (%rax),%eax
  8027a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ac:	48 89 d6             	mov    %rdx,%rsi
  8027af:	89 c7                	mov    %eax,%edi
  8027b1:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  8027b8:	00 00 00 
  8027bb:	ff d0                	callq  *%rax
  8027bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c4:	79 05                	jns    8027cb <write+0x5d>
		return r;
  8027c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c9:	eb 79                	jmp    802844 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cf:	8b 40 08             	mov    0x8(%rax),%eax
  8027d2:	83 e0 03             	and    $0x3,%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	75 3a                	jne    802813 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8027d9:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  8027e0:	00 00 00 
  8027e3:	48 8b 00             	mov    (%rax),%rax
  8027e6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027ec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027ef:	89 c6                	mov    %eax,%esi
  8027f1:	48 bf 5b 47 80 00 00 	movabs $0x80475b,%rdi
  8027f8:	00 00 00 
  8027fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802800:	48 b9 73 07 80 00 00 	movabs $0x800773,%rcx
  802807:	00 00 00 
  80280a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80280c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802811:	eb 31                	jmp    802844 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802817:	48 8b 40 18          	mov    0x18(%rax),%rax
  80281b:	48 85 c0             	test   %rax,%rax
  80281e:	75 07                	jne    802827 <write+0xb9>
		return -E_NOT_SUPP;
  802820:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802825:	eb 1d                	jmp    802844 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80282f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802833:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802837:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80283b:	48 89 ce             	mov    %rcx,%rsi
  80283e:	48 89 c7             	mov    %rax,%rdi
  802841:	41 ff d0             	callq  *%r8
}
  802844:	c9                   	leaveq 
  802845:	c3                   	retq   

0000000000802846 <seek>:

int
seek(int fdnum, off_t offset)
{
  802846:	55                   	push   %rbp
  802847:	48 89 e5             	mov    %rsp,%rbp
  80284a:	48 83 ec 18          	sub    $0x18,%rsp
  80284e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802851:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802854:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802858:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80285b:	48 89 d6             	mov    %rdx,%rsi
  80285e:	89 c7                	mov    %eax,%edi
  802860:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  802867:	00 00 00 
  80286a:	ff d0                	callq  *%rax
  80286c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802873:	79 05                	jns    80287a <seek+0x34>
		return r;
  802875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802878:	eb 0f                	jmp    802889 <seek+0x43>
	fd->fd_offset = offset;
  80287a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802881:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802884:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802889:	c9                   	leaveq 
  80288a:	c3                   	retq   

000000000080288b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80288b:	55                   	push   %rbp
  80288c:	48 89 e5             	mov    %rsp,%rbp
  80288f:	48 83 ec 30          	sub    $0x30,%rsp
  802893:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802896:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802899:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80289d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028a0:	48 89 d6             	mov    %rdx,%rsi
  8028a3:	89 c7                	mov    %eax,%edi
  8028a5:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  8028ac:	00 00 00 
  8028af:	ff d0                	callq  *%rax
  8028b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b8:	78 24                	js     8028de <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028be:	8b 00                	mov    (%rax),%eax
  8028c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028c4:	48 89 d6             	mov    %rdx,%rsi
  8028c7:	89 c7                	mov    %eax,%edi
  8028c9:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  8028d0:	00 00 00 
  8028d3:	ff d0                	callq  *%rax
  8028d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028dc:	79 05                	jns    8028e3 <ftruncate+0x58>
		return r;
  8028de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e1:	eb 72                	jmp    802955 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e7:	8b 40 08             	mov    0x8(%rax),%eax
  8028ea:	83 e0 03             	and    $0x3,%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	75 3a                	jne    80292b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028f1:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  8028f8:	00 00 00 
  8028fb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028fe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802904:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802907:	89 c6                	mov    %eax,%esi
  802909:	48 bf 78 47 80 00 00 	movabs $0x804778,%rdi
  802910:	00 00 00 
  802913:	b8 00 00 00 00       	mov    $0x0,%eax
  802918:	48 b9 73 07 80 00 00 	movabs $0x800773,%rcx
  80291f:	00 00 00 
  802922:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802924:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802929:	eb 2a                	jmp    802955 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80292b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802933:	48 85 c0             	test   %rax,%rax
  802936:	75 07                	jne    80293f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802938:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80293d:	eb 16                	jmp    802955 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80293f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802943:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80294e:	89 d6                	mov    %edx,%esi
  802950:	48 89 c7             	mov    %rax,%rdi
  802953:	ff d1                	callq  *%rcx
}
  802955:	c9                   	leaveq 
  802956:	c3                   	retq   

0000000000802957 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802957:	55                   	push   %rbp
  802958:	48 89 e5             	mov    %rsp,%rbp
  80295b:	48 83 ec 30          	sub    $0x30,%rsp
  80295f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802962:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802966:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80296a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80296d:	48 89 d6             	mov    %rdx,%rsi
  802970:	89 c7                	mov    %eax,%edi
  802972:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  802979:	00 00 00 
  80297c:	ff d0                	callq  *%rax
  80297e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802981:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802985:	78 24                	js     8029ab <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298b:	8b 00                	mov    (%rax),%eax
  80298d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802991:	48 89 d6             	mov    %rdx,%rsi
  802994:	89 c7                	mov    %eax,%edi
  802996:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  80299d:	00 00 00 
  8029a0:	ff d0                	callq  *%rax
  8029a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a9:	79 05                	jns    8029b0 <fstat+0x59>
		return r;
  8029ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ae:	eb 5e                	jmp    802a0e <fstat+0xb7>
	if (!dev->dev_stat)
  8029b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029b8:	48 85 c0             	test   %rax,%rax
  8029bb:	75 07                	jne    8029c4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8029bd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029c2:	eb 4a                	jmp    802a0e <fstat+0xb7>
	stat->st_name[0] = 0;
  8029c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029c8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8029cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029cf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8029d6:	00 00 00 
	stat->st_isdir = 0;
  8029d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029dd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8029e4:	00 00 00 
	stat->st_dev = dev;
  8029e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029ef:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fa:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8029fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a02:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802a06:	48 89 d6             	mov    %rdx,%rsi
  802a09:	48 89 c7             	mov    %rax,%rdi
  802a0c:	ff d1                	callq  *%rcx
}
  802a0e:	c9                   	leaveq 
  802a0f:	c3                   	retq   

0000000000802a10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a10:	55                   	push   %rbp
  802a11:	48 89 e5             	mov    %rsp,%rbp
  802a14:	48 83 ec 20          	sub    $0x20,%rsp
  802a18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a24:	be 00 00 00 00       	mov    $0x0,%esi
  802a29:	48 89 c7             	mov    %rax,%rdi
  802a2c:	48 b8 ff 2a 80 00 00 	movabs $0x802aff,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	callq  *%rax
  802a38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3f:	79 05                	jns    802a46 <stat+0x36>
		return fd;
  802a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a44:	eb 2f                	jmp    802a75 <stat+0x65>
	r = fstat(fd, stat);
  802a46:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4d:	48 89 d6             	mov    %rdx,%rsi
  802a50:	89 c7                	mov    %eax,%edi
  802a52:	48 b8 57 29 80 00 00 	movabs $0x802957,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
  802a5e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a64:	89 c7                	mov    %eax,%edi
  802a66:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  802a6d:	00 00 00 
  802a70:	ff d0                	callq  *%rax
	return r;
  802a72:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a75:	c9                   	leaveq 
  802a76:	c3                   	retq   
	...

0000000000802a78 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a78:	55                   	push   %rbp
  802a79:	48 89 e5             	mov    %rsp,%rbp
  802a7c:	48 83 ec 10          	sub    $0x10,%rsp
  802a80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a87:	48 b8 2c 74 80 00 00 	movabs $0x80742c,%rax
  802a8e:	00 00 00 
  802a91:	8b 00                	mov    (%rax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	75 1d                	jne    802ab4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a97:	bf 01 00 00 00       	mov    $0x1,%edi
  802a9c:	48 b8 6f 40 80 00 00 	movabs $0x80406f,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
  802aa8:	48 ba 2c 74 80 00 00 	movabs $0x80742c,%rdx
  802aaf:	00 00 00 
  802ab2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ab4:	48 b8 2c 74 80 00 00 	movabs $0x80742c,%rax
  802abb:	00 00 00 
  802abe:	8b 00                	mov    (%rax),%eax
  802ac0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ac3:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ac8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802acf:	00 00 00 
  802ad2:	89 c7                	mov    %eax,%edi
  802ad4:	48 b8 ac 3f 80 00 00 	movabs $0x803fac,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ae0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae9:	48 89 c6             	mov    %rax,%rsi
  802aec:	bf 00 00 00 00       	mov    $0x0,%edi
  802af1:	48 b8 ec 3e 80 00 00 	movabs $0x803eec,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
}
  802afd:	c9                   	leaveq 
  802afe:	c3                   	retq   

0000000000802aff <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802aff:	55                   	push   %rbp
  802b00:	48 89 e5             	mov    %rsp,%rbp
  802b03:	48 83 ec 20          	sub    $0x20,%rsp
  802b07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b0b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802b0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b12:	48 89 c7             	mov    %rax,%rdi
  802b15:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax
  802b21:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b26:	7e 0a                	jle    802b32 <open+0x33>
                return -E_BAD_PATH;
  802b28:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b2d:	e9 a5 00 00 00       	jmpq   802bd7 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802b32:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b36:	48 89 c7             	mov    %rax,%rdi
  802b39:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	callq  *%rax
  802b45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4c:	79 08                	jns    802b56 <open+0x57>
		return r;
  802b4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b51:	e9 81 00 00 00       	jmpq   802bd7 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802b56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5a:	48 89 c6             	mov    %rax,%rsi
  802b5d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b64:	00 00 00 
  802b67:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  802b6e:	00 00 00 
  802b71:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802b73:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b7a:	00 00 00 
  802b7d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802b80:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8a:	48 89 c6             	mov    %rax,%rsi
  802b8d:	bf 01 00 00 00       	mov    $0x1,%edi
  802b92:	48 b8 78 2a 80 00 00 	movabs $0x802a78,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
  802b9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802ba1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba5:	79 1d                	jns    802bc4 <open+0xc5>
	{
		fd_close(fd,0);
  802ba7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bab:	be 00 00 00 00       	mov    $0x0,%esi
  802bb0:	48 89 c7             	mov    %rax,%rdi
  802bb3:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
		return r;
  802bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc2:	eb 13                	jmp    802bd7 <open+0xd8>
	}
	return fd2num(fd);
  802bc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc8:	48 89 c7             	mov    %rax,%rdi
  802bcb:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
	


}
  802bd7:	c9                   	leaveq 
  802bd8:	c3                   	retq   

0000000000802bd9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bd9:	55                   	push   %rbp
  802bda:	48 89 e5             	mov    %rsp,%rbp
  802bdd:	48 83 ec 10          	sub    $0x10,%rsp
  802be1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802be9:	8b 50 0c             	mov    0xc(%rax),%edx
  802bec:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bf3:	00 00 00 
  802bf6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802bf8:	be 00 00 00 00       	mov    $0x0,%esi
  802bfd:	bf 06 00 00 00       	mov    $0x6,%edi
  802c02:	48 b8 78 2a 80 00 00 	movabs $0x802a78,%rax
  802c09:	00 00 00 
  802c0c:	ff d0                	callq  *%rax
}
  802c0e:	c9                   	leaveq 
  802c0f:	c3                   	retq   

0000000000802c10 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c10:	55                   	push   %rbp
  802c11:	48 89 e5             	mov    %rsp,%rbp
  802c14:	48 83 ec 30          	sub    $0x30,%rsp
  802c18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c20:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c28:	8b 50 0c             	mov    0xc(%rax),%edx
  802c2b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c32:	00 00 00 
  802c35:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c37:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c3e:	00 00 00 
  802c41:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c45:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802c49:	be 00 00 00 00       	mov    $0x0,%esi
  802c4e:	bf 03 00 00 00       	mov    $0x3,%edi
  802c53:	48 b8 78 2a 80 00 00 	movabs $0x802a78,%rax
  802c5a:	00 00 00 
  802c5d:	ff d0                	callq  *%rax
  802c5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c66:	79 05                	jns    802c6d <devfile_read+0x5d>
	{
		return r;
  802c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6b:	eb 2c                	jmp    802c99 <devfile_read+0x89>
	}
	if(r > 0)
  802c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c71:	7e 23                	jle    802c96 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c76:	48 63 d0             	movslq %eax,%rdx
  802c79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c7d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c84:	00 00 00 
  802c87:	48 89 c7             	mov    %rax,%rdi
  802c8a:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  802c91:	00 00 00 
  802c94:	ff d0                	callq  *%rax
	return r;
  802c96:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802c99:	c9                   	leaveq 
  802c9a:	c3                   	retq   

0000000000802c9b <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c9b:	55                   	push   %rbp
  802c9c:	48 89 e5             	mov    %rsp,%rbp
  802c9f:	48 83 ec 30          	sub    $0x30,%rsp
  802ca3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb3:	8b 50 0c             	mov    0xc(%rax),%edx
  802cb6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cbd:	00 00 00 
  802cc0:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802cc2:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802cc9:	00 
  802cca:	76 08                	jbe    802cd4 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802ccc:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802cd3:	00 
	fsipcbuf.write.req_n=n;
  802cd4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cdb:	00 00 00 
  802cde:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ce2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802ce6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cee:	48 89 c6             	mov    %rax,%rsi
  802cf1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802cf8:	00 00 00 
  802cfb:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802d07:	be 00 00 00 00       	mov    $0x0,%esi
  802d0c:	bf 04 00 00 00       	mov    $0x4,%edi
  802d11:	48 b8 78 2a 80 00 00 	movabs $0x802a78,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
  802d1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802d20:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d23:	c9                   	leaveq 
  802d24:	c3                   	retq   

0000000000802d25 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802d25:	55                   	push   %rbp
  802d26:	48 89 e5             	mov    %rsp,%rbp
  802d29:	48 83 ec 10          	sub    $0x10,%rsp
  802d2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d31:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802d34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d38:	8b 50 0c             	mov    0xc(%rax),%edx
  802d3b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d42:	00 00 00 
  802d45:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802d47:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d4e:	00 00 00 
  802d51:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802d54:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802d57:	be 00 00 00 00       	mov    $0x0,%esi
  802d5c:	bf 02 00 00 00       	mov    $0x2,%edi
  802d61:	48 b8 78 2a 80 00 00 	movabs $0x802a78,%rax
  802d68:	00 00 00 
  802d6b:	ff d0                	callq  *%rax
}
  802d6d:	c9                   	leaveq 
  802d6e:	c3                   	retq   

0000000000802d6f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d6f:	55                   	push   %rbp
  802d70:	48 89 e5             	mov    %rsp,%rbp
  802d73:	48 83 ec 20          	sub    $0x20,%rsp
  802d77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d83:	8b 50 0c             	mov    0xc(%rax),%edx
  802d86:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d8d:	00 00 00 
  802d90:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d92:	be 00 00 00 00       	mov    $0x0,%esi
  802d97:	bf 05 00 00 00       	mov    $0x5,%edi
  802d9c:	48 b8 78 2a 80 00 00 	movabs $0x802a78,%rax
  802da3:	00 00 00 
  802da6:	ff d0                	callq  *%rax
  802da8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802daf:	79 05                	jns    802db6 <devfile_stat+0x47>
		return r;
  802db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db4:	eb 56                	jmp    802e0c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802db6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dba:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802dc1:	00 00 00 
  802dc4:	48 89 c7             	mov    %rax,%rdi
  802dc7:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  802dce:	00 00 00 
  802dd1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802dd3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dda:	00 00 00 
  802ddd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802de3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ded:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df4:	00 00 00 
  802df7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802dfd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e01:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0c:	c9                   	leaveq 
  802e0d:	c3                   	retq   
	...

0000000000802e10 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e10:	55                   	push   %rbp
  802e11:	48 89 e5             	mov    %rsp,%rbp
  802e14:	48 83 ec 20          	sub    $0x20,%rsp
  802e18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e20:	8b 40 0c             	mov    0xc(%rax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	7e 67                	jle    802e8e <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2b:	8b 40 04             	mov    0x4(%rax),%eax
  802e2e:	48 63 d0             	movslq %eax,%rdx
  802e31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e35:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3d:	8b 00                	mov    (%rax),%eax
  802e3f:	48 89 ce             	mov    %rcx,%rsi
  802e42:	89 c7                	mov    %eax,%edi
  802e44:	48 b8 6e 27 80 00 00 	movabs $0x80276e,%rax
  802e4b:	00 00 00 
  802e4e:	ff d0                	callq  *%rax
  802e50:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802e53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e57:	7e 13                	jle    802e6c <writebuf+0x5c>
			b->result += result;
  802e59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5d:	8b 40 08             	mov    0x8(%rax),%eax
  802e60:	89 c2                	mov    %eax,%edx
  802e62:	03 55 fc             	add    -0x4(%rbp),%edx
  802e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e69:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e70:	8b 40 04             	mov    0x4(%rax),%eax
  802e73:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e76:	74 16                	je     802e8e <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802e78:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e81:	89 c2                	mov    %eax,%edx
  802e83:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  802e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8b:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802e8e:	c9                   	leaveq 
  802e8f:	c3                   	retq   

0000000000802e90 <putch>:

static void
putch(int ch, void *thunk)
{
  802e90:	55                   	push   %rbp
  802e91:	48 89 e5             	mov    %rsp,%rbp
  802e94:	48 83 ec 20          	sub    $0x20,%rsp
  802e98:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e9b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802e9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802ea7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eab:	8b 40 04             	mov    0x4(%rax),%eax
  802eae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802eb1:	89 d6                	mov    %edx,%esi
  802eb3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802eb7:	48 63 d0             	movslq %eax,%rdx
  802eba:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  802ebf:	8d 50 01             	lea    0x1(%rax),%edx
  802ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec6:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  802ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ecd:	8b 40 04             	mov    0x4(%rax),%eax
  802ed0:	3d 00 01 00 00       	cmp    $0x100,%eax
  802ed5:	75 1e                	jne    802ef5 <putch+0x65>
		writebuf(b);
  802ed7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802edb:	48 89 c7             	mov    %rax,%rdi
  802ede:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
		b->idx = 0;
  802eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802ef5:	c9                   	leaveq 
  802ef6:	c3                   	retq   

0000000000802ef7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802ef7:	55                   	push   %rbp
  802ef8:	48 89 e5             	mov    %rsp,%rbp
  802efb:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f02:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f08:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f0f:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f16:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802f1c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802f22:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802f29:	00 00 00 
	b.result = 0;
  802f2c:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802f33:	00 00 00 
	b.error = 1;
  802f36:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f3d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f40:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802f47:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802f4e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f55:	48 89 c6             	mov    %rax,%rsi
  802f58:	48 bf 90 2e 80 00 00 	movabs $0x802e90,%rdi
  802f5f:	00 00 00 
  802f62:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802f6e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	7e 16                	jle    802f8e <vfprintf+0x97>
		writebuf(&b);
  802f78:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f7f:	48 89 c7             	mov    %rax,%rdi
  802f82:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  802f89:	00 00 00 
  802f8c:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802f8e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 08                	je     802fa0 <vfprintf+0xa9>
  802f98:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f9e:	eb 06                	jmp    802fa6 <vfprintf+0xaf>
  802fa0:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802fa6:	c9                   	leaveq 
  802fa7:	c3                   	retq   

0000000000802fa8 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802fa8:	55                   	push   %rbp
  802fa9:	48 89 e5             	mov    %rsp,%rbp
  802fac:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fb3:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802fb9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fc0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fc7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fce:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fd5:	84 c0                	test   %al,%al
  802fd7:	74 20                	je     802ff9 <fprintf+0x51>
  802fd9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fdd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fe1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fe5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fe9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ff1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ff5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ff9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803000:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803007:	00 00 00 
  80300a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803011:	00 00 00 
  803014:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803018:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80301f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803026:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80302d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803034:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80303b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803041:	48 89 ce             	mov    %rcx,%rsi
  803044:	89 c7                	mov    %eax,%edi
  803046:	48 b8 f7 2e 80 00 00 	movabs $0x802ef7,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
  803052:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803058:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80305e:	c9                   	leaveq 
  80305f:	c3                   	retq   

0000000000803060 <printf>:

int
printf(const char *fmt, ...)
{
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
  803064:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80306b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803072:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803079:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803080:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803087:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80308e:	84 c0                	test   %al,%al
  803090:	74 20                	je     8030b2 <printf+0x52>
  803092:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803096:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80309a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80309e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030a2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030a6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030aa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030ae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030b2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8030b9:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8030c0:	00 00 00 
  8030c3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030ca:	00 00 00 
  8030cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030df:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8030e6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030ed:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8030f4:	48 89 c6             	mov    %rax,%rsi
  8030f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8030fc:	48 b8 f7 2e 80 00 00 	movabs $0x802ef7,%rax
  803103:	00 00 00 
  803106:	ff d0                	callq  *%rax
  803108:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80310e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803114:	c9                   	leaveq 
  803115:	c3                   	retq   
	...

0000000000803118 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803118:	55                   	push   %rbp
  803119:	48 89 e5             	mov    %rsp,%rbp
  80311c:	48 83 ec 20          	sub    $0x20,%rsp
  803120:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803123:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803127:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80312a:	48 89 d6             	mov    %rdx,%rsi
  80312d:	89 c7                	mov    %eax,%edi
  80312f:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
  80313b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80313e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803142:	79 05                	jns    803149 <fd2sockid+0x31>
		return r;
  803144:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803147:	eb 24                	jmp    80316d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80314d:	8b 10                	mov    (%rax),%edx
  80314f:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803156:	00 00 00 
  803159:	8b 00                	mov    (%rax),%eax
  80315b:	39 c2                	cmp    %eax,%edx
  80315d:	74 07                	je     803166 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80315f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803164:	eb 07                	jmp    80316d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80316d:	c9                   	leaveq 
  80316e:	c3                   	retq   

000000000080316f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80316f:	55                   	push   %rbp
  803170:	48 89 e5             	mov    %rsp,%rbp
  803173:	48 83 ec 20          	sub    $0x20,%rsp
  803177:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80317a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80317e:	48 89 c7             	mov    %rax,%rdi
  803181:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
  80318d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803194:	78 26                	js     8031bc <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803196:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319a:	ba 07 04 00 00       	mov    $0x407,%edx
  80319f:	48 89 c6             	mov    %rax,%rsi
  8031a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a7:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  8031ae:	00 00 00 
  8031b1:	ff d0                	callq  *%rax
  8031b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ba:	79 16                	jns    8031d2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8031bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031bf:	89 c7                	mov    %eax,%edi
  8031c1:	48 b8 7c 36 80 00 00 	movabs $0x80367c,%rax
  8031c8:	00 00 00 
  8031cb:	ff d0                	callq  *%rax
		return r;
  8031cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d0:	eb 3a                	jmp    80320c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8031d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d6:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8031dd:	00 00 00 
  8031e0:	8b 12                	mov    (%rdx),%edx
  8031e2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8031e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8031ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031f6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8031f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031fd:	48 89 c7             	mov    %rax,%rdi
  803200:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  803207:	00 00 00 
  80320a:	ff d0                	callq  *%rax
}
  80320c:	c9                   	leaveq 
  80320d:	c3                   	retq   

000000000080320e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80320e:	55                   	push   %rbp
  80320f:	48 89 e5             	mov    %rsp,%rbp
  803212:	48 83 ec 30          	sub    $0x30,%rsp
  803216:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803219:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80321d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803221:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803224:	89 c7                	mov    %eax,%edi
  803226:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
  803232:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803235:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803239:	79 05                	jns    803240 <accept+0x32>
		return r;
  80323b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323e:	eb 3b                	jmp    80327b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803240:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803244:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803248:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324b:	48 89 ce             	mov    %rcx,%rsi
  80324e:	89 c7                	mov    %eax,%edi
  803250:	48 b8 59 35 80 00 00 	movabs $0x803559,%rax
  803257:	00 00 00 
  80325a:	ff d0                	callq  *%rax
  80325c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80325f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803263:	79 05                	jns    80326a <accept+0x5c>
		return r;
  803265:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803268:	eb 11                	jmp    80327b <accept+0x6d>
	return alloc_sockfd(r);
  80326a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326d:	89 c7                	mov    %eax,%edi
  80326f:	48 b8 6f 31 80 00 00 	movabs $0x80316f,%rax
  803276:	00 00 00 
  803279:	ff d0                	callq  *%rax
}
  80327b:	c9                   	leaveq 
  80327c:	c3                   	retq   

000000000080327d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80327d:	55                   	push   %rbp
  80327e:	48 89 e5             	mov    %rsp,%rbp
  803281:	48 83 ec 20          	sub    $0x20,%rsp
  803285:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803288:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80328c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80328f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803292:	89 c7                	mov    %eax,%edi
  803294:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  80329b:	00 00 00 
  80329e:	ff d0                	callq  *%rax
  8032a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a7:	79 05                	jns    8032ae <bind+0x31>
		return r;
  8032a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ac:	eb 1b                	jmp    8032c9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8032ae:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032b1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b8:	48 89 ce             	mov    %rcx,%rsi
  8032bb:	89 c7                	mov    %eax,%edi
  8032bd:	48 b8 d8 35 80 00 00 	movabs $0x8035d8,%rax
  8032c4:	00 00 00 
  8032c7:	ff d0                	callq  *%rax
}
  8032c9:	c9                   	leaveq 
  8032ca:	c3                   	retq   

00000000008032cb <shutdown>:

int
shutdown(int s, int how)
{
  8032cb:	55                   	push   %rbp
  8032cc:	48 89 e5             	mov    %rsp,%rbp
  8032cf:	48 83 ec 20          	sub    $0x20,%rsp
  8032d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032d6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032dc:	89 c7                	mov    %eax,%edi
  8032de:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  8032e5:	00 00 00 
  8032e8:	ff d0                	callq  *%rax
  8032ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f1:	79 05                	jns    8032f8 <shutdown+0x2d>
		return r;
  8032f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f6:	eb 16                	jmp    80330e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8032f8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fe:	89 d6                	mov    %edx,%esi
  803300:	89 c7                	mov    %eax,%edi
  803302:	48 b8 3c 36 80 00 00 	movabs $0x80363c,%rax
  803309:	00 00 00 
  80330c:	ff d0                	callq  *%rax
}
  80330e:	c9                   	leaveq 
  80330f:	c3                   	retq   

0000000000803310 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803310:	55                   	push   %rbp
  803311:	48 89 e5             	mov    %rsp,%rbp
  803314:	48 83 ec 10          	sub    $0x10,%rsp
  803318:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80331c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803320:	48 89 c7             	mov    %rax,%rdi
  803323:	48 b8 f4 40 80 00 00 	movabs $0x8040f4,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
  80332f:	83 f8 01             	cmp    $0x1,%eax
  803332:	75 17                	jne    80334b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803338:	8b 40 0c             	mov    0xc(%rax),%eax
  80333b:	89 c7                	mov    %eax,%edi
  80333d:	48 b8 7c 36 80 00 00 	movabs $0x80367c,%rax
  803344:	00 00 00 
  803347:	ff d0                	callq  *%rax
  803349:	eb 05                	jmp    803350 <devsock_close+0x40>
	else
		return 0;
  80334b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803350:	c9                   	leaveq 
  803351:	c3                   	retq   

0000000000803352 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803352:	55                   	push   %rbp
  803353:	48 89 e5             	mov    %rsp,%rbp
  803356:	48 83 ec 20          	sub    $0x20,%rsp
  80335a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80335d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803361:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803364:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803367:	89 c7                	mov    %eax,%edi
  803369:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
  803375:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337c:	79 05                	jns    803383 <connect+0x31>
		return r;
  80337e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803381:	eb 1b                	jmp    80339e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803383:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803386:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80338a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338d:	48 89 ce             	mov    %rcx,%rsi
  803390:	89 c7                	mov    %eax,%edi
  803392:	48 b8 a9 36 80 00 00 	movabs $0x8036a9,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
}
  80339e:	c9                   	leaveq 
  80339f:	c3                   	retq   

00000000008033a0 <listen>:

int
listen(int s, int backlog)
{
  8033a0:	55                   	push   %rbp
  8033a1:	48 89 e5             	mov    %rsp,%rbp
  8033a4:	48 83 ec 20          	sub    $0x20,%rsp
  8033a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033ab:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b1:	89 c7                	mov    %eax,%edi
  8033b3:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  8033ba:	00 00 00 
  8033bd:	ff d0                	callq  *%rax
  8033bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c6:	79 05                	jns    8033cd <listen+0x2d>
		return r;
  8033c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033cb:	eb 16                	jmp    8033e3 <listen+0x43>
	return nsipc_listen(r, backlog);
  8033cd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d3:	89 d6                	mov    %edx,%esi
  8033d5:	89 c7                	mov    %eax,%edi
  8033d7:	48 b8 0d 37 80 00 00 	movabs $0x80370d,%rax
  8033de:	00 00 00 
  8033e1:	ff d0                	callq  *%rax
}
  8033e3:	c9                   	leaveq 
  8033e4:	c3                   	retq   

00000000008033e5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8033e5:	55                   	push   %rbp
  8033e6:	48 89 e5             	mov    %rsp,%rbp
  8033e9:	48 83 ec 20          	sub    $0x20,%rsp
  8033ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033f5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8033f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033fd:	89 c2                	mov    %eax,%edx
  8033ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803403:	8b 40 0c             	mov    0xc(%rax),%eax
  803406:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80340a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80340f:	89 c7                	mov    %eax,%edi
  803411:	48 b8 4d 37 80 00 00 	movabs $0x80374d,%rax
  803418:	00 00 00 
  80341b:	ff d0                	callq  *%rax
}
  80341d:	c9                   	leaveq 
  80341e:	c3                   	retq   

000000000080341f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80341f:	55                   	push   %rbp
  803420:	48 89 e5             	mov    %rsp,%rbp
  803423:	48 83 ec 20          	sub    $0x20,%rsp
  803427:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80342b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80342f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803437:	89 c2                	mov    %eax,%edx
  803439:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343d:	8b 40 0c             	mov    0xc(%rax),%eax
  803440:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803444:	b9 00 00 00 00       	mov    $0x0,%ecx
  803449:	89 c7                	mov    %eax,%edi
  80344b:	48 b8 19 38 80 00 00 	movabs $0x803819,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
}
  803457:	c9                   	leaveq 
  803458:	c3                   	retq   

0000000000803459 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803459:	55                   	push   %rbp
  80345a:	48 89 e5             	mov    %rsp,%rbp
  80345d:	48 83 ec 10          	sub    $0x10,%rsp
  803461:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803465:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80346d:	48 be a3 47 80 00 00 	movabs $0x8047a3,%rsi
  803474:	00 00 00 
  803477:	48 89 c7             	mov    %rax,%rdi
  80347a:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
	return 0;
  803486:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348b:	c9                   	leaveq 
  80348c:	c3                   	retq   

000000000080348d <socket>:

int
socket(int domain, int type, int protocol)
{
  80348d:	55                   	push   %rbp
  80348e:	48 89 e5             	mov    %rsp,%rbp
  803491:	48 83 ec 20          	sub    $0x20,%rsp
  803495:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803498:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80349b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80349e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8034a1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034a7:	89 ce                	mov    %ecx,%esi
  8034a9:	89 c7                	mov    %eax,%edi
  8034ab:	48 b8 d1 38 80 00 00 	movabs $0x8038d1,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034be:	79 05                	jns    8034c5 <socket+0x38>
		return r;
  8034c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c3:	eb 11                	jmp    8034d6 <socket+0x49>
	return alloc_sockfd(r);
  8034c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c8:	89 c7                	mov    %eax,%edi
  8034ca:	48 b8 6f 31 80 00 00 	movabs $0x80316f,%rax
  8034d1:	00 00 00 
  8034d4:	ff d0                	callq  *%rax
}
  8034d6:	c9                   	leaveq 
  8034d7:	c3                   	retq   

00000000008034d8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8034d8:	55                   	push   %rbp
  8034d9:	48 89 e5             	mov    %rsp,%rbp
  8034dc:	48 83 ec 10          	sub    $0x10,%rsp
  8034e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8034e3:	48 b8 3c 74 80 00 00 	movabs $0x80743c,%rax
  8034ea:	00 00 00 
  8034ed:	8b 00                	mov    (%rax),%eax
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	75 1d                	jne    803510 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8034f3:	bf 02 00 00 00       	mov    $0x2,%edi
  8034f8:	48 b8 6f 40 80 00 00 	movabs $0x80406f,%rax
  8034ff:	00 00 00 
  803502:	ff d0                	callq  *%rax
  803504:	48 ba 3c 74 80 00 00 	movabs $0x80743c,%rdx
  80350b:	00 00 00 
  80350e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803510:	48 b8 3c 74 80 00 00 	movabs $0x80743c,%rax
  803517:	00 00 00 
  80351a:	8b 00                	mov    (%rax),%eax
  80351c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80351f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803524:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80352b:	00 00 00 
  80352e:	89 c7                	mov    %eax,%edi
  803530:	48 b8 ac 3f 80 00 00 	movabs $0x803fac,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80353c:	ba 00 00 00 00       	mov    $0x0,%edx
  803541:	be 00 00 00 00       	mov    $0x0,%esi
  803546:	bf 00 00 00 00       	mov    $0x0,%edi
  80354b:	48 b8 ec 3e 80 00 00 	movabs $0x803eec,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax
}
  803557:	c9                   	leaveq 
  803558:	c3                   	retq   

0000000000803559 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803559:	55                   	push   %rbp
  80355a:	48 89 e5             	mov    %rsp,%rbp
  80355d:	48 83 ec 30          	sub    $0x30,%rsp
  803561:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803564:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803568:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80356c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803573:	00 00 00 
  803576:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803579:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80357b:	bf 01 00 00 00       	mov    $0x1,%edi
  803580:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  803587:	00 00 00 
  80358a:	ff d0                	callq  *%rax
  80358c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803593:	78 3e                	js     8035d3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803595:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80359c:	00 00 00 
  80359f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8035a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a7:	8b 40 10             	mov    0x10(%rax),%eax
  8035aa:	89 c2                	mov    %eax,%edx
  8035ac:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8035b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b4:	48 89 ce             	mov    %rcx,%rsi
  8035b7:	48 89 c7             	mov    %rax,%rdi
  8035ba:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8035c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ca:	8b 50 10             	mov    0x10(%rax),%edx
  8035cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8035d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035d6:	c9                   	leaveq 
  8035d7:	c3                   	retq   

00000000008035d8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035d8:	55                   	push   %rbp
  8035d9:	48 89 e5             	mov    %rsp,%rbp
  8035dc:	48 83 ec 10          	sub    $0x10,%rsp
  8035e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035e7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8035ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f1:	00 00 00 
  8035f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035f7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8035f9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803600:	48 89 c6             	mov    %rax,%rsi
  803603:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80360a:	00 00 00 
  80360d:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  803614:	00 00 00 
  803617:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803619:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803620:	00 00 00 
  803623:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803626:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803629:	bf 02 00 00 00       	mov    $0x2,%edi
  80362e:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  803635:	00 00 00 
  803638:	ff d0                	callq  *%rax
}
  80363a:	c9                   	leaveq 
  80363b:	c3                   	retq   

000000000080363c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80363c:	55                   	push   %rbp
  80363d:	48 89 e5             	mov    %rsp,%rbp
  803640:	48 83 ec 10          	sub    $0x10,%rsp
  803644:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803647:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80364a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803651:	00 00 00 
  803654:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803657:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803659:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803660:	00 00 00 
  803663:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803666:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803669:	bf 03 00 00 00       	mov    $0x3,%edi
  80366e:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  803675:	00 00 00 
  803678:	ff d0                	callq  *%rax
}
  80367a:	c9                   	leaveq 
  80367b:	c3                   	retq   

000000000080367c <nsipc_close>:

int
nsipc_close(int s)
{
  80367c:	55                   	push   %rbp
  80367d:	48 89 e5             	mov    %rsp,%rbp
  803680:	48 83 ec 10          	sub    $0x10,%rsp
  803684:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803687:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80368e:	00 00 00 
  803691:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803694:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803696:	bf 04 00 00 00       	mov    $0x4,%edi
  80369b:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
}
  8036a7:	c9                   	leaveq 
  8036a8:	c3                   	retq   

00000000008036a9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036a9:	55                   	push   %rbp
  8036aa:	48 89 e5             	mov    %rsp,%rbp
  8036ad:	48 83 ec 10          	sub    $0x10,%rsp
  8036b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036b8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8036bb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036c2:	00 00 00 
  8036c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036c8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8036ca:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d1:	48 89 c6             	mov    %rax,%rsi
  8036d4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036db:	00 00 00 
  8036de:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  8036e5:	00 00 00 
  8036e8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8036ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036f1:	00 00 00 
  8036f4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036f7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8036fa:	bf 05 00 00 00       	mov    $0x5,%edi
  8036ff:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  803706:	00 00 00 
  803709:	ff d0                	callq  *%rax
}
  80370b:	c9                   	leaveq 
  80370c:	c3                   	retq   

000000000080370d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80370d:	55                   	push   %rbp
  80370e:	48 89 e5             	mov    %rsp,%rbp
  803711:	48 83 ec 10          	sub    $0x10,%rsp
  803715:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803718:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80371b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803722:	00 00 00 
  803725:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803728:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80372a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803731:	00 00 00 
  803734:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803737:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80373a:	bf 06 00 00 00       	mov    $0x6,%edi
  80373f:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
}
  80374b:	c9                   	leaveq 
  80374c:	c3                   	retq   

000000000080374d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80374d:	55                   	push   %rbp
  80374e:	48 89 e5             	mov    %rsp,%rbp
  803751:	48 83 ec 30          	sub    $0x30,%rsp
  803755:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803758:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80375c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80375f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803762:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803769:	00 00 00 
  80376c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80376f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803771:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803778:	00 00 00 
  80377b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80377e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803781:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803788:	00 00 00 
  80378b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80378e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803791:	bf 07 00 00 00       	mov    $0x7,%edi
  803796:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  80379d:	00 00 00 
  8037a0:	ff d0                	callq  *%rax
  8037a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a9:	78 69                	js     803814 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8037ab:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8037b2:	7f 08                	jg     8037bc <nsipc_recv+0x6f>
  8037b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8037ba:	7e 35                	jle    8037f1 <nsipc_recv+0xa4>
  8037bc:	48 b9 aa 47 80 00 00 	movabs $0x8047aa,%rcx
  8037c3:	00 00 00 
  8037c6:	48 ba bf 47 80 00 00 	movabs $0x8047bf,%rdx
  8037cd:	00 00 00 
  8037d0:	be 61 00 00 00       	mov    $0x61,%esi
  8037d5:	48 bf d4 47 80 00 00 	movabs $0x8047d4,%rdi
  8037dc:	00 00 00 
  8037df:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e4:	49 b8 38 05 80 00 00 	movabs $0x800538,%r8
  8037eb:	00 00 00 
  8037ee:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8037f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f4:	48 63 d0             	movslq %eax,%rdx
  8037f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037fb:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803802:	00 00 00 
  803805:	48 89 c7             	mov    %rax,%rdi
  803808:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
	}

	return r;
  803814:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803817:	c9                   	leaveq 
  803818:	c3                   	retq   

0000000000803819 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803819:	55                   	push   %rbp
  80381a:	48 89 e5             	mov    %rsp,%rbp
  80381d:	48 83 ec 20          	sub    $0x20,%rsp
  803821:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803824:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803828:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80382b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80382e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803835:	00 00 00 
  803838:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80383b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80383d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803844:	7e 35                	jle    80387b <nsipc_send+0x62>
  803846:	48 b9 e0 47 80 00 00 	movabs $0x8047e0,%rcx
  80384d:	00 00 00 
  803850:	48 ba bf 47 80 00 00 	movabs $0x8047bf,%rdx
  803857:	00 00 00 
  80385a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80385f:	48 bf d4 47 80 00 00 	movabs $0x8047d4,%rdi
  803866:	00 00 00 
  803869:	b8 00 00 00 00       	mov    $0x0,%eax
  80386e:	49 b8 38 05 80 00 00 	movabs $0x800538,%r8
  803875:	00 00 00 
  803878:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80387b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80387e:	48 63 d0             	movslq %eax,%rdx
  803881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803885:	48 89 c6             	mov    %rax,%rsi
  803888:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80388f:	00 00 00 
  803892:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  803899:	00 00 00 
  80389c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80389e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038a5:	00 00 00 
  8038a8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038ab:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8038ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b5:	00 00 00 
  8038b8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038bb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8038be:	bf 08 00 00 00       	mov    $0x8,%edi
  8038c3:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  8038ca:	00 00 00 
  8038cd:	ff d0                	callq  *%rax
}
  8038cf:	c9                   	leaveq 
  8038d0:	c3                   	retq   

00000000008038d1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8038d1:	55                   	push   %rbp
  8038d2:	48 89 e5             	mov    %rsp,%rbp
  8038d5:	48 83 ec 10          	sub    $0x10,%rsp
  8038d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038dc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8038df:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8038e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038e9:	00 00 00 
  8038ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038ef:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8038f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f8:	00 00 00 
  8038fb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038fe:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803901:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803908:	00 00 00 
  80390b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80390e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803911:	bf 09 00 00 00       	mov    $0x9,%edi
  803916:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  80391d:	00 00 00 
  803920:	ff d0                	callq  *%rax
}
  803922:	c9                   	leaveq 
  803923:	c3                   	retq   

0000000000803924 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803924:	55                   	push   %rbp
  803925:	48 89 e5             	mov    %rsp,%rbp
  803928:	53                   	push   %rbx
  803929:	48 83 ec 38          	sub    $0x38,%rsp
  80392d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803931:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803935:	48 89 c7             	mov    %rax,%rdi
  803938:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  80393f:	00 00 00 
  803942:	ff d0                	callq  *%rax
  803944:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803947:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80394b:	0f 88 bf 01 00 00    	js     803b10 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803955:	ba 07 04 00 00       	mov    $0x407,%edx
  80395a:	48 89 c6             	mov    %rax,%rsi
  80395d:	bf 00 00 00 00       	mov    $0x0,%edi
  803962:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  803969:	00 00 00 
  80396c:	ff d0                	callq  *%rax
  80396e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803971:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803975:	0f 88 95 01 00 00    	js     803b10 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80397b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80397f:	48 89 c7             	mov    %rax,%rdi
  803982:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  803989:	00 00 00 
  80398c:	ff d0                	callq  *%rax
  80398e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803991:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803995:	0f 88 5d 01 00 00    	js     803af8 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80399b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80399f:	ba 07 04 00 00       	mov    $0x407,%edx
  8039a4:	48 89 c6             	mov    %rax,%rsi
  8039a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ac:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  8039b3:	00 00 00 
  8039b6:	ff d0                	callq  *%rax
  8039b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039bf:	0f 88 33 01 00 00    	js     803af8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8039c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c9:	48 89 c7             	mov    %rax,%rdi
  8039cc:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  8039d3:	00 00 00 
  8039d6:	ff d0                	callq  *%rax
  8039d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e0:	ba 07 04 00 00       	mov    $0x407,%edx
  8039e5:	48 89 c6             	mov    %rax,%rsi
  8039e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ed:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  8039f4:	00 00 00 
  8039f7:	ff d0                	callq  *%rax
  8039f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a00:	0f 88 d9 00 00 00    	js     803adf <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a0a:	48 89 c7             	mov    %rax,%rdi
  803a0d:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  803a14:	00 00 00 
  803a17:	ff d0                	callq  *%rax
  803a19:	48 89 c2             	mov    %rax,%rdx
  803a1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a20:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803a26:	48 89 d1             	mov    %rdx,%rcx
  803a29:	ba 00 00 00 00       	mov    $0x0,%edx
  803a2e:	48 89 c6             	mov    %rax,%rsi
  803a31:	bf 00 00 00 00       	mov    $0x0,%edi
  803a36:	48 b8 18 1e 80 00 00 	movabs $0x801e18,%rax
  803a3d:	00 00 00 
  803a40:	ff d0                	callq  *%rax
  803a42:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a45:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a49:	78 79                	js     803ac4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803a4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a4f:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803a56:	00 00 00 
  803a59:	8b 12                	mov    (%rdx),%edx
  803a5b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a61:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a6c:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803a73:	00 00 00 
  803a76:	8b 12                	mov    (%rdx),%edx
  803a78:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803a7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a7e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a89:	48 89 c7             	mov    %rax,%rdi
  803a8c:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  803a93:	00 00 00 
  803a96:	ff d0                	callq  *%rax
  803a98:	89 c2                	mov    %eax,%edx
  803a9a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a9e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803aa0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803aa4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803aa8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aac:	48 89 c7             	mov    %rax,%rdi
  803aaf:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  803ab6:	00 00 00 
  803ab9:	ff d0                	callq  *%rax
  803abb:	89 03                	mov    %eax,(%rbx)
	return 0;
  803abd:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac2:	eb 4f                	jmp    803b13 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803ac4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803ac5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ac9:	48 89 c6             	mov    %rax,%rsi
  803acc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad1:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  803ad8:	00 00 00 
  803adb:	ff d0                	callq  *%rax
  803add:	eb 01                	jmp    803ae0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803adf:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803ae0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae4:	48 89 c6             	mov    %rax,%rsi
  803ae7:	bf 00 00 00 00       	mov    $0x0,%edi
  803aec:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  803af3:	00 00 00 
  803af6:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803af8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803afc:	48 89 c6             	mov    %rax,%rsi
  803aff:	bf 00 00 00 00       	mov    $0x0,%edi
  803b04:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  803b0b:	00 00 00 
  803b0e:	ff d0                	callq  *%rax
    err:
	return r;
  803b10:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b13:	48 83 c4 38          	add    $0x38,%rsp
  803b17:	5b                   	pop    %rbx
  803b18:	5d                   	pop    %rbp
  803b19:	c3                   	retq   

0000000000803b1a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b1a:	55                   	push   %rbp
  803b1b:	48 89 e5             	mov    %rsp,%rbp
  803b1e:	53                   	push   %rbx
  803b1f:	48 83 ec 28          	sub    $0x28,%rsp
  803b23:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b27:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b2b:	eb 01                	jmp    803b2e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803b2d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803b2e:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  803b35:	00 00 00 
  803b38:	48 8b 00             	mov    (%rax),%rax
  803b3b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b41:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b48:	48 89 c7             	mov    %rax,%rdi
  803b4b:	48 b8 f4 40 80 00 00 	movabs $0x8040f4,%rax
  803b52:	00 00 00 
  803b55:	ff d0                	callq  *%rax
  803b57:	89 c3                	mov    %eax,%ebx
  803b59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b5d:	48 89 c7             	mov    %rax,%rdi
  803b60:	48 b8 f4 40 80 00 00 	movabs $0x8040f4,%rax
  803b67:	00 00 00 
  803b6a:	ff d0                	callq  *%rax
  803b6c:	39 c3                	cmp    %eax,%ebx
  803b6e:	0f 94 c0             	sete   %al
  803b71:	0f b6 c0             	movzbl %al,%eax
  803b74:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803b77:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  803b7e:	00 00 00 
  803b81:	48 8b 00             	mov    (%rax),%rax
  803b84:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b8a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803b8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b90:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b93:	75 0a                	jne    803b9f <_pipeisclosed+0x85>
			return ret;
  803b95:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803b98:	48 83 c4 28          	add    $0x28,%rsp
  803b9c:	5b                   	pop    %rbx
  803b9d:	5d                   	pop    %rbp
  803b9e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803b9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ba5:	74 86                	je     803b2d <_pipeisclosed+0x13>
  803ba7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803bab:	75 80                	jne    803b2d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803bad:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  803bb4:	00 00 00 
  803bb7:	48 8b 00             	mov    (%rax),%rax
  803bba:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803bc0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803bc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc6:	89 c6                	mov    %eax,%esi
  803bc8:	48 bf f1 47 80 00 00 	movabs $0x8047f1,%rdi
  803bcf:	00 00 00 
  803bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd7:	49 b8 73 07 80 00 00 	movabs $0x800773,%r8
  803bde:	00 00 00 
  803be1:	41 ff d0             	callq  *%r8
	}
  803be4:	e9 44 ff ff ff       	jmpq   803b2d <_pipeisclosed+0x13>

0000000000803be9 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803be9:	55                   	push   %rbp
  803bea:	48 89 e5             	mov    %rsp,%rbp
  803bed:	48 83 ec 30          	sub    $0x30,%rsp
  803bf1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bf4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803bf8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803bfb:	48 89 d6             	mov    %rdx,%rsi
  803bfe:	89 c7                	mov    %eax,%edi
  803c00:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  803c07:	00 00 00 
  803c0a:	ff d0                	callq  *%rax
  803c0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c13:	79 05                	jns    803c1a <pipeisclosed+0x31>
		return r;
  803c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c18:	eb 31                	jmp    803c4b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c1e:	48 89 c7             	mov    %rax,%rdi
  803c21:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  803c28:	00 00 00 
  803c2b:	ff d0                	callq  *%rax
  803c2d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c39:	48 89 d6             	mov    %rdx,%rsi
  803c3c:	48 89 c7             	mov    %rax,%rdi
  803c3f:	48 b8 1a 3b 80 00 00 	movabs $0x803b1a,%rax
  803c46:	00 00 00 
  803c49:	ff d0                	callq  *%rax
}
  803c4b:	c9                   	leaveq 
  803c4c:	c3                   	retq   

0000000000803c4d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c4d:	55                   	push   %rbp
  803c4e:	48 89 e5             	mov    %rsp,%rbp
  803c51:	48 83 ec 40          	sub    $0x40,%rsp
  803c55:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c59:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c5d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c65:	48 89 c7             	mov    %rax,%rdi
  803c68:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  803c6f:	00 00 00 
  803c72:	ff d0                	callq  *%rax
  803c74:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c80:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c87:	00 
  803c88:	e9 97 00 00 00       	jmpq   803d24 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803c8d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c92:	74 09                	je     803c9d <devpipe_read+0x50>
				return i;
  803c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c98:	e9 95 00 00 00       	jmpq   803d32 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803c9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ca1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca5:	48 89 d6             	mov    %rdx,%rsi
  803ca8:	48 89 c7             	mov    %rax,%rdi
  803cab:	48 b8 1a 3b 80 00 00 	movabs $0x803b1a,%rax
  803cb2:	00 00 00 
  803cb5:	ff d0                	callq  *%rax
  803cb7:	85 c0                	test   %eax,%eax
  803cb9:	74 07                	je     803cc2 <devpipe_read+0x75>
				return 0;
  803cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc0:	eb 70                	jmp    803d32 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803cc2:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
  803cce:	eb 01                	jmp    803cd1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803cd0:	90                   	nop
  803cd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd5:	8b 10                	mov    (%rax),%edx
  803cd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdb:	8b 40 04             	mov    0x4(%rax),%eax
  803cde:	39 c2                	cmp    %eax,%edx
  803ce0:	74 ab                	je     803c8d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ce2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ce6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cea:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803cee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf2:	8b 00                	mov    (%rax),%eax
  803cf4:	89 c2                	mov    %eax,%edx
  803cf6:	c1 fa 1f             	sar    $0x1f,%edx
  803cf9:	c1 ea 1b             	shr    $0x1b,%edx
  803cfc:	01 d0                	add    %edx,%eax
  803cfe:	83 e0 1f             	and    $0x1f,%eax
  803d01:	29 d0                	sub    %edx,%eax
  803d03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d07:	48 98                	cltq   
  803d09:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d0e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d14:	8b 00                	mov    (%rax),%eax
  803d16:	8d 50 01             	lea    0x1(%rax),%edx
  803d19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d1f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d28:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d2c:	72 a2                	jb     803cd0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803d2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d32:	c9                   	leaveq 
  803d33:	c3                   	retq   

0000000000803d34 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d34:	55                   	push   %rbp
  803d35:	48 89 e5             	mov    %rsp,%rbp
  803d38:	48 83 ec 40          	sub    $0x40,%rsp
  803d3c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d40:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d44:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d4c:	48 89 c7             	mov    %rax,%rdi
  803d4f:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  803d56:	00 00 00 
  803d59:	ff d0                	callq  *%rax
  803d5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d67:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d6e:	00 
  803d6f:	e9 93 00 00 00       	jmpq   803e07 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7c:	48 89 d6             	mov    %rdx,%rsi
  803d7f:	48 89 c7             	mov    %rax,%rdi
  803d82:	48 b8 1a 3b 80 00 00 	movabs $0x803b1a,%rax
  803d89:	00 00 00 
  803d8c:	ff d0                	callq  *%rax
  803d8e:	85 c0                	test   %eax,%eax
  803d90:	74 07                	je     803d99 <devpipe_write+0x65>
				return 0;
  803d92:	b8 00 00 00 00       	mov    $0x0,%eax
  803d97:	eb 7c                	jmp    803e15 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803d99:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  803da0:	00 00 00 
  803da3:	ff d0                	callq  *%rax
  803da5:	eb 01                	jmp    803da8 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803da7:	90                   	nop
  803da8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dac:	8b 40 04             	mov    0x4(%rax),%eax
  803daf:	48 63 d0             	movslq %eax,%rdx
  803db2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db6:	8b 00                	mov    (%rax),%eax
  803db8:	48 98                	cltq   
  803dba:	48 83 c0 20          	add    $0x20,%rax
  803dbe:	48 39 c2             	cmp    %rax,%rdx
  803dc1:	73 b1                	jae    803d74 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803dc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc7:	8b 40 04             	mov    0x4(%rax),%eax
  803dca:	89 c2                	mov    %eax,%edx
  803dcc:	c1 fa 1f             	sar    $0x1f,%edx
  803dcf:	c1 ea 1b             	shr    $0x1b,%edx
  803dd2:	01 d0                	add    %edx,%eax
  803dd4:	83 e0 1f             	and    $0x1f,%eax
  803dd7:	29 d0                	sub    %edx,%eax
  803dd9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ddd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803de1:	48 01 ca             	add    %rcx,%rdx
  803de4:	0f b6 0a             	movzbl (%rdx),%ecx
  803de7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803deb:	48 98                	cltq   
  803ded:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803df1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df5:	8b 40 04             	mov    0x4(%rax),%eax
  803df8:	8d 50 01             	lea    0x1(%rax),%edx
  803dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dff:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e02:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e0f:	72 96                	jb     803da7 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e15:	c9                   	leaveq 
  803e16:	c3                   	retq   

0000000000803e17 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e17:	55                   	push   %rbp
  803e18:	48 89 e5             	mov    %rsp,%rbp
  803e1b:	48 83 ec 20          	sub    $0x20,%rsp
  803e1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e2b:	48 89 c7             	mov    %rax,%rdi
  803e2e:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  803e35:	00 00 00 
  803e38:	ff d0                	callq  *%rax
  803e3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e42:	48 be 04 48 80 00 00 	movabs $0x804804,%rsi
  803e49:	00 00 00 
  803e4c:	48 89 c7             	mov    %rax,%rdi
  803e4f:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  803e56:	00 00 00 
  803e59:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803e5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e5f:	8b 50 04             	mov    0x4(%rax),%edx
  803e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e66:	8b 00                	mov    (%rax),%eax
  803e68:	29 c2                	sub    %eax,%edx
  803e6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e6e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803e74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e78:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803e7f:	00 00 00 
	stat->st_dev = &devpipe;
  803e82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e86:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803e8d:	00 00 00 
  803e90:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e9c:	c9                   	leaveq 
  803e9d:	c3                   	retq   

0000000000803e9e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803e9e:	55                   	push   %rbp
  803e9f:	48 89 e5             	mov    %rsp,%rbp
  803ea2:	48 83 ec 10          	sub    $0x10,%rsp
  803ea6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eae:	48 89 c6             	mov    %rax,%rsi
  803eb1:	bf 00 00 00 00       	mov    $0x0,%edi
  803eb6:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  803ebd:	00 00 00 
  803ec0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec6:	48 89 c7             	mov    %rax,%rdi
  803ec9:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  803ed0:	00 00 00 
  803ed3:	ff d0                	callq  *%rax
  803ed5:	48 89 c6             	mov    %rax,%rsi
  803ed8:	bf 00 00 00 00       	mov    $0x0,%edi
  803edd:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  803ee4:	00 00 00 
  803ee7:	ff d0                	callq  *%rax
}
  803ee9:	c9                   	leaveq 
  803eea:	c3                   	retq   
	...

0000000000803eec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803eec:	55                   	push   %rbp
  803eed:	48 89 e5             	mov    %rsp,%rbp
  803ef0:	48 83 ec 30          	sub    $0x30,%rsp
  803ef4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ef8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803efc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803f00:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f05:	74 18                	je     803f1f <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803f07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f0b:	48 89 c7             	mov    %rax,%rdi
  803f0e:	48 b8 f1 1f 80 00 00 	movabs $0x801ff1,%rax
  803f15:	00 00 00 
  803f18:	ff d0                	callq  *%rax
  803f1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f1d:	eb 19                	jmp    803f38 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803f1f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803f26:	00 00 00 
  803f29:	48 b8 f1 1f 80 00 00 	movabs $0x801ff1,%rax
  803f30:	00 00 00 
  803f33:	ff d0                	callq  *%rax
  803f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3c:	79 19                	jns    803f57 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f42:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803f48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f4c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803f52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f55:	eb 53                	jmp    803faa <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803f57:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f5c:	74 19                	je     803f77 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803f5e:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  803f65:	00 00 00 
  803f68:	48 8b 00             	mov    (%rax),%rax
  803f6b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f75:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803f77:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f7c:	74 19                	je     803f97 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803f7e:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  803f85:	00 00 00 
  803f88:	48 8b 00             	mov    (%rax),%rax
  803f8b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f95:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803f97:	48 b8 50 74 80 00 00 	movabs $0x807450,%rax
  803f9e:	00 00 00 
  803fa1:	48 8b 00             	mov    (%rax),%rax
  803fa4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803faa:	c9                   	leaveq 
  803fab:	c3                   	retq   

0000000000803fac <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fac:	55                   	push   %rbp
  803fad:	48 89 e5             	mov    %rsp,%rbp
  803fb0:	48 83 ec 30          	sub    $0x30,%rsp
  803fb4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fb7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fba:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803fbe:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803fc1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803fc8:	e9 96 00 00 00       	jmpq   804063 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803fcd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fd2:	74 20                	je     803ff4 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803fd4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803fd7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803fda:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fe1:	89 c7                	mov    %eax,%edi
  803fe3:	48 b8 9c 1f 80 00 00 	movabs $0x801f9c,%rax
  803fea:	00 00 00 
  803fed:	ff d0                	callq  *%rax
  803fef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ff2:	eb 2d                	jmp    804021 <ipc_send+0x75>
		else if(pg==NULL)
  803ff4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ff9:	75 26                	jne    804021 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803ffb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ffe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804001:	b9 00 00 00 00       	mov    $0x0,%ecx
  804006:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80400d:	00 00 00 
  804010:	89 c7                	mov    %eax,%edi
  804012:	48 b8 9c 1f 80 00 00 	movabs $0x801f9c,%rax
  804019:	00 00 00 
  80401c:	ff d0                	callq  *%rax
  80401e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  804021:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804025:	79 30                	jns    804057 <ipc_send+0xab>
  804027:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80402b:	74 2a                	je     804057 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  80402d:	48 ba 0b 48 80 00 00 	movabs $0x80480b,%rdx
  804034:	00 00 00 
  804037:	be 40 00 00 00       	mov    $0x40,%esi
  80403c:	48 bf 23 48 80 00 00 	movabs $0x804823,%rdi
  804043:	00 00 00 
  804046:	b8 00 00 00 00       	mov    $0x0,%eax
  80404b:	48 b9 38 05 80 00 00 	movabs $0x800538,%rcx
  804052:	00 00 00 
  804055:	ff d1                	callq  *%rcx
		}
		sys_yield();
  804057:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  80405e:	00 00 00 
  804061:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  804063:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804067:	0f 85 60 ff ff ff    	jne    803fcd <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  80406d:	c9                   	leaveq 
  80406e:	c3                   	retq   

000000000080406f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80406f:	55                   	push   %rbp
  804070:	48 89 e5             	mov    %rsp,%rbp
  804073:	48 83 ec 18          	sub    $0x18,%rsp
  804077:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80407a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804081:	eb 5e                	jmp    8040e1 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804083:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80408a:	00 00 00 
  80408d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804090:	48 63 d0             	movslq %eax,%rdx
  804093:	48 89 d0             	mov    %rdx,%rax
  804096:	48 c1 e0 03          	shl    $0x3,%rax
  80409a:	48 01 d0             	add    %rdx,%rax
  80409d:	48 c1 e0 05          	shl    $0x5,%rax
  8040a1:	48 01 c8             	add    %rcx,%rax
  8040a4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8040aa:	8b 00                	mov    (%rax),%eax
  8040ac:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8040af:	75 2c                	jne    8040dd <ipc_find_env+0x6e>
			return envs[i].env_id;
  8040b1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8040b8:	00 00 00 
  8040bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040be:	48 63 d0             	movslq %eax,%rdx
  8040c1:	48 89 d0             	mov    %rdx,%rax
  8040c4:	48 c1 e0 03          	shl    $0x3,%rax
  8040c8:	48 01 d0             	add    %rdx,%rax
  8040cb:	48 c1 e0 05          	shl    $0x5,%rax
  8040cf:	48 01 c8             	add    %rcx,%rax
  8040d2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040d8:	8b 40 08             	mov    0x8(%rax),%eax
  8040db:	eb 12                	jmp    8040ef <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8040dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040e1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040e8:	7e 99                	jle    804083 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8040ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040ef:	c9                   	leaveq 
  8040f0:	c3                   	retq   
  8040f1:	00 00                	add    %al,(%rax)
	...

00000000008040f4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040f4:	55                   	push   %rbp
  8040f5:	48 89 e5             	mov    %rsp,%rbp
  8040f8:	48 83 ec 18          	sub    $0x18,%rsp
  8040fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804104:	48 89 c2             	mov    %rax,%rdx
  804107:	48 c1 ea 15          	shr    $0x15,%rdx
  80410b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804112:	01 00 00 
  804115:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804119:	83 e0 01             	and    $0x1,%eax
  80411c:	48 85 c0             	test   %rax,%rax
  80411f:	75 07                	jne    804128 <pageref+0x34>
		return 0;
  804121:	b8 00 00 00 00       	mov    $0x0,%eax
  804126:	eb 53                	jmp    80417b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80412c:	48 89 c2             	mov    %rax,%rdx
  80412f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804133:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80413a:	01 00 00 
  80413d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804141:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804149:	83 e0 01             	and    $0x1,%eax
  80414c:	48 85 c0             	test   %rax,%rax
  80414f:	75 07                	jne    804158 <pageref+0x64>
		return 0;
  804151:	b8 00 00 00 00       	mov    $0x0,%eax
  804156:	eb 23                	jmp    80417b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80415c:	48 89 c2             	mov    %rax,%rdx
  80415f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804163:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80416a:	00 00 00 
  80416d:	48 c1 e2 04          	shl    $0x4,%rdx
  804171:	48 01 d0             	add    %rdx,%rax
  804174:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804178:	0f b7 c0             	movzwl %ax,%eax
}
  80417b:	c9                   	leaveq 
  80417c:	c3                   	retq   
