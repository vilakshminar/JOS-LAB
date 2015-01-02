
obj/user/testfilero.debug:     file format elf64-x86-64


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
  80003c:	e8 17 0a 00 00       	callq  800a58 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <xopen>:
const char *msg2 = "This is the test message";
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
  800064:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  80006b:	00 00 00 
  80006e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800070:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800077:	00 00 00 
  80007a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
  800088:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
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
  8000b0:	48 b8 50 26 80 00 00 	movabs $0x802650,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000cb:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
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
  8000f7:	48 bf fd 45 80 00 00 	movabs $0x8045fd,%rdi
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
  800128:	48 ba 08 46 80 00 00 	movabs $0x804608,%rdx
  80012f:	00 00 00 
  800132:	be 20 00 00 00       	mov    $0x20,%esi
  800137:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  80013e:	00 00 00 
  800141:	b8 00 00 00 00       	mov    $0x0,%eax
  800146:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  80014d:	00 00 00 
  800150:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800153:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800158:	78 2a                	js     800184 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  80015a:	48 ba 38 46 80 00 00 	movabs $0x804638,%rdx
  800161:	00 00 00 
  800164:	be 22 00 00 00       	mov    $0x22,%esi
  800169:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800170:	00 00 00 
  800173:	b8 00 00 00 00       	mov    $0x0,%eax
  800178:	48 b9 20 0b 80 00 00 	movabs $0x800b20,%rcx
  80017f:	00 00 00 
  800182:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800184:	be 00 00 00 00       	mov    $0x0,%esi
  800189:	48 bf 59 46 80 00 00 	movabs $0x804659,%rdi
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
  8001b3:	48 ba 62 46 80 00 00 	movabs $0x804662,%rdx
  8001ba:	00 00 00 
  8001bd:	be 25 00 00 00       	mov    $0x25,%esi
  8001c2:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  8001c9:	00 00 00 
  8001cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d1:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
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
  800202:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  800209:	00 00 00 
  80020c:	be 27 00 00 00       	mov    $0x27,%esi
  800211:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800218:	00 00 00 
  80021b:	b8 00 00 00 00       	mov    $0x0,%eax
  800220:	48 b9 20 0b 80 00 00 	movabs $0x800b20,%rcx
  800227:	00 00 00 
  80022a:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022c:	48 bf ad 46 80 00 00 	movabs $0x8046ad,%rdi
  800233:	00 00 00 
  800236:	b8 00 00 00 00       	mov    $0x0,%eax
  80023b:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  800242:	00 00 00 
  800245:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800247:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
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
  80027a:	48 ba c1 46 80 00 00 	movabs $0x8046c1,%rdx
  800281:	00 00 00 
  800284:	be 2b 00 00 00       	mov    $0x2b,%esi
  800289:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  80029f:	00 00 00 
  8002a2:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ac:	00 00 00 
  8002af:	48 8b 00             	mov    (%rax),%rax
  8002b2:	48 89 c7             	mov    %rax,%rdi
  8002b5:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  8002bc:	00 00 00 
  8002bf:	ff d0                	callq  *%rax
  8002c1:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c4:	39 d0                	cmp    %edx,%eax
  8002c6:	74 51                	je     800319 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002cf:	00 00 00 
  8002d2:	48 8b 00             	mov    (%rax),%rax
  8002d5:	48 89 c7             	mov    %rax,%rdi
  8002d8:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  8002df:	00 00 00 
  8002e2:	ff d0                	callq  *%rax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e9:	41 89 d0             	mov    %edx,%r8d
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	48 ba d0 46 80 00 00 	movabs $0x8046d0,%rdx
  8002f5:	00 00 00 
  8002f8:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fd:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800304:	00 00 00 
  800307:	b8 00 00 00 00       	mov    $0x0,%eax
  80030c:	49 b9 20 0b 80 00 00 	movabs $0x800b20,%r9
  800313:	00 00 00 
  800316:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800319:	48 bf f6 46 80 00 00 	movabs $0x8046f6,%rdi
  800320:	00 00 00 
  800323:	b8 00 00 00 00       	mov    $0x0,%eax
  800328:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  80032f:	00 00 00 
  800332:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800334:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033b:	ba 00 02 00 00       	mov    $0x200,%edx
  800340:	be 00 00 00 00       	mov    $0x0,%esi
  800345:	48 89 c7             	mov    %rax,%rdi
  800348:	48 b8 af 1b 80 00 00 	movabs $0x801baf,%rax
  80034f:	00 00 00 
  800352:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800354:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
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
  80038c:	48 ba 09 47 80 00 00 	movabs $0x804709,%rdx
  800393:	00 00 00 
  800396:	be 32 00 00 00       	mov    $0x32,%esi
  80039b:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  8003a2:	00 00 00 
  8003a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003aa:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  8003b1:	00 00 00 
  8003b4:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003be:	00 00 00 
  8003c1:	48 8b 10             	mov    (%rax),%rdx
  8003c4:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003cb:	48 89 d6             	mov    %rdx,%rsi
  8003ce:	48 89 c7             	mov    %rax,%rdi
  8003d1:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  8003d8:	00 00 00 
  8003db:	ff d0                	callq  *%rax
  8003dd:	85 c0                	test   %eax,%eax
  8003df:	74 2a                	je     80040b <umain+0x332>
		panic("file_read returned wrong data");
  8003e1:	48 ba 17 47 80 00 00 	movabs $0x804717,%rdx
  8003e8:	00 00 00 
  8003eb:	be 34 00 00 00       	mov    $0x34,%esi
  8003f0:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  8003f7:	00 00 00 
  8003fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ff:	48 b9 20 0b 80 00 00 	movabs $0x800b20,%rcx
  800406:	00 00 00 
  800409:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040b:	48 bf 35 47 80 00 00 	movabs $0x804735,%rdi
  800412:	00 00 00 
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
  80041a:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  800421:	00 00 00 
  800424:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800426:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
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
  80044f:	48 ba 48 47 80 00 00 	movabs $0x804748,%rdx
  800456:	00 00 00 
  800459:	be 38 00 00 00       	mov    $0x38,%esi
  80045e:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800465:	00 00 00 
  800468:	b8 00 00 00 00       	mov    $0x0,%eax
  80046d:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  800474:	00 00 00 
  800477:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  80047a:	48 bf 57 47 80 00 00 	movabs $0x804757,%rdi
  800481:	00 00 00 
  800484:	b8 00 00 00 00       	mov    $0x0,%eax
  800489:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
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
  8004b3:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004bf:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
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
  8004fa:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  800501:	00 00 00 
  800504:	be 43 00 00 00       	mov    $0x43,%esi
  800509:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800510:	00 00 00 
  800513:	b8 00 00 00 00       	mov    $0x0,%eax
  800518:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  80051f:	00 00 00 
  800522:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800525:	48 bf a7 47 80 00 00 	movabs $0x8047a7,%rdi
  80052c:	00 00 00 
  80052f:	b8 00 00 00 00       	mov    $0x0,%eax
  800534:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  80053b:	00 00 00 
  80053e:	ff d2                	callq  *%rdx




	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800540:	be 00 00 00 00       	mov    $0x0,%esi
  800545:	48 bf fd 45 80 00 00 	movabs $0x8045fd,%rdi
  80054c:	00 00 00 
  80054f:	48 b8 8f 31 80 00 00 	movabs $0x80318f,%rax
  800556:	00 00 00 
  800559:	ff d0                	callq  *%rax
  80055b:	48 98                	cltq   
  80055d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800561:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800566:	79 39                	jns    8005a1 <umain+0x4c8>
  800568:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80056d:	74 32                	je     8005a1 <umain+0x4c8>
		panic("open /not-found: %e", r);
  80056f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800573:	48 89 c1             	mov    %rax,%rcx
  800576:	48 ba bd 47 80 00 00 	movabs $0x8047bd,%rdx
  80057d:	00 00 00 
  800580:	be 4c 00 00 00       	mov    $0x4c,%esi
  800585:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  80058c:	00 00 00 
  80058f:	b8 00 00 00 00       	mov    $0x0,%eax
  800594:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  80059b:	00 00 00 
  80059e:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  8005a1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8005a6:	78 2a                	js     8005d2 <umain+0x4f9>
		panic("open /not-found succeeded!");
  8005a8:	48 ba d1 47 80 00 00 	movabs $0x8047d1,%rdx
  8005af:	00 00 00 
  8005b2:	be 4e 00 00 00       	mov    $0x4e,%esi
  8005b7:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  8005be:	00 00 00 
  8005c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c6:	48 b9 20 0b 80 00 00 	movabs $0x800b20,%rcx
  8005cd:	00 00 00 
  8005d0:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8005d2:	be 00 00 00 00       	mov    $0x0,%esi
  8005d7:	48 bf 59 46 80 00 00 	movabs $0x804659,%rdi
  8005de:	00 00 00 
  8005e1:	48 b8 8f 31 80 00 00 	movabs $0x80318f,%rax
  8005e8:	00 00 00 
  8005eb:	ff d0                	callq  *%rax
  8005ed:	48 98                	cltq   
  8005ef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8005f3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8005f8:	79 32                	jns    80062c <umain+0x553>
		panic("open /newmotd: %e", r);
  8005fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005fe:	48 89 c1             	mov    %rax,%rcx
  800601:	48 ba ec 47 80 00 00 	movabs $0x8047ec,%rdx
  800608:	00 00 00 
  80060b:	be 51 00 00 00       	mov    $0x51,%esi
  800610:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800617:	00 00 00 
  80061a:	b8 00 00 00 00       	mov    $0x0,%eax
  80061f:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  800626:	00 00 00 
  800629:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  80062c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800630:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800636:	48 c1 e0 0c          	shl    $0xc,%rax
  80063a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80063e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800642:	8b 00                	mov    (%rax),%eax
  800644:	83 f8 66             	cmp    $0x66,%eax
  800647:	75 16                	jne    80065f <umain+0x586>
  800649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80064d:	8b 40 04             	mov    0x4(%rax),%eax
  800650:	85 c0                	test   %eax,%eax
  800652:	75 0b                	jne    80065f <umain+0x586>
  800654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800658:	8b 40 08             	mov    0x8(%rax),%eax
  80065b:	85 c0                	test   %eax,%eax
  80065d:	74 2a                	je     800689 <umain+0x5b0>
		panic("open did not fill struct Fd correctly\n");
  80065f:	48 ba 00 48 80 00 00 	movabs $0x804800,%rdx
  800666:	00 00 00 
  800669:	be 54 00 00 00       	mov    $0x54,%esi
  80066e:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800675:	00 00 00 
  800678:	b8 00 00 00 00       	mov    $0x0,%eax
  80067d:	48 b9 20 0b 80 00 00 	movabs $0x800b20,%rcx
  800684:	00 00 00 
  800687:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800689:	48 bf 27 48 80 00 00 	movabs $0x804827,%rdi
  800690:	00 00 00 
  800693:	b8 00 00 00 00       	mov    $0x0,%eax
  800698:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  80069f:	00 00 00 
  8006a2:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/robig", O_RDONLY)) < 0)
  8006a4:	be 00 00 00 00       	mov    $0x0,%esi
  8006a9:	48 bf 35 48 80 00 00 	movabs $0x804835,%rdi
  8006b0:	00 00 00 
  8006b3:	48 b8 8f 31 80 00 00 	movabs $0x80318f,%rax
  8006ba:	00 00 00 
  8006bd:	ff d0                	callq  *%rax
  8006bf:	48 98                	cltq   
  8006c1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8006c5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8006ca:	79 32                	jns    8006fe <umain+0x625>
		panic("open /robig: %e", f);
  8006cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8006d0:	48 89 c1             	mov    %rax,%rcx
  8006d3:	48 ba 3c 48 80 00 00 	movabs $0x80483c,%rdx
  8006da:	00 00 00 
  8006dd:	be 59 00 00 00       	mov    $0x59,%esi
  8006e2:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  8006f8:	00 00 00 
  8006fb:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8006fe:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800705:	00 
  800706:	e9 1a 01 00 00       	jmpq   800825 <umain+0x74c>
		*(int*)buf = i;
  80070b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800718:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80071c:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800723:	ba 00 02 00 00       	mov    $0x200,%edx
  800728:	48 89 ce             	mov    %rcx,%rsi
  80072b:	89 c7                	mov    %eax,%edi
  80072d:	48 b8 89 2d 80 00 00 	movabs $0x802d89,%rax
  800734:	00 00 00 
  800737:	ff d0                	callq  *%rax
  800739:	48 98                	cltq   
  80073b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80073f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800744:	79 39                	jns    80077f <umain+0x6a6>
			panic("read /robig@%d: %e", i, r);
  800746:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	49 89 d0             	mov    %rdx,%r8
  800751:	48 89 c1             	mov    %rax,%rcx
  800754:	48 ba 4c 48 80 00 00 	movabs $0x80484c,%rdx
  80075b:	00 00 00 
  80075e:	be 5d 00 00 00       	mov    $0x5d,%esi
  800763:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  80076a:	00 00 00 
  80076d:	b8 00 00 00 00       	mov    $0x0,%eax
  800772:	49 b9 20 0b 80 00 00 	movabs $0x800b20,%r9
  800779:	00 00 00 
  80077c:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  80077f:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800786:	00 
  800787:	74 3f                	je     8007c8 <umain+0x6ef>
			panic("read /robig from %d returned %d < %d bytes",
  800789:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80078d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800791:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800797:	49 89 d0             	mov    %rdx,%r8
  80079a:	48 89 c1             	mov    %rax,%rcx
  80079d:	48 ba 60 48 80 00 00 	movabs $0x804860,%rdx
  8007a4:	00 00 00 
  8007a7:	be 60 00 00 00       	mov    $0x60,%esi
  8007ac:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  8007b3:	00 00 00 
  8007b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bb:	49 ba 20 0b 80 00 00 	movabs $0x800b20,%r10
  8007c2:	00 00 00 
  8007c5:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  8007c8:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007cf:	8b 00                	mov    (%rax),%eax
  8007d1:	48 98                	cltq   
  8007d3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8007d7:	74 3e                	je     800817 <umain+0x73e>
			panic("read /robig from %d returned bad data %d",
  8007d9:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007e0:	8b 10                	mov    (%rax),%edx
  8007e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e6:	41 89 d0             	mov    %edx,%r8d
  8007e9:	48 89 c1             	mov    %rax,%rcx
  8007ec:	48 ba 90 48 80 00 00 	movabs $0x804890,%rdx
  8007f3:	00 00 00 
  8007f6:	be 63 00 00 00       	mov    $0x63,%esi
  8007fb:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800802:	00 00 00 
  800805:	b8 00 00 00 00       	mov    $0x0,%eax
  80080a:	49 b9 20 0b 80 00 00 	movabs $0x800b20,%r9
  800811:	00 00 00 
  800814:	41 ff d1             	callq  *%r9
	cprintf("open is good\n");

	// Try files with indirect blocks
	if ((f = open("/robig", O_RDONLY)) < 0)
		panic("open /robig: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 05 00 02 00 00    	add    $0x200,%rax
  800821:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800825:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  80082c:	00 
  80082d:	0f 8e d8 fe ff ff    	jle    80070b <umain+0x632>




 // Try writing
        if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800833:	be 02 01 00 00       	mov    $0x102,%esi
  800838:	48 bf b9 48 80 00 00 	movabs $0x8048b9,%rdi
  80083f:	00 00 00 
  800842:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800849:	00 00 00 
  80084c:	ff d0                	callq  *%rax
  80084e:	48 98                	cltq   
  800850:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800854:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800859:	79 32                	jns    80088d <umain+0x7b4>
                panic("serve_open /new-file: %e", r);
  80085b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085f:	48 89 c1             	mov    %rax,%rcx
  800862:	48 ba c3 48 80 00 00 	movabs $0x8048c3,%rdx
  800869:	00 00 00 
  80086c:	be 6c 00 00 00       	mov    $0x6c,%esi
  800871:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800878:	00 00 00 
  80087b:	b8 00 00 00 00       	mov    $0x0,%eax
  800880:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  800887:	00 00 00 
  80088a:	41 ff d0             	callq  *%r8

	 cprintf("file_open is good\n");
  80088d:	48 bf dc 48 80 00 00 	movabs $0x8048dc,%rdi
  800894:	00 00 00 
  800897:	b8 00 00 00 00       	mov    $0x0,%eax
  80089c:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  8008a3:	00 00 00 
  8008a6:	ff d2                	callq  *%rdx



       if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  8008a8:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8008af:	00 00 00 
  8008b2:	48 8b 58 18          	mov    0x18(%rax),%rbx
  8008b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008bd:	00 00 00 
  8008c0:	48 8b 00             	mov    (%rax),%rax
  8008c3:	48 89 c7             	mov    %rax,%rdi
  8008c6:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  8008cd:	00 00 00 
  8008d0:	ff d0                	callq  *%rax
  8008d2:	48 63 d0             	movslq %eax,%rdx
  8008d5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008dc:	00 00 00 
  8008df:	48 8b 00             	mov    (%rax),%rax
  8008e2:	48 89 c6             	mov    %rax,%rsi
  8008e5:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  8008ea:	ff d3                	callq  *%rbx
  8008ec:	48 98                	cltq   
  8008ee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008f2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008f9:	00 00 00 
  8008fc:	48 8b 00             	mov    (%rax),%rax
  8008ff:	48 89 c7             	mov    %rax,%rdi
  800902:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  800909:	00 00 00 
  80090c:	ff d0                	callq  *%rax
  80090e:	48 98                	cltq   
  800910:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800914:	74 32                	je     800948 <umain+0x86f>
                panic("file_write: %e", r);
  800916:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80091a:	48 89 c1             	mov    %rax,%rcx
  80091d:	48 ba ef 48 80 00 00 	movabs $0x8048ef,%rdx
  800924:	00 00 00 
  800927:	be 73 00 00 00       	mov    $0x73,%esi
  80092c:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  800933:	00 00 00 
  800936:	b8 00 00 00 00       	mov    $0x0,%eax
  80093b:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  800942:	00 00 00 
  800945:	41 ff d0             	callq  *%r8
       cprintf("file_write is good\n");
  800948:	48 bf fe 48 80 00 00 	movabs $0x8048fe,%rdi
  80094f:	00 00 00 
  800952:	b8 00 00 00 00       	mov    $0x0,%eax
  800957:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  80095e:	00 00 00 
  800961:	ff d2                	callq  *%rdx
                panic("file_read after file_write returned wrong length: %d", r);
        if (strcmp(buf, msg) != 0)
               panic("file_read after file_write returned wrong data");
        cprintf("file_read after file_write is good\n");
*/
	if ((r = devfile.dev_write(FVA, msg2, strlen(msg2))) != (strlen(msg2)))
  800963:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80096a:	00 00 00 
  80096d:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800971:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800978:	00 00 00 
  80097b:	48 8b 00             	mov    (%rax),%rax
  80097e:	48 89 c7             	mov    %rax,%rdi
  800981:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  800988:	00 00 00 
  80098b:	ff d0                	callq  *%rax
  80098d:	48 63 d0             	movslq %eax,%rdx
  800990:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800997:	00 00 00 
  80099a:	48 8b 00             	mov    (%rax),%rax
  80099d:	48 89 c6             	mov    %rax,%rsi
  8009a0:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  8009a5:	ff d3                	callq  *%rbx
  8009a7:	48 98                	cltq   
  8009a9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8009ad:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8009b4:	00 00 00 
  8009b7:	48 8b 00             	mov    (%rax),%rax
  8009ba:	48 89 c7             	mov    %rax,%rdi
  8009bd:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  8009c4:	00 00 00 
  8009c7:	ff d0                	callq  *%rax
  8009c9:	48 98                	cltq   
  8009cb:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  8009cf:	74 32                	je     800a03 <umain+0x92a>
              panic("file_write: %e", r);
  8009d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009d5:	48 89 c1             	mov    %rax,%rcx
  8009d8:	48 ba ef 48 80 00 00 	movabs $0x8048ef,%rdx
  8009df:	00 00 00 
  8009e2:	be 81 00 00 00       	mov    $0x81,%esi
  8009e7:	48 bf 22 46 80 00 00 	movabs $0x804622,%rdi
  8009ee:	00 00 00 
  8009f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f6:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  8009fd:	00 00 00 
  800a00:	41 ff d0             	callq  *%r8
        cprintf("file_write 2 is good\n");
  800a03:	48 bf 12 49 80 00 00 	movabs $0x804912,%rdi
  800a0a:	00 00 00 
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a12:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  800a19:	00 00 00 
  800a1c:	ff d2                	callq  *%rdx

	close(f);
  800a1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a22:	89 c7                	mov    %eax,%edi
  800a24:	48 b8 8e 2a 80 00 00 	movabs $0x802a8e,%rax
  800a2b:	00 00 00 
  800a2e:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800a30:	48 bf 28 49 80 00 00 	movabs $0x804928,%rdi
  800a37:	00 00 00 
  800a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3f:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  800a46:	00 00 00 
  800a49:	ff d2                	callq  *%rdx
}
  800a4b:	48 81 c4 d8 02 00 00 	add    $0x2d8,%rsp
  800a52:	5b                   	pop    %rbx
  800a53:	5d                   	pop    %rbp
  800a54:	c3                   	retq   
  800a55:	00 00                	add    %al,(%rax)
	...

0000000000800a58 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a58:	55                   	push   %rbp
  800a59:	48 89 e5             	mov    %rsp,%rbp
  800a5c:	48 83 ec 10          	sub    $0x10,%rsp
  800a60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800a67:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800a6e:	00 00 00 
  800a71:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800a78:	48 b8 d4 21 80 00 00 	movabs $0x8021d4,%rax
  800a7f:	00 00 00 
  800a82:	ff d0                	callq  *%rax
  800a84:	48 98                	cltq   
  800a86:	48 89 c2             	mov    %rax,%rdx
  800a89:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800a8f:	48 89 d0             	mov    %rdx,%rax
  800a92:	48 c1 e0 03          	shl    $0x3,%rax
  800a96:	48 01 d0             	add    %rdx,%rax
  800a99:	48 c1 e0 05          	shl    $0x5,%rax
  800a9d:	48 89 c2             	mov    %rax,%rdx
  800aa0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800aa7:	00 00 00 
  800aaa:	48 01 c2             	add    %rax,%rdx
  800aad:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800ab4:	00 00 00 
  800ab7:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800aba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800abe:	7e 14                	jle    800ad4 <libmain+0x7c>
		binaryname = argv[0];
  800ac0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ac4:	48 8b 10             	mov    (%rax),%rdx
  800ac7:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800ace:	00 00 00 
  800ad1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800ad4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800adb:	48 89 d6             	mov    %rdx,%rsi
  800ade:	89 c7                	mov    %eax,%edi
  800ae0:	48 b8 d9 00 80 00 00 	movabs $0x8000d9,%rax
  800ae7:	00 00 00 
  800aea:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800aec:	48 b8 fc 0a 80 00 00 	movabs $0x800afc,%rax
  800af3:	00 00 00 
  800af6:	ff d0                	callq  *%rax
}
  800af8:	c9                   	leaveq 
  800af9:	c3                   	retq   
	...

0000000000800afc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800afc:	55                   	push   %rbp
  800afd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800b00:	48 b8 d9 2a 80 00 00 	movabs $0x802ad9,%rax
  800b07:	00 00 00 
  800b0a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800b0c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b11:	48 b8 90 21 80 00 00 	movabs $0x802190,%rax
  800b18:	00 00 00 
  800b1b:	ff d0                	callq  *%rax
}
  800b1d:	5d                   	pop    %rbp
  800b1e:	c3                   	retq   
	...

0000000000800b20 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800b20:	55                   	push   %rbp
  800b21:	48 89 e5             	mov    %rsp,%rbp
  800b24:	53                   	push   %rbx
  800b25:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800b2c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800b33:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b39:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b40:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b47:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b4e:	84 c0                	test   %al,%al
  800b50:	74 23                	je     800b75 <_panic+0x55>
  800b52:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b59:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b5d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b61:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b65:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b69:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b6d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b71:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b75:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b7c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b83:	00 00 00 
  800b86:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b8d:	00 00 00 
  800b90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b94:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b9b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800ba2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ba9:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800bb0:	00 00 00 
  800bb3:	48 8b 18             	mov    (%rax),%rbx
  800bb6:	48 b8 d4 21 80 00 00 	movabs $0x8021d4,%rax
  800bbd:	00 00 00 
  800bc0:	ff d0                	callq  *%rax
  800bc2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800bc8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bcf:	41 89 c8             	mov    %ecx,%r8d
  800bd2:	48 89 d1             	mov    %rdx,%rcx
  800bd5:	48 89 da             	mov    %rbx,%rdx
  800bd8:	89 c6                	mov    %eax,%esi
  800bda:	48 bf 48 49 80 00 00 	movabs $0x804948,%rdi
  800be1:	00 00 00 
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
  800be9:	49 b9 5b 0d 80 00 00 	movabs $0x800d5b,%r9
  800bf0:	00 00 00 
  800bf3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bf6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bfd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800c04:	48 89 d6             	mov    %rdx,%rsi
  800c07:	48 89 c7             	mov    %rax,%rdi
  800c0a:	48 b8 af 0c 80 00 00 	movabs $0x800caf,%rax
  800c11:	00 00 00 
  800c14:	ff d0                	callq  *%rax
	cprintf("\n");
  800c16:	48 bf 6b 49 80 00 00 	movabs $0x80496b,%rdi
  800c1d:	00 00 00 
  800c20:	b8 00 00 00 00       	mov    $0x0,%eax
  800c25:	48 ba 5b 0d 80 00 00 	movabs $0x800d5b,%rdx
  800c2c:	00 00 00 
  800c2f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c31:	cc                   	int3   
  800c32:	eb fd                	jmp    800c31 <_panic+0x111>

0000000000800c34 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800c34:	55                   	push   %rbp
  800c35:	48 89 e5             	mov    %rsp,%rbp
  800c38:	48 83 ec 10          	sub    $0x10,%rsp
  800c3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c47:	8b 00                	mov    (%rax),%eax
  800c49:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c4c:	89 d6                	mov    %edx,%esi
  800c4e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800c52:	48 63 d0             	movslq %eax,%rdx
  800c55:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800c5a:	8d 50 01             	lea    0x1(%rax),%edx
  800c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c61:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800c63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c67:	8b 00                	mov    (%rax),%eax
  800c69:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c6e:	75 2c                	jne    800c9c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c74:	8b 00                	mov    (%rax),%eax
  800c76:	48 98                	cltq   
  800c78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c7c:	48 83 c2 08          	add    $0x8,%rdx
  800c80:	48 89 c6             	mov    %rax,%rsi
  800c83:	48 89 d7             	mov    %rdx,%rdi
  800c86:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  800c8d:	00 00 00 
  800c90:	ff d0                	callq  *%rax
		b->idx = 0;
  800c92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c96:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800c9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca0:	8b 40 04             	mov    0x4(%rax),%eax
  800ca3:	8d 50 01             	lea    0x1(%rax),%edx
  800ca6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800caa:	89 50 04             	mov    %edx,0x4(%rax)
}
  800cad:	c9                   	leaveq 
  800cae:	c3                   	retq   

0000000000800caf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800caf:	55                   	push   %rbp
  800cb0:	48 89 e5             	mov    %rsp,%rbp
  800cb3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800cba:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800cc1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800cc8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800ccf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800cd6:	48 8b 0a             	mov    (%rdx),%rcx
  800cd9:	48 89 08             	mov    %rcx,(%rax)
  800cdc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ce0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ce4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ce8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800cec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cf3:	00 00 00 
	b.cnt = 0;
  800cf6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cfd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800d00:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800d07:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800d0e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800d15:	48 89 c6             	mov    %rax,%rsi
  800d18:	48 bf 34 0c 80 00 00 	movabs $0x800c34,%rdi
  800d1f:	00 00 00 
  800d22:	48 b8 0c 11 80 00 00 	movabs $0x80110c,%rax
  800d29:	00 00 00 
  800d2c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800d2e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800d34:	48 98                	cltq   
  800d36:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d3d:	48 83 c2 08          	add    $0x8,%rdx
  800d41:	48 89 c6             	mov    %rax,%rsi
  800d44:	48 89 d7             	mov    %rdx,%rdi
  800d47:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  800d4e:	00 00 00 
  800d51:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800d53:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d59:	c9                   	leaveq 
  800d5a:	c3                   	retq   

0000000000800d5b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800d5b:	55                   	push   %rbp
  800d5c:	48 89 e5             	mov    %rsp,%rbp
  800d5f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d66:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d6d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d74:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d7b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d82:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d89:	84 c0                	test   %al,%al
  800d8b:	74 20                	je     800dad <cprintf+0x52>
  800d8d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d91:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d95:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d99:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d9d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800da1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dad:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800db4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800dbb:	00 00 00 
  800dbe:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dc5:	00 00 00 
  800dc8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dcc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dd3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dda:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800de1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800de8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800def:	48 8b 0a             	mov    (%rdx),%rcx
  800df2:	48 89 08             	mov    %rcx,(%rax)
  800df5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800df9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dfd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e01:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800e05:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800e0c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e13:	48 89 d6             	mov    %rdx,%rsi
  800e16:	48 89 c7             	mov    %rax,%rdi
  800e19:	48 b8 af 0c 80 00 00 	movabs $0x800caf,%rax
  800e20:	00 00 00 
  800e23:	ff d0                	callq  *%rax
  800e25:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800e2b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e31:	c9                   	leaveq 
  800e32:	c3                   	retq   
	...

0000000000800e34 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	48 83 ec 30          	sub    $0x30,%rsp
  800e3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800e44:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e48:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800e4b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800e4f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e53:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800e56:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800e5a:	77 52                	ja     800eae <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e5c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800e5f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e63:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800e66:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e73:	48 f7 75 d0          	divq   -0x30(%rbp)
  800e77:	48 89 c2             	mov    %rax,%rdx
  800e7a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e7d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e80:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800e84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e88:	41 89 f9             	mov    %edi,%r9d
  800e8b:	48 89 c7             	mov    %rax,%rdi
  800e8e:	48 b8 34 0e 80 00 00 	movabs $0x800e34,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
  800e9a:	eb 1c                	jmp    800eb8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ea0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ea3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800ea7:	48 89 d6             	mov    %rdx,%rsi
  800eaa:	89 c7                	mov    %eax,%edi
  800eac:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800eae:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800eb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800eb6:	7f e4                	jg     800e9c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800eb8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	48 f7 f1             	div    %rcx
  800ec7:	48 89 d0             	mov    %rdx,%rax
  800eca:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  800ed1:	00 00 00 
  800ed4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800ed8:	0f be c0             	movsbl %al,%eax
  800edb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800edf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800ee3:	48 89 d6             	mov    %rdx,%rsi
  800ee6:	89 c7                	mov    %eax,%edi
  800ee8:	ff d1                	callq  *%rcx
}
  800eea:	c9                   	leaveq 
  800eeb:	c3                   	retq   

0000000000800eec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800eec:	55                   	push   %rbp
  800eed:	48 89 e5             	mov    %rsp,%rbp
  800ef0:	48 83 ec 20          	sub    $0x20,%rsp
  800ef4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800efb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800eff:	7e 52                	jle    800f53 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800f01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f05:	8b 00                	mov    (%rax),%eax
  800f07:	83 f8 30             	cmp    $0x30,%eax
  800f0a:	73 24                	jae    800f30 <getuint+0x44>
  800f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f10:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f18:	8b 00                	mov    (%rax),%eax
  800f1a:	89 c0                	mov    %eax,%eax
  800f1c:	48 01 d0             	add    %rdx,%rax
  800f1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f23:	8b 12                	mov    (%rdx),%edx
  800f25:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f2c:	89 0a                	mov    %ecx,(%rdx)
  800f2e:	eb 17                	jmp    800f47 <getuint+0x5b>
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f38:	48 89 d0             	mov    %rdx,%rax
  800f3b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f43:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f47:	48 8b 00             	mov    (%rax),%rax
  800f4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f4e:	e9 a3 00 00 00       	jmpq   800ff6 <getuint+0x10a>
	else if (lflag)
  800f53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f57:	74 4f                	je     800fa8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5d:	8b 00                	mov    (%rax),%eax
  800f5f:	83 f8 30             	cmp    $0x30,%eax
  800f62:	73 24                	jae    800f88 <getuint+0x9c>
  800f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f68:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f70:	8b 00                	mov    (%rax),%eax
  800f72:	89 c0                	mov    %eax,%eax
  800f74:	48 01 d0             	add    %rdx,%rax
  800f77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f7b:	8b 12                	mov    (%rdx),%edx
  800f7d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f84:	89 0a                	mov    %ecx,(%rdx)
  800f86:	eb 17                	jmp    800f9f <getuint+0xb3>
  800f88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f90:	48 89 d0             	mov    %rdx,%rax
  800f93:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f9b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f9f:	48 8b 00             	mov    (%rax),%rax
  800fa2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800fa6:	eb 4e                	jmp    800ff6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fac:	8b 00                	mov    (%rax),%eax
  800fae:	83 f8 30             	cmp    $0x30,%eax
  800fb1:	73 24                	jae    800fd7 <getuint+0xeb>
  800fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fbf:	8b 00                	mov    (%rax),%eax
  800fc1:	89 c0                	mov    %eax,%eax
  800fc3:	48 01 d0             	add    %rdx,%rax
  800fc6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fca:	8b 12                	mov    (%rdx),%edx
  800fcc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fcf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fd3:	89 0a                	mov    %ecx,(%rdx)
  800fd5:	eb 17                	jmp    800fee <getuint+0x102>
  800fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fdf:	48 89 d0             	mov    %rdx,%rax
  800fe2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fe6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fee:	8b 00                	mov    (%rax),%eax
  800ff0:	89 c0                	mov    %eax,%eax
  800ff2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ffa:	c9                   	leaveq 
  800ffb:	c3                   	retq   

0000000000800ffc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ffc:	55                   	push   %rbp
  800ffd:	48 89 e5             	mov    %rsp,%rbp
  801000:	48 83 ec 20          	sub    $0x20,%rsp
  801004:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801008:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80100b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80100f:	7e 52                	jle    801063 <getint+0x67>
		x=va_arg(*ap, long long);
  801011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801015:	8b 00                	mov    (%rax),%eax
  801017:	83 f8 30             	cmp    $0x30,%eax
  80101a:	73 24                	jae    801040 <getint+0x44>
  80101c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801020:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801028:	8b 00                	mov    (%rax),%eax
  80102a:	89 c0                	mov    %eax,%eax
  80102c:	48 01 d0             	add    %rdx,%rax
  80102f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801033:	8b 12                	mov    (%rdx),%edx
  801035:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801038:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80103c:	89 0a                	mov    %ecx,(%rdx)
  80103e:	eb 17                	jmp    801057 <getint+0x5b>
  801040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801044:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801048:	48 89 d0             	mov    %rdx,%rax
  80104b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80104f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801053:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801057:	48 8b 00             	mov    (%rax),%rax
  80105a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80105e:	e9 a3 00 00 00       	jmpq   801106 <getint+0x10a>
	else if (lflag)
  801063:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801067:	74 4f                	je     8010b8 <getint+0xbc>
		x=va_arg(*ap, long);
  801069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106d:	8b 00                	mov    (%rax),%eax
  80106f:	83 f8 30             	cmp    $0x30,%eax
  801072:	73 24                	jae    801098 <getint+0x9c>
  801074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801078:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80107c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801080:	8b 00                	mov    (%rax),%eax
  801082:	89 c0                	mov    %eax,%eax
  801084:	48 01 d0             	add    %rdx,%rax
  801087:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80108b:	8b 12                	mov    (%rdx),%edx
  80108d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801090:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801094:	89 0a                	mov    %ecx,(%rdx)
  801096:	eb 17                	jmp    8010af <getint+0xb3>
  801098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010a0:	48 89 d0             	mov    %rdx,%rax
  8010a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010af:	48 8b 00             	mov    (%rax),%rax
  8010b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8010b6:	eb 4e                	jmp    801106 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	8b 00                	mov    (%rax),%eax
  8010be:	83 f8 30             	cmp    $0x30,%eax
  8010c1:	73 24                	jae    8010e7 <getint+0xeb>
  8010c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cf:	8b 00                	mov    (%rax),%eax
  8010d1:	89 c0                	mov    %eax,%eax
  8010d3:	48 01 d0             	add    %rdx,%rax
  8010d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010da:	8b 12                	mov    (%rdx),%edx
  8010dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010e3:	89 0a                	mov    %ecx,(%rdx)
  8010e5:	eb 17                	jmp    8010fe <getint+0x102>
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010ef:	48 89 d0             	mov    %rdx,%rax
  8010f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010fe:	8b 00                	mov    (%rax),%eax
  801100:	48 98                	cltq   
  801102:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80110a:	c9                   	leaveq 
  80110b:	c3                   	retq   

000000000080110c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80110c:	55                   	push   %rbp
  80110d:	48 89 e5             	mov    %rsp,%rbp
  801110:	41 54                	push   %r12
  801112:	53                   	push   %rbx
  801113:	48 83 ec 60          	sub    $0x60,%rsp
  801117:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80111b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80111f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801123:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801127:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80112b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80112f:	48 8b 0a             	mov    (%rdx),%rcx
  801132:	48 89 08             	mov    %rcx,(%rax)
  801135:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801139:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80113d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801141:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801145:	eb 17                	jmp    80115e <vprintfmt+0x52>
			if (ch == '\0')
  801147:	85 db                	test   %ebx,%ebx
  801149:	0f 84 d7 04 00 00    	je     801626 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  80114f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801153:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801157:	48 89 c6             	mov    %rax,%rsi
  80115a:	89 df                	mov    %ebx,%edi
  80115c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80115e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801162:	0f b6 00             	movzbl (%rax),%eax
  801165:	0f b6 d8             	movzbl %al,%ebx
  801168:	83 fb 25             	cmp    $0x25,%ebx
  80116b:	0f 95 c0             	setne  %al
  80116e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801173:	84 c0                	test   %al,%al
  801175:	75 d0                	jne    801147 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801177:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80117b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801182:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801189:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801190:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  801197:	eb 04                	jmp    80119d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  801199:	90                   	nop
  80119a:	eb 01                	jmp    80119d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80119c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80119d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011a1:	0f b6 00             	movzbl (%rax),%eax
  8011a4:	0f b6 d8             	movzbl %al,%ebx
  8011a7:	89 d8                	mov    %ebx,%eax
  8011a9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8011ae:	83 e8 23             	sub    $0x23,%eax
  8011b1:	83 f8 55             	cmp    $0x55,%eax
  8011b4:	0f 87 38 04 00 00    	ja     8015f2 <vprintfmt+0x4e6>
  8011ba:	89 c0                	mov    %eax,%eax
  8011bc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8011c3:	00 
  8011c4:	48 b8 70 4b 80 00 00 	movabs $0x804b70,%rax
  8011cb:	00 00 00 
  8011ce:	48 01 d0             	add    %rdx,%rax
  8011d1:	48 8b 00             	mov    (%rax),%rax
  8011d4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011d6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8011da:	eb c1                	jmp    80119d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011dc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8011e0:	eb bb                	jmp    80119d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011e9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	01 d8                	add    %ebx,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011fd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801201:	0f b6 00             	movzbl (%rax),%eax
  801204:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801207:	83 fb 2f             	cmp    $0x2f,%ebx
  80120a:	7e 63                	jle    80126f <vprintfmt+0x163>
  80120c:	83 fb 39             	cmp    $0x39,%ebx
  80120f:	7f 5e                	jg     80126f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801211:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801216:	eb d1                	jmp    8011e9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  801218:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80121b:	83 f8 30             	cmp    $0x30,%eax
  80121e:	73 17                	jae    801237 <vprintfmt+0x12b>
  801220:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801224:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801227:	89 c0                	mov    %eax,%eax
  801229:	48 01 d0             	add    %rdx,%rax
  80122c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80122f:	83 c2 08             	add    $0x8,%edx
  801232:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801235:	eb 0f                	jmp    801246 <vprintfmt+0x13a>
  801237:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80123b:	48 89 d0             	mov    %rdx,%rax
  80123e:	48 83 c2 08          	add    $0x8,%rdx
  801242:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801246:	8b 00                	mov    (%rax),%eax
  801248:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80124b:	eb 23                	jmp    801270 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  80124d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801251:	0f 89 42 ff ff ff    	jns    801199 <vprintfmt+0x8d>
				width = 0;
  801257:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80125e:	e9 36 ff ff ff       	jmpq   801199 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801263:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80126a:	e9 2e ff ff ff       	jmpq   80119d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80126f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801270:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801274:	0f 89 22 ff ff ff    	jns    80119c <vprintfmt+0x90>
				width = precision, precision = -1;
  80127a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80127d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801280:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801287:	e9 10 ff ff ff       	jmpq   80119c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80128c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801290:	e9 08 ff ff ff       	jmpq   80119d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801295:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801298:	83 f8 30             	cmp    $0x30,%eax
  80129b:	73 17                	jae    8012b4 <vprintfmt+0x1a8>
  80129d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a4:	89 c0                	mov    %eax,%eax
  8012a6:	48 01 d0             	add    %rdx,%rax
  8012a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012ac:	83 c2 08             	add    $0x8,%edx
  8012af:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012b2:	eb 0f                	jmp    8012c3 <vprintfmt+0x1b7>
  8012b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012b8:	48 89 d0             	mov    %rdx,%rax
  8012bb:	48 83 c2 08          	add    $0x8,%rdx
  8012bf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012c3:	8b 00                	mov    (%rax),%eax
  8012c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012c9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8012cd:	48 89 d6             	mov    %rdx,%rsi
  8012d0:	89 c7                	mov    %eax,%edi
  8012d2:	ff d1                	callq  *%rcx
			break;
  8012d4:	e9 47 03 00 00       	jmpq   801620 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8012d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012dc:	83 f8 30             	cmp    $0x30,%eax
  8012df:	73 17                	jae    8012f8 <vprintfmt+0x1ec>
  8012e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012e8:	89 c0                	mov    %eax,%eax
  8012ea:	48 01 d0             	add    %rdx,%rax
  8012ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012f0:	83 c2 08             	add    $0x8,%edx
  8012f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012f6:	eb 0f                	jmp    801307 <vprintfmt+0x1fb>
  8012f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012fc:	48 89 d0             	mov    %rdx,%rax
  8012ff:	48 83 c2 08          	add    $0x8,%rdx
  801303:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801307:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801309:	85 db                	test   %ebx,%ebx
  80130b:	79 02                	jns    80130f <vprintfmt+0x203>
				err = -err;
  80130d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80130f:	83 fb 10             	cmp    $0x10,%ebx
  801312:	7f 16                	jg     80132a <vprintfmt+0x21e>
  801314:	48 b8 c0 4a 80 00 00 	movabs $0x804ac0,%rax
  80131b:	00 00 00 
  80131e:	48 63 d3             	movslq %ebx,%rdx
  801321:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801325:	4d 85 e4             	test   %r12,%r12
  801328:	75 2e                	jne    801358 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80132a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80132e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801332:	89 d9                	mov    %ebx,%ecx
  801334:	48 ba 59 4b 80 00 00 	movabs $0x804b59,%rdx
  80133b:	00 00 00 
  80133e:	48 89 c7             	mov    %rax,%rdi
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
  801346:	49 b8 30 16 80 00 00 	movabs $0x801630,%r8
  80134d:	00 00 00 
  801350:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801353:	e9 c8 02 00 00       	jmpq   801620 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801358:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80135c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801360:	4c 89 e1             	mov    %r12,%rcx
  801363:	48 ba 62 4b 80 00 00 	movabs $0x804b62,%rdx
  80136a:	00 00 00 
  80136d:	48 89 c7             	mov    %rax,%rdi
  801370:	b8 00 00 00 00       	mov    $0x0,%eax
  801375:	49 b8 30 16 80 00 00 	movabs $0x801630,%r8
  80137c:	00 00 00 
  80137f:	41 ff d0             	callq  *%r8
			break;
  801382:	e9 99 02 00 00       	jmpq   801620 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801387:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80138a:	83 f8 30             	cmp    $0x30,%eax
  80138d:	73 17                	jae    8013a6 <vprintfmt+0x29a>
  80138f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801393:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801396:	89 c0                	mov    %eax,%eax
  801398:	48 01 d0             	add    %rdx,%rax
  80139b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80139e:	83 c2 08             	add    $0x8,%edx
  8013a1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013a4:	eb 0f                	jmp    8013b5 <vprintfmt+0x2a9>
  8013a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013aa:	48 89 d0             	mov    %rdx,%rax
  8013ad:	48 83 c2 08          	add    $0x8,%rdx
  8013b1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013b5:	4c 8b 20             	mov    (%rax),%r12
  8013b8:	4d 85 e4             	test   %r12,%r12
  8013bb:	75 0a                	jne    8013c7 <vprintfmt+0x2bb>
				p = "(null)";
  8013bd:	49 bc 65 4b 80 00 00 	movabs $0x804b65,%r12
  8013c4:	00 00 00 
			if (width > 0 && padc != '-')
  8013c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013cb:	7e 7a                	jle    801447 <vprintfmt+0x33b>
  8013cd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8013d1:	74 74                	je     801447 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8013d6:	48 98                	cltq   
  8013d8:	48 89 c6             	mov    %rax,%rsi
  8013db:	4c 89 e7             	mov    %r12,%rdi
  8013de:	48 b8 da 18 80 00 00 	movabs $0x8018da,%rax
  8013e5:	00 00 00 
  8013e8:	ff d0                	callq  *%rax
  8013ea:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013ed:	eb 17                	jmp    801406 <vprintfmt+0x2fa>
					putch(padc, putdat);
  8013ef:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8013f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013f7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8013fb:	48 89 d6             	mov    %rdx,%rsi
  8013fe:	89 c7                	mov    %eax,%edi
  801400:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801402:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801406:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80140a:	7f e3                	jg     8013ef <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80140c:	eb 39                	jmp    801447 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  80140e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801412:	74 1e                	je     801432 <vprintfmt+0x326>
  801414:	83 fb 1f             	cmp    $0x1f,%ebx
  801417:	7e 05                	jle    80141e <vprintfmt+0x312>
  801419:	83 fb 7e             	cmp    $0x7e,%ebx
  80141c:	7e 14                	jle    801432 <vprintfmt+0x326>
					putch('?', putdat);
  80141e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801422:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801426:	48 89 c6             	mov    %rax,%rsi
  801429:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80142e:	ff d2                	callq  *%rdx
  801430:	eb 0f                	jmp    801441 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801432:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801436:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80143a:	48 89 c6             	mov    %rax,%rsi
  80143d:	89 df                	mov    %ebx,%edi
  80143f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801441:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801445:	eb 01                	jmp    801448 <vprintfmt+0x33c>
  801447:	90                   	nop
  801448:	41 0f b6 04 24       	movzbl (%r12),%eax
  80144d:	0f be d8             	movsbl %al,%ebx
  801450:	85 db                	test   %ebx,%ebx
  801452:	0f 95 c0             	setne  %al
  801455:	49 83 c4 01          	add    $0x1,%r12
  801459:	84 c0                	test   %al,%al
  80145b:	74 28                	je     801485 <vprintfmt+0x379>
  80145d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801461:	78 ab                	js     80140e <vprintfmt+0x302>
  801463:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801467:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80146b:	79 a1                	jns    80140e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80146d:	eb 16                	jmp    801485 <vprintfmt+0x379>
				putch(' ', putdat);
  80146f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801473:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801477:	48 89 c6             	mov    %rax,%rsi
  80147a:	bf 20 00 00 00       	mov    $0x20,%edi
  80147f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801481:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801485:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801489:	7f e4                	jg     80146f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80148b:	e9 90 01 00 00       	jmpq   801620 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801490:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801494:	be 03 00 00 00       	mov    $0x3,%esi
  801499:	48 89 c7             	mov    %rax,%rdi
  80149c:	48 b8 fc 0f 80 00 00 	movabs $0x800ffc,%rax
  8014a3:	00 00 00 
  8014a6:	ff d0                	callq  *%rax
  8014a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b0:	48 85 c0             	test   %rax,%rax
  8014b3:	79 1d                	jns    8014d2 <vprintfmt+0x3c6>
				putch('-', putdat);
  8014b5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8014b9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8014bd:	48 89 c6             	mov    %rax,%rsi
  8014c0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8014c5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8014c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cb:	48 f7 d8             	neg    %rax
  8014ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8014d2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014d9:	e9 d5 00 00 00       	jmpq   8015b3 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8014de:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014e2:	be 03 00 00 00       	mov    $0x3,%esi
  8014e7:	48 89 c7             	mov    %rax,%rdi
  8014ea:	48 b8 ec 0e 80 00 00 	movabs $0x800eec,%rax
  8014f1:	00 00 00 
  8014f4:	ff d0                	callq  *%rax
  8014f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014fa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801501:	e9 ad 00 00 00       	jmpq   8015b3 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  801506:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80150a:	be 03 00 00 00       	mov    $0x3,%esi
  80150f:	48 89 c7             	mov    %rax,%rdi
  801512:	48 b8 ec 0e 80 00 00 	movabs $0x800eec,%rax
  801519:	00 00 00 
  80151c:	ff d0                	callq  *%rax
  80151e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  801522:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801529:	e9 85 00 00 00       	jmpq   8015b3 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  80152e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801532:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801536:	48 89 c6             	mov    %rax,%rsi
  801539:	bf 30 00 00 00       	mov    $0x30,%edi
  80153e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801540:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801544:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801548:	48 89 c6             	mov    %rax,%rsi
  80154b:	bf 78 00 00 00       	mov    $0x78,%edi
  801550:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801552:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801555:	83 f8 30             	cmp    $0x30,%eax
  801558:	73 17                	jae    801571 <vprintfmt+0x465>
  80155a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80155e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801561:	89 c0                	mov    %eax,%eax
  801563:	48 01 d0             	add    %rdx,%rax
  801566:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801569:	83 c2 08             	add    $0x8,%edx
  80156c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80156f:	eb 0f                	jmp    801580 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  801571:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801575:	48 89 d0             	mov    %rdx,%rax
  801578:	48 83 c2 08          	add    $0x8,%rdx
  80157c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801580:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801583:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801587:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80158e:	eb 23                	jmp    8015b3 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801590:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801594:	be 03 00 00 00       	mov    $0x3,%esi
  801599:	48 89 c7             	mov    %rax,%rdi
  80159c:	48 b8 ec 0e 80 00 00 	movabs $0x800eec,%rax
  8015a3:	00 00 00 
  8015a6:	ff d0                	callq  *%rax
  8015a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8015ac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015b3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8015b8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8015bb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8015be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8015c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015ca:	45 89 c1             	mov    %r8d,%r9d
  8015cd:	41 89 f8             	mov    %edi,%r8d
  8015d0:	48 89 c7             	mov    %rax,%rdi
  8015d3:	48 b8 34 0e 80 00 00 	movabs $0x800e34,%rax
  8015da:	00 00 00 
  8015dd:	ff d0                	callq  *%rax
			break;
  8015df:	eb 3f                	jmp    801620 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015e1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8015e5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8015e9:	48 89 c6             	mov    %rax,%rsi
  8015ec:	89 df                	mov    %ebx,%edi
  8015ee:	ff d2                	callq  *%rdx
			break;
  8015f0:	eb 2e                	jmp    801620 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015f2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8015f6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8015fa:	48 89 c6             	mov    %rax,%rsi
  8015fd:	bf 25 00 00 00       	mov    $0x25,%edi
  801602:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801604:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801609:	eb 05                	jmp    801610 <vprintfmt+0x504>
  80160b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801610:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801614:	48 83 e8 01          	sub    $0x1,%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3c 25                	cmp    $0x25,%al
  80161d:	75 ec                	jne    80160b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  80161f:	90                   	nop
		}
	}
  801620:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801621:	e9 38 fb ff ff       	jmpq   80115e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801626:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  801627:	48 83 c4 60          	add    $0x60,%rsp
  80162b:	5b                   	pop    %rbx
  80162c:	41 5c                	pop    %r12
  80162e:	5d                   	pop    %rbp
  80162f:	c3                   	retq   

0000000000801630 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801630:	55                   	push   %rbp
  801631:	48 89 e5             	mov    %rsp,%rbp
  801634:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80163b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801642:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801649:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801650:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801657:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80165e:	84 c0                	test   %al,%al
  801660:	74 20                	je     801682 <printfmt+0x52>
  801662:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801666:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80166a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80166e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801672:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801676:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80167a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80167e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801682:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801689:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801690:	00 00 00 
  801693:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80169a:	00 00 00 
  80169d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8016a1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8016a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8016af:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8016b6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8016bd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8016c4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8016cb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8016d2:	48 89 c7             	mov    %rax,%rdi
  8016d5:	48 b8 0c 11 80 00 00 	movabs $0x80110c,%rax
  8016dc:	00 00 00 
  8016df:	ff d0                	callq  *%rax
	va_end(ap);
}
  8016e1:	c9                   	leaveq 
  8016e2:	c3                   	retq   

00000000008016e3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016e3:	55                   	push   %rbp
  8016e4:	48 89 e5             	mov    %rsp,%rbp
  8016e7:	48 83 ec 10          	sub    $0x10,%rsp
  8016eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f6:	8b 40 10             	mov    0x10(%rax),%eax
  8016f9:	8d 50 01             	lea    0x1(%rax),%edx
  8016fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801700:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801707:	48 8b 10             	mov    (%rax),%rdx
  80170a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801712:	48 39 c2             	cmp    %rax,%rdx
  801715:	73 17                	jae    80172e <sprintputch+0x4b>
		*b->buf++ = ch;
  801717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171b:	48 8b 00             	mov    (%rax),%rax
  80171e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801721:	88 10                	mov    %dl,(%rax)
  801723:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172b:	48 89 10             	mov    %rdx,(%rax)
}
  80172e:	c9                   	leaveq 
  80172f:	c3                   	retq   

0000000000801730 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801730:	55                   	push   %rbp
  801731:	48 89 e5             	mov    %rsp,%rbp
  801734:	48 83 ec 50          	sub    $0x50,%rsp
  801738:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80173c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80173f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801743:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801747:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80174b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80174f:	48 8b 0a             	mov    (%rdx),%rcx
  801752:	48 89 08             	mov    %rcx,(%rax)
  801755:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801759:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80175d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801761:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801765:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801769:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80176d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801770:	48 98                	cltq   
  801772:	48 83 e8 01          	sub    $0x1,%rax
  801776:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80177a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80177e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801785:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80178a:	74 06                	je     801792 <vsnprintf+0x62>
  80178c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801790:	7f 07                	jg     801799 <vsnprintf+0x69>
		return -E_INVAL;
  801792:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801797:	eb 2f                	jmp    8017c8 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801799:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80179d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8017a1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8017a5:	48 89 c6             	mov    %rax,%rsi
  8017a8:	48 bf e3 16 80 00 00 	movabs $0x8016e3,%rdi
  8017af:	00 00 00 
  8017b2:	48 b8 0c 11 80 00 00 	movabs $0x80110c,%rax
  8017b9:	00 00 00 
  8017bc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8017be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017c2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8017c5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8017c8:	c9                   	leaveq 
  8017c9:	c3                   	retq   

00000000008017ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017ca:	55                   	push   %rbp
  8017cb:	48 89 e5             	mov    %rsp,%rbp
  8017ce:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8017d5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8017dc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8017e2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017e9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017f0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017f7:	84 c0                	test   %al,%al
  8017f9:	74 20                	je     80181b <snprintf+0x51>
  8017fb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017ff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801803:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801807:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80180b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80180f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801813:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801817:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80181b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801822:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801829:	00 00 00 
  80182c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801833:	00 00 00 
  801836:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80183a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801841:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801848:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80184f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801856:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80185d:	48 8b 0a             	mov    (%rdx),%rcx
  801860:	48 89 08             	mov    %rcx,(%rax)
  801863:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801867:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80186b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80186f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801873:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80187a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801881:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801887:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80188e:	48 89 c7             	mov    %rax,%rdi
  801891:	48 b8 30 17 80 00 00 	movabs $0x801730,%rax
  801898:	00 00 00 
  80189b:	ff d0                	callq  *%rax
  80189d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8018a3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8018a9:	c9                   	leaveq 
  8018aa:	c3                   	retq   
	...

00000000008018ac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018ac:	55                   	push   %rbp
  8018ad:	48 89 e5             	mov    %rsp,%rbp
  8018b0:	48 83 ec 18          	sub    $0x18,%rsp
  8018b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018bf:	eb 09                	jmp    8018ca <strlen+0x1e>
		n++;
  8018c1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018c5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ce:	0f b6 00             	movzbl (%rax),%eax
  8018d1:	84 c0                	test   %al,%al
  8018d3:	75 ec                	jne    8018c1 <strlen+0x15>
		n++;
	return n;
  8018d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018d8:	c9                   	leaveq 
  8018d9:	c3                   	retq   

00000000008018da <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018da:	55                   	push   %rbp
  8018db:	48 89 e5             	mov    %rsp,%rbp
  8018de:	48 83 ec 20          	sub    $0x20,%rsp
  8018e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018f1:	eb 0e                	jmp    801901 <strnlen+0x27>
		n++;
  8018f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018f7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018fc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801901:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801906:	74 0b                	je     801913 <strnlen+0x39>
  801908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80190c:	0f b6 00             	movzbl (%rax),%eax
  80190f:	84 c0                	test   %al,%al
  801911:	75 e0                	jne    8018f3 <strnlen+0x19>
		n++;
	return n;
  801913:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801916:	c9                   	leaveq 
  801917:	c3                   	retq   

0000000000801918 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801918:	55                   	push   %rbp
  801919:	48 89 e5             	mov    %rsp,%rbp
  80191c:	48 83 ec 20          	sub    $0x20,%rsp
  801920:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801924:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80192c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801930:	90                   	nop
  801931:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801935:	0f b6 10             	movzbl (%rax),%edx
  801938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80193c:	88 10                	mov    %dl,(%rax)
  80193e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801942:	0f b6 00             	movzbl (%rax),%eax
  801945:	84 c0                	test   %al,%al
  801947:	0f 95 c0             	setne  %al
  80194a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80194f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801954:	84 c0                	test   %al,%al
  801956:	75 d9                	jne    801931 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801958:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80195c:	c9                   	leaveq 
  80195d:	c3                   	retq   

000000000080195e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	48 83 ec 20          	sub    $0x20,%rsp
  801966:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80196a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80196e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801972:	48 89 c7             	mov    %rax,%rdi
  801975:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  80197c:	00 00 00 
  80197f:	ff d0                	callq  *%rax
  801981:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801984:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801987:	48 98                	cltq   
  801989:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80198d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801991:	48 89 d6             	mov    %rdx,%rsi
  801994:	48 89 c7             	mov    %rax,%rdi
  801997:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  80199e:	00 00 00 
  8019a1:	ff d0                	callq  *%rax
	return dst;
  8019a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019a7:	c9                   	leaveq 
  8019a8:	c3                   	retq   

00000000008019a9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	48 83 ec 28          	sub    $0x28,%rsp
  8019b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8019bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8019c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019cc:	00 
  8019cd:	eb 27                	jmp    8019f6 <strncpy+0x4d>
		*dst++ = *src;
  8019cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019d3:	0f b6 10             	movzbl (%rax),%edx
  8019d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019da:	88 10                	mov    %dl,(%rax)
  8019dc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8019e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019e5:	0f b6 00             	movzbl (%rax),%eax
  8019e8:	84 c0                	test   %al,%al
  8019ea:	74 05                	je     8019f1 <strncpy+0x48>
			src++;
  8019ec:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019fe:	72 cf                	jb     8019cf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801a00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a04:	c9                   	leaveq 
  801a05:	c3                   	retq   

0000000000801a06 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801a06:	55                   	push   %rbp
  801a07:	48 89 e5             	mov    %rsp,%rbp
  801a0a:	48 83 ec 28          	sub    $0x28,%rsp
  801a0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a16:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801a22:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a27:	74 37                	je     801a60 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801a29:	eb 17                	jmp    801a42 <strlcpy+0x3c>
			*dst++ = *src++;
  801a2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a2f:	0f b6 10             	movzbl (%rax),%edx
  801a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a36:	88 10                	mov    %dl,(%rax)
  801a38:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a3d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a42:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a47:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a4c:	74 0b                	je     801a59 <strlcpy+0x53>
  801a4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a52:	0f b6 00             	movzbl (%rax),%eax
  801a55:	84 c0                	test   %al,%al
  801a57:	75 d2                	jne    801a2b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a5d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a68:	48 89 d1             	mov    %rdx,%rcx
  801a6b:	48 29 c1             	sub    %rax,%rcx
  801a6e:	48 89 c8             	mov    %rcx,%rax
}
  801a71:	c9                   	leaveq 
  801a72:	c3                   	retq   

0000000000801a73 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a73:	55                   	push   %rbp
  801a74:	48 89 e5             	mov    %rsp,%rbp
  801a77:	48 83 ec 10          	sub    $0x10,%rsp
  801a7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a83:	eb 0a                	jmp    801a8f <strcmp+0x1c>
		p++, q++;
  801a85:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a8a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a93:	0f b6 00             	movzbl (%rax),%eax
  801a96:	84 c0                	test   %al,%al
  801a98:	74 12                	je     801aac <strcmp+0x39>
  801a9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9e:	0f b6 10             	movzbl (%rax),%edx
  801aa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa5:	0f b6 00             	movzbl (%rax),%eax
  801aa8:	38 c2                	cmp    %al,%dl
  801aaa:	74 d9                	je     801a85 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801aac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab0:	0f b6 00             	movzbl (%rax),%eax
  801ab3:	0f b6 d0             	movzbl %al,%edx
  801ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aba:	0f b6 00             	movzbl (%rax),%eax
  801abd:	0f b6 c0             	movzbl %al,%eax
  801ac0:	89 d1                	mov    %edx,%ecx
  801ac2:	29 c1                	sub    %eax,%ecx
  801ac4:	89 c8                	mov    %ecx,%eax
}
  801ac6:	c9                   	leaveq 
  801ac7:	c3                   	retq   

0000000000801ac8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801ac8:	55                   	push   %rbp
  801ac9:	48 89 e5             	mov    %rsp,%rbp
  801acc:	48 83 ec 18          	sub    $0x18,%rsp
  801ad0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ad4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ad8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801adc:	eb 0f                	jmp    801aed <strncmp+0x25>
		n--, p++, q++;
  801ade:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801ae3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ae8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801aed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801af2:	74 1d                	je     801b11 <strncmp+0x49>
  801af4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af8:	0f b6 00             	movzbl (%rax),%eax
  801afb:	84 c0                	test   %al,%al
  801afd:	74 12                	je     801b11 <strncmp+0x49>
  801aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b03:	0f b6 10             	movzbl (%rax),%edx
  801b06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b0a:	0f b6 00             	movzbl (%rax),%eax
  801b0d:	38 c2                	cmp    %al,%dl
  801b0f:	74 cd                	je     801ade <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801b11:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b16:	75 07                	jne    801b1f <strncmp+0x57>
		return 0;
  801b18:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1d:	eb 1a                	jmp    801b39 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801b1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b23:	0f b6 00             	movzbl (%rax),%eax
  801b26:	0f b6 d0             	movzbl %al,%edx
  801b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b2d:	0f b6 00             	movzbl (%rax),%eax
  801b30:	0f b6 c0             	movzbl %al,%eax
  801b33:	89 d1                	mov    %edx,%ecx
  801b35:	29 c1                	sub    %eax,%ecx
  801b37:	89 c8                	mov    %ecx,%eax
}
  801b39:	c9                   	leaveq 
  801b3a:	c3                   	retq   

0000000000801b3b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b3b:	55                   	push   %rbp
  801b3c:	48 89 e5             	mov    %rsp,%rbp
  801b3f:	48 83 ec 10          	sub    $0x10,%rsp
  801b43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b47:	89 f0                	mov    %esi,%eax
  801b49:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b4c:	eb 17                	jmp    801b65 <strchr+0x2a>
		if (*s == c)
  801b4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b52:	0f b6 00             	movzbl (%rax),%eax
  801b55:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b58:	75 06                	jne    801b60 <strchr+0x25>
			return (char *) s;
  801b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5e:	eb 15                	jmp    801b75 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b60:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b69:	0f b6 00             	movzbl (%rax),%eax
  801b6c:	84 c0                	test   %al,%al
  801b6e:	75 de                	jne    801b4e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b75:	c9                   	leaveq 
  801b76:	c3                   	retq   

0000000000801b77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b77:	55                   	push   %rbp
  801b78:	48 89 e5             	mov    %rsp,%rbp
  801b7b:	48 83 ec 10          	sub    $0x10,%rsp
  801b7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b83:	89 f0                	mov    %esi,%eax
  801b85:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b88:	eb 11                	jmp    801b9b <strfind+0x24>
		if (*s == c)
  801b8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b8e:	0f b6 00             	movzbl (%rax),%eax
  801b91:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b94:	74 12                	je     801ba8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b96:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9f:	0f b6 00             	movzbl (%rax),%eax
  801ba2:	84 c0                	test   %al,%al
  801ba4:	75 e4                	jne    801b8a <strfind+0x13>
  801ba6:	eb 01                	jmp    801ba9 <strfind+0x32>
		if (*s == c)
			break;
  801ba8:	90                   	nop
	return (char *) s;
  801ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801bad:	c9                   	leaveq 
  801bae:	c3                   	retq   

0000000000801baf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801baf:	55                   	push   %rbp
  801bb0:	48 89 e5             	mov    %rsp,%rbp
  801bb3:	48 83 ec 18          	sub    $0x18,%rsp
  801bb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bbb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801bbe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801bc2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bc7:	75 06                	jne    801bcf <memset+0x20>
		return v;
  801bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcd:	eb 69                	jmp    801c38 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801bcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd3:	83 e0 03             	and    $0x3,%eax
  801bd6:	48 85 c0             	test   %rax,%rax
  801bd9:	75 48                	jne    801c23 <memset+0x74>
  801bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdf:	83 e0 03             	and    $0x3,%eax
  801be2:	48 85 c0             	test   %rax,%rax
  801be5:	75 3c                	jne    801c23 <memset+0x74>
		c &= 0xFF;
  801be7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801bee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf1:	89 c2                	mov    %eax,%edx
  801bf3:	c1 e2 18             	shl    $0x18,%edx
  801bf6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf9:	c1 e0 10             	shl    $0x10,%eax
  801bfc:	09 c2                	or     %eax,%edx
  801bfe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c01:	c1 e0 08             	shl    $0x8,%eax
  801c04:	09 d0                	or     %edx,%eax
  801c06:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0d:	48 89 c1             	mov    %rax,%rcx
  801c10:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801c14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c18:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c1b:	48 89 d7             	mov    %rdx,%rdi
  801c1e:	fc                   	cld    
  801c1f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801c21:	eb 11                	jmp    801c34 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801c23:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c27:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c2a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c2e:	48 89 d7             	mov    %rdx,%rdi
  801c31:	fc                   	cld    
  801c32:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801c34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c38:	c9                   	leaveq 
  801c39:	c3                   	retq   

0000000000801c3a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801c3a:	55                   	push   %rbp
  801c3b:	48 89 e5             	mov    %rsp,%rbp
  801c3e:	48 83 ec 28          	sub    $0x28,%rsp
  801c42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c62:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c66:	0f 83 88 00 00 00    	jae    801cf4 <memmove+0xba>
  801c6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c74:	48 01 d0             	add    %rdx,%rax
  801c77:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c7b:	76 77                	jbe    801cf4 <memmove+0xba>
		s += n;
  801c7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c81:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c89:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c91:	83 e0 03             	and    $0x3,%eax
  801c94:	48 85 c0             	test   %rax,%rax
  801c97:	75 3b                	jne    801cd4 <memmove+0x9a>
  801c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9d:	83 e0 03             	and    $0x3,%eax
  801ca0:	48 85 c0             	test   %rax,%rax
  801ca3:	75 2f                	jne    801cd4 <memmove+0x9a>
  801ca5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca9:	83 e0 03             	and    $0x3,%eax
  801cac:	48 85 c0             	test   %rax,%rax
  801caf:	75 23                	jne    801cd4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801cb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb5:	48 83 e8 04          	sub    $0x4,%rax
  801cb9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cbd:	48 83 ea 04          	sub    $0x4,%rdx
  801cc1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801cc5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801cc9:	48 89 c7             	mov    %rax,%rdi
  801ccc:	48 89 d6             	mov    %rdx,%rsi
  801ccf:	fd                   	std    
  801cd0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cd2:	eb 1d                	jmp    801cf1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801cd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ce4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce8:	48 89 d7             	mov    %rdx,%rdi
  801ceb:	48 89 c1             	mov    %rax,%rcx
  801cee:	fd                   	std    
  801cef:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cf1:	fc                   	cld    
  801cf2:	eb 57                	jmp    801d4b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf8:	83 e0 03             	and    $0x3,%eax
  801cfb:	48 85 c0             	test   %rax,%rax
  801cfe:	75 36                	jne    801d36 <memmove+0xfc>
  801d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d04:	83 e0 03             	and    $0x3,%eax
  801d07:	48 85 c0             	test   %rax,%rax
  801d0a:	75 2a                	jne    801d36 <memmove+0xfc>
  801d0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d10:	83 e0 03             	and    $0x3,%eax
  801d13:	48 85 c0             	test   %rax,%rax
  801d16:	75 1e                	jne    801d36 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1c:	48 89 c1             	mov    %rax,%rcx
  801d1f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801d23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d27:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d2b:	48 89 c7             	mov    %rax,%rdi
  801d2e:	48 89 d6             	mov    %rdx,%rsi
  801d31:	fc                   	cld    
  801d32:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d34:	eb 15                	jmp    801d4b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d3e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d42:	48 89 c7             	mov    %rax,%rdi
  801d45:	48 89 d6             	mov    %rdx,%rsi
  801d48:	fc                   	cld    
  801d49:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d4f:	c9                   	leaveq 
  801d50:	c3                   	retq   

0000000000801d51 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d51:	55                   	push   %rbp
  801d52:	48 89 e5             	mov    %rsp,%rbp
  801d55:	48 83 ec 18          	sub    $0x18,%rsp
  801d59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d61:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d69:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d71:	48 89 ce             	mov    %rcx,%rsi
  801d74:	48 89 c7             	mov    %rax,%rdi
  801d77:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  801d7e:	00 00 00 
  801d81:	ff d0                	callq  *%rax
}
  801d83:	c9                   	leaveq 
  801d84:	c3                   	retq   

0000000000801d85 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d85:	55                   	push   %rbp
  801d86:	48 89 e5             	mov    %rsp,%rbp
  801d89:	48 83 ec 28          	sub    $0x28,%rsp
  801d8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d95:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801da1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801da5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801da9:	eb 38                	jmp    801de3 <memcmp+0x5e>
		if (*s1 != *s2)
  801dab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801daf:	0f b6 10             	movzbl (%rax),%edx
  801db2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db6:	0f b6 00             	movzbl (%rax),%eax
  801db9:	38 c2                	cmp    %al,%dl
  801dbb:	74 1c                	je     801dd9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc1:	0f b6 00             	movzbl (%rax),%eax
  801dc4:	0f b6 d0             	movzbl %al,%edx
  801dc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dcb:	0f b6 00             	movzbl (%rax),%eax
  801dce:	0f b6 c0             	movzbl %al,%eax
  801dd1:	89 d1                	mov    %edx,%ecx
  801dd3:	29 c1                	sub    %eax,%ecx
  801dd5:	89 c8                	mov    %ecx,%eax
  801dd7:	eb 20                	jmp    801df9 <memcmp+0x74>
		s1++, s2++;
  801dd9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801dde:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801de3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801de8:	0f 95 c0             	setne  %al
  801deb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801df0:	84 c0                	test   %al,%al
  801df2:	75 b7                	jne    801dab <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df9:	c9                   	leaveq 
  801dfa:	c3                   	retq   

0000000000801dfb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dfb:	55                   	push   %rbp
  801dfc:	48 89 e5             	mov    %rsp,%rbp
  801dff:	48 83 ec 28          	sub    $0x28,%rsp
  801e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e07:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801e0a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801e0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e16:	48 01 d0             	add    %rdx,%rax
  801e19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801e1d:	eb 13                	jmp    801e32 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e23:	0f b6 10             	movzbl (%rax),%edx
  801e26:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e29:	38 c2                	cmp    %al,%dl
  801e2b:	74 11                	je     801e3e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e2d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e36:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801e3a:	72 e3                	jb     801e1f <memfind+0x24>
  801e3c:	eb 01                	jmp    801e3f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801e3e:	90                   	nop
	return (void *) s;
  801e3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e43:	c9                   	leaveq 
  801e44:	c3                   	retq   

0000000000801e45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e45:	55                   	push   %rbp
  801e46:	48 89 e5             	mov    %rsp,%rbp
  801e49:	48 83 ec 38          	sub    $0x38,%rsp
  801e4d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e51:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e55:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e5f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e66:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e67:	eb 05                	jmp    801e6e <strtol+0x29>
		s++;
  801e69:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e72:	0f b6 00             	movzbl (%rax),%eax
  801e75:	3c 20                	cmp    $0x20,%al
  801e77:	74 f0                	je     801e69 <strtol+0x24>
  801e79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7d:	0f b6 00             	movzbl (%rax),%eax
  801e80:	3c 09                	cmp    $0x9,%al
  801e82:	74 e5                	je     801e69 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e88:	0f b6 00             	movzbl (%rax),%eax
  801e8b:	3c 2b                	cmp    $0x2b,%al
  801e8d:	75 07                	jne    801e96 <strtol+0x51>
		s++;
  801e8f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e94:	eb 17                	jmp    801ead <strtol+0x68>
	else if (*s == '-')
  801e96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9a:	0f b6 00             	movzbl (%rax),%eax
  801e9d:	3c 2d                	cmp    $0x2d,%al
  801e9f:	75 0c                	jne    801ead <strtol+0x68>
		s++, neg = 1;
  801ea1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ea6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ead:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eb1:	74 06                	je     801eb9 <strtol+0x74>
  801eb3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801eb7:	75 28                	jne    801ee1 <strtol+0x9c>
  801eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebd:	0f b6 00             	movzbl (%rax),%eax
  801ec0:	3c 30                	cmp    $0x30,%al
  801ec2:	75 1d                	jne    801ee1 <strtol+0x9c>
  801ec4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec8:	48 83 c0 01          	add    $0x1,%rax
  801ecc:	0f b6 00             	movzbl (%rax),%eax
  801ecf:	3c 78                	cmp    $0x78,%al
  801ed1:	75 0e                	jne    801ee1 <strtol+0x9c>
		s += 2, base = 16;
  801ed3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801ed8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801edf:	eb 2c                	jmp    801f0d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801ee1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ee5:	75 19                	jne    801f00 <strtol+0xbb>
  801ee7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eeb:	0f b6 00             	movzbl (%rax),%eax
  801eee:	3c 30                	cmp    $0x30,%al
  801ef0:	75 0e                	jne    801f00 <strtol+0xbb>
		s++, base = 8;
  801ef2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ef7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801efe:	eb 0d                	jmp    801f0d <strtol+0xc8>
	else if (base == 0)
  801f00:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801f04:	75 07                	jne    801f0d <strtol+0xc8>
		base = 10;
  801f06:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801f0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f11:	0f b6 00             	movzbl (%rax),%eax
  801f14:	3c 2f                	cmp    $0x2f,%al
  801f16:	7e 1d                	jle    801f35 <strtol+0xf0>
  801f18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1c:	0f b6 00             	movzbl (%rax),%eax
  801f1f:	3c 39                	cmp    $0x39,%al
  801f21:	7f 12                	jg     801f35 <strtol+0xf0>
			dig = *s - '0';
  801f23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f27:	0f b6 00             	movzbl (%rax),%eax
  801f2a:	0f be c0             	movsbl %al,%eax
  801f2d:	83 e8 30             	sub    $0x30,%eax
  801f30:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f33:	eb 4e                	jmp    801f83 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801f35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f39:	0f b6 00             	movzbl (%rax),%eax
  801f3c:	3c 60                	cmp    $0x60,%al
  801f3e:	7e 1d                	jle    801f5d <strtol+0x118>
  801f40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f44:	0f b6 00             	movzbl (%rax),%eax
  801f47:	3c 7a                	cmp    $0x7a,%al
  801f49:	7f 12                	jg     801f5d <strtol+0x118>
			dig = *s - 'a' + 10;
  801f4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4f:	0f b6 00             	movzbl (%rax),%eax
  801f52:	0f be c0             	movsbl %al,%eax
  801f55:	83 e8 57             	sub    $0x57,%eax
  801f58:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f5b:	eb 26                	jmp    801f83 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f61:	0f b6 00             	movzbl (%rax),%eax
  801f64:	3c 40                	cmp    $0x40,%al
  801f66:	7e 47                	jle    801faf <strtol+0x16a>
  801f68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6c:	0f b6 00             	movzbl (%rax),%eax
  801f6f:	3c 5a                	cmp    $0x5a,%al
  801f71:	7f 3c                	jg     801faf <strtol+0x16a>
			dig = *s - 'A' + 10;
  801f73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f77:	0f b6 00             	movzbl (%rax),%eax
  801f7a:	0f be c0             	movsbl %al,%eax
  801f7d:	83 e8 37             	sub    $0x37,%eax
  801f80:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f86:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f89:	7d 23                	jge    801fae <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801f8b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f90:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f93:	48 98                	cltq   
  801f95:	48 89 c2             	mov    %rax,%rdx
  801f98:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801f9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fa0:	48 98                	cltq   
  801fa2:	48 01 d0             	add    %rdx,%rax
  801fa5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801fa9:	e9 5f ff ff ff       	jmpq   801f0d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801fae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801faf:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801fb4:	74 0b                	je     801fc1 <strtol+0x17c>
		*endptr = (char *) s;
  801fb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fbe:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801fc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc5:	74 09                	je     801fd0 <strtol+0x18b>
  801fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fcb:	48 f7 d8             	neg    %rax
  801fce:	eb 04                	jmp    801fd4 <strtol+0x18f>
  801fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801fd4:	c9                   	leaveq 
  801fd5:	c3                   	retq   

0000000000801fd6 <strstr>:

char * strstr(const char *in, const char *str)
{
  801fd6:	55                   	push   %rbp
  801fd7:	48 89 e5             	mov    %rsp,%rbp
  801fda:	48 83 ec 30          	sub    $0x30,%rsp
  801fde:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fe2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801fe6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fea:	0f b6 00             	movzbl (%rax),%eax
  801fed:	88 45 ff             	mov    %al,-0x1(%rbp)
  801ff0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801ff5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ff9:	75 06                	jne    802001 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801ffb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fff:	eb 68                	jmp    802069 <strstr+0x93>

    len = strlen(str);
  802001:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802005:	48 89 c7             	mov    %rax,%rdi
  802008:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  80200f:	00 00 00 
  802012:	ff d0                	callq  *%rax
  802014:	48 98                	cltq   
  802016:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80201a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201e:	0f b6 00             	movzbl (%rax),%eax
  802021:	88 45 ef             	mov    %al,-0x11(%rbp)
  802024:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  802029:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80202d:	75 07                	jne    802036 <strstr+0x60>
                return (char *) 0;
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
  802034:	eb 33                	jmp    802069 <strstr+0x93>
        } while (sc != c);
  802036:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80203a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80203d:	75 db                	jne    80201a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80203f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802043:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802047:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204b:	48 89 ce             	mov    %rcx,%rsi
  80204e:	48 89 c7             	mov    %rax,%rdi
  802051:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  802058:	00 00 00 
  80205b:	ff d0                	callq  *%rax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	75 b9                	jne    80201a <strstr+0x44>

    return (char *) (in - 1);
  802061:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802065:	48 83 e8 01          	sub    $0x1,%rax
}
  802069:	c9                   	leaveq 
  80206a:	c3                   	retq   
	...

000000000080206c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80206c:	55                   	push   %rbp
  80206d:	48 89 e5             	mov    %rsp,%rbp
  802070:	53                   	push   %rbx
  802071:	48 83 ec 58          	sub    $0x58,%rsp
  802075:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802078:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80207b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80207f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802083:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802087:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80208b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80208e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  802091:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802095:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802099:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80209d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8020a1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8020a5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8020a8:	4c 89 c3             	mov    %r8,%rbx
  8020ab:	cd 30                	int    $0x30
  8020ad:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8020b1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8020b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8020b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8020bd:	74 3e                	je     8020fd <syscall+0x91>
  8020bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020c4:	7e 37                	jle    8020fd <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8020c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020cd:	49 89 d0             	mov    %rdx,%r8
  8020d0:	89 c1                	mov    %eax,%ecx
  8020d2:	48 ba 20 4e 80 00 00 	movabs $0x804e20,%rdx
  8020d9:	00 00 00 
  8020dc:	be 23 00 00 00       	mov    $0x23,%esi
  8020e1:	48 bf 3d 4e 80 00 00 	movabs $0x804e3d,%rdi
  8020e8:	00 00 00 
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	49 b9 20 0b 80 00 00 	movabs $0x800b20,%r9
  8020f7:	00 00 00 
  8020fa:	41 ff d1             	callq  *%r9

	return ret;
  8020fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802101:	48 83 c4 58          	add    $0x58,%rsp
  802105:	5b                   	pop    %rbx
  802106:	5d                   	pop    %rbp
  802107:	c3                   	retq   

0000000000802108 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802108:	55                   	push   %rbp
  802109:	48 89 e5             	mov    %rsp,%rbp
  80210c:	48 83 ec 20          	sub    $0x20,%rsp
  802110:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802114:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802120:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802127:	00 
  802128:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80212e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802134:	48 89 d1             	mov    %rdx,%rcx
  802137:	48 89 c2             	mov    %rax,%rdx
  80213a:	be 00 00 00 00       	mov    $0x0,%esi
  80213f:	bf 00 00 00 00       	mov    $0x0,%edi
  802144:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  80214b:	00 00 00 
  80214e:	ff d0                	callq  *%rax
}
  802150:	c9                   	leaveq 
  802151:	c3                   	retq   

0000000000802152 <sys_cgetc>:

int
sys_cgetc(void)
{
  802152:	55                   	push   %rbp
  802153:	48 89 e5             	mov    %rsp,%rbp
  802156:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80215a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802161:	00 
  802162:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802168:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80216e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802173:	ba 00 00 00 00       	mov    $0x0,%edx
  802178:	be 00 00 00 00       	mov    $0x0,%esi
  80217d:	bf 01 00 00 00       	mov    $0x1,%edi
  802182:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
}
  80218e:	c9                   	leaveq 
  80218f:	c3                   	retq   

0000000000802190 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802190:	55                   	push   %rbp
  802191:	48 89 e5             	mov    %rsp,%rbp
  802194:	48 83 ec 20          	sub    $0x20,%rsp
  802198:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80219b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219e:	48 98                	cltq   
  8021a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021a7:	00 
  8021a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021b9:	48 89 c2             	mov    %rax,%rdx
  8021bc:	be 01 00 00 00       	mov    $0x1,%esi
  8021c1:	bf 03 00 00 00       	mov    $0x3,%edi
  8021c6:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  8021cd:	00 00 00 
  8021d0:	ff d0                	callq  *%rax
}
  8021d2:	c9                   	leaveq 
  8021d3:	c3                   	retq   

00000000008021d4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8021d4:	55                   	push   %rbp
  8021d5:	48 89 e5             	mov    %rsp,%rbp
  8021d8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8021dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021e3:	00 
  8021e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021fa:	be 00 00 00 00       	mov    $0x0,%esi
  8021ff:	bf 02 00 00 00       	mov    $0x2,%edi
  802204:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax
}
  802210:	c9                   	leaveq 
  802211:	c3                   	retq   

0000000000802212 <sys_yield>:

void
sys_yield(void)
{
  802212:	55                   	push   %rbp
  802213:	48 89 e5             	mov    %rsp,%rbp
  802216:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80221a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802221:	00 
  802222:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802228:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80222e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802233:	ba 00 00 00 00       	mov    $0x0,%edx
  802238:	be 00 00 00 00       	mov    $0x0,%esi
  80223d:	bf 0b 00 00 00       	mov    $0xb,%edi
  802242:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  802249:	00 00 00 
  80224c:	ff d0                	callq  *%rax
}
  80224e:	c9                   	leaveq 
  80224f:	c3                   	retq   

0000000000802250 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802250:	55                   	push   %rbp
  802251:	48 89 e5             	mov    %rsp,%rbp
  802254:	48 83 ec 20          	sub    $0x20,%rsp
  802258:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80225b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80225f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802262:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802265:	48 63 c8             	movslq %eax,%rcx
  802268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80226c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226f:	48 98                	cltq   
  802271:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802278:	00 
  802279:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80227f:	49 89 c8             	mov    %rcx,%r8
  802282:	48 89 d1             	mov    %rdx,%rcx
  802285:	48 89 c2             	mov    %rax,%rdx
  802288:	be 01 00 00 00       	mov    $0x1,%esi
  80228d:	bf 04 00 00 00       	mov    $0x4,%edi
  802292:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  802299:	00 00 00 
  80229c:	ff d0                	callq  *%rax
}
  80229e:	c9                   	leaveq 
  80229f:	c3                   	retq   

00000000008022a0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8022a0:	55                   	push   %rbp
  8022a1:	48 89 e5             	mov    %rsp,%rbp
  8022a4:	48 83 ec 30          	sub    $0x30,%rsp
  8022a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8022af:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8022b2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8022b6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8022ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022bd:	48 63 c8             	movslq %eax,%rcx
  8022c0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8022c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022c7:	48 63 f0             	movslq %eax,%rsi
  8022ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d1:	48 98                	cltq   
  8022d3:	48 89 0c 24          	mov    %rcx,(%rsp)
  8022d7:	49 89 f9             	mov    %rdi,%r9
  8022da:	49 89 f0             	mov    %rsi,%r8
  8022dd:	48 89 d1             	mov    %rdx,%rcx
  8022e0:	48 89 c2             	mov    %rax,%rdx
  8022e3:	be 01 00 00 00       	mov    $0x1,%esi
  8022e8:	bf 05 00 00 00       	mov    $0x5,%edi
  8022ed:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
}
  8022f9:	c9                   	leaveq 
  8022fa:	c3                   	retq   

00000000008022fb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022fb:	55                   	push   %rbp
  8022fc:	48 89 e5             	mov    %rsp,%rbp
  8022ff:	48 83 ec 20          	sub    $0x20,%rsp
  802303:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802306:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80230a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80230e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802311:	48 98                	cltq   
  802313:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80231a:	00 
  80231b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802321:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802327:	48 89 d1             	mov    %rdx,%rcx
  80232a:	48 89 c2             	mov    %rax,%rdx
  80232d:	be 01 00 00 00       	mov    $0x1,%esi
  802332:	bf 06 00 00 00       	mov    $0x6,%edi
  802337:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  80233e:	00 00 00 
  802341:	ff d0                	callq  *%rax
}
  802343:	c9                   	leaveq 
  802344:	c3                   	retq   

0000000000802345 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802345:	55                   	push   %rbp
  802346:	48 89 e5             	mov    %rsp,%rbp
  802349:	48 83 ec 20          	sub    $0x20,%rsp
  80234d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802350:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802353:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802356:	48 63 d0             	movslq %eax,%rdx
  802359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235c:	48 98                	cltq   
  80235e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802365:	00 
  802366:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80236c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802372:	48 89 d1             	mov    %rdx,%rcx
  802375:	48 89 c2             	mov    %rax,%rdx
  802378:	be 01 00 00 00       	mov    $0x1,%esi
  80237d:	bf 08 00 00 00       	mov    $0x8,%edi
  802382:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  802389:	00 00 00 
  80238c:	ff d0                	callq  *%rax
}
  80238e:	c9                   	leaveq 
  80238f:	c3                   	retq   

0000000000802390 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802390:	55                   	push   %rbp
  802391:	48 89 e5             	mov    %rsp,%rbp
  802394:	48 83 ec 20          	sub    $0x20,%rsp
  802398:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80239b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80239f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a6:	48 98                	cltq   
  8023a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023af:	00 
  8023b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023bc:	48 89 d1             	mov    %rdx,%rcx
  8023bf:	48 89 c2             	mov    %rax,%rdx
  8023c2:	be 01 00 00 00       	mov    $0x1,%esi
  8023c7:	bf 09 00 00 00       	mov    $0x9,%edi
  8023cc:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  8023d3:	00 00 00 
  8023d6:	ff d0                	callq  *%rax
}
  8023d8:	c9                   	leaveq 
  8023d9:	c3                   	retq   

00000000008023da <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8023da:	55                   	push   %rbp
  8023db:	48 89 e5             	mov    %rsp,%rbp
  8023de:	48 83 ec 20          	sub    $0x20,%rsp
  8023e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8023e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f0:	48 98                	cltq   
  8023f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023f9:	00 
  8023fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802400:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802406:	48 89 d1             	mov    %rdx,%rcx
  802409:	48 89 c2             	mov    %rax,%rdx
  80240c:	be 01 00 00 00       	mov    $0x1,%esi
  802411:	bf 0a 00 00 00       	mov    $0xa,%edi
  802416:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  80241d:	00 00 00 
  802420:	ff d0                	callq  *%rax
}
  802422:	c9                   	leaveq 
  802423:	c3                   	retq   

0000000000802424 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802424:	55                   	push   %rbp
  802425:	48 89 e5             	mov    %rsp,%rbp
  802428:	48 83 ec 30          	sub    $0x30,%rsp
  80242c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80242f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802433:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802437:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80243a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80243d:	48 63 f0             	movslq %eax,%rsi
  802440:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802444:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802447:	48 98                	cltq   
  802449:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80244d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802454:	00 
  802455:	49 89 f1             	mov    %rsi,%r9
  802458:	49 89 c8             	mov    %rcx,%r8
  80245b:	48 89 d1             	mov    %rdx,%rcx
  80245e:	48 89 c2             	mov    %rax,%rdx
  802461:	be 00 00 00 00       	mov    $0x0,%esi
  802466:	bf 0c 00 00 00       	mov    $0xc,%edi
  80246b:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  802472:	00 00 00 
  802475:	ff d0                	callq  *%rax
}
  802477:	c9                   	leaveq 
  802478:	c3                   	retq   

0000000000802479 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802479:	55                   	push   %rbp
  80247a:	48 89 e5             	mov    %rsp,%rbp
  80247d:	48 83 ec 20          	sub    $0x20,%rsp
  802481:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802489:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802490:	00 
  802491:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802497:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80249d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024a2:	48 89 c2             	mov    %rax,%rdx
  8024a5:	be 01 00 00 00       	mov    $0x1,%esi
  8024aa:	bf 0d 00 00 00       	mov    $0xd,%edi
  8024af:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  8024b6:	00 00 00 
  8024b9:	ff d0                	callq  *%rax
}
  8024bb:	c9                   	leaveq 
  8024bc:	c3                   	retq   

00000000008024bd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8024bd:	55                   	push   %rbp
  8024be:	48 89 e5             	mov    %rsp,%rbp
  8024c1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8024c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024cc:	00 
  8024cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024de:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e3:	be 00 00 00 00       	mov    $0x0,%esi
  8024e8:	bf 0e 00 00 00       	mov    $0xe,%edi
  8024ed:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  8024f4:	00 00 00 
  8024f7:	ff d0                	callq  *%rax
}
  8024f9:	c9                   	leaveq 
  8024fa:	c3                   	retq   

00000000008024fb <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  8024fb:	55                   	push   %rbp
  8024fc:	48 89 e5             	mov    %rsp,%rbp
  8024ff:	48 83 ec 20          	sub    $0x20,%rsp
  802503:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802507:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  80250b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80250f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802513:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80251a:	00 
  80251b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802521:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802527:	48 89 d1             	mov    %rdx,%rcx
  80252a:	48 89 c2             	mov    %rax,%rdx
  80252d:	be 00 00 00 00       	mov    $0x0,%esi
  802532:	bf 0f 00 00 00       	mov    $0xf,%edi
  802537:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  80253e:	00 00 00 
  802541:	ff d0                	callq  *%rax
}
  802543:	c9                   	leaveq 
  802544:	c3                   	retq   

0000000000802545 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802545:	55                   	push   %rbp
  802546:	48 89 e5             	mov    %rsp,%rbp
  802549:	48 83 ec 20          	sub    $0x20,%rsp
  80254d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802551:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802559:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80255d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802564:	00 
  802565:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80256b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802571:	48 89 d1             	mov    %rdx,%rcx
  802574:	48 89 c2             	mov    %rax,%rdx
  802577:	be 00 00 00 00       	mov    $0x0,%esi
  80257c:	bf 10 00 00 00       	mov    $0x10,%edi
  802581:	48 b8 6c 20 80 00 00 	movabs $0x80206c,%rax
  802588:	00 00 00 
  80258b:	ff d0                	callq  *%rax
}
  80258d:	c9                   	leaveq 
  80258e:	c3                   	retq   
	...

0000000000802590 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802590:	55                   	push   %rbp
  802591:	48 89 e5             	mov    %rsp,%rbp
  802594:	48 83 ec 30          	sub    $0x30,%rsp
  802598:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80259c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8025a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8025a9:	74 18                	je     8025c3 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8025ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025af:	48 89 c7             	mov    %rax,%rdi
  8025b2:	48 b8 79 24 80 00 00 	movabs $0x802479,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	callq  *%rax
  8025be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c1:	eb 19                	jmp    8025dc <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  8025c3:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8025ca:	00 00 00 
  8025cd:	48 b8 79 24 80 00 00 	movabs $0x802479,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
  8025d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8025dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e0:	79 19                	jns    8025fb <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8025e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8025ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8025f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f9:	eb 53                	jmp    80264e <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8025fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802600:	74 19                	je     80261b <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  802602:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802609:	00 00 00 
  80260c:	48 8b 00             	mov    (%rax),%rax
  80260f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802619:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80261b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802620:	74 19                	je     80263b <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  802622:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802629:	00 00 00 
  80262c:	48 8b 00             	mov    (%rax),%rax
  80262f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802639:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80263b:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802642:	00 00 00 
  802645:	48 8b 00             	mov    (%rax),%rax
  802648:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80264e:	c9                   	leaveq 
  80264f:	c3                   	retq   

0000000000802650 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802650:	55                   	push   %rbp
  802651:	48 89 e5             	mov    %rsp,%rbp
  802654:	48 83 ec 30          	sub    $0x30,%rsp
  802658:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80265b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80265e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802662:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  802665:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  80266c:	e9 96 00 00 00       	jmpq   802707 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  802671:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802676:	74 20                	je     802698 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  802678:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80267b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80267e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802682:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802685:	89 c7                	mov    %eax,%edi
  802687:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  80268e:	00 00 00 
  802691:	ff d0                	callq  *%rax
  802693:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802696:	eb 2d                	jmp    8026c5 <ipc_send+0x75>
		else if(pg==NULL)
  802698:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80269d:	75 26                	jne    8026c5 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80269f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8026a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026aa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8026b1:	00 00 00 
  8026b4:	89 c7                	mov    %eax,%edi
  8026b6:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
  8026c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8026c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c9:	79 30                	jns    8026fb <ipc_send+0xab>
  8026cb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8026cf:	74 2a                	je     8026fb <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8026d1:	48 ba 4b 4e 80 00 00 	movabs $0x804e4b,%rdx
  8026d8:	00 00 00 
  8026db:	be 40 00 00 00       	mov    $0x40,%esi
  8026e0:	48 bf 63 4e 80 00 00 	movabs $0x804e63,%rdi
  8026e7:	00 00 00 
  8026ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ef:	48 b9 20 0b 80 00 00 	movabs $0x800b20,%rcx
  8026f6:	00 00 00 
  8026f9:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8026fb:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  802707:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270b:	0f 85 60 ff ff ff    	jne    802671 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  802711:	c9                   	leaveq 
  802712:	c3                   	retq   

0000000000802713 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802713:	55                   	push   %rbp
  802714:	48 89 e5             	mov    %rsp,%rbp
  802717:	48 83 ec 18          	sub    $0x18,%rsp
  80271b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80271e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802725:	eb 5e                	jmp    802785 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802727:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80272e:	00 00 00 
  802731:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802734:	48 63 d0             	movslq %eax,%rdx
  802737:	48 89 d0             	mov    %rdx,%rax
  80273a:	48 c1 e0 03          	shl    $0x3,%rax
  80273e:	48 01 d0             	add    %rdx,%rax
  802741:	48 c1 e0 05          	shl    $0x5,%rax
  802745:	48 01 c8             	add    %rcx,%rax
  802748:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80274e:	8b 00                	mov    (%rax),%eax
  802750:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802753:	75 2c                	jne    802781 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802755:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80275c:	00 00 00 
  80275f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802762:	48 63 d0             	movslq %eax,%rdx
  802765:	48 89 d0             	mov    %rdx,%rax
  802768:	48 c1 e0 03          	shl    $0x3,%rax
  80276c:	48 01 d0             	add    %rdx,%rax
  80276f:	48 c1 e0 05          	shl    $0x5,%rax
  802773:	48 01 c8             	add    %rcx,%rax
  802776:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80277c:	8b 40 08             	mov    0x8(%rax),%eax
  80277f:	eb 12                	jmp    802793 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802781:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802785:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80278c:	7e 99                	jle    802727 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802793:	c9                   	leaveq 
  802794:	c3                   	retq   
  802795:	00 00                	add    %al,(%rax)
	...

0000000000802798 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802798:	55                   	push   %rbp
  802799:	48 89 e5             	mov    %rsp,%rbp
  80279c:	48 83 ec 08          	sub    $0x8,%rsp
  8027a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8027a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027a8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8027af:	ff ff ff 
  8027b2:	48 01 d0             	add    %rdx,%rax
  8027b5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8027b9:	c9                   	leaveq 
  8027ba:	c3                   	retq   

00000000008027bb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8027bb:	55                   	push   %rbp
  8027bc:	48 89 e5             	mov    %rsp,%rbp
  8027bf:	48 83 ec 08          	sub    $0x8,%rsp
  8027c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8027c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027cb:	48 89 c7             	mov    %rax,%rdi
  8027ce:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	callq  *%rax
  8027da:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8027e0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8027e4:	c9                   	leaveq 
  8027e5:	c3                   	retq   

00000000008027e6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8027e6:	55                   	push   %rbp
  8027e7:	48 89 e5             	mov    %rsp,%rbp
  8027ea:	48 83 ec 18          	sub    $0x18,%rsp
  8027ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027f9:	eb 6b                	jmp    802866 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8027fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fe:	48 98                	cltq   
  802800:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802806:	48 c1 e0 0c          	shl    $0xc,%rax
  80280a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80280e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802812:	48 89 c2             	mov    %rax,%rdx
  802815:	48 c1 ea 15          	shr    $0x15,%rdx
  802819:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802820:	01 00 00 
  802823:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802827:	83 e0 01             	and    $0x1,%eax
  80282a:	48 85 c0             	test   %rax,%rax
  80282d:	74 21                	je     802850 <fd_alloc+0x6a>
  80282f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802833:	48 89 c2             	mov    %rax,%rdx
  802836:	48 c1 ea 0c          	shr    $0xc,%rdx
  80283a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802841:	01 00 00 
  802844:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802848:	83 e0 01             	and    $0x1,%eax
  80284b:	48 85 c0             	test   %rax,%rax
  80284e:	75 12                	jne    802862 <fd_alloc+0x7c>
			*fd_store = fd;
  802850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802854:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802858:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
  802860:	eb 1a                	jmp    80287c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802862:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802866:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80286a:	7e 8f                	jle    8027fb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80286c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802870:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802877:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80287c:	c9                   	leaveq 
  80287d:	c3                   	retq   

000000000080287e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80287e:	55                   	push   %rbp
  80287f:	48 89 e5             	mov    %rsp,%rbp
  802882:	48 83 ec 20          	sub    $0x20,%rsp
  802886:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802889:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80288d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802891:	78 06                	js     802899 <fd_lookup+0x1b>
  802893:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802897:	7e 07                	jle    8028a0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802899:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80289e:	eb 6c                	jmp    80290c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8028a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028a3:	48 98                	cltq   
  8028a5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028ab:	48 c1 e0 0c          	shl    $0xc,%rax
  8028af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8028b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b7:	48 89 c2             	mov    %rax,%rdx
  8028ba:	48 c1 ea 15          	shr    $0x15,%rdx
  8028be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028c5:	01 00 00 
  8028c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028cc:	83 e0 01             	and    $0x1,%eax
  8028cf:	48 85 c0             	test   %rax,%rax
  8028d2:	74 21                	je     8028f5 <fd_lookup+0x77>
  8028d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d8:	48 89 c2             	mov    %rax,%rdx
  8028db:	48 c1 ea 0c          	shr    $0xc,%rdx
  8028df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028e6:	01 00 00 
  8028e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028ed:	83 e0 01             	and    $0x1,%eax
  8028f0:	48 85 c0             	test   %rax,%rax
  8028f3:	75 07                	jne    8028fc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028fa:	eb 10                	jmp    80290c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8028fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802900:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802904:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802907:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80290c:	c9                   	leaveq 
  80290d:	c3                   	retq   

000000000080290e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80290e:	55                   	push   %rbp
  80290f:	48 89 e5             	mov    %rsp,%rbp
  802912:	48 83 ec 30          	sub    $0x30,%rsp
  802916:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80291a:	89 f0                	mov    %esi,%eax
  80291c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80291f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802923:	48 89 c7             	mov    %rax,%rdi
  802926:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  80292d:	00 00 00 
  802930:	ff d0                	callq  *%rax
  802932:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802936:	48 89 d6             	mov    %rdx,%rsi
  802939:	89 c7                	mov    %eax,%edi
  80293b:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax
  802947:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294e:	78 0a                	js     80295a <fd_close+0x4c>
	    || fd != fd2)
  802950:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802954:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802958:	74 12                	je     80296c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80295a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80295e:	74 05                	je     802965 <fd_close+0x57>
  802960:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802963:	eb 05                	jmp    80296a <fd_close+0x5c>
  802965:	b8 00 00 00 00       	mov    $0x0,%eax
  80296a:	eb 69                	jmp    8029d5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80296c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802970:	8b 00                	mov    (%rax),%eax
  802972:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802976:	48 89 d6             	mov    %rdx,%rsi
  802979:	89 c7                	mov    %eax,%edi
  80297b:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802982:	00 00 00 
  802985:	ff d0                	callq  *%rax
  802987:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80298e:	78 2a                	js     8029ba <fd_close+0xac>
		if (dev->dev_close)
  802990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802994:	48 8b 40 20          	mov    0x20(%rax),%rax
  802998:	48 85 c0             	test   %rax,%rax
  80299b:	74 16                	je     8029b3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80299d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a1:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8029a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a9:	48 89 c7             	mov    %rax,%rdi
  8029ac:	ff d2                	callq  *%rdx
  8029ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b1:	eb 07                	jmp    8029ba <fd_close+0xac>
		else
			r = 0;
  8029b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8029ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029be:	48 89 c6             	mov    %rax,%rsi
  8029c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c6:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
	return r;
  8029d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029d5:	c9                   	leaveq 
  8029d6:	c3                   	retq   

00000000008029d7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029d7:	55                   	push   %rbp
  8029d8:	48 89 e5             	mov    %rsp,%rbp
  8029db:	48 83 ec 20          	sub    $0x20,%rsp
  8029df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8029e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029ed:	eb 41                	jmp    802a30 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8029ef:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8029f6:	00 00 00 
  8029f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029fc:	48 63 d2             	movslq %edx,%rdx
  8029ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a03:	8b 00                	mov    (%rax),%eax
  802a05:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a08:	75 22                	jne    802a2c <dev_lookup+0x55>
			*dev = devtab[i];
  802a0a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a11:	00 00 00 
  802a14:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a17:	48 63 d2             	movslq %edx,%rdx
  802a1a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a22:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a25:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2a:	eb 60                	jmp    802a8c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a2c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a30:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a37:	00 00 00 
  802a3a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a3d:	48 63 d2             	movslq %edx,%rdx
  802a40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a44:	48 85 c0             	test   %rax,%rax
  802a47:	75 a6                	jne    8029ef <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a49:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802a50:	00 00 00 
  802a53:	48 8b 00             	mov    (%rax),%rax
  802a56:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a5c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a5f:	89 c6                	mov    %eax,%esi
  802a61:	48 bf 70 4e 80 00 00 	movabs $0x804e70,%rdi
  802a68:	00 00 00 
  802a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a70:	48 b9 5b 0d 80 00 00 	movabs $0x800d5b,%rcx
  802a77:	00 00 00 
  802a7a:	ff d1                	callq  *%rcx
	*dev = 0;
  802a7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a80:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802a87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a8c:	c9                   	leaveq 
  802a8d:	c3                   	retq   

0000000000802a8e <close>:

int
close(int fdnum)
{
  802a8e:	55                   	push   %rbp
  802a8f:	48 89 e5             	mov    %rsp,%rbp
  802a92:	48 83 ec 20          	sub    $0x20,%rsp
  802a96:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a99:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aa0:	48 89 d6             	mov    %rdx,%rsi
  802aa3:	89 c7                	mov    %eax,%edi
  802aa5:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	callq  *%rax
  802ab1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab8:	79 05                	jns    802abf <close+0x31>
		return r;
  802aba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abd:	eb 18                	jmp    802ad7 <close+0x49>
	else
		return fd_close(fd, 1);
  802abf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac3:	be 01 00 00 00       	mov    $0x1,%esi
  802ac8:	48 89 c7             	mov    %rax,%rdi
  802acb:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
}
  802ad7:	c9                   	leaveq 
  802ad8:	c3                   	retq   

0000000000802ad9 <close_all>:

void
close_all(void)
{
  802ad9:	55                   	push   %rbp
  802ada:	48 89 e5             	mov    %rsp,%rbp
  802add:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802ae1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ae8:	eb 15                	jmp    802aff <close_all+0x26>
		close(i);
  802aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aed:	89 c7                	mov    %eax,%edi
  802aef:	48 b8 8e 2a 80 00 00 	movabs $0x802a8e,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802afb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802aff:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b03:	7e e5                	jle    802aea <close_all+0x11>
		close(i);
}
  802b05:	c9                   	leaveq 
  802b06:	c3                   	retq   

0000000000802b07 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b07:	55                   	push   %rbp
  802b08:	48 89 e5             	mov    %rsp,%rbp
  802b0b:	48 83 ec 40          	sub    $0x40,%rsp
  802b0f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b12:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b15:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b19:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b1c:	48 89 d6             	mov    %rdx,%rsi
  802b1f:	89 c7                	mov    %eax,%edi
  802b21:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802b28:	00 00 00 
  802b2b:	ff d0                	callq  *%rax
  802b2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b34:	79 08                	jns    802b3e <dup+0x37>
		return r;
  802b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b39:	e9 70 01 00 00       	jmpq   802cae <dup+0x1a7>
	close(newfdnum);
  802b3e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b41:	89 c7                	mov    %eax,%edi
  802b43:	48 b8 8e 2a 80 00 00 	movabs $0x802a8e,%rax
  802b4a:	00 00 00 
  802b4d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b4f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b52:	48 98                	cltq   
  802b54:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b5a:	48 c1 e0 0c          	shl    $0xc,%rax
  802b5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b66:	48 89 c7             	mov    %rax,%rdi
  802b69:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax
  802b75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802b79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7d:	48 89 c7             	mov    %rax,%rdi
  802b80:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
  802b8c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b94:	48 89 c2             	mov    %rax,%rdx
  802b97:	48 c1 ea 15          	shr    $0x15,%rdx
  802b9b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ba2:	01 00 00 
  802ba5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ba9:	83 e0 01             	and    $0x1,%eax
  802bac:	84 c0                	test   %al,%al
  802bae:	74 71                	je     802c21 <dup+0x11a>
  802bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb4:	48 89 c2             	mov    %rax,%rdx
  802bb7:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bbb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bc2:	01 00 00 
  802bc5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bc9:	83 e0 01             	and    $0x1,%eax
  802bcc:	84 c0                	test   %al,%al
  802bce:	74 51                	je     802c21 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd4:	48 89 c2             	mov    %rax,%rdx
  802bd7:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bdb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802be2:	01 00 00 
  802be5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802be9:	89 c1                	mov    %eax,%ecx
  802beb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802bf1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf9:	41 89 c8             	mov    %ecx,%r8d
  802bfc:	48 89 d1             	mov    %rdx,%rcx
  802bff:	ba 00 00 00 00       	mov    $0x0,%edx
  802c04:	48 89 c6             	mov    %rax,%rsi
  802c07:	bf 00 00 00 00       	mov    $0x0,%edi
  802c0c:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  802c13:	00 00 00 
  802c16:	ff d0                	callq  *%rax
  802c18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1f:	78 56                	js     802c77 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c25:	48 89 c2             	mov    %rax,%rdx
  802c28:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c2c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c33:	01 00 00 
  802c36:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c3a:	89 c1                	mov    %eax,%ecx
  802c3c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802c42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c4a:	41 89 c8             	mov    %ecx,%r8d
  802c4d:	48 89 d1             	mov    %rdx,%rcx
  802c50:	ba 00 00 00 00       	mov    $0x0,%edx
  802c55:	48 89 c6             	mov    %rax,%rsi
  802c58:	bf 00 00 00 00       	mov    $0x0,%edi
  802c5d:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  802c64:	00 00 00 
  802c67:	ff d0                	callq  *%rax
  802c69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c70:	78 08                	js     802c7a <dup+0x173>
		goto err;

	return newfdnum;
  802c72:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c75:	eb 37                	jmp    802cae <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802c77:	90                   	nop
  802c78:	eb 01                	jmp    802c7b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802c7a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802c7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7f:	48 89 c6             	mov    %rax,%rsi
  802c82:	bf 00 00 00 00       	mov    $0x0,%edi
  802c87:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  802c8e:	00 00 00 
  802c91:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802c93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c97:	48 89 c6             	mov    %rax,%rsi
  802c9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802c9f:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	callq  *%rax
	return r;
  802cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cae:	c9                   	leaveq 
  802caf:	c3                   	retq   

0000000000802cb0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802cb0:	55                   	push   %rbp
  802cb1:	48 89 e5             	mov    %rsp,%rbp
  802cb4:	48 83 ec 40          	sub    $0x40,%rsp
  802cb8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cbb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cbf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cca:	48 89 d6             	mov    %rdx,%rsi
  802ccd:	89 c7                	mov    %eax,%edi
  802ccf:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802cd6:	00 00 00 
  802cd9:	ff d0                	callq  *%rax
  802cdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce2:	78 24                	js     802d08 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce8:	8b 00                	mov    (%rax),%eax
  802cea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cee:	48 89 d6             	mov    %rdx,%rsi
  802cf1:	89 c7                	mov    %eax,%edi
  802cf3:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
  802cff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d06:	79 05                	jns    802d0d <read+0x5d>
		return r;
  802d08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0b:	eb 7a                	jmp    802d87 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d11:	8b 40 08             	mov    0x8(%rax),%eax
  802d14:	83 e0 03             	and    $0x3,%eax
  802d17:	83 f8 01             	cmp    $0x1,%eax
  802d1a:	75 3a                	jne    802d56 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d1c:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802d23:	00 00 00 
  802d26:	48 8b 00             	mov    (%rax),%rax
  802d29:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d2f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d32:	89 c6                	mov    %eax,%esi
  802d34:	48 bf 8f 4e 80 00 00 	movabs $0x804e8f,%rdi
  802d3b:	00 00 00 
  802d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d43:	48 b9 5b 0d 80 00 00 	movabs $0x800d5b,%rcx
  802d4a:	00 00 00 
  802d4d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d54:	eb 31                	jmp    802d87 <read+0xd7>
	}
	if (!dev->dev_read)
  802d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5a:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d5e:	48 85 c0             	test   %rax,%rax
  802d61:	75 07                	jne    802d6a <read+0xba>
		return -E_NOT_SUPP;
  802d63:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d68:	eb 1d                	jmp    802d87 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802d72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d7a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d7e:	48 89 ce             	mov    %rcx,%rsi
  802d81:	48 89 c7             	mov    %rax,%rdi
  802d84:	41 ff d0             	callq  *%r8
}
  802d87:	c9                   	leaveq 
  802d88:	c3                   	retq   

0000000000802d89 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d89:	55                   	push   %rbp
  802d8a:	48 89 e5             	mov    %rsp,%rbp
  802d8d:	48 83 ec 30          	sub    $0x30,%rsp
  802d91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d98:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802da3:	eb 46                	jmp    802deb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da8:	48 98                	cltq   
  802daa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dae:	48 29 c2             	sub    %rax,%rdx
  802db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db4:	48 98                	cltq   
  802db6:	48 89 c1             	mov    %rax,%rcx
  802db9:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802dbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dc0:	48 89 ce             	mov    %rcx,%rsi
  802dc3:	89 c7                	mov    %eax,%edi
  802dc5:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  802dcc:	00 00 00 
  802dcf:	ff d0                	callq  *%rax
  802dd1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802dd4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dd8:	79 05                	jns    802ddf <readn+0x56>
			return m;
  802dda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddd:	eb 1d                	jmp    802dfc <readn+0x73>
		if (m == 0)
  802ddf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802de3:	74 13                	je     802df8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802de5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802de8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dee:	48 98                	cltq   
  802df0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802df4:	72 af                	jb     802da5 <readn+0x1c>
  802df6:	eb 01                	jmp    802df9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802df8:	90                   	nop
	}
	return tot;
  802df9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802dfc:	c9                   	leaveq 
  802dfd:	c3                   	retq   

0000000000802dfe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802dfe:	55                   	push   %rbp
  802dff:	48 89 e5             	mov    %rsp,%rbp
  802e02:	48 83 ec 40          	sub    $0x40,%rsp
  802e06:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e0d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e18:	48 89 d6             	mov    %rdx,%rsi
  802e1b:	89 c7                	mov    %eax,%edi
  802e1d:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802e24:	00 00 00 
  802e27:	ff d0                	callq  *%rax
  802e29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e30:	78 24                	js     802e56 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e36:	8b 00                	mov    (%rax),%eax
  802e38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e3c:	48 89 d6             	mov    %rdx,%rsi
  802e3f:	89 c7                	mov    %eax,%edi
  802e41:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802e48:	00 00 00 
  802e4b:	ff d0                	callq  *%rax
  802e4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e54:	79 05                	jns    802e5b <write+0x5d>
		return r;
  802e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e59:	eb 79                	jmp    802ed4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5f:	8b 40 08             	mov    0x8(%rax),%eax
  802e62:	83 e0 03             	and    $0x3,%eax
  802e65:	85 c0                	test   %eax,%eax
  802e67:	75 3a                	jne    802ea3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e69:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802e70:	00 00 00 
  802e73:	48 8b 00             	mov    (%rax),%rax
  802e76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e7f:	89 c6                	mov    %eax,%esi
  802e81:	48 bf ab 4e 80 00 00 	movabs $0x804eab,%rdi
  802e88:	00 00 00 
  802e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e90:	48 b9 5b 0d 80 00 00 	movabs $0x800d5b,%rcx
  802e97:	00 00 00 
  802e9a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ea1:	eb 31                	jmp    802ed4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ea3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea7:	48 8b 40 18          	mov    0x18(%rax),%rax
  802eab:	48 85 c0             	test   %rax,%rax
  802eae:	75 07                	jne    802eb7 <write+0xb9>
		return -E_NOT_SUPP;
  802eb0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eb5:	eb 1d                	jmp    802ed4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebb:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ec7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ecb:	48 89 ce             	mov    %rcx,%rsi
  802ece:	48 89 c7             	mov    %rax,%rdi
  802ed1:	41 ff d0             	callq  *%r8
}
  802ed4:	c9                   	leaveq 
  802ed5:	c3                   	retq   

0000000000802ed6 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ed6:	55                   	push   %rbp
  802ed7:	48 89 e5             	mov    %rsp,%rbp
  802eda:	48 83 ec 18          	sub    $0x18,%rsp
  802ede:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ee1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ee4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ee8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eeb:	48 89 d6             	mov    %rdx,%rsi
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
  802efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f03:	79 05                	jns    802f0a <seek+0x34>
		return r;
  802f05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f08:	eb 0f                	jmp    802f19 <seek+0x43>
	fd->fd_offset = offset;
  802f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f11:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f19:	c9                   	leaveq 
  802f1a:	c3                   	retq   

0000000000802f1b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f1b:	55                   	push   %rbp
  802f1c:	48 89 e5             	mov    %rsp,%rbp
  802f1f:	48 83 ec 30          	sub    $0x30,%rsp
  802f23:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f26:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f29:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f2d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f30:	48 89 d6             	mov    %rdx,%rsi
  802f33:	89 c7                	mov    %eax,%edi
  802f35:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802f3c:	00 00 00 
  802f3f:	ff d0                	callq  *%rax
  802f41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f48:	78 24                	js     802f6e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4e:	8b 00                	mov    (%rax),%eax
  802f50:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f54:	48 89 d6             	mov    %rdx,%rsi
  802f57:	89 c7                	mov    %eax,%edi
  802f59:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802f60:	00 00 00 
  802f63:	ff d0                	callq  *%rax
  802f65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6c:	79 05                	jns    802f73 <ftruncate+0x58>
		return r;
  802f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f71:	eb 72                	jmp    802fe5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f77:	8b 40 08             	mov    0x8(%rax),%eax
  802f7a:	83 e0 03             	and    $0x3,%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	75 3a                	jne    802fbb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802f81:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802f88:	00 00 00 
  802f8b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f8e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f94:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f97:	89 c6                	mov    %eax,%esi
  802f99:	48 bf c8 4e 80 00 00 	movabs $0x804ec8,%rdi
  802fa0:	00 00 00 
  802fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa8:	48 b9 5b 0d 80 00 00 	movabs $0x800d5b,%rcx
  802faf:	00 00 00 
  802fb2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802fb4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fb9:	eb 2a                	jmp    802fe5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbf:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fc3:	48 85 c0             	test   %rax,%rax
  802fc6:	75 07                	jne    802fcf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802fc8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fcd:	eb 16                	jmp    802fe5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fdb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802fde:	89 d6                	mov    %edx,%esi
  802fe0:	48 89 c7             	mov    %rax,%rdi
  802fe3:	ff d1                	callq  *%rcx
}
  802fe5:	c9                   	leaveq 
  802fe6:	c3                   	retq   

0000000000802fe7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802fe7:	55                   	push   %rbp
  802fe8:	48 89 e5             	mov    %rsp,%rbp
  802feb:	48 83 ec 30          	sub    $0x30,%rsp
  802fef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ff2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ff6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ffa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ffd:	48 89 d6             	mov    %rdx,%rsi
  803000:	89 c7                	mov    %eax,%edi
  803002:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  803009:	00 00 00 
  80300c:	ff d0                	callq  *%rax
  80300e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803011:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803015:	78 24                	js     80303b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803017:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301b:	8b 00                	mov    (%rax),%eax
  80301d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803021:	48 89 d6             	mov    %rdx,%rsi
  803024:	89 c7                	mov    %eax,%edi
  803026:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  80302d:	00 00 00 
  803030:	ff d0                	callq  *%rax
  803032:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803035:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803039:	79 05                	jns    803040 <fstat+0x59>
		return r;
  80303b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303e:	eb 5e                	jmp    80309e <fstat+0xb7>
	if (!dev->dev_stat)
  803040:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803044:	48 8b 40 28          	mov    0x28(%rax),%rax
  803048:	48 85 c0             	test   %rax,%rax
  80304b:	75 07                	jne    803054 <fstat+0x6d>
		return -E_NOT_SUPP;
  80304d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803052:	eb 4a                	jmp    80309e <fstat+0xb7>
	stat->st_name[0] = 0;
  803054:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803058:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80305b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80305f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803066:	00 00 00 
	stat->st_isdir = 0;
  803069:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80306d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803074:	00 00 00 
	stat->st_dev = dev;
  803077:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80307b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80307f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80308e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803092:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803096:	48 89 d6             	mov    %rdx,%rsi
  803099:	48 89 c7             	mov    %rax,%rdi
  80309c:	ff d1                	callq  *%rcx
}
  80309e:	c9                   	leaveq 
  80309f:	c3                   	retq   

00000000008030a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8030a0:	55                   	push   %rbp
  8030a1:	48 89 e5             	mov    %rsp,%rbp
  8030a4:	48 83 ec 20          	sub    $0x20,%rsp
  8030a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b4:	be 00 00 00 00       	mov    $0x0,%esi
  8030b9:	48 89 c7             	mov    %rax,%rdi
  8030bc:	48 b8 8f 31 80 00 00 	movabs $0x80318f,%rax
  8030c3:	00 00 00 
  8030c6:	ff d0                	callq  *%rax
  8030c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030cf:	79 05                	jns    8030d6 <stat+0x36>
		return fd;
  8030d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d4:	eb 2f                	jmp    803105 <stat+0x65>
	r = fstat(fd, stat);
  8030d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030dd:	48 89 d6             	mov    %rdx,%rsi
  8030e0:	89 c7                	mov    %eax,%edi
  8030e2:	48 b8 e7 2f 80 00 00 	movabs $0x802fe7,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
  8030ee:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8030f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f4:	89 c7                	mov    %eax,%edi
  8030f6:	48 b8 8e 2a 80 00 00 	movabs $0x802a8e,%rax
  8030fd:	00 00 00 
  803100:	ff d0                	callq  *%rax
	return r;
  803102:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803105:	c9                   	leaveq 
  803106:	c3                   	retq   
	...

0000000000803108 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803108:	55                   	push   %rbp
  803109:	48 89 e5             	mov    %rsp,%rbp
  80310c:	48 83 ec 10          	sub    $0x10,%rsp
  803110:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803113:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803117:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  80311e:	00 00 00 
  803121:	8b 00                	mov    (%rax),%eax
  803123:	85 c0                	test   %eax,%eax
  803125:	75 1d                	jne    803144 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803127:	bf 01 00 00 00       	mov    $0x1,%edi
  80312c:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
  803138:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  80313f:	00 00 00 
  803142:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803144:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  80314b:	00 00 00 
  80314e:	8b 00                	mov    (%rax),%eax
  803150:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803153:	b9 07 00 00 00       	mov    $0x7,%ecx
  803158:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80315f:	00 00 00 
  803162:	89 c7                	mov    %eax,%edi
  803164:	48 b8 50 26 80 00 00 	movabs $0x802650,%rax
  80316b:	00 00 00 
  80316e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803174:	ba 00 00 00 00       	mov    $0x0,%edx
  803179:	48 89 c6             	mov    %rax,%rsi
  80317c:	bf 00 00 00 00       	mov    $0x0,%edi
  803181:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
}
  80318d:	c9                   	leaveq 
  80318e:	c3                   	retq   

000000000080318f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80318f:	55                   	push   %rbp
  803190:	48 89 e5             	mov    %rsp,%rbp
  803193:	48 83 ec 20          	sub    $0x20,%rsp
  803197:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80319b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80319e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a2:	48 89 c7             	mov    %rax,%rdi
  8031a5:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  8031ac:	00 00 00 
  8031af:	ff d0                	callq  *%rax
  8031b1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031b6:	7e 0a                	jle    8031c2 <open+0x33>
                return -E_BAD_PATH;
  8031b8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031bd:	e9 a5 00 00 00       	jmpq   803267 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8031c2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031c6:	48 89 c7             	mov    %rax,%rdi
  8031c9:	48 b8 e6 27 80 00 00 	movabs $0x8027e6,%rax
  8031d0:	00 00 00 
  8031d3:	ff d0                	callq  *%rax
  8031d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031dc:	79 08                	jns    8031e6 <open+0x57>
		return r;
  8031de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e1:	e9 81 00 00 00       	jmpq   803267 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8031e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ea:	48 89 c6             	mov    %rax,%rsi
  8031ed:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031f4:	00 00 00 
  8031f7:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  8031fe:	00 00 00 
  803201:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  803203:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320a:	00 00 00 
  80320d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803210:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  803216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321a:	48 89 c6             	mov    %rax,%rsi
  80321d:	bf 01 00 00 00       	mov    $0x1,%edi
  803222:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  803229:	00 00 00 
  80322c:	ff d0                	callq  *%rax
  80322e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  803231:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803235:	79 1d                	jns    803254 <open+0xc5>
	{
		fd_close(fd,0);
  803237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80323b:	be 00 00 00 00       	mov    $0x0,%esi
  803240:	48 89 c7             	mov    %rax,%rdi
  803243:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  80324a:	00 00 00 
  80324d:	ff d0                	callq  *%rax
		return r;
  80324f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803252:	eb 13                	jmp    803267 <open+0xd8>
	}
	return fd2num(fd);
  803254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803258:	48 89 c7             	mov    %rax,%rdi
  80325b:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  803262:	00 00 00 
  803265:	ff d0                	callq  *%rax
	


}
  803267:	c9                   	leaveq 
  803268:	c3                   	retq   

0000000000803269 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803269:	55                   	push   %rbp
  80326a:	48 89 e5             	mov    %rsp,%rbp
  80326d:	48 83 ec 10          	sub    $0x10,%rsp
  803271:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803279:	8b 50 0c             	mov    0xc(%rax),%edx
  80327c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803283:	00 00 00 
  803286:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803288:	be 00 00 00 00       	mov    $0x0,%esi
  80328d:	bf 06 00 00 00       	mov    $0x6,%edi
  803292:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  803299:	00 00 00 
  80329c:	ff d0                	callq  *%rax
}
  80329e:	c9                   	leaveq 
  80329f:	c3                   	retq   

00000000008032a0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032a0:	55                   	push   %rbp
  8032a1:	48 89 e5             	mov    %rsp,%rbp
  8032a4:	48 83 ec 30          	sub    $0x30,%rsp
  8032a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8032b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b8:	8b 50 0c             	mov    0xc(%rax),%edx
  8032bb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032c2:	00 00 00 
  8032c5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032c7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032ce:	00 00 00 
  8032d1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8032d9:	be 00 00 00 00       	mov    $0x0,%esi
  8032de:	bf 03 00 00 00       	mov    $0x3,%edi
  8032e3:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  8032ea:	00 00 00 
  8032ed:	ff d0                	callq  *%rax
  8032ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f6:	79 05                	jns    8032fd <devfile_read+0x5d>
	{
		return r;
  8032f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fb:	eb 2c                	jmp    803329 <devfile_read+0x89>
	}
	if(r > 0)
  8032fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803301:	7e 23                	jle    803326 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  803303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803306:	48 63 d0             	movslq %eax,%rdx
  803309:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80330d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803314:	00 00 00 
  803317:	48 89 c7             	mov    %rax,%rdi
  80331a:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
	return r;
  803326:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  803329:	c9                   	leaveq 
  80332a:	c3                   	retq   

000000000080332b <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80332b:	55                   	push   %rbp
  80332c:	48 89 e5             	mov    %rsp,%rbp
  80332f:	48 83 ec 30          	sub    $0x30,%rsp
  803333:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803337:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80333b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80333f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803343:	8b 50 0c             	mov    0xc(%rax),%edx
  803346:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80334d:	00 00 00 
  803350:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  803352:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803359:	00 
  80335a:	76 08                	jbe    803364 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  80335c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803363:	00 
	fsipcbuf.write.req_n=n;
  803364:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80336b:	00 00 00 
  80336e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803372:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803376:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80337a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337e:	48 89 c6             	mov    %rax,%rsi
  803381:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803388:	00 00 00 
  80338b:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  803397:	be 00 00 00 00       	mov    $0x0,%esi
  80339c:	bf 04 00 00 00       	mov    $0x4,%edi
  8033a1:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  8033a8:	00 00 00 
  8033ab:	ff d0                	callq  *%rax
  8033ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8033b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033b3:	c9                   	leaveq 
  8033b4:	c3                   	retq   

00000000008033b5 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8033b5:	55                   	push   %rbp
  8033b6:	48 89 e5             	mov    %rsp,%rbp
  8033b9:	48 83 ec 10          	sub    $0x10,%rsp
  8033bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033c1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c8:	8b 50 0c             	mov    0xc(%rax),%edx
  8033cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033d2:	00 00 00 
  8033d5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8033d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033de:	00 00 00 
  8033e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033e4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033e7:	be 00 00 00 00       	mov    $0x0,%esi
  8033ec:	bf 02 00 00 00       	mov    $0x2,%edi
  8033f1:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  8033f8:	00 00 00 
  8033fb:	ff d0                	callq  *%rax
}
  8033fd:	c9                   	leaveq 
  8033fe:	c3                   	retq   

00000000008033ff <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033ff:	55                   	push   %rbp
  803400:	48 89 e5             	mov    %rsp,%rbp
  803403:	48 83 ec 20          	sub    $0x20,%rsp
  803407:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80340b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80340f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803413:	8b 50 0c             	mov    0xc(%rax),%edx
  803416:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80341d:	00 00 00 
  803420:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803422:	be 00 00 00 00       	mov    $0x0,%esi
  803427:	bf 05 00 00 00       	mov    $0x5,%edi
  80342c:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
  803438:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80343b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343f:	79 05                	jns    803446 <devfile_stat+0x47>
		return r;
  803441:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803444:	eb 56                	jmp    80349c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803446:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803451:	00 00 00 
  803454:	48 89 c7             	mov    %rax,%rdi
  803457:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  80345e:	00 00 00 
  803461:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803463:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80346a:	00 00 00 
  80346d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803473:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803477:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80347d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803484:	00 00 00 
  803487:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80348d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803491:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80349c:	c9                   	leaveq 
  80349d:	c3                   	retq   
	...

00000000008034a0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8034a0:	55                   	push   %rbp
  8034a1:	48 89 e5             	mov    %rsp,%rbp
  8034a4:	48 83 ec 20          	sub    $0x20,%rsp
  8034a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8034ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b2:	48 89 d6             	mov    %rdx,%rsi
  8034b5:	89 c7                	mov    %eax,%edi
  8034b7:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  8034be:	00 00 00 
  8034c1:	ff d0                	callq  *%rax
  8034c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ca:	79 05                	jns    8034d1 <fd2sockid+0x31>
		return r;
  8034cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cf:	eb 24                	jmp    8034f5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d5:	8b 10                	mov    (%rax),%edx
  8034d7:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8034de:	00 00 00 
  8034e1:	8b 00                	mov    (%rax),%eax
  8034e3:	39 c2                	cmp    %eax,%edx
  8034e5:	74 07                	je     8034ee <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8034e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034ec:	eb 07                	jmp    8034f5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8034ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8034f5:	c9                   	leaveq 
  8034f6:	c3                   	retq   

00000000008034f7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8034f7:	55                   	push   %rbp
  8034f8:	48 89 e5             	mov    %rsp,%rbp
  8034fb:	48 83 ec 20          	sub    $0x20,%rsp
  8034ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803502:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803506:	48 89 c7             	mov    %rax,%rdi
  803509:	48 b8 e6 27 80 00 00 	movabs $0x8027e6,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
  803515:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803518:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351c:	78 26                	js     803544 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80351e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803522:	ba 07 04 00 00       	mov    $0x407,%edx
  803527:	48 89 c6             	mov    %rax,%rsi
  80352a:	bf 00 00 00 00       	mov    $0x0,%edi
  80352f:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  803536:	00 00 00 
  803539:	ff d0                	callq  *%rax
  80353b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803542:	79 16                	jns    80355a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803544:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803547:	89 c7                	mov    %eax,%edi
  803549:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  803550:	00 00 00 
  803553:	ff d0                	callq  *%rax
		return r;
  803555:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803558:	eb 3a                	jmp    803594 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80355a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803565:	00 00 00 
  803568:	8b 12                	mov    (%rdx),%edx
  80356a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80356c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803570:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80357e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803585:	48 89 c7             	mov    %rax,%rdi
  803588:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
}
  803594:	c9                   	leaveq 
  803595:	c3                   	retq   

0000000000803596 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803596:	55                   	push   %rbp
  803597:	48 89 e5             	mov    %rsp,%rbp
  80359a:	48 83 ec 30          	sub    $0x30,%rsp
  80359e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035ac:	89 c7                	mov    %eax,%edi
  8035ae:	48 b8 a0 34 80 00 00 	movabs $0x8034a0,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
  8035ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c1:	79 05                	jns    8035c8 <accept+0x32>
		return r;
  8035c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c6:	eb 3b                	jmp    803603 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035cc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d3:	48 89 ce             	mov    %rcx,%rsi
  8035d6:	89 c7                	mov    %eax,%edi
  8035d8:	48 b8 e1 38 80 00 00 	movabs $0x8038e1,%rax
  8035df:	00 00 00 
  8035e2:	ff d0                	callq  *%rax
  8035e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035eb:	79 05                	jns    8035f2 <accept+0x5c>
		return r;
  8035ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f0:	eb 11                	jmp    803603 <accept+0x6d>
	return alloc_sockfd(r);
  8035f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f5:	89 c7                	mov    %eax,%edi
  8035f7:	48 b8 f7 34 80 00 00 	movabs $0x8034f7,%rax
  8035fe:	00 00 00 
  803601:	ff d0                	callq  *%rax
}
  803603:	c9                   	leaveq 
  803604:	c3                   	retq   

0000000000803605 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803605:	55                   	push   %rbp
  803606:	48 89 e5             	mov    %rsp,%rbp
  803609:	48 83 ec 20          	sub    $0x20,%rsp
  80360d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803610:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803614:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803617:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80361a:	89 c7                	mov    %eax,%edi
  80361c:	48 b8 a0 34 80 00 00 	movabs $0x8034a0,%rax
  803623:	00 00 00 
  803626:	ff d0                	callq  *%rax
  803628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80362f:	79 05                	jns    803636 <bind+0x31>
		return r;
  803631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803634:	eb 1b                	jmp    803651 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803636:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803639:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80363d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803640:	48 89 ce             	mov    %rcx,%rsi
  803643:	89 c7                	mov    %eax,%edi
  803645:	48 b8 60 39 80 00 00 	movabs $0x803960,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
}
  803651:	c9                   	leaveq 
  803652:	c3                   	retq   

0000000000803653 <shutdown>:

int
shutdown(int s, int how)
{
  803653:	55                   	push   %rbp
  803654:	48 89 e5             	mov    %rsp,%rbp
  803657:	48 83 ec 20          	sub    $0x20,%rsp
  80365b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80365e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803661:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803664:	89 c7                	mov    %eax,%edi
  803666:	48 b8 a0 34 80 00 00 	movabs $0x8034a0,%rax
  80366d:	00 00 00 
  803670:	ff d0                	callq  *%rax
  803672:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803675:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803679:	79 05                	jns    803680 <shutdown+0x2d>
		return r;
  80367b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367e:	eb 16                	jmp    803696 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803680:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803683:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803686:	89 d6                	mov    %edx,%esi
  803688:	89 c7                	mov    %eax,%edi
  80368a:	48 b8 c4 39 80 00 00 	movabs $0x8039c4,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
}
  803696:	c9                   	leaveq 
  803697:	c3                   	retq   

0000000000803698 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803698:	55                   	push   %rbp
  803699:	48 89 e5             	mov    %rsp,%rbp
  80369c:	48 83 ec 10          	sub    $0x10,%rsp
  8036a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8036a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a8:	48 89 c7             	mov    %rax,%rdi
  8036ab:	48 b8 28 45 80 00 00 	movabs $0x804528,%rax
  8036b2:	00 00 00 
  8036b5:	ff d0                	callq  *%rax
  8036b7:	83 f8 01             	cmp    $0x1,%eax
  8036ba:	75 17                	jne    8036d3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8036bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c0:	8b 40 0c             	mov    0xc(%rax),%eax
  8036c3:	89 c7                	mov    %eax,%edi
  8036c5:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  8036cc:	00 00 00 
  8036cf:	ff d0                	callq  *%rax
  8036d1:	eb 05                	jmp    8036d8 <devsock_close+0x40>
	else
		return 0;
  8036d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036d8:	c9                   	leaveq 
  8036d9:	c3                   	retq   

00000000008036da <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036da:	55                   	push   %rbp
  8036db:	48 89 e5             	mov    %rsp,%rbp
  8036de:	48 83 ec 20          	sub    $0x20,%rsp
  8036e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036e9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ef:	89 c7                	mov    %eax,%edi
  8036f1:	48 b8 a0 34 80 00 00 	movabs $0x8034a0,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
  8036fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803700:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803704:	79 05                	jns    80370b <connect+0x31>
		return r;
  803706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803709:	eb 1b                	jmp    803726 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80370b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80370e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803712:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803715:	48 89 ce             	mov    %rcx,%rsi
  803718:	89 c7                	mov    %eax,%edi
  80371a:	48 b8 31 3a 80 00 00 	movabs $0x803a31,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
}
  803726:	c9                   	leaveq 
  803727:	c3                   	retq   

0000000000803728 <listen>:

int
listen(int s, int backlog)
{
  803728:	55                   	push   %rbp
  803729:	48 89 e5             	mov    %rsp,%rbp
  80372c:	48 83 ec 20          	sub    $0x20,%rsp
  803730:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803733:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803736:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803739:	89 c7                	mov    %eax,%edi
  80373b:	48 b8 a0 34 80 00 00 	movabs $0x8034a0,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
  803747:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80374a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374e:	79 05                	jns    803755 <listen+0x2d>
		return r;
  803750:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803753:	eb 16                	jmp    80376b <listen+0x43>
	return nsipc_listen(r, backlog);
  803755:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375b:	89 d6                	mov    %edx,%esi
  80375d:	89 c7                	mov    %eax,%edi
  80375f:	48 b8 95 3a 80 00 00 	movabs $0x803a95,%rax
  803766:	00 00 00 
  803769:	ff d0                	callq  *%rax
}
  80376b:	c9                   	leaveq 
  80376c:	c3                   	retq   

000000000080376d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80376d:	55                   	push   %rbp
  80376e:	48 89 e5             	mov    %rsp,%rbp
  803771:	48 83 ec 20          	sub    $0x20,%rsp
  803775:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803779:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80377d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803785:	89 c2                	mov    %eax,%edx
  803787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378b:	8b 40 0c             	mov    0xc(%rax),%eax
  80378e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803792:	b9 00 00 00 00       	mov    $0x0,%ecx
  803797:	89 c7                	mov    %eax,%edi
  803799:	48 b8 d5 3a 80 00 00 	movabs $0x803ad5,%rax
  8037a0:	00 00 00 
  8037a3:	ff d0                	callq  *%rax
}
  8037a5:	c9                   	leaveq 
  8037a6:	c3                   	retq   

00000000008037a7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037a7:	55                   	push   %rbp
  8037a8:	48 89 e5             	mov    %rsp,%rbp
  8037ab:	48 83 ec 20          	sub    $0x20,%rsp
  8037af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bf:	89 c2                	mov    %eax,%edx
  8037c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c5:	8b 40 0c             	mov    0xc(%rax),%eax
  8037c8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037d1:	89 c7                	mov    %eax,%edi
  8037d3:	48 b8 a1 3b 80 00 00 	movabs $0x803ba1,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
}
  8037df:	c9                   	leaveq 
  8037e0:	c3                   	retq   

00000000008037e1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037e1:	55                   	push   %rbp
  8037e2:	48 89 e5             	mov    %rsp,%rbp
  8037e5:	48 83 ec 10          	sub    $0x10,%rsp
  8037e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8037f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f5:	48 be f3 4e 80 00 00 	movabs $0x804ef3,%rsi
  8037fc:	00 00 00 
  8037ff:	48 89 c7             	mov    %rax,%rdi
  803802:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803809:	00 00 00 
  80380c:	ff d0                	callq  *%rax
	return 0;
  80380e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803813:	c9                   	leaveq 
  803814:	c3                   	retq   

0000000000803815 <socket>:

int
socket(int domain, int type, int protocol)
{
  803815:	55                   	push   %rbp
  803816:	48 89 e5             	mov    %rsp,%rbp
  803819:	48 83 ec 20          	sub    $0x20,%rsp
  80381d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803820:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803823:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803826:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803829:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80382c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80382f:	89 ce                	mov    %ecx,%esi
  803831:	89 c7                	mov    %eax,%edi
  803833:	48 b8 59 3c 80 00 00 	movabs $0x803c59,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
  80383f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803842:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803846:	79 05                	jns    80384d <socket+0x38>
		return r;
  803848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384b:	eb 11                	jmp    80385e <socket+0x49>
	return alloc_sockfd(r);
  80384d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803850:	89 c7                	mov    %eax,%edi
  803852:	48 b8 f7 34 80 00 00 	movabs $0x8034f7,%rax
  803859:	00 00 00 
  80385c:	ff d0                	callq  *%rax
}
  80385e:	c9                   	leaveq 
  80385f:	c3                   	retq   

0000000000803860 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803860:	55                   	push   %rbp
  803861:	48 89 e5             	mov    %rsp,%rbp
  803864:	48 83 ec 10          	sub    $0x10,%rsp
  803868:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80386b:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803872:	00 00 00 
  803875:	8b 00                	mov    (%rax),%eax
  803877:	85 c0                	test   %eax,%eax
  803879:	75 1d                	jne    803898 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80387b:	bf 02 00 00 00       	mov    $0x2,%edi
  803880:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  803887:	00 00 00 
  80388a:	ff d0                	callq  *%rax
  80388c:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  803893:	00 00 00 
  803896:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803898:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80389f:	00 00 00 
  8038a2:	8b 00                	mov    (%rax),%eax
  8038a4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8038a7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038ac:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8038b3:	00 00 00 
  8038b6:	89 c7                	mov    %eax,%edi
  8038b8:	48 b8 50 26 80 00 00 	movabs $0x802650,%rax
  8038bf:	00 00 00 
  8038c2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8038c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8038c9:	be 00 00 00 00       	mov    $0x0,%esi
  8038ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d3:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  8038da:	00 00 00 
  8038dd:	ff d0                	callq  *%rax
}
  8038df:	c9                   	leaveq 
  8038e0:	c3                   	retq   

00000000008038e1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038e1:	55                   	push   %rbp
  8038e2:	48 89 e5             	mov    %rsp,%rbp
  8038e5:	48 83 ec 30          	sub    $0x30,%rsp
  8038e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8038f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038fb:	00 00 00 
  8038fe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803901:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803903:	bf 01 00 00 00       	mov    $0x1,%edi
  803908:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  80390f:	00 00 00 
  803912:	ff d0                	callq  *%rax
  803914:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803917:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391b:	78 3e                	js     80395b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80391d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803924:	00 00 00 
  803927:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80392b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392f:	8b 40 10             	mov    0x10(%rax),%eax
  803932:	89 c2                	mov    %eax,%edx
  803934:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803938:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393c:	48 89 ce             	mov    %rcx,%rsi
  80393f:	48 89 c7             	mov    %rax,%rdi
  803942:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  803949:	00 00 00 
  80394c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80394e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803952:	8b 50 10             	mov    0x10(%rax),%edx
  803955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803959:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80395b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80395e:	c9                   	leaveq 
  80395f:	c3                   	retq   

0000000000803960 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803960:	55                   	push   %rbp
  803961:	48 89 e5             	mov    %rsp,%rbp
  803964:	48 83 ec 10          	sub    $0x10,%rsp
  803968:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80396b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80396f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803972:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803979:	00 00 00 
  80397c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80397f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803981:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803988:	48 89 c6             	mov    %rax,%rsi
  80398b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803992:	00 00 00 
  803995:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  80399c:	00 00 00 
  80399f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8039a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a8:	00 00 00 
  8039ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039ae:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8039b1:	bf 02 00 00 00       	mov    $0x2,%edi
  8039b6:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
}
  8039c2:	c9                   	leaveq 
  8039c3:	c3                   	retq   

00000000008039c4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8039c4:	55                   	push   %rbp
  8039c5:	48 89 e5             	mov    %rsp,%rbp
  8039c8:	48 83 ec 10          	sub    $0x10,%rsp
  8039cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039cf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039d9:	00 00 00 
  8039dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8039e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e8:	00 00 00 
  8039eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039ee:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8039f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8039f6:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  8039fd:	00 00 00 
  803a00:	ff d0                	callq  *%rax
}
  803a02:	c9                   	leaveq 
  803a03:	c3                   	retq   

0000000000803a04 <nsipc_close>:

int
nsipc_close(int s)
{
  803a04:	55                   	push   %rbp
  803a05:	48 89 e5             	mov    %rsp,%rbp
  803a08:	48 83 ec 10          	sub    $0x10,%rsp
  803a0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a0f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a16:	00 00 00 
  803a19:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a1c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a1e:	bf 04 00 00 00       	mov    $0x4,%edi
  803a23:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	callq  *%rax
}
  803a2f:	c9                   	leaveq 
  803a30:	c3                   	retq   

0000000000803a31 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a31:	55                   	push   %rbp
  803a32:	48 89 e5             	mov    %rsp,%rbp
  803a35:	48 83 ec 10          	sub    $0x10,%rsp
  803a39:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a40:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a43:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a4a:	00 00 00 
  803a4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a50:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a52:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a59:	48 89 c6             	mov    %rax,%rsi
  803a5c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a63:	00 00 00 
  803a66:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a72:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a79:	00 00 00 
  803a7c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a7f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a82:	bf 05 00 00 00       	mov    $0x5,%edi
  803a87:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  803a8e:	00 00 00 
  803a91:	ff d0                	callq  *%rax
}
  803a93:	c9                   	leaveq 
  803a94:	c3                   	retq   

0000000000803a95 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a95:	55                   	push   %rbp
  803a96:	48 89 e5             	mov    %rsp,%rbp
  803a99:	48 83 ec 10          	sub    $0x10,%rsp
  803a9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803aa0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803aa3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aaa:	00 00 00 
  803aad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ab0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803ab2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ab9:	00 00 00 
  803abc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803abf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803ac2:	bf 06 00 00 00       	mov    $0x6,%edi
  803ac7:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  803ace:	00 00 00 
  803ad1:	ff d0                	callq  *%rax
}
  803ad3:	c9                   	leaveq 
  803ad4:	c3                   	retq   

0000000000803ad5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803ad5:	55                   	push   %rbp
  803ad6:	48 89 e5             	mov    %rsp,%rbp
  803ad9:	48 83 ec 30          	sub    $0x30,%rsp
  803add:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ae0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ae4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803ae7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803aea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803af1:	00 00 00 
  803af4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803af7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803af9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b00:	00 00 00 
  803b03:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b06:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b09:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b10:	00 00 00 
  803b13:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b16:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b19:	bf 07 00 00 00       	mov    $0x7,%edi
  803b1e:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  803b25:	00 00 00 
  803b28:	ff d0                	callq  *%rax
  803b2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b31:	78 69                	js     803b9c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b33:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b3a:	7f 08                	jg     803b44 <nsipc_recv+0x6f>
  803b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b42:	7e 35                	jle    803b79 <nsipc_recv+0xa4>
  803b44:	48 b9 fa 4e 80 00 00 	movabs $0x804efa,%rcx
  803b4b:	00 00 00 
  803b4e:	48 ba 0f 4f 80 00 00 	movabs $0x804f0f,%rdx
  803b55:	00 00 00 
  803b58:	be 61 00 00 00       	mov    $0x61,%esi
  803b5d:	48 bf 24 4f 80 00 00 	movabs $0x804f24,%rdi
  803b64:	00 00 00 
  803b67:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6c:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  803b73:	00 00 00 
  803b76:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b7c:	48 63 d0             	movslq %eax,%rdx
  803b7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b83:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803b8a:	00 00 00 
  803b8d:	48 89 c7             	mov    %rax,%rdi
  803b90:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
	}

	return r;
  803b9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b9f:	c9                   	leaveq 
  803ba0:	c3                   	retq   

0000000000803ba1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ba1:	55                   	push   %rbp
  803ba2:	48 89 e5             	mov    %rsp,%rbp
  803ba5:	48 83 ec 20          	sub    $0x20,%rsp
  803ba9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bb0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803bb3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803bb6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bbd:	00 00 00 
  803bc0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bc3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803bc5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803bcc:	7e 35                	jle    803c03 <nsipc_send+0x62>
  803bce:	48 b9 30 4f 80 00 00 	movabs $0x804f30,%rcx
  803bd5:	00 00 00 
  803bd8:	48 ba 0f 4f 80 00 00 	movabs $0x804f0f,%rdx
  803bdf:	00 00 00 
  803be2:	be 6c 00 00 00       	mov    $0x6c,%esi
  803be7:	48 bf 24 4f 80 00 00 	movabs $0x804f24,%rdi
  803bee:	00 00 00 
  803bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf6:	49 b8 20 0b 80 00 00 	movabs $0x800b20,%r8
  803bfd:	00 00 00 
  803c00:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c06:	48 63 d0             	movslq %eax,%rdx
  803c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0d:	48 89 c6             	mov    %rax,%rsi
  803c10:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803c17:	00 00 00 
  803c1a:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  803c21:	00 00 00 
  803c24:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c26:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c2d:	00 00 00 
  803c30:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c33:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c36:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c3d:	00 00 00 
  803c40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c43:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c46:	bf 08 00 00 00       	mov    $0x8,%edi
  803c4b:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
}
  803c57:	c9                   	leaveq 
  803c58:	c3                   	retq   

0000000000803c59 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c59:	55                   	push   %rbp
  803c5a:	48 89 e5             	mov    %rsp,%rbp
  803c5d:	48 83 ec 10          	sub    $0x10,%rsp
  803c61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c64:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c67:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c6a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c71:	00 00 00 
  803c74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c77:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c79:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c80:	00 00 00 
  803c83:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c86:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c89:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c90:	00 00 00 
  803c93:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c96:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c99:	bf 09 00 00 00       	mov    $0x9,%edi
  803c9e:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  803ca5:	00 00 00 
  803ca8:	ff d0                	callq  *%rax
}
  803caa:	c9                   	leaveq 
  803cab:	c3                   	retq   

0000000000803cac <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803cac:	55                   	push   %rbp
  803cad:	48 89 e5             	mov    %rsp,%rbp
  803cb0:	53                   	push   %rbx
  803cb1:	48 83 ec 38          	sub    $0x38,%rsp
  803cb5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803cb9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803cbd:	48 89 c7             	mov    %rax,%rdi
  803cc0:	48 b8 e6 27 80 00 00 	movabs $0x8027e6,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
  803ccc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ccf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cd3:	0f 88 bf 01 00 00    	js     803e98 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cdd:	ba 07 04 00 00       	mov    $0x407,%edx
  803ce2:	48 89 c6             	mov    %rax,%rsi
  803ce5:	bf 00 00 00 00       	mov    $0x0,%edi
  803cea:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  803cf1:	00 00 00 
  803cf4:	ff d0                	callq  *%rax
  803cf6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cfd:	0f 88 95 01 00 00    	js     803e98 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d03:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d07:	48 89 c7             	mov    %rax,%rdi
  803d0a:	48 b8 e6 27 80 00 00 	movabs $0x8027e6,%rax
  803d11:	00 00 00 
  803d14:	ff d0                	callq  *%rax
  803d16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d1d:	0f 88 5d 01 00 00    	js     803e80 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d27:	ba 07 04 00 00       	mov    $0x407,%edx
  803d2c:	48 89 c6             	mov    %rax,%rsi
  803d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d34:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  803d3b:	00 00 00 
  803d3e:	ff d0                	callq  *%rax
  803d40:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d43:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d47:	0f 88 33 01 00 00    	js     803e80 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d51:	48 89 c7             	mov    %rax,%rdi
  803d54:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  803d5b:	00 00 00 
  803d5e:	ff d0                	callq  *%rax
  803d60:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d68:	ba 07 04 00 00       	mov    $0x407,%edx
  803d6d:	48 89 c6             	mov    %rax,%rsi
  803d70:	bf 00 00 00 00       	mov    $0x0,%edi
  803d75:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  803d7c:	00 00 00 
  803d7f:	ff d0                	callq  *%rax
  803d81:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d84:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d88:	0f 88 d9 00 00 00    	js     803e67 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d92:	48 89 c7             	mov    %rax,%rdi
  803d95:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  803d9c:	00 00 00 
  803d9f:	ff d0                	callq  *%rax
  803da1:	48 89 c2             	mov    %rax,%rdx
  803da4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803dae:	48 89 d1             	mov    %rdx,%rcx
  803db1:	ba 00 00 00 00       	mov    $0x0,%edx
  803db6:	48 89 c6             	mov    %rax,%rsi
  803db9:	bf 00 00 00 00       	mov    $0x0,%edi
  803dbe:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  803dc5:	00 00 00 
  803dc8:	ff d0                	callq  *%rax
  803dca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dd1:	78 79                	js     803e4c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803dd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dd7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803dde:	00 00 00 
  803de1:	8b 12                	mov    (%rdx),%edx
  803de3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803de5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803df0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803df4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803dfb:	00 00 00 
  803dfe:	8b 12                	mov    (%rdx),%edx
  803e00:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e06:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e11:	48 89 c7             	mov    %rax,%rdi
  803e14:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  803e1b:	00 00 00 
  803e1e:	ff d0                	callq  *%rax
  803e20:	89 c2                	mov    %eax,%edx
  803e22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e26:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e2c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e34:	48 89 c7             	mov    %rax,%rdi
  803e37:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  803e3e:	00 00 00 
  803e41:	ff d0                	callq  *%rax
  803e43:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e45:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4a:	eb 4f                	jmp    803e9b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803e4c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803e4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e51:	48 89 c6             	mov    %rax,%rsi
  803e54:	bf 00 00 00 00       	mov    $0x0,%edi
  803e59:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  803e60:	00 00 00 
  803e63:	ff d0                	callq  *%rax
  803e65:	eb 01                	jmp    803e68 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803e67:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803e68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e6c:	48 89 c6             	mov    %rax,%rsi
  803e6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803e74:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  803e7b:	00 00 00 
  803e7e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803e80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e84:	48 89 c6             	mov    %rax,%rsi
  803e87:	bf 00 00 00 00       	mov    $0x0,%edi
  803e8c:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  803e93:	00 00 00 
  803e96:	ff d0                	callq  *%rax
    err:
	return r;
  803e98:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e9b:	48 83 c4 38          	add    $0x38,%rsp
  803e9f:	5b                   	pop    %rbx
  803ea0:	5d                   	pop    %rbp
  803ea1:	c3                   	retq   

0000000000803ea2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ea2:	55                   	push   %rbp
  803ea3:	48 89 e5             	mov    %rsp,%rbp
  803ea6:	53                   	push   %rbx
  803ea7:	48 83 ec 28          	sub    $0x28,%rsp
  803eab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803eaf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803eb3:	eb 01                	jmp    803eb6 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803eb5:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803eb6:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803ebd:	00 00 00 
  803ec0:	48 8b 00             	mov    (%rax),%rax
  803ec3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ec9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ecc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ed0:	48 89 c7             	mov    %rax,%rdi
  803ed3:	48 b8 28 45 80 00 00 	movabs $0x804528,%rax
  803eda:	00 00 00 
  803edd:	ff d0                	callq  *%rax
  803edf:	89 c3                	mov    %eax,%ebx
  803ee1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ee5:	48 89 c7             	mov    %rax,%rdi
  803ee8:	48 b8 28 45 80 00 00 	movabs $0x804528,%rax
  803eef:	00 00 00 
  803ef2:	ff d0                	callq  *%rax
  803ef4:	39 c3                	cmp    %eax,%ebx
  803ef6:	0f 94 c0             	sete   %al
  803ef9:	0f b6 c0             	movzbl %al,%eax
  803efc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803eff:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803f06:	00 00 00 
  803f09:	48 8b 00             	mov    (%rax),%rax
  803f0c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f12:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f18:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f1b:	75 0a                	jne    803f27 <_pipeisclosed+0x85>
			return ret;
  803f1d:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803f20:	48 83 c4 28          	add    $0x28,%rsp
  803f24:	5b                   	pop    %rbx
  803f25:	5d                   	pop    %rbp
  803f26:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803f27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f2a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f2d:	74 86                	je     803eb5 <_pipeisclosed+0x13>
  803f2f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f33:	75 80                	jne    803eb5 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f35:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803f3c:	00 00 00 
  803f3f:	48 8b 00             	mov    (%rax),%rax
  803f42:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f48:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f4e:	89 c6                	mov    %eax,%esi
  803f50:	48 bf 41 4f 80 00 00 	movabs $0x804f41,%rdi
  803f57:	00 00 00 
  803f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f5f:	49 b8 5b 0d 80 00 00 	movabs $0x800d5b,%r8
  803f66:	00 00 00 
  803f69:	41 ff d0             	callq  *%r8
	}
  803f6c:	e9 44 ff ff ff       	jmpq   803eb5 <_pipeisclosed+0x13>

0000000000803f71 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803f71:	55                   	push   %rbp
  803f72:	48 89 e5             	mov    %rsp,%rbp
  803f75:	48 83 ec 30          	sub    $0x30,%rsp
  803f79:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f7c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f80:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f83:	48 89 d6             	mov    %rdx,%rsi
  803f86:	89 c7                	mov    %eax,%edi
  803f88:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  803f8f:	00 00 00 
  803f92:	ff d0                	callq  *%rax
  803f94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9b:	79 05                	jns    803fa2 <pipeisclosed+0x31>
		return r;
  803f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa0:	eb 31                	jmp    803fd3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803fa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa6:	48 89 c7             	mov    %rax,%rdi
  803fa9:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  803fb0:	00 00 00 
  803fb3:	ff d0                	callq  *%rax
  803fb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fc1:	48 89 d6             	mov    %rdx,%rsi
  803fc4:	48 89 c7             	mov    %rax,%rdi
  803fc7:	48 b8 a2 3e 80 00 00 	movabs $0x803ea2,%rax
  803fce:	00 00 00 
  803fd1:	ff d0                	callq  *%rax
}
  803fd3:	c9                   	leaveq 
  803fd4:	c3                   	retq   

0000000000803fd5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fd5:	55                   	push   %rbp
  803fd6:	48 89 e5             	mov    %rsp,%rbp
  803fd9:	48 83 ec 40          	sub    $0x40,%rsp
  803fdd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fe1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fe5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803fe9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fed:	48 89 c7             	mov    %rax,%rdi
  803ff0:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  803ff7:	00 00 00 
  803ffa:	ff d0                	callq  *%rax
  803ffc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804000:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804004:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804008:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80400f:	00 
  804010:	e9 97 00 00 00       	jmpq   8040ac <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804015:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80401a:	74 09                	je     804025 <devpipe_read+0x50>
				return i;
  80401c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804020:	e9 95 00 00 00       	jmpq   8040ba <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804025:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804029:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80402d:	48 89 d6             	mov    %rdx,%rsi
  804030:	48 89 c7             	mov    %rax,%rdi
  804033:	48 b8 a2 3e 80 00 00 	movabs $0x803ea2,%rax
  80403a:	00 00 00 
  80403d:	ff d0                	callq  *%rax
  80403f:	85 c0                	test   %eax,%eax
  804041:	74 07                	je     80404a <devpipe_read+0x75>
				return 0;
  804043:	b8 00 00 00 00       	mov    $0x0,%eax
  804048:	eb 70                	jmp    8040ba <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80404a:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  804051:	00 00 00 
  804054:	ff d0                	callq  *%rax
  804056:	eb 01                	jmp    804059 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804058:	90                   	nop
  804059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405d:	8b 10                	mov    (%rax),%edx
  80405f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804063:	8b 40 04             	mov    0x4(%rax),%eax
  804066:	39 c2                	cmp    %eax,%edx
  804068:	74 ab                	je     804015 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80406a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80406e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804072:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80407a:	8b 00                	mov    (%rax),%eax
  80407c:	89 c2                	mov    %eax,%edx
  80407e:	c1 fa 1f             	sar    $0x1f,%edx
  804081:	c1 ea 1b             	shr    $0x1b,%edx
  804084:	01 d0                	add    %edx,%eax
  804086:	83 e0 1f             	and    $0x1f,%eax
  804089:	29 d0                	sub    %edx,%eax
  80408b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80408f:	48 98                	cltq   
  804091:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804096:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409c:	8b 00                	mov    (%rax),%eax
  80409e:	8d 50 01             	lea    0x1(%rax),%edx
  8040a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040b0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040b4:	72 a2                	jb     804058 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8040b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040ba:	c9                   	leaveq 
  8040bb:	c3                   	retq   

00000000008040bc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040bc:	55                   	push   %rbp
  8040bd:	48 89 e5             	mov    %rsp,%rbp
  8040c0:	48 83 ec 40          	sub    $0x40,%rsp
  8040c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040cc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d4:	48 89 c7             	mov    %rax,%rdi
  8040d7:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  8040de:	00 00 00 
  8040e1:	ff d0                	callq  *%rax
  8040e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8040e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040ef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040f6:	00 
  8040f7:	e9 93 00 00 00       	jmpq   80418f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8040fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804100:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804104:	48 89 d6             	mov    %rdx,%rsi
  804107:	48 89 c7             	mov    %rax,%rdi
  80410a:	48 b8 a2 3e 80 00 00 	movabs $0x803ea2,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
  804116:	85 c0                	test   %eax,%eax
  804118:	74 07                	je     804121 <devpipe_write+0x65>
				return 0;
  80411a:	b8 00 00 00 00       	mov    $0x0,%eax
  80411f:	eb 7c                	jmp    80419d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804121:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  804128:	00 00 00 
  80412b:	ff d0                	callq  *%rax
  80412d:	eb 01                	jmp    804130 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80412f:	90                   	nop
  804130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804134:	8b 40 04             	mov    0x4(%rax),%eax
  804137:	48 63 d0             	movslq %eax,%rdx
  80413a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80413e:	8b 00                	mov    (%rax),%eax
  804140:	48 98                	cltq   
  804142:	48 83 c0 20          	add    $0x20,%rax
  804146:	48 39 c2             	cmp    %rax,%rdx
  804149:	73 b1                	jae    8040fc <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80414b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80414f:	8b 40 04             	mov    0x4(%rax),%eax
  804152:	89 c2                	mov    %eax,%edx
  804154:	c1 fa 1f             	sar    $0x1f,%edx
  804157:	c1 ea 1b             	shr    $0x1b,%edx
  80415a:	01 d0                	add    %edx,%eax
  80415c:	83 e0 1f             	and    $0x1f,%eax
  80415f:	29 d0                	sub    %edx,%eax
  804161:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804165:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804169:	48 01 ca             	add    %rcx,%rdx
  80416c:	0f b6 0a             	movzbl (%rdx),%ecx
  80416f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804173:	48 98                	cltq   
  804175:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804179:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417d:	8b 40 04             	mov    0x4(%rax),%eax
  804180:	8d 50 01             	lea    0x1(%rax),%edx
  804183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804187:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80418a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80418f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804193:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804197:	72 96                	jb     80412f <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80419d:	c9                   	leaveq 
  80419e:	c3                   	retq   

000000000080419f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80419f:	55                   	push   %rbp
  8041a0:	48 89 e5             	mov    %rsp,%rbp
  8041a3:	48 83 ec 20          	sub    $0x20,%rsp
  8041a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041b3:	48 89 c7             	mov    %rax,%rdi
  8041b6:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  8041bd:	00 00 00 
  8041c0:	ff d0                	callq  *%rax
  8041c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8041c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ca:	48 be 54 4f 80 00 00 	movabs $0x804f54,%rsi
  8041d1:	00 00 00 
  8041d4:	48 89 c7             	mov    %rax,%rdi
  8041d7:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  8041de:	00 00 00 
  8041e1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8041e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041e7:	8b 50 04             	mov    0x4(%rax),%edx
  8041ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ee:	8b 00                	mov    (%rax),%eax
  8041f0:	29 c2                	sub    %eax,%edx
  8041f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8041fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804200:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804207:	00 00 00 
	stat->st_dev = &devpipe;
  80420a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80420e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  804215:	00 00 00 
  804218:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80421f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804224:	c9                   	leaveq 
  804225:	c3                   	retq   

0000000000804226 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804226:	55                   	push   %rbp
  804227:	48 89 e5             	mov    %rsp,%rbp
  80422a:	48 83 ec 10          	sub    $0x10,%rsp
  80422e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804236:	48 89 c6             	mov    %rax,%rsi
  804239:	bf 00 00 00 00       	mov    $0x0,%edi
  80423e:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  804245:	00 00 00 
  804248:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80424a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80424e:	48 89 c7             	mov    %rax,%rdi
  804251:	48 b8 bb 27 80 00 00 	movabs $0x8027bb,%rax
  804258:	00 00 00 
  80425b:	ff d0                	callq  *%rax
  80425d:	48 89 c6             	mov    %rax,%rsi
  804260:	bf 00 00 00 00       	mov    $0x0,%edi
  804265:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  80426c:	00 00 00 
  80426f:	ff d0                	callq  *%rax
}
  804271:	c9                   	leaveq 
  804272:	c3                   	retq   
	...

0000000000804274 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804274:	55                   	push   %rbp
  804275:	48 89 e5             	mov    %rsp,%rbp
  804278:	48 83 ec 20          	sub    $0x20,%rsp
  80427c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80427f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804282:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804285:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804289:	be 01 00 00 00       	mov    $0x1,%esi
  80428e:	48 89 c7             	mov    %rax,%rdi
  804291:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  804298:	00 00 00 
  80429b:	ff d0                	callq  *%rax
}
  80429d:	c9                   	leaveq 
  80429e:	c3                   	retq   

000000000080429f <getchar>:

int
getchar(void)
{
  80429f:	55                   	push   %rbp
  8042a0:	48 89 e5             	mov    %rsp,%rbp
  8042a3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8042a7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8042ab:	ba 01 00 00 00       	mov    $0x1,%edx
  8042b0:	48 89 c6             	mov    %rax,%rsi
  8042b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8042b8:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  8042bf:	00 00 00 
  8042c2:	ff d0                	callq  *%rax
  8042c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8042c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042cb:	79 05                	jns    8042d2 <getchar+0x33>
		return r;
  8042cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d0:	eb 14                	jmp    8042e6 <getchar+0x47>
	if (r < 1)
  8042d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042d6:	7f 07                	jg     8042df <getchar+0x40>
		return -E_EOF;
  8042d8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8042dd:	eb 07                	jmp    8042e6 <getchar+0x47>
	return c;
  8042df:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8042e3:	0f b6 c0             	movzbl %al,%eax
}
  8042e6:	c9                   	leaveq 
  8042e7:	c3                   	retq   

00000000008042e8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042e8:	55                   	push   %rbp
  8042e9:	48 89 e5             	mov    %rsp,%rbp
  8042ec:	48 83 ec 20          	sub    $0x20,%rsp
  8042f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042fa:	48 89 d6             	mov    %rdx,%rsi
  8042fd:	89 c7                	mov    %eax,%edi
  8042ff:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  804306:	00 00 00 
  804309:	ff d0                	callq  *%rax
  80430b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80430e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804312:	79 05                	jns    804319 <iscons+0x31>
		return r;
  804314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804317:	eb 1a                	jmp    804333 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431d:	8b 10                	mov    (%rax),%edx
  80431f:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804326:	00 00 00 
  804329:	8b 00                	mov    (%rax),%eax
  80432b:	39 c2                	cmp    %eax,%edx
  80432d:	0f 94 c0             	sete   %al
  804330:	0f b6 c0             	movzbl %al,%eax
}
  804333:	c9                   	leaveq 
  804334:	c3                   	retq   

0000000000804335 <opencons>:

int
opencons(void)
{
  804335:	55                   	push   %rbp
  804336:	48 89 e5             	mov    %rsp,%rbp
  804339:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80433d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804341:	48 89 c7             	mov    %rax,%rdi
  804344:	48 b8 e6 27 80 00 00 	movabs $0x8027e6,%rax
  80434b:	00 00 00 
  80434e:	ff d0                	callq  *%rax
  804350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804353:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804357:	79 05                	jns    80435e <opencons+0x29>
		return r;
  804359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435c:	eb 5b                	jmp    8043b9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80435e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804362:	ba 07 04 00 00       	mov    $0x407,%edx
  804367:	48 89 c6             	mov    %rax,%rsi
  80436a:	bf 00 00 00 00       	mov    $0x0,%edi
  80436f:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  804376:	00 00 00 
  804379:	ff d0                	callq  *%rax
  80437b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80437e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804382:	79 05                	jns    804389 <opencons+0x54>
		return r;
  804384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804387:	eb 30                	jmp    8043b9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80438d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804394:	00 00 00 
  804397:	8b 12                	mov    (%rdx),%edx
  804399:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80439b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8043a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043aa:	48 89 c7             	mov    %rax,%rdi
  8043ad:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  8043b4:	00 00 00 
  8043b7:	ff d0                	callq  *%rax
}
  8043b9:	c9                   	leaveq 
  8043ba:	c3                   	retq   

00000000008043bb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043bb:	55                   	push   %rbp
  8043bc:	48 89 e5             	mov    %rsp,%rbp
  8043bf:	48 83 ec 30          	sub    $0x30,%rsp
  8043c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043cf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043d4:	75 13                	jne    8043e9 <devcons_read+0x2e>
		return 0;
  8043d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8043db:	eb 49                	jmp    804426 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8043dd:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  8043e4:	00 00 00 
  8043e7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8043e9:	48 b8 52 21 80 00 00 	movabs $0x802152,%rax
  8043f0:	00 00 00 
  8043f3:	ff d0                	callq  *%rax
  8043f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043fc:	74 df                	je     8043dd <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8043fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804402:	79 05                	jns    804409 <devcons_read+0x4e>
		return c;
  804404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804407:	eb 1d                	jmp    804426 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804409:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80440d:	75 07                	jne    804416 <devcons_read+0x5b>
		return 0;
  80440f:	b8 00 00 00 00       	mov    $0x0,%eax
  804414:	eb 10                	jmp    804426 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804419:	89 c2                	mov    %eax,%edx
  80441b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80441f:	88 10                	mov    %dl,(%rax)
	return 1;
  804421:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804426:	c9                   	leaveq 
  804427:	c3                   	retq   

0000000000804428 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804428:	55                   	push   %rbp
  804429:	48 89 e5             	mov    %rsp,%rbp
  80442c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804433:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80443a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804441:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804448:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80444f:	eb 77                	jmp    8044c8 <devcons_write+0xa0>
		m = n - tot;
  804451:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804458:	89 c2                	mov    %eax,%edx
  80445a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80445d:	89 d1                	mov    %edx,%ecx
  80445f:	29 c1                	sub    %eax,%ecx
  804461:	89 c8                	mov    %ecx,%eax
  804463:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804466:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804469:	83 f8 7f             	cmp    $0x7f,%eax
  80446c:	76 07                	jbe    804475 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80446e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804475:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804478:	48 63 d0             	movslq %eax,%rdx
  80447b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80447e:	48 98                	cltq   
  804480:	48 89 c1             	mov    %rax,%rcx
  804483:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80448a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804491:	48 89 ce             	mov    %rcx,%rsi
  804494:	48 89 c7             	mov    %rax,%rdi
  804497:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  80449e:	00 00 00 
  8044a1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8044a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044a6:	48 63 d0             	movslq %eax,%rdx
  8044a9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044b0:	48 89 d6             	mov    %rdx,%rsi
  8044b3:	48 89 c7             	mov    %rax,%rdi
  8044b6:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  8044bd:	00 00 00 
  8044c0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044c5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044cb:	48 98                	cltq   
  8044cd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044d4:	0f 82 77 ff ff ff    	jb     804451 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8044da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044dd:	c9                   	leaveq 
  8044de:	c3                   	retq   

00000000008044df <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8044df:	55                   	push   %rbp
  8044e0:	48 89 e5             	mov    %rsp,%rbp
  8044e3:	48 83 ec 08          	sub    $0x8,%rsp
  8044e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044f0:	c9                   	leaveq 
  8044f1:	c3                   	retq   

00000000008044f2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8044f2:	55                   	push   %rbp
  8044f3:	48 89 e5             	mov    %rsp,%rbp
  8044f6:	48 83 ec 10          	sub    $0x10,%rsp
  8044fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804506:	48 be 60 4f 80 00 00 	movabs $0x804f60,%rsi
  80450d:	00 00 00 
  804510:	48 89 c7             	mov    %rax,%rdi
  804513:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  80451a:	00 00 00 
  80451d:	ff d0                	callq  *%rax
	return 0;
  80451f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804524:	c9                   	leaveq 
  804525:	c3                   	retq   
	...

0000000000804528 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804528:	55                   	push   %rbp
  804529:	48 89 e5             	mov    %rsp,%rbp
  80452c:	48 83 ec 18          	sub    $0x18,%rsp
  804530:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804538:	48 89 c2             	mov    %rax,%rdx
  80453b:	48 c1 ea 15          	shr    $0x15,%rdx
  80453f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804546:	01 00 00 
  804549:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80454d:	83 e0 01             	and    $0x1,%eax
  804550:	48 85 c0             	test   %rax,%rax
  804553:	75 07                	jne    80455c <pageref+0x34>
		return 0;
  804555:	b8 00 00 00 00       	mov    $0x0,%eax
  80455a:	eb 53                	jmp    8045af <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80455c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804560:	48 89 c2             	mov    %rax,%rdx
  804563:	48 c1 ea 0c          	shr    $0xc,%rdx
  804567:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80456e:	01 00 00 
  804571:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804575:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804579:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80457d:	83 e0 01             	and    $0x1,%eax
  804580:	48 85 c0             	test   %rax,%rax
  804583:	75 07                	jne    80458c <pageref+0x64>
		return 0;
  804585:	b8 00 00 00 00       	mov    $0x0,%eax
  80458a:	eb 23                	jmp    8045af <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80458c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804590:	48 89 c2             	mov    %rax,%rdx
  804593:	48 c1 ea 0c          	shr    $0xc,%rdx
  804597:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80459e:	00 00 00 
  8045a1:	48 c1 e2 04          	shl    $0x4,%rdx
  8045a5:	48 01 d0             	add    %rdx,%rax
  8045a8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8045ac:	0f b7 c0             	movzwl %ax,%eax
}
  8045af:	c9                   	leaveq 
  8045b0:	c3                   	retq   
