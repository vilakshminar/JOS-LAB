
obj/user/testfile.debug:     file format elf64-x86-64


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
  80003c:	e8 bb 0b 00 00       	callq  800bfc <libmain>
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
  80005a:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  800061:	00 00 00 
  800064:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80006b:	00 00 00 
  80006e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800070:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800077:	00 00 00 
  80007a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
  800088:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  80008f:	00 00 00 
  800092:	ff d0                	callq  *%rax
  800094:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80009a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009f:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8000a6:	00 00 00 
  8000a9:	be 01 00 00 00       	mov    $0x1,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 f4 27 80 00 00 	movabs $0x8027f4,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000cb:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
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
  8000de:	48 81 ec d8 02 00 00 	sub    $0x2d8,%rsp
  8000e5:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000eb:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f2:	be 00 00 00 00       	mov    $0x0,%esi
  8000f7:	48 bf 86 47 80 00 00 	movabs $0x804786,%rdi
  8000fe:	00 00 00 
  800101:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax
  80010d:	48 98                	cltq   
  80010f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800113:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800118:	79 39                	jns    800153 <umain+0x7a>
  80011a:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011f:	74 32                	je     800153 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800121:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800125:	48 89 c1             	mov    %rax,%rcx
  800128:	48 ba 91 47 80 00 00 	movabs $0x804791,%rdx
  80012f:	00 00 00 
  800132:	be 20 00 00 00       	mov    $0x20,%esi
  800137:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  80013e:	00 00 00 
  800141:	b8 00 00 00 00       	mov    $0x0,%eax
  800146:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  80014d:	00 00 00 
  800150:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800153:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800158:	78 2a                	js     800184 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  80015a:	48 ba c0 47 80 00 00 	movabs $0x8047c0,%rdx
  800161:	00 00 00 
  800164:	be 22 00 00 00       	mov    $0x22,%esi
  800169:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800170:	00 00 00 
  800173:	b8 00 00 00 00       	mov    $0x0,%eax
  800178:	48 b9 c4 0c 80 00 00 	movabs $0x800cc4,%rcx
  80017f:	00 00 00 
  800182:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800184:	be 00 00 00 00       	mov    $0x0,%esi
  800189:	48 bf e1 47 80 00 00 	movabs $0x8047e1,%rdi
  800190:	00 00 00 
  800193:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
  80019f:	48 98                	cltq   
  8001a1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001aa:	79 32                	jns    8001de <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001b0:	48 89 c1             	mov    %rax,%rcx
  8001b3:	48 ba ea 47 80 00 00 	movabs $0x8047ea,%rdx
  8001ba:	00 00 00 
  8001bd:	be 25 00 00 00       	mov    $0x25,%esi
  8001c2:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  8001c9:	00 00 00 
  8001cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d1:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  8001d8:	00 00 00 
  8001db:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001de:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e3:	8b 00                	mov    (%rax),%eax
  8001e5:	83 f8 66             	cmp    $0x66,%eax
  8001e8:	75 18                	jne    800202 <umain+0x129>
  8001ea:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ef:	8b 40 04             	mov    0x4(%rax),%eax
  8001f2:	85 c0                	test   %eax,%eax
  8001f4:	75 0c                	jne    800202 <umain+0x129>
  8001f6:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fb:	8b 40 08             	mov    0x8(%rax),%eax
  8001fe:	85 c0                	test   %eax,%eax
  800200:	74 2a                	je     80022c <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800202:	48 ba 08 48 80 00 00 	movabs $0x804808,%rdx
  800209:	00 00 00 
  80020c:	be 27 00 00 00       	mov    $0x27,%esi
  800211:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800218:	00 00 00 
  80021b:	b8 00 00 00 00       	mov    $0x0,%eax
  800220:	48 b9 c4 0c 80 00 00 	movabs $0x800cc4,%rcx
  800227:	00 00 00 
  80022a:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022c:	48 bf 35 48 80 00 00 	movabs $0x804835,%rdi
  800233:	00 00 00 
  800236:	b8 00 00 00 00       	mov    $0x0,%eax
  80023b:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  800242:	00 00 00 
  800245:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800247:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80024e:	00 00 00 
  800251:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800255:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80025c:	48 89 c6             	mov    %rax,%rsi
  80025f:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800264:	ff d2                	callq  *%rdx
  800266:	48 98                	cltq   
  800268:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800271:	79 32                	jns    8002a5 <umain+0x1cc>
		panic("file_stat: %e", r);
  800273:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800277:	48 89 c1             	mov    %rax,%rcx
  80027a:	48 ba 49 48 80 00 00 	movabs $0x804849,%rdx
  800281:	00 00 00 
  800284:	be 2b 00 00 00       	mov    $0x2b,%esi
  800289:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  80029f:	00 00 00 
  8002a2:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002ac:	00 00 00 
  8002af:	48 8b 00             	mov    (%rax),%rax
  8002b2:	48 89 c7             	mov    %rax,%rdi
  8002b5:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  8002bc:	00 00 00 
  8002bf:	ff d0                	callq  *%rax
  8002c1:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c4:	39 d0                	cmp    %edx,%eax
  8002c6:	74 51                	je     800319 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002cf:	00 00 00 
  8002d2:	48 8b 00             	mov    (%rax),%rax
  8002d5:	48 89 c7             	mov    %rax,%rdi
  8002d8:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  8002df:	00 00 00 
  8002e2:	ff d0                	callq  *%rax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e9:	41 89 d0             	mov    %edx,%r8d
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	48 ba 58 48 80 00 00 	movabs $0x804858,%rdx
  8002f5:	00 00 00 
  8002f8:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fd:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800304:	00 00 00 
  800307:	b8 00 00 00 00       	mov    $0x0,%eax
  80030c:	49 b9 c4 0c 80 00 00 	movabs $0x800cc4,%r9
  800313:	00 00 00 
  800316:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800319:	48 bf 7e 48 80 00 00 	movabs $0x80487e,%rdi
  800320:	00 00 00 
  800323:	b8 00 00 00 00       	mov    $0x0,%eax
  800328:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  80032f:	00 00 00 
  800332:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800334:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033b:	ba 00 02 00 00       	mov    $0x200,%edx
  800340:	be 00 00 00 00       	mov    $0x0,%esi
  800345:	48 89 c7             	mov    %rax,%rdi
  800348:	48 b8 53 1d 80 00 00 	movabs $0x801d53,%rax
  80034f:	00 00 00 
  800352:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800354:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80035b:	00 00 00 
  80035e:	48 8b 48 10          	mov    0x10(%rax),%rcx
  800362:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800369:	ba 00 02 00 00       	mov    $0x200,%edx
  80036e:	48 89 c6             	mov    %rax,%rsi
  800371:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800376:	ff d1                	callq  *%rcx
  800378:	48 98                	cltq   
  80037a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800383:	79 32                	jns    8003b7 <umain+0x2de>
		panic("file_read: %e", r);
  800385:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800389:	48 89 c1             	mov    %rax,%rcx
  80038c:	48 ba 91 48 80 00 00 	movabs $0x804891,%rdx
  800393:	00 00 00 
  800396:	be 32 00 00 00       	mov    $0x32,%esi
  80039b:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  8003a2:	00 00 00 
  8003a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003aa:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  8003b1:	00 00 00 
  8003b4:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003be:	00 00 00 
  8003c1:	48 8b 10             	mov    (%rax),%rdx
  8003c4:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003cb:	48 89 d6             	mov    %rdx,%rsi
  8003ce:	48 89 c7             	mov    %rax,%rdi
  8003d1:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  8003d8:	00 00 00 
  8003db:	ff d0                	callq  *%rax
  8003dd:	85 c0                	test   %eax,%eax
  8003df:	74 2a                	je     80040b <umain+0x332>
		panic("file_read returned wrong data");
  8003e1:	48 ba 9f 48 80 00 00 	movabs $0x80489f,%rdx
  8003e8:	00 00 00 
  8003eb:	be 34 00 00 00       	mov    $0x34,%esi
  8003f0:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  8003f7:	00 00 00 
  8003fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ff:	48 b9 c4 0c 80 00 00 	movabs $0x800cc4,%rcx
  800406:	00 00 00 
  800409:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040b:	48 bf bd 48 80 00 00 	movabs $0x8048bd,%rdi
  800412:	00 00 00 
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
  80041a:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  800421:	00 00 00 
  800424:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800426:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80042d:	00 00 00 
  800430:	48 8b 40 20          	mov    0x20(%rax),%rax
  800434:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800439:	ff d0                	callq  *%rax
  80043b:	48 98                	cltq   
  80043d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800441:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800446:	79 32                	jns    80047a <umain+0x3a1>
		panic("file_close: %e", r);
  800448:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044c:	48 89 c1             	mov    %rax,%rcx
  80044f:	48 ba d0 48 80 00 00 	movabs $0x8048d0,%rdx
  800456:	00 00 00 
  800459:	be 38 00 00 00       	mov    $0x38,%esi
  80045e:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800465:	00 00 00 
  800468:	b8 00 00 00 00       	mov    $0x0,%eax
  80046d:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  800474:	00 00 00 
  800477:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  80047a:	48 bf df 48 80 00 00 	movabs $0x8048df,%rdi
  800481:	00 00 00 
  800484:	b8 00 00 00 00       	mov    $0x0,%eax
  800489:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  800490:	00 00 00 
  800493:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800495:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  80049a:	48 8b 10             	mov    (%rax),%rdx
  80049d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8004a1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004a5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004a9:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b3:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004bf:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8004c6:	00 00 00 
  8004c9:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8004cd:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  8004d4:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8004d8:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dd:	48 89 ce             	mov    %rcx,%rsi
  8004e0:	48 89 c7             	mov    %rax,%rdi
  8004e3:	41 ff d0             	callq  *%r8
  8004e6:	48 98                	cltq   
  8004e8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004ec:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004f1:	74 32                	je     800525 <umain+0x44c>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f7:	48 89 c1             	mov    %rax,%rcx
  8004fa:	48 ba f8 48 80 00 00 	movabs $0x8048f8,%rdx
  800501:	00 00 00 
  800504:	be 43 00 00 00       	mov    $0x43,%esi
  800509:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800510:	00 00 00 
  800513:	b8 00 00 00 00       	mov    $0x0,%eax
  800518:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  80051f:	00 00 00 
  800522:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800525:	48 bf 2f 49 80 00 00 	movabs $0x80492f,%rdi
  80052c:	00 00 00 
  80052f:	b8 00 00 00 00       	mov    $0x0,%eax
  800534:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  80053b:	00 00 00 
  80053e:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800540:	be 02 01 00 00       	mov    $0x102,%esi
  800545:	48 bf 45 49 80 00 00 	movabs $0x804945,%rdi
  80054c:	00 00 00 
  80054f:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800556:	00 00 00 
  800559:	ff d0                	callq  *%rax
  80055b:	48 98                	cltq   
  80055d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800561:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800566:	79 32                	jns    80059a <umain+0x4c1>
		panic("serve_open /new-file: %e", r);
  800568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80056c:	48 89 c1             	mov    %rax,%rcx
  80056f:	48 ba 4f 49 80 00 00 	movabs $0x80494f,%rdx
  800576:	00 00 00 
  800579:	be 48 00 00 00       	mov    $0x48,%esi
  80057e:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800585:	00 00 00 
  800588:	b8 00 00 00 00       	mov    $0x0,%eax
  80058d:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  800594:	00 00 00 
  800597:	41 ff d0             	callq  *%r8

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  80059a:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8005a1:	00 00 00 
  8005a4:	48 8b 58 18          	mov    0x18(%rax),%rbx
  8005a8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8005af:	00 00 00 
  8005b2:	48 8b 00             	mov    (%rax),%rax
  8005b5:	48 89 c7             	mov    %rax,%rdi
  8005b8:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  8005bf:	00 00 00 
  8005c2:	ff d0                	callq  *%rax
  8005c4:	48 63 d0             	movslq %eax,%rdx
  8005c7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8005ce:	00 00 00 
  8005d1:	48 8b 00             	mov    (%rax),%rax
  8005d4:	48 89 c6             	mov    %rax,%rsi
  8005d7:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  8005dc:	ff d3                	callq  *%rbx
  8005de:	48 98                	cltq   
  8005e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8005e4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8005eb:	00 00 00 
  8005ee:	48 8b 00             	mov    (%rax),%rax
  8005f1:	48 89 c7             	mov    %rax,%rdi
  8005f4:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  8005fb:	00 00 00 
  8005fe:	ff d0                	callq  *%rax
  800600:	48 98                	cltq   
  800602:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800606:	74 32                	je     80063a <umain+0x561>
		panic("file_write: %e", r);
  800608:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80060c:	48 89 c1             	mov    %rax,%rcx
  80060f:	48 ba 68 49 80 00 00 	movabs $0x804968,%rdx
  800616:	00 00 00 
  800619:	be 4b 00 00 00       	mov    $0x4b,%esi
  80061e:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800625:	00 00 00 
  800628:	b8 00 00 00 00       	mov    $0x0,%eax
  80062d:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  800634:	00 00 00 
  800637:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  80063a:	48 bf 77 49 80 00 00 	movabs $0x804977,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  800655:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  80065a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  800661:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800668:	ba 00 02 00 00       	mov    $0x200,%edx
  80066d:	be 00 00 00 00       	mov    $0x0,%esi
  800672:	48 89 c7             	mov    %rax,%rdi
  800675:	48 b8 53 1d 80 00 00 	movabs $0x801d53,%rax
  80067c:	00 00 00 
  80067f:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800681:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  800688:	00 00 00 
  80068b:	48 8b 48 10          	mov    0x10(%rax),%rcx
  80068f:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800696:	ba 00 02 00 00       	mov    $0x200,%edx
  80069b:	48 89 c6             	mov    %rax,%rsi
  80069e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  8006a3:	ff d1                	callq  *%rcx
  8006a5:	48 98                	cltq   
  8006a7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8006ab:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8006b0:	79 32                	jns    8006e4 <umain+0x60b>
		panic("file_read after file_write: %e", r);
  8006b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006b6:	48 89 c1             	mov    %rax,%rcx
  8006b9:	48 ba 90 49 80 00 00 	movabs $0x804990,%rdx
  8006c0:	00 00 00 
  8006c3:	be 51 00 00 00       	mov    $0x51,%esi
  8006c8:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  8006cf:	00 00 00 
  8006d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d7:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  8006de:	00 00 00 
  8006e1:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  8006e4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8006eb:	00 00 00 
  8006ee:	48 8b 00             	mov    (%rax),%rax
  8006f1:	48 89 c7             	mov    %rax,%rdi
  8006f4:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  8006fb:	00 00 00 
  8006fe:	ff d0                	callq  *%rax
  800700:	48 98                	cltq   
  800702:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800706:	74 32                	je     80073a <umain+0x661>
		panic("file_read after file_write returned wrong length: %d", r);
  800708:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80070c:	48 89 c1             	mov    %rax,%rcx
  80070f:	48 ba b0 49 80 00 00 	movabs $0x8049b0,%rdx
  800716:	00 00 00 
  800719:	be 53 00 00 00       	mov    $0x53,%esi
  80071e:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800725:	00 00 00 
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
  80072d:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  800734:	00 00 00 
  800737:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  80073a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800741:	00 00 00 
  800744:	48 8b 10             	mov    (%rax),%rdx
  800747:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80074e:	48 89 d6             	mov    %rdx,%rsi
  800751:	48 89 c7             	mov    %rax,%rdi
  800754:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  80075b:	00 00 00 
  80075e:	ff d0                	callq  *%rax
  800760:	85 c0                	test   %eax,%eax
  800762:	74 2a                	je     80078e <umain+0x6b5>
		panic("file_read after file_write returned wrong data");
  800764:	48 ba e8 49 80 00 00 	movabs $0x8049e8,%rdx
  80076b:	00 00 00 
  80076e:	be 55 00 00 00       	mov    $0x55,%esi
  800773:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  80077a:	00 00 00 
  80077d:	b8 00 00 00 00       	mov    $0x0,%eax
  800782:	48 b9 c4 0c 80 00 00 	movabs $0x800cc4,%rcx
  800789:	00 00 00 
  80078c:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80078e:	48 bf 18 4a 80 00 00 	movabs $0x804a18,%rdi
  800795:	00 00 00 
  800798:	b8 00 00 00 00       	mov    $0x0,%eax
  80079d:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  8007a4:	00 00 00 
  8007a7:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8007a9:	be 00 00 00 00       	mov    $0x0,%esi
  8007ae:	48 bf 86 47 80 00 00 	movabs $0x804786,%rdi
  8007b5:	00 00 00 
  8007b8:	48 b8 33 33 80 00 00 	movabs $0x803333,%rax
  8007bf:	00 00 00 
  8007c2:	ff d0                	callq  *%rax
  8007c4:	48 98                	cltq   
  8007c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8007ca:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8007cf:	79 39                	jns    80080a <umain+0x731>
  8007d1:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  8007d6:	74 32                	je     80080a <umain+0x731>
		panic("open /not-found: %e", r);
  8007d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007dc:	48 89 c1             	mov    %rax,%rcx
  8007df:	48 ba 3c 4a 80 00 00 	movabs $0x804a3c,%rdx
  8007e6:	00 00 00 
  8007e9:	be 5a 00 00 00       	mov    $0x5a,%esi
  8007ee:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  8007f5:	00 00 00 
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  800804:	00 00 00 
  800807:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  80080a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80080f:	78 2a                	js     80083b <umain+0x762>
		panic("open /not-found succeeded!");
  800811:	48 ba 50 4a 80 00 00 	movabs $0x804a50,%rdx
  800818:	00 00 00 
  80081b:	be 5c 00 00 00       	mov    $0x5c,%esi
  800820:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800827:	00 00 00 
  80082a:	b8 00 00 00 00       	mov    $0x0,%eax
  80082f:	48 b9 c4 0c 80 00 00 	movabs $0x800cc4,%rcx
  800836:	00 00 00 
  800839:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80083b:	be 00 00 00 00       	mov    $0x0,%esi
  800840:	48 bf e1 47 80 00 00 	movabs $0x8047e1,%rdi
  800847:	00 00 00 
  80084a:	48 b8 33 33 80 00 00 	movabs $0x803333,%rax
  800851:	00 00 00 
  800854:	ff d0                	callq  *%rax
  800856:	48 98                	cltq   
  800858:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80085c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800861:	79 32                	jns    800895 <umain+0x7bc>
		panic("open /newmotd: %e", r);
  800863:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800867:	48 89 c1             	mov    %rax,%rcx
  80086a:	48 ba 6b 4a 80 00 00 	movabs $0x804a6b,%rdx
  800871:	00 00 00 
  800874:	be 5f 00 00 00       	mov    $0x5f,%esi
  800879:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800880:	00 00 00 
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
  800888:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  80088f:	00 00 00 
  800892:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800895:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800899:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80089f:	48 c1 e0 0c          	shl    $0xc,%rax
  8008a3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  8008a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ab:	8b 00                	mov    (%rax),%eax
  8008ad:	83 f8 66             	cmp    $0x66,%eax
  8008b0:	75 16                	jne    8008c8 <umain+0x7ef>
  8008b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b6:	8b 40 04             	mov    0x4(%rax),%eax
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	75 0b                	jne    8008c8 <umain+0x7ef>
  8008bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c1:	8b 40 08             	mov    0x8(%rax),%eax
  8008c4:	85 c0                	test   %eax,%eax
  8008c6:	74 2a                	je     8008f2 <umain+0x819>
		panic("open did not fill struct Fd correctly\n");
  8008c8:	48 ba 80 4a 80 00 00 	movabs $0x804a80,%rdx
  8008cf:	00 00 00 
  8008d2:	be 62 00 00 00       	mov    $0x62,%esi
  8008d7:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  8008de:	00 00 00 
  8008e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e6:	48 b9 c4 0c 80 00 00 	movabs $0x800cc4,%rcx
  8008ed:	00 00 00 
  8008f0:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  8008f2:	48 bf a7 4a 80 00 00 	movabs $0x804aa7,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  800908:	00 00 00 
  80090b:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80090d:	be 01 01 00 00       	mov    $0x101,%esi
  800912:	48 bf b5 4a 80 00 00 	movabs $0x804ab5,%rdi
  800919:	00 00 00 
  80091c:	48 b8 33 33 80 00 00 	movabs $0x803333,%rax
  800923:	00 00 00 
  800926:	ff d0                	callq  *%rax
  800928:	48 98                	cltq   
  80092a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80092e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800933:	79 32                	jns    800967 <umain+0x88e>
		panic("creat /big: %e", f);
  800935:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800939:	48 89 c1             	mov    %rax,%rcx
  80093c:	48 ba ba 4a 80 00 00 	movabs $0x804aba,%rdx
  800943:	00 00 00 
  800946:	be 67 00 00 00       	mov    $0x67,%esi
  80094b:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800952:	00 00 00 
  800955:	b8 00 00 00 00       	mov    $0x0,%eax
  80095a:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  800961:	00 00 00 
  800964:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  800967:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80096e:	ba 00 02 00 00       	mov    $0x200,%edx
  800973:	be 00 00 00 00       	mov    $0x0,%esi
  800978:	48 89 c7             	mov    %rax,%rdi
  80097b:	48 b8 53 1d 80 00 00 	movabs $0x801d53,%rax
  800982:	00 00 00 
  800985:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800987:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80098e:	00 
  80098f:	e9 82 00 00 00       	jmpq   800a16 <umain+0x93d>
		//cprintf("i/sizeofbuf:%d\n", i/sizeof(buf));
		*(int*)buf = i;
  800994:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80099b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099f:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8009a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009a5:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  8009ac:	ba 00 02 00 00       	mov    $0x200,%edx
  8009b1:	48 89 ce             	mov    %rcx,%rsi
  8009b4:	89 c7                	mov    %eax,%edi
  8009b6:	48 b8 a2 2f 80 00 00 	movabs $0x802fa2,%rax
  8009bd:	00 00 00 
  8009c0:	ff d0                	callq  *%rax
  8009c2:	48 98                	cltq   
  8009c4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8009c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8009cd:	79 39                	jns    800a08 <umain+0x92f>
			panic("write /big@%d: %e", i, r);
  8009cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	49 89 d0             	mov    %rdx,%r8
  8009da:	48 89 c1             	mov    %rax,%rcx
  8009dd:	48 ba c9 4a 80 00 00 	movabs $0x804ac9,%rdx
  8009e4:	00 00 00 
  8009e7:	be 6d 00 00 00       	mov    $0x6d,%esi
  8009ec:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  8009f3:	00 00 00 
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	49 b9 c4 0c 80 00 00 	movabs $0x800cc4,%r9
  800a02:	00 00 00 
  800a05:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0c:	48 05 00 02 00 00    	add    $0x200,%rax
  800a12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a16:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a1d:	00 
  800a1e:	0f 8e 70 ff ff ff    	jle    800994 <umain+0x8bb>
		//cprintf("i/sizeofbuf:%d\n", i/sizeof(buf));
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800a24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a28:	89 c7                	mov    %eax,%edi
  800a2a:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  800a31:	00 00 00 
  800a34:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800a36:	be 00 00 00 00       	mov    $0x0,%esi
  800a3b:	48 bf b5 4a 80 00 00 	movabs $0x804ab5,%rdi
  800a42:	00 00 00 
  800a45:	48 b8 33 33 80 00 00 	movabs $0x803333,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
  800a51:	48 98                	cltq   
  800a53:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800a57:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800a5c:	79 32                	jns    800a90 <umain+0x9b7>
		panic("open /big: %e", f);
  800a5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a62:	48 89 c1             	mov    %rax,%rcx
  800a65:	48 ba db 4a 80 00 00 	movabs $0x804adb,%rdx
  800a6c:	00 00 00 
  800a6f:	be 72 00 00 00       	mov    $0x72,%esi
  800a74:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800a7b:	00 00 00 
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a83:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  800a8a:	00 00 00 
  800a8d:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a90:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800a97:	00 
  800a98:	e9 1a 01 00 00       	jmpq   800bb7 <umain+0xade>
		*(int*)buf = i;
  800a9d:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800aa4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa8:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800aaa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aae:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800ab5:	ba 00 02 00 00       	mov    $0x200,%edx
  800aba:	48 89 ce             	mov    %rcx,%rsi
  800abd:	89 c7                	mov    %eax,%edi
  800abf:	48 b8 2d 2f 80 00 00 	movabs $0x802f2d,%rax
  800ac6:	00 00 00 
  800ac9:	ff d0                	callq  *%rax
  800acb:	48 98                	cltq   
  800acd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800ad1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ad6:	79 39                	jns    800b11 <umain+0xa38>
			panic("read /big@%d: %e", i, r);
  800ad8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae0:	49 89 d0             	mov    %rdx,%r8
  800ae3:	48 89 c1             	mov    %rax,%rcx
  800ae6:	48 ba e9 4a 80 00 00 	movabs $0x804ae9,%rdx
  800aed:	00 00 00 
  800af0:	be 76 00 00 00       	mov    $0x76,%esi
  800af5:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800afc:	00 00 00 
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
  800b04:	49 b9 c4 0c 80 00 00 	movabs $0x800cc4,%r9
  800b0b:	00 00 00 
  800b0e:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b11:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b18:	00 
  800b19:	74 3f                	je     800b5a <umain+0xa81>
			panic("read /big from %d returned %d < %d bytes",
  800b1b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b23:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800b29:	49 89 d0             	mov    %rdx,%r8
  800b2c:	48 89 c1             	mov    %rax,%rcx
  800b2f:	48 ba 00 4b 80 00 00 	movabs $0x804b00,%rdx
  800b36:	00 00 00 
  800b39:	be 79 00 00 00       	mov    $0x79,%esi
  800b3e:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800b45:	00 00 00 
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4d:	49 ba c4 0c 80 00 00 	movabs $0x800cc4,%r10
  800b54:	00 00 00 
  800b57:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800b5a:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b61:	8b 00                	mov    (%rax),%eax
  800b63:	48 98                	cltq   
  800b65:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800b69:	74 3e                	je     800ba9 <umain+0xad0>
			panic("read /big from %d returned bad data %d",
  800b6b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b72:	8b 10                	mov    (%rax),%edx
  800b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b78:	41 89 d0             	mov    %edx,%r8d
  800b7b:	48 89 c1             	mov    %rax,%rcx
  800b7e:	48 ba 30 4b 80 00 00 	movabs $0x804b30,%rdx
  800b85:	00 00 00 
  800b88:	be 7c 00 00 00       	mov    $0x7c,%esi
  800b8d:	48 bf ab 47 80 00 00 	movabs $0x8047ab,%rdi
  800b94:	00 00 00 
  800b97:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9c:	49 b9 c4 0c 80 00 00 	movabs $0x800cc4,%r9
  800ba3:	00 00 00 
  800ba6:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bad:	48 05 00 02 00 00    	add    $0x200,%rax
  800bb3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800bb7:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800bbe:	00 
  800bbf:	0f 8e d8 fe ff ff    	jle    800a9d <umain+0x9c4>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800bc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  800bd2:	00 00 00 
  800bd5:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800bd7:	48 bf 57 4b 80 00 00 	movabs $0x804b57,%rdi
  800bde:	00 00 00 
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  800bed:	00 00 00 
  800bf0:	ff d2                	callq  *%rdx
}
  800bf2:	48 81 c4 d8 02 00 00 	add    $0x2d8,%rsp
  800bf9:	5b                   	pop    %rbx
  800bfa:	5d                   	pop    %rbp
  800bfb:	c3                   	retq   

0000000000800bfc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800bfc:	55                   	push   %rbp
  800bfd:	48 89 e5             	mov    %rsp,%rbp
  800c00:	48 83 ec 10          	sub    $0x10,%rsp
  800c04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800c0b:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  800c12:	00 00 00 
  800c15:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800c1c:	48 b8 78 23 80 00 00 	movabs $0x802378,%rax
  800c23:	00 00 00 
  800c26:	ff d0                	callq  *%rax
  800c28:	48 98                	cltq   
  800c2a:	48 89 c2             	mov    %rax,%rdx
  800c2d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800c33:	48 89 d0             	mov    %rdx,%rax
  800c36:	48 c1 e0 03          	shl    $0x3,%rax
  800c3a:	48 01 d0             	add    %rdx,%rax
  800c3d:	48 c1 e0 05          	shl    $0x5,%rax
  800c41:	48 89 c2             	mov    %rax,%rdx
  800c44:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800c4b:	00 00 00 
  800c4e:	48 01 c2             	add    %rax,%rdx
  800c51:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  800c58:	00 00 00 
  800c5b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c62:	7e 14                	jle    800c78 <libmain+0x7c>
		binaryname = argv[0];
  800c64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c68:	48 8b 10             	mov    (%rax),%rdx
  800c6b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800c72:	00 00 00 
  800c75:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800c78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c7f:	48 89 d6             	mov    %rdx,%rsi
  800c82:	89 c7                	mov    %eax,%edi
  800c84:	48 b8 d9 00 80 00 00 	movabs $0x8000d9,%rax
  800c8b:	00 00 00 
  800c8e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800c90:	48 b8 a0 0c 80 00 00 	movabs $0x800ca0,%rax
  800c97:	00 00 00 
  800c9a:	ff d0                	callq  *%rax
}
  800c9c:	c9                   	leaveq 
  800c9d:	c3                   	retq   
	...

0000000000800ca0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ca0:	55                   	push   %rbp
  800ca1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800ca4:	48 b8 7d 2c 80 00 00 	movabs $0x802c7d,%rax
  800cab:	00 00 00 
  800cae:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800cb0:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb5:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  800cbc:	00 00 00 
  800cbf:	ff d0                	callq  *%rax
}
  800cc1:	5d                   	pop    %rbp
  800cc2:	c3                   	retq   
	...

0000000000800cc4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800cc4:	55                   	push   %rbp
  800cc5:	48 89 e5             	mov    %rsp,%rbp
  800cc8:	53                   	push   %rbx
  800cc9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800cd0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800cd7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800cdd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800ce4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800ceb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 23                	je     800d19 <_panic+0x55>
  800cf6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800cfd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d01:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d05:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d09:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d0d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d11:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d15:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d19:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d20:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d27:	00 00 00 
  800d2a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d31:	00 00 00 
  800d34:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d38:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800d3f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800d46:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d4d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d54:	00 00 00 
  800d57:	48 8b 18             	mov    (%rax),%rbx
  800d5a:	48 b8 78 23 80 00 00 	movabs $0x802378,%rax
  800d61:	00 00 00 
  800d64:	ff d0                	callq  *%rax
  800d66:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800d6c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d73:	41 89 c8             	mov    %ecx,%r8d
  800d76:	48 89 d1             	mov    %rdx,%rcx
  800d79:	48 89 da             	mov    %rbx,%rdx
  800d7c:	89 c6                	mov    %eax,%esi
  800d7e:	48 bf 78 4b 80 00 00 	movabs $0x804b78,%rdi
  800d85:	00 00 00 
  800d88:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8d:	49 b9 ff 0e 80 00 00 	movabs $0x800eff,%r9
  800d94:	00 00 00 
  800d97:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d9a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800da1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800da8:	48 89 d6             	mov    %rdx,%rsi
  800dab:	48 89 c7             	mov    %rax,%rdi
  800dae:	48 b8 53 0e 80 00 00 	movabs $0x800e53,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	callq  *%rax
	cprintf("\n");
  800dba:	48 bf 9b 4b 80 00 00 	movabs $0x804b9b,%rdi
  800dc1:	00 00 00 
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc9:	48 ba ff 0e 80 00 00 	movabs $0x800eff,%rdx
  800dd0:	00 00 00 
  800dd3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800dd5:	cc                   	int3   
  800dd6:	eb fd                	jmp    800dd5 <_panic+0x111>

0000000000800dd8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800dd8:	55                   	push   %rbp
  800dd9:	48 89 e5             	mov    %rsp,%rbp
  800ddc:	48 83 ec 10          	sub    $0x10,%rsp
  800de0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800de3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800deb:	8b 00                	mov    (%rax),%eax
  800ded:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800df0:	89 d6                	mov    %edx,%esi
  800df2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800df6:	48 63 d0             	movslq %eax,%rdx
  800df9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800dfe:	8d 50 01             	lea    0x1(%rax),%edx
  800e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e05:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0b:	8b 00                	mov    (%rax),%eax
  800e0d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e12:	75 2c                	jne    800e40 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e18:	8b 00                	mov    (%rax),%eax
  800e1a:	48 98                	cltq   
  800e1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e20:	48 83 c2 08          	add    $0x8,%rdx
  800e24:	48 89 c6             	mov    %rax,%rsi
  800e27:	48 89 d7             	mov    %rdx,%rdi
  800e2a:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	callq  *%rax
		b->idx = 0;
  800e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e44:	8b 40 04             	mov    0x4(%rax),%eax
  800e47:	8d 50 01             	lea    0x1(%rax),%edx
  800e4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800e51:	c9                   	leaveq 
  800e52:	c3                   	retq   

0000000000800e53 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800e53:	55                   	push   %rbp
  800e54:	48 89 e5             	mov    %rsp,%rbp
  800e57:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800e5e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800e65:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800e6c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800e73:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800e7a:	48 8b 0a             	mov    (%rdx),%rcx
  800e7d:	48 89 08             	mov    %rcx,(%rax)
  800e80:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e84:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e88:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e8c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800e90:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800e97:	00 00 00 
	b.cnt = 0;
  800e9a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ea1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800ea4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800eab:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800eb2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800eb9:	48 89 c6             	mov    %rax,%rsi
  800ebc:	48 bf d8 0d 80 00 00 	movabs $0x800dd8,%rdi
  800ec3:	00 00 00 
  800ec6:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  800ecd:	00 00 00 
  800ed0:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800ed2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800ed8:	48 98                	cltq   
  800eda:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800ee1:	48 83 c2 08          	add    $0x8,%rdx
  800ee5:	48 89 c6             	mov    %rax,%rsi
  800ee8:	48 89 d7             	mov    %rdx,%rdi
  800eeb:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  800ef2:	00 00 00 
  800ef5:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800ef7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800efd:	c9                   	leaveq 
  800efe:	c3                   	retq   

0000000000800eff <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800eff:	55                   	push   %rbp
  800f00:	48 89 e5             	mov    %rsp,%rbp
  800f03:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f0a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f11:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f18:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f1f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f26:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f2d:	84 c0                	test   %al,%al
  800f2f:	74 20                	je     800f51 <cprintf+0x52>
  800f31:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f35:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f39:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f3d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f41:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f45:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f49:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f4d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f51:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800f58:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800f5f:	00 00 00 
  800f62:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f69:	00 00 00 
  800f6c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f70:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f77:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f7e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f85:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f8c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f93:	48 8b 0a             	mov    (%rdx),%rcx
  800f96:	48 89 08             	mov    %rcx,(%rax)
  800f99:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f9d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fa1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fa5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800fa9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800fb0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fb7:	48 89 d6             	mov    %rdx,%rsi
  800fba:	48 89 c7             	mov    %rax,%rdi
  800fbd:	48 b8 53 0e 80 00 00 	movabs $0x800e53,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	callq  *%rax
  800fc9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800fcf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fd5:	c9                   	leaveq 
  800fd6:	c3                   	retq   
	...

0000000000800fd8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fd8:	55                   	push   %rbp
  800fd9:	48 89 e5             	mov    %rsp,%rbp
  800fdc:	48 83 ec 30          	sub    $0x30,%rsp
  800fe0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fe4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fe8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fec:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800fef:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800ff3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ff7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800ffa:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800ffe:	77 52                	ja     801052 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801000:	8b 45 e0             	mov    -0x20(%rbp),%eax
  801003:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801007:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80100a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80100e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801012:	ba 00 00 00 00       	mov    $0x0,%edx
  801017:	48 f7 75 d0          	divq   -0x30(%rbp)
  80101b:	48 89 c2             	mov    %rax,%rdx
  80101e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801021:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801024:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801028:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102c:	41 89 f9             	mov    %edi,%r9d
  80102f:	48 89 c7             	mov    %rax,%rdi
  801032:	48 b8 d8 0f 80 00 00 	movabs $0x800fd8,%rax
  801039:	00 00 00 
  80103c:	ff d0                	callq  *%rax
  80103e:	eb 1c                	jmp    80105c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801040:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801044:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801047:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80104b:	48 89 d6             	mov    %rdx,%rsi
  80104e:	89 c7                	mov    %eax,%edi
  801050:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801052:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  801056:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80105a:	7f e4                	jg     801040 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80105c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80105f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801063:	ba 00 00 00 00       	mov    $0x0,%edx
  801068:	48 f7 f1             	div    %rcx
  80106b:	48 89 d0             	mov    %rdx,%rax
  80106e:	48 ba 68 4d 80 00 00 	movabs $0x804d68,%rdx
  801075:	00 00 00 
  801078:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80107c:	0f be c0             	movsbl %al,%eax
  80107f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801083:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801087:	48 89 d6             	mov    %rdx,%rsi
  80108a:	89 c7                	mov    %eax,%edi
  80108c:	ff d1                	callq  *%rcx
}
  80108e:	c9                   	leaveq 
  80108f:	c3                   	retq   

0000000000801090 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801090:	55                   	push   %rbp
  801091:	48 89 e5             	mov    %rsp,%rbp
  801094:	48 83 ec 20          	sub    $0x20,%rsp
  801098:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80109c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80109f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8010a3:	7e 52                	jle    8010f7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8010a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a9:	8b 00                	mov    (%rax),%eax
  8010ab:	83 f8 30             	cmp    $0x30,%eax
  8010ae:	73 24                	jae    8010d4 <getuint+0x44>
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	8b 00                	mov    (%rax),%eax
  8010be:	89 c0                	mov    %eax,%eax
  8010c0:	48 01 d0             	add    %rdx,%rax
  8010c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010c7:	8b 12                	mov    (%rdx),%edx
  8010c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d0:	89 0a                	mov    %ecx,(%rdx)
  8010d2:	eb 17                	jmp    8010eb <getuint+0x5b>
  8010d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010dc:	48 89 d0             	mov    %rdx,%rax
  8010df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010eb:	48 8b 00             	mov    (%rax),%rax
  8010ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8010f2:	e9 a3 00 00 00       	jmpq   80119a <getuint+0x10a>
	else if (lflag)
  8010f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8010fb:	74 4f                	je     80114c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8010fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801101:	8b 00                	mov    (%rax),%eax
  801103:	83 f8 30             	cmp    $0x30,%eax
  801106:	73 24                	jae    80112c <getuint+0x9c>
  801108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	8b 00                	mov    (%rax),%eax
  801116:	89 c0                	mov    %eax,%eax
  801118:	48 01 d0             	add    %rdx,%rax
  80111b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80111f:	8b 12                	mov    (%rdx),%edx
  801121:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801124:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801128:	89 0a                	mov    %ecx,(%rdx)
  80112a:	eb 17                	jmp    801143 <getuint+0xb3>
  80112c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801130:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801134:	48 89 d0             	mov    %rdx,%rax
  801137:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80113b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80113f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801143:	48 8b 00             	mov    (%rax),%rax
  801146:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80114a:	eb 4e                	jmp    80119a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801150:	8b 00                	mov    (%rax),%eax
  801152:	83 f8 30             	cmp    $0x30,%eax
  801155:	73 24                	jae    80117b <getuint+0xeb>
  801157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80115f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801163:	8b 00                	mov    (%rax),%eax
  801165:	89 c0                	mov    %eax,%eax
  801167:	48 01 d0             	add    %rdx,%rax
  80116a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80116e:	8b 12                	mov    (%rdx),%edx
  801170:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801173:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801177:	89 0a                	mov    %ecx,(%rdx)
  801179:	eb 17                	jmp    801192 <getuint+0x102>
  80117b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801183:	48 89 d0             	mov    %rdx,%rax
  801186:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80118a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80118e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801192:	8b 00                	mov    (%rax),%eax
  801194:	89 c0                	mov    %eax,%eax
  801196:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80119e:	c9                   	leaveq 
  80119f:	c3                   	retq   

00000000008011a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011a0:	55                   	push   %rbp
  8011a1:	48 89 e5             	mov    %rsp,%rbp
  8011a4:	48 83 ec 20          	sub    $0x20,%rsp
  8011a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ac:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8011af:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8011b3:	7e 52                	jle    801207 <getint+0x67>
		x=va_arg(*ap, long long);
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	8b 00                	mov    (%rax),%eax
  8011bb:	83 f8 30             	cmp    $0x30,%eax
  8011be:	73 24                	jae    8011e4 <getint+0x44>
  8011c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cc:	8b 00                	mov    (%rax),%eax
  8011ce:	89 c0                	mov    %eax,%eax
  8011d0:	48 01 d0             	add    %rdx,%rax
  8011d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d7:	8b 12                	mov    (%rdx),%edx
  8011d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e0:	89 0a                	mov    %ecx,(%rdx)
  8011e2:	eb 17                	jmp    8011fb <getint+0x5b>
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011ec:	48 89 d0             	mov    %rdx,%rax
  8011ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011fb:	48 8b 00             	mov    (%rax),%rax
  8011fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801202:	e9 a3 00 00 00       	jmpq   8012aa <getint+0x10a>
	else if (lflag)
  801207:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80120b:	74 4f                	je     80125c <getint+0xbc>
		x=va_arg(*ap, long);
  80120d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801211:	8b 00                	mov    (%rax),%eax
  801213:	83 f8 30             	cmp    $0x30,%eax
  801216:	73 24                	jae    80123c <getint+0x9c>
  801218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801224:	8b 00                	mov    (%rax),%eax
  801226:	89 c0                	mov    %eax,%eax
  801228:	48 01 d0             	add    %rdx,%rax
  80122b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80122f:	8b 12                	mov    (%rdx),%edx
  801231:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801234:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801238:	89 0a                	mov    %ecx,(%rdx)
  80123a:	eb 17                	jmp    801253 <getint+0xb3>
  80123c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801240:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801244:	48 89 d0             	mov    %rdx,%rax
  801247:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80124b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80124f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801253:	48 8b 00             	mov    (%rax),%rax
  801256:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80125a:	eb 4e                	jmp    8012aa <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80125c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801260:	8b 00                	mov    (%rax),%eax
  801262:	83 f8 30             	cmp    $0x30,%eax
  801265:	73 24                	jae    80128b <getint+0xeb>
  801267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80126f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801273:	8b 00                	mov    (%rax),%eax
  801275:	89 c0                	mov    %eax,%eax
  801277:	48 01 d0             	add    %rdx,%rax
  80127a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80127e:	8b 12                	mov    (%rdx),%edx
  801280:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801283:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801287:	89 0a                	mov    %ecx,(%rdx)
  801289:	eb 17                	jmp    8012a2 <getint+0x102>
  80128b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801293:	48 89 d0             	mov    %rdx,%rax
  801296:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80129a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80129e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012a2:	8b 00                	mov    (%rax),%eax
  8012a4:	48 98                	cltq   
  8012a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	41 54                	push   %r12
  8012b6:	53                   	push   %rbx
  8012b7:	48 83 ec 60          	sub    $0x60,%rsp
  8012bb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8012bf:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8012c3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8012c7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8012cb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012cf:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8012d3:	48 8b 0a             	mov    (%rdx),%rcx
  8012d6:	48 89 08             	mov    %rcx,(%rax)
  8012d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012dd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012e1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012e9:	eb 17                	jmp    801302 <vprintfmt+0x52>
			if (ch == '\0')
  8012eb:	85 db                	test   %ebx,%ebx
  8012ed:	0f 84 d7 04 00 00    	je     8017ca <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8012f3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8012f7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8012fb:	48 89 c6             	mov    %rax,%rsi
  8012fe:	89 df                	mov    %ebx,%edi
  801300:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801302:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801306:	0f b6 00             	movzbl (%rax),%eax
  801309:	0f b6 d8             	movzbl %al,%ebx
  80130c:	83 fb 25             	cmp    $0x25,%ebx
  80130f:	0f 95 c0             	setne  %al
  801312:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801317:	84 c0                	test   %al,%al
  801319:	75 d0                	jne    8012eb <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80131b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80131f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801326:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80132d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801334:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80133b:	eb 04                	jmp    801341 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80133d:	90                   	nop
  80133e:	eb 01                	jmp    801341 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  801340:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801341:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801345:	0f b6 00             	movzbl (%rax),%eax
  801348:	0f b6 d8             	movzbl %al,%ebx
  80134b:	89 d8                	mov    %ebx,%eax
  80134d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801352:	83 e8 23             	sub    $0x23,%eax
  801355:	83 f8 55             	cmp    $0x55,%eax
  801358:	0f 87 38 04 00 00    	ja     801796 <vprintfmt+0x4e6>
  80135e:	89 c0                	mov    %eax,%eax
  801360:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801367:	00 
  801368:	48 b8 90 4d 80 00 00 	movabs $0x804d90,%rax
  80136f:	00 00 00 
  801372:	48 01 d0             	add    %rdx,%rax
  801375:	48 8b 00             	mov    (%rax),%rax
  801378:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80137a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80137e:	eb c1                	jmp    801341 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801380:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801384:	eb bb                	jmp    801341 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801386:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80138d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801390:	89 d0                	mov    %edx,%eax
  801392:	c1 e0 02             	shl    $0x2,%eax
  801395:	01 d0                	add    %edx,%eax
  801397:	01 c0                	add    %eax,%eax
  801399:	01 d8                	add    %ebx,%eax
  80139b:	83 e8 30             	sub    $0x30,%eax
  80139e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8013a1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8013ae:	7e 63                	jle    801413 <vprintfmt+0x163>
  8013b0:	83 fb 39             	cmp    $0x39,%ebx
  8013b3:	7f 5e                	jg     801413 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013b5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8013ba:	eb d1                	jmp    80138d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8013bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013bf:	83 f8 30             	cmp    $0x30,%eax
  8013c2:	73 17                	jae    8013db <vprintfmt+0x12b>
  8013c4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013cb:	89 c0                	mov    %eax,%eax
  8013cd:	48 01 d0             	add    %rdx,%rax
  8013d0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013d3:	83 c2 08             	add    $0x8,%edx
  8013d6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013d9:	eb 0f                	jmp    8013ea <vprintfmt+0x13a>
  8013db:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013df:	48 89 d0             	mov    %rdx,%rax
  8013e2:	48 83 c2 08          	add    $0x8,%rdx
  8013e6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013ea:	8b 00                	mov    (%rax),%eax
  8013ec:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8013ef:	eb 23                	jmp    801414 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8013f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013f5:	0f 89 42 ff ff ff    	jns    80133d <vprintfmt+0x8d>
				width = 0;
  8013fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801402:	e9 36 ff ff ff       	jmpq   80133d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801407:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80140e:	e9 2e ff ff ff       	jmpq   801341 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801413:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801414:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801418:	0f 89 22 ff ff ff    	jns    801340 <vprintfmt+0x90>
				width = precision, precision = -1;
  80141e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801421:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801424:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80142b:	e9 10 ff ff ff       	jmpq   801340 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801430:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801434:	e9 08 ff ff ff       	jmpq   801341 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801439:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80143c:	83 f8 30             	cmp    $0x30,%eax
  80143f:	73 17                	jae    801458 <vprintfmt+0x1a8>
  801441:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801445:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801448:	89 c0                	mov    %eax,%eax
  80144a:	48 01 d0             	add    %rdx,%rax
  80144d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801450:	83 c2 08             	add    $0x8,%edx
  801453:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801456:	eb 0f                	jmp    801467 <vprintfmt+0x1b7>
  801458:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80145c:	48 89 d0             	mov    %rdx,%rax
  80145f:	48 83 c2 08          	add    $0x8,%rdx
  801463:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801467:	8b 00                	mov    (%rax),%eax
  801469:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80146d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  801471:	48 89 d6             	mov    %rdx,%rsi
  801474:	89 c7                	mov    %eax,%edi
  801476:	ff d1                	callq  *%rcx
			break;
  801478:	e9 47 03 00 00       	jmpq   8017c4 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80147d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801480:	83 f8 30             	cmp    $0x30,%eax
  801483:	73 17                	jae    80149c <vprintfmt+0x1ec>
  801485:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801489:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80148c:	89 c0                	mov    %eax,%eax
  80148e:	48 01 d0             	add    %rdx,%rax
  801491:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801494:	83 c2 08             	add    $0x8,%edx
  801497:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80149a:	eb 0f                	jmp    8014ab <vprintfmt+0x1fb>
  80149c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014a0:	48 89 d0             	mov    %rdx,%rax
  8014a3:	48 83 c2 08          	add    $0x8,%rdx
  8014a7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014ab:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8014ad:	85 db                	test   %ebx,%ebx
  8014af:	79 02                	jns    8014b3 <vprintfmt+0x203>
				err = -err;
  8014b1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8014b3:	83 fb 10             	cmp    $0x10,%ebx
  8014b6:	7f 16                	jg     8014ce <vprintfmt+0x21e>
  8014b8:	48 b8 e0 4c 80 00 00 	movabs $0x804ce0,%rax
  8014bf:	00 00 00 
  8014c2:	48 63 d3             	movslq %ebx,%rdx
  8014c5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8014c9:	4d 85 e4             	test   %r12,%r12
  8014cc:	75 2e                	jne    8014fc <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  8014ce:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8014d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014d6:	89 d9                	mov    %ebx,%ecx
  8014d8:	48 ba 79 4d 80 00 00 	movabs $0x804d79,%rdx
  8014df:	00 00 00 
  8014e2:	48 89 c7             	mov    %rax,%rdi
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	49 b8 d4 17 80 00 00 	movabs $0x8017d4,%r8
  8014f1:	00 00 00 
  8014f4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014f7:	e9 c8 02 00 00       	jmpq   8017c4 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8014fc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801500:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801504:	4c 89 e1             	mov    %r12,%rcx
  801507:	48 ba 82 4d 80 00 00 	movabs $0x804d82,%rdx
  80150e:	00 00 00 
  801511:	48 89 c7             	mov    %rax,%rdi
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
  801519:	49 b8 d4 17 80 00 00 	movabs $0x8017d4,%r8
  801520:	00 00 00 
  801523:	41 ff d0             	callq  *%r8
			break;
  801526:	e9 99 02 00 00       	jmpq   8017c4 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80152b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80152e:	83 f8 30             	cmp    $0x30,%eax
  801531:	73 17                	jae    80154a <vprintfmt+0x29a>
  801533:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801537:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80153a:	89 c0                	mov    %eax,%eax
  80153c:	48 01 d0             	add    %rdx,%rax
  80153f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801542:	83 c2 08             	add    $0x8,%edx
  801545:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801548:	eb 0f                	jmp    801559 <vprintfmt+0x2a9>
  80154a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80154e:	48 89 d0             	mov    %rdx,%rax
  801551:	48 83 c2 08          	add    $0x8,%rdx
  801555:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801559:	4c 8b 20             	mov    (%rax),%r12
  80155c:	4d 85 e4             	test   %r12,%r12
  80155f:	75 0a                	jne    80156b <vprintfmt+0x2bb>
				p = "(null)";
  801561:	49 bc 85 4d 80 00 00 	movabs $0x804d85,%r12
  801568:	00 00 00 
			if (width > 0 && padc != '-')
  80156b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80156f:	7e 7a                	jle    8015eb <vprintfmt+0x33b>
  801571:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801575:	74 74                	je     8015eb <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  801577:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80157a:	48 98                	cltq   
  80157c:	48 89 c6             	mov    %rax,%rsi
  80157f:	4c 89 e7             	mov    %r12,%rdi
  801582:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  801589:	00 00 00 
  80158c:	ff d0                	callq  *%rax
  80158e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801591:	eb 17                	jmp    8015aa <vprintfmt+0x2fa>
					putch(padc, putdat);
  801593:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  801597:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80159b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80159f:	48 89 d6             	mov    %rdx,%rsi
  8015a2:	89 c7                	mov    %eax,%edi
  8015a4:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015a6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8015aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015ae:	7f e3                	jg     801593 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015b0:	eb 39                	jmp    8015eb <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8015b2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8015b6:	74 1e                	je     8015d6 <vprintfmt+0x326>
  8015b8:	83 fb 1f             	cmp    $0x1f,%ebx
  8015bb:	7e 05                	jle    8015c2 <vprintfmt+0x312>
  8015bd:	83 fb 7e             	cmp    $0x7e,%ebx
  8015c0:	7e 14                	jle    8015d6 <vprintfmt+0x326>
					putch('?', putdat);
  8015c2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8015c6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8015ca:	48 89 c6             	mov    %rax,%rsi
  8015cd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8015d2:	ff d2                	callq  *%rdx
  8015d4:	eb 0f                	jmp    8015e5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  8015d6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8015da:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8015de:	48 89 c6             	mov    %rax,%rsi
  8015e1:	89 df                	mov    %ebx,%edi
  8015e3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015e5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8015e9:	eb 01                	jmp    8015ec <vprintfmt+0x33c>
  8015eb:	90                   	nop
  8015ec:	41 0f b6 04 24       	movzbl (%r12),%eax
  8015f1:	0f be d8             	movsbl %al,%ebx
  8015f4:	85 db                	test   %ebx,%ebx
  8015f6:	0f 95 c0             	setne  %al
  8015f9:	49 83 c4 01          	add    $0x1,%r12
  8015fd:	84 c0                	test   %al,%al
  8015ff:	74 28                	je     801629 <vprintfmt+0x379>
  801601:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801605:	78 ab                	js     8015b2 <vprintfmt+0x302>
  801607:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80160b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80160f:	79 a1                	jns    8015b2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801611:	eb 16                	jmp    801629 <vprintfmt+0x379>
				putch(' ', putdat);
  801613:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801617:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80161b:	48 89 c6             	mov    %rax,%rsi
  80161e:	bf 20 00 00 00       	mov    $0x20,%edi
  801623:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801625:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801629:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80162d:	7f e4                	jg     801613 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80162f:	e9 90 01 00 00       	jmpq   8017c4 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801634:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801638:	be 03 00 00 00       	mov    $0x3,%esi
  80163d:	48 89 c7             	mov    %rax,%rdi
  801640:	48 b8 a0 11 80 00 00 	movabs $0x8011a0,%rax
  801647:	00 00 00 
  80164a:	ff d0                	callq  *%rax
  80164c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801654:	48 85 c0             	test   %rax,%rax
  801657:	79 1d                	jns    801676 <vprintfmt+0x3c6>
				putch('-', putdat);
  801659:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80165d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801661:	48 89 c6             	mov    %rax,%rsi
  801664:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801669:	ff d2                	callq  *%rdx
				num = -(long long) num;
  80166b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166f:	48 f7 d8             	neg    %rax
  801672:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801676:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80167d:	e9 d5 00 00 00       	jmpq   801757 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801682:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801686:	be 03 00 00 00       	mov    $0x3,%esi
  80168b:	48 89 c7             	mov    %rax,%rdi
  80168e:	48 b8 90 10 80 00 00 	movabs $0x801090,%rax
  801695:	00 00 00 
  801698:	ff d0                	callq  *%rax
  80169a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80169e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016a5:	e9 ad 00 00 00       	jmpq   801757 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  8016aa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016ae:	be 03 00 00 00       	mov    $0x3,%esi
  8016b3:	48 89 c7             	mov    %rax,%rdi
  8016b6:	48 b8 90 10 80 00 00 	movabs $0x801090,%rax
  8016bd:	00 00 00 
  8016c0:	ff d0                	callq  *%rax
  8016c2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  8016c6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8016cd:	e9 85 00 00 00       	jmpq   801757 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  8016d2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8016d6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8016da:	48 89 c6             	mov    %rax,%rsi
  8016dd:	bf 30 00 00 00       	mov    $0x30,%edi
  8016e2:	ff d2                	callq  *%rdx
			putch('x', putdat);
  8016e4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8016e8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8016ec:	48 89 c6             	mov    %rax,%rsi
  8016ef:	bf 78 00 00 00       	mov    $0x78,%edi
  8016f4:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8016f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016f9:	83 f8 30             	cmp    $0x30,%eax
  8016fc:	73 17                	jae    801715 <vprintfmt+0x465>
  8016fe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801702:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801705:	89 c0                	mov    %eax,%eax
  801707:	48 01 d0             	add    %rdx,%rax
  80170a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80170d:	83 c2 08             	add    $0x8,%edx
  801710:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801713:	eb 0f                	jmp    801724 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  801715:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801719:	48 89 d0             	mov    %rdx,%rax
  80171c:	48 83 c2 08          	add    $0x8,%rdx
  801720:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801724:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801727:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80172b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801732:	eb 23                	jmp    801757 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801734:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801738:	be 03 00 00 00       	mov    $0x3,%esi
  80173d:	48 89 c7             	mov    %rax,%rdi
  801740:	48 b8 90 10 80 00 00 	movabs $0x801090,%rax
  801747:	00 00 00 
  80174a:	ff d0                	callq  *%rax
  80174c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801750:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801757:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80175c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80175f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801762:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801766:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80176a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80176e:	45 89 c1             	mov    %r8d,%r9d
  801771:	41 89 f8             	mov    %edi,%r8d
  801774:	48 89 c7             	mov    %rax,%rdi
  801777:	48 b8 d8 0f 80 00 00 	movabs $0x800fd8,%rax
  80177e:	00 00 00 
  801781:	ff d0                	callq  *%rax
			break;
  801783:	eb 3f                	jmp    8017c4 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801785:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801789:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80178d:	48 89 c6             	mov    %rax,%rsi
  801790:	89 df                	mov    %ebx,%edi
  801792:	ff d2                	callq  *%rdx
			break;
  801794:	eb 2e                	jmp    8017c4 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801796:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80179a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80179e:	48 89 c6             	mov    %rax,%rsi
  8017a1:	bf 25 00 00 00       	mov    $0x25,%edi
  8017a6:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017a8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017ad:	eb 05                	jmp    8017b4 <vprintfmt+0x504>
  8017af:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017b4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8017b8:	48 83 e8 01          	sub    $0x1,%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	3c 25                	cmp    $0x25,%al
  8017c1:	75 ec                	jne    8017af <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  8017c3:	90                   	nop
		}
	}
  8017c4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017c5:	e9 38 fb ff ff       	jmpq   801302 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  8017ca:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  8017cb:	48 83 c4 60          	add    $0x60,%rsp
  8017cf:	5b                   	pop    %rbx
  8017d0:	41 5c                	pop    %r12
  8017d2:	5d                   	pop    %rbp
  8017d3:	c3                   	retq   

00000000008017d4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017d4:	55                   	push   %rbp
  8017d5:	48 89 e5             	mov    %rsp,%rbp
  8017d8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8017df:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8017e6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8017ed:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017f4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017fb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801802:	84 c0                	test   %al,%al
  801804:	74 20                	je     801826 <printfmt+0x52>
  801806:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80180a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80180e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801812:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801816:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80181a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80181e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801822:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801826:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80182d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801834:	00 00 00 
  801837:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80183e:	00 00 00 
  801841:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801845:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80184c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801853:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80185a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801861:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801868:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80186f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801876:	48 89 c7             	mov    %rax,%rdi
  801879:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801880:	00 00 00 
  801883:	ff d0                	callq  *%rax
	va_end(ap);
}
  801885:	c9                   	leaveq 
  801886:	c3                   	retq   

0000000000801887 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	48 83 ec 10          	sub    $0x10,%rsp
  80188f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801892:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189a:	8b 40 10             	mov    0x10(%rax),%eax
  80189d:	8d 50 01             	lea    0x1(%rax),%edx
  8018a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8018a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ab:	48 8b 10             	mov    (%rax),%rdx
  8018ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8018b6:	48 39 c2             	cmp    %rax,%rdx
  8018b9:	73 17                	jae    8018d2 <sprintputch+0x4b>
		*b->buf++ = ch;
  8018bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018bf:	48 8b 00             	mov    (%rax),%rax
  8018c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018c5:	88 10                	mov    %dl,(%rax)
  8018c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cf:	48 89 10             	mov    %rdx,(%rax)
}
  8018d2:	c9                   	leaveq 
  8018d3:	c3                   	retq   

00000000008018d4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	48 83 ec 50          	sub    $0x50,%rsp
  8018dc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018e0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8018e3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8018e7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8018eb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8018ef:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8018f3:	48 8b 0a             	mov    (%rdx),%rcx
  8018f6:	48 89 08             	mov    %rcx,(%rax)
  8018f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8018fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801901:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801905:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801909:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80190d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801911:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801914:	48 98                	cltq   
  801916:	48 83 e8 01          	sub    $0x1,%rax
  80191a:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80191e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801922:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801929:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80192e:	74 06                	je     801936 <vsnprintf+0x62>
  801930:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801934:	7f 07                	jg     80193d <vsnprintf+0x69>
		return -E_INVAL;
  801936:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80193b:	eb 2f                	jmp    80196c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80193d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801941:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801945:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801949:	48 89 c6             	mov    %rax,%rsi
  80194c:	48 bf 87 18 80 00 00 	movabs $0x801887,%rdi
  801953:	00 00 00 
  801956:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  80195d:	00 00 00 
  801960:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801962:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801966:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801969:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801979:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801980:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801986:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80198d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801994:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80199b:	84 c0                	test   %al,%al
  80199d:	74 20                	je     8019bf <snprintf+0x51>
  80199f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8019a3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8019a7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8019ab:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8019af:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8019b3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8019b7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8019bb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8019bf:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8019c6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8019cd:	00 00 00 
  8019d0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8019d7:	00 00 00 
  8019da:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019de:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8019e5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8019ec:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8019f3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8019fa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a01:	48 8b 0a             	mov    (%rdx),%rcx
  801a04:	48 89 08             	mov    %rcx,(%rax)
  801a07:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a0b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a0f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a13:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a17:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a1e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a25:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a2b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a32:	48 89 c7             	mov    %rax,%rdi
  801a35:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801a3c:	00 00 00 
  801a3f:	ff d0                	callq  *%rax
  801a41:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801a47:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801a4d:	c9                   	leaveq 
  801a4e:	c3                   	retq   
	...

0000000000801a50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801a50:	55                   	push   %rbp
  801a51:	48 89 e5             	mov    %rsp,%rbp
  801a54:	48 83 ec 18          	sub    $0x18,%rsp
  801a58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801a5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a63:	eb 09                	jmp    801a6e <strlen+0x1e>
		n++;
  801a65:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801a69:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a72:	0f b6 00             	movzbl (%rax),%eax
  801a75:	84 c0                	test   %al,%al
  801a77:	75 ec                	jne    801a65 <strlen+0x15>
		n++;
	return n;
  801a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801a7c:	c9                   	leaveq 
  801a7d:	c3                   	retq   

0000000000801a7e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801a7e:	55                   	push   %rbp
  801a7f:	48 89 e5             	mov    %rsp,%rbp
  801a82:	48 83 ec 20          	sub    $0x20,%rsp
  801a86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a95:	eb 0e                	jmp    801aa5 <strnlen+0x27>
		n++;
  801a97:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a9b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801aa0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801aa5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801aaa:	74 0b                	je     801ab7 <strnlen+0x39>
  801aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ab0:	0f b6 00             	movzbl (%rax),%eax
  801ab3:	84 c0                	test   %al,%al
  801ab5:	75 e0                	jne    801a97 <strnlen+0x19>
		n++;
	return n;
  801ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801aba:	c9                   	leaveq 
  801abb:	c3                   	retq   

0000000000801abc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	48 83 ec 20          	sub    $0x20,%rsp
  801ac4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ac8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801ad4:	90                   	nop
  801ad5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ad9:	0f b6 10             	movzbl (%rax),%edx
  801adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae0:	88 10                	mov    %dl,(%rax)
  801ae2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae6:	0f b6 00             	movzbl (%rax),%eax
  801ae9:	84 c0                	test   %al,%al
  801aeb:	0f 95 c0             	setne  %al
  801aee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801af3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801af8:	84 c0                	test   %al,%al
  801afa:	75 d9                	jne    801ad5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801afc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b00:	c9                   	leaveq 
  801b01:	c3                   	retq   

0000000000801b02 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b02:	55                   	push   %rbp
  801b03:	48 89 e5             	mov    %rsp,%rbp
  801b06:	48 83 ec 20          	sub    $0x20,%rsp
  801b0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b16:	48 89 c7             	mov    %rax,%rdi
  801b19:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  801b20:	00 00 00 
  801b23:	ff d0                	callq  *%rax
  801b25:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2b:	48 98                	cltq   
  801b2d:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801b31:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b35:	48 89 d6             	mov    %rdx,%rsi
  801b38:	48 89 c7             	mov    %rax,%rdi
  801b3b:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  801b42:	00 00 00 
  801b45:	ff d0                	callq  *%rax
	return dst;
  801b47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b4b:	c9                   	leaveq 
  801b4c:	c3                   	retq   

0000000000801b4d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	48 83 ec 28          	sub    $0x28,%rsp
  801b55:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b5d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801b69:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801b70:	00 
  801b71:	eb 27                	jmp    801b9a <strncpy+0x4d>
		*dst++ = *src;
  801b73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b77:	0f b6 10             	movzbl (%rax),%edx
  801b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b7e:	88 10                	mov    %dl,(%rax)
  801b80:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b89:	0f b6 00             	movzbl (%rax),%eax
  801b8c:	84 c0                	test   %al,%al
  801b8e:	74 05                	je     801b95 <strncpy+0x48>
			src++;
  801b90:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801b95:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801ba2:	72 cf                	jb     801b73 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ba8:	c9                   	leaveq 
  801ba9:	c3                   	retq   

0000000000801baa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801baa:	55                   	push   %rbp
  801bab:	48 89 e5             	mov    %rsp,%rbp
  801bae:	48 83 ec 28          	sub    $0x28,%rsp
  801bb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801bbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801bc6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801bcb:	74 37                	je     801c04 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801bcd:	eb 17                	jmp    801be6 <strlcpy+0x3c>
			*dst++ = *src++;
  801bcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bd3:	0f b6 10             	movzbl (%rax),%edx
  801bd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bda:	88 10                	mov    %dl,(%rax)
  801bdc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801be1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801be6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801beb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801bf0:	74 0b                	je     801bfd <strlcpy+0x53>
  801bf2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bf6:	0f b6 00             	movzbl (%rax),%eax
  801bf9:	84 c0                	test   %al,%al
  801bfb:	75 d2                	jne    801bcf <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c01:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0c:	48 89 d1             	mov    %rdx,%rcx
  801c0f:	48 29 c1             	sub    %rax,%rcx
  801c12:	48 89 c8             	mov    %rcx,%rax
}
  801c15:	c9                   	leaveq 
  801c16:	c3                   	retq   

0000000000801c17 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c17:	55                   	push   %rbp
  801c18:	48 89 e5             	mov    %rsp,%rbp
  801c1b:	48 83 ec 10          	sub    $0x10,%rsp
  801c1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c27:	eb 0a                	jmp    801c33 <strcmp+0x1c>
		p++, q++;
  801c29:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c2e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801c33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c37:	0f b6 00             	movzbl (%rax),%eax
  801c3a:	84 c0                	test   %al,%al
  801c3c:	74 12                	je     801c50 <strcmp+0x39>
  801c3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c42:	0f b6 10             	movzbl (%rax),%edx
  801c45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c49:	0f b6 00             	movzbl (%rax),%eax
  801c4c:	38 c2                	cmp    %al,%dl
  801c4e:	74 d9                	je     801c29 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c54:	0f b6 00             	movzbl (%rax),%eax
  801c57:	0f b6 d0             	movzbl %al,%edx
  801c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c5e:	0f b6 00             	movzbl (%rax),%eax
  801c61:	0f b6 c0             	movzbl %al,%eax
  801c64:	89 d1                	mov    %edx,%ecx
  801c66:	29 c1                	sub    %eax,%ecx
  801c68:	89 c8                	mov    %ecx,%eax
}
  801c6a:	c9                   	leaveq 
  801c6b:	c3                   	retq   

0000000000801c6c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c6c:	55                   	push   %rbp
  801c6d:	48 89 e5             	mov    %rsp,%rbp
  801c70:	48 83 ec 18          	sub    $0x18,%rsp
  801c74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c7c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801c80:	eb 0f                	jmp    801c91 <strncmp+0x25>
		n--, p++, q++;
  801c82:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801c87:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c8c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801c91:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c96:	74 1d                	je     801cb5 <strncmp+0x49>
  801c98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9c:	0f b6 00             	movzbl (%rax),%eax
  801c9f:	84 c0                	test   %al,%al
  801ca1:	74 12                	je     801cb5 <strncmp+0x49>
  801ca3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca7:	0f b6 10             	movzbl (%rax),%edx
  801caa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cae:	0f b6 00             	movzbl (%rax),%eax
  801cb1:	38 c2                	cmp    %al,%dl
  801cb3:	74 cd                	je     801c82 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801cb5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cba:	75 07                	jne    801cc3 <strncmp+0x57>
		return 0;
  801cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc1:	eb 1a                	jmp    801cdd <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc7:	0f b6 00             	movzbl (%rax),%eax
  801cca:	0f b6 d0             	movzbl %al,%edx
  801ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd1:	0f b6 00             	movzbl (%rax),%eax
  801cd4:	0f b6 c0             	movzbl %al,%eax
  801cd7:	89 d1                	mov    %edx,%ecx
  801cd9:	29 c1                	sub    %eax,%ecx
  801cdb:	89 c8                	mov    %ecx,%eax
}
  801cdd:	c9                   	leaveq 
  801cde:	c3                   	retq   

0000000000801cdf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801cdf:	55                   	push   %rbp
  801ce0:	48 89 e5             	mov    %rsp,%rbp
  801ce3:	48 83 ec 10          	sub    $0x10,%rsp
  801ce7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ceb:	89 f0                	mov    %esi,%eax
  801ced:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801cf0:	eb 17                	jmp    801d09 <strchr+0x2a>
		if (*s == c)
  801cf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf6:	0f b6 00             	movzbl (%rax),%eax
  801cf9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801cfc:	75 06                	jne    801d04 <strchr+0x25>
			return (char *) s;
  801cfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d02:	eb 15                	jmp    801d19 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d04:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0d:	0f b6 00             	movzbl (%rax),%eax
  801d10:	84 c0                	test   %al,%al
  801d12:	75 de                	jne    801cf2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d19:	c9                   	leaveq 
  801d1a:	c3                   	retq   

0000000000801d1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d1b:	55                   	push   %rbp
  801d1c:	48 89 e5             	mov    %rsp,%rbp
  801d1f:	48 83 ec 10          	sub    $0x10,%rsp
  801d23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d27:	89 f0                	mov    %esi,%eax
  801d29:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d2c:	eb 11                	jmp    801d3f <strfind+0x24>
		if (*s == c)
  801d2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d32:	0f b6 00             	movzbl (%rax),%eax
  801d35:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d38:	74 12                	je     801d4c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d3a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d43:	0f b6 00             	movzbl (%rax),%eax
  801d46:	84 c0                	test   %al,%al
  801d48:	75 e4                	jne    801d2e <strfind+0x13>
  801d4a:	eb 01                	jmp    801d4d <strfind+0x32>
		if (*s == c)
			break;
  801d4c:	90                   	nop
	return (char *) s;
  801d4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801d51:	c9                   	leaveq 
  801d52:	c3                   	retq   

0000000000801d53 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d53:	55                   	push   %rbp
  801d54:	48 89 e5             	mov    %rsp,%rbp
  801d57:	48 83 ec 18          	sub    $0x18,%rsp
  801d5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d5f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801d62:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801d66:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d6b:	75 06                	jne    801d73 <memset+0x20>
		return v;
  801d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d71:	eb 69                	jmp    801ddc <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d77:	83 e0 03             	and    $0x3,%eax
  801d7a:	48 85 c0             	test   %rax,%rax
  801d7d:	75 48                	jne    801dc7 <memset+0x74>
  801d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d83:	83 e0 03             	and    $0x3,%eax
  801d86:	48 85 c0             	test   %rax,%rax
  801d89:	75 3c                	jne    801dc7 <memset+0x74>
		c &= 0xFF;
  801d8b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801d92:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d95:	89 c2                	mov    %eax,%edx
  801d97:	c1 e2 18             	shl    $0x18,%edx
  801d9a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d9d:	c1 e0 10             	shl    $0x10,%eax
  801da0:	09 c2                	or     %eax,%edx
  801da2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801da5:	c1 e0 08             	shl    $0x8,%eax
  801da8:	09 d0                	or     %edx,%eax
  801daa:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db1:	48 89 c1             	mov    %rax,%rcx
  801db4:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801db8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dbc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dbf:	48 89 d7             	mov    %rdx,%rdi
  801dc2:	fc                   	cld    
  801dc3:	f3 ab                	rep stos %eax,%es:(%rdi)
  801dc5:	eb 11                	jmp    801dd8 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801dc7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dcb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dce:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dd2:	48 89 d7             	mov    %rdx,%rdi
  801dd5:	fc                   	cld    
  801dd6:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801dd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 28          	sub    $0x28,%rsp
  801de6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801dee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801df2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801df6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801dfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e06:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e0a:	0f 83 88 00 00 00    	jae    801e98 <memmove+0xba>
  801e10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e18:	48 01 d0             	add    %rdx,%rax
  801e1b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e1f:	76 77                	jbe    801e98 <memmove+0xba>
		s += n;
  801e21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e25:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e35:	83 e0 03             	and    $0x3,%eax
  801e38:	48 85 c0             	test   %rax,%rax
  801e3b:	75 3b                	jne    801e78 <memmove+0x9a>
  801e3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e41:	83 e0 03             	and    $0x3,%eax
  801e44:	48 85 c0             	test   %rax,%rax
  801e47:	75 2f                	jne    801e78 <memmove+0x9a>
  801e49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4d:	83 e0 03             	and    $0x3,%eax
  801e50:	48 85 c0             	test   %rax,%rax
  801e53:	75 23                	jne    801e78 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e59:	48 83 e8 04          	sub    $0x4,%rax
  801e5d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e61:	48 83 ea 04          	sub    $0x4,%rdx
  801e65:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801e69:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801e6d:	48 89 c7             	mov    %rax,%rdi
  801e70:	48 89 d6             	mov    %rdx,%rsi
  801e73:	fd                   	std    
  801e74:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801e76:	eb 1d                	jmp    801e95 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e84:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801e88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8c:	48 89 d7             	mov    %rdx,%rdi
  801e8f:	48 89 c1             	mov    %rax,%rcx
  801e92:	fd                   	std    
  801e93:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e95:	fc                   	cld    
  801e96:	eb 57                	jmp    801eef <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9c:	83 e0 03             	and    $0x3,%eax
  801e9f:	48 85 c0             	test   %rax,%rax
  801ea2:	75 36                	jne    801eda <memmove+0xfc>
  801ea4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea8:	83 e0 03             	and    $0x3,%eax
  801eab:	48 85 c0             	test   %rax,%rax
  801eae:	75 2a                	jne    801eda <memmove+0xfc>
  801eb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb4:	83 e0 03             	and    $0x3,%eax
  801eb7:	48 85 c0             	test   %rax,%rax
  801eba:	75 1e                	jne    801eda <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ebc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec0:	48 89 c1             	mov    %rax,%rcx
  801ec3:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ecb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ecf:	48 89 c7             	mov    %rax,%rdi
  801ed2:	48 89 d6             	mov    %rdx,%rsi
  801ed5:	fc                   	cld    
  801ed6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ed8:	eb 15                	jmp    801eef <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ede:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ee2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ee6:	48 89 c7             	mov    %rax,%rdi
  801ee9:	48 89 d6             	mov    %rdx,%rsi
  801eec:	fc                   	cld    
  801eed:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ef3:	c9                   	leaveq 
  801ef4:	c3                   	retq   

0000000000801ef5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ef5:	55                   	push   %rbp
  801ef6:	48 89 e5             	mov    %rsp,%rbp
  801ef9:	48 83 ec 18          	sub    $0x18,%rsp
  801efd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f05:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f0d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f15:	48 89 ce             	mov    %rcx,%rsi
  801f18:	48 89 c7             	mov    %rax,%rdi
  801f1b:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
}
  801f27:	c9                   	leaveq 
  801f28:	c3                   	retq   

0000000000801f29 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f29:	55                   	push   %rbp
  801f2a:	48 89 e5             	mov    %rsp,%rbp
  801f2d:	48 83 ec 28          	sub    $0x28,%rsp
  801f31:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f39:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f41:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801f45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f49:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801f4d:	eb 38                	jmp    801f87 <memcmp+0x5e>
		if (*s1 != *s2)
  801f4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f53:	0f b6 10             	movzbl (%rax),%edx
  801f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5a:	0f b6 00             	movzbl (%rax),%eax
  801f5d:	38 c2                	cmp    %al,%dl
  801f5f:	74 1c                	je     801f7d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f65:	0f b6 00             	movzbl (%rax),%eax
  801f68:	0f b6 d0             	movzbl %al,%edx
  801f6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6f:	0f b6 00             	movzbl (%rax),%eax
  801f72:	0f b6 c0             	movzbl %al,%eax
  801f75:	89 d1                	mov    %edx,%ecx
  801f77:	29 c1                	sub    %eax,%ecx
  801f79:	89 c8                	mov    %ecx,%eax
  801f7b:	eb 20                	jmp    801f9d <memcmp+0x74>
		s1++, s2++;
  801f7d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f82:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f87:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801f8c:	0f 95 c0             	setne  %al
  801f8f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801f94:	84 c0                	test   %al,%al
  801f96:	75 b7                	jne    801f4f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9d:	c9                   	leaveq 
  801f9e:	c3                   	retq   

0000000000801f9f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f9f:	55                   	push   %rbp
  801fa0:	48 89 e5             	mov    %rsp,%rbp
  801fa3:	48 83 ec 28          	sub    $0x28,%rsp
  801fa7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fab:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801fae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801fb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fba:	48 01 d0             	add    %rdx,%rax
  801fbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801fc1:	eb 13                	jmp    801fd6 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc7:	0f b6 10             	movzbl (%rax),%edx
  801fca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801fcd:	38 c2                	cmp    %al,%dl
  801fcf:	74 11                	je     801fe2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801fd1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fda:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801fde:	72 e3                	jb     801fc3 <memfind+0x24>
  801fe0:	eb 01                	jmp    801fe3 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801fe2:	90                   	nop
	return (void *) s;
  801fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801fe7:	c9                   	leaveq 
  801fe8:	c3                   	retq   

0000000000801fe9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fe9:	55                   	push   %rbp
  801fea:	48 89 e5             	mov    %rsp,%rbp
  801fed:	48 83 ec 38          	sub    $0x38,%rsp
  801ff1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ff5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801ff9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802003:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80200a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80200b:	eb 05                	jmp    802012 <strtol+0x29>
		s++;
  80200d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802012:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802016:	0f b6 00             	movzbl (%rax),%eax
  802019:	3c 20                	cmp    $0x20,%al
  80201b:	74 f0                	je     80200d <strtol+0x24>
  80201d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802021:	0f b6 00             	movzbl (%rax),%eax
  802024:	3c 09                	cmp    $0x9,%al
  802026:	74 e5                	je     80200d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802028:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202c:	0f b6 00             	movzbl (%rax),%eax
  80202f:	3c 2b                	cmp    $0x2b,%al
  802031:	75 07                	jne    80203a <strtol+0x51>
		s++;
  802033:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802038:	eb 17                	jmp    802051 <strtol+0x68>
	else if (*s == '-')
  80203a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80203e:	0f b6 00             	movzbl (%rax),%eax
  802041:	3c 2d                	cmp    $0x2d,%al
  802043:	75 0c                	jne    802051 <strtol+0x68>
		s++, neg = 1;
  802045:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80204a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802051:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802055:	74 06                	je     80205d <strtol+0x74>
  802057:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80205b:	75 28                	jne    802085 <strtol+0x9c>
  80205d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802061:	0f b6 00             	movzbl (%rax),%eax
  802064:	3c 30                	cmp    $0x30,%al
  802066:	75 1d                	jne    802085 <strtol+0x9c>
  802068:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206c:	48 83 c0 01          	add    $0x1,%rax
  802070:	0f b6 00             	movzbl (%rax),%eax
  802073:	3c 78                	cmp    $0x78,%al
  802075:	75 0e                	jne    802085 <strtol+0x9c>
		s += 2, base = 16;
  802077:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80207c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802083:	eb 2c                	jmp    8020b1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802085:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802089:	75 19                	jne    8020a4 <strtol+0xbb>
  80208b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208f:	0f b6 00             	movzbl (%rax),%eax
  802092:	3c 30                	cmp    $0x30,%al
  802094:	75 0e                	jne    8020a4 <strtol+0xbb>
		s++, base = 8;
  802096:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80209b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8020a2:	eb 0d                	jmp    8020b1 <strtol+0xc8>
	else if (base == 0)
  8020a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020a8:	75 07                	jne    8020b1 <strtol+0xc8>
		base = 10;
  8020aa:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8020b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b5:	0f b6 00             	movzbl (%rax),%eax
  8020b8:	3c 2f                	cmp    $0x2f,%al
  8020ba:	7e 1d                	jle    8020d9 <strtol+0xf0>
  8020bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c0:	0f b6 00             	movzbl (%rax),%eax
  8020c3:	3c 39                	cmp    $0x39,%al
  8020c5:	7f 12                	jg     8020d9 <strtol+0xf0>
			dig = *s - '0';
  8020c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020cb:	0f b6 00             	movzbl (%rax),%eax
  8020ce:	0f be c0             	movsbl %al,%eax
  8020d1:	83 e8 30             	sub    $0x30,%eax
  8020d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020d7:	eb 4e                	jmp    802127 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8020d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020dd:	0f b6 00             	movzbl (%rax),%eax
  8020e0:	3c 60                	cmp    $0x60,%al
  8020e2:	7e 1d                	jle    802101 <strtol+0x118>
  8020e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e8:	0f b6 00             	movzbl (%rax),%eax
  8020eb:	3c 7a                	cmp    $0x7a,%al
  8020ed:	7f 12                	jg     802101 <strtol+0x118>
			dig = *s - 'a' + 10;
  8020ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f3:	0f b6 00             	movzbl (%rax),%eax
  8020f6:	0f be c0             	movsbl %al,%eax
  8020f9:	83 e8 57             	sub    $0x57,%eax
  8020fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020ff:	eb 26                	jmp    802127 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802101:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802105:	0f b6 00             	movzbl (%rax),%eax
  802108:	3c 40                	cmp    $0x40,%al
  80210a:	7e 47                	jle    802153 <strtol+0x16a>
  80210c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802110:	0f b6 00             	movzbl (%rax),%eax
  802113:	3c 5a                	cmp    $0x5a,%al
  802115:	7f 3c                	jg     802153 <strtol+0x16a>
			dig = *s - 'A' + 10;
  802117:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211b:	0f b6 00             	movzbl (%rax),%eax
  80211e:	0f be c0             	movsbl %al,%eax
  802121:	83 e8 37             	sub    $0x37,%eax
  802124:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802127:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80212a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80212d:	7d 23                	jge    802152 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80212f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802134:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802137:	48 98                	cltq   
  802139:	48 89 c2             	mov    %rax,%rdx
  80213c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  802141:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802144:	48 98                	cltq   
  802146:	48 01 d0             	add    %rdx,%rax
  802149:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80214d:	e9 5f ff ff ff       	jmpq   8020b1 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802152:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802153:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802158:	74 0b                	je     802165 <strtol+0x17c>
		*endptr = (char *) s;
  80215a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80215e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802162:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  802165:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802169:	74 09                	je     802174 <strtol+0x18b>
  80216b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80216f:	48 f7 d8             	neg    %rax
  802172:	eb 04                	jmp    802178 <strtol+0x18f>
  802174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802178:	c9                   	leaveq 
  802179:	c3                   	retq   

000000000080217a <strstr>:

char * strstr(const char *in, const char *str)
{
  80217a:	55                   	push   %rbp
  80217b:	48 89 e5             	mov    %rsp,%rbp
  80217e:	48 83 ec 30          	sub    $0x30,%rsp
  802182:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802186:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80218a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80218e:	0f b6 00             	movzbl (%rax),%eax
  802191:	88 45 ff             	mov    %al,-0x1(%rbp)
  802194:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  802199:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80219d:	75 06                	jne    8021a5 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80219f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a3:	eb 68                	jmp    80220d <strstr+0x93>

    len = strlen(str);
  8021a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021a9:	48 89 c7             	mov    %rax,%rdi
  8021ac:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax
  8021b8:	48 98                	cltq   
  8021ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8021be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c2:	0f b6 00             	movzbl (%rax),%eax
  8021c5:	88 45 ef             	mov    %al,-0x11(%rbp)
  8021c8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8021cd:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8021d1:	75 07                	jne    8021da <strstr+0x60>
                return (char *) 0;
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d8:	eb 33                	jmp    80220d <strstr+0x93>
        } while (sc != c);
  8021da:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8021de:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8021e1:	75 db                	jne    8021be <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8021e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8021eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ef:	48 89 ce             	mov    %rcx,%rsi
  8021f2:	48 89 c7             	mov    %rax,%rdi
  8021f5:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  8021fc:	00 00 00 
  8021ff:	ff d0                	callq  *%rax
  802201:	85 c0                	test   %eax,%eax
  802203:	75 b9                	jne    8021be <strstr+0x44>

    return (char *) (in - 1);
  802205:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802209:	48 83 e8 01          	sub    $0x1,%rax
}
  80220d:	c9                   	leaveq 
  80220e:	c3                   	retq   
	...

0000000000802210 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	53                   	push   %rbx
  802215:	48 83 ec 58          	sub    $0x58,%rsp
  802219:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80221c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80221f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802223:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802227:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80222b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80222f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802232:	89 45 ac             	mov    %eax,-0x54(%rbp)
  802235:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802239:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80223d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802241:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802245:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802249:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80224c:	4c 89 c3             	mov    %r8,%rbx
  80224f:	cd 30                	int    $0x30
  802251:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  802255:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  802259:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80225d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802261:	74 3e                	je     8022a1 <syscall+0x91>
  802263:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802268:	7e 37                	jle    8022a1 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80226a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80226e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802271:	49 89 d0             	mov    %rdx,%r8
  802274:	89 c1                	mov    %eax,%ecx
  802276:	48 ba 40 50 80 00 00 	movabs $0x805040,%rdx
  80227d:	00 00 00 
  802280:	be 23 00 00 00       	mov    $0x23,%esi
  802285:	48 bf 5d 50 80 00 00 	movabs $0x80505d,%rdi
  80228c:	00 00 00 
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	49 b9 c4 0c 80 00 00 	movabs $0x800cc4,%r9
  80229b:	00 00 00 
  80229e:	41 ff d1             	callq  *%r9

	return ret;
  8022a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022a5:	48 83 c4 58          	add    $0x58,%rsp
  8022a9:	5b                   	pop    %rbx
  8022aa:	5d                   	pop    %rbp
  8022ab:	c3                   	retq   

00000000008022ac <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8022ac:	55                   	push   %rbp
  8022ad:	48 89 e5             	mov    %rsp,%rbp
  8022b0:	48 83 ec 20          	sub    $0x20,%rsp
  8022b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8022bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022cb:	00 
  8022cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022d8:	48 89 d1             	mov    %rdx,%rcx
  8022db:	48 89 c2             	mov    %rax,%rdx
  8022de:	be 00 00 00 00       	mov    $0x0,%esi
  8022e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e8:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
}
  8022f4:	c9                   	leaveq 
  8022f5:	c3                   	retq   

00000000008022f6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022f6:	55                   	push   %rbp
  8022f7:	48 89 e5             	mov    %rsp,%rbp
  8022fa:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8022fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802305:	00 
  802306:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80230c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802312:	b9 00 00 00 00       	mov    $0x0,%ecx
  802317:	ba 00 00 00 00       	mov    $0x0,%edx
  80231c:	be 00 00 00 00       	mov    $0x0,%esi
  802321:	bf 01 00 00 00       	mov    $0x1,%edi
  802326:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  80232d:	00 00 00 
  802330:	ff d0                	callq  *%rax
}
  802332:	c9                   	leaveq 
  802333:	c3                   	retq   

0000000000802334 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802334:	55                   	push   %rbp
  802335:	48 89 e5             	mov    %rsp,%rbp
  802338:	48 83 ec 20          	sub    $0x20,%rsp
  80233c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80233f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802342:	48 98                	cltq   
  802344:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80234b:	00 
  80234c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802352:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802358:	b9 00 00 00 00       	mov    $0x0,%ecx
  80235d:	48 89 c2             	mov    %rax,%rdx
  802360:	be 01 00 00 00       	mov    $0x1,%esi
  802365:	bf 03 00 00 00       	mov    $0x3,%edi
  80236a:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802371:	00 00 00 
  802374:	ff d0                	callq  *%rax
}
  802376:	c9                   	leaveq 
  802377:	c3                   	retq   

0000000000802378 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802378:	55                   	push   %rbp
  802379:	48 89 e5             	mov    %rsp,%rbp
  80237c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802380:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802387:	00 
  802388:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80238e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802394:	b9 00 00 00 00       	mov    $0x0,%ecx
  802399:	ba 00 00 00 00       	mov    $0x0,%edx
  80239e:	be 00 00 00 00       	mov    $0x0,%esi
  8023a3:	bf 02 00 00 00       	mov    $0x2,%edi
  8023a8:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8023af:	00 00 00 
  8023b2:	ff d0                	callq  *%rax
}
  8023b4:	c9                   	leaveq 
  8023b5:	c3                   	retq   

00000000008023b6 <sys_yield>:

void
sys_yield(void)
{
  8023b6:	55                   	push   %rbp
  8023b7:	48 89 e5             	mov    %rsp,%rbp
  8023ba:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8023be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023c5:	00 
  8023c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8023dc:	be 00 00 00 00       	mov    $0x0,%esi
  8023e1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8023e6:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8023ed:	00 00 00 
  8023f0:	ff d0                	callq  *%rax
}
  8023f2:	c9                   	leaveq 
  8023f3:	c3                   	retq   

00000000008023f4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8023f4:	55                   	push   %rbp
  8023f5:	48 89 e5             	mov    %rsp,%rbp
  8023f8:	48 83 ec 20          	sub    $0x20,%rsp
  8023fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802403:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802406:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802409:	48 63 c8             	movslq %eax,%rcx
  80240c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802410:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802413:	48 98                	cltq   
  802415:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80241c:	00 
  80241d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802423:	49 89 c8             	mov    %rcx,%r8
  802426:	48 89 d1             	mov    %rdx,%rcx
  802429:	48 89 c2             	mov    %rax,%rdx
  80242c:	be 01 00 00 00       	mov    $0x1,%esi
  802431:	bf 04 00 00 00       	mov    $0x4,%edi
  802436:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  80243d:	00 00 00 
  802440:	ff d0                	callq  *%rax
}
  802442:	c9                   	leaveq 
  802443:	c3                   	retq   

0000000000802444 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802444:	55                   	push   %rbp
  802445:	48 89 e5             	mov    %rsp,%rbp
  802448:	48 83 ec 30          	sub    $0x30,%rsp
  80244c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80244f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802453:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802456:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80245a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80245e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802461:	48 63 c8             	movslq %eax,%rcx
  802464:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802468:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80246b:	48 63 f0             	movslq %eax,%rsi
  80246e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802475:	48 98                	cltq   
  802477:	48 89 0c 24          	mov    %rcx,(%rsp)
  80247b:	49 89 f9             	mov    %rdi,%r9
  80247e:	49 89 f0             	mov    %rsi,%r8
  802481:	48 89 d1             	mov    %rdx,%rcx
  802484:	48 89 c2             	mov    %rax,%rdx
  802487:	be 01 00 00 00       	mov    $0x1,%esi
  80248c:	bf 05 00 00 00       	mov    $0x5,%edi
  802491:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
}
  80249d:	c9                   	leaveq 
  80249e:	c3                   	retq   

000000000080249f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80249f:	55                   	push   %rbp
  8024a0:	48 89 e5             	mov    %rsp,%rbp
  8024a3:	48 83 ec 20          	sub    $0x20,%rsp
  8024a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8024ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b5:	48 98                	cltq   
  8024b7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024be:	00 
  8024bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024cb:	48 89 d1             	mov    %rdx,%rcx
  8024ce:	48 89 c2             	mov    %rax,%rdx
  8024d1:	be 01 00 00 00       	mov    $0x1,%esi
  8024d6:	bf 06 00 00 00       	mov    $0x6,%edi
  8024db:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax
}
  8024e7:	c9                   	leaveq 
  8024e8:	c3                   	retq   

00000000008024e9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8024e9:	55                   	push   %rbp
  8024ea:	48 89 e5             	mov    %rsp,%rbp
  8024ed:	48 83 ec 20          	sub    $0x20,%rsp
  8024f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024f4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8024f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024fa:	48 63 d0             	movslq %eax,%rdx
  8024fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802500:	48 98                	cltq   
  802502:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802509:	00 
  80250a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802510:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802516:	48 89 d1             	mov    %rdx,%rcx
  802519:	48 89 c2             	mov    %rax,%rdx
  80251c:	be 01 00 00 00       	mov    $0x1,%esi
  802521:	bf 08 00 00 00       	mov    $0x8,%edi
  802526:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  80252d:	00 00 00 
  802530:	ff d0                	callq  *%rax
}
  802532:	c9                   	leaveq 
  802533:	c3                   	retq   

0000000000802534 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802534:	55                   	push   %rbp
  802535:	48 89 e5             	mov    %rsp,%rbp
  802538:	48 83 ec 20          	sub    $0x20,%rsp
  80253c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80253f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802543:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254a:	48 98                	cltq   
  80254c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802553:	00 
  802554:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80255a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802560:	48 89 d1             	mov    %rdx,%rcx
  802563:	48 89 c2             	mov    %rax,%rdx
  802566:	be 01 00 00 00       	mov    $0x1,%esi
  80256b:	bf 09 00 00 00       	mov    $0x9,%edi
  802570:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802577:	00 00 00 
  80257a:	ff d0                	callq  *%rax
}
  80257c:	c9                   	leaveq 
  80257d:	c3                   	retq   

000000000080257e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80257e:	55                   	push   %rbp
  80257f:	48 89 e5             	mov    %rsp,%rbp
  802582:	48 83 ec 20          	sub    $0x20,%rsp
  802586:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802589:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80258d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802594:	48 98                	cltq   
  802596:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80259d:	00 
  80259e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025aa:	48 89 d1             	mov    %rdx,%rcx
  8025ad:	48 89 c2             	mov    %rax,%rdx
  8025b0:	be 01 00 00 00       	mov    $0x1,%esi
  8025b5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8025ba:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8025c1:	00 00 00 
  8025c4:	ff d0                	callq  *%rax
}
  8025c6:	c9                   	leaveq 
  8025c7:	c3                   	retq   

00000000008025c8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8025c8:	55                   	push   %rbp
  8025c9:	48 89 e5             	mov    %rsp,%rbp
  8025cc:	48 83 ec 30          	sub    $0x30,%rsp
  8025d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8025db:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8025de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025e1:	48 63 f0             	movslq %eax,%rsi
  8025e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025eb:	48 98                	cltq   
  8025ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025f8:	00 
  8025f9:	49 89 f1             	mov    %rsi,%r9
  8025fc:	49 89 c8             	mov    %rcx,%r8
  8025ff:	48 89 d1             	mov    %rdx,%rcx
  802602:	48 89 c2             	mov    %rax,%rdx
  802605:	be 00 00 00 00       	mov    $0x0,%esi
  80260a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80260f:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
}
  80261b:	c9                   	leaveq 
  80261c:	c3                   	retq   

000000000080261d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80261d:	55                   	push   %rbp
  80261e:	48 89 e5             	mov    %rsp,%rbp
  802621:	48 83 ec 20          	sub    $0x20,%rsp
  802625:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80262d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802634:	00 
  802635:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80263b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802641:	b9 00 00 00 00       	mov    $0x0,%ecx
  802646:	48 89 c2             	mov    %rax,%rdx
  802649:	be 01 00 00 00       	mov    $0x1,%esi
  80264e:	bf 0d 00 00 00       	mov    $0xd,%edi
  802653:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  80265a:	00 00 00 
  80265d:	ff d0                	callq  *%rax
}
  80265f:	c9                   	leaveq 
  802660:	c3                   	retq   

0000000000802661 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802661:	55                   	push   %rbp
  802662:	48 89 e5             	mov    %rsp,%rbp
  802665:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802669:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802670:	00 
  802671:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802677:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80267d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802682:	ba 00 00 00 00       	mov    $0x0,%edx
  802687:	be 00 00 00 00       	mov    $0x0,%esi
  80268c:	bf 0e 00 00 00       	mov    $0xe,%edi
  802691:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802698:	00 00 00 
  80269b:	ff d0                	callq  *%rax
}
  80269d:	c9                   	leaveq 
  80269e:	c3                   	retq   

000000000080269f <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  80269f:	55                   	push   %rbp
  8026a0:	48 89 e5             	mov    %rsp,%rbp
  8026a3:	48 83 ec 20          	sub    $0x20,%rsp
  8026a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8026af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026b7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8026be:	00 
  8026bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026cb:	48 89 d1             	mov    %rdx,%rcx
  8026ce:	48 89 c2             	mov    %rax,%rdx
  8026d1:	be 00 00 00 00       	mov    $0x0,%esi
  8026d6:	bf 0f 00 00 00       	mov    $0xf,%edi
  8026db:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
}
  8026e7:	c9                   	leaveq 
  8026e8:	c3                   	retq   

00000000008026e9 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  8026e9:	55                   	push   %rbp
  8026ea:	48 89 e5             	mov    %rsp,%rbp
  8026ed:	48 83 ec 20          	sub    $0x20,%rsp
  8026f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8026f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802701:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802708:	00 
  802709:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80270f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802715:	48 89 d1             	mov    %rdx,%rcx
  802718:	48 89 c2             	mov    %rax,%rdx
  80271b:	be 00 00 00 00       	mov    $0x0,%esi
  802720:	bf 10 00 00 00       	mov    $0x10,%edi
  802725:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  80272c:	00 00 00 
  80272f:	ff d0                	callq  *%rax
}
  802731:	c9                   	leaveq 
  802732:	c3                   	retq   
	...

0000000000802734 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802734:	55                   	push   %rbp
  802735:	48 89 e5             	mov    %rsp,%rbp
  802738:	48 83 ec 30          	sub    $0x30,%rsp
  80273c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802740:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802744:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  802748:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80274d:	74 18                	je     802767 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80274f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802753:	48 89 c7             	mov    %rax,%rdi
  802756:	48 b8 1d 26 80 00 00 	movabs $0x80261d,%rax
  80275d:	00 00 00 
  802760:	ff d0                	callq  *%rax
  802762:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802765:	eb 19                	jmp    802780 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  802767:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80276e:	00 00 00 
  802771:	48 b8 1d 26 80 00 00 	movabs $0x80261d,%rax
  802778:	00 00 00 
  80277b:	ff d0                	callq  *%rax
  80277d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  802780:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802784:	79 19                	jns    80279f <ipc_recv+0x6b>
	{
		*from_env_store=0;
  802786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  802790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802794:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  80279a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279d:	eb 53                	jmp    8027f2 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  80279f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8027a4:	74 19                	je     8027bf <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8027a6:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8027ad:	00 00 00 
  8027b0:	48 8b 00             	mov    (%rax),%rax
  8027b3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8027b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bd:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8027bf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027c4:	74 19                	je     8027df <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8027c6:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8027cd:	00 00 00 
  8027d0:	48 8b 00             	mov    (%rax),%rax
  8027d3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8027d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027dd:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8027df:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8027e6:	00 00 00 
  8027e9:	48 8b 00             	mov    (%rax),%rax
  8027ec:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8027f2:	c9                   	leaveq 
  8027f3:	c3                   	retq   

00000000008027f4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027f4:	55                   	push   %rbp
  8027f5:	48 89 e5             	mov    %rsp,%rbp
  8027f8:	48 83 ec 30          	sub    $0x30,%rsp
  8027fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027ff:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802802:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802806:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  802809:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  802810:	e9 96 00 00 00       	jmpq   8028ab <ipc_send+0xb7>
	{
		if(pg!=NULL)
  802815:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80281a:	74 20                	je     80283c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  80281c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80281f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802822:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802826:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802829:	89 c7                	mov    %eax,%edi
  80282b:	48 b8 c8 25 80 00 00 	movabs $0x8025c8,%rax
  802832:	00 00 00 
  802835:	ff d0                	callq  *%rax
  802837:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283a:	eb 2d                	jmp    802869 <ipc_send+0x75>
		else if(pg==NULL)
  80283c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802841:	75 26                	jne    802869 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  802843:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802846:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802849:	b9 00 00 00 00       	mov    $0x0,%ecx
  80284e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802855:	00 00 00 
  802858:	89 c7                	mov    %eax,%edi
  80285a:	48 b8 c8 25 80 00 00 	movabs $0x8025c8,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
  802866:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  802869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286d:	79 30                	jns    80289f <ipc_send+0xab>
  80286f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802873:	74 2a                	je     80289f <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  802875:	48 ba 6b 50 80 00 00 	movabs $0x80506b,%rdx
  80287c:	00 00 00 
  80287f:	be 40 00 00 00       	mov    $0x40,%esi
  802884:	48 bf 83 50 80 00 00 	movabs $0x805083,%rdi
  80288b:	00 00 00 
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	48 b9 c4 0c 80 00 00 	movabs $0x800cc4,%rcx
  80289a:	00 00 00 
  80289d:	ff d1                	callq  *%rcx
		}
		sys_yield();
  80289f:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  8028a6:	00 00 00 
  8028a9:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8028ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028af:	0f 85 60 ff ff ff    	jne    802815 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8028b5:	c9                   	leaveq 
  8028b6:	c3                   	retq   

00000000008028b7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028b7:	55                   	push   %rbp
  8028b8:	48 89 e5             	mov    %rsp,%rbp
  8028bb:	48 83 ec 18          	sub    $0x18,%rsp
  8028bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8028c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028c9:	eb 5e                	jmp    802929 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8028cb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8028d2:	00 00 00 
  8028d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d8:	48 63 d0             	movslq %eax,%rdx
  8028db:	48 89 d0             	mov    %rdx,%rax
  8028de:	48 c1 e0 03          	shl    $0x3,%rax
  8028e2:	48 01 d0             	add    %rdx,%rax
  8028e5:	48 c1 e0 05          	shl    $0x5,%rax
  8028e9:	48 01 c8             	add    %rcx,%rax
  8028ec:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8028f2:	8b 00                	mov    (%rax),%eax
  8028f4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028f7:	75 2c                	jne    802925 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8028f9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802900:	00 00 00 
  802903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802906:	48 63 d0             	movslq %eax,%rdx
  802909:	48 89 d0             	mov    %rdx,%rax
  80290c:	48 c1 e0 03          	shl    $0x3,%rax
  802910:	48 01 d0             	add    %rdx,%rax
  802913:	48 c1 e0 05          	shl    $0x5,%rax
  802917:	48 01 c8             	add    %rcx,%rax
  80291a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802920:	8b 40 08             	mov    0x8(%rax),%eax
  802923:	eb 12                	jmp    802937 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802925:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802929:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802930:	7e 99                	jle    8028cb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802932:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802937:	c9                   	leaveq 
  802938:	c3                   	retq   
  802939:	00 00                	add    %al,(%rax)
	...

000000000080293c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80293c:	55                   	push   %rbp
  80293d:	48 89 e5             	mov    %rsp,%rbp
  802940:	48 83 ec 08          	sub    $0x8,%rsp
  802944:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802948:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80294c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802953:	ff ff ff 
  802956:	48 01 d0             	add    %rdx,%rax
  802959:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80295d:	c9                   	leaveq 
  80295e:	c3                   	retq   

000000000080295f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80295f:	55                   	push   %rbp
  802960:	48 89 e5             	mov    %rsp,%rbp
  802963:	48 83 ec 08          	sub    $0x8,%rsp
  802967:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80296b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80296f:	48 89 c7             	mov    %rax,%rdi
  802972:	48 b8 3c 29 80 00 00 	movabs $0x80293c,%rax
  802979:	00 00 00 
  80297c:	ff d0                	callq  *%rax
  80297e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802984:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802988:	c9                   	leaveq 
  802989:	c3                   	retq   

000000000080298a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80298a:	55                   	push   %rbp
  80298b:	48 89 e5             	mov    %rsp,%rbp
  80298e:	48 83 ec 18          	sub    $0x18,%rsp
  802992:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802996:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80299d:	eb 6b                	jmp    802a0a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80299f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a2:	48 98                	cltq   
  8029a4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8029ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8029b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b6:	48 89 c2             	mov    %rax,%rdx
  8029b9:	48 c1 ea 15          	shr    $0x15,%rdx
  8029bd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029c4:	01 00 00 
  8029c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029cb:	83 e0 01             	and    $0x1,%eax
  8029ce:	48 85 c0             	test   %rax,%rax
  8029d1:	74 21                	je     8029f4 <fd_alloc+0x6a>
  8029d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d7:	48 89 c2             	mov    %rax,%rdx
  8029da:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029de:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029e5:	01 00 00 
  8029e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029ec:	83 e0 01             	and    $0x1,%eax
  8029ef:	48 85 c0             	test   %rax,%rax
  8029f2:	75 12                	jne    802a06 <fd_alloc+0x7c>
			*fd_store = fd;
  8029f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029fc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8029ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802a04:	eb 1a                	jmp    802a20 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a06:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a0a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a0e:	7e 8f                	jle    80299f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a14:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802a1b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802a20:	c9                   	leaveq 
  802a21:	c3                   	retq   

0000000000802a22 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802a22:	55                   	push   %rbp
  802a23:	48 89 e5             	mov    %rsp,%rbp
  802a26:	48 83 ec 20          	sub    $0x20,%rsp
  802a2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802a31:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a35:	78 06                	js     802a3d <fd_lookup+0x1b>
  802a37:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802a3b:	7e 07                	jle    802a44 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a42:	eb 6c                	jmp    802ab0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802a44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a47:	48 98                	cltq   
  802a49:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a4f:	48 c1 e0 0c          	shl    $0xc,%rax
  802a53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802a57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a5b:	48 89 c2             	mov    %rax,%rdx
  802a5e:	48 c1 ea 15          	shr    $0x15,%rdx
  802a62:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a69:	01 00 00 
  802a6c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a70:	83 e0 01             	and    $0x1,%eax
  802a73:	48 85 c0             	test   %rax,%rax
  802a76:	74 21                	je     802a99 <fd_lookup+0x77>
  802a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a7c:	48 89 c2             	mov    %rax,%rdx
  802a7f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a8a:	01 00 00 
  802a8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a91:	83 e0 01             	and    $0x1,%eax
  802a94:	48 85 c0             	test   %rax,%rax
  802a97:	75 07                	jne    802aa0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a9e:	eb 10                	jmp    802ab0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802aa0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802aa8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab0:	c9                   	leaveq 
  802ab1:	c3                   	retq   

0000000000802ab2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802ab2:	55                   	push   %rbp
  802ab3:	48 89 e5             	mov    %rsp,%rbp
  802ab6:	48 83 ec 30          	sub    $0x30,%rsp
  802aba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802abe:	89 f0                	mov    %esi,%eax
  802ac0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ac3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac7:	48 89 c7             	mov    %rax,%rdi
  802aca:	48 b8 3c 29 80 00 00 	movabs $0x80293c,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
  802ad6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ada:	48 89 d6             	mov    %rdx,%rsi
  802add:	89 c7                	mov    %eax,%edi
  802adf:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
  802aeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af2:	78 0a                	js     802afe <fd_close+0x4c>
	    || fd != fd2)
  802af4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802afc:	74 12                	je     802b10 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802afe:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802b02:	74 05                	je     802b09 <fd_close+0x57>
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	eb 05                	jmp    802b0e <fd_close+0x5c>
  802b09:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0e:	eb 69                	jmp    802b79 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802b10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b14:	8b 00                	mov    (%rax),%eax
  802b16:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b1a:	48 89 d6             	mov    %rdx,%rsi
  802b1d:	89 c7                	mov    %eax,%edi
  802b1f:	48 b8 7b 2b 80 00 00 	movabs $0x802b7b,%rax
  802b26:	00 00 00 
  802b29:	ff d0                	callq  *%rax
  802b2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b32:	78 2a                	js     802b5e <fd_close+0xac>
		if (dev->dev_close)
  802b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b38:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b3c:	48 85 c0             	test   %rax,%rax
  802b3f:	74 16                	je     802b57 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b45:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802b49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b4d:	48 89 c7             	mov    %rax,%rdi
  802b50:	ff d2                	callq  *%rdx
  802b52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b55:	eb 07                	jmp    802b5e <fd_close+0xac>
		else
			r = 0;
  802b57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802b5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b62:	48 89 c6             	mov    %rax,%rsi
  802b65:	bf 00 00 00 00       	mov    $0x0,%edi
  802b6a:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  802b71:	00 00 00 
  802b74:	ff d0                	callq  *%rax
	return r;
  802b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b79:	c9                   	leaveq 
  802b7a:	c3                   	retq   

0000000000802b7b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802b7b:	55                   	push   %rbp
  802b7c:	48 89 e5             	mov    %rsp,%rbp
  802b7f:	48 83 ec 20          	sub    $0x20,%rsp
  802b83:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802b8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b91:	eb 41                	jmp    802bd4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802b93:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802b9a:	00 00 00 
  802b9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ba0:	48 63 d2             	movslq %edx,%rdx
  802ba3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ba7:	8b 00                	mov    (%rax),%eax
  802ba9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802bac:	75 22                	jne    802bd0 <dev_lookup+0x55>
			*dev = devtab[i];
  802bae:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802bb5:	00 00 00 
  802bb8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802bbb:	48 63 d2             	movslq %edx,%rdx
  802bbe:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802bc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bce:	eb 60                	jmp    802c30 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802bd0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802bd4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802bdb:	00 00 00 
  802bde:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802be1:	48 63 d2             	movslq %edx,%rdx
  802be4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802be8:	48 85 c0             	test   %rax,%rax
  802beb:	75 a6                	jne    802b93 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802bed:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802bf4:	00 00 00 
  802bf7:	48 8b 00             	mov    (%rax),%rax
  802bfa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c00:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c03:	89 c6                	mov    %eax,%esi
  802c05:	48 bf 90 50 80 00 00 	movabs $0x805090,%rdi
  802c0c:	00 00 00 
  802c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c14:	48 b9 ff 0e 80 00 00 	movabs $0x800eff,%rcx
  802c1b:	00 00 00 
  802c1e:	ff d1                	callq  *%rcx
	*dev = 0;
  802c20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c24:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802c2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802c30:	c9                   	leaveq 
  802c31:	c3                   	retq   

0000000000802c32 <close>:

int
close(int fdnum)
{
  802c32:	55                   	push   %rbp
  802c33:	48 89 e5             	mov    %rsp,%rbp
  802c36:	48 83 ec 20          	sub    $0x20,%rsp
  802c3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c3d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c44:	48 89 d6             	mov    %rdx,%rsi
  802c47:	89 c7                	mov    %eax,%edi
  802c49:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  802c50:	00 00 00 
  802c53:	ff d0                	callq  *%rax
  802c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5c:	79 05                	jns    802c63 <close+0x31>
		return r;
  802c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c61:	eb 18                	jmp    802c7b <close+0x49>
	else
		return fd_close(fd, 1);
  802c63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c67:	be 01 00 00 00       	mov    $0x1,%esi
  802c6c:	48 89 c7             	mov    %rax,%rdi
  802c6f:	48 b8 b2 2a 80 00 00 	movabs $0x802ab2,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
}
  802c7b:	c9                   	leaveq 
  802c7c:	c3                   	retq   

0000000000802c7d <close_all>:

void
close_all(void)
{
  802c7d:	55                   	push   %rbp
  802c7e:	48 89 e5             	mov    %rsp,%rbp
  802c81:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c8c:	eb 15                	jmp    802ca3 <close_all+0x26>
		close(i);
  802c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c91:	89 c7                	mov    %eax,%edi
  802c93:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802c9f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ca3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802ca7:	7e e5                	jle    802c8e <close_all+0x11>
		close(i);
}
  802ca9:	c9                   	leaveq 
  802caa:	c3                   	retq   

0000000000802cab <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802cab:	55                   	push   %rbp
  802cac:	48 89 e5             	mov    %rsp,%rbp
  802caf:	48 83 ec 40          	sub    $0x40,%rsp
  802cb3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802cb6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802cb9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802cbd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802cc0:	48 89 d6             	mov    %rdx,%rsi
  802cc3:	89 c7                	mov    %eax,%edi
  802cc5:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	callq  *%rax
  802cd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd8:	79 08                	jns    802ce2 <dup+0x37>
		return r;
  802cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdd:	e9 70 01 00 00       	jmpq   802e52 <dup+0x1a7>
	close(newfdnum);
  802ce2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ce5:	89 c7                	mov    %eax,%edi
  802ce7:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  802cee:	00 00 00 
  802cf1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802cf3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802cf6:	48 98                	cltq   
  802cf8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802cfe:	48 c1 e0 0c          	shl    $0xc,%rax
  802d02:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802d06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d0a:	48 89 c7             	mov    %rax,%rdi
  802d0d:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
  802d19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d21:	48 89 c7             	mov    %rax,%rdi
  802d24:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax
  802d30:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d38:	48 89 c2             	mov    %rax,%rdx
  802d3b:	48 c1 ea 15          	shr    $0x15,%rdx
  802d3f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802d46:	01 00 00 
  802d49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d4d:	83 e0 01             	and    $0x1,%eax
  802d50:	84 c0                	test   %al,%al
  802d52:	74 71                	je     802dc5 <dup+0x11a>
  802d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d58:	48 89 c2             	mov    %rax,%rdx
  802d5b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802d5f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d66:	01 00 00 
  802d69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d6d:	83 e0 01             	and    $0x1,%eax
  802d70:	84 c0                	test   %al,%al
  802d72:	74 51                	je     802dc5 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802d74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d78:	48 89 c2             	mov    %rax,%rdx
  802d7b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802d7f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d86:	01 00 00 
  802d89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d8d:	89 c1                	mov    %eax,%ecx
  802d8f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802d95:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9d:	41 89 c8             	mov    %ecx,%r8d
  802da0:	48 89 d1             	mov    %rdx,%rcx
  802da3:	ba 00 00 00 00       	mov    $0x0,%edx
  802da8:	48 89 c6             	mov    %rax,%rsi
  802dab:	bf 00 00 00 00       	mov    $0x0,%edi
  802db0:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  802db7:	00 00 00 
  802dba:	ff d0                	callq  *%rax
  802dbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc3:	78 56                	js     802e1b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802dc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dc9:	48 89 c2             	mov    %rax,%rdx
  802dcc:	48 c1 ea 0c          	shr    $0xc,%rdx
  802dd0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dd7:	01 00 00 
  802dda:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dde:	89 c1                	mov    %eax,%ecx
  802de0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802de6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dee:	41 89 c8             	mov    %ecx,%r8d
  802df1:	48 89 d1             	mov    %rdx,%rcx
  802df4:	ba 00 00 00 00       	mov    $0x0,%edx
  802df9:	48 89 c6             	mov    %rax,%rsi
  802dfc:	bf 00 00 00 00       	mov    $0x0,%edi
  802e01:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  802e08:	00 00 00 
  802e0b:	ff d0                	callq  *%rax
  802e0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e14:	78 08                	js     802e1e <dup+0x173>
		goto err;

	return newfdnum;
  802e16:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e19:	eb 37                	jmp    802e52 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802e1b:	90                   	nop
  802e1c:	eb 01                	jmp    802e1f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802e1e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e23:	48 89 c6             	mov    %rax,%rsi
  802e26:	bf 00 00 00 00       	mov    $0x0,%edi
  802e2b:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802e37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e3b:	48 89 c6             	mov    %rax,%rsi
  802e3e:	bf 00 00 00 00       	mov    $0x0,%edi
  802e43:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  802e4a:	00 00 00 
  802e4d:	ff d0                	callq  *%rax
	return r;
  802e4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e52:	c9                   	leaveq 
  802e53:	c3                   	retq   

0000000000802e54 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802e54:	55                   	push   %rbp
  802e55:	48 89 e5             	mov    %rsp,%rbp
  802e58:	48 83 ec 40          	sub    $0x40,%rsp
  802e5c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e5f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e63:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e67:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e6b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e6e:	48 89 d6             	mov    %rdx,%rsi
  802e71:	89 c7                	mov    %eax,%edi
  802e73:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
  802e7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e86:	78 24                	js     802eac <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8c:	8b 00                	mov    (%rax),%eax
  802e8e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e92:	48 89 d6             	mov    %rdx,%rsi
  802e95:	89 c7                	mov    %eax,%edi
  802e97:	48 b8 7b 2b 80 00 00 	movabs $0x802b7b,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
  802ea3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eaa:	79 05                	jns    802eb1 <read+0x5d>
		return r;
  802eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaf:	eb 7a                	jmp    802f2b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb5:	8b 40 08             	mov    0x8(%rax),%eax
  802eb8:	83 e0 03             	and    $0x3,%eax
  802ebb:	83 f8 01             	cmp    $0x1,%eax
  802ebe:	75 3a                	jne    802efa <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802ec0:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802ec7:	00 00 00 
  802eca:	48 8b 00             	mov    (%rax),%rax
  802ecd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ed3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ed6:	89 c6                	mov    %eax,%esi
  802ed8:	48 bf af 50 80 00 00 	movabs $0x8050af,%rdi
  802edf:	00 00 00 
  802ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee7:	48 b9 ff 0e 80 00 00 	movabs $0x800eff,%rcx
  802eee:	00 00 00 
  802ef1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ef3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef8:	eb 31                	jmp    802f2b <read+0xd7>
	}
	if (!dev->dev_read)
  802efa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efe:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f02:	48 85 c0             	test   %rax,%rax
  802f05:	75 07                	jne    802f0e <read+0xba>
		return -E_NOT_SUPP;
  802f07:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f0c:	eb 1d                	jmp    802f2b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f12:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802f16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f1e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f22:	48 89 ce             	mov    %rcx,%rsi
  802f25:	48 89 c7             	mov    %rax,%rdi
  802f28:	41 ff d0             	callq  *%r8
}
  802f2b:	c9                   	leaveq 
  802f2c:	c3                   	retq   

0000000000802f2d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802f2d:	55                   	push   %rbp
  802f2e:	48 89 e5             	mov    %rsp,%rbp
  802f31:	48 83 ec 30          	sub    $0x30,%rsp
  802f35:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f3c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f47:	eb 46                	jmp    802f8f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4c:	48 98                	cltq   
  802f4e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f52:	48 29 c2             	sub    %rax,%rdx
  802f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f58:	48 98                	cltq   
  802f5a:	48 89 c1             	mov    %rax,%rcx
  802f5d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802f61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f64:	48 89 ce             	mov    %rcx,%rsi
  802f67:	89 c7                	mov    %eax,%edi
  802f69:	48 b8 54 2e 80 00 00 	movabs $0x802e54,%rax
  802f70:	00 00 00 
  802f73:	ff d0                	callq  *%rax
  802f75:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802f78:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f7c:	79 05                	jns    802f83 <readn+0x56>
			return m;
  802f7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f81:	eb 1d                	jmp    802fa0 <readn+0x73>
		if (m == 0)
  802f83:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f87:	74 13                	je     802f9c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f8c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f92:	48 98                	cltq   
  802f94:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f98:	72 af                	jb     802f49 <readn+0x1c>
  802f9a:	eb 01                	jmp    802f9d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802f9c:	90                   	nop
	}
	return tot;
  802f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fa0:	c9                   	leaveq 
  802fa1:	c3                   	retq   

0000000000802fa2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802fa2:	55                   	push   %rbp
  802fa3:	48 89 e5             	mov    %rsp,%rbp
  802fa6:	48 83 ec 40          	sub    $0x40,%rsp
  802faa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fb1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fb5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fb9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fbc:	48 89 d6             	mov    %rdx,%rsi
  802fbf:	89 c7                	mov    %eax,%edi
  802fc1:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
  802fcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd4:	78 24                	js     802ffa <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fda:	8b 00                	mov    (%rax),%eax
  802fdc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fe0:	48 89 d6             	mov    %rdx,%rsi
  802fe3:	89 c7                	mov    %eax,%edi
  802fe5:	48 b8 7b 2b 80 00 00 	movabs $0x802b7b,%rax
  802fec:	00 00 00 
  802fef:	ff d0                	callq  *%rax
  802ff1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff8:	79 05                	jns    802fff <write+0x5d>
		return r;
  802ffa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffd:	eb 79                	jmp    803078 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803003:	8b 40 08             	mov    0x8(%rax),%eax
  803006:	83 e0 03             	and    $0x3,%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	75 3a                	jne    803047 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80300d:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  803014:	00 00 00 
  803017:	48 8b 00             	mov    (%rax),%rax
  80301a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803020:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803023:	89 c6                	mov    %eax,%esi
  803025:	48 bf cb 50 80 00 00 	movabs $0x8050cb,%rdi
  80302c:	00 00 00 
  80302f:	b8 00 00 00 00       	mov    $0x0,%eax
  803034:	48 b9 ff 0e 80 00 00 	movabs $0x800eff,%rcx
  80303b:	00 00 00 
  80303e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803040:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803045:	eb 31                	jmp    803078 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803047:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80304f:	48 85 c0             	test   %rax,%rax
  803052:	75 07                	jne    80305b <write+0xb9>
		return -E_NOT_SUPP;
  803054:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803059:	eb 1d                	jmp    803078 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80305b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  803063:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803067:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80306b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80306f:	48 89 ce             	mov    %rcx,%rsi
  803072:	48 89 c7             	mov    %rax,%rdi
  803075:	41 ff d0             	callq  *%r8
}
  803078:	c9                   	leaveq 
  803079:	c3                   	retq   

000000000080307a <seek>:

int
seek(int fdnum, off_t offset)
{
  80307a:	55                   	push   %rbp
  80307b:	48 89 e5             	mov    %rsp,%rbp
  80307e:	48 83 ec 18          	sub    $0x18,%rsp
  803082:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803085:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803088:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80308c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80308f:	48 89 d6             	mov    %rdx,%rsi
  803092:	89 c7                	mov    %eax,%edi
  803094:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  80309b:	00 00 00 
  80309e:	ff d0                	callq  *%rax
  8030a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a7:	79 05                	jns    8030ae <seek+0x34>
		return r;
  8030a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ac:	eb 0f                	jmp    8030bd <seek+0x43>
	fd->fd_offset = offset;
  8030ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030b5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8030b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030bd:	c9                   	leaveq 
  8030be:	c3                   	retq   

00000000008030bf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8030bf:	55                   	push   %rbp
  8030c0:	48 89 e5             	mov    %rsp,%rbp
  8030c3:	48 83 ec 30          	sub    $0x30,%rsp
  8030c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030ca:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030d4:	48 89 d6             	mov    %rdx,%rsi
  8030d7:	89 c7                	mov    %eax,%edi
  8030d9:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  8030e0:	00 00 00 
  8030e3:	ff d0                	callq  *%rax
  8030e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ec:	78 24                	js     803112 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f2:	8b 00                	mov    (%rax),%eax
  8030f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030f8:	48 89 d6             	mov    %rdx,%rsi
  8030fb:	89 c7                	mov    %eax,%edi
  8030fd:	48 b8 7b 2b 80 00 00 	movabs $0x802b7b,%rax
  803104:	00 00 00 
  803107:	ff d0                	callq  *%rax
  803109:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803110:	79 05                	jns    803117 <ftruncate+0x58>
		return r;
  803112:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803115:	eb 72                	jmp    803189 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803117:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311b:	8b 40 08             	mov    0x8(%rax),%eax
  80311e:	83 e0 03             	and    $0x3,%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	75 3a                	jne    80315f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803125:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  80312c:	00 00 00 
  80312f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803132:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803138:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80313b:	89 c6                	mov    %eax,%esi
  80313d:	48 bf e8 50 80 00 00 	movabs $0x8050e8,%rdi
  803144:	00 00 00 
  803147:	b8 00 00 00 00       	mov    $0x0,%eax
  80314c:	48 b9 ff 0e 80 00 00 	movabs $0x800eff,%rcx
  803153:	00 00 00 
  803156:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803158:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80315d:	eb 2a                	jmp    803189 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80315f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803163:	48 8b 40 30          	mov    0x30(%rax),%rax
  803167:	48 85 c0             	test   %rax,%rax
  80316a:	75 07                	jne    803173 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80316c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803171:	eb 16                	jmp    803189 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803173:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803177:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80317b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80317f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803182:	89 d6                	mov    %edx,%esi
  803184:	48 89 c7             	mov    %rax,%rdi
  803187:	ff d1                	callq  *%rcx
}
  803189:	c9                   	leaveq 
  80318a:	c3                   	retq   

000000000080318b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80318b:	55                   	push   %rbp
  80318c:	48 89 e5             	mov    %rsp,%rbp
  80318f:	48 83 ec 30          	sub    $0x30,%rsp
  803193:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803196:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80319a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80319e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031a1:	48 89 d6             	mov    %rdx,%rsi
  8031a4:	89 c7                	mov    %eax,%edi
  8031a6:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  8031ad:	00 00 00 
  8031b0:	ff d0                	callq  *%rax
  8031b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b9:	78 24                	js     8031df <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031bf:	8b 00                	mov    (%rax),%eax
  8031c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031c5:	48 89 d6             	mov    %rdx,%rsi
  8031c8:	89 c7                	mov    %eax,%edi
  8031ca:	48 b8 7b 2b 80 00 00 	movabs $0x802b7b,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
  8031d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031dd:	79 05                	jns    8031e4 <fstat+0x59>
		return r;
  8031df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e2:	eb 5e                	jmp    803242 <fstat+0xb7>
	if (!dev->dev_stat)
  8031e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8031ec:	48 85 c0             	test   %rax,%rax
  8031ef:	75 07                	jne    8031f8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8031f1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031f6:	eb 4a                	jmp    803242 <fstat+0xb7>
	stat->st_name[0] = 0;
  8031f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031fc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8031ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803203:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80320a:	00 00 00 
	stat->st_isdir = 0;
  80320d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803211:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803218:	00 00 00 
	stat->st_dev = dev;
  80321b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80321f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803223:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80322a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  803232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803236:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80323a:	48 89 d6             	mov    %rdx,%rsi
  80323d:	48 89 c7             	mov    %rax,%rdi
  803240:	ff d1                	callq  *%rcx
}
  803242:	c9                   	leaveq 
  803243:	c3                   	retq   

0000000000803244 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803244:	55                   	push   %rbp
  803245:	48 89 e5             	mov    %rsp,%rbp
  803248:	48 83 ec 20          	sub    $0x20,%rsp
  80324c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803250:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803258:	be 00 00 00 00       	mov    $0x0,%esi
  80325d:	48 89 c7             	mov    %rax,%rdi
  803260:	48 b8 33 33 80 00 00 	movabs $0x803333,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
  80326c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803273:	79 05                	jns    80327a <stat+0x36>
		return fd;
  803275:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803278:	eb 2f                	jmp    8032a9 <stat+0x65>
	r = fstat(fd, stat);
  80327a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80327e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803281:	48 89 d6             	mov    %rdx,%rsi
  803284:	89 c7                	mov    %eax,%edi
  803286:	48 b8 8b 31 80 00 00 	movabs $0x80318b,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
  803292:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803295:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803298:	89 c7                	mov    %eax,%edi
  80329a:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
	return r;
  8032a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8032a9:	c9                   	leaveq 
  8032aa:	c3                   	retq   
	...

00000000008032ac <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8032ac:	55                   	push   %rbp
  8032ad:	48 89 e5             	mov    %rsp,%rbp
  8032b0:	48 83 ec 10          	sub    $0x10,%rsp
  8032b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8032bb:	48 b8 24 80 80 00 00 	movabs $0x808024,%rax
  8032c2:	00 00 00 
  8032c5:	8b 00                	mov    (%rax),%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	75 1d                	jne    8032e8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8032cb:	bf 01 00 00 00       	mov    $0x1,%edi
  8032d0:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
  8032dc:	48 ba 24 80 80 00 00 	movabs $0x808024,%rdx
  8032e3:	00 00 00 
  8032e6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8032e8:	48 b8 24 80 80 00 00 	movabs $0x808024,%rax
  8032ef:	00 00 00 
  8032f2:	8b 00                	mov    (%rax),%eax
  8032f4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032f7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032fc:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803303:	00 00 00 
  803306:	89 c7                	mov    %eax,%edi
  803308:	48 b8 f4 27 80 00 00 	movabs $0x8027f4,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803318:	ba 00 00 00 00       	mov    $0x0,%edx
  80331d:	48 89 c6             	mov    %rax,%rsi
  803320:	bf 00 00 00 00       	mov    $0x0,%edi
  803325:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	callq  *%rax
}
  803331:	c9                   	leaveq 
  803332:	c3                   	retq   

0000000000803333 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803333:	55                   	push   %rbp
  803334:	48 89 e5             	mov    %rsp,%rbp
  803337:	48 83 ec 20          	sub    $0x20,%rsp
  80333b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80333f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  803342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803346:	48 89 c7             	mov    %rax,%rdi
  803349:	48 b8 50 1a 80 00 00 	movabs $0x801a50,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80335a:	7e 0a                	jle    803366 <open+0x33>
                return -E_BAD_PATH;
  80335c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803361:	e9 a5 00 00 00       	jmpq   80340b <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  803366:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80336a:	48 89 c7             	mov    %rax,%rdi
  80336d:	48 b8 8a 29 80 00 00 	movabs $0x80298a,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
  803379:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803380:	79 08                	jns    80338a <open+0x57>
		return r;
  803382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803385:	e9 81 00 00 00       	jmpq   80340b <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80338a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80338e:	48 89 c6             	mov    %rax,%rsi
  803391:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803398:	00 00 00 
  80339b:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  8033a2:	00 00 00 
  8033a5:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8033a7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033ae:	00 00 00 
  8033b1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8033b4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8033ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033be:	48 89 c6             	mov    %rax,%rsi
  8033c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8033c6:	48 b8 ac 32 80 00 00 	movabs $0x8032ac,%rax
  8033cd:	00 00 00 
  8033d0:	ff d0                	callq  *%rax
  8033d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8033d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d9:	79 1d                	jns    8033f8 <open+0xc5>
	{
		fd_close(fd,0);
  8033db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033df:	be 00 00 00 00       	mov    $0x0,%esi
  8033e4:	48 89 c7             	mov    %rax,%rdi
  8033e7:	48 b8 b2 2a 80 00 00 	movabs $0x802ab2,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
		return r;
  8033f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f6:	eb 13                	jmp    80340b <open+0xd8>
	}
	return fd2num(fd);
  8033f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033fc:	48 89 c7             	mov    %rax,%rdi
  8033ff:	48 b8 3c 29 80 00 00 	movabs $0x80293c,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
	


}
  80340b:	c9                   	leaveq 
  80340c:	c3                   	retq   

000000000080340d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80340d:	55                   	push   %rbp
  80340e:	48 89 e5             	mov    %rsp,%rbp
  803411:	48 83 ec 10          	sub    $0x10,%rsp
  803415:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80341d:	8b 50 0c             	mov    0xc(%rax),%edx
  803420:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803427:	00 00 00 
  80342a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80342c:	be 00 00 00 00       	mov    $0x0,%esi
  803431:	bf 06 00 00 00       	mov    $0x6,%edi
  803436:	48 b8 ac 32 80 00 00 	movabs $0x8032ac,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
}
  803442:	c9                   	leaveq 
  803443:	c3                   	retq   

0000000000803444 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803444:	55                   	push   %rbp
  803445:	48 89 e5             	mov    %rsp,%rbp
  803448:	48 83 ec 30          	sub    $0x30,%rsp
  80344c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803450:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803454:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80345c:	8b 50 0c             	mov    0xc(%rax),%edx
  80345f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803466:	00 00 00 
  803469:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80346b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803472:	00 00 00 
  803475:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803479:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80347d:	be 00 00 00 00       	mov    $0x0,%esi
  803482:	bf 03 00 00 00       	mov    $0x3,%edi
  803487:	48 b8 ac 32 80 00 00 	movabs $0x8032ac,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
  803493:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803496:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80349a:	79 05                	jns    8034a1 <devfile_read+0x5d>
	{
		return r;
  80349c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349f:	eb 2c                	jmp    8034cd <devfile_read+0x89>
	}
	if(r > 0)
  8034a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a5:	7e 23                	jle    8034ca <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8034a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034aa:	48 63 d0             	movslq %eax,%rdx
  8034ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b1:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8034b8:	00 00 00 
  8034bb:	48 89 c7             	mov    %rax,%rdi
  8034be:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
	return r;
  8034ca:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8034cd:	c9                   	leaveq 
  8034ce:	c3                   	retq   

00000000008034cf <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8034cf:	55                   	push   %rbp
  8034d0:	48 89 e5             	mov    %rsp,%rbp
  8034d3:	48 83 ec 30          	sub    $0x30,%rsp
  8034d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8034e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e7:	8b 50 0c             	mov    0xc(%rax),%edx
  8034ea:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034f1:	00 00 00 
  8034f4:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8034f6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8034fd:	00 
  8034fe:	76 08                	jbe    803508 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  803500:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803507:	00 
	fsipcbuf.write.req_n=n;
  803508:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80350f:	00 00 00 
  803512:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803516:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80351a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80351e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803522:	48 89 c6             	mov    %rax,%rsi
  803525:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80352c:	00 00 00 
  80352f:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803536:	00 00 00 
  803539:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80353b:	be 00 00 00 00       	mov    $0x0,%esi
  803540:	bf 04 00 00 00       	mov    $0x4,%edi
  803545:	48 b8 ac 32 80 00 00 	movabs $0x8032ac,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
  803551:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  803554:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803557:	c9                   	leaveq 
  803558:	c3                   	retq   

0000000000803559 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803559:	55                   	push   %rbp
  80355a:	48 89 e5             	mov    %rsp,%rbp
  80355d:	48 83 ec 10          	sub    $0x10,%rsp
  803561:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803565:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356c:	8b 50 0c             	mov    0xc(%rax),%edx
  80356f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803576:	00 00 00 
  803579:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80357b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803582:	00 00 00 
  803585:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803588:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80358b:	be 00 00 00 00       	mov    $0x0,%esi
  803590:	bf 02 00 00 00       	mov    $0x2,%edi
  803595:	48 b8 ac 32 80 00 00 	movabs $0x8032ac,%rax
  80359c:	00 00 00 
  80359f:	ff d0                	callq  *%rax
}
  8035a1:	c9                   	leaveq 
  8035a2:	c3                   	retq   

00000000008035a3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8035a3:	55                   	push   %rbp
  8035a4:	48 89 e5             	mov    %rsp,%rbp
  8035a7:	48 83 ec 20          	sub    $0x20,%rsp
  8035ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8035b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8035ba:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035c1:	00 00 00 
  8035c4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8035c6:	be 00 00 00 00       	mov    $0x0,%esi
  8035cb:	bf 05 00 00 00       	mov    $0x5,%edi
  8035d0:	48 b8 ac 32 80 00 00 	movabs $0x8032ac,%rax
  8035d7:	00 00 00 
  8035da:	ff d0                	callq  *%rax
  8035dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e3:	79 05                	jns    8035ea <devfile_stat+0x47>
		return r;
  8035e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e8:	eb 56                	jmp    803640 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8035ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ee:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8035f5:	00 00 00 
  8035f8:	48 89 c7             	mov    %rax,%rdi
  8035fb:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803602:	00 00 00 
  803605:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803607:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80360e:	00 00 00 
  803611:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803617:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80361b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803621:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803628:	00 00 00 
  80362b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803631:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803635:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80363b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803640:	c9                   	leaveq 
  803641:	c3                   	retq   
	...

0000000000803644 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803644:	55                   	push   %rbp
  803645:	48 89 e5             	mov    %rsp,%rbp
  803648:	48 83 ec 20          	sub    $0x20,%rsp
  80364c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80364f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803653:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803656:	48 89 d6             	mov    %rdx,%rsi
  803659:	89 c7                	mov    %eax,%edi
  80365b:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  803662:	00 00 00 
  803665:	ff d0                	callq  *%rax
  803667:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80366a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366e:	79 05                	jns    803675 <fd2sockid+0x31>
		return r;
  803670:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803673:	eb 24                	jmp    803699 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803679:	8b 10                	mov    (%rax),%edx
  80367b:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803682:	00 00 00 
  803685:	8b 00                	mov    (%rax),%eax
  803687:	39 c2                	cmp    %eax,%edx
  803689:	74 07                	je     803692 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80368b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803690:	eb 07                	jmp    803699 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803696:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803699:	c9                   	leaveq 
  80369a:	c3                   	retq   

000000000080369b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80369b:	55                   	push   %rbp
  80369c:	48 89 e5             	mov    %rsp,%rbp
  80369f:	48 83 ec 20          	sub    $0x20,%rsp
  8036a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8036a6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036aa:	48 89 c7             	mov    %rax,%rdi
  8036ad:	48 b8 8a 29 80 00 00 	movabs $0x80298a,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	callq  *%rax
  8036b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c0:	78 26                	js     8036e8 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8036c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c6:	ba 07 04 00 00       	mov    $0x407,%edx
  8036cb:	48 89 c6             	mov    %rax,%rsi
  8036ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d3:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
  8036df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e6:	79 16                	jns    8036fe <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8036e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036eb:	89 c7                	mov    %eax,%edi
  8036ed:	48 b8 a8 3b 80 00 00 	movabs $0x803ba8,%rax
  8036f4:	00 00 00 
  8036f7:	ff d0                	callq  *%rax
		return r;
  8036f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fc:	eb 3a                	jmp    803738 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803702:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803709:	00 00 00 
  80370c:	8b 12                	mov    (%rdx),%edx
  80370e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803714:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80371b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803722:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803725:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803729:	48 89 c7             	mov    %rax,%rdi
  80372c:	48 b8 3c 29 80 00 00 	movabs $0x80293c,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
}
  803738:	c9                   	leaveq 
  803739:	c3                   	retq   

000000000080373a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80373a:	55                   	push   %rbp
  80373b:	48 89 e5             	mov    %rsp,%rbp
  80373e:	48 83 ec 30          	sub    $0x30,%rsp
  803742:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803745:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803749:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80374d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803750:	89 c7                	mov    %eax,%edi
  803752:	48 b8 44 36 80 00 00 	movabs $0x803644,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
  80375e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803765:	79 05                	jns    80376c <accept+0x32>
		return r;
  803767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376a:	eb 3b                	jmp    8037a7 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80376c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803770:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803774:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803777:	48 89 ce             	mov    %rcx,%rsi
  80377a:	89 c7                	mov    %eax,%edi
  80377c:	48 b8 85 3a 80 00 00 	movabs $0x803a85,%rax
  803783:	00 00 00 
  803786:	ff d0                	callq  *%rax
  803788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80378b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378f:	79 05                	jns    803796 <accept+0x5c>
		return r;
  803791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803794:	eb 11                	jmp    8037a7 <accept+0x6d>
	return alloc_sockfd(r);
  803796:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803799:	89 c7                	mov    %eax,%edi
  80379b:	48 b8 9b 36 80 00 00 	movabs $0x80369b,%rax
  8037a2:	00 00 00 
  8037a5:	ff d0                	callq  *%rax
}
  8037a7:	c9                   	leaveq 
  8037a8:	c3                   	retq   

00000000008037a9 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037a9:	55                   	push   %rbp
  8037aa:	48 89 e5             	mov    %rsp,%rbp
  8037ad:	48 83 ec 20          	sub    $0x20,%rsp
  8037b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037b8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037be:	89 c7                	mov    %eax,%edi
  8037c0:	48 b8 44 36 80 00 00 	movabs $0x803644,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
  8037cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037d3:	79 05                	jns    8037da <bind+0x31>
		return r;
  8037d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d8:	eb 1b                	jmp    8037f5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8037da:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037dd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e4:	48 89 ce             	mov    %rcx,%rsi
  8037e7:	89 c7                	mov    %eax,%edi
  8037e9:	48 b8 04 3b 80 00 00 	movabs $0x803b04,%rax
  8037f0:	00 00 00 
  8037f3:	ff d0                	callq  *%rax
}
  8037f5:	c9                   	leaveq 
  8037f6:	c3                   	retq   

00000000008037f7 <shutdown>:

int
shutdown(int s, int how)
{
  8037f7:	55                   	push   %rbp
  8037f8:	48 89 e5             	mov    %rsp,%rbp
  8037fb:	48 83 ec 20          	sub    $0x20,%rsp
  8037ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803802:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803805:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803808:	89 c7                	mov    %eax,%edi
  80380a:	48 b8 44 36 80 00 00 	movabs $0x803644,%rax
  803811:	00 00 00 
  803814:	ff d0                	callq  *%rax
  803816:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803819:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381d:	79 05                	jns    803824 <shutdown+0x2d>
		return r;
  80381f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803822:	eb 16                	jmp    80383a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803824:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803827:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382a:	89 d6                	mov    %edx,%esi
  80382c:	89 c7                	mov    %eax,%edi
  80382e:	48 b8 68 3b 80 00 00 	movabs $0x803b68,%rax
  803835:	00 00 00 
  803838:	ff d0                	callq  *%rax
}
  80383a:	c9                   	leaveq 
  80383b:	c3                   	retq   

000000000080383c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80383c:	55                   	push   %rbp
  80383d:	48 89 e5             	mov    %rsp,%rbp
  803840:	48 83 ec 10          	sub    $0x10,%rsp
  803844:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384c:	48 89 c7             	mov    %rax,%rdi
  80384f:	48 b8 cc 46 80 00 00 	movabs $0x8046cc,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
  80385b:	83 f8 01             	cmp    $0x1,%eax
  80385e:	75 17                	jne    803877 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803864:	8b 40 0c             	mov    0xc(%rax),%eax
  803867:	89 c7                	mov    %eax,%edi
  803869:	48 b8 a8 3b 80 00 00 	movabs $0x803ba8,%rax
  803870:	00 00 00 
  803873:	ff d0                	callq  *%rax
  803875:	eb 05                	jmp    80387c <devsock_close+0x40>
	else
		return 0;
  803877:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80387c:	c9                   	leaveq 
  80387d:	c3                   	retq   

000000000080387e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80387e:	55                   	push   %rbp
  80387f:	48 89 e5             	mov    %rsp,%rbp
  803882:	48 83 ec 20          	sub    $0x20,%rsp
  803886:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803889:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80388d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803890:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803893:	89 c7                	mov    %eax,%edi
  803895:	48 b8 44 36 80 00 00 	movabs $0x803644,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
  8038a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038a8:	79 05                	jns    8038af <connect+0x31>
		return r;
  8038aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ad:	eb 1b                	jmp    8038ca <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8038af:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b9:	48 89 ce             	mov    %rcx,%rsi
  8038bc:	89 c7                	mov    %eax,%edi
  8038be:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  8038c5:	00 00 00 
  8038c8:	ff d0                	callq  *%rax
}
  8038ca:	c9                   	leaveq 
  8038cb:	c3                   	retq   

00000000008038cc <listen>:

int
listen(int s, int backlog)
{
  8038cc:	55                   	push   %rbp
  8038cd:	48 89 e5             	mov    %rsp,%rbp
  8038d0:	48 83 ec 20          	sub    $0x20,%rsp
  8038d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038dd:	89 c7                	mov    %eax,%edi
  8038df:	48 b8 44 36 80 00 00 	movabs $0x803644,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
  8038eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f2:	79 05                	jns    8038f9 <listen+0x2d>
		return r;
  8038f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f7:	eb 16                	jmp    80390f <listen+0x43>
	return nsipc_listen(r, backlog);
  8038f9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ff:	89 d6                	mov    %edx,%esi
  803901:	89 c7                	mov    %eax,%edi
  803903:	48 b8 39 3c 80 00 00 	movabs $0x803c39,%rax
  80390a:	00 00 00 
  80390d:	ff d0                	callq  *%rax
}
  80390f:	c9                   	leaveq 
  803910:	c3                   	retq   

0000000000803911 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803911:	55                   	push   %rbp
  803912:	48 89 e5             	mov    %rsp,%rbp
  803915:	48 83 ec 20          	sub    $0x20,%rsp
  803919:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80391d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803921:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803929:	89 c2                	mov    %eax,%edx
  80392b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392f:	8b 40 0c             	mov    0xc(%rax),%eax
  803932:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803936:	b9 00 00 00 00       	mov    $0x0,%ecx
  80393b:	89 c7                	mov    %eax,%edi
  80393d:	48 b8 79 3c 80 00 00 	movabs $0x803c79,%rax
  803944:	00 00 00 
  803947:	ff d0                	callq  *%rax
}
  803949:	c9                   	leaveq 
  80394a:	c3                   	retq   

000000000080394b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80394b:	55                   	push   %rbp
  80394c:	48 89 e5             	mov    %rsp,%rbp
  80394f:	48 83 ec 20          	sub    $0x20,%rsp
  803953:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803957:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80395b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80395f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803963:	89 c2                	mov    %eax,%edx
  803965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803969:	8b 40 0c             	mov    0xc(%rax),%eax
  80396c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803970:	b9 00 00 00 00       	mov    $0x0,%ecx
  803975:	89 c7                	mov    %eax,%edi
  803977:	48 b8 45 3d 80 00 00 	movabs $0x803d45,%rax
  80397e:	00 00 00 
  803981:	ff d0                	callq  *%rax
}
  803983:	c9                   	leaveq 
  803984:	c3                   	retq   

0000000000803985 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803985:	55                   	push   %rbp
  803986:	48 89 e5             	mov    %rsp,%rbp
  803989:	48 83 ec 10          	sub    $0x10,%rsp
  80398d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803991:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803995:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803999:	48 be 13 51 80 00 00 	movabs $0x805113,%rsi
  8039a0:	00 00 00 
  8039a3:	48 89 c7             	mov    %rax,%rdi
  8039a6:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  8039ad:	00 00 00 
  8039b0:	ff d0                	callq  *%rax
	return 0;
  8039b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039b7:	c9                   	leaveq 
  8039b8:	c3                   	retq   

00000000008039b9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8039b9:	55                   	push   %rbp
  8039ba:	48 89 e5             	mov    %rsp,%rbp
  8039bd:	48 83 ec 20          	sub    $0x20,%rsp
  8039c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039c4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8039c7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8039ca:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8039cd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039d3:	89 ce                	mov    %ecx,%esi
  8039d5:	89 c7                	mov    %eax,%edi
  8039d7:	48 b8 fd 3d 80 00 00 	movabs $0x803dfd,%rax
  8039de:	00 00 00 
  8039e1:	ff d0                	callq  *%rax
  8039e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ea:	79 05                	jns    8039f1 <socket+0x38>
		return r;
  8039ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ef:	eb 11                	jmp    803a02 <socket+0x49>
	return alloc_sockfd(r);
  8039f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f4:	89 c7                	mov    %eax,%edi
  8039f6:	48 b8 9b 36 80 00 00 	movabs $0x80369b,%rax
  8039fd:	00 00 00 
  803a00:	ff d0                	callq  *%rax
}
  803a02:	c9                   	leaveq 
  803a03:	c3                   	retq   

0000000000803a04 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a04:	55                   	push   %rbp
  803a05:	48 89 e5             	mov    %rsp,%rbp
  803a08:	48 83 ec 10          	sub    $0x10,%rsp
  803a0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803a0f:	48 b8 30 80 80 00 00 	movabs $0x808030,%rax
  803a16:	00 00 00 
  803a19:	8b 00                	mov    (%rax),%eax
  803a1b:	85 c0                	test   %eax,%eax
  803a1d:	75 1d                	jne    803a3c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a1f:	bf 02 00 00 00       	mov    $0x2,%edi
  803a24:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
  803a30:	48 ba 30 80 80 00 00 	movabs $0x808030,%rdx
  803a37:	00 00 00 
  803a3a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a3c:	48 b8 30 80 80 00 00 	movabs $0x808030,%rax
  803a43:	00 00 00 
  803a46:	8b 00                	mov    (%rax),%eax
  803a48:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a4b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a50:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a57:	00 00 00 
  803a5a:	89 c7                	mov    %eax,%edi
  803a5c:	48 b8 f4 27 80 00 00 	movabs $0x8027f4,%rax
  803a63:	00 00 00 
  803a66:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803a68:	ba 00 00 00 00       	mov    $0x0,%edx
  803a6d:	be 00 00 00 00       	mov    $0x0,%esi
  803a72:	bf 00 00 00 00       	mov    $0x0,%edi
  803a77:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	callq  *%rax
}
  803a83:	c9                   	leaveq 
  803a84:	c3                   	retq   

0000000000803a85 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a85:	55                   	push   %rbp
  803a86:	48 89 e5             	mov    %rsp,%rbp
  803a89:	48 83 ec 30          	sub    $0x30,%rsp
  803a8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a94:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a98:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a9f:	00 00 00 
  803aa2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803aa5:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803aa7:	bf 01 00 00 00       	mov    $0x1,%edi
  803aac:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803ab3:	00 00 00 
  803ab6:	ff d0                	callq  *%rax
  803ab8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803abb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abf:	78 3e                	js     803aff <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803ac1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ac8:	00 00 00 
  803acb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803acf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad3:	8b 40 10             	mov    0x10(%rax),%eax
  803ad6:	89 c2                	mov    %eax,%edx
  803ad8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803adc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae0:	48 89 ce             	mov    %rcx,%rsi
  803ae3:	48 89 c7             	mov    %rax,%rdi
  803ae6:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803af2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af6:	8b 50 10             	mov    0x10(%rax),%edx
  803af9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803afd:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803aff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b02:	c9                   	leaveq 
  803b03:	c3                   	retq   

0000000000803b04 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b04:	55                   	push   %rbp
  803b05:	48 89 e5             	mov    %rsp,%rbp
  803b08:	48 83 ec 10          	sub    $0x10,%rsp
  803b0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b13:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803b16:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b1d:	00 00 00 
  803b20:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b23:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b25:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2c:	48 89 c6             	mov    %rax,%rsi
  803b2f:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b36:	00 00 00 
  803b39:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b45:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b4c:	00 00 00 
  803b4f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b52:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b55:	bf 02 00 00 00       	mov    $0x2,%edi
  803b5a:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803b61:	00 00 00 
  803b64:	ff d0                	callq  *%rax
}
  803b66:	c9                   	leaveq 
  803b67:	c3                   	retq   

0000000000803b68 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b68:	55                   	push   %rbp
  803b69:	48 89 e5             	mov    %rsp,%rbp
  803b6c:	48 83 ec 10          	sub    $0x10,%rsp
  803b70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b73:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803b76:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b7d:	00 00 00 
  803b80:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b83:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803b85:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b8c:	00 00 00 
  803b8f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b92:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b95:	bf 03 00 00 00       	mov    $0x3,%edi
  803b9a:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803ba1:	00 00 00 
  803ba4:	ff d0                	callq  *%rax
}
  803ba6:	c9                   	leaveq 
  803ba7:	c3                   	retq   

0000000000803ba8 <nsipc_close>:

int
nsipc_close(int s)
{
  803ba8:	55                   	push   %rbp
  803ba9:	48 89 e5             	mov    %rsp,%rbp
  803bac:	48 83 ec 10          	sub    $0x10,%rsp
  803bb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803bb3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bba:	00 00 00 
  803bbd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bc0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803bc2:	bf 04 00 00 00       	mov    $0x4,%edi
  803bc7:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803bce:	00 00 00 
  803bd1:	ff d0                	callq  *%rax
}
  803bd3:	c9                   	leaveq 
  803bd4:	c3                   	retq   

0000000000803bd5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803bd5:	55                   	push   %rbp
  803bd6:	48 89 e5             	mov    %rsp,%rbp
  803bd9:	48 83 ec 10          	sub    $0x10,%rsp
  803bdd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803be0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803be4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803be7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bee:	00 00 00 
  803bf1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bf4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803bf6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfd:	48 89 c6             	mov    %rax,%rsi
  803c00:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c07:	00 00 00 
  803c0a:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803c11:	00 00 00 
  803c14:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803c16:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c1d:	00 00 00 
  803c20:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c23:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803c26:	bf 05 00 00 00       	mov    $0x5,%edi
  803c2b:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803c32:	00 00 00 
  803c35:	ff d0                	callq  *%rax
}
  803c37:	c9                   	leaveq 
  803c38:	c3                   	retq   

0000000000803c39 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c39:	55                   	push   %rbp
  803c3a:	48 89 e5             	mov    %rsp,%rbp
  803c3d:	48 83 ec 10          	sub    $0x10,%rsp
  803c41:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c44:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c47:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c4e:	00 00 00 
  803c51:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c54:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c56:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c5d:	00 00 00 
  803c60:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c63:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c66:	bf 06 00 00 00       	mov    $0x6,%edi
  803c6b:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
}
  803c77:	c9                   	leaveq 
  803c78:	c3                   	retq   

0000000000803c79 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803c79:	55                   	push   %rbp
  803c7a:	48 89 e5             	mov    %rsp,%rbp
  803c7d:	48 83 ec 30          	sub    $0x30,%rsp
  803c81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c88:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803c8b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c8e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c95:	00 00 00 
  803c98:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c9b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c9d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ca4:	00 00 00 
  803ca7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803caa:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803cad:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cb4:	00 00 00 
  803cb7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803cba:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803cbd:	bf 07 00 00 00       	mov    $0x7,%edi
  803cc2:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
  803cce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd5:	78 69                	js     803d40 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803cd7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803cde:	7f 08                	jg     803ce8 <nsipc_recv+0x6f>
  803ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803ce6:	7e 35                	jle    803d1d <nsipc_recv+0xa4>
  803ce8:	48 b9 1a 51 80 00 00 	movabs $0x80511a,%rcx
  803cef:	00 00 00 
  803cf2:	48 ba 2f 51 80 00 00 	movabs $0x80512f,%rdx
  803cf9:	00 00 00 
  803cfc:	be 61 00 00 00       	mov    $0x61,%esi
  803d01:	48 bf 44 51 80 00 00 	movabs $0x805144,%rdi
  803d08:	00 00 00 
  803d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d10:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  803d17:	00 00 00 
  803d1a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d20:	48 63 d0             	movslq %eax,%rdx
  803d23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d27:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803d2e:	00 00 00 
  803d31:	48 89 c7             	mov    %rax,%rdi
  803d34:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803d3b:	00 00 00 
  803d3e:	ff d0                	callq  *%rax
	}

	return r;
  803d40:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d43:	c9                   	leaveq 
  803d44:	c3                   	retq   

0000000000803d45 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d45:	55                   	push   %rbp
  803d46:	48 89 e5             	mov    %rsp,%rbp
  803d49:	48 83 ec 20          	sub    $0x20,%rsp
  803d4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d54:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d57:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d5a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d61:	00 00 00 
  803d64:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d67:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803d69:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803d70:	7e 35                	jle    803da7 <nsipc_send+0x62>
  803d72:	48 b9 50 51 80 00 00 	movabs $0x805150,%rcx
  803d79:	00 00 00 
  803d7c:	48 ba 2f 51 80 00 00 	movabs $0x80512f,%rdx
  803d83:	00 00 00 
  803d86:	be 6c 00 00 00       	mov    $0x6c,%esi
  803d8b:	48 bf 44 51 80 00 00 	movabs $0x805144,%rdi
  803d92:	00 00 00 
  803d95:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9a:	49 b8 c4 0c 80 00 00 	movabs $0x800cc4,%r8
  803da1:	00 00 00 
  803da4:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803da7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803daa:	48 63 d0             	movslq %eax,%rdx
  803dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db1:	48 89 c6             	mov    %rax,%rsi
  803db4:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803dbb:	00 00 00 
  803dbe:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803dc5:	00 00 00 
  803dc8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803dca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dd1:	00 00 00 
  803dd4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dd7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803dda:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803de1:	00 00 00 
  803de4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803de7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803dea:	bf 08 00 00 00       	mov    $0x8,%edi
  803def:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
}
  803dfb:	c9                   	leaveq 
  803dfc:	c3                   	retq   

0000000000803dfd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803dfd:	55                   	push   %rbp
  803dfe:	48 89 e5             	mov    %rsp,%rbp
  803e01:	48 83 ec 10          	sub    $0x10,%rsp
  803e05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e08:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803e0b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803e0e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e15:	00 00 00 
  803e18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e1b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803e1d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e24:	00 00 00 
  803e27:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e2a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803e2d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e34:	00 00 00 
  803e37:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e3a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e3d:	bf 09 00 00 00       	mov    $0x9,%edi
  803e42:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803e49:	00 00 00 
  803e4c:	ff d0                	callq  *%rax
}
  803e4e:	c9                   	leaveq 
  803e4f:	c3                   	retq   

0000000000803e50 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e50:	55                   	push   %rbp
  803e51:	48 89 e5             	mov    %rsp,%rbp
  803e54:	53                   	push   %rbx
  803e55:	48 83 ec 38          	sub    $0x38,%rsp
  803e59:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e5d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e61:	48 89 c7             	mov    %rax,%rdi
  803e64:	48 b8 8a 29 80 00 00 	movabs $0x80298a,%rax
  803e6b:	00 00 00 
  803e6e:	ff d0                	callq  *%rax
  803e70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e73:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e77:	0f 88 bf 01 00 00    	js     80403c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e81:	ba 07 04 00 00       	mov    $0x407,%edx
  803e86:	48 89 c6             	mov    %rax,%rsi
  803e89:	bf 00 00 00 00       	mov    $0x0,%edi
  803e8e:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  803e95:	00 00 00 
  803e98:	ff d0                	callq  *%rax
  803e9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ea1:	0f 88 95 01 00 00    	js     80403c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803ea7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803eab:	48 89 c7             	mov    %rax,%rdi
  803eae:	48 b8 8a 29 80 00 00 	movabs $0x80298a,%rax
  803eb5:	00 00 00 
  803eb8:	ff d0                	callq  *%rax
  803eba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ebd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ec1:	0f 88 5d 01 00 00    	js     804024 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ec7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ecb:	ba 07 04 00 00       	mov    $0x407,%edx
  803ed0:	48 89 c6             	mov    %rax,%rsi
  803ed3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed8:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  803edf:	00 00 00 
  803ee2:	ff d0                	callq  *%rax
  803ee4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ee7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eeb:	0f 88 33 01 00 00    	js     804024 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ef1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef5:	48 89 c7             	mov    %rax,%rdi
  803ef8:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  803eff:	00 00 00 
  803f02:	ff d0                	callq  *%rax
  803f04:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f0c:	ba 07 04 00 00       	mov    $0x407,%edx
  803f11:	48 89 c6             	mov    %rax,%rsi
  803f14:	bf 00 00 00 00       	mov    $0x0,%edi
  803f19:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  803f20:	00 00 00 
  803f23:	ff d0                	callq  *%rax
  803f25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f2c:	0f 88 d9 00 00 00    	js     80400b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f36:	48 89 c7             	mov    %rax,%rdi
  803f39:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  803f40:	00 00 00 
  803f43:	ff d0                	callq  *%rax
  803f45:	48 89 c2             	mov    %rax,%rdx
  803f48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f4c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f52:	48 89 d1             	mov    %rdx,%rcx
  803f55:	ba 00 00 00 00       	mov    $0x0,%edx
  803f5a:	48 89 c6             	mov    %rax,%rsi
  803f5d:	bf 00 00 00 00       	mov    $0x0,%edi
  803f62:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  803f69:	00 00 00 
  803f6c:	ff d0                	callq  *%rax
  803f6e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f71:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f75:	78 79                	js     803ff0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f7b:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f82:	00 00 00 
  803f85:	8b 12                	mov    (%rdx),%edx
  803f87:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f98:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f9f:	00 00 00 
  803fa2:	8b 12                	mov    (%rdx),%edx
  803fa4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803fa6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803faa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803fb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb5:	48 89 c7             	mov    %rax,%rdi
  803fb8:	48 b8 3c 29 80 00 00 	movabs $0x80293c,%rax
  803fbf:	00 00 00 
  803fc2:	ff d0                	callq  *%rax
  803fc4:	89 c2                	mov    %eax,%edx
  803fc6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fca:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803fcc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fd0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803fd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd8:	48 89 c7             	mov    %rax,%rdi
  803fdb:	48 b8 3c 29 80 00 00 	movabs $0x80293c,%rax
  803fe2:	00 00 00 
  803fe5:	ff d0                	callq  *%rax
  803fe7:	89 03                	mov    %eax,(%rbx)
	return 0;
  803fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  803fee:	eb 4f                	jmp    80403f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803ff0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803ff1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff5:	48 89 c6             	mov    %rax,%rsi
  803ff8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ffd:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  804004:	00 00 00 
  804007:	ff d0                	callq  *%rax
  804009:	eb 01                	jmp    80400c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80400b:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80400c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804010:	48 89 c6             	mov    %rax,%rsi
  804013:	bf 00 00 00 00       	mov    $0x0,%edi
  804018:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  80401f:	00 00 00 
  804022:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  804024:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804028:	48 89 c6             	mov    %rax,%rsi
  80402b:	bf 00 00 00 00       	mov    $0x0,%edi
  804030:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  804037:	00 00 00 
  80403a:	ff d0                	callq  *%rax
    err:
	return r;
  80403c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80403f:	48 83 c4 38          	add    $0x38,%rsp
  804043:	5b                   	pop    %rbx
  804044:	5d                   	pop    %rbp
  804045:	c3                   	retq   

0000000000804046 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804046:	55                   	push   %rbp
  804047:	48 89 e5             	mov    %rsp,%rbp
  80404a:	53                   	push   %rbx
  80404b:	48 83 ec 28          	sub    $0x28,%rsp
  80404f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804053:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804057:	eb 01                	jmp    80405a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  804059:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80405a:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  804061:	00 00 00 
  804064:	48 8b 00             	mov    (%rax),%rax
  804067:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80406d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804070:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804074:	48 89 c7             	mov    %rax,%rdi
  804077:	48 b8 cc 46 80 00 00 	movabs $0x8046cc,%rax
  80407e:	00 00 00 
  804081:	ff d0                	callq  *%rax
  804083:	89 c3                	mov    %eax,%ebx
  804085:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804089:	48 89 c7             	mov    %rax,%rdi
  80408c:	48 b8 cc 46 80 00 00 	movabs $0x8046cc,%rax
  804093:	00 00 00 
  804096:	ff d0                	callq  *%rax
  804098:	39 c3                	cmp    %eax,%ebx
  80409a:	0f 94 c0             	sete   %al
  80409d:	0f b6 c0             	movzbl %al,%eax
  8040a0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8040a3:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8040aa:	00 00 00 
  8040ad:	48 8b 00             	mov    (%rax),%rax
  8040b0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040b6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8040b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040bc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040bf:	75 0a                	jne    8040cb <_pipeisclosed+0x85>
			return ret;
  8040c1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8040c4:	48 83 c4 28          	add    $0x28,%rsp
  8040c8:	5b                   	pop    %rbx
  8040c9:	5d                   	pop    %rbp
  8040ca:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8040cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040ce:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040d1:	74 86                	je     804059 <_pipeisclosed+0x13>
  8040d3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8040d7:	75 80                	jne    804059 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8040d9:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8040e0:	00 00 00 
  8040e3:	48 8b 00             	mov    (%rax),%rax
  8040e6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8040ec:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8040ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040f2:	89 c6                	mov    %eax,%esi
  8040f4:	48 bf 61 51 80 00 00 	movabs $0x805161,%rdi
  8040fb:	00 00 00 
  8040fe:	b8 00 00 00 00       	mov    $0x0,%eax
  804103:	49 b8 ff 0e 80 00 00 	movabs $0x800eff,%r8
  80410a:	00 00 00 
  80410d:	41 ff d0             	callq  *%r8
	}
  804110:	e9 44 ff ff ff       	jmpq   804059 <_pipeisclosed+0x13>

0000000000804115 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804115:	55                   	push   %rbp
  804116:	48 89 e5             	mov    %rsp,%rbp
  804119:	48 83 ec 30          	sub    $0x30,%rsp
  80411d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804120:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804124:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804127:	48 89 d6             	mov    %rdx,%rsi
  80412a:	89 c7                	mov    %eax,%edi
  80412c:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  804133:	00 00 00 
  804136:	ff d0                	callq  *%rax
  804138:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80413b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80413f:	79 05                	jns    804146 <pipeisclosed+0x31>
		return r;
  804141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804144:	eb 31                	jmp    804177 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804146:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80414a:	48 89 c7             	mov    %rax,%rdi
  80414d:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  804154:	00 00 00 
  804157:	ff d0                	callq  *%rax
  804159:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80415d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804161:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804165:	48 89 d6             	mov    %rdx,%rsi
  804168:	48 89 c7             	mov    %rax,%rdi
  80416b:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  804172:	00 00 00 
  804175:	ff d0                	callq  *%rax
}
  804177:	c9                   	leaveq 
  804178:	c3                   	retq   

0000000000804179 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804179:	55                   	push   %rbp
  80417a:	48 89 e5             	mov    %rsp,%rbp
  80417d:	48 83 ec 40          	sub    $0x40,%rsp
  804181:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804185:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804189:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80418d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804191:	48 89 c7             	mov    %rax,%rdi
  804194:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  80419b:	00 00 00 
  80419e:	ff d0                	callq  *%rax
  8041a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041ac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041b3:	00 
  8041b4:	e9 97 00 00 00       	jmpq   804250 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8041b9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8041be:	74 09                	je     8041c9 <devpipe_read+0x50>
				return i;
  8041c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041c4:	e9 95 00 00 00       	jmpq   80425e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8041c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041d1:	48 89 d6             	mov    %rdx,%rsi
  8041d4:	48 89 c7             	mov    %rax,%rdi
  8041d7:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  8041de:	00 00 00 
  8041e1:	ff d0                	callq  *%rax
  8041e3:	85 c0                	test   %eax,%eax
  8041e5:	74 07                	je     8041ee <devpipe_read+0x75>
				return 0;
  8041e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ec:	eb 70                	jmp    80425e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8041ee:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  8041f5:	00 00 00 
  8041f8:	ff d0                	callq  *%rax
  8041fa:	eb 01                	jmp    8041fd <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041fc:	90                   	nop
  8041fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804201:	8b 10                	mov    (%rax),%edx
  804203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804207:	8b 40 04             	mov    0x4(%rax),%eax
  80420a:	39 c2                	cmp    %eax,%edx
  80420c:	74 ab                	je     8041b9 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80420e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804212:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804216:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80421a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80421e:	8b 00                	mov    (%rax),%eax
  804220:	89 c2                	mov    %eax,%edx
  804222:	c1 fa 1f             	sar    $0x1f,%edx
  804225:	c1 ea 1b             	shr    $0x1b,%edx
  804228:	01 d0                	add    %edx,%eax
  80422a:	83 e0 1f             	and    $0x1f,%eax
  80422d:	29 d0                	sub    %edx,%eax
  80422f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804233:	48 98                	cltq   
  804235:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80423a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80423c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804240:	8b 00                	mov    (%rax),%eax
  804242:	8d 50 01             	lea    0x1(%rax),%edx
  804245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804249:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80424b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804254:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804258:	72 a2                	jb     8041fc <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80425a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80425e:	c9                   	leaveq 
  80425f:	c3                   	retq   

0000000000804260 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804260:	55                   	push   %rbp
  804261:	48 89 e5             	mov    %rsp,%rbp
  804264:	48 83 ec 40          	sub    $0x40,%rsp
  804268:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80426c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804270:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804278:	48 89 c7             	mov    %rax,%rdi
  80427b:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  804282:	00 00 00 
  804285:	ff d0                	callq  *%rax
  804287:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80428b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80428f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804293:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80429a:	00 
  80429b:	e9 93 00 00 00       	jmpq   804333 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8042a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042a8:	48 89 d6             	mov    %rdx,%rsi
  8042ab:	48 89 c7             	mov    %rax,%rdi
  8042ae:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  8042b5:	00 00 00 
  8042b8:	ff d0                	callq  *%rax
  8042ba:	85 c0                	test   %eax,%eax
  8042bc:	74 07                	je     8042c5 <devpipe_write+0x65>
				return 0;
  8042be:	b8 00 00 00 00       	mov    $0x0,%eax
  8042c3:	eb 7c                	jmp    804341 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8042c5:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  8042cc:	00 00 00 
  8042cf:	ff d0                	callq  *%rax
  8042d1:	eb 01                	jmp    8042d4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8042d3:	90                   	nop
  8042d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d8:	8b 40 04             	mov    0x4(%rax),%eax
  8042db:	48 63 d0             	movslq %eax,%rdx
  8042de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e2:	8b 00                	mov    (%rax),%eax
  8042e4:	48 98                	cltq   
  8042e6:	48 83 c0 20          	add    $0x20,%rax
  8042ea:	48 39 c2             	cmp    %rax,%rdx
  8042ed:	73 b1                	jae    8042a0 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8042ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f3:	8b 40 04             	mov    0x4(%rax),%eax
  8042f6:	89 c2                	mov    %eax,%edx
  8042f8:	c1 fa 1f             	sar    $0x1f,%edx
  8042fb:	c1 ea 1b             	shr    $0x1b,%edx
  8042fe:	01 d0                	add    %edx,%eax
  804300:	83 e0 1f             	and    $0x1f,%eax
  804303:	29 d0                	sub    %edx,%eax
  804305:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804309:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80430d:	48 01 ca             	add    %rcx,%rdx
  804310:	0f b6 0a             	movzbl (%rdx),%ecx
  804313:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804317:	48 98                	cltq   
  804319:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80431d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804321:	8b 40 04             	mov    0x4(%rax),%eax
  804324:	8d 50 01             	lea    0x1(%rax),%edx
  804327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80432b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80432e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804337:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80433b:	72 96                	jb     8042d3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80433d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804341:	c9                   	leaveq 
  804342:	c3                   	retq   

0000000000804343 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804343:	55                   	push   %rbp
  804344:	48 89 e5             	mov    %rsp,%rbp
  804347:	48 83 ec 20          	sub    $0x20,%rsp
  80434b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80434f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804357:	48 89 c7             	mov    %rax,%rdi
  80435a:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  804361:	00 00 00 
  804364:	ff d0                	callq  *%rax
  804366:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80436a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80436e:	48 be 74 51 80 00 00 	movabs $0x805174,%rsi
  804375:	00 00 00 
  804378:	48 89 c7             	mov    %rax,%rdi
  80437b:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  804382:	00 00 00 
  804385:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80438b:	8b 50 04             	mov    0x4(%rax),%edx
  80438e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804392:	8b 00                	mov    (%rax),%eax
  804394:	29 c2                	sub    %eax,%edx
  804396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80439a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8043a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043a4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8043ab:	00 00 00 
	stat->st_dev = &devpipe;
  8043ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b2:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8043b9:	00 00 00 
  8043bc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8043c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043c8:	c9                   	leaveq 
  8043c9:	c3                   	retq   

00000000008043ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8043ca:	55                   	push   %rbp
  8043cb:	48 89 e5             	mov    %rsp,%rbp
  8043ce:	48 83 ec 10          	sub    $0x10,%rsp
  8043d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8043d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043da:	48 89 c6             	mov    %rax,%rsi
  8043dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8043e2:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  8043e9:	00 00 00 
  8043ec:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8043ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043f2:	48 89 c7             	mov    %rax,%rdi
  8043f5:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  8043fc:	00 00 00 
  8043ff:	ff d0                	callq  *%rax
  804401:	48 89 c6             	mov    %rax,%rsi
  804404:	bf 00 00 00 00       	mov    $0x0,%edi
  804409:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  804410:	00 00 00 
  804413:	ff d0                	callq  *%rax
}
  804415:	c9                   	leaveq 
  804416:	c3                   	retq   
	...

0000000000804418 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804418:	55                   	push   %rbp
  804419:	48 89 e5             	mov    %rsp,%rbp
  80441c:	48 83 ec 20          	sub    $0x20,%rsp
  804420:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804423:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804426:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804429:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80442d:	be 01 00 00 00       	mov    $0x1,%esi
  804432:	48 89 c7             	mov    %rax,%rdi
  804435:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  80443c:	00 00 00 
  80443f:	ff d0                	callq  *%rax
}
  804441:	c9                   	leaveq 
  804442:	c3                   	retq   

0000000000804443 <getchar>:

int
getchar(void)
{
  804443:	55                   	push   %rbp
  804444:	48 89 e5             	mov    %rsp,%rbp
  804447:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80444b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80444f:	ba 01 00 00 00       	mov    $0x1,%edx
  804454:	48 89 c6             	mov    %rax,%rsi
  804457:	bf 00 00 00 00       	mov    $0x0,%edi
  80445c:	48 b8 54 2e 80 00 00 	movabs $0x802e54,%rax
  804463:	00 00 00 
  804466:	ff d0                	callq  *%rax
  804468:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80446b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80446f:	79 05                	jns    804476 <getchar+0x33>
		return r;
  804471:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804474:	eb 14                	jmp    80448a <getchar+0x47>
	if (r < 1)
  804476:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80447a:	7f 07                	jg     804483 <getchar+0x40>
		return -E_EOF;
  80447c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804481:	eb 07                	jmp    80448a <getchar+0x47>
	return c;
  804483:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804487:	0f b6 c0             	movzbl %al,%eax
}
  80448a:	c9                   	leaveq 
  80448b:	c3                   	retq   

000000000080448c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80448c:	55                   	push   %rbp
  80448d:	48 89 e5             	mov    %rsp,%rbp
  804490:	48 83 ec 20          	sub    $0x20,%rsp
  804494:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804497:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80449b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80449e:	48 89 d6             	mov    %rdx,%rsi
  8044a1:	89 c7                	mov    %eax,%edi
  8044a3:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  8044aa:	00 00 00 
  8044ad:	ff d0                	callq  *%rax
  8044af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b6:	79 05                	jns    8044bd <iscons+0x31>
		return r;
  8044b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044bb:	eb 1a                	jmp    8044d7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8044bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c1:	8b 10                	mov    (%rax),%edx
  8044c3:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8044ca:	00 00 00 
  8044cd:	8b 00                	mov    (%rax),%eax
  8044cf:	39 c2                	cmp    %eax,%edx
  8044d1:	0f 94 c0             	sete   %al
  8044d4:	0f b6 c0             	movzbl %al,%eax
}
  8044d7:	c9                   	leaveq 
  8044d8:	c3                   	retq   

00000000008044d9 <opencons>:

int
opencons(void)
{
  8044d9:	55                   	push   %rbp
  8044da:	48 89 e5             	mov    %rsp,%rbp
  8044dd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8044e1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8044e5:	48 89 c7             	mov    %rax,%rdi
  8044e8:	48 b8 8a 29 80 00 00 	movabs $0x80298a,%rax
  8044ef:	00 00 00 
  8044f2:	ff d0                	callq  *%rax
  8044f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044fb:	79 05                	jns    804502 <opencons+0x29>
		return r;
  8044fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804500:	eb 5b                	jmp    80455d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804506:	ba 07 04 00 00       	mov    $0x407,%edx
  80450b:	48 89 c6             	mov    %rax,%rsi
  80450e:	bf 00 00 00 00       	mov    $0x0,%edi
  804513:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  80451a:	00 00 00 
  80451d:	ff d0                	callq  *%rax
  80451f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804522:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804526:	79 05                	jns    80452d <opencons+0x54>
		return r;
  804528:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80452b:	eb 30                	jmp    80455d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80452d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804531:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804538:	00 00 00 
  80453b:	8b 12                	mov    (%rdx),%edx
  80453d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80453f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804543:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80454a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454e:	48 89 c7             	mov    %rax,%rdi
  804551:	48 b8 3c 29 80 00 00 	movabs $0x80293c,%rax
  804558:	00 00 00 
  80455b:	ff d0                	callq  *%rax
}
  80455d:	c9                   	leaveq 
  80455e:	c3                   	retq   

000000000080455f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80455f:	55                   	push   %rbp
  804560:	48 89 e5             	mov    %rsp,%rbp
  804563:	48 83 ec 30          	sub    $0x30,%rsp
  804567:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80456b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80456f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804573:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804578:	75 13                	jne    80458d <devcons_read+0x2e>
		return 0;
  80457a:	b8 00 00 00 00       	mov    $0x0,%eax
  80457f:	eb 49                	jmp    8045ca <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804581:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  804588:	00 00 00 
  80458b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80458d:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  804594:	00 00 00 
  804597:	ff d0                	callq  *%rax
  804599:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80459c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a0:	74 df                	je     804581 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8045a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a6:	79 05                	jns    8045ad <devcons_read+0x4e>
		return c;
  8045a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ab:	eb 1d                	jmp    8045ca <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8045ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8045b1:	75 07                	jne    8045ba <devcons_read+0x5b>
		return 0;
  8045b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b8:	eb 10                	jmp    8045ca <devcons_read+0x6b>
	*(char*)vbuf = c;
  8045ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045bd:	89 c2                	mov    %eax,%edx
  8045bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045c3:	88 10                	mov    %dl,(%rax)
	return 1;
  8045c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8045ca:	c9                   	leaveq 
  8045cb:	c3                   	retq   

00000000008045cc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045cc:	55                   	push   %rbp
  8045cd:	48 89 e5             	mov    %rsp,%rbp
  8045d0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8045d7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8045de:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8045e5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045f3:	eb 77                	jmp    80466c <devcons_write+0xa0>
		m = n - tot;
  8045f5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8045fc:	89 c2                	mov    %eax,%edx
  8045fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804601:	89 d1                	mov    %edx,%ecx
  804603:	29 c1                	sub    %eax,%ecx
  804605:	89 c8                	mov    %ecx,%eax
  804607:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80460a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80460d:	83 f8 7f             	cmp    $0x7f,%eax
  804610:	76 07                	jbe    804619 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804612:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804619:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80461c:	48 63 d0             	movslq %eax,%rdx
  80461f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804622:	48 98                	cltq   
  804624:	48 89 c1             	mov    %rax,%rcx
  804627:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80462e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804635:	48 89 ce             	mov    %rcx,%rsi
  804638:	48 89 c7             	mov    %rax,%rdi
  80463b:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  804642:	00 00 00 
  804645:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804647:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80464a:	48 63 d0             	movslq %eax,%rdx
  80464d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804654:	48 89 d6             	mov    %rdx,%rsi
  804657:	48 89 c7             	mov    %rax,%rdi
  80465a:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  804661:	00 00 00 
  804664:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804666:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804669:	01 45 fc             	add    %eax,-0x4(%rbp)
  80466c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80466f:	48 98                	cltq   
  804671:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804678:	0f 82 77 ff ff ff    	jb     8045f5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80467e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804681:	c9                   	leaveq 
  804682:	c3                   	retq   

0000000000804683 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804683:	55                   	push   %rbp
  804684:	48 89 e5             	mov    %rsp,%rbp
  804687:	48 83 ec 08          	sub    $0x8,%rsp
  80468b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80468f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804694:	c9                   	leaveq 
  804695:	c3                   	retq   

0000000000804696 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804696:	55                   	push   %rbp
  804697:	48 89 e5             	mov    %rsp,%rbp
  80469a:	48 83 ec 10          	sub    $0x10,%rsp
  80469e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8046a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046aa:	48 be 80 51 80 00 00 	movabs $0x805180,%rsi
  8046b1:	00 00 00 
  8046b4:	48 89 c7             	mov    %rax,%rdi
  8046b7:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  8046be:	00 00 00 
  8046c1:	ff d0                	callq  *%rax
	return 0;
  8046c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046c8:	c9                   	leaveq 
  8046c9:	c3                   	retq   
	...

00000000008046cc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8046cc:	55                   	push   %rbp
  8046cd:	48 89 e5             	mov    %rsp,%rbp
  8046d0:	48 83 ec 18          	sub    $0x18,%rsp
  8046d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046dc:	48 89 c2             	mov    %rax,%rdx
  8046df:	48 c1 ea 15          	shr    $0x15,%rdx
  8046e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046ea:	01 00 00 
  8046ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046f1:	83 e0 01             	and    $0x1,%eax
  8046f4:	48 85 c0             	test   %rax,%rax
  8046f7:	75 07                	jne    804700 <pageref+0x34>
		return 0;
  8046f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fe:	eb 53                	jmp    804753 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804704:	48 89 c2             	mov    %rax,%rdx
  804707:	48 c1 ea 0c          	shr    $0xc,%rdx
  80470b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804712:	01 00 00 
  804715:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804719:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80471d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804721:	83 e0 01             	and    $0x1,%eax
  804724:	48 85 c0             	test   %rax,%rax
  804727:	75 07                	jne    804730 <pageref+0x64>
		return 0;
  804729:	b8 00 00 00 00       	mov    $0x0,%eax
  80472e:	eb 23                	jmp    804753 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804734:	48 89 c2             	mov    %rax,%rdx
  804737:	48 c1 ea 0c          	shr    $0xc,%rdx
  80473b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804742:	00 00 00 
  804745:	48 c1 e2 04          	shl    $0x4,%rdx
  804749:	48 01 d0             	add    %rdx,%rax
  80474c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804750:	0f b7 c0             	movzwl %ax,%eax
}
  804753:	c9                   	leaveq 
  804754:	c3                   	retq   
