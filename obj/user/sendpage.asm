
obj/user/sendpage.debug:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;

	if ((who = fork()) == 0) {
  800053:	48 b8 63 20 80 00 00 	movabs $0x802063,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800065:	85 c0                	test   %eax,%eax
  800067:	0f 85 09 01 00 00    	jne    800176 <umain+0x132>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  80006d:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800071:	ba 00 00 00 00       	mov    $0x0,%edx
  800076:	be 00 00 b0 00       	mov    $0xb00000,%esi
  80007b:	48 89 c7             	mov    %rax,%rdi
  80007e:	48 b8 90 23 80 00 00 	movabs $0x802390,%rax
  800085:	00 00 00 
  800088:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  80008a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008d:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800092:	89 c6                	mov    %eax,%esi
  800094:	48 bf 6c 46 80 00 00 	movabs $0x80466c,%rdi
  80009b:	00 00 00 
  80009e:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a3:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  8000aa:	00 00 00 
  8000ad:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000af:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b6:	00 00 00 
  8000b9:	48 8b 00             	mov    (%rax),%rax
  8000bc:	48 89 c7             	mov    %rax,%rdi
  8000bf:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  8000c6:	00 00 00 
  8000c9:	ff d0                	callq  *%rax
  8000cb:	48 63 d0             	movslq %eax,%rdx
  8000ce:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d5:	00 00 00 
  8000d8:	48 8b 00             	mov    (%rax),%rax
  8000db:	48 89 c6             	mov    %rax,%rsi
  8000de:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e3:	48 b8 04 12 80 00 00 	movabs $0x801204,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	75 1b                	jne    80010e <umain+0xca>
			cprintf("child received correct message\n");
  8000f3:	48 bf 88 46 80 00 00 	movabs $0x804688,%rdi
  8000fa:	00 00 00 
  8000fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800102:	48 ba 97 04 80 00 00 	movabs $0x800497,%rdx
  800109:	00 00 00 
  80010c:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800115:	00 00 00 
  800118:	48 8b 00             	mov    (%rax),%rax
  80011b:	48 89 c7             	mov    %rax,%rdi
  80011e:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  800125:	00 00 00 
  800128:	ff d0                	callq  *%rax
  80012a:	83 c0 01             	add    $0x1,%eax
  80012d:	48 63 d0             	movslq %eax,%rdx
  800130:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800137:	00 00 00 
  80013a:	48 8b 00             	mov    (%rax),%rax
  80013d:	48 89 c6             	mov    %rax,%rsi
  800140:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800145:	48 b8 8d 14 80 00 00 	movabs $0x80148d,%rax
  80014c:	00 00 00 
  80014f:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800154:	b9 07 00 00 00       	mov    $0x7,%ecx
  800159:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015e:	be 00 00 00 00       	mov    $0x0,%esi
  800163:	89 c7                	mov    %eax,%edi
  800165:	48 b8 50 24 80 00 00 	movabs $0x802450,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		return;
  800171:	e9 30 01 00 00       	jmpq   8002a6 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800176:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80017d:	00 00 00 
  800180:	48 8b 00             	mov    (%rax),%rax
  800183:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800189:	ba 07 00 00 00       	mov    $0x7,%edx
  80018e:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800193:	89 c7                	mov    %eax,%edi
  800195:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a8:	00 00 00 
  8001ab:	48 8b 00             	mov    (%rax),%rax
  8001ae:	48 89 c7             	mov    %rax,%rdi
  8001b1:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
  8001bd:	83 c0 01             	add    $0x1,%eax
  8001c0:	48 63 d0             	movslq %eax,%rdx
  8001c3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001ca:	00 00 00 
  8001cd:	48 8b 00             	mov    (%rax),%rax
  8001d0:	48 89 c6             	mov    %rax,%rsi
  8001d3:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d8:	48 b8 8d 14 80 00 00 	movabs $0x80148d,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001ec:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 50 24 80 00 00 	movabs $0x802450,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800204:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800208:	ba 00 00 00 00       	mov    $0x0,%edx
  80020d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800212:	48 89 c7             	mov    %rax,%rdi
  800215:	48 b8 90 23 80 00 00 	movabs $0x802390,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800229:	89 c6                	mov    %eax,%esi
  80022b:	48 bf 6c 46 80 00 00 	movabs $0x80466c,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  800241:	00 00 00 
  800244:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800246:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80024d:	00 00 00 
  800250:	48 8b 00             	mov    (%rax),%rax
  800253:	48 89 c7             	mov    %rax,%rdi
  800256:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
  800262:	48 63 d0             	movslq %eax,%rdx
  800265:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80026c:	00 00 00 
  80026f:	48 8b 00             	mov    (%rax),%rax
  800272:	48 89 c6             	mov    %rax,%rsi
  800275:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  80027a:	48 b8 04 12 80 00 00 	movabs $0x801204,%rax
  800281:	00 00 00 
  800284:	ff d0                	callq  *%rax
  800286:	85 c0                	test   %eax,%eax
  800288:	75 1b                	jne    8002a5 <umain+0x261>
		cprintf("parent received correct message\n");
  80028a:	48 bf a8 46 80 00 00 	movabs $0x8046a8,%rdi
  800291:	00 00 00 
  800294:	b8 00 00 00 00       	mov    $0x0,%eax
  800299:	48 ba 97 04 80 00 00 	movabs $0x800497,%rdx
  8002a0:	00 00 00 
  8002a3:	ff d2                	callq  *%rdx
	return;
  8002a5:	90                   	nop
}
  8002a6:	c9                   	leaveq 
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002b7:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8002be:	00 00 00 
  8002c1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8002c8:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  8002cf:	00 00 00 
  8002d2:	ff d0                	callq  *%rax
  8002d4:	48 98                	cltq   
  8002d6:	48 89 c2             	mov    %rax,%rdx
  8002d9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8002df:	48 89 d0             	mov    %rdx,%rax
  8002e2:	48 c1 e0 03          	shl    $0x3,%rax
  8002e6:	48 01 d0             	add    %rdx,%rax
  8002e9:	48 c1 e0 05          	shl    $0x5,%rax
  8002ed:	48 89 c2             	mov    %rax,%rdx
  8002f0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002f7:	00 00 00 
  8002fa:	48 01 c2             	add    %rax,%rdx
  8002fd:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800304:	00 00 00 
  800307:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80030a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80030e:	7e 14                	jle    800324 <libmain+0x7c>
		binaryname = argv[0];
  800310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800314:	48 8b 10             	mov    (%rax),%rdx
  800317:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  80031e:	00 00 00 
  800321:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800324:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032b:	48 89 d6             	mov    %rdx,%rsi
  80032e:	89 c7                	mov    %eax,%edi
  800330:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800337:	00 00 00 
  80033a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80033c:	48 b8 4c 03 80 00 00 	movabs $0x80034c,%rax
  800343:	00 00 00 
  800346:	ff d0                	callq  *%rax
}
  800348:	c9                   	leaveq 
  800349:	c3                   	retq   
	...

000000000080034c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80034c:	55                   	push   %rbp
  80034d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800350:	48 b8 d9 28 80 00 00 	movabs $0x8028d9,%rax
  800357:	00 00 00 
  80035a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80035c:	bf 00 00 00 00       	mov    $0x0,%edi
  800361:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  800368:	00 00 00 
  80036b:	ff d0                	callq  *%rax
}
  80036d:	5d                   	pop    %rbp
  80036e:	c3                   	retq   
	...

0000000000800370 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800370:	55                   	push   %rbp
  800371:	48 89 e5             	mov    %rsp,%rbp
  800374:	48 83 ec 10          	sub    $0x10,%rsp
  800378:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80037b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80037f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800383:	8b 00                	mov    (%rax),%eax
  800385:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800388:	89 d6                	mov    %edx,%esi
  80038a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80038e:	48 63 d0             	movslq %eax,%rdx
  800391:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800396:	8d 50 01             	lea    0x1(%rax),%edx
  800399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039d:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80039f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a3:	8b 00                	mov    (%rax),%eax
  8003a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003aa:	75 2c                	jne    8003d8 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8003ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b0:	8b 00                	mov    (%rax),%eax
  8003b2:	48 98                	cltq   
  8003b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b8:	48 83 c2 08          	add    $0x8,%rdx
  8003bc:	48 89 c6             	mov    %rax,%rsi
  8003bf:	48 89 d7             	mov    %rdx,%rdi
  8003c2:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  8003c9:	00 00 00 
  8003cc:	ff d0                	callq  *%rax
		b->idx = 0;
  8003ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003dc:	8b 40 04             	mov    0x4(%rax),%eax
  8003df:	8d 50 01             	lea    0x1(%rax),%edx
  8003e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003e9:	c9                   	leaveq 
  8003ea:	c3                   	retq   

00000000008003eb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
  8003ef:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003f6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003fd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800404:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80040b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800412:	48 8b 0a             	mov    (%rdx),%rcx
  800415:	48 89 08             	mov    %rcx,(%rax)
  800418:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80041c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800420:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800424:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800428:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80042f:	00 00 00 
	b.cnt = 0;
  800432:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800439:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80043c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800443:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80044a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800451:	48 89 c6             	mov    %rax,%rsi
  800454:	48 bf 70 03 80 00 00 	movabs $0x800370,%rdi
  80045b:	00 00 00 
  80045e:	48 b8 48 08 80 00 00 	movabs $0x800848,%rax
  800465:	00 00 00 
  800468:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80046a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800470:	48 98                	cltq   
  800472:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800479:	48 83 c2 08          	add    $0x8,%rdx
  80047d:	48 89 c6             	mov    %rax,%rsi
  800480:	48 89 d7             	mov    %rdx,%rdi
  800483:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  80048a:	00 00 00 
  80048d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80048f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800495:	c9                   	leaveq 
  800496:	c3                   	retq   

0000000000800497 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800497:	55                   	push   %rbp
  800498:	48 89 e5             	mov    %rsp,%rbp
  80049b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004a2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004a9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004b0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004b7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004be:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004c5:	84 c0                	test   %al,%al
  8004c7:	74 20                	je     8004e9 <cprintf+0x52>
  8004c9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004cd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004d5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004d9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004dd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004e5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004e9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004f0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004f7:	00 00 00 
  8004fa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800501:	00 00 00 
  800504:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800508:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80050f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800516:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80051d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800524:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80052b:	48 8b 0a             	mov    (%rdx),%rcx
  80052e:	48 89 08             	mov    %rcx,(%rax)
  800531:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800535:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800539:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80053d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800541:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800548:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80054f:	48 89 d6             	mov    %rdx,%rsi
  800552:	48 89 c7             	mov    %rax,%rdi
  800555:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  80055c:	00 00 00 
  80055f:	ff d0                	callq  *%rax
  800561:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800567:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80056d:	c9                   	leaveq 
  80056e:	c3                   	retq   
	...

0000000000800570 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800570:	55                   	push   %rbp
  800571:	48 89 e5             	mov    %rsp,%rbp
  800574:	48 83 ec 30          	sub    $0x30,%rsp
  800578:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80057c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800580:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800584:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800587:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80058b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800592:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800596:	77 52                	ja     8005ea <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800598:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80059b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80059f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005a2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8005a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	48 f7 75 d0          	divq   -0x30(%rbp)
  8005b3:	48 89 c2             	mov    %rax,%rdx
  8005b6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8005b9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005bc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005c4:	41 89 f9             	mov    %edi,%r9d
  8005c7:	48 89 c7             	mov    %rax,%rdi
  8005ca:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  8005d1:	00 00 00 
  8005d4:	ff d0                	callq  *%rax
  8005d6:	eb 1c                	jmp    8005f4 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005dc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8005df:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8005e3:	48 89 d6             	mov    %rdx,%rsi
  8005e6:	89 c7                	mov    %eax,%edi
  8005e8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ea:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005f2:	7f e4                	jg     8005d8 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800600:	48 f7 f1             	div    %rcx
  800603:	48 89 d0             	mov    %rdx,%rax
  800606:	48 ba a8 48 80 00 00 	movabs $0x8048a8,%rdx
  80060d:	00 00 00 
  800610:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800614:	0f be c0             	movsbl %al,%eax
  800617:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80061b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80061f:	48 89 d6             	mov    %rdx,%rsi
  800622:	89 c7                	mov    %eax,%edi
  800624:	ff d1                	callq  *%rcx
}
  800626:	c9                   	leaveq 
  800627:	c3                   	retq   

0000000000800628 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800628:	55                   	push   %rbp
  800629:	48 89 e5             	mov    %rsp,%rbp
  80062c:	48 83 ec 20          	sub    $0x20,%rsp
  800630:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800634:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800637:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80063b:	7e 52                	jle    80068f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	8b 00                	mov    (%rax),%eax
  800643:	83 f8 30             	cmp    $0x30,%eax
  800646:	73 24                	jae    80066c <getuint+0x44>
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	8b 00                	mov    (%rax),%eax
  800656:	89 c0                	mov    %eax,%eax
  800658:	48 01 d0             	add    %rdx,%rax
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	8b 12                	mov    (%rdx),%edx
  800661:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800668:	89 0a                	mov    %ecx,(%rdx)
  80066a:	eb 17                	jmp    800683 <getuint+0x5b>
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800674:	48 89 d0             	mov    %rdx,%rax
  800677:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800683:	48 8b 00             	mov    (%rax),%rax
  800686:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068a:	e9 a3 00 00 00       	jmpq   800732 <getuint+0x10a>
	else if (lflag)
  80068f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800693:	74 4f                	je     8006e4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800699:	8b 00                	mov    (%rax),%eax
  80069b:	83 f8 30             	cmp    $0x30,%eax
  80069e:	73 24                	jae    8006c4 <getuint+0x9c>
  8006a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	8b 00                	mov    (%rax),%eax
  8006ae:	89 c0                	mov    %eax,%eax
  8006b0:	48 01 d0             	add    %rdx,%rax
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	8b 12                	mov    (%rdx),%edx
  8006b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	89 0a                	mov    %ecx,(%rdx)
  8006c2:	eb 17                	jmp    8006db <getuint+0xb3>
  8006c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cc:	48 89 d0             	mov    %rdx,%rax
  8006cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006db:	48 8b 00             	mov    (%rax),%rax
  8006de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e2:	eb 4e                	jmp    800732 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	8b 00                	mov    (%rax),%eax
  8006ea:	83 f8 30             	cmp    $0x30,%eax
  8006ed:	73 24                	jae    800713 <getuint+0xeb>
  8006ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fb:	8b 00                	mov    (%rax),%eax
  8006fd:	89 c0                	mov    %eax,%eax
  8006ff:	48 01 d0             	add    %rdx,%rax
  800702:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800706:	8b 12                	mov    (%rdx),%edx
  800708:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070f:	89 0a                	mov    %ecx,(%rdx)
  800711:	eb 17                	jmp    80072a <getuint+0x102>
  800713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800717:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071b:	48 89 d0             	mov    %rdx,%rax
  80071e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800722:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800726:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072a:	8b 00                	mov    (%rax),%eax
  80072c:	89 c0                	mov    %eax,%eax
  80072e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800732:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800736:	c9                   	leaveq 
  800737:	c3                   	retq   

0000000000800738 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800738:	55                   	push   %rbp
  800739:	48 89 e5             	mov    %rsp,%rbp
  80073c:	48 83 ec 20          	sub    $0x20,%rsp
  800740:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800744:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800747:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80074b:	7e 52                	jle    80079f <getint+0x67>
		x=va_arg(*ap, long long);
  80074d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800751:	8b 00                	mov    (%rax),%eax
  800753:	83 f8 30             	cmp    $0x30,%eax
  800756:	73 24                	jae    80077c <getint+0x44>
  800758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	8b 00                	mov    (%rax),%eax
  800766:	89 c0                	mov    %eax,%eax
  800768:	48 01 d0             	add    %rdx,%rax
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	8b 12                	mov    (%rdx),%edx
  800771:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	89 0a                	mov    %ecx,(%rdx)
  80077a:	eb 17                	jmp    800793 <getint+0x5b>
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800784:	48 89 d0             	mov    %rdx,%rax
  800787:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800793:	48 8b 00             	mov    (%rax),%rax
  800796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80079a:	e9 a3 00 00 00       	jmpq   800842 <getint+0x10a>
	else if (lflag)
  80079f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007a3:	74 4f                	je     8007f4 <getint+0xbc>
		x=va_arg(*ap, long);
  8007a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a9:	8b 00                	mov    (%rax),%eax
  8007ab:	83 f8 30             	cmp    $0x30,%eax
  8007ae:	73 24                	jae    8007d4 <getint+0x9c>
  8007b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	8b 00                	mov    (%rax),%eax
  8007be:	89 c0                	mov    %eax,%eax
  8007c0:	48 01 d0             	add    %rdx,%rax
  8007c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c7:	8b 12                	mov    (%rdx),%edx
  8007c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d0:	89 0a                	mov    %ecx,(%rdx)
  8007d2:	eb 17                	jmp    8007eb <getint+0xb3>
  8007d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007dc:	48 89 d0             	mov    %rdx,%rax
  8007df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007eb:	48 8b 00             	mov    (%rax),%rax
  8007ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f2:	eb 4e                	jmp    800842 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	8b 00                	mov    (%rax),%eax
  8007fa:	83 f8 30             	cmp    $0x30,%eax
  8007fd:	73 24                	jae    800823 <getint+0xeb>
  8007ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800803:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080b:	8b 00                	mov    (%rax),%eax
  80080d:	89 c0                	mov    %eax,%eax
  80080f:	48 01 d0             	add    %rdx,%rax
  800812:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800816:	8b 12                	mov    (%rdx),%edx
  800818:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80081b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081f:	89 0a                	mov    %ecx,(%rdx)
  800821:	eb 17                	jmp    80083a <getint+0x102>
  800823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800827:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80082b:	48 89 d0             	mov    %rdx,%rax
  80082e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083a:	8b 00                	mov    (%rax),%eax
  80083c:	48 98                	cltq   
  80083e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800842:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800846:	c9                   	leaveq 
  800847:	c3                   	retq   

0000000000800848 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800848:	55                   	push   %rbp
  800849:	48 89 e5             	mov    %rsp,%rbp
  80084c:	41 54                	push   %r12
  80084e:	53                   	push   %rbx
  80084f:	48 83 ec 60          	sub    $0x60,%rsp
  800853:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800857:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80085b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80085f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800863:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800867:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80086b:	48 8b 0a             	mov    (%rdx),%rcx
  80086e:	48 89 08             	mov    %rcx,(%rax)
  800871:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800875:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800879:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80087d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800881:	eb 17                	jmp    80089a <vprintfmt+0x52>
			if (ch == '\0')
  800883:	85 db                	test   %ebx,%ebx
  800885:	0f 84 d7 04 00 00    	je     800d62 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  80088b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80088f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800893:	48 89 c6             	mov    %rax,%rsi
  800896:	89 df                	mov    %ebx,%edi
  800898:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80089e:	0f b6 00             	movzbl (%rax),%eax
  8008a1:	0f b6 d8             	movzbl %al,%ebx
  8008a4:	83 fb 25             	cmp    $0x25,%ebx
  8008a7:	0f 95 c0             	setne  %al
  8008aa:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008af:	84 c0                	test   %al,%al
  8008b1:	75 d0                	jne    800883 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008b7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008be:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008cc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8008d3:	eb 04                	jmp    8008d9 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8008d5:	90                   	nop
  8008d6:	eb 01                	jmp    8008d9 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8008d8:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008dd:	0f b6 00             	movzbl (%rax),%eax
  8008e0:	0f b6 d8             	movzbl %al,%ebx
  8008e3:	89 d8                	mov    %ebx,%eax
  8008e5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008ea:	83 e8 23             	sub    $0x23,%eax
  8008ed:	83 f8 55             	cmp    $0x55,%eax
  8008f0:	0f 87 38 04 00 00    	ja     800d2e <vprintfmt+0x4e6>
  8008f6:	89 c0                	mov    %eax,%eax
  8008f8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ff:	00 
  800900:	48 b8 d0 48 80 00 00 	movabs $0x8048d0,%rax
  800907:	00 00 00 
  80090a:	48 01 d0             	add    %rdx,%rax
  80090d:	48 8b 00             	mov    (%rax),%rax
  800910:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800912:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800916:	eb c1                	jmp    8008d9 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800918:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80091c:	eb bb                	jmp    8008d9 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800925:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800928:	89 d0                	mov    %edx,%eax
  80092a:	c1 e0 02             	shl    $0x2,%eax
  80092d:	01 d0                	add    %edx,%eax
  80092f:	01 c0                	add    %eax,%eax
  800931:	01 d8                	add    %ebx,%eax
  800933:	83 e8 30             	sub    $0x30,%eax
  800936:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800939:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093d:	0f b6 00             	movzbl (%rax),%eax
  800940:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800943:	83 fb 2f             	cmp    $0x2f,%ebx
  800946:	7e 63                	jle    8009ab <vprintfmt+0x163>
  800948:	83 fb 39             	cmp    $0x39,%ebx
  80094b:	7f 5e                	jg     8009ab <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800952:	eb d1                	jmp    800925 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800954:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800957:	83 f8 30             	cmp    $0x30,%eax
  80095a:	73 17                	jae    800973 <vprintfmt+0x12b>
  80095c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800960:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800963:	89 c0                	mov    %eax,%eax
  800965:	48 01 d0             	add    %rdx,%rax
  800968:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096b:	83 c2 08             	add    $0x8,%edx
  80096e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800971:	eb 0f                	jmp    800982 <vprintfmt+0x13a>
  800973:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800977:	48 89 d0             	mov    %rdx,%rax
  80097a:	48 83 c2 08          	add    $0x8,%rdx
  80097e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800982:	8b 00                	mov    (%rax),%eax
  800984:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800987:	eb 23                	jmp    8009ac <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800989:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098d:	0f 89 42 ff ff ff    	jns    8008d5 <vprintfmt+0x8d>
				width = 0;
  800993:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80099a:	e9 36 ff ff ff       	jmpq   8008d5 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  80099f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009a6:	e9 2e ff ff ff       	jmpq   8008d9 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009ab:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b0:	0f 89 22 ff ff ff    	jns    8008d8 <vprintfmt+0x90>
				width = precision, precision = -1;
  8009b6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009c3:	e9 10 ff ff ff       	jmpq   8008d8 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009cc:	e9 08 ff ff ff       	jmpq   8008d9 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d4:	83 f8 30             	cmp    $0x30,%eax
  8009d7:	73 17                	jae    8009f0 <vprintfmt+0x1a8>
  8009d9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e0:	89 c0                	mov    %eax,%eax
  8009e2:	48 01 d0             	add    %rdx,%rax
  8009e5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e8:	83 c2 08             	add    $0x8,%edx
  8009eb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009ee:	eb 0f                	jmp    8009ff <vprintfmt+0x1b7>
  8009f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f4:	48 89 d0             	mov    %rdx,%rax
  8009f7:	48 83 c2 08          	add    $0x8,%rdx
  8009fb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ff:	8b 00                	mov    (%rax),%eax
  800a01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a05:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a09:	48 89 d6             	mov    %rdx,%rsi
  800a0c:	89 c7                	mov    %eax,%edi
  800a0e:	ff d1                	callq  *%rcx
			break;
  800a10:	e9 47 03 00 00       	jmpq   800d5c <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a18:	83 f8 30             	cmp    $0x30,%eax
  800a1b:	73 17                	jae    800a34 <vprintfmt+0x1ec>
  800a1d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a24:	89 c0                	mov    %eax,%eax
  800a26:	48 01 d0             	add    %rdx,%rax
  800a29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2c:	83 c2 08             	add    $0x8,%edx
  800a2f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a32:	eb 0f                	jmp    800a43 <vprintfmt+0x1fb>
  800a34:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a38:	48 89 d0             	mov    %rdx,%rax
  800a3b:	48 83 c2 08          	add    $0x8,%rdx
  800a3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a43:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a45:	85 db                	test   %ebx,%ebx
  800a47:	79 02                	jns    800a4b <vprintfmt+0x203>
				err = -err;
  800a49:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a4b:	83 fb 10             	cmp    $0x10,%ebx
  800a4e:	7f 16                	jg     800a66 <vprintfmt+0x21e>
  800a50:	48 b8 20 48 80 00 00 	movabs $0x804820,%rax
  800a57:	00 00 00 
  800a5a:	48 63 d3             	movslq %ebx,%rdx
  800a5d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a61:	4d 85 e4             	test   %r12,%r12
  800a64:	75 2e                	jne    800a94 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800a66:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6e:	89 d9                	mov    %ebx,%ecx
  800a70:	48 ba b9 48 80 00 00 	movabs $0x8048b9,%rdx
  800a77:	00 00 00 
  800a7a:	48 89 c7             	mov    %rax,%rdi
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a82:	49 b8 6c 0d 80 00 00 	movabs $0x800d6c,%r8
  800a89:	00 00 00 
  800a8c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a8f:	e9 c8 02 00 00       	jmpq   800d5c <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a94:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9c:	4c 89 e1             	mov    %r12,%rcx
  800a9f:	48 ba c2 48 80 00 00 	movabs $0x8048c2,%rdx
  800aa6:	00 00 00 
  800aa9:	48 89 c7             	mov    %rax,%rdi
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab1:	49 b8 6c 0d 80 00 00 	movabs $0x800d6c,%r8
  800ab8:	00 00 00 
  800abb:	41 ff d0             	callq  *%r8
			break;
  800abe:	e9 99 02 00 00       	jmpq   800d5c <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ac3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac6:	83 f8 30             	cmp    $0x30,%eax
  800ac9:	73 17                	jae    800ae2 <vprintfmt+0x29a>
  800acb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800acf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad2:	89 c0                	mov    %eax,%eax
  800ad4:	48 01 d0             	add    %rdx,%rax
  800ad7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ada:	83 c2 08             	add    $0x8,%edx
  800add:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae0:	eb 0f                	jmp    800af1 <vprintfmt+0x2a9>
  800ae2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae6:	48 89 d0             	mov    %rdx,%rax
  800ae9:	48 83 c2 08          	add    $0x8,%rdx
  800aed:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af1:	4c 8b 20             	mov    (%rax),%r12
  800af4:	4d 85 e4             	test   %r12,%r12
  800af7:	75 0a                	jne    800b03 <vprintfmt+0x2bb>
				p = "(null)";
  800af9:	49 bc c5 48 80 00 00 	movabs $0x8048c5,%r12
  800b00:	00 00 00 
			if (width > 0 && padc != '-')
  800b03:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b07:	7e 7a                	jle    800b83 <vprintfmt+0x33b>
  800b09:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b0d:	74 74                	je     800b83 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b12:	48 98                	cltq   
  800b14:	48 89 c6             	mov    %rax,%rsi
  800b17:	4c 89 e7             	mov    %r12,%rdi
  800b1a:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  800b21:	00 00 00 
  800b24:	ff d0                	callq  *%rax
  800b26:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b29:	eb 17                	jmp    800b42 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800b2b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800b2f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b33:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b37:	48 89 d6             	mov    %rdx,%rsi
  800b3a:	89 c7                	mov    %eax,%edi
  800b3c:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b42:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b46:	7f e3                	jg     800b2b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b48:	eb 39                	jmp    800b83 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b4e:	74 1e                	je     800b6e <vprintfmt+0x326>
  800b50:	83 fb 1f             	cmp    $0x1f,%ebx
  800b53:	7e 05                	jle    800b5a <vprintfmt+0x312>
  800b55:	83 fb 7e             	cmp    $0x7e,%ebx
  800b58:	7e 14                	jle    800b6e <vprintfmt+0x326>
					putch('?', putdat);
  800b5a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b5e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b62:	48 89 c6             	mov    %rax,%rsi
  800b65:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b6a:	ff d2                	callq  *%rdx
  800b6c:	eb 0f                	jmp    800b7d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800b6e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b72:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b76:	48 89 c6             	mov    %rax,%rsi
  800b79:	89 df                	mov    %ebx,%edi
  800b7b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b81:	eb 01                	jmp    800b84 <vprintfmt+0x33c>
  800b83:	90                   	nop
  800b84:	41 0f b6 04 24       	movzbl (%r12),%eax
  800b89:	0f be d8             	movsbl %al,%ebx
  800b8c:	85 db                	test   %ebx,%ebx
  800b8e:	0f 95 c0             	setne  %al
  800b91:	49 83 c4 01          	add    $0x1,%r12
  800b95:	84 c0                	test   %al,%al
  800b97:	74 28                	je     800bc1 <vprintfmt+0x379>
  800b99:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9d:	78 ab                	js     800b4a <vprintfmt+0x302>
  800b9f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ba3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba7:	79 a1                	jns    800b4a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba9:	eb 16                	jmp    800bc1 <vprintfmt+0x379>
				putch(' ', putdat);
  800bab:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800baf:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bb3:	48 89 c6             	mov    %rax,%rsi
  800bb6:	bf 20 00 00 00       	mov    $0x20,%edi
  800bbb:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc5:	7f e4                	jg     800bab <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800bc7:	e9 90 01 00 00       	jmpq   800d5c <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bcc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd0:	be 03 00 00 00       	mov    $0x3,%esi
  800bd5:	48 89 c7             	mov    %rax,%rdi
  800bd8:	48 b8 38 07 80 00 00 	movabs $0x800738,%rax
  800bdf:	00 00 00 
  800be2:	ff d0                	callq  *%rax
  800be4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bec:	48 85 c0             	test   %rax,%rax
  800bef:	79 1d                	jns    800c0e <vprintfmt+0x3c6>
				putch('-', putdat);
  800bf1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bf5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bf9:	48 89 c6             	mov    %rax,%rsi
  800bfc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c01:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c07:	48 f7 d8             	neg    %rax
  800c0a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c0e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c15:	e9 d5 00 00 00       	jmpq   800cef <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c1a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1e:	be 03 00 00 00       	mov    $0x3,%esi
  800c23:	48 89 c7             	mov    %rax,%rdi
  800c26:	48 b8 28 06 80 00 00 	movabs $0x800628,%rax
  800c2d:	00 00 00 
  800c30:	ff d0                	callq  *%rax
  800c32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c36:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c3d:	e9 ad 00 00 00       	jmpq   800cef <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800c42:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c46:	be 03 00 00 00       	mov    $0x3,%esi
  800c4b:	48 89 c7             	mov    %rax,%rdi
  800c4e:	48 b8 28 06 80 00 00 	movabs $0x800628,%rax
  800c55:	00 00 00 
  800c58:	ff d0                	callq  *%rax
  800c5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800c5e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c65:	e9 85 00 00 00       	jmpq   800cef <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800c6a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c6e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c72:	48 89 c6             	mov    %rax,%rsi
  800c75:	bf 30 00 00 00       	mov    $0x30,%edi
  800c7a:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800c7c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c80:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c84:	48 89 c6             	mov    %rax,%rsi
  800c87:	bf 78 00 00 00       	mov    $0x78,%edi
  800c8c:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c91:	83 f8 30             	cmp    $0x30,%eax
  800c94:	73 17                	jae    800cad <vprintfmt+0x465>
  800c96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9d:	89 c0                	mov    %eax,%eax
  800c9f:	48 01 d0             	add    %rdx,%rax
  800ca2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca5:	83 c2 08             	add    $0x8,%edx
  800ca8:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cab:	eb 0f                	jmp    800cbc <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800cad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb1:	48 89 d0             	mov    %rdx,%rax
  800cb4:	48 83 c2 08          	add    $0x8,%rdx
  800cb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbc:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cc3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cca:	eb 23                	jmp    800cef <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ccc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd0:	be 03 00 00 00       	mov    $0x3,%esi
  800cd5:	48 89 c7             	mov    %rax,%rdi
  800cd8:	48 b8 28 06 80 00 00 	movabs $0x800628,%rax
  800cdf:	00 00 00 
  800ce2:	ff d0                	callq  *%rax
  800ce4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ce8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cef:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cf4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cf7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cfa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d06:	45 89 c1             	mov    %r8d,%r9d
  800d09:	41 89 f8             	mov    %edi,%r8d
  800d0c:	48 89 c7             	mov    %rax,%rdi
  800d0f:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	callq  *%rax
			break;
  800d1b:	eb 3f                	jmp    800d5c <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d21:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d25:	48 89 c6             	mov    %rax,%rsi
  800d28:	89 df                	mov    %ebx,%edi
  800d2a:	ff d2                	callq  *%rdx
			break;
  800d2c:	eb 2e                	jmp    800d5c <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d32:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d36:	48 89 c6             	mov    %rax,%rsi
  800d39:	bf 25 00 00 00       	mov    $0x25,%edi
  800d3e:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d40:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d45:	eb 05                	jmp    800d4c <vprintfmt+0x504>
  800d47:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d4c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d50:	48 83 e8 01          	sub    $0x1,%rax
  800d54:	0f b6 00             	movzbl (%rax),%eax
  800d57:	3c 25                	cmp    $0x25,%al
  800d59:	75 ec                	jne    800d47 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800d5b:	90                   	nop
		}
	}
  800d5c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d5d:	e9 38 fb ff ff       	jmpq   80089a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800d62:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800d63:	48 83 c4 60          	add    $0x60,%rsp
  800d67:	5b                   	pop    %rbx
  800d68:	41 5c                	pop    %r12
  800d6a:	5d                   	pop    %rbp
  800d6b:	c3                   	retq   

0000000000800d6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6c:	55                   	push   %rbp
  800d6d:	48 89 e5             	mov    %rsp,%rbp
  800d70:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d77:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d7e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d85:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d8c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d93:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d9a:	84 c0                	test   %al,%al
  800d9c:	74 20                	je     800dbe <printfmt+0x52>
  800d9e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800da2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800da6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800daa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800db2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800db6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dbe:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dc5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dcc:	00 00 00 
  800dcf:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dd6:	00 00 00 
  800dd9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ddd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800de4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800deb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800df2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800df9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e00:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e07:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e0e:	48 89 c7             	mov    %rax,%rdi
  800e11:	48 b8 48 08 80 00 00 	movabs $0x800848,%rax
  800e18:	00 00 00 
  800e1b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e1d:	c9                   	leaveq 
  800e1e:	c3                   	retq   

0000000000800e1f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e1f:	55                   	push   %rbp
  800e20:	48 89 e5             	mov    %rsp,%rbp
  800e23:	48 83 ec 10          	sub    $0x10,%rsp
  800e27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e32:	8b 40 10             	mov    0x10(%rax),%eax
  800e35:	8d 50 01             	lea    0x1(%rax),%edx
  800e38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e43:	48 8b 10             	mov    (%rax),%rdx
  800e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e4e:	48 39 c2             	cmp    %rax,%rdx
  800e51:	73 17                	jae    800e6a <sprintputch+0x4b>
		*b->buf++ = ch;
  800e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e57:	48 8b 00             	mov    (%rax),%rax
  800e5a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e5d:	88 10                	mov    %dl,(%rax)
  800e5f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e67:	48 89 10             	mov    %rdx,(%rax)
}
  800e6a:	c9                   	leaveq 
  800e6b:	c3                   	retq   

0000000000800e6c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e6c:	55                   	push   %rbp
  800e6d:	48 89 e5             	mov    %rsp,%rbp
  800e70:	48 83 ec 50          	sub    $0x50,%rsp
  800e74:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e78:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e7b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e7f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e83:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e87:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e8b:	48 8b 0a             	mov    (%rdx),%rcx
  800e8e:	48 89 08             	mov    %rcx,(%rax)
  800e91:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e95:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e99:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e9d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ea9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eac:	48 98                	cltq   
  800eae:	48 83 e8 01          	sub    $0x1,%rax
  800eb2:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800eb6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ec1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ec6:	74 06                	je     800ece <vsnprintf+0x62>
  800ec8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ecc:	7f 07                	jg     800ed5 <vsnprintf+0x69>
		return -E_INVAL;
  800ece:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed3:	eb 2f                	jmp    800f04 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ed5:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ed9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800edd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ee1:	48 89 c6             	mov    %rax,%rsi
  800ee4:	48 bf 1f 0e 80 00 00 	movabs $0x800e1f,%rdi
  800eeb:	00 00 00 
  800eee:	48 b8 48 08 80 00 00 	movabs $0x800848,%rax
  800ef5:	00 00 00 
  800ef8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800efa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800efe:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f01:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f04:	c9                   	leaveq 
  800f05:	c3                   	retq   

0000000000800f06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f06:	55                   	push   %rbp
  800f07:	48 89 e5             	mov    %rsp,%rbp
  800f0a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f11:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f18:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f1e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f25:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f2c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f33:	84 c0                	test   %al,%al
  800f35:	74 20                	je     800f57 <snprintf+0x51>
  800f37:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f3b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f3f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f43:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f47:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f4b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f4f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f53:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f57:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f5e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f65:	00 00 00 
  800f68:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f6f:	00 00 00 
  800f72:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f76:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f7d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f84:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f8b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f92:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f99:	48 8b 0a             	mov    (%rdx),%rcx
  800f9c:	48 89 08             	mov    %rcx,(%rax)
  800f9f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fa3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fa7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fab:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800faf:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fb6:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fbd:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fc3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fca:	48 89 c7             	mov    %rax,%rdi
  800fcd:	48 b8 6c 0e 80 00 00 	movabs $0x800e6c,%rax
  800fd4:	00 00 00 
  800fd7:	ff d0                	callq  *%rax
  800fd9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fdf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fe5:	c9                   	leaveq 
  800fe6:	c3                   	retq   
	...

0000000000800fe8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fe8:	55                   	push   %rbp
  800fe9:	48 89 e5             	mov    %rsp,%rbp
  800fec:	48 83 ec 18          	sub    $0x18,%rsp
  800ff0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ffb:	eb 09                	jmp    801006 <strlen+0x1e>
		n++;
  800ffd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801001:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801006:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100a:	0f b6 00             	movzbl (%rax),%eax
  80100d:	84 c0                	test   %al,%al
  80100f:	75 ec                	jne    800ffd <strlen+0x15>
		n++;
	return n;
  801011:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801014:	c9                   	leaveq 
  801015:	c3                   	retq   

0000000000801016 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801016:	55                   	push   %rbp
  801017:	48 89 e5             	mov    %rsp,%rbp
  80101a:	48 83 ec 20          	sub    $0x20,%rsp
  80101e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801022:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801026:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102d:	eb 0e                	jmp    80103d <strnlen+0x27>
		n++;
  80102f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801033:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801038:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80103d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801042:	74 0b                	je     80104f <strnlen+0x39>
  801044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801048:	0f b6 00             	movzbl (%rax),%eax
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e0                	jne    80102f <strnlen+0x19>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801052:	c9                   	leaveq 
  801053:	c3                   	retq   

0000000000801054 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801054:	55                   	push   %rbp
  801055:	48 89 e5             	mov    %rsp,%rbp
  801058:	48 83 ec 20          	sub    $0x20,%rsp
  80105c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801060:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801068:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80106c:	90                   	nop
  80106d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801071:	0f b6 10             	movzbl (%rax),%edx
  801074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801078:	88 10                	mov    %dl,(%rax)
  80107a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107e:	0f b6 00             	movzbl (%rax),%eax
  801081:	84 c0                	test   %al,%al
  801083:	0f 95 c0             	setne  %al
  801086:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80108b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801090:	84 c0                	test   %al,%al
  801092:	75 d9                	jne    80106d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801098:	c9                   	leaveq 
  801099:	c3                   	retq   

000000000080109a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80109a:	55                   	push   %rbp
  80109b:	48 89 e5             	mov    %rsp,%rbp
  80109e:	48 83 ec 20          	sub    $0x20,%rsp
  8010a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	48 89 c7             	mov    %rax,%rdi
  8010b1:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  8010b8:	00 00 00 
  8010bb:	ff d0                	callq  *%rax
  8010bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c3:	48 98                	cltq   
  8010c5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8010c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010cd:	48 89 d6             	mov    %rdx,%rsi
  8010d0:	48 89 c7             	mov    %rax,%rdi
  8010d3:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  8010da:	00 00 00 
  8010dd:	ff d0                	callq  *%rax
	return dst;
  8010df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 28          	sub    $0x28,%rsp
  8010ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801101:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801108:	00 
  801109:	eb 27                	jmp    801132 <strncpy+0x4d>
		*dst++ = *src;
  80110b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110f:	0f b6 10             	movzbl (%rax),%edx
  801112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801116:	88 10                	mov    %dl,(%rax)
  801118:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80111d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801121:	0f b6 00             	movzbl (%rax),%eax
  801124:	84 c0                	test   %al,%al
  801126:	74 05                	je     80112d <strncpy+0x48>
			src++;
  801128:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80112d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801136:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80113a:	72 cf                	jb     80110b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80113c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 28          	sub    $0x28,%rsp
  80114a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801152:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80115e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801163:	74 37                	je     80119c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801165:	eb 17                	jmp    80117e <strlcpy+0x3c>
			*dst++ = *src++;
  801167:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116b:	0f b6 10             	movzbl (%rax),%edx
  80116e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801172:	88 10                	mov    %dl,(%rax)
  801174:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801179:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80117e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801183:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801188:	74 0b                	je     801195 <strlcpy+0x53>
  80118a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80118e:	0f b6 00             	movzbl (%rax),%eax
  801191:	84 c0                	test   %al,%al
  801193:	75 d2                	jne    801167 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80119c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a4:	48 89 d1             	mov    %rdx,%rcx
  8011a7:	48 29 c1             	sub    %rax,%rcx
  8011aa:	48 89 c8             	mov    %rcx,%rax
}
  8011ad:	c9                   	leaveq 
  8011ae:	c3                   	retq   

00000000008011af <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	48 83 ec 10          	sub    $0x10,%rsp
  8011b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011bf:	eb 0a                	jmp    8011cb <strcmp+0x1c>
		p++, q++;
  8011c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cf:	0f b6 00             	movzbl (%rax),%eax
  8011d2:	84 c0                	test   %al,%al
  8011d4:	74 12                	je     8011e8 <strcmp+0x39>
  8011d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011da:	0f b6 10             	movzbl (%rax),%edx
  8011dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e1:	0f b6 00             	movzbl (%rax),%eax
  8011e4:	38 c2                	cmp    %al,%dl
  8011e6:	74 d9                	je     8011c1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ec:	0f b6 00             	movzbl (%rax),%eax
  8011ef:	0f b6 d0             	movzbl %al,%edx
  8011f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f6:	0f b6 00             	movzbl (%rax),%eax
  8011f9:	0f b6 c0             	movzbl %al,%eax
  8011fc:	89 d1                	mov    %edx,%ecx
  8011fe:	29 c1                	sub    %eax,%ecx
  801200:	89 c8                	mov    %ecx,%eax
}
  801202:	c9                   	leaveq 
  801203:	c3                   	retq   

0000000000801204 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801204:	55                   	push   %rbp
  801205:	48 89 e5             	mov    %rsp,%rbp
  801208:	48 83 ec 18          	sub    $0x18,%rsp
  80120c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801210:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801214:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801218:	eb 0f                	jmp    801229 <strncmp+0x25>
		n--, p++, q++;
  80121a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80121f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801224:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801229:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80122e:	74 1d                	je     80124d <strncmp+0x49>
  801230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801234:	0f b6 00             	movzbl (%rax),%eax
  801237:	84 c0                	test   %al,%al
  801239:	74 12                	je     80124d <strncmp+0x49>
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	0f b6 10             	movzbl (%rax),%edx
  801242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801246:	0f b6 00             	movzbl (%rax),%eax
  801249:	38 c2                	cmp    %al,%dl
  80124b:	74 cd                	je     80121a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80124d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801252:	75 07                	jne    80125b <strncmp+0x57>
		return 0;
  801254:	b8 00 00 00 00       	mov    $0x0,%eax
  801259:	eb 1a                	jmp    801275 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	0f b6 d0             	movzbl %al,%edx
  801265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801269:	0f b6 00             	movzbl (%rax),%eax
  80126c:	0f b6 c0             	movzbl %al,%eax
  80126f:	89 d1                	mov    %edx,%ecx
  801271:	29 c1                	sub    %eax,%ecx
  801273:	89 c8                	mov    %ecx,%eax
}
  801275:	c9                   	leaveq 
  801276:	c3                   	retq   

0000000000801277 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801277:	55                   	push   %rbp
  801278:	48 89 e5             	mov    %rsp,%rbp
  80127b:	48 83 ec 10          	sub    $0x10,%rsp
  80127f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801283:	89 f0                	mov    %esi,%eax
  801285:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801288:	eb 17                	jmp    8012a1 <strchr+0x2a>
		if (*s == c)
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801294:	75 06                	jne    80129c <strchr+0x25>
			return (char *) s;
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	eb 15                	jmp    8012b1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80129c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a5:	0f b6 00             	movzbl (%rax),%eax
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 de                	jne    80128a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b1:	c9                   	leaveq 
  8012b2:	c3                   	retq   

00000000008012b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	48 83 ec 10          	sub    $0x10,%rsp
  8012bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012c4:	eb 11                	jmp    8012d7 <strfind+0x24>
		if (*s == c)
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d0:	74 12                	je     8012e4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 00             	movzbl (%rax),%eax
  8012de:	84 c0                	test   %al,%al
  8012e0:	75 e4                	jne    8012c6 <strfind+0x13>
  8012e2:	eb 01                	jmp    8012e5 <strfind+0x32>
		if (*s == c)
			break;
  8012e4:	90                   	nop
	return (char *) s;
  8012e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e9:	c9                   	leaveq 
  8012ea:	c3                   	retq   

00000000008012eb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012eb:	55                   	push   %rbp
  8012ec:	48 89 e5             	mov    %rsp,%rbp
  8012ef:	48 83 ec 18          	sub    $0x18,%rsp
  8012f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012fe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801303:	75 06                	jne    80130b <memset+0x20>
		return v;
  801305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801309:	eb 69                	jmp    801374 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	83 e0 03             	and    $0x3,%eax
  801312:	48 85 c0             	test   %rax,%rax
  801315:	75 48                	jne    80135f <memset+0x74>
  801317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131b:	83 e0 03             	and    $0x3,%eax
  80131e:	48 85 c0             	test   %rax,%rax
  801321:	75 3c                	jne    80135f <memset+0x74>
		c &= 0xFF;
  801323:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80132a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132d:	89 c2                	mov    %eax,%edx
  80132f:	c1 e2 18             	shl    $0x18,%edx
  801332:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801335:	c1 e0 10             	shl    $0x10,%eax
  801338:	09 c2                	or     %eax,%edx
  80133a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133d:	c1 e0 08             	shl    $0x8,%eax
  801340:	09 d0                	or     %edx,%eax
  801342:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801349:	48 89 c1             	mov    %rax,%rcx
  80134c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801350:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801354:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801357:	48 89 d7             	mov    %rdx,%rdi
  80135a:	fc                   	cld    
  80135b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80135d:	eb 11                	jmp    801370 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80135f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801366:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80136a:	48 89 d7             	mov    %rdx,%rdi
  80136d:	fc                   	cld    
  80136e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801374:	c9                   	leaveq 
  801375:	c3                   	retq   

0000000000801376 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801376:	55                   	push   %rbp
  801377:	48 89 e5             	mov    %rsp,%rbp
  80137a:	48 83 ec 28          	sub    $0x28,%rsp
  80137e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801382:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801386:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80138a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801396:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80139a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a2:	0f 83 88 00 00 00    	jae    801430 <memmove+0xba>
  8013a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b0:	48 01 d0             	add    %rdx,%rax
  8013b3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b7:	76 77                	jbe    801430 <memmove+0xba>
		s += n;
  8013b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cd:	83 e0 03             	and    $0x3,%eax
  8013d0:	48 85 c0             	test   %rax,%rax
  8013d3:	75 3b                	jne    801410 <memmove+0x9a>
  8013d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d9:	83 e0 03             	and    $0x3,%eax
  8013dc:	48 85 c0             	test   %rax,%rax
  8013df:	75 2f                	jne    801410 <memmove+0x9a>
  8013e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 23                	jne    801410 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	48 83 e8 04          	sub    $0x4,%rax
  8013f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f9:	48 83 ea 04          	sub    $0x4,%rdx
  8013fd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801401:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801405:	48 89 c7             	mov    %rax,%rdi
  801408:	48 89 d6             	mov    %rdx,%rsi
  80140b:	fd                   	std    
  80140c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80140e:	eb 1d                	jmp    80142d <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801410:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801414:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801418:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801424:	48 89 d7             	mov    %rdx,%rdi
  801427:	48 89 c1             	mov    %rax,%rcx
  80142a:	fd                   	std    
  80142b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80142d:	fc                   	cld    
  80142e:	eb 57                	jmp    801487 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801434:	83 e0 03             	and    $0x3,%eax
  801437:	48 85 c0             	test   %rax,%rax
  80143a:	75 36                	jne    801472 <memmove+0xfc>
  80143c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801440:	83 e0 03             	and    $0x3,%eax
  801443:	48 85 c0             	test   %rax,%rax
  801446:	75 2a                	jne    801472 <memmove+0xfc>
  801448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144c:	83 e0 03             	and    $0x3,%eax
  80144f:	48 85 c0             	test   %rax,%rax
  801452:	75 1e                	jne    801472 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 89 c1             	mov    %rax,%rcx
  80145b:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80145f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801463:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801467:	48 89 c7             	mov    %rax,%rdi
  80146a:	48 89 d6             	mov    %rdx,%rsi
  80146d:	fc                   	cld    
  80146e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801470:	eb 15                	jmp    801487 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801472:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801476:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80147e:	48 89 c7             	mov    %rax,%rdi
  801481:	48 89 d6             	mov    %rdx,%rsi
  801484:	fc                   	cld    
  801485:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80148b:	c9                   	leaveq 
  80148c:	c3                   	retq   

000000000080148d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80148d:	55                   	push   %rbp
  80148e:	48 89 e5             	mov    %rsp,%rbp
  801491:	48 83 ec 18          	sub    $0x18,%rsp
  801495:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801499:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80149d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014a5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ad:	48 89 ce             	mov    %rcx,%rsi
  8014b0:	48 89 c7             	mov    %rax,%rdi
  8014b3:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  8014ba:	00 00 00 
  8014bd:	ff d0                	callq  *%rax
}
  8014bf:	c9                   	leaveq 
  8014c0:	c3                   	retq   

00000000008014c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014c1:	55                   	push   %rbp
  8014c2:	48 89 e5             	mov    %rsp,%rbp
  8014c5:	48 83 ec 28          	sub    $0x28,%rsp
  8014c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014e5:	eb 38                	jmp    80151f <memcmp+0x5e>
		if (*s1 != *s2)
  8014e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014eb:	0f b6 10             	movzbl (%rax),%edx
  8014ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	38 c2                	cmp    %al,%dl
  8014f7:	74 1c                	je     801515 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8014f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	0f b6 d0             	movzbl %al,%edx
  801503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	0f b6 c0             	movzbl %al,%eax
  80150d:	89 d1                	mov    %edx,%ecx
  80150f:	29 c1                	sub    %eax,%ecx
  801511:	89 c8                	mov    %ecx,%eax
  801513:	eb 20                	jmp    801535 <memcmp+0x74>
		s1++, s2++;
  801515:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80151a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80151f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801524:	0f 95 c0             	setne  %al
  801527:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80152c:	84 c0                	test   %al,%al
  80152e:	75 b7                	jne    8014e7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 28          	sub    $0x28,%rsp
  80153f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801543:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801546:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80154a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801552:	48 01 d0             	add    %rdx,%rax
  801555:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801559:	eb 13                	jmp    80156e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80155b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155f:	0f b6 10             	movzbl (%rax),%edx
  801562:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801565:	38 c2                	cmp    %al,%dl
  801567:	74 11                	je     80157a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801569:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80156e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801572:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801576:	72 e3                	jb     80155b <memfind+0x24>
  801578:	eb 01                	jmp    80157b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80157a:	90                   	nop
	return (void *) s;
  80157b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80157f:	c9                   	leaveq 
  801580:	c3                   	retq   

0000000000801581 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801581:	55                   	push   %rbp
  801582:	48 89 e5             	mov    %rsp,%rbp
  801585:	48 83 ec 38          	sub    $0x38,%rsp
  801589:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80158d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801591:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801594:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80159b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015a2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a3:	eb 05                	jmp    8015aa <strtol+0x29>
		s++;
  8015a5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	3c 20                	cmp    $0x20,%al
  8015b3:	74 f0                	je     8015a5 <strtol+0x24>
  8015b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b9:	0f b6 00             	movzbl (%rax),%eax
  8015bc:	3c 09                	cmp    $0x9,%al
  8015be:	74 e5                	je     8015a5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c4:	0f b6 00             	movzbl (%rax),%eax
  8015c7:	3c 2b                	cmp    $0x2b,%al
  8015c9:	75 07                	jne    8015d2 <strtol+0x51>
		s++;
  8015cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d0:	eb 17                	jmp    8015e9 <strtol+0x68>
	else if (*s == '-')
  8015d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d6:	0f b6 00             	movzbl (%rax),%eax
  8015d9:	3c 2d                	cmp    $0x2d,%al
  8015db:	75 0c                	jne    8015e9 <strtol+0x68>
		s++, neg = 1;
  8015dd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ed:	74 06                	je     8015f5 <strtol+0x74>
  8015ef:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015f3:	75 28                	jne    80161d <strtol+0x9c>
  8015f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	3c 30                	cmp    $0x30,%al
  8015fe:	75 1d                	jne    80161d <strtol+0x9c>
  801600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801604:	48 83 c0 01          	add    $0x1,%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 78                	cmp    $0x78,%al
  80160d:	75 0e                	jne    80161d <strtol+0x9c>
		s += 2, base = 16;
  80160f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801614:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80161b:	eb 2c                	jmp    801649 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80161d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801621:	75 19                	jne    80163c <strtol+0xbb>
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	0f b6 00             	movzbl (%rax),%eax
  80162a:	3c 30                	cmp    $0x30,%al
  80162c:	75 0e                	jne    80163c <strtol+0xbb>
		s++, base = 8;
  80162e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801633:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80163a:	eb 0d                	jmp    801649 <strtol+0xc8>
	else if (base == 0)
  80163c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801640:	75 07                	jne    801649 <strtol+0xc8>
		base = 10;
  801642:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	0f b6 00             	movzbl (%rax),%eax
  801650:	3c 2f                	cmp    $0x2f,%al
  801652:	7e 1d                	jle    801671 <strtol+0xf0>
  801654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	3c 39                	cmp    $0x39,%al
  80165d:	7f 12                	jg     801671 <strtol+0xf0>
			dig = *s - '0';
  80165f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801663:	0f b6 00             	movzbl (%rax),%eax
  801666:	0f be c0             	movsbl %al,%eax
  801669:	83 e8 30             	sub    $0x30,%eax
  80166c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166f:	eb 4e                	jmp    8016bf <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801675:	0f b6 00             	movzbl (%rax),%eax
  801678:	3c 60                	cmp    $0x60,%al
  80167a:	7e 1d                	jle    801699 <strtol+0x118>
  80167c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	3c 7a                	cmp    $0x7a,%al
  801685:	7f 12                	jg     801699 <strtol+0x118>
			dig = *s - 'a' + 10;
  801687:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168b:	0f b6 00             	movzbl (%rax),%eax
  80168e:	0f be c0             	movsbl %al,%eax
  801691:	83 e8 57             	sub    $0x57,%eax
  801694:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801697:	eb 26                	jmp    8016bf <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	3c 40                	cmp    $0x40,%al
  8016a2:	7e 47                	jle    8016eb <strtol+0x16a>
  8016a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a8:	0f b6 00             	movzbl (%rax),%eax
  8016ab:	3c 5a                	cmp    $0x5a,%al
  8016ad:	7f 3c                	jg     8016eb <strtol+0x16a>
			dig = *s - 'A' + 10;
  8016af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	0f be c0             	movsbl %al,%eax
  8016b9:	83 e8 37             	sub    $0x37,%eax
  8016bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016c2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016c5:	7d 23                	jge    8016ea <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8016c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016cc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016cf:	48 98                	cltq   
  8016d1:	48 89 c2             	mov    %rax,%rdx
  8016d4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8016d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016dc:	48 98                	cltq   
  8016de:	48 01 d0             	add    %rdx,%rax
  8016e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016e5:	e9 5f ff ff ff       	jmpq   801649 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ea:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016eb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016f0:	74 0b                	je     8016fd <strtol+0x17c>
		*endptr = (char *) s;
  8016f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016fa:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801701:	74 09                	je     80170c <strtol+0x18b>
  801703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801707:	48 f7 d8             	neg    %rax
  80170a:	eb 04                	jmp    801710 <strtol+0x18f>
  80170c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801710:	c9                   	leaveq 
  801711:	c3                   	retq   

0000000000801712 <strstr>:

char * strstr(const char *in, const char *str)
{
  801712:	55                   	push   %rbp
  801713:	48 89 e5             	mov    %rsp,%rbp
  801716:	48 83 ec 30          	sub    $0x30,%rsp
  80171a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80171e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801722:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801726:	0f b6 00             	movzbl (%rax),%eax
  801729:	88 45 ff             	mov    %al,-0x1(%rbp)
  80172c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801731:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801735:	75 06                	jne    80173d <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	eb 68                	jmp    8017a5 <strstr+0x93>

    len = strlen(str);
  80173d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801741:	48 89 c7             	mov    %rax,%rdi
  801744:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  80174b:	00 00 00 
  80174e:	ff d0                	callq  *%rax
  801750:	48 98                	cltq   
  801752:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175a:	0f b6 00             	movzbl (%rax),%eax
  80175d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801760:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801765:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801769:	75 07                	jne    801772 <strstr+0x60>
                return (char *) 0;
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
  801770:	eb 33                	jmp    8017a5 <strstr+0x93>
        } while (sc != c);
  801772:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801776:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801779:	75 db                	jne    801756 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80177b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	48 89 ce             	mov    %rcx,%rsi
  80178a:	48 89 c7             	mov    %rax,%rdi
  80178d:	48 b8 04 12 80 00 00 	movabs $0x801204,%rax
  801794:	00 00 00 
  801797:	ff d0                	callq  *%rax
  801799:	85 c0                	test   %eax,%eax
  80179b:	75 b9                	jne    801756 <strstr+0x44>

    return (char *) (in - 1);
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	48 83 e8 01          	sub    $0x1,%rax
}
  8017a5:	c9                   	leaveq 
  8017a6:	c3                   	retq   
	...

00000000008017a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017a8:	55                   	push   %rbp
  8017a9:	48 89 e5             	mov    %rsp,%rbp
  8017ac:	53                   	push   %rbx
  8017ad:	48 83 ec 58          	sub    $0x58,%rsp
  8017b1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017b4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017b7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017bb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017bf:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017c3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ca:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8017cd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017d1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017d5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017d9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017dd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017e1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8017e4:	4c 89 c3             	mov    %r8,%rbx
  8017e7:	cd 30                	int    $0x30
  8017e9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8017ed:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8017f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017f9:	74 3e                	je     801839 <syscall+0x91>
  8017fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801800:	7e 37                	jle    801839 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801802:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801806:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801809:	49 89 d0             	mov    %rdx,%r8
  80180c:	89 c1                	mov    %eax,%ecx
  80180e:	48 ba 80 4b 80 00 00 	movabs $0x804b80,%rdx
  801815:	00 00 00 
  801818:	be 23 00 00 00       	mov    $0x23,%esi
  80181d:	48 bf 9d 4b 80 00 00 	movabs $0x804b9d,%rdi
  801824:	00 00 00 
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
  80182c:	49 b9 28 43 80 00 00 	movabs $0x804328,%r9
  801833:	00 00 00 
  801836:	41 ff d1             	callq  *%r9

	return ret;
  801839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183d:	48 83 c4 58          	add    $0x58,%rsp
  801841:	5b                   	pop    %rbx
  801842:	5d                   	pop    %rbp
  801843:	c3                   	retq   

0000000000801844 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801844:	55                   	push   %rbp
  801845:	48 89 e5             	mov    %rsp,%rbp
  801848:	48 83 ec 20          	sub    $0x20,%rsp
  80184c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801850:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801858:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801863:	00 
  801864:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801870:	48 89 d1             	mov    %rdx,%rcx
  801873:	48 89 c2             	mov    %rax,%rdx
  801876:	be 00 00 00 00       	mov    $0x0,%esi
  80187b:	bf 00 00 00 00       	mov    $0x0,%edi
  801880:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801887:	00 00 00 
  80188a:	ff d0                	callq  *%rax
}
  80188c:	c9                   	leaveq 
  80188d:	c3                   	retq   

000000000080188e <sys_cgetc>:

int
sys_cgetc(void)
{
  80188e:	55                   	push   %rbp
  80188f:	48 89 e5             	mov    %rsp,%rbp
  801892:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801896:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189d:	00 
  80189e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018af:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b4:	be 00 00 00 00       	mov    $0x0,%esi
  8018b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8018be:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  8018c5:	00 00 00 
  8018c8:	ff d0                	callq  *%rax
}
  8018ca:	c9                   	leaveq 
  8018cb:	c3                   	retq   

00000000008018cc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018cc:	55                   	push   %rbp
  8018cd:	48 89 e5             	mov    %rsp,%rbp
  8018d0:	48 83 ec 20          	sub    $0x20,%rsp
  8018d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018da:	48 98                	cltq   
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f5:	48 89 c2             	mov    %rax,%rdx
  8018f8:	be 01 00 00 00       	mov    $0x1,%esi
  8018fd:	bf 03 00 00 00       	mov    $0x3,%edi
  801902:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801909:	00 00 00 
  80190c:	ff d0                	callq  *%rax
}
  80190e:	c9                   	leaveq 
  80190f:	c3                   	retq   

0000000000801910 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801910:	55                   	push   %rbp
  801911:	48 89 e5             	mov    %rsp,%rbp
  801914:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801918:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191f:	00 
  801920:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801926:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	be 00 00 00 00       	mov    $0x0,%esi
  80193b:	bf 02 00 00 00       	mov    $0x2,%edi
  801940:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801947:	00 00 00 
  80194a:	ff d0                	callq  *%rax
}
  80194c:	c9                   	leaveq 
  80194d:	c3                   	retq   

000000000080194e <sys_yield>:

void
sys_yield(void)
{
  80194e:	55                   	push   %rbp
  80194f:	48 89 e5             	mov    %rsp,%rbp
  801952:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801956:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195d:	00 
  80195e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801964:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80196f:	ba 00 00 00 00       	mov    $0x0,%edx
  801974:	be 00 00 00 00       	mov    $0x0,%esi
  801979:	bf 0b 00 00 00       	mov    $0xb,%edi
  80197e:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801985:	00 00 00 
  801988:	ff d0                	callq  *%rax
}
  80198a:	c9                   	leaveq 
  80198b:	c3                   	retq   

000000000080198c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80198c:	55                   	push   %rbp
  80198d:	48 89 e5             	mov    %rsp,%rbp
  801990:	48 83 ec 20          	sub    $0x20,%rsp
  801994:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801997:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80199b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80199e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a1:	48 63 c8             	movslq %eax,%rcx
  8019a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ab:	48 98                	cltq   
  8019ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b4:	00 
  8019b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bb:	49 89 c8             	mov    %rcx,%r8
  8019be:	48 89 d1             	mov    %rdx,%rcx
  8019c1:	48 89 c2             	mov    %rax,%rdx
  8019c4:	be 01 00 00 00       	mov    $0x1,%esi
  8019c9:	bf 04 00 00 00       	mov    $0x4,%edi
  8019ce:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  8019d5:	00 00 00 
  8019d8:	ff d0                	callq  *%rax
}
  8019da:	c9                   	leaveq 
  8019db:	c3                   	retq   

00000000008019dc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019dc:	55                   	push   %rbp
  8019dd:	48 89 e5             	mov    %rsp,%rbp
  8019e0:	48 83 ec 30          	sub    $0x30,%rsp
  8019e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019eb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019ee:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019f2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019f6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019f9:	48 63 c8             	movslq %eax,%rcx
  8019fc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a03:	48 63 f0             	movslq %eax,%rsi
  801a06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0d:	48 98                	cltq   
  801a0f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a13:	49 89 f9             	mov    %rdi,%r9
  801a16:	49 89 f0             	mov    %rsi,%r8
  801a19:	48 89 d1             	mov    %rdx,%rcx
  801a1c:	48 89 c2             	mov    %rax,%rdx
  801a1f:	be 01 00 00 00       	mov    $0x1,%esi
  801a24:	bf 05 00 00 00       	mov    $0x5,%edi
  801a29:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
}
  801a35:	c9                   	leaveq 
  801a36:	c3                   	retq   

0000000000801a37 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a37:	55                   	push   %rbp
  801a38:	48 89 e5             	mov    %rsp,%rbp
  801a3b:	48 83 ec 20          	sub    $0x20,%rsp
  801a3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4d:	48 98                	cltq   
  801a4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a56:	00 
  801a57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a63:	48 89 d1             	mov    %rdx,%rcx
  801a66:	48 89 c2             	mov    %rax,%rdx
  801a69:	be 01 00 00 00       	mov    $0x1,%esi
  801a6e:	bf 06 00 00 00       	mov    $0x6,%edi
  801a73:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801a7a:	00 00 00 
  801a7d:	ff d0                	callq  *%rax
}
  801a7f:	c9                   	leaveq 
  801a80:	c3                   	retq   

0000000000801a81 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a81:	55                   	push   %rbp
  801a82:	48 89 e5             	mov    %rsp,%rbp
  801a85:	48 83 ec 20          	sub    $0x20,%rsp
  801a89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a92:	48 63 d0             	movslq %eax,%rdx
  801a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a98:	48 98                	cltq   
  801a9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa1:	00 
  801aa2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aae:	48 89 d1             	mov    %rdx,%rcx
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	be 01 00 00 00       	mov    $0x1,%esi
  801ab9:	bf 08 00 00 00       	mov    $0x8,%edi
  801abe:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801ac5:	00 00 00 
  801ac8:	ff d0                	callq  *%rax
}
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
  801ad0:	48 83 ec 20          	sub    $0x20,%rsp
  801ad4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801adb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae2:	48 98                	cltq   
  801ae4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aeb:	00 
  801aec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af8:	48 89 d1             	mov    %rdx,%rcx
  801afb:	48 89 c2             	mov    %rax,%rdx
  801afe:	be 01 00 00 00       	mov    $0x1,%esi
  801b03:	bf 09 00 00 00       	mov    $0x9,%edi
  801b08:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801b0f:	00 00 00 
  801b12:	ff d0                	callq  *%rax
}
  801b14:	c9                   	leaveq 
  801b15:	c3                   	retq   

0000000000801b16 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b16:	55                   	push   %rbp
  801b17:	48 89 e5             	mov    %rsp,%rbp
  801b1a:	48 83 ec 20          	sub    $0x20,%rsp
  801b1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2c:	48 98                	cltq   
  801b2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b35:	00 
  801b36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b42:	48 89 d1             	mov    %rdx,%rcx
  801b45:	48 89 c2             	mov    %rax,%rdx
  801b48:	be 01 00 00 00       	mov    $0x1,%esi
  801b4d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b52:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801b59:	00 00 00 
  801b5c:	ff d0                	callq  *%rax
}
  801b5e:	c9                   	leaveq 
  801b5f:	c3                   	retq   

0000000000801b60 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b60:	55                   	push   %rbp
  801b61:	48 89 e5             	mov    %rsp,%rbp
  801b64:	48 83 ec 30          	sub    $0x30,%rsp
  801b68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b6f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b73:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b79:	48 63 f0             	movslq %eax,%rsi
  801b7c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b83:	48 98                	cltq   
  801b85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b90:	00 
  801b91:	49 89 f1             	mov    %rsi,%r9
  801b94:	49 89 c8             	mov    %rcx,%r8
  801b97:	48 89 d1             	mov    %rdx,%rcx
  801b9a:	48 89 c2             	mov    %rax,%rdx
  801b9d:	be 00 00 00 00       	mov    $0x0,%esi
  801ba2:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ba7:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801bae:	00 00 00 
  801bb1:	ff d0                	callq  *%rax
}
  801bb3:	c9                   	leaveq 
  801bb4:	c3                   	retq   

0000000000801bb5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	48 83 ec 20          	sub    $0x20,%rsp
  801bbd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bcc:	00 
  801bcd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bde:	48 89 c2             	mov    %rax,%rdx
  801be1:	be 01 00 00 00       	mov    $0x1,%esi
  801be6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801beb:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	callq  *%rax
}
  801bf7:	c9                   	leaveq 
  801bf8:	c3                   	retq   

0000000000801bf9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801bf9:	55                   	push   %rbp
  801bfa:	48 89 e5             	mov    %rsp,%rbp
  801bfd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c08:	00 
  801c09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c15:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1f:	be 00 00 00 00       	mov    $0x0,%esi
  801c24:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c29:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	callq  *%rax
}
  801c35:	c9                   	leaveq 
  801c36:	c3                   	retq   

0000000000801c37 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801c37:	55                   	push   %rbp
  801c38:	48 89 e5             	mov    %rsp,%rbp
  801c3b:	48 83 ec 20          	sub    $0x20,%rsp
  801c3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c56:	00 
  801c57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c63:	48 89 d1             	mov    %rdx,%rcx
  801c66:	48 89 c2             	mov    %rax,%rdx
  801c69:	be 00 00 00 00       	mov    $0x0,%esi
  801c6e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c73:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
}
  801c7f:	c9                   	leaveq 
  801c80:	c3                   	retq   

0000000000801c81 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	48 83 ec 20          	sub    $0x20,%rsp
  801c89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca0:	00 
  801ca1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cad:	48 89 d1             	mov    %rdx,%rcx
  801cb0:	48 89 c2             	mov    %rax,%rdx
  801cb3:	be 00 00 00 00       	mov    $0x0,%esi
  801cb8:	bf 10 00 00 00       	mov    $0x10,%edi
  801cbd:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   
	...

0000000000801ccc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 30          	sub    $0x30,%rsp
  801cd4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801cd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cdc:	48 8b 00             	mov    (%rax),%rax
  801cdf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ce3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ceb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801cee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cf1:	83 e0 02             	and    $0x2,%eax
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	74 23                	je     801d1b <pgfault+0x4f>
  801cf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfc:	48 89 c2             	mov    %rax,%rdx
  801cff:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d03:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d0a:	01 00 00 
  801d0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d11:	25 00 08 00 00       	and    $0x800,%eax
  801d16:	48 85 c0             	test   %rax,%rax
  801d19:	75 2a                	jne    801d45 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801d1b:	48 ba b0 4b 80 00 00 	movabs $0x804bb0,%rdx
  801d22:	00 00 00 
  801d25:	be 1c 00 00 00       	mov    $0x1c,%esi
  801d2a:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801d31:	00 00 00 
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	48 b9 28 43 80 00 00 	movabs $0x804328,%rcx
  801d40:	00 00 00 
  801d43:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801d45:	ba 07 00 00 00       	mov    $0x7,%edx
  801d4a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d54:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  801d5b:	00 00 00 
  801d5e:	ff d0                	callq  *%rax
  801d60:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801d63:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801d67:	79 30                	jns    801d99 <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801d69:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801d6c:	89 c1                	mov    %eax,%ecx
  801d6e:	48 ba f0 4b 80 00 00 	movabs $0x804bf0,%rdx
  801d75:	00 00 00 
  801d78:	be 26 00 00 00       	mov    $0x26,%esi
  801d7d:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801d84:	00 00 00 
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8c:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  801d93:	00 00 00 
  801d96:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801d99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801da1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801dab:	ba 00 10 00 00       	mov    $0x1000,%edx
  801db0:	48 89 c6             	mov    %rax,%rsi
  801db3:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801db8:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  801dbf:	00 00 00 
  801dc2:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801dc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801dcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dd0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801dd6:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ddc:	48 89 c1             	mov    %rax,%rcx
  801ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  801de4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801de9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dee:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  801df5:	00 00 00 
  801df8:	ff d0                	callq  *%rax
  801dfa:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e01:	79 30                	jns    801e33 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801e03:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e06:	89 c1                	mov    %eax,%ecx
  801e08:	48 ba 18 4c 80 00 00 	movabs $0x804c18,%rdx
  801e0f:	00 00 00 
  801e12:	be 2b 00 00 00       	mov    $0x2b,%esi
  801e17:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801e1e:	00 00 00 
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
  801e26:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  801e2d:	00 00 00 
  801e30:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801e33:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e38:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3d:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	callq  *%rax
  801e49:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801e4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e50:	79 30                	jns    801e82 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801e52:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e55:	89 c1                	mov    %eax,%ecx
  801e57:	48 ba 40 4c 80 00 00 	movabs $0x804c40,%rdx
  801e5e:	00 00 00 
  801e61:	be 2e 00 00 00       	mov    $0x2e,%esi
  801e66:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801e6d:	00 00 00 
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
  801e75:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  801e7c:	00 00 00 
  801e7f:	41 ff d0             	callq  *%r8
	
}
  801e82:	c9                   	leaveq 
  801e83:	c3                   	retq   

0000000000801e84 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e84:	55                   	push   %rbp
  801e85:	48 89 e5             	mov    %rsp,%rbp
  801e88:	48 83 ec 30          	sub    $0x30,%rsp
  801e8c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e8f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  801e92:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e99:	01 00 00 
  801e9c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801e9f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  801ea7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eab:	25 07 0e 00 00       	and    $0xe07,%eax
  801eb0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  801eb3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801eb6:	48 c1 e0 0c          	shl    $0xc,%rax
  801eba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  801ebe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ec1:	25 00 04 00 00       	and    $0x400,%eax
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	74 5c                	je     801f26 <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  801eca:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801ecd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ed1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801ed4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed8:	41 89 f0             	mov    %esi,%r8d
  801edb:	48 89 c6             	mov    %rax,%rsi
  801ede:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee3:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	callq  *%rax
  801eef:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  801ef2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801ef6:	0f 89 60 01 00 00    	jns    80205c <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  801efc:	48 ba 68 4c 80 00 00 	movabs $0x804c68,%rdx
  801f03:	00 00 00 
  801f06:	be 4d 00 00 00       	mov    $0x4d,%esi
  801f0b:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801f12:	00 00 00 
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1a:	48 b9 28 43 80 00 00 	movabs $0x804328,%rcx
  801f21:	00 00 00 
  801f24:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  801f26:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f29:	83 e0 02             	and    $0x2,%eax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	75 10                	jne    801f40 <duppage+0xbc>
  801f30:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f33:	25 00 08 00 00       	and    $0x800,%eax
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	0f 84 c4 00 00 00    	je     802004 <duppage+0x180>
	{
		perm |= PTE_COW;
  801f40:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  801f47:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  801f4b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801f4e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f52:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f59:	41 89 f0             	mov    %esi,%r8d
  801f5c:	48 89 c6             	mov    %rax,%rsi
  801f5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f64:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  801f6b:	00 00 00 
  801f6e:	ff d0                	callq  *%rax
  801f70:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  801f73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f77:	79 2a                	jns    801fa3 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  801f79:	48 ba 98 4c 80 00 00 	movabs $0x804c98,%rdx
  801f80:	00 00 00 
  801f83:	be 56 00 00 00       	mov    $0x56,%esi
  801f88:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801f8f:	00 00 00 
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
  801f97:	48 b9 28 43 80 00 00 	movabs $0x804328,%rcx
  801f9e:	00 00 00 
  801fa1:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  801fa3:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  801fa6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fae:	41 89 c8             	mov    %ecx,%r8d
  801fb1:	48 89 d1             	mov    %rdx,%rcx
  801fb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb9:	48 89 c6             	mov    %rax,%rsi
  801fbc:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc1:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  801fc8:	00 00 00 
  801fcb:	ff d0                	callq  *%rax
  801fcd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  801fd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801fd4:	0f 89 82 00 00 00    	jns    80205c <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  801fda:	48 ba 98 4c 80 00 00 	movabs $0x804c98,%rdx
  801fe1:	00 00 00 
  801fe4:	be 59 00 00 00       	mov    $0x59,%esi
  801fe9:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801ff0:	00 00 00 
  801ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff8:	48 b9 28 43 80 00 00 	movabs $0x804328,%rcx
  801fff:	00 00 00 
  802002:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  802004:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802007:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80200b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80200e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802012:	41 89 f0             	mov    %esi,%r8d
  802015:	48 89 c6             	mov    %rax,%rsi
  802018:	bf 00 00 00 00       	mov    $0x0,%edi
  80201d:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  802024:	00 00 00 
  802027:	ff d0                	callq  *%rax
  802029:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  80202c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802030:	79 2a                	jns    80205c <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  802032:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  802039:	00 00 00 
  80203c:	be 60 00 00 00       	mov    $0x60,%esi
  802041:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  802048:	00 00 00 
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	48 b9 28 43 80 00 00 	movabs $0x804328,%rcx
  802057:	00 00 00 
  80205a:	ff d1                	callq  *%rcx
	}
	return 0;
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802061:	c9                   	leaveq 
  802062:	c3                   	retq   

0000000000802063 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802063:	55                   	push   %rbp
  802064:	48 89 e5             	mov    %rsp,%rbp
  802067:	53                   	push   %rbx
  802068:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80206c:	48 bf cc 1c 80 00 00 	movabs $0x801ccc,%rdi
  802073:	00 00 00 
  802076:	48 b8 3c 44 80 00 00 	movabs $0x80443c,%rax
  80207d:	00 00 00 
  802080:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802082:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  802089:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80208c:	cd 30                	int    $0x30
  80208e:	89 c3                	mov    %eax,%ebx
  802090:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802093:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  802096:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  802099:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80209d:	79 30                	jns    8020cf <fork+0x6c>
                panic("sys_exofork: %e", envid);
  80209f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8020a2:	89 c1                	mov    %eax,%ecx
  8020a4:	48 ba f4 4c 80 00 00 	movabs $0x804cf4,%rdx
  8020ab:	00 00 00 
  8020ae:	be 7f 00 00 00       	mov    $0x7f,%esi
  8020b3:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  8020ba:	00 00 00 
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  8020c9:	00 00 00 
  8020cc:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  8020cf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8020d3:	75 4c                	jne    802121 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  8020d5:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  8020dc:	00 00 00 
  8020df:	ff d0                	callq  *%rax
  8020e1:	48 98                	cltq   
  8020e3:	48 89 c2             	mov    %rax,%rdx
  8020e6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8020ec:	48 89 d0             	mov    %rdx,%rax
  8020ef:	48 c1 e0 03          	shl    $0x3,%rax
  8020f3:	48 01 d0             	add    %rdx,%rax
  8020f6:	48 c1 e0 05          	shl    $0x5,%rax
  8020fa:	48 89 c2             	mov    %rax,%rdx
  8020fd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802104:	00 00 00 
  802107:	48 01 c2             	add    %rax,%rdx
  80210a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802111:	00 00 00 
  802114:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
  80211c:	e9 38 02 00 00       	jmpq   802359 <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  802121:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802124:	ba 07 00 00 00       	mov    $0x7,%edx
  802129:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80212e:	89 c7                	mov    %eax,%edi
  802130:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  802137:	00 00 00 
  80213a:	ff d0                	callq  *%rax
  80213c:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  80213f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802143:	79 30                	jns    802175 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  802145:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802148:	89 c1                	mov    %eax,%ecx
  80214a:	48 ba 08 4d 80 00 00 	movabs $0x804d08,%rdx
  802151:	00 00 00 
  802154:	be 8b 00 00 00       	mov    $0x8b,%esi
  802159:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  802160:	00 00 00 
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  80216f:	00 00 00 
  802172:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802175:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  80217c:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802183:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  80218a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802191:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802198:	e9 0a 01 00 00       	jmpq   8022a7 <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  80219d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021a4:	01 00 00 
  8021a7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021aa:	48 63 d2             	movslq %edx,%rdx
  8021ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b1:	83 e0 01             	and    $0x1,%eax
  8021b4:	84 c0                	test   %al,%al
  8021b6:	0f 84 e7 00 00 00    	je     8022a3 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  8021bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  8021c3:	e9 cf 00 00 00       	jmpq   802297 <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  8021c8:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021cf:	01 00 00 
  8021d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021d5:	48 63 d2             	movslq %edx,%rdx
  8021d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021dc:	83 e0 01             	and    $0x1,%eax
  8021df:	84 c0                	test   %al,%al
  8021e1:	0f 84 a0 00 00 00    	je     802287 <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8021e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  8021ee:	e9 85 00 00 00       	jmpq   802278 <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  8021f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021fa:	01 00 00 
  8021fd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802200:	48 63 d2             	movslq %edx,%rdx
  802203:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802207:	83 e0 01             	and    $0x1,%eax
  80220a:	84 c0                	test   %al,%al
  80220c:	74 56                	je     802264 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  80220e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  802215:	eb 42                	jmp    802259 <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  802217:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80221e:	01 00 00 
  802221:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802224:	48 63 d2             	movslq %edx,%rdx
  802227:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222b:	83 e0 01             	and    $0x1,%eax
  80222e:	84 c0                	test   %al,%al
  802230:	74 1f                	je     802251 <fork+0x1ee>
  802232:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  802239:	74 16                	je     802251 <fork+0x1ee>
									 duppage(envid,d1);
  80223b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80223e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802241:	89 d6                	mov    %edx,%esi
  802243:	89 c7                	mov    %eax,%edi
  802245:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  80224c:	00 00 00 
  80224f:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802251:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  802255:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  802259:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802260:	7e b5                	jle    802217 <fork+0x1b4>
  802262:	eb 0c                	jmp    802270 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802264:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802267:	83 c0 01             	add    $0x1,%eax
  80226a:	c1 e0 09             	shl    $0x9,%eax
  80226d:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802270:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802274:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  802278:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  80227f:	0f 8e 6e ff ff ff    	jle    8021f3 <fork+0x190>
  802285:	eb 0c                	jmp    802293 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  802287:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80228a:	83 c0 01             	add    $0x1,%eax
  80228d:	c1 e0 09             	shl    $0x9,%eax
  802290:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802293:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  802297:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80229a:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  80229d:	0f 8c 25 ff ff ff    	jl     8021c8 <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8022a3:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8022a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022aa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8022ad:	0f 8c ea fe ff ff    	jl     80219d <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8022b3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8022b6:	48 be 00 45 80 00 00 	movabs $0x804500,%rsi
  8022bd:	00 00 00 
  8022c0:	89 c7                	mov    %eax,%edi
  8022c2:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8022c9:	00 00 00 
  8022cc:	ff d0                	callq  *%rax
  8022ce:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8022d1:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8022d5:	79 30                	jns    802307 <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  8022d7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8022da:	89 c1                	mov    %eax,%ecx
  8022dc:	48 ba 28 4d 80 00 00 	movabs $0x804d28,%rdx
  8022e3:	00 00 00 
  8022e6:	be ad 00 00 00       	mov    $0xad,%esi
  8022eb:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  8022f2:	00 00 00 
  8022f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fa:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  802301:	00 00 00 
  802304:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  802307:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80230a:	be 02 00 00 00       	mov    $0x2,%esi
  80230f:	89 c7                	mov    %eax,%edi
  802311:	48 b8 81 1a 80 00 00 	movabs $0x801a81,%rax
  802318:	00 00 00 
  80231b:	ff d0                	callq  *%rax
  80231d:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802320:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802324:	79 30                	jns    802356 <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  802326:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802329:	89 c1                	mov    %eax,%ecx
  80232b:	48 ba 58 4d 80 00 00 	movabs $0x804d58,%rdx
  802332:	00 00 00 
  802335:	be b0 00 00 00       	mov    $0xb0,%esi
  80233a:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  802341:	00 00 00 
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  802350:	00 00 00 
  802353:	41 ff d0             	callq  *%r8
	return envid;
  802356:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  802359:	48 83 c4 48          	add    $0x48,%rsp
  80235d:	5b                   	pop    %rbx
  80235e:	5d                   	pop    %rbp
  80235f:	c3                   	retq   

0000000000802360 <sfork>:

// Challenge!
int
sfork(void)
{
  802360:	55                   	push   %rbp
  802361:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802364:	48 ba 7c 4d 80 00 00 	movabs $0x804d7c,%rdx
  80236b:	00 00 00 
  80236e:	be b8 00 00 00       	mov    $0xb8,%esi
  802373:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  80237a:	00 00 00 
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
  802382:	48 b9 28 43 80 00 00 	movabs $0x804328,%rcx
  802389:	00 00 00 
  80238c:	ff d1                	callq  *%rcx
	...

0000000000802390 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802390:	55                   	push   %rbp
  802391:	48 89 e5             	mov    %rsp,%rbp
  802394:	48 83 ec 30          	sub    $0x30,%rsp
  802398:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80239c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8023a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023a9:	74 18                	je     8023c3 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8023ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023af:	48 89 c7             	mov    %rax,%rdi
  8023b2:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
  8023be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c1:	eb 19                	jmp    8023dc <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  8023c3:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8023ca:	00 00 00 
  8023cd:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  8023d4:	00 00 00 
  8023d7:	ff d0                	callq  *%rax
  8023d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8023dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e0:	79 19                	jns    8023fb <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8023e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8023ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8023f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f9:	eb 53                	jmp    80244e <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8023fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802400:	74 19                	je     80241b <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  802402:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802409:	00 00 00 
  80240c:	48 8b 00             	mov    (%rax),%rax
  80240f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802419:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80241b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802420:	74 19                	je     80243b <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  802422:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802429:	00 00 00 
  80242c:	48 8b 00             	mov    (%rax),%rax
  80242f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802439:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80243b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802442:	00 00 00 
  802445:	48 8b 00             	mov    (%rax),%rax
  802448:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80244e:	c9                   	leaveq 
  80244f:	c3                   	retq   

0000000000802450 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802450:	55                   	push   %rbp
  802451:	48 89 e5             	mov    %rsp,%rbp
  802454:	48 83 ec 30          	sub    $0x30,%rsp
  802458:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80245b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80245e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802462:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  802465:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  80246c:	e9 96 00 00 00       	jmpq   802507 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  802471:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802476:	74 20                	je     802498 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  802478:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80247b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80247e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802482:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802485:	89 c7                	mov    %eax,%edi
  802487:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  80248e:	00 00 00 
  802491:	ff d0                	callq  *%rax
  802493:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802496:	eb 2d                	jmp    8024c5 <ipc_send+0x75>
		else if(pg==NULL)
  802498:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80249d:	75 26                	jne    8024c5 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80249f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8024a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024aa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8024b1:	00 00 00 
  8024b4:	89 c7                	mov    %eax,%edi
  8024b6:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  8024bd:	00 00 00 
  8024c0:	ff d0                	callq  *%rax
  8024c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8024c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c9:	79 30                	jns    8024fb <ipc_send+0xab>
  8024cb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8024cf:	74 2a                	je     8024fb <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8024d1:	48 ba 92 4d 80 00 00 	movabs $0x804d92,%rdx
  8024d8:	00 00 00 
  8024db:	be 40 00 00 00       	mov    $0x40,%esi
  8024e0:	48 bf aa 4d 80 00 00 	movabs $0x804daa,%rdi
  8024e7:	00 00 00 
  8024ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ef:	48 b9 28 43 80 00 00 	movabs $0x804328,%rcx
  8024f6:	00 00 00 
  8024f9:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8024fb:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  802502:	00 00 00 
  802505:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  802507:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250b:	0f 85 60 ff ff ff    	jne    802471 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  802511:	c9                   	leaveq 
  802512:	c3                   	retq   

0000000000802513 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802513:	55                   	push   %rbp
  802514:	48 89 e5             	mov    %rsp,%rbp
  802517:	48 83 ec 18          	sub    $0x18,%rsp
  80251b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80251e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802525:	eb 5e                	jmp    802585 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802527:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80252e:	00 00 00 
  802531:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802534:	48 63 d0             	movslq %eax,%rdx
  802537:	48 89 d0             	mov    %rdx,%rax
  80253a:	48 c1 e0 03          	shl    $0x3,%rax
  80253e:	48 01 d0             	add    %rdx,%rax
  802541:	48 c1 e0 05          	shl    $0x5,%rax
  802545:	48 01 c8             	add    %rcx,%rax
  802548:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80254e:	8b 00                	mov    (%rax),%eax
  802550:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802553:	75 2c                	jne    802581 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802555:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80255c:	00 00 00 
  80255f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802562:	48 63 d0             	movslq %eax,%rdx
  802565:	48 89 d0             	mov    %rdx,%rax
  802568:	48 c1 e0 03          	shl    $0x3,%rax
  80256c:	48 01 d0             	add    %rdx,%rax
  80256f:	48 c1 e0 05          	shl    $0x5,%rax
  802573:	48 01 c8             	add    %rcx,%rax
  802576:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80257c:	8b 40 08             	mov    0x8(%rax),%eax
  80257f:	eb 12                	jmp    802593 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802581:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802585:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80258c:	7e 99                	jle    802527 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802593:	c9                   	leaveq 
  802594:	c3                   	retq   
  802595:	00 00                	add    %al,(%rax)
	...

0000000000802598 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802598:	55                   	push   %rbp
  802599:	48 89 e5             	mov    %rsp,%rbp
  80259c:	48 83 ec 08          	sub    $0x8,%rsp
  8025a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025a8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025af:	ff ff ff 
  8025b2:	48 01 d0             	add    %rdx,%rax
  8025b5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025b9:	c9                   	leaveq 
  8025ba:	c3                   	retq   

00000000008025bb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025bb:	55                   	push   %rbp
  8025bc:	48 89 e5             	mov    %rsp,%rbp
  8025bf:	48 83 ec 08          	sub    $0x8,%rsp
  8025c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025cb:	48 89 c7             	mov    %rax,%rdi
  8025ce:	48 b8 98 25 80 00 00 	movabs $0x802598,%rax
  8025d5:	00 00 00 
  8025d8:	ff d0                	callq  *%rax
  8025da:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8025e0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8025e4:	c9                   	leaveq 
  8025e5:	c3                   	retq   

00000000008025e6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8025e6:	55                   	push   %rbp
  8025e7:	48 89 e5             	mov    %rsp,%rbp
  8025ea:	48 83 ec 18          	sub    $0x18,%rsp
  8025ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025f9:	eb 6b                	jmp    802666 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8025fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fe:	48 98                	cltq   
  802600:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802606:	48 c1 e0 0c          	shl    $0xc,%rax
  80260a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80260e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802612:	48 89 c2             	mov    %rax,%rdx
  802615:	48 c1 ea 15          	shr    $0x15,%rdx
  802619:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802620:	01 00 00 
  802623:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802627:	83 e0 01             	and    $0x1,%eax
  80262a:	48 85 c0             	test   %rax,%rax
  80262d:	74 21                	je     802650 <fd_alloc+0x6a>
  80262f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802633:	48 89 c2             	mov    %rax,%rdx
  802636:	48 c1 ea 0c          	shr    $0xc,%rdx
  80263a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802641:	01 00 00 
  802644:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802648:	83 e0 01             	and    $0x1,%eax
  80264b:	48 85 c0             	test   %rax,%rax
  80264e:	75 12                	jne    802662 <fd_alloc+0x7c>
			*fd_store = fd;
  802650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802654:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802658:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
  802660:	eb 1a                	jmp    80267c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802662:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802666:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80266a:	7e 8f                	jle    8025fb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80266c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802670:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802677:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80267c:	c9                   	leaveq 
  80267d:	c3                   	retq   

000000000080267e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80267e:	55                   	push   %rbp
  80267f:	48 89 e5             	mov    %rsp,%rbp
  802682:	48 83 ec 20          	sub    $0x20,%rsp
  802686:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802689:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80268d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802691:	78 06                	js     802699 <fd_lookup+0x1b>
  802693:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802697:	7e 07                	jle    8026a0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802699:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80269e:	eb 6c                	jmp    80270c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a3:	48 98                	cltq   
  8026a5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026ab:	48 c1 e0 0c          	shl    $0xc,%rax
  8026af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026b7:	48 89 c2             	mov    %rax,%rdx
  8026ba:	48 c1 ea 15          	shr    $0x15,%rdx
  8026be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026c5:	01 00 00 
  8026c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026cc:	83 e0 01             	and    $0x1,%eax
  8026cf:	48 85 c0             	test   %rax,%rax
  8026d2:	74 21                	je     8026f5 <fd_lookup+0x77>
  8026d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d8:	48 89 c2             	mov    %rax,%rdx
  8026db:	48 c1 ea 0c          	shr    $0xc,%rdx
  8026df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026e6:	01 00 00 
  8026e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ed:	83 e0 01             	and    $0x1,%eax
  8026f0:	48 85 c0             	test   %rax,%rax
  8026f3:	75 07                	jne    8026fc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026fa:	eb 10                	jmp    80270c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8026fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802700:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802704:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270c:	c9                   	leaveq 
  80270d:	c3                   	retq   

000000000080270e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80270e:	55                   	push   %rbp
  80270f:	48 89 e5             	mov    %rsp,%rbp
  802712:	48 83 ec 30          	sub    $0x30,%rsp
  802716:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80271a:	89 f0                	mov    %esi,%eax
  80271c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80271f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802723:	48 89 c7             	mov    %rax,%rdi
  802726:	48 b8 98 25 80 00 00 	movabs $0x802598,%rax
  80272d:	00 00 00 
  802730:	ff d0                	callq  *%rax
  802732:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802736:	48 89 d6             	mov    %rdx,%rsi
  802739:	89 c7                	mov    %eax,%edi
  80273b:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802742:	00 00 00 
  802745:	ff d0                	callq  *%rax
  802747:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80274e:	78 0a                	js     80275a <fd_close+0x4c>
	    || fd != fd2)
  802750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802754:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802758:	74 12                	je     80276c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80275a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80275e:	74 05                	je     802765 <fd_close+0x57>
  802760:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802763:	eb 05                	jmp    80276a <fd_close+0x5c>
  802765:	b8 00 00 00 00       	mov    $0x0,%eax
  80276a:	eb 69                	jmp    8027d5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80276c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802770:	8b 00                	mov    (%rax),%eax
  802772:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802776:	48 89 d6             	mov    %rdx,%rsi
  802779:	89 c7                	mov    %eax,%edi
  80277b:	48 b8 d7 27 80 00 00 	movabs $0x8027d7,%rax
  802782:	00 00 00 
  802785:	ff d0                	callq  *%rax
  802787:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278e:	78 2a                	js     8027ba <fd_close+0xac>
		if (dev->dev_close)
  802790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802794:	48 8b 40 20          	mov    0x20(%rax),%rax
  802798:	48 85 c0             	test   %rax,%rax
  80279b:	74 16                	je     8027b3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80279d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a1:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8027a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a9:	48 89 c7             	mov    %rax,%rdi
  8027ac:	ff d2                	callq  *%rdx
  8027ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b1:	eb 07                	jmp    8027ba <fd_close+0xac>
		else
			r = 0;
  8027b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027be:	48 89 c6             	mov    %rax,%rsi
  8027c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c6:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  8027cd:	00 00 00 
  8027d0:	ff d0                	callq  *%rax
	return r;
  8027d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027d5:	c9                   	leaveq 
  8027d6:	c3                   	retq   

00000000008027d7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027d7:	55                   	push   %rbp
  8027d8:	48 89 e5             	mov    %rsp,%rbp
  8027db:	48 83 ec 20          	sub    $0x20,%rsp
  8027df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8027e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027ed:	eb 41                	jmp    802830 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8027ef:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027f6:	00 00 00 
  8027f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027fc:	48 63 d2             	movslq %edx,%rdx
  8027ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802803:	8b 00                	mov    (%rax),%eax
  802805:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802808:	75 22                	jne    80282c <dev_lookup+0x55>
			*dev = devtab[i];
  80280a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802811:	00 00 00 
  802814:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802817:	48 63 d2             	movslq %edx,%rdx
  80281a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80281e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802822:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	eb 60                	jmp    80288c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80282c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802830:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802837:	00 00 00 
  80283a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80283d:	48 63 d2             	movslq %edx,%rdx
  802840:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802844:	48 85 c0             	test   %rax,%rax
  802847:	75 a6                	jne    8027ef <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802849:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802850:	00 00 00 
  802853:	48 8b 00             	mov    (%rax),%rax
  802856:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80285c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80285f:	89 c6                	mov    %eax,%esi
  802861:	48 bf b8 4d 80 00 00 	movabs $0x804db8,%rdi
  802868:	00 00 00 
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  802877:	00 00 00 
  80287a:	ff d1                	callq  *%rcx
	*dev = 0;
  80287c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802880:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802887:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80288c:	c9                   	leaveq 
  80288d:	c3                   	retq   

000000000080288e <close>:

int
close(int fdnum)
{
  80288e:	55                   	push   %rbp
  80288f:	48 89 e5             	mov    %rsp,%rbp
  802892:	48 83 ec 20          	sub    $0x20,%rsp
  802896:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802899:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80289d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028a0:	48 89 d6             	mov    %rdx,%rsi
  8028a3:	89 c7                	mov    %eax,%edi
  8028a5:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  8028ac:	00 00 00 
  8028af:	ff d0                	callq  *%rax
  8028b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b8:	79 05                	jns    8028bf <close+0x31>
		return r;
  8028ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bd:	eb 18                	jmp    8028d7 <close+0x49>
	else
		return fd_close(fd, 1);
  8028bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c3:	be 01 00 00 00       	mov    $0x1,%esi
  8028c8:	48 89 c7             	mov    %rax,%rdi
  8028cb:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
}
  8028d7:	c9                   	leaveq 
  8028d8:	c3                   	retq   

00000000008028d9 <close_all>:

void
close_all(void)
{
  8028d9:	55                   	push   %rbp
  8028da:	48 89 e5             	mov    %rsp,%rbp
  8028dd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8028e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028e8:	eb 15                	jmp    8028ff <close_all+0x26>
		close(i);
  8028ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ed:	89 c7                	mov    %eax,%edi
  8028ef:	48 b8 8e 28 80 00 00 	movabs $0x80288e,%rax
  8028f6:	00 00 00 
  8028f9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8028fb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028ff:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802903:	7e e5                	jle    8028ea <close_all+0x11>
		close(i);
}
  802905:	c9                   	leaveq 
  802906:	c3                   	retq   

0000000000802907 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802907:	55                   	push   %rbp
  802908:	48 89 e5             	mov    %rsp,%rbp
  80290b:	48 83 ec 40          	sub    $0x40,%rsp
  80290f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802912:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802915:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802919:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80291c:	48 89 d6             	mov    %rdx,%rsi
  80291f:	89 c7                	mov    %eax,%edi
  802921:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802928:	00 00 00 
  80292b:	ff d0                	callq  *%rax
  80292d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802930:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802934:	79 08                	jns    80293e <dup+0x37>
		return r;
  802936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802939:	e9 70 01 00 00       	jmpq   802aae <dup+0x1a7>
	close(newfdnum);
  80293e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802941:	89 c7                	mov    %eax,%edi
  802943:	48 b8 8e 28 80 00 00 	movabs $0x80288e,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80294f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802952:	48 98                	cltq   
  802954:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80295a:	48 c1 e0 0c          	shl    $0xc,%rax
  80295e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802966:	48 89 c7             	mov    %rax,%rdi
  802969:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  802970:	00 00 00 
  802973:	ff d0                	callq  *%rax
  802975:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802979:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297d:	48 89 c7             	mov    %rax,%rdi
  802980:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  802987:	00 00 00 
  80298a:	ff d0                	callq  *%rax
  80298c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802994:	48 89 c2             	mov    %rax,%rdx
  802997:	48 c1 ea 15          	shr    $0x15,%rdx
  80299b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029a2:	01 00 00 
  8029a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029a9:	83 e0 01             	and    $0x1,%eax
  8029ac:	84 c0                	test   %al,%al
  8029ae:	74 71                	je     802a21 <dup+0x11a>
  8029b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b4:	48 89 c2             	mov    %rax,%rdx
  8029b7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029c2:	01 00 00 
  8029c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c9:	83 e0 01             	and    $0x1,%eax
  8029cc:	84 c0                	test   %al,%al
  8029ce:	74 51                	je     802a21 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d4:	48 89 c2             	mov    %rax,%rdx
  8029d7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029e2:	01 00 00 
  8029e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e9:	89 c1                	mov    %eax,%ecx
  8029eb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8029f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f9:	41 89 c8             	mov    %ecx,%r8d
  8029fc:	48 89 d1             	mov    %rdx,%rcx
  8029ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802a04:	48 89 c6             	mov    %rax,%rsi
  802a07:	bf 00 00 00 00       	mov    $0x0,%edi
  802a0c:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  802a13:	00 00 00 
  802a16:	ff d0                	callq  *%rax
  802a18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1f:	78 56                	js     802a77 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a25:	48 89 c2             	mov    %rax,%rdx
  802a28:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a2c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a33:	01 00 00 
  802a36:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a3a:	89 c1                	mov    %eax,%ecx
  802a3c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a4a:	41 89 c8             	mov    %ecx,%r8d
  802a4d:	48 89 d1             	mov    %rdx,%rcx
  802a50:	ba 00 00 00 00       	mov    $0x0,%edx
  802a55:	48 89 c6             	mov    %rax,%rsi
  802a58:	bf 00 00 00 00       	mov    $0x0,%edi
  802a5d:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax
  802a69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a70:	78 08                	js     802a7a <dup+0x173>
		goto err;

	return newfdnum;
  802a72:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a75:	eb 37                	jmp    802aae <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802a77:	90                   	nop
  802a78:	eb 01                	jmp    802a7b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802a7a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a7f:	48 89 c6             	mov    %rax,%rsi
  802a82:	bf 00 00 00 00       	mov    $0x0,%edi
  802a87:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  802a8e:	00 00 00 
  802a91:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a97:	48 89 c6             	mov    %rax,%rsi
  802a9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9f:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
	return r;
  802aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aae:	c9                   	leaveq 
  802aaf:	c3                   	retq   

0000000000802ab0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ab0:	55                   	push   %rbp
  802ab1:	48 89 e5             	mov    %rsp,%rbp
  802ab4:	48 83 ec 40          	sub    $0x40,%rsp
  802ab8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802abb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802abf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ac3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aca:	48 89 d6             	mov    %rdx,%rsi
  802acd:	89 c7                	mov    %eax,%edi
  802acf:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802ad6:	00 00 00 
  802ad9:	ff d0                	callq  *%rax
  802adb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ade:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae2:	78 24                	js     802b08 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ae4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae8:	8b 00                	mov    (%rax),%eax
  802aea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aee:	48 89 d6             	mov    %rdx,%rsi
  802af1:	89 c7                	mov    %eax,%edi
  802af3:	48 b8 d7 27 80 00 00 	movabs $0x8027d7,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
  802aff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b06:	79 05                	jns    802b0d <read+0x5d>
		return r;
  802b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0b:	eb 7a                	jmp    802b87 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b11:	8b 40 08             	mov    0x8(%rax),%eax
  802b14:	83 e0 03             	and    $0x3,%eax
  802b17:	83 f8 01             	cmp    $0x1,%eax
  802b1a:	75 3a                	jne    802b56 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b1c:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802b23:	00 00 00 
  802b26:	48 8b 00             	mov    (%rax),%rax
  802b29:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b2f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b32:	89 c6                	mov    %eax,%esi
  802b34:	48 bf d7 4d 80 00 00 	movabs $0x804dd7,%rdi
  802b3b:	00 00 00 
  802b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b43:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  802b4a:	00 00 00 
  802b4d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b54:	eb 31                	jmp    802b87 <read+0xd7>
	}
	if (!dev->dev_read)
  802b56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5a:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b5e:	48 85 c0             	test   %rax,%rax
  802b61:	75 07                	jne    802b6a <read+0xba>
		return -E_NOT_SUPP;
  802b63:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b68:	eb 1d                	jmp    802b87 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b7a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b7e:	48 89 ce             	mov    %rcx,%rsi
  802b81:	48 89 c7             	mov    %rax,%rdi
  802b84:	41 ff d0             	callq  *%r8
}
  802b87:	c9                   	leaveq 
  802b88:	c3                   	retq   

0000000000802b89 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b89:	55                   	push   %rbp
  802b8a:	48 89 e5             	mov    %rsp,%rbp
  802b8d:	48 83 ec 30          	sub    $0x30,%rsp
  802b91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b98:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ba3:	eb 46                	jmp    802beb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ba5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba8:	48 98                	cltq   
  802baa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bae:	48 29 c2             	sub    %rax,%rdx
  802bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb4:	48 98                	cltq   
  802bb6:	48 89 c1             	mov    %rax,%rcx
  802bb9:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802bbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bc0:	48 89 ce             	mov    %rcx,%rsi
  802bc3:	89 c7                	mov    %eax,%edi
  802bc5:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  802bcc:	00 00 00 
  802bcf:	ff d0                	callq  *%rax
  802bd1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802bd4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bd8:	79 05                	jns    802bdf <readn+0x56>
			return m;
  802bda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bdd:	eb 1d                	jmp    802bfc <readn+0x73>
		if (m == 0)
  802bdf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802be3:	74 13                	je     802bf8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802be5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802be8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bee:	48 98                	cltq   
  802bf0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802bf4:	72 af                	jb     802ba5 <readn+0x1c>
  802bf6:	eb 01                	jmp    802bf9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802bf8:	90                   	nop
	}
	return tot;
  802bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bfc:	c9                   	leaveq 
  802bfd:	c3                   	retq   

0000000000802bfe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802bfe:	55                   	push   %rbp
  802bff:	48 89 e5             	mov    %rsp,%rbp
  802c02:	48 83 ec 40          	sub    $0x40,%rsp
  802c06:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c0d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c18:	48 89 d6             	mov    %rdx,%rsi
  802c1b:	89 c7                	mov    %eax,%edi
  802c1d:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
  802c29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c30:	78 24                	js     802c56 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c36:	8b 00                	mov    (%rax),%eax
  802c38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c3c:	48 89 d6             	mov    %rdx,%rsi
  802c3f:	89 c7                	mov    %eax,%edi
  802c41:	48 b8 d7 27 80 00 00 	movabs $0x8027d7,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	callq  *%rax
  802c4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c54:	79 05                	jns    802c5b <write+0x5d>
		return r;
  802c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c59:	eb 79                	jmp    802cd4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5f:	8b 40 08             	mov    0x8(%rax),%eax
  802c62:	83 e0 03             	and    $0x3,%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	75 3a                	jne    802ca3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c69:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802c70:	00 00 00 
  802c73:	48 8b 00             	mov    (%rax),%rax
  802c76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c7f:	89 c6                	mov    %eax,%esi
  802c81:	48 bf f3 4d 80 00 00 	movabs $0x804df3,%rdi
  802c88:	00 00 00 
  802c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c90:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  802c97:	00 00 00 
  802c9a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ca1:	eb 31                	jmp    802cd4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ca3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca7:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cab:	48 85 c0             	test   %rax,%rax
  802cae:	75 07                	jne    802cb7 <write+0xb9>
		return -E_NOT_SUPP;
  802cb0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cb5:	eb 1d                	jmp    802cd4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbb:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802cbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cc7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ccb:	48 89 ce             	mov    %rcx,%rsi
  802cce:	48 89 c7             	mov    %rax,%rdi
  802cd1:	41 ff d0             	callq  *%r8
}
  802cd4:	c9                   	leaveq 
  802cd5:	c3                   	retq   

0000000000802cd6 <seek>:

int
seek(int fdnum, off_t offset)
{
  802cd6:	55                   	push   %rbp
  802cd7:	48 89 e5             	mov    %rsp,%rbp
  802cda:	48 83 ec 18          	sub    $0x18,%rsp
  802cde:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ce1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ce4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ce8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ceb:	48 89 d6             	mov    %rdx,%rsi
  802cee:	89 c7                	mov    %eax,%edi
  802cf0:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802cf7:	00 00 00 
  802cfa:	ff d0                	callq  *%rax
  802cfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d03:	79 05                	jns    802d0a <seek+0x34>
		return r;
  802d05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d08:	eb 0f                	jmp    802d19 <seek+0x43>
	fd->fd_offset = offset;
  802d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d11:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d19:	c9                   	leaveq 
  802d1a:	c3                   	retq   

0000000000802d1b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d1b:	55                   	push   %rbp
  802d1c:	48 89 e5             	mov    %rsp,%rbp
  802d1f:	48 83 ec 30          	sub    $0x30,%rsp
  802d23:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d26:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d29:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d2d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d30:	48 89 d6             	mov    %rdx,%rsi
  802d33:	89 c7                	mov    %eax,%edi
  802d35:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802d3c:	00 00 00 
  802d3f:	ff d0                	callq  *%rax
  802d41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d48:	78 24                	js     802d6e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4e:	8b 00                	mov    (%rax),%eax
  802d50:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d54:	48 89 d6             	mov    %rdx,%rsi
  802d57:	89 c7                	mov    %eax,%edi
  802d59:	48 b8 d7 27 80 00 00 	movabs $0x8027d7,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
  802d65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6c:	79 05                	jns    802d73 <ftruncate+0x58>
		return r;
  802d6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d71:	eb 72                	jmp    802de5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d77:	8b 40 08             	mov    0x8(%rax),%eax
  802d7a:	83 e0 03             	and    $0x3,%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	75 3a                	jne    802dbb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d81:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802d88:	00 00 00 
  802d8b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d8e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d94:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d97:	89 c6                	mov    %eax,%esi
  802d99:	48 bf 10 4e 80 00 00 	movabs $0x804e10,%rdi
  802da0:	00 00 00 
  802da3:	b8 00 00 00 00       	mov    $0x0,%eax
  802da8:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  802daf:	00 00 00 
  802db2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802db4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802db9:	eb 2a                	jmp    802de5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbf:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dc3:	48 85 c0             	test   %rax,%rax
  802dc6:	75 07                	jne    802dcf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dc8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dcd:	eb 16                	jmp    802de5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802dcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802dde:	89 d6                	mov    %edx,%esi
  802de0:	48 89 c7             	mov    %rax,%rdi
  802de3:	ff d1                	callq  *%rcx
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 30          	sub    $0x30,%rsp
  802def:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802df2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802df6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dfa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dfd:	48 89 d6             	mov    %rdx,%rsi
  802e00:	89 c7                	mov    %eax,%edi
  802e02:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
  802e0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e15:	78 24                	js     802e3b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1b:	8b 00                	mov    (%rax),%eax
  802e1d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e21:	48 89 d6             	mov    %rdx,%rsi
  802e24:	89 c7                	mov    %eax,%edi
  802e26:	48 b8 d7 27 80 00 00 	movabs $0x8027d7,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
  802e32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e39:	79 05                	jns    802e40 <fstat+0x59>
		return r;
  802e3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3e:	eb 5e                	jmp    802e9e <fstat+0xb7>
	if (!dev->dev_stat)
  802e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e44:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e48:	48 85 c0             	test   %rax,%rax
  802e4b:	75 07                	jne    802e54 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e4d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e52:	eb 4a                	jmp    802e9e <fstat+0xb7>
	stat->st_name[0] = 0;
  802e54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e58:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e5f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e66:	00 00 00 
	stat->st_isdir = 0;
  802e69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e6d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e74:	00 00 00 
	stat->st_dev = dev;
  802e77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e7f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e8a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e92:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802e96:	48 89 d6             	mov    %rdx,%rsi
  802e99:	48 89 c7             	mov    %rax,%rdi
  802e9c:	ff d1                	callq  *%rcx
}
  802e9e:	c9                   	leaveq 
  802e9f:	c3                   	retq   

0000000000802ea0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ea0:	55                   	push   %rbp
  802ea1:	48 89 e5             	mov    %rsp,%rbp
  802ea4:	48 83 ec 20          	sub    $0x20,%rsp
  802ea8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802eb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb4:	be 00 00 00 00       	mov    $0x0,%esi
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 8f 2f 80 00 00 	movabs $0x802f8f,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ecf:	79 05                	jns    802ed6 <stat+0x36>
		return fd;
  802ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed4:	eb 2f                	jmp    802f05 <stat+0x65>
	r = fstat(fd, stat);
  802ed6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edd:	48 89 d6             	mov    %rdx,%rsi
  802ee0:	89 c7                	mov    %eax,%edi
  802ee2:	48 b8 e7 2d 80 00 00 	movabs $0x802de7,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
  802eee:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef4:	89 c7                	mov    %eax,%edi
  802ef6:	48 b8 8e 28 80 00 00 	movabs $0x80288e,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
	return r;
  802f02:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f05:	c9                   	leaveq 
  802f06:	c3                   	retq   
	...

0000000000802f08 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f08:	55                   	push   %rbp
  802f09:	48 89 e5             	mov    %rsp,%rbp
  802f0c:	48 83 ec 10          	sub    $0x10,%rsp
  802f10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f17:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802f1e:	00 00 00 
  802f21:	8b 00                	mov    (%rax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	75 1d                	jne    802f44 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f27:	bf 01 00 00 00       	mov    $0x1,%edi
  802f2c:	48 b8 13 25 80 00 00 	movabs $0x802513,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
  802f38:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  802f3f:	00 00 00 
  802f42:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f44:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802f4b:	00 00 00 
  802f4e:	8b 00                	mov    (%rax),%eax
  802f50:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f53:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f58:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f5f:	00 00 00 
  802f62:	89 c7                	mov    %eax,%edi
  802f64:	48 b8 50 24 80 00 00 	movabs $0x802450,%rax
  802f6b:	00 00 00 
  802f6e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f74:	ba 00 00 00 00       	mov    $0x0,%edx
  802f79:	48 89 c6             	mov    %rax,%rsi
  802f7c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f81:	48 b8 90 23 80 00 00 	movabs $0x802390,%rax
  802f88:	00 00 00 
  802f8b:	ff d0                	callq  *%rax
}
  802f8d:	c9                   	leaveq 
  802f8e:	c3                   	retq   

0000000000802f8f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f8f:	55                   	push   %rbp
  802f90:	48 89 e5             	mov    %rsp,%rbp
  802f93:	48 83 ec 20          	sub    $0x20,%rsp
  802f97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f9b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa2:	48 89 c7             	mov    %rax,%rdi
  802fa5:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
  802fb1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fb6:	7e 0a                	jle    802fc2 <open+0x33>
                return -E_BAD_PATH;
  802fb8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fbd:	e9 a5 00 00 00       	jmpq   803067 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802fc2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fc6:	48 89 c7             	mov    %rax,%rdi
  802fc9:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  802fd0:	00 00 00 
  802fd3:	ff d0                	callq  *%rax
  802fd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fdc:	79 08                	jns    802fe6 <open+0x57>
		return r;
  802fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe1:	e9 81 00 00 00       	jmpq   803067 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fea:	48 89 c6             	mov    %rax,%rsi
  802fed:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ff4:	00 00 00 
  802ff7:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  802ffe:	00 00 00 
  803001:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  803003:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80300a:	00 00 00 
  80300d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803010:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  803016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301a:	48 89 c6             	mov    %rax,%rsi
  80301d:	bf 01 00 00 00       	mov    $0x1,%edi
  803022:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
  80302e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  803031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803035:	79 1d                	jns    803054 <open+0xc5>
	{
		fd_close(fd,0);
  803037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303b:	be 00 00 00 00       	mov    $0x0,%esi
  803040:	48 89 c7             	mov    %rax,%rdi
  803043:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
		return r;
  80304f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803052:	eb 13                	jmp    803067 <open+0xd8>
	}
	return fd2num(fd);
  803054:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803058:	48 89 c7             	mov    %rax,%rdi
  80305b:	48 b8 98 25 80 00 00 	movabs $0x802598,%rax
  803062:	00 00 00 
  803065:	ff d0                	callq  *%rax
	


}
  803067:	c9                   	leaveq 
  803068:	c3                   	retq   

0000000000803069 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803069:	55                   	push   %rbp
  80306a:	48 89 e5             	mov    %rsp,%rbp
  80306d:	48 83 ec 10          	sub    $0x10,%rsp
  803071:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803075:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803079:	8b 50 0c             	mov    0xc(%rax),%edx
  80307c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803083:	00 00 00 
  803086:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803088:	be 00 00 00 00       	mov    $0x0,%esi
  80308d:	bf 06 00 00 00       	mov    $0x6,%edi
  803092:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  803099:	00 00 00 
  80309c:	ff d0                	callq  *%rax
}
  80309e:	c9                   	leaveq 
  80309f:	c3                   	retq   

00000000008030a0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030a0:	55                   	push   %rbp
  8030a1:	48 89 e5             	mov    %rsp,%rbp
  8030a4:	48 83 ec 30          	sub    $0x30,%rsp
  8030a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b8:	8b 50 0c             	mov    0xc(%rax),%edx
  8030bb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030c2:	00 00 00 
  8030c5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8030c7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030ce:	00 00 00 
  8030d1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030d5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8030d9:	be 00 00 00 00       	mov    $0x0,%esi
  8030de:	bf 03 00 00 00       	mov    $0x3,%edi
  8030e3:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  8030ea:	00 00 00 
  8030ed:	ff d0                	callq  *%rax
  8030ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f6:	79 05                	jns    8030fd <devfile_read+0x5d>
	{
		return r;
  8030f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fb:	eb 2c                	jmp    803129 <devfile_read+0x89>
	}
	if(r > 0)
  8030fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803101:	7e 23                	jle    803126 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  803103:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803106:	48 63 d0             	movslq %eax,%rdx
  803109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803114:	00 00 00 
  803117:	48 89 c7             	mov    %rax,%rdi
  80311a:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  803121:	00 00 00 
  803124:	ff d0                	callq  *%rax
	return r;
  803126:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  803129:	c9                   	leaveq 
  80312a:	c3                   	retq   

000000000080312b <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80312b:	55                   	push   %rbp
  80312c:	48 89 e5             	mov    %rsp,%rbp
  80312f:	48 83 ec 30          	sub    $0x30,%rsp
  803133:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803137:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80313b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80313f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803143:	8b 50 0c             	mov    0xc(%rax),%edx
  803146:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80314d:	00 00 00 
  803150:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  803152:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803159:	00 
  80315a:	76 08                	jbe    803164 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  80315c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803163:	00 
	fsipcbuf.write.req_n=n;
  803164:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80316b:	00 00 00 
  80316e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803172:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803176:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80317a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317e:	48 89 c6             	mov    %rax,%rsi
  803181:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803188:	00 00 00 
  80318b:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  803197:	be 00 00 00 00       	mov    $0x0,%esi
  80319c:	bf 04 00 00 00       	mov    $0x4,%edi
  8031a1:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
  8031ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8031b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031b3:	c9                   	leaveq 
  8031b4:	c3                   	retq   

00000000008031b5 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8031b5:	55                   	push   %rbp
  8031b6:	48 89 e5             	mov    %rsp,%rbp
  8031b9:	48 83 ec 10          	sub    $0x10,%rsp
  8031bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031c1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c8:	8b 50 0c             	mov    0xc(%rax),%edx
  8031cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d2:	00 00 00 
  8031d5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8031d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031de:	00 00 00 
  8031e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031e4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031e7:	be 00 00 00 00       	mov    $0x0,%esi
  8031ec:	bf 02 00 00 00       	mov    $0x2,%edi
  8031f1:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  8031f8:	00 00 00 
  8031fb:	ff d0                	callq  *%rax
}
  8031fd:	c9                   	leaveq 
  8031fe:	c3                   	retq   

00000000008031ff <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8031ff:	55                   	push   %rbp
  803200:	48 89 e5             	mov    %rsp,%rbp
  803203:	48 83 ec 20          	sub    $0x20,%rsp
  803207:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80320b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80320f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803213:	8b 50 0c             	mov    0xc(%rax),%edx
  803216:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80321d:	00 00 00 
  803220:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803222:	be 00 00 00 00       	mov    $0x0,%esi
  803227:	bf 05 00 00 00       	mov    $0x5,%edi
  80322c:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  803233:	00 00 00 
  803236:	ff d0                	callq  *%rax
  803238:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323f:	79 05                	jns    803246 <devfile_stat+0x47>
		return r;
  803241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803244:	eb 56                	jmp    80329c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803246:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80324a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803251:	00 00 00 
  803254:	48 89 c7             	mov    %rax,%rdi
  803257:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803263:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80326a:	00 00 00 
  80326d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803273:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803277:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80327d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803284:	00 00 00 
  803287:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80328d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803291:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80329c:	c9                   	leaveq 
  80329d:	c3                   	retq   
	...

00000000008032a0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8032a0:	55                   	push   %rbp
  8032a1:	48 89 e5             	mov    %rsp,%rbp
  8032a4:	48 83 ec 20          	sub    $0x20,%rsp
  8032a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8032ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032b2:	48 89 d6             	mov    %rdx,%rsi
  8032b5:	89 c7                	mov    %eax,%edi
  8032b7:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ca:	79 05                	jns    8032d1 <fd2sockid+0x31>
		return r;
  8032cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032cf:	eb 24                	jmp    8032f5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8032d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d5:	8b 10                	mov    (%rax),%edx
  8032d7:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8032de:	00 00 00 
  8032e1:	8b 00                	mov    (%rax),%eax
  8032e3:	39 c2                	cmp    %eax,%edx
  8032e5:	74 07                	je     8032ee <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8032e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032ec:	eb 07                	jmp    8032f5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8032ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8032f5:	c9                   	leaveq 
  8032f6:	c3                   	retq   

00000000008032f7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8032f7:	55                   	push   %rbp
  8032f8:	48 89 e5             	mov    %rsp,%rbp
  8032fb:	48 83 ec 20          	sub    $0x20,%rsp
  8032ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803302:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803306:	48 89 c7             	mov    %rax,%rdi
  803309:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  803310:	00 00 00 
  803313:	ff d0                	callq  *%rax
  803315:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803318:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331c:	78 26                	js     803344 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80331e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803322:	ba 07 04 00 00       	mov    $0x407,%edx
  803327:	48 89 c6             	mov    %rax,%rsi
  80332a:	bf 00 00 00 00       	mov    $0x0,%edi
  80332f:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  803336:	00 00 00 
  803339:	ff d0                	callq  *%rax
  80333b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80333e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803342:	79 16                	jns    80335a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803344:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803347:	89 c7                	mov    %eax,%edi
  803349:	48 b8 04 38 80 00 00 	movabs $0x803804,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
		return r;
  803355:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803358:	eb 3a                	jmp    803394 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80335a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80335e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803365:	00 00 00 
  803368:	8b 12                	mov    (%rdx),%edx
  80336a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80336c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803370:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80337e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803385:	48 89 c7             	mov    %rax,%rdi
  803388:	48 b8 98 25 80 00 00 	movabs $0x802598,%rax
  80338f:	00 00 00 
  803392:	ff d0                	callq  *%rax
}
  803394:	c9                   	leaveq 
  803395:	c3                   	retq   

0000000000803396 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803396:	55                   	push   %rbp
  803397:	48 89 e5             	mov    %rsp,%rbp
  80339a:	48 83 ec 30          	sub    $0x30,%rsp
  80339e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ac:	89 c7                	mov    %eax,%edi
  8033ae:	48 b8 a0 32 80 00 00 	movabs $0x8032a0,%rax
  8033b5:	00 00 00 
  8033b8:	ff d0                	callq  *%rax
  8033ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c1:	79 05                	jns    8033c8 <accept+0x32>
		return r;
  8033c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c6:	eb 3b                	jmp    803403 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8033c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033cc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d3:	48 89 ce             	mov    %rcx,%rsi
  8033d6:	89 c7                	mov    %eax,%edi
  8033d8:	48 b8 e1 36 80 00 00 	movabs $0x8036e1,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
  8033e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033eb:	79 05                	jns    8033f2 <accept+0x5c>
		return r;
  8033ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f0:	eb 11                	jmp    803403 <accept+0x6d>
	return alloc_sockfd(r);
  8033f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f5:	89 c7                	mov    %eax,%edi
  8033f7:	48 b8 f7 32 80 00 00 	movabs $0x8032f7,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
}
  803403:	c9                   	leaveq 
  803404:	c3                   	retq   

0000000000803405 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803405:	55                   	push   %rbp
  803406:	48 89 e5             	mov    %rsp,%rbp
  803409:	48 83 ec 20          	sub    $0x20,%rsp
  80340d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803410:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803414:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803417:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80341a:	89 c7                	mov    %eax,%edi
  80341c:	48 b8 a0 32 80 00 00 	movabs $0x8032a0,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
  803428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80342f:	79 05                	jns    803436 <bind+0x31>
		return r;
  803431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803434:	eb 1b                	jmp    803451 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803436:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803439:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80343d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803440:	48 89 ce             	mov    %rcx,%rsi
  803443:	89 c7                	mov    %eax,%edi
  803445:	48 b8 60 37 80 00 00 	movabs $0x803760,%rax
  80344c:	00 00 00 
  80344f:	ff d0                	callq  *%rax
}
  803451:	c9                   	leaveq 
  803452:	c3                   	retq   

0000000000803453 <shutdown>:

int
shutdown(int s, int how)
{
  803453:	55                   	push   %rbp
  803454:	48 89 e5             	mov    %rsp,%rbp
  803457:	48 83 ec 20          	sub    $0x20,%rsp
  80345b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80345e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803461:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803464:	89 c7                	mov    %eax,%edi
  803466:	48 b8 a0 32 80 00 00 	movabs $0x8032a0,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
  803472:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803475:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803479:	79 05                	jns    803480 <shutdown+0x2d>
		return r;
  80347b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347e:	eb 16                	jmp    803496 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803480:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803486:	89 d6                	mov    %edx,%esi
  803488:	89 c7                	mov    %eax,%edi
  80348a:	48 b8 c4 37 80 00 00 	movabs $0x8037c4,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
}
  803496:	c9                   	leaveq 
  803497:	c3                   	retq   

0000000000803498 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803498:	55                   	push   %rbp
  803499:	48 89 e5             	mov    %rsp,%rbp
  80349c:	48 83 ec 10          	sub    $0x10,%rsp
  8034a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8034a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a8:	48 89 c7             	mov    %rax,%rdi
  8034ab:	48 b8 8c 45 80 00 00 	movabs $0x80458c,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	83 f8 01             	cmp    $0x1,%eax
  8034ba:	75 17                	jne    8034d3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8034bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c0:	8b 40 0c             	mov    0xc(%rax),%eax
  8034c3:	89 c7                	mov    %eax,%edi
  8034c5:	48 b8 04 38 80 00 00 	movabs $0x803804,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	callq  *%rax
  8034d1:	eb 05                	jmp    8034d8 <devsock_close+0x40>
	else
		return 0;
  8034d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034d8:	c9                   	leaveq 
  8034d9:	c3                   	retq   

00000000008034da <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8034da:	55                   	push   %rbp
  8034db:	48 89 e5             	mov    %rsp,%rbp
  8034de:	48 83 ec 20          	sub    $0x20,%rsp
  8034e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034e9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ef:	89 c7                	mov    %eax,%edi
  8034f1:	48 b8 a0 32 80 00 00 	movabs $0x8032a0,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	callq  *%rax
  8034fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803500:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803504:	79 05                	jns    80350b <connect+0x31>
		return r;
  803506:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803509:	eb 1b                	jmp    803526 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80350b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80350e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803512:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803515:	48 89 ce             	mov    %rcx,%rsi
  803518:	89 c7                	mov    %eax,%edi
  80351a:	48 b8 31 38 80 00 00 	movabs $0x803831,%rax
  803521:	00 00 00 
  803524:	ff d0                	callq  *%rax
}
  803526:	c9                   	leaveq 
  803527:	c3                   	retq   

0000000000803528 <listen>:

int
listen(int s, int backlog)
{
  803528:	55                   	push   %rbp
  803529:	48 89 e5             	mov    %rsp,%rbp
  80352c:	48 83 ec 20          	sub    $0x20,%rsp
  803530:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803533:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803536:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803539:	89 c7                	mov    %eax,%edi
  80353b:	48 b8 a0 32 80 00 00 	movabs $0x8032a0,%rax
  803542:	00 00 00 
  803545:	ff d0                	callq  *%rax
  803547:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354e:	79 05                	jns    803555 <listen+0x2d>
		return r;
  803550:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803553:	eb 16                	jmp    80356b <listen+0x43>
	return nsipc_listen(r, backlog);
  803555:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803558:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355b:	89 d6                	mov    %edx,%esi
  80355d:	89 c7                	mov    %eax,%edi
  80355f:	48 b8 95 38 80 00 00 	movabs $0x803895,%rax
  803566:	00 00 00 
  803569:	ff d0                	callq  *%rax
}
  80356b:	c9                   	leaveq 
  80356c:	c3                   	retq   

000000000080356d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80356d:	55                   	push   %rbp
  80356e:	48 89 e5             	mov    %rsp,%rbp
  803571:	48 83 ec 20          	sub    $0x20,%rsp
  803575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803579:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80357d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803585:	89 c2                	mov    %eax,%edx
  803587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358b:	8b 40 0c             	mov    0xc(%rax),%eax
  80358e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803592:	b9 00 00 00 00       	mov    $0x0,%ecx
  803597:	89 c7                	mov    %eax,%edi
  803599:	48 b8 d5 38 80 00 00 	movabs $0x8038d5,%rax
  8035a0:	00 00 00 
  8035a3:	ff d0                	callq  *%rax
}
  8035a5:	c9                   	leaveq 
  8035a6:	c3                   	retq   

00000000008035a7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8035a7:	55                   	push   %rbp
  8035a8:	48 89 e5             	mov    %rsp,%rbp
  8035ab:	48 83 ec 20          	sub    $0x20,%rsp
  8035af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8035bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035bf:	89 c2                	mov    %eax,%edx
  8035c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c5:	8b 40 0c             	mov    0xc(%rax),%eax
  8035c8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8035cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8035d1:	89 c7                	mov    %eax,%edi
  8035d3:	48 b8 a1 39 80 00 00 	movabs $0x8039a1,%rax
  8035da:	00 00 00 
  8035dd:	ff d0                	callq  *%rax
}
  8035df:	c9                   	leaveq 
  8035e0:	c3                   	retq   

00000000008035e1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035e1:	55                   	push   %rbp
  8035e2:	48 89 e5             	mov    %rsp,%rbp
  8035e5:	48 83 ec 10          	sub    $0x10,%rsp
  8035e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8035f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f5:	48 be 3b 4e 80 00 00 	movabs $0x804e3b,%rsi
  8035fc:	00 00 00 
  8035ff:	48 89 c7             	mov    %rax,%rdi
  803602:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  803609:	00 00 00 
  80360c:	ff d0                	callq  *%rax
	return 0;
  80360e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803613:	c9                   	leaveq 
  803614:	c3                   	retq   

0000000000803615 <socket>:

int
socket(int domain, int type, int protocol)
{
  803615:	55                   	push   %rbp
  803616:	48 89 e5             	mov    %rsp,%rbp
  803619:	48 83 ec 20          	sub    $0x20,%rsp
  80361d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803620:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803623:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803626:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803629:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80362c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80362f:	89 ce                	mov    %ecx,%esi
  803631:	89 c7                	mov    %eax,%edi
  803633:	48 b8 59 3a 80 00 00 	movabs $0x803a59,%rax
  80363a:	00 00 00 
  80363d:	ff d0                	callq  *%rax
  80363f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803642:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803646:	79 05                	jns    80364d <socket+0x38>
		return r;
  803648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364b:	eb 11                	jmp    80365e <socket+0x49>
	return alloc_sockfd(r);
  80364d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803650:	89 c7                	mov    %eax,%edi
  803652:	48 b8 f7 32 80 00 00 	movabs $0x8032f7,%rax
  803659:	00 00 00 
  80365c:	ff d0                	callq  *%rax
}
  80365e:	c9                   	leaveq 
  80365f:	c3                   	retq   

0000000000803660 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803660:	55                   	push   %rbp
  803661:	48 89 e5             	mov    %rsp,%rbp
  803664:	48 83 ec 10          	sub    $0x10,%rsp
  803668:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80366b:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803672:	00 00 00 
  803675:	8b 00                	mov    (%rax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	75 1d                	jne    803698 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80367b:	bf 02 00 00 00       	mov    $0x2,%edi
  803680:	48 b8 13 25 80 00 00 	movabs $0x802513,%rax
  803687:	00 00 00 
  80368a:	ff d0                	callq  *%rax
  80368c:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  803693:	00 00 00 
  803696:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803698:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80369f:	00 00 00 
  8036a2:	8b 00                	mov    (%rax),%eax
  8036a4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8036a7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8036ac:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8036b3:	00 00 00 
  8036b6:	89 c7                	mov    %eax,%edi
  8036b8:	48 b8 50 24 80 00 00 	movabs $0x802450,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8036c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8036c9:	be 00 00 00 00       	mov    $0x0,%esi
  8036ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d3:	48 b8 90 23 80 00 00 	movabs $0x802390,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
}
  8036df:	c9                   	leaveq 
  8036e0:	c3                   	retq   

00000000008036e1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036e1:	55                   	push   %rbp
  8036e2:	48 89 e5             	mov    %rsp,%rbp
  8036e5:	48 83 ec 30          	sub    $0x30,%rsp
  8036e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8036f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036fb:	00 00 00 
  8036fe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803701:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803703:	bf 01 00 00 00       	mov    $0x1,%edi
  803708:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  80370f:	00 00 00 
  803712:	ff d0                	callq  *%rax
  803714:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803717:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80371b:	78 3e                	js     80375b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80371d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803724:	00 00 00 
  803727:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80372b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372f:	8b 40 10             	mov    0x10(%rax),%eax
  803732:	89 c2                	mov    %eax,%edx
  803734:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803738:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80373c:	48 89 ce             	mov    %rcx,%rsi
  80373f:	48 89 c7             	mov    %rax,%rdi
  803742:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  803749:	00 00 00 
  80374c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80374e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803752:	8b 50 10             	mov    0x10(%rax),%edx
  803755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803759:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80375b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80375e:	c9                   	leaveq 
  80375f:	c3                   	retq   

0000000000803760 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803760:	55                   	push   %rbp
  803761:	48 89 e5             	mov    %rsp,%rbp
  803764:	48 83 ec 10          	sub    $0x10,%rsp
  803768:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80376b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80376f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803772:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803779:	00 00 00 
  80377c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80377f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803781:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803784:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803788:	48 89 c6             	mov    %rax,%rsi
  80378b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803792:	00 00 00 
  803795:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8037a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037a8:	00 00 00 
  8037ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037ae:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8037b1:	bf 02 00 00 00       	mov    $0x2,%edi
  8037b6:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  8037bd:	00 00 00 
  8037c0:	ff d0                	callq  *%rax
}
  8037c2:	c9                   	leaveq 
  8037c3:	c3                   	retq   

00000000008037c4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8037c4:	55                   	push   %rbp
  8037c5:	48 89 e5             	mov    %rsp,%rbp
  8037c8:	48 83 ec 10          	sub    $0x10,%rsp
  8037cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037cf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8037d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037d9:	00 00 00 
  8037dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8037e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e8:	00 00 00 
  8037eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037ee:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8037f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8037f6:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  8037fd:	00 00 00 
  803800:	ff d0                	callq  *%rax
}
  803802:	c9                   	leaveq 
  803803:	c3                   	retq   

0000000000803804 <nsipc_close>:

int
nsipc_close(int s)
{
  803804:	55                   	push   %rbp
  803805:	48 89 e5             	mov    %rsp,%rbp
  803808:	48 83 ec 10          	sub    $0x10,%rsp
  80380c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80380f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803816:	00 00 00 
  803819:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80381c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80381e:	bf 04 00 00 00       	mov    $0x4,%edi
  803823:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
}
  80382f:	c9                   	leaveq 
  803830:	c3                   	retq   

0000000000803831 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803831:	55                   	push   %rbp
  803832:	48 89 e5             	mov    %rsp,%rbp
  803835:	48 83 ec 10          	sub    $0x10,%rsp
  803839:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80383c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803840:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803843:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80384a:	00 00 00 
  80384d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803850:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803852:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803855:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803859:	48 89 c6             	mov    %rax,%rsi
  80385c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803863:	00 00 00 
  803866:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  80386d:	00 00 00 
  803870:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803872:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803879:	00 00 00 
  80387c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80387f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803882:	bf 05 00 00 00       	mov    $0x5,%edi
  803887:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  80388e:	00 00 00 
  803891:	ff d0                	callq  *%rax
}
  803893:	c9                   	leaveq 
  803894:	c3                   	retq   

0000000000803895 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803895:	55                   	push   %rbp
  803896:	48 89 e5             	mov    %rsp,%rbp
  803899:	48 83 ec 10          	sub    $0x10,%rsp
  80389d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038a0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8038a3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038aa:	00 00 00 
  8038ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038b0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8038b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b9:	00 00 00 
  8038bc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038bf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8038c2:	bf 06 00 00 00       	mov    $0x6,%edi
  8038c7:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
}
  8038d3:	c9                   	leaveq 
  8038d4:	c3                   	retq   

00000000008038d5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8038d5:	55                   	push   %rbp
  8038d6:	48 89 e5             	mov    %rsp,%rbp
  8038d9:	48 83 ec 30          	sub    $0x30,%rsp
  8038dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038e4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8038e7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8038ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f1:	00 00 00 
  8038f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038f7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8038f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803900:	00 00 00 
  803903:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803906:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803909:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803910:	00 00 00 
  803913:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803916:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803919:	bf 07 00 00 00       	mov    $0x7,%edi
  80391e:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
  80392a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803931:	78 69                	js     80399c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803933:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80393a:	7f 08                	jg     803944 <nsipc_recv+0x6f>
  80393c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803942:	7e 35                	jle    803979 <nsipc_recv+0xa4>
  803944:	48 b9 42 4e 80 00 00 	movabs $0x804e42,%rcx
  80394b:	00 00 00 
  80394e:	48 ba 57 4e 80 00 00 	movabs $0x804e57,%rdx
  803955:	00 00 00 
  803958:	be 61 00 00 00       	mov    $0x61,%esi
  80395d:	48 bf 6c 4e 80 00 00 	movabs $0x804e6c,%rdi
  803964:	00 00 00 
  803967:	b8 00 00 00 00       	mov    $0x0,%eax
  80396c:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  803973:	00 00 00 
  803976:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397c:	48 63 d0             	movslq %eax,%rdx
  80397f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803983:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80398a:	00 00 00 
  80398d:	48 89 c7             	mov    %rax,%rdi
  803990:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  803997:	00 00 00 
  80399a:	ff d0                	callq  *%rax
	}

	return r;
  80399c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80399f:	c9                   	leaveq 
  8039a0:	c3                   	retq   

00000000008039a1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8039a1:	55                   	push   %rbp
  8039a2:	48 89 e5             	mov    %rsp,%rbp
  8039a5:	48 83 ec 20          	sub    $0x20,%rsp
  8039a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039b0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8039b3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8039b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039bd:	00 00 00 
  8039c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039c3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8039c5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8039cc:	7e 35                	jle    803a03 <nsipc_send+0x62>
  8039ce:	48 b9 78 4e 80 00 00 	movabs $0x804e78,%rcx
  8039d5:	00 00 00 
  8039d8:	48 ba 57 4e 80 00 00 	movabs $0x804e57,%rdx
  8039df:	00 00 00 
  8039e2:	be 6c 00 00 00       	mov    $0x6c,%esi
  8039e7:	48 bf 6c 4e 80 00 00 	movabs $0x804e6c,%rdi
  8039ee:	00 00 00 
  8039f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f6:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  8039fd:	00 00 00 
  803a00:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a06:	48 63 d0             	movslq %eax,%rdx
  803a09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0d:	48 89 c6             	mov    %rax,%rsi
  803a10:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803a17:	00 00 00 
  803a1a:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  803a21:	00 00 00 
  803a24:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803a26:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a2d:	00 00 00 
  803a30:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a33:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803a36:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a3d:	00 00 00 
  803a40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a43:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803a46:	bf 08 00 00 00       	mov    $0x8,%edi
  803a4b:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  803a52:	00 00 00 
  803a55:	ff d0                	callq  *%rax
}
  803a57:	c9                   	leaveq 
  803a58:	c3                   	retq   

0000000000803a59 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a59:	55                   	push   %rbp
  803a5a:	48 89 e5             	mov    %rsp,%rbp
  803a5d:	48 83 ec 10          	sub    $0x10,%rsp
  803a61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a64:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a67:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803a6a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a71:	00 00 00 
  803a74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a77:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803a79:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a80:	00 00 00 
  803a83:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a86:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a89:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a90:	00 00 00 
  803a93:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a96:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a99:	bf 09 00 00 00       	mov    $0x9,%edi
  803a9e:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  803aa5:	00 00 00 
  803aa8:	ff d0                	callq  *%rax
}
  803aaa:	c9                   	leaveq 
  803aab:	c3                   	retq   

0000000000803aac <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803aac:	55                   	push   %rbp
  803aad:	48 89 e5             	mov    %rsp,%rbp
  803ab0:	53                   	push   %rbx
  803ab1:	48 83 ec 38          	sub    $0x38,%rsp
  803ab5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ab9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803abd:	48 89 c7             	mov    %rax,%rdi
  803ac0:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  803ac7:	00 00 00 
  803aca:	ff d0                	callq  *%rax
  803acc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803acf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ad3:	0f 88 bf 01 00 00    	js     803c98 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ad9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803add:	ba 07 04 00 00       	mov    $0x407,%edx
  803ae2:	48 89 c6             	mov    %rax,%rsi
  803ae5:	bf 00 00 00 00       	mov    $0x0,%edi
  803aea:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  803af1:	00 00 00 
  803af4:	ff d0                	callq  *%rax
  803af6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803af9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803afd:	0f 88 95 01 00 00    	js     803c98 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803b03:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803b07:	48 89 c7             	mov    %rax,%rdi
  803b0a:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  803b11:	00 00 00 
  803b14:	ff d0                	callq  *%rax
  803b16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b1d:	0f 88 5d 01 00 00    	js     803c80 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b27:	ba 07 04 00 00       	mov    $0x407,%edx
  803b2c:	48 89 c6             	mov    %rax,%rsi
  803b2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b34:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  803b3b:	00 00 00 
  803b3e:	ff d0                	callq  *%rax
  803b40:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b43:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b47:	0f 88 33 01 00 00    	js     803c80 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803b4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b51:	48 89 c7             	mov    %rax,%rdi
  803b54:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  803b5b:	00 00 00 
  803b5e:	ff d0                	callq  *%rax
  803b60:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b68:	ba 07 04 00 00       	mov    $0x407,%edx
  803b6d:	48 89 c6             	mov    %rax,%rsi
  803b70:	bf 00 00 00 00       	mov    $0x0,%edi
  803b75:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  803b7c:	00 00 00 
  803b7f:	ff d0                	callq  *%rax
  803b81:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b84:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b88:	0f 88 d9 00 00 00    	js     803c67 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b92:	48 89 c7             	mov    %rax,%rdi
  803b95:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  803b9c:	00 00 00 
  803b9f:	ff d0                	callq  *%rax
  803ba1:	48 89 c2             	mov    %rax,%rdx
  803ba4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803bae:	48 89 d1             	mov    %rdx,%rcx
  803bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  803bb6:	48 89 c6             	mov    %rax,%rsi
  803bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  803bbe:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  803bc5:	00 00 00 
  803bc8:	ff d0                	callq  *%rax
  803bca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bd1:	78 79                	js     803c4c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803bde:	00 00 00 
  803be1:	8b 12                	mov    (%rdx),%edx
  803be3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803be5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803bf0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803bfb:	00 00 00 
  803bfe:	8b 12                	mov    (%rdx),%edx
  803c00:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803c02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c06:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c11:	48 89 c7             	mov    %rax,%rdi
  803c14:	48 b8 98 25 80 00 00 	movabs $0x802598,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
  803c20:	89 c2                	mov    %eax,%edx
  803c22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c26:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803c28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c2c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803c30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c34:	48 89 c7             	mov    %rax,%rdi
  803c37:	48 b8 98 25 80 00 00 	movabs $0x802598,%rax
  803c3e:	00 00 00 
  803c41:	ff d0                	callq  *%rax
  803c43:	89 03                	mov    %eax,(%rbx)
	return 0;
  803c45:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4a:	eb 4f                	jmp    803c9b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803c4c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c51:	48 89 c6             	mov    %rax,%rsi
  803c54:	bf 00 00 00 00       	mov    $0x0,%edi
  803c59:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  803c60:	00 00 00 
  803c63:	ff d0                	callq  *%rax
  803c65:	eb 01                	jmp    803c68 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803c67:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803c68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c6c:	48 89 c6             	mov    %rax,%rsi
  803c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c74:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  803c7b:	00 00 00 
  803c7e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803c80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c84:	48 89 c6             	mov    %rax,%rsi
  803c87:	bf 00 00 00 00       	mov    $0x0,%edi
  803c8c:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  803c93:	00 00 00 
  803c96:	ff d0                	callq  *%rax
    err:
	return r;
  803c98:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c9b:	48 83 c4 38          	add    $0x38,%rsp
  803c9f:	5b                   	pop    %rbx
  803ca0:	5d                   	pop    %rbp
  803ca1:	c3                   	retq   

0000000000803ca2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ca2:	55                   	push   %rbp
  803ca3:	48 89 e5             	mov    %rsp,%rbp
  803ca6:	53                   	push   %rbx
  803ca7:	48 83 ec 28          	sub    $0x28,%rsp
  803cab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803caf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cb3:	eb 01                	jmp    803cb6 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803cb5:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803cb6:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803cbd:	00 00 00 
  803cc0:	48 8b 00             	mov    (%rax),%rax
  803cc3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803cc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ccc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd0:	48 89 c7             	mov    %rax,%rdi
  803cd3:	48 b8 8c 45 80 00 00 	movabs $0x80458c,%rax
  803cda:	00 00 00 
  803cdd:	ff d0                	callq  *%rax
  803cdf:	89 c3                	mov    %eax,%ebx
  803ce1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ce5:	48 89 c7             	mov    %rax,%rdi
  803ce8:	48 b8 8c 45 80 00 00 	movabs $0x80458c,%rax
  803cef:	00 00 00 
  803cf2:	ff d0                	callq  *%rax
  803cf4:	39 c3                	cmp    %eax,%ebx
  803cf6:	0f 94 c0             	sete   %al
  803cf9:	0f b6 c0             	movzbl %al,%eax
  803cfc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803cff:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803d06:	00 00 00 
  803d09:	48 8b 00             	mov    (%rax),%rax
  803d0c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d12:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803d15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d18:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d1b:	75 0a                	jne    803d27 <_pipeisclosed+0x85>
			return ret;
  803d1d:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803d20:	48 83 c4 28          	add    $0x28,%rsp
  803d24:	5b                   	pop    %rbx
  803d25:	5d                   	pop    %rbp
  803d26:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803d27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d2a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d2d:	74 86                	je     803cb5 <_pipeisclosed+0x13>
  803d2f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803d33:	75 80                	jne    803cb5 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803d35:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803d3c:	00 00 00 
  803d3f:	48 8b 00             	mov    (%rax),%rax
  803d42:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803d48:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d4e:	89 c6                	mov    %eax,%esi
  803d50:	48 bf 89 4e 80 00 00 	movabs $0x804e89,%rdi
  803d57:	00 00 00 
  803d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d5f:	49 b8 97 04 80 00 00 	movabs $0x800497,%r8
  803d66:	00 00 00 
  803d69:	41 ff d0             	callq  *%r8
	}
  803d6c:	e9 44 ff ff ff       	jmpq   803cb5 <_pipeisclosed+0x13>

0000000000803d71 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803d71:	55                   	push   %rbp
  803d72:	48 89 e5             	mov    %rsp,%rbp
  803d75:	48 83 ec 30          	sub    $0x30,%rsp
  803d79:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d7c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d80:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d83:	48 89 d6             	mov    %rdx,%rsi
  803d86:	89 c7                	mov    %eax,%edi
  803d88:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  803d8f:	00 00 00 
  803d92:	ff d0                	callq  *%rax
  803d94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d9b:	79 05                	jns    803da2 <pipeisclosed+0x31>
		return r;
  803d9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da0:	eb 31                	jmp    803dd3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803da2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803da6:	48 89 c7             	mov    %rax,%rdi
  803da9:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  803db0:	00 00 00 
  803db3:	ff d0                	callq  *%rax
  803db5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803db9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dc1:	48 89 d6             	mov    %rdx,%rsi
  803dc4:	48 89 c7             	mov    %rax,%rdi
  803dc7:	48 b8 a2 3c 80 00 00 	movabs $0x803ca2,%rax
  803dce:	00 00 00 
  803dd1:	ff d0                	callq  *%rax
}
  803dd3:	c9                   	leaveq 
  803dd4:	c3                   	retq   

0000000000803dd5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803dd5:	55                   	push   %rbp
  803dd6:	48 89 e5             	mov    %rsp,%rbp
  803dd9:	48 83 ec 40          	sub    $0x40,%rsp
  803ddd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803de1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803de5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ded:	48 89 c7             	mov    %rax,%rdi
  803df0:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  803df7:	00 00 00 
  803dfa:	ff d0                	callq  *%rax
  803dfc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e08:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e0f:	00 
  803e10:	e9 97 00 00 00       	jmpq   803eac <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e15:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e1a:	74 09                	je     803e25 <devpipe_read+0x50>
				return i;
  803e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e20:	e9 95 00 00 00       	jmpq   803eba <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e2d:	48 89 d6             	mov    %rdx,%rsi
  803e30:	48 89 c7             	mov    %rax,%rdi
  803e33:	48 b8 a2 3c 80 00 00 	movabs $0x803ca2,%rax
  803e3a:	00 00 00 
  803e3d:	ff d0                	callq  *%rax
  803e3f:	85 c0                	test   %eax,%eax
  803e41:	74 07                	je     803e4a <devpipe_read+0x75>
				return 0;
  803e43:	b8 00 00 00 00       	mov    $0x0,%eax
  803e48:	eb 70                	jmp    803eba <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e4a:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  803e51:	00 00 00 
  803e54:	ff d0                	callq  *%rax
  803e56:	eb 01                	jmp    803e59 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e58:	90                   	nop
  803e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5d:	8b 10                	mov    (%rax),%edx
  803e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e63:	8b 40 04             	mov    0x4(%rax),%eax
  803e66:	39 c2                	cmp    %eax,%edx
  803e68:	74 ab                	je     803e15 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e72:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7a:	8b 00                	mov    (%rax),%eax
  803e7c:	89 c2                	mov    %eax,%edx
  803e7e:	c1 fa 1f             	sar    $0x1f,%edx
  803e81:	c1 ea 1b             	shr    $0x1b,%edx
  803e84:	01 d0                	add    %edx,%eax
  803e86:	83 e0 1f             	and    $0x1f,%eax
  803e89:	29 d0                	sub    %edx,%eax
  803e8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e8f:	48 98                	cltq   
  803e91:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e96:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e9c:	8b 00                	mov    (%rax),%eax
  803e9e:	8d 50 01             	lea    0x1(%rax),%edx
  803ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ea7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803eac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eb0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803eb4:	72 a2                	jb     803e58 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803eb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803eba:	c9                   	leaveq 
  803ebb:	c3                   	retq   

0000000000803ebc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ebc:	55                   	push   %rbp
  803ebd:	48 89 e5             	mov    %rsp,%rbp
  803ec0:	48 83 ec 40          	sub    $0x40,%rsp
  803ec4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ec8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ecc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ed0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ed4:	48 89 c7             	mov    %rax,%rdi
  803ed7:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  803ede:	00 00 00 
  803ee1:	ff d0                	callq  *%rax
  803ee3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ee7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eeb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803eef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ef6:	00 
  803ef7:	e9 93 00 00 00       	jmpq   803f8f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803efc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f04:	48 89 d6             	mov    %rdx,%rsi
  803f07:	48 89 c7             	mov    %rax,%rdi
  803f0a:	48 b8 a2 3c 80 00 00 	movabs $0x803ca2,%rax
  803f11:	00 00 00 
  803f14:	ff d0                	callq  *%rax
  803f16:	85 c0                	test   %eax,%eax
  803f18:	74 07                	je     803f21 <devpipe_write+0x65>
				return 0;
  803f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f1f:	eb 7c                	jmp    803f9d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803f21:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  803f28:	00 00 00 
  803f2b:	ff d0                	callq  *%rax
  803f2d:	eb 01                	jmp    803f30 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803f2f:	90                   	nop
  803f30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f34:	8b 40 04             	mov    0x4(%rax),%eax
  803f37:	48 63 d0             	movslq %eax,%rdx
  803f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f3e:	8b 00                	mov    (%rax),%eax
  803f40:	48 98                	cltq   
  803f42:	48 83 c0 20          	add    $0x20,%rax
  803f46:	48 39 c2             	cmp    %rax,%rdx
  803f49:	73 b1                	jae    803efc <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803f4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f4f:	8b 40 04             	mov    0x4(%rax),%eax
  803f52:	89 c2                	mov    %eax,%edx
  803f54:	c1 fa 1f             	sar    $0x1f,%edx
  803f57:	c1 ea 1b             	shr    $0x1b,%edx
  803f5a:	01 d0                	add    %edx,%eax
  803f5c:	83 e0 1f             	and    $0x1f,%eax
  803f5f:	29 d0                	sub    %edx,%eax
  803f61:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f65:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f69:	48 01 ca             	add    %rcx,%rdx
  803f6c:	0f b6 0a             	movzbl (%rdx),%ecx
  803f6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f73:	48 98                	cltq   
  803f75:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f7d:	8b 40 04             	mov    0x4(%rax),%eax
  803f80:	8d 50 01             	lea    0x1(%rax),%edx
  803f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f87:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f8a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f93:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f97:	72 96                	jb     803f2f <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f9d:	c9                   	leaveq 
  803f9e:	c3                   	retq   

0000000000803f9f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f9f:	55                   	push   %rbp
  803fa0:	48 89 e5             	mov    %rsp,%rbp
  803fa3:	48 83 ec 20          	sub    $0x20,%rsp
  803fa7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb3:	48 89 c7             	mov    %rax,%rdi
  803fb6:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  803fbd:	00 00 00 
  803fc0:	ff d0                	callq  *%rax
  803fc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803fc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fca:	48 be 9c 4e 80 00 00 	movabs $0x804e9c,%rsi
  803fd1:	00 00 00 
  803fd4:	48 89 c7             	mov    %rax,%rdi
  803fd7:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe7:	8b 50 04             	mov    0x4(%rax),%edx
  803fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fee:	8b 00                	mov    (%rax),%eax
  803ff0:	29 c2                	sub    %eax,%edx
  803ff2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ffc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804000:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804007:	00 00 00 
	stat->st_dev = &devpipe;
  80400a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80400e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  804015:	00 00 00 
  804018:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80401f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804024:	c9                   	leaveq 
  804025:	c3                   	retq   

0000000000804026 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804026:	55                   	push   %rbp
  804027:	48 89 e5             	mov    %rsp,%rbp
  80402a:	48 83 ec 10          	sub    $0x10,%rsp
  80402e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804036:	48 89 c6             	mov    %rax,%rsi
  804039:	bf 00 00 00 00       	mov    $0x0,%edi
  80403e:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  804045:	00 00 00 
  804048:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80404a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80404e:	48 89 c7             	mov    %rax,%rdi
  804051:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  804058:	00 00 00 
  80405b:	ff d0                	callq  *%rax
  80405d:	48 89 c6             	mov    %rax,%rsi
  804060:	bf 00 00 00 00       	mov    $0x0,%edi
  804065:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  80406c:	00 00 00 
  80406f:	ff d0                	callq  *%rax
}
  804071:	c9                   	leaveq 
  804072:	c3                   	retq   
	...

0000000000804074 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804074:	55                   	push   %rbp
  804075:	48 89 e5             	mov    %rsp,%rbp
  804078:	48 83 ec 20          	sub    $0x20,%rsp
  80407c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80407f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804082:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804085:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804089:	be 01 00 00 00       	mov    $0x1,%esi
  80408e:	48 89 c7             	mov    %rax,%rdi
  804091:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  804098:	00 00 00 
  80409b:	ff d0                	callq  *%rax
}
  80409d:	c9                   	leaveq 
  80409e:	c3                   	retq   

000000000080409f <getchar>:

int
getchar(void)
{
  80409f:	55                   	push   %rbp
  8040a0:	48 89 e5             	mov    %rsp,%rbp
  8040a3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8040a7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8040ab:	ba 01 00 00 00       	mov    $0x1,%edx
  8040b0:	48 89 c6             	mov    %rax,%rsi
  8040b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8040b8:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  8040bf:	00 00 00 
  8040c2:	ff d0                	callq  *%rax
  8040c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8040c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040cb:	79 05                	jns    8040d2 <getchar+0x33>
		return r;
  8040cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d0:	eb 14                	jmp    8040e6 <getchar+0x47>
	if (r < 1)
  8040d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040d6:	7f 07                	jg     8040df <getchar+0x40>
		return -E_EOF;
  8040d8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8040dd:	eb 07                	jmp    8040e6 <getchar+0x47>
	return c;
  8040df:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8040e3:	0f b6 c0             	movzbl %al,%eax
}
  8040e6:	c9                   	leaveq 
  8040e7:	c3                   	retq   

00000000008040e8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8040e8:	55                   	push   %rbp
  8040e9:	48 89 e5             	mov    %rsp,%rbp
  8040ec:	48 83 ec 20          	sub    $0x20,%rsp
  8040f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8040f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040fa:	48 89 d6             	mov    %rdx,%rsi
  8040fd:	89 c7                	mov    %eax,%edi
  8040ff:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  804106:	00 00 00 
  804109:	ff d0                	callq  *%rax
  80410b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80410e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804112:	79 05                	jns    804119 <iscons+0x31>
		return r;
  804114:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804117:	eb 1a                	jmp    804133 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804119:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80411d:	8b 10                	mov    (%rax),%edx
  80411f:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804126:	00 00 00 
  804129:	8b 00                	mov    (%rax),%eax
  80412b:	39 c2                	cmp    %eax,%edx
  80412d:	0f 94 c0             	sete   %al
  804130:	0f b6 c0             	movzbl %al,%eax
}
  804133:	c9                   	leaveq 
  804134:	c3                   	retq   

0000000000804135 <opencons>:

int
opencons(void)
{
  804135:	55                   	push   %rbp
  804136:	48 89 e5             	mov    %rsp,%rbp
  804139:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80413d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804141:	48 89 c7             	mov    %rax,%rdi
  804144:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  80414b:	00 00 00 
  80414e:	ff d0                	callq  *%rax
  804150:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804157:	79 05                	jns    80415e <opencons+0x29>
		return r;
  804159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415c:	eb 5b                	jmp    8041b9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80415e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804162:	ba 07 04 00 00       	mov    $0x407,%edx
  804167:	48 89 c6             	mov    %rax,%rsi
  80416a:	bf 00 00 00 00       	mov    $0x0,%edi
  80416f:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  804176:	00 00 00 
  804179:	ff d0                	callq  *%rax
  80417b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80417e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804182:	79 05                	jns    804189 <opencons+0x54>
		return r;
  804184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804187:	eb 30                	jmp    8041b9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80418d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804194:	00 00 00 
  804197:	8b 12                	mov    (%rdx),%edx
  804199:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80419b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80419f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8041a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041aa:	48 89 c7             	mov    %rax,%rdi
  8041ad:	48 b8 98 25 80 00 00 	movabs $0x802598,%rax
  8041b4:	00 00 00 
  8041b7:	ff d0                	callq  *%rax
}
  8041b9:	c9                   	leaveq 
  8041ba:	c3                   	retq   

00000000008041bb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041bb:	55                   	push   %rbp
  8041bc:	48 89 e5             	mov    %rsp,%rbp
  8041bf:	48 83 ec 30          	sub    $0x30,%rsp
  8041c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8041cf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041d4:	75 13                	jne    8041e9 <devcons_read+0x2e>
		return 0;
  8041d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8041db:	eb 49                	jmp    804226 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8041dd:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  8041e4:	00 00 00 
  8041e7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8041e9:	48 b8 8e 18 80 00 00 	movabs $0x80188e,%rax
  8041f0:	00 00 00 
  8041f3:	ff d0                	callq  *%rax
  8041f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041fc:	74 df                	je     8041dd <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8041fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804202:	79 05                	jns    804209 <devcons_read+0x4e>
		return c;
  804204:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804207:	eb 1d                	jmp    804226 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804209:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80420d:	75 07                	jne    804216 <devcons_read+0x5b>
		return 0;
  80420f:	b8 00 00 00 00       	mov    $0x0,%eax
  804214:	eb 10                	jmp    804226 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804219:	89 c2                	mov    %eax,%edx
  80421b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80421f:	88 10                	mov    %dl,(%rax)
	return 1;
  804221:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804226:	c9                   	leaveq 
  804227:	c3                   	retq   

0000000000804228 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804228:	55                   	push   %rbp
  804229:	48 89 e5             	mov    %rsp,%rbp
  80422c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804233:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80423a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804241:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80424f:	eb 77                	jmp    8042c8 <devcons_write+0xa0>
		m = n - tot;
  804251:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804258:	89 c2                	mov    %eax,%edx
  80425a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80425d:	89 d1                	mov    %edx,%ecx
  80425f:	29 c1                	sub    %eax,%ecx
  804261:	89 c8                	mov    %ecx,%eax
  804263:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804266:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804269:	83 f8 7f             	cmp    $0x7f,%eax
  80426c:	76 07                	jbe    804275 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80426e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804275:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804278:	48 63 d0             	movslq %eax,%rdx
  80427b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427e:	48 98                	cltq   
  804280:	48 89 c1             	mov    %rax,%rcx
  804283:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80428a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804291:	48 89 ce             	mov    %rcx,%rsi
  804294:	48 89 c7             	mov    %rax,%rdi
  804297:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  80429e:	00 00 00 
  8042a1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8042a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042a6:	48 63 d0             	movslq %eax,%rdx
  8042a9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042b0:	48 89 d6             	mov    %rdx,%rsi
  8042b3:	48 89 c7             	mov    %rax,%rdi
  8042b6:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  8042bd:	00 00 00 
  8042c0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042c5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8042c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042cb:	48 98                	cltq   
  8042cd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8042d4:	0f 82 77 ff ff ff    	jb     804251 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8042da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042dd:	c9                   	leaveq 
  8042de:	c3                   	retq   

00000000008042df <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8042df:	55                   	push   %rbp
  8042e0:	48 89 e5             	mov    %rsp,%rbp
  8042e3:	48 83 ec 08          	sub    $0x8,%rsp
  8042e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8042eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042f0:	c9                   	leaveq 
  8042f1:	c3                   	retq   

00000000008042f2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8042f2:	55                   	push   %rbp
  8042f3:	48 89 e5             	mov    %rsp,%rbp
  8042f6:	48 83 ec 10          	sub    $0x10,%rsp
  8042fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804306:	48 be a8 4e 80 00 00 	movabs $0x804ea8,%rsi
  80430d:	00 00 00 
  804310:	48 89 c7             	mov    %rax,%rdi
  804313:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  80431a:	00 00 00 
  80431d:	ff d0                	callq  *%rax
	return 0;
  80431f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804324:	c9                   	leaveq 
  804325:	c3                   	retq   
	...

0000000000804328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  804328:	55                   	push   %rbp
  804329:	48 89 e5             	mov    %rsp,%rbp
  80432c:	53                   	push   %rbx
  80432d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804334:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80433b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804341:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804348:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80434f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804356:	84 c0                	test   %al,%al
  804358:	74 23                	je     80437d <_panic+0x55>
  80435a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804361:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804365:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804369:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80436d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804371:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804375:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804379:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80437d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804384:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80438b:	00 00 00 
  80438e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804395:	00 00 00 
  804398:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80439c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8043a3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8043aa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8043b1:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8043b8:	00 00 00 
  8043bb:	48 8b 18             	mov    (%rax),%rbx
  8043be:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  8043c5:	00 00 00 
  8043c8:	ff d0                	callq  *%rax
  8043ca:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8043d0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8043d7:	41 89 c8             	mov    %ecx,%r8d
  8043da:	48 89 d1             	mov    %rdx,%rcx
  8043dd:	48 89 da             	mov    %rbx,%rdx
  8043e0:	89 c6                	mov    %eax,%esi
  8043e2:	48 bf b0 4e 80 00 00 	movabs $0x804eb0,%rdi
  8043e9:	00 00 00 
  8043ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f1:	49 b9 97 04 80 00 00 	movabs $0x800497,%r9
  8043f8:	00 00 00 
  8043fb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8043fe:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804405:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80440c:	48 89 d6             	mov    %rdx,%rsi
  80440f:	48 89 c7             	mov    %rax,%rdi
  804412:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  804419:	00 00 00 
  80441c:	ff d0                	callq  *%rax
	cprintf("\n");
  80441e:	48 bf d3 4e 80 00 00 	movabs $0x804ed3,%rdi
  804425:	00 00 00 
  804428:	b8 00 00 00 00       	mov    $0x0,%eax
  80442d:	48 ba 97 04 80 00 00 	movabs $0x800497,%rdx
  804434:	00 00 00 
  804437:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804439:	cc                   	int3   
  80443a:	eb fd                	jmp    804439 <_panic+0x111>

000000000080443c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80443c:	55                   	push   %rbp
  80443d:	48 89 e5             	mov    %rsp,%rbp
  804440:	48 83 ec 20          	sub    $0x20,%rsp
  804444:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  804448:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80444f:	00 00 00 
  804452:	48 8b 00             	mov    (%rax),%rax
  804455:	48 85 c0             	test   %rax,%rax
  804458:	0f 85 8e 00 00 00    	jne    8044ec <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  80445e:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804465:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  80446c:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  804473:	00 00 00 
  804476:	ff d0                	callq  *%rax
  804478:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  80447b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80447f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804482:	ba 07 00 00 00       	mov    $0x7,%edx
  804487:	48 89 ce             	mov    %rcx,%rsi
  80448a:	89 c7                	mov    %eax,%edi
  80448c:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  804493:	00 00 00 
  804496:	ff d0                	callq  *%rax
  804498:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  80449b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80449f:	74 30                	je     8044d1 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  8044a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8044a4:	89 c1                	mov    %eax,%ecx
  8044a6:	48 ba d8 4e 80 00 00 	movabs $0x804ed8,%rdx
  8044ad:	00 00 00 
  8044b0:	be 24 00 00 00       	mov    $0x24,%esi
  8044b5:	48 bf 0f 4f 80 00 00 	movabs $0x804f0f,%rdi
  8044bc:	00 00 00 
  8044bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8044c4:	49 b8 28 43 80 00 00 	movabs $0x804328,%r8
  8044cb:	00 00 00 
  8044ce:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8044d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044d4:	48 be 00 45 80 00 00 	movabs $0x804500,%rsi
  8044db:	00 00 00 
  8044de:	89 c7                	mov    %eax,%edi
  8044e0:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8044e7:	00 00 00 
  8044ea:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8044ec:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044f3:	00 00 00 
  8044f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044fa:	48 89 10             	mov    %rdx,(%rax)
}
  8044fd:	c9                   	leaveq 
  8044fe:	c3                   	retq   
	...

0000000000804500 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804500:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804503:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  80450a:	00 00 00 
	call *%rax
  80450d:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  80450f:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  804513:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  804517:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  80451a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804521:	00 
		movq 120(%rsp), %rcx				// trap time rip
  804522:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  804527:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  80452a:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  80452b:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  80452e:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  804535:	00 08 
		POPA_						// copy the register contents to the registers
  804537:	4c 8b 3c 24          	mov    (%rsp),%r15
  80453b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804540:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804545:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80454a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80454f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804554:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804559:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80455e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804563:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804568:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80456d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804572:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804577:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80457c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804581:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804585:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  804589:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  80458a:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  80458b:	c3                   	retq   

000000000080458c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80458c:	55                   	push   %rbp
  80458d:	48 89 e5             	mov    %rsp,%rbp
  804590:	48 83 ec 18          	sub    $0x18,%rsp
  804594:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80459c:	48 89 c2             	mov    %rax,%rdx
  80459f:	48 c1 ea 15          	shr    $0x15,%rdx
  8045a3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8045aa:	01 00 00 
  8045ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045b1:	83 e0 01             	and    $0x1,%eax
  8045b4:	48 85 c0             	test   %rax,%rax
  8045b7:	75 07                	jne    8045c0 <pageref+0x34>
		return 0;
  8045b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8045be:	eb 53                	jmp    804613 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8045c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045c4:	48 89 c2             	mov    %rax,%rdx
  8045c7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8045cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8045d2:	01 00 00 
  8045d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8045dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045e1:	83 e0 01             	and    $0x1,%eax
  8045e4:	48 85 c0             	test   %rax,%rax
  8045e7:	75 07                	jne    8045f0 <pageref+0x64>
		return 0;
  8045e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ee:	eb 23                	jmp    804613 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8045f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045f4:	48 89 c2             	mov    %rax,%rdx
  8045f7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8045fb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804602:	00 00 00 
  804605:	48 c1 e2 04          	shl    $0x4,%rdx
  804609:	48 01 d0             	add    %rdx,%rax
  80460c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804610:	0f b7 c0             	movzwl %ax,%eax
}
  804613:	c9                   	leaveq 
  804614:	c3                   	retq   
