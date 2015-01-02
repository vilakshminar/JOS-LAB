
obj/user/sh.debug:     file format elf64-x86-64


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
  80003c:	e8 0b 11 00 00       	callq  80114c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004f:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005d:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800064:	be 00 00 00 00       	mov    $0x0,%esi
  800069:	48 89 c7             	mov    %rax,%rdi
  80006c:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax

again:
	argc = 0;
  800078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007f:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800086:	48 89 c6             	mov    %rax,%rsi
  800089:	bf 00 00 00 00       	mov    $0x0,%edi
  80008e:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
  80009a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000a0:	83 f8 77             	cmp    $0x77,%eax
  8000a3:	74 2e                	je     8000d3 <runcmd+0x8f>
  8000a5:	83 f8 77             	cmp    $0x77,%eax
  8000a8:	7f 1b                	jg     8000c5 <runcmd+0x81>
  8000aa:	83 f8 3c             	cmp    $0x3c,%eax
  8000ad:	74 6e                	je     80011d <runcmd+0xd9>
  8000af:	83 f8 3e             	cmp    $0x3e,%eax
  8000b2:	0f 84 3a 01 00 00    	je     8001f2 <runcmd+0x1ae>
  8000b8:	85 c0                	test   %eax,%eax
  8000ba:	0f 84 af 03 00 00    	je     80046f <runcmd+0x42b>
  8000c0:	e9 71 03 00 00       	jmpq   800436 <runcmd+0x3f2>
  8000c5:	83 f8 7c             	cmp    $0x7c,%eax
  8000c8:	0f 84 f9 01 00 00    	je     8002c7 <runcmd+0x283>
  8000ce:	e9 63 03 00 00       	jmpq   800436 <runcmd+0x3f2>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d3:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d7:	75 27                	jne    800100 <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d9:	48 bf 08 66 80 00 00 	movabs $0x806608,%rdi
  8000e0:	00 00 00 
  8000e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e8:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  8000ef:	00 00 00 
  8000f2:	ff d2                	callq  *%rdx
				exit();
  8000f4:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  800100:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	48 98                	cltq   
  80010c:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800113:	ff 
  800114:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
  800118:	e9 4d 03 00 00       	jmpq   80046a <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011d:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800124:	48 89 c6             	mov    %rax,%rsi
  800127:	bf 00 00 00 00       	mov    $0x0,%edi
  80012c:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800133:	00 00 00 
  800136:	ff d0                	callq  *%rax
  800138:	83 f8 77             	cmp    $0x77,%eax
  80013b:	74 27                	je     800164 <runcmd+0x120>
				cprintf("syntax error: < not followed by word\n");
  80013d:	48 bf 20 66 80 00 00 	movabs $0x806620,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800153:	00 00 00 
  800156:	ff d2                	callq  *%rdx
				exit();
  800158:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  80015f:	00 00 00 
  800162:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800164:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016b:	be 00 00 00 00       	mov    $0x0,%esi
  800170:	48 89 c7             	mov    %rax,%rdi
  800173:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
  80017f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800182:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800186:	79 34                	jns    8001bc <runcmd+0x178>
				cprintf("open %s for read: %e", t, fd);
  800188:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80018f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800192:	48 89 c6             	mov    %rax,%rsi
  800195:	48 bf 46 66 80 00 00 	movabs $0x806646,%rdi
  80019c:	00 00 00 
  80019f:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a4:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  8001ab:	00 00 00 
  8001ae:	ff d1                	callq  *%rcx
				exit();
  8001b0:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c0:	0f 84 a0 02 00 00    	je     800466 <runcmd+0x422>
				dup(fd, 0);
  8001c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c9:	be 00 00 00 00       	mov    $0x0,%esi
  8001ce:	89 c7                	mov    %eax,%edi
  8001d0:	48 b8 f7 3a 80 00 00 	movabs $0x803af7,%rax
  8001d7:	00 00 00 
  8001da:	ff d0                	callq  *%rax
				close(fd);
  8001dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001df:	89 c7                	mov    %eax,%edi
  8001e1:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  8001e8:	00 00 00 
  8001eb:	ff d0                	callq  *%rax
			}
			break;
  8001ed:	e9 74 02 00 00       	jmpq   800466 <runcmd+0x422>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f2:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001f9:	48 89 c6             	mov    %rax,%rsi
  8001fc:	bf 00 00 00 00       	mov    $0x0,%edi
  800201:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800208:	00 00 00 
  80020b:	ff d0                	callq  *%rax
  80020d:	83 f8 77             	cmp    $0x77,%eax
  800210:	74 27                	je     800239 <runcmd+0x1f5>
				cprintf("syntax error: > not followed by word\n");
  800212:	48 bf 60 66 80 00 00 	movabs $0x806660,%rdi
  800219:	00 00 00 
  80021c:	b8 00 00 00 00       	mov    $0x0,%eax
  800221:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800228:	00 00 00 
  80022b:	ff d2                	callq  *%rdx
				exit();
  80022d:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800239:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800240:	be 01 03 00 00       	mov    $0x301,%esi
  800245:	48 89 c7             	mov    %rax,%rdi
  800248:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  80024f:	00 00 00 
  800252:	ff d0                	callq  *%rax
  800254:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800257:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025b:	79 34                	jns    800291 <runcmd+0x24d>
				cprintf("open %s for write: %e", t, fd);
  80025d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800264:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800267:	48 89 c6             	mov    %rax,%rsi
  80026a:	48 bf 86 66 80 00 00 	movabs $0x806686,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  800280:	00 00 00 
  800283:	ff d1                	callq  *%rcx
				exit();
  800285:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  80028c:	00 00 00 
  80028f:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800291:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800295:	0f 84 ce 01 00 00    	je     800469 <runcmd+0x425>
				dup(fd, 1);
  80029b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029e:	be 01 00 00 00       	mov    $0x1,%esi
  8002a3:	89 c7                	mov    %eax,%edi
  8002a5:	48 b8 f7 3a 80 00 00 	movabs $0x803af7,%rax
  8002ac:	00 00 00 
  8002af:	ff d0                	callq  *%rax
				close(fd);
  8002b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b4:	89 c7                	mov    %eax,%edi
  8002b6:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
			}
			break;
  8002c2:	e9 a2 01 00 00       	jmpq   800469 <runcmd+0x425>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002c7:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002ce:	48 89 c7             	mov    %rax,%rdi
  8002d1:	48 b8 b0 5b 80 00 00 	movabs $0x805bb0,%rax
  8002d8:	00 00 00 
  8002db:	ff d0                	callq  *%rax
  8002dd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e4:	79 2c                	jns    800312 <runcmd+0x2ce>
				cprintf("pipe: %e", r);
  8002e6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e9:	89 c6                	mov    %eax,%esi
  8002eb:	48 bf 9c 66 80 00 00 	movabs $0x80669c,%rdi
  8002f2:	00 00 00 
  8002f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fa:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800301:	00 00 00 
  800304:	ff d2                	callq  *%rdx
				exit();
  800306:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  80030d:	00 00 00 
  800310:	ff d0                	callq  *%rax
			}
			if (debug)
  800312:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800319:	00 00 00 
  80031c:	8b 00                	mov    (%rax),%eax
  80031e:	85 c0                	test   %eax,%eax
  800320:	74 29                	je     80034b <runcmd+0x307>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800322:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  800328:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80032e:	89 c6                	mov    %eax,%esi
  800330:	48 bf a5 66 80 00 00 	movabs $0x8066a5,%rdi
  800337:	00 00 00 
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  800346:	00 00 00 
  800349:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034b:	48 b8 7b 31 80 00 00 	movabs $0x80317b,%rax
  800352:	00 00 00 
  800355:	ff d0                	callq  *%rax
  800357:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80035e:	79 2c                	jns    80038c <runcmd+0x348>
				cprintf("fork: %e", r);
  800360:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800363:	89 c6                	mov    %eax,%esi
  800365:	48 bf b2 66 80 00 00 	movabs $0x8066b2,%rdi
  80036c:	00 00 00 
  80036f:	b8 00 00 00 00       	mov    $0x0,%eax
  800374:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  80037b:	00 00 00 
  80037e:	ff d2                	callq  *%rdx
				exit();
  800380:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  800387:	00 00 00 
  80038a:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800390:	75 50                	jne    8003e2 <runcmd+0x39e>
				if (p[0] != 0) {
  800392:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	74 2d                	je     8003c9 <runcmd+0x385>
					dup(p[0], 0);
  80039c:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a2:	be 00 00 00 00       	mov    $0x0,%esi
  8003a7:	89 c7                	mov    %eax,%edi
  8003a9:	48 b8 f7 3a 80 00 00 	movabs $0x803af7,%rax
  8003b0:	00 00 00 
  8003b3:	ff d0                	callq  *%rax
					close(p[0]);
  8003b5:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003bb:	89 c7                	mov    %eax,%edi
  8003bd:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  8003c4:	00 00 00 
  8003c7:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003c9:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003cf:	89 c7                	mov    %eax,%edi
  8003d1:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  8003d8:	00 00 00 
  8003db:	ff d0                	callq  *%rax
				goto again;
  8003dd:	e9 96 fc ff ff       	jmpq   800078 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e5:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003e8:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003ee:	83 f8 01             	cmp    $0x1,%eax
  8003f1:	74 2d                	je     800420 <runcmd+0x3dc>
					dup(p[1], 1);
  8003f3:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f9:	be 01 00 00 00       	mov    $0x1,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 f7 3a 80 00 00 	movabs $0x803af7,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
					close(p[1]);
  80040c:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800412:	89 c7                	mov    %eax,%edi
  800414:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800420:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800426:	89 c7                	mov    %eax,%edi
  800428:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  80042f:	00 00 00 
  800432:	ff d0                	callq  *%rax
				goto runit;
  800434:	eb 3a                	jmp    800470 <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800436:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800439:	89 c1                	mov    %eax,%ecx
  80043b:	48 ba bb 66 80 00 00 	movabs $0x8066bb,%rdx
  800442:	00 00 00 
  800445:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044a:	48 bf d7 66 80 00 00 	movabs $0x8066d7,%rdi
  800451:	00 00 00 
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
  800459:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  800460:	00 00 00 
  800463:	41 ff d0             	callq  *%r8
			}
			if (fd != 0) {
				dup(fd, 0);
				close(fd);
			}
			break;
  800466:	90                   	nop
  800467:	eb 01                	jmp    80046a <runcmd+0x426>
			}
			if (fd != 1) {
				dup(fd, 1);
				close(fd);
			}
			break;
  800469:	90                   	nop
		default:
			panic("bad return %d from gettoken", c);
			break;

		}
	}
  80046a:	e9 10 fc ff ff       	jmpq   80007f <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  80046f:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  800470:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800474:	75 34                	jne    8004aa <runcmd+0x466>
		if (debug)
  800476:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80047d:	00 00 00 
  800480:	8b 00                	mov    (%rax),%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	0f 84 7b 03 00 00    	je     800805 <runcmd+0x7c1>
			cprintf("EMPTY COMMAND\n");
  80048a:	48 bf e1 66 80 00 00 	movabs $0x8066e1,%rdi
  800491:	00 00 00 
  800494:	b8 00 00 00 00       	mov    $0x0,%eax
  800499:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  8004a0:	00 00 00 
  8004a3:	ff d2                	callq  *%rdx
		return;
  8004a5:	e9 5b 03 00 00       	jmpq   800805 <runcmd+0x7c1>
	}
    
    //Search in all the PATH's for the binary
    struct Stat st;
    for(i=0;i<npaths;i++) {
  8004aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b1:	e9 8a 00 00 00       	jmpq   800540 <runcmd+0x4fc>
        strcpy(argv0buf, PATH[i]);
  8004b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004bd:	00 00 00 
  8004c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c3:	48 63 d2             	movslq %edx,%rdx
  8004c6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004ca:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d1:	48 89 d6             	mov    %rdx,%rsi
  8004d4:	48 89 c7             	mov    %rax,%rdi
  8004d7:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8004de:	00 00 00 
  8004e1:	ff d0                	callq  *%rax
        strcat(argv0buf, argv[0]);
  8004e3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004ea:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f1:	48 89 d6             	mov    %rdx,%rsi
  8004f4:	48 89 c7             	mov    %rax,%rdi
  8004f7:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
        r = stat(argv0buf, &st);
  800503:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  80050a:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800511:	48 89 d6             	mov    %rdx,%rsi
  800514:	48 89 c7             	mov    %rax,%rdi
  800517:	48 b8 90 40 80 00 00 	movabs $0x804090,%rax
  80051e:	00 00 00 
  800521:	ff d0                	callq  *%rax
  800523:	89 45 e8             	mov    %eax,-0x18(%rbp)
        if(r==0) {
  800526:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80052a:	75 10                	jne    80053c <runcmd+0x4f8>
           argv[0] = argv0buf;
  80052c:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800533:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
           break; 
  80053a:	eb 19                	jmp    800555 <runcmd+0x511>
		return;
	}
    
    //Search in all the PATH's for the binary
    struct Stat st;
    for(i=0;i<npaths;i++) {
  80053c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800540:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800547:	00 00 00 
  80054a:	8b 00                	mov    (%rax),%eax
  80054c:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054f:	0f 8c 61 ff ff ff    	jl     8004b6 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800555:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055c:	0f b6 00             	movzbl (%rax),%eax
  80055f:	3c 2f                	cmp    $0x2f,%al
  800561:	74 39                	je     80059c <runcmd+0x558>
		argv0buf[0] = '/';
  800563:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  80056a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800571:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800578:	48 83 c2 01          	add    $0x1,%rdx
  80057c:	48 89 c6             	mov    %rax,%rsi
  80057f:	48 89 d7             	mov    %rdx,%rdi
  800582:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  800589:	00 00 00 
  80058c:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058e:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800595:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059f:	48 98                	cltq   
  8005a1:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a8:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8005b4:	00 00 00 
  8005b7:	8b 00                	mov    (%rax),%eax
  8005b9:	85 c0                	test   %eax,%eax
  8005bb:	0f 84 95 00 00 00    	je     800656 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c1:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  8005c8:	00 00 00 
  8005cb:	48 8b 00             	mov    (%rax),%rax
  8005ce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d4:	89 c6                	mov    %eax,%esi
  8005d6:	48 bf f0 66 80 00 00 	movabs $0x8066f0,%rdi
  8005dd:	00 00 00 
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  8005ec:	00 00 00 
  8005ef:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f8:	eb 2f                	jmp    800629 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fd:	48 98                	cltq   
  8005ff:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800606:	ff 
  800607:	48 89 c6             	mov    %rax,%rsi
  80060a:	48 bf fe 66 80 00 00 	movabs $0x8066fe,%rdi
  800611:	00 00 00 
  800614:	b8 00 00 00 00       	mov    $0x0,%eax
  800619:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800620:	00 00 00 
  800623:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800625:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800629:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062c:	48 98                	cltq   
  80062e:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800635:	ff 
  800636:	48 85 c0             	test   %rax,%rax
  800639:	75 bf                	jne    8005fa <runcmd+0x5b6>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063b:	48 bf 02 67 80 00 00 	movabs $0x806702,%rdi
  800642:	00 00 00 
  800645:	b8 00 00 00 00       	mov    $0x0,%eax
  80064a:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800651:	00 00 00 
  800654:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800656:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065d:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800664:	48 89 d6             	mov    %rdx,%rsi
  800667:	48 89 c7             	mov    %rax,%rdi
  80066a:	48 b8 98 47 80 00 00 	movabs $0x804798,%rax
  800671:	00 00 00 
  800674:	ff d0                	callq  *%rax
  800676:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800679:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067d:	79 28                	jns    8006a7 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800686:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800689:	48 89 c6             	mov    %rax,%rsi
  80068c:	48 bf 04 67 80 00 00 	movabs $0x806704,%rdi
  800693:	00 00 00 
  800696:	b8 00 00 00 00       	mov    $0x0,%eax
  80069b:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  8006a2:	00 00 00 
  8006a5:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a7:	48 b8 c9 3a 80 00 00 	movabs $0x803ac9,%rax
  8006ae:	00 00 00 
  8006b1:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b7:	0f 88 9c 00 00 00    	js     800759 <runcmd+0x715>
		if (debug)
  8006bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8006c4:	00 00 00 
  8006c7:	8b 00                	mov    (%rax),%eax
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	74 3b                	je     800708 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cd:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d4:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  8006db:	00 00 00 
  8006de:	48 8b 00             	mov    (%rax),%rax
  8006e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006ea:	89 c6                	mov    %eax,%esi
  8006ec:	48 bf 12 67 80 00 00 	movabs $0x806712,%rdi
  8006f3:	00 00 00 
  8006f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fb:	49 b8 4f 14 80 00 00 	movabs $0x80144f,%r8
  800702:	00 00 00 
  800705:	41 ff d0             	callq  *%r8
		wait(r);
  800708:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070b:	89 c7                	mov    %eax,%edi
  80070d:	48 b8 78 61 80 00 00 	movabs $0x806178,%rax
  800714:	00 00 00 
  800717:	ff d0                	callq  *%rax
		if (debug)
  800719:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800720:	00 00 00 
  800723:	8b 00                	mov    (%rax),%eax
  800725:	85 c0                	test   %eax,%eax
  800727:	74 30                	je     800759 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800729:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  800730:	00 00 00 
  800733:	48 8b 00             	mov    (%rax),%rax
  800736:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073c:	89 c6                	mov    %eax,%esi
  80073e:	48 bf 27 67 80 00 00 	movabs $0x806727,%rdi
  800745:	00 00 00 
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
  80074d:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800754:	00 00 00 
  800757:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800759:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075d:	0f 84 94 00 00 00    	je     8007f7 <runcmd+0x7b3>
		if (debug)
  800763:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80076a:	00 00 00 
  80076d:	8b 00                	mov    (%rax),%eax
  80076f:	85 c0                	test   %eax,%eax
  800771:	74 33                	je     8007a6 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800773:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  80077a:	00 00 00 
  80077d:	48 8b 00             	mov    (%rax),%rax
  800780:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800786:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800789:	89 c6                	mov    %eax,%esi
  80078b:	48 bf 3d 67 80 00 00 	movabs $0x80673d,%rdi
  800792:	00 00 00 
  800795:	b8 00 00 00 00       	mov    $0x0,%eax
  80079a:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  8007a1:	00 00 00 
  8007a4:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a9:	89 c7                	mov    %eax,%edi
  8007ab:	48 b8 78 61 80 00 00 	movabs $0x806178,%rax
  8007b2:	00 00 00 
  8007b5:	ff d0                	callq  *%rax
		if (debug)
  8007b7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8007be:	00 00 00 
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	74 30                	je     8007f7 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c7:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  8007ce:	00 00 00 
  8007d1:	48 8b 00             	mov    (%rax),%rax
  8007d4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007da:	89 c6                	mov    %eax,%esi
  8007dc:	48 bf 27 67 80 00 00 	movabs $0x806727,%rdi
  8007e3:	00 00 00 
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  8007f2:	00 00 00 
  8007f5:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f7:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  8007fe:	00 00 00 
  800801:	ff d0                	callq  *%rax
  800803:	eb 01                	jmp    800806 <runcmd+0x7c2>
runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
		if (debug)
			cprintf("EMPTY COMMAND\n");
		return;
  800805:	90                   	nop
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  800806:	c9                   	leaveq 
  800807:	c3                   	retq   

0000000000800808 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800808:	55                   	push   %rbp
  800809:	48 89 e5             	mov    %rsp,%rbp
  80080c:	48 83 ec 30          	sub    $0x30,%rsp
  800810:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800814:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800818:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  80081c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800821:	75 36                	jne    800859 <_gettoken+0x51>
		if (debug > 1)
  800823:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80082a:	00 00 00 
  80082d:	8b 00                	mov    (%rax),%eax
  80082f:	83 f8 01             	cmp    $0x1,%eax
  800832:	7e 1b                	jle    80084f <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800834:	48 bf 5a 67 80 00 00 	movabs $0x80675a,%rdi
  80083b:	00 00 00 
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  80084a:	00 00 00 
  80084d:	ff d2                	callq  *%rdx
		return 0;
  80084f:	b8 00 00 00 00       	mov    $0x0,%eax
  800854:	e9 fe 01 00 00       	jmpq   800a57 <_gettoken+0x24f>
	}

	if (debug > 1)
  800859:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800860:	00 00 00 
  800863:	8b 00                	mov    (%rax),%eax
  800865:	83 f8 01             	cmp    $0x1,%eax
  800868:	7e 22                	jle    80088c <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  80086a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086e:	48 89 c6             	mov    %rax,%rsi
  800871:	48 bf 69 67 80 00 00 	movabs $0x806769,%rdi
  800878:	00 00 00 
  80087b:	b8 00 00 00 00       	mov    $0x0,%eax
  800880:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800887:	00 00 00 
  80088a:	ff d2                	callq  *%rdx

	*p1 = 0;
  80088c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800890:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800897:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  8008a2:	eb 0c                	jmp    8008b0 <_gettoken+0xa8>
		*s++ = 0;
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	c6 00 00             	movb   $0x0,(%rax)
  8008ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b4:	0f b6 00             	movzbl (%rax),%eax
  8008b7:	0f be c0             	movsbl %al,%eax
  8008ba:	89 c6                	mov    %eax,%esi
  8008bc:	48 bf 77 67 80 00 00 	movabs $0x806777,%rdi
  8008c3:	00 00 00 
  8008c6:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  8008cd:	00 00 00 
  8008d0:	ff d0                	callq  *%rax
  8008d2:	48 85 c0             	test   %rax,%rax
  8008d5:	75 cd                	jne    8008a4 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	0f b6 00             	movzbl (%rax),%eax
  8008de:	84 c0                	test   %al,%al
  8008e0:	75 36                	jne    800918 <_gettoken+0x110>
		if (debug > 1)
  8008e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8008e9:	00 00 00 
  8008ec:	8b 00                	mov    (%rax),%eax
  8008ee:	83 f8 01             	cmp    $0x1,%eax
  8008f1:	7e 1b                	jle    80090e <_gettoken+0x106>
			cprintf("EOL\n");
  8008f3:	48 bf 7c 67 80 00 00 	movabs $0x80677c,%rdi
  8008fa:	00 00 00 
  8008fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800902:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800909:	00 00 00 
  80090c:	ff d2                	callq  *%rdx
		return 0;
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
  800913:	e9 3f 01 00 00       	jmpq   800a57 <_gettoken+0x24f>
	}
	if (strchr(SYMBOLS, *s)) {
  800918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091c:	0f b6 00             	movzbl (%rax),%eax
  80091f:	0f be c0             	movsbl %al,%eax
  800922:	89 c6                	mov    %eax,%esi
  800924:	48 bf 81 67 80 00 00 	movabs $0x806781,%rdi
  80092b:	00 00 00 
  80092e:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  800935:	00 00 00 
  800938:	ff d0                	callq  *%rax
  80093a:	48 85 c0             	test   %rax,%rax
  80093d:	74 68                	je     8009a7 <_gettoken+0x19f>
		t = *s;
  80093f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800943:	0f b6 00             	movzbl (%rax),%eax
  800946:	0f be c0             	movsbl %al,%eax
  800949:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800954:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095b:	c6 00 00             	movb   $0x0,(%rax)
  80095e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		*p2 = s;
  800963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800967:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096b:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  80096e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800975:	00 00 00 
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	83 f8 01             	cmp    $0x1,%eax
  80097d:	7e 20                	jle    80099f <_gettoken+0x197>
			cprintf("TOK %c\n", t);
  80097f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800982:	89 c6                	mov    %eax,%esi
  800984:	48 bf 89 67 80 00 00 	movabs $0x806789,%rdi
  80098b:	00 00 00 
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
  800993:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  80099a:	00 00 00 
  80099d:	ff d2                	callq  *%rdx
		return t;
  80099f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a2:	e9 b0 00 00 00       	jmpq   800a57 <_gettoken+0x24f>
	}
	*p1 = s;
  8009a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009af:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b2:	eb 05                	jmp    8009b9 <_gettoken+0x1b1>
		s++;
  8009b4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	0f b6 00             	movzbl (%rax),%eax
  8009c0:	84 c0                	test   %al,%al
  8009c2:	74 27                	je     8009eb <_gettoken+0x1e3>
  8009c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c8:	0f b6 00             	movzbl (%rax),%eax
  8009cb:	0f be c0             	movsbl %al,%eax
  8009ce:	89 c6                	mov    %eax,%esi
  8009d0:	48 bf 91 67 80 00 00 	movabs $0x806791,%rdi
  8009d7:	00 00 00 
  8009da:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  8009e1:	00 00 00 
  8009e4:	ff d0                	callq  *%rax
  8009e6:	48 85 c0             	test   %rax,%rax
  8009e9:	74 c9                	je     8009b4 <_gettoken+0x1ac>
		s++;
	*p2 = s;
  8009eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f3:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8009fd:	00 00 00 
  800a00:	8b 00                	mov    (%rax),%eax
  800a02:	83 f8 01             	cmp    $0x1,%eax
  800a05:	7e 4b                	jle    800a52 <_gettoken+0x24a>
		t = **p2;
  800a07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0b:	48 8b 00             	mov    (%rax),%rax
  800a0e:	0f b6 00             	movzbl (%rax),%eax
  800a11:	0f be c0             	movsbl %al,%eax
  800a14:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1b:	48 8b 00             	mov    (%rax),%rax
  800a1e:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a25:	48 8b 00             	mov    (%rax),%rax
  800a28:	48 89 c6             	mov    %rax,%rsi
  800a2b:	48 bf 9d 67 80 00 00 	movabs $0x80679d,%rdi
  800a32:	00 00 00 
  800a35:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3a:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800a41:	00 00 00 
  800a44:	ff d2                	callq  *%rdx
		**p2 = t;
  800a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4a:	48 8b 00             	mov    (%rax),%rax
  800a4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a50:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a52:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a57:	c9                   	leaveq 
  800a58:	c3                   	retq   

0000000000800a59 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a59:	55                   	push   %rbp
  800a5a:	48 89 e5             	mov    %rsp,%rbp
  800a5d:	48 83 ec 10          	sub    $0x10,%rsp
  800a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a69:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a6e:	74 3a                	je     800aaa <gettoken+0x51>
		nc = _gettoken(s, &np1, &np2);
  800a70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a74:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800a7b:	00 00 00 
  800a7e:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800a85:	00 00 00 
  800a88:	48 89 c7             	mov    %rax,%rdi
  800a8b:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800a92:	00 00 00 
  800a95:	ff d0                	callq  *%rax
  800a97:	48 ba 18 a0 80 00 00 	movabs $0x80a018,%rdx
  800a9e:	00 00 00 
  800aa1:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	eb 74                	jmp    800b1e <gettoken+0xc5>
	}
	c = nc;
  800aaa:	48 b8 18 a0 80 00 00 	movabs $0x80a018,%rax
  800ab1:	00 00 00 
  800ab4:	8b 10                	mov    (%rax),%edx
  800ab6:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800abd:	00 00 00 
  800ac0:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac2:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  800ac9:	00 00 00 
  800acc:	48 8b 10             	mov    (%rax),%rdx
  800acf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad3:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad6:	48 b8 10 a0 80 00 00 	movabs $0x80a010,%rax
  800add:	00 00 00 
  800ae0:	48 8b 00             	mov    (%rax),%rax
  800ae3:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800aea:	00 00 00 
  800aed:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800af4:	00 00 00 
  800af7:	48 89 c7             	mov    %rax,%rdi
  800afa:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800b01:	00 00 00 
  800b04:	ff d0                	callq  *%rax
  800b06:	48 ba 18 a0 80 00 00 	movabs $0x80a018,%rdx
  800b0d:	00 00 00 
  800b10:	89 02                	mov    %eax,(%rdx)
	return c;
  800b12:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800b19:	00 00 00 
  800b1c:	8b 00                	mov    (%rax),%eax
}
  800b1e:	c9                   	leaveq 
  800b1f:	c3                   	retq   

0000000000800b20 <usage>:


void
usage(void)
{
  800b20:	55                   	push   %rbp
  800b21:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b24:	48 bf a8 67 80 00 00 	movabs $0x8067a8,%rdi
  800b2b:	00 00 00 
  800b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b33:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800b3a:	00 00 00 
  800b3d:	ff d2                	callq  *%rdx
	exit();
  800b3f:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  800b46:	00 00 00 
  800b49:	ff d0                	callq  *%rax
}
  800b4b:	5d                   	pop    %rbp
  800b4c:	c3                   	retq   

0000000000800b4d <umain>:

void
umain(int argc, char **argv)
{
  800b4d:	55                   	push   %rbp
  800b4e:	48 89 e5             	mov    %rsp,%rbp
  800b51:	48 83 ec 50          	sub    $0x50,%rsp
  800b55:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b58:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  800b5c:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b63:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b6a:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b6e:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b72:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b76:	48 89 ce             	mov    %rcx,%rsi
  800b79:	48 89 c7             	mov    %rax,%rdi
  800b7c:	48 b8 a8 34 80 00 00 	movabs $0x8034a8,%rax
  800b83:	00 00 00 
  800b86:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b88:	eb 4d                	jmp    800bd7 <umain+0x8a>
		switch (r) {
  800b8a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800b8d:	83 f8 69             	cmp    $0x69,%eax
  800b90:	74 27                	je     800bb9 <umain+0x6c>
  800b92:	83 f8 78             	cmp    $0x78,%eax
  800b95:	74 2b                	je     800bc2 <umain+0x75>
  800b97:	83 f8 64             	cmp    $0x64,%eax
  800b9a:	75 2f                	jne    800bcb <umain+0x7e>
		case 'd':
			debug++;
  800b9c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800ba3:	00 00 00 
  800ba6:	8b 00                	mov    (%rax),%eax
  800ba8:	8d 50 01             	lea    0x1(%rax),%edx
  800bab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800bb2:	00 00 00 
  800bb5:	89 10                	mov    %edx,(%rax)
			break;
  800bb7:	eb 1e                	jmp    800bd7 <umain+0x8a>
		case 'i':
			interactive = 1;
  800bb9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bc0:	eb 15                	jmp    800bd7 <umain+0x8a>
		case 'x':
			echocmds = 1;
  800bc2:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bc9:	eb 0c                	jmp    800bd7 <umain+0x8a>
		default:
			usage();
  800bcb:	48 b8 20 0b 80 00 00 	movabs $0x800b20,%rax
  800bd2:	00 00 00 
  800bd5:	ff d0                	callq  *%rax
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bd7:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bdb:	48 89 c7             	mov    %rax,%rdi
  800bde:	48 b8 0c 35 80 00 00 	movabs $0x80350c,%rax
  800be5:	00 00 00 
  800be8:	ff d0                	callq  *%rax
  800bea:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800bed:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800bf1:	79 97                	jns    800b8a <umain+0x3d>
			break;
		default:
			usage();
		}

	if (argc > 2)
  800bf3:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800bf6:	83 f8 02             	cmp    $0x2,%eax
  800bf9:	7e 0c                	jle    800c07 <umain+0xba>
		usage();
  800bfb:	48 b8 20 0b 80 00 00 	movabs $0x800b20,%rax
  800c02:	00 00 00 
  800c05:	ff d0                	callq  *%rax
	if (argc == 2) {
  800c07:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800c0a:	83 f8 02             	cmp    $0x2,%eax
  800c0d:	0f 85 b3 00 00 00    	jne    800cc6 <umain+0x179>
		close(0);
  800c13:	bf 00 00 00 00       	mov    $0x0,%edi
  800c18:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  800c1f:	00 00 00 
  800c22:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800c24:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c28:	48 83 c0 08          	add    $0x8,%rax
  800c2c:	48 8b 00             	mov    (%rax),%rax
  800c2f:	be 00 00 00 00       	mov    $0x0,%esi
  800c34:	48 89 c7             	mov    %rax,%rdi
  800c37:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  800c3e:	00 00 00 
  800c41:	ff d0                	callq  *%rax
  800c43:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c4a:	79 3f                	jns    800c8b <umain+0x13e>
			panic("open %s: %e", argv[1], r);
  800c4c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c50:	48 83 c0 08          	add    $0x8,%rax
  800c54:	48 8b 00             	mov    (%rax),%rax
  800c57:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800c5a:	41 89 d0             	mov    %edx,%r8d
  800c5d:	48 89 c1             	mov    %rax,%rcx
  800c60:	48 ba c9 67 80 00 00 	movabs $0x8067c9,%rdx
  800c67:	00 00 00 
  800c6a:	be 2b 01 00 00       	mov    $0x12b,%esi
  800c6f:	48 bf d7 66 80 00 00 	movabs $0x8066d7,%rdi
  800c76:	00 00 00 
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	49 b9 14 12 80 00 00 	movabs $0x801214,%r9
  800c85:	00 00 00 
  800c88:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c8f:	74 35                	je     800cc6 <umain+0x179>
  800c91:	48 b9 d5 67 80 00 00 	movabs $0x8067d5,%rcx
  800c98:	00 00 00 
  800c9b:	48 ba dc 67 80 00 00 	movabs $0x8067dc,%rdx
  800ca2:	00 00 00 
  800ca5:	be 2c 01 00 00       	mov    $0x12c,%esi
  800caa:	48 bf d7 66 80 00 00 	movabs $0x8066d7,%rdi
  800cb1:	00 00 00 
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb9:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  800cc0:	00 00 00 
  800cc3:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800cc6:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800cca:	75 14                	jne    800ce0 <umain+0x193>
		interactive = iscons(0);
  800ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd1:	48 b8 0c 0f 80 00 00 	movabs $0x800f0c,%rax
  800cd8:	00 00 00 
  800cdb:	ff d0                	callq  *%rax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800ce0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce4:	74 0c                	je     800cf2 <umain+0x1a5>
  800ce6:	48 b8 f1 67 80 00 00 	movabs $0x8067f1,%rax
  800ced:	00 00 00 
  800cf0:	eb 05                	jmp    800cf7 <umain+0x1aa>
  800cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf7:	48 89 c7             	mov    %rax,%rdi
  800cfa:	48 b8 a0 1f 80 00 00 	movabs $0x801fa0,%rax
  800d01:	00 00 00 
  800d04:	ff d0                	callq  *%rax
  800d06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		if (buf == NULL) {
  800d0a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800d0f:	75 37                	jne    800d48 <umain+0x1fb>
			if (debug)
  800d11:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800d18:	00 00 00 
  800d1b:	8b 00                	mov    (%rax),%eax
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	74 1b                	je     800d3c <umain+0x1ef>
				cprintf("EXITING\n");
  800d21:	48 bf f4 67 80 00 00 	movabs $0x8067f4,%rdi
  800d28:	00 00 00 
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d30:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800d37:	00 00 00 
  800d3a:	ff d2                	callq  *%rdx
			exit();	// end of file
  800d3c:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  800d43:	00 00 00 
  800d46:	ff d0                	callq  *%rax
		}
		if (debug)
  800d48:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800d4f:	00 00 00 
  800d52:	8b 00                	mov    (%rax),%eax
  800d54:	85 c0                	test   %eax,%eax
  800d56:	74 22                	je     800d7a <umain+0x22d>
			cprintf("LINE: %s\n", buf);
  800d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5c:	48 89 c6             	mov    %rax,%rsi
  800d5f:	48 bf fd 67 80 00 00 	movabs $0x8067fd,%rdi
  800d66:	00 00 00 
  800d69:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6e:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800d75:	00 00 00 
  800d78:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7e:	0f b6 00             	movzbl (%rax),%eax
  800d81:	3c 23                	cmp    $0x23,%al
  800d83:	0f 84 08 01 00 00    	je     800e91 <umain+0x344>
			continue;
		if (echocmds)
  800d89:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d8d:	74 22                	je     800db1 <umain+0x264>
			printf("# %s\n", buf);
  800d8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d93:	48 89 c6             	mov    %rax,%rsi
  800d96:	48 bf 07 68 80 00 00 	movabs $0x806807,%rdi
  800d9d:	00 00 00 
  800da0:	b8 00 00 00 00       	mov    $0x0,%eax
  800da5:	48 ba e0 46 80 00 00 	movabs $0x8046e0,%rdx
  800dac:	00 00 00 
  800daf:	ff d2                	callq  *%rdx
		if (debug)
  800db1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800db8:	00 00 00 
  800dbb:	8b 00                	mov    (%rax),%eax
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	74 1b                	je     800ddc <umain+0x28f>
			cprintf("BEFORE FORK\n");
  800dc1:	48 bf 0d 68 80 00 00 	movabs $0x80680d,%rdi
  800dc8:	00 00 00 
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd0:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800dd7:	00 00 00 
  800dda:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800ddc:	48 b8 7b 31 80 00 00 	movabs $0x80317b,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	callq  *%rax
  800de8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800def:	79 30                	jns    800e21 <umain+0x2d4>
			panic("fork: %e", r);
  800df1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800df4:	89 c1                	mov    %eax,%ecx
  800df6:	48 ba b2 66 80 00 00 	movabs $0x8066b2,%rdx
  800dfd:	00 00 00 
  800e00:	be 43 01 00 00       	mov    $0x143,%esi
  800e05:	48 bf d7 66 80 00 00 	movabs $0x8066d7,%rdi
  800e0c:	00 00 00 
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e14:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  800e1b:	00 00 00 
  800e1e:	41 ff d0             	callq  *%r8
		if (debug)
  800e21:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800e28:	00 00 00 
  800e2b:	8b 00                	mov    (%rax),%eax
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	74 20                	je     800e51 <umain+0x304>
			cprintf("FORK: %d\n", r);
  800e31:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e34:	89 c6                	mov    %eax,%esi
  800e36:	48 bf 1a 68 80 00 00 	movabs $0x80681a,%rdi
  800e3d:	00 00 00 
  800e40:	b8 00 00 00 00       	mov    $0x0,%eax
  800e45:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  800e4c:	00 00 00 
  800e4f:	ff d2                	callq  *%rdx
		if (r == 0) {
  800e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e55:	75 24                	jne    800e7b <umain+0x32e>
			runcmd(buf);
  800e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5b:	48 89 c7             	mov    %rax,%rdi
  800e5e:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800e65:	00 00 00 
  800e68:	ff d0                	callq  *%rax
			exit();
  800e6a:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  800e71:	00 00 00 
  800e74:	ff d0                	callq  *%rax
		} else
			wait(r);
	}
  800e76:	e9 65 fe ff ff       	jmpq   800ce0 <umain+0x193>
			cprintf("FORK: %d\n", r);
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800e7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e7e:	89 c7                	mov    %eax,%edi
  800e80:	48 b8 78 61 80 00 00 	movabs $0x806178,%rax
  800e87:	00 00 00 
  800e8a:	ff d0                	callq  *%rax
	}
  800e8c:	e9 4f fe ff ff       	jmpq   800ce0 <umain+0x193>
			exit();	// end of file
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
		if (buf[0] == '#')
			continue;
  800e91:	90                   	nop
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
	}
  800e92:	e9 49 fe ff ff       	jmpq   800ce0 <umain+0x193>
	...

0000000000800e98 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800e98:	55                   	push   %rbp
  800e99:	48 89 e5             	mov    %rsp,%rbp
  800e9c:	48 83 ec 20          	sub    $0x20,%rsp
  800ea0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ea3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ea6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ea9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800ead:	be 01 00 00 00       	mov    $0x1,%esi
  800eb2:	48 89 c7             	mov    %rax,%rdi
  800eb5:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  800ebc:	00 00 00 
  800ebf:	ff d0                	callq  *%rax
}
  800ec1:	c9                   	leaveq 
  800ec2:	c3                   	retq   

0000000000800ec3 <getchar>:

int
getchar(void)
{
  800ec3:	55                   	push   %rbp
  800ec4:	48 89 e5             	mov    %rsp,%rbp
  800ec7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ecb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800ecf:	ba 01 00 00 00       	mov    $0x1,%edx
  800ed4:	48 89 c6             	mov    %rax,%rsi
  800ed7:	bf 00 00 00 00       	mov    $0x0,%edi
  800edc:	48 b8 a0 3c 80 00 00 	movabs $0x803ca0,%rax
  800ee3:	00 00 00 
  800ee6:	ff d0                	callq  *%rax
  800ee8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800eeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eef:	79 05                	jns    800ef6 <getchar+0x33>
		return r;
  800ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ef4:	eb 14                	jmp    800f0a <getchar+0x47>
	if (r < 1)
  800ef6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800efa:	7f 07                	jg     800f03 <getchar+0x40>
		return -E_EOF;
  800efc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800f01:	eb 07                	jmp    800f0a <getchar+0x47>
	return c;
  800f03:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800f07:	0f b6 c0             	movzbl %al,%eax
}
  800f0a:	c9                   	leaveq 
  800f0b:	c3                   	retq   

0000000000800f0c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f0c:	55                   	push   %rbp
  800f0d:	48 89 e5             	mov    %rsp,%rbp
  800f10:	48 83 ec 20          	sub    $0x20,%rsp
  800f14:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f17:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f1e:	48 89 d6             	mov    %rdx,%rsi
  800f21:	89 c7                	mov    %eax,%edi
  800f23:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  800f2a:	00 00 00 
  800f2d:	ff d0                	callq  *%rax
  800f2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f36:	79 05                	jns    800f3d <iscons+0x31>
		return r;
  800f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f3b:	eb 1a                	jmp    800f57 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800f3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f41:	8b 10                	mov    (%rax),%edx
  800f43:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800f4a:	00 00 00 
  800f4d:	8b 00                	mov    (%rax),%eax
  800f4f:	39 c2                	cmp    %eax,%edx
  800f51:	0f 94 c0             	sete   %al
  800f54:	0f b6 c0             	movzbl %al,%eax
}
  800f57:	c9                   	leaveq 
  800f58:	c3                   	retq   

0000000000800f59 <opencons>:

int
opencons(void)
{
  800f59:	55                   	push   %rbp
  800f5a:	48 89 e5             	mov    %rsp,%rbp
  800f5d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f61:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f65:	48 89 c7             	mov    %rax,%rdi
  800f68:	48 b8 d6 37 80 00 00 	movabs $0x8037d6,%rax
  800f6f:	00 00 00 
  800f72:	ff d0                	callq  *%rax
  800f74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f7b:	79 05                	jns    800f82 <opencons+0x29>
		return r;
  800f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f80:	eb 5b                	jmp    800fdd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f86:	ba 07 04 00 00       	mov    $0x407,%edx
  800f8b:	48 89 c6             	mov    %rax,%rsi
  800f8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800f93:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  800f9a:	00 00 00 
  800f9d:	ff d0                	callq  *%rax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa6:	79 05                	jns    800fad <opencons+0x54>
		return r;
  800fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fab:	eb 30                	jmp    800fdd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb1:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  800fb8:	00 00 00 
  800fbb:	8b 12                	mov    (%rdx),%edx
  800fbd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800fca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fce:	48 89 c7             	mov    %rax,%rdi
  800fd1:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  800fd8:	00 00 00 
  800fdb:	ff d0                	callq  *%rax
}
  800fdd:	c9                   	leaveq 
  800fde:	c3                   	retq   

0000000000800fdf <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800fdf:	55                   	push   %rbp
  800fe0:	48 89 e5             	mov    %rsp,%rbp
  800fe3:	48 83 ec 30          	sub    $0x30,%rsp
  800fe7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800feb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800ff3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ff8:	75 13                	jne    80100d <devcons_read+0x2e>
		return 0;
  800ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  800fff:	eb 49                	jmp    80104a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801001:	48 b8 66 2a 80 00 00 	movabs $0x802a66,%rax
  801008:	00 00 00 
  80100b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80100d:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  801014:	00 00 00 
  801017:	ff d0                	callq  *%rax
  801019:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80101c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801020:	74 df                	je     801001 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  801022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801026:	79 05                	jns    80102d <devcons_read+0x4e>
		return c;
  801028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80102b:	eb 1d                	jmp    80104a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80102d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801031:	75 07                	jne    80103a <devcons_read+0x5b>
		return 0;
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
  801038:	eb 10                	jmp    80104a <devcons_read+0x6b>
	*(char*)vbuf = c;
  80103a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80103d:	89 c2                	mov    %eax,%edx
  80103f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801043:	88 10                	mov    %dl,(%rax)
	return 1;
  801045:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801057:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80105e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801065:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801073:	eb 77                	jmp    8010ec <devcons_write+0xa0>
		m = n - tot;
  801075:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801081:	89 d1                	mov    %edx,%ecx
  801083:	29 c1                	sub    %eax,%ecx
  801085:	89 c8                	mov    %ecx,%eax
  801087:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80108a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80108d:	83 f8 7f             	cmp    $0x7f,%eax
  801090:	76 07                	jbe    801099 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  801092:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801099:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80109c:	48 63 d0             	movslq %eax,%rdx
  80109f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a2:	48 98                	cltq   
  8010a4:	48 89 c1             	mov    %rax,%rcx
  8010a7:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8010ae:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010b5:	48 89 ce             	mov    %rcx,%rsi
  8010b8:	48 89 c7             	mov    %rax,%rdi
  8010bb:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  8010c2:	00 00 00 
  8010c5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8010c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010ca:	48 63 d0             	movslq %eax,%rdx
  8010cd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010d4:	48 89 d6             	mov    %rdx,%rsi
  8010d7:	48 89 c7             	mov    %rax,%rdi
  8010da:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  8010e1:	00 00 00 
  8010e4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8010e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010e9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8010ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ef:	48 98                	cltq   
  8010f1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8010f8:	0f 82 77 ff ff ff    	jb     801075 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8010fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 08          	sub    $0x8,%rsp
  80110b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80110f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801114:	c9                   	leaveq 
  801115:	c3                   	retq   

0000000000801116 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801116:	55                   	push   %rbp
  801117:	48 89 e5             	mov    %rsp,%rbp
  80111a:	48 83 ec 10          	sub    $0x10,%rsp
  80111e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801122:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80112a:	48 be 29 68 80 00 00 	movabs $0x806829,%rsi
  801131:	00 00 00 
  801134:	48 89 c7             	mov    %rax,%rdi
  801137:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  80113e:	00 00 00 
  801141:	ff d0                	callq  *%rax
	return 0;
  801143:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801148:	c9                   	leaveq 
  801149:	c3                   	retq   
	...

000000000080114c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80114c:	55                   	push   %rbp
  80114d:	48 89 e5             	mov    %rsp,%rbp
  801150:	48 83 ec 10          	sub    $0x10,%rsp
  801154:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801157:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80115b:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  801162:	00 00 00 
  801165:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80116c:	48 b8 28 2a 80 00 00 	movabs $0x802a28,%rax
  801173:	00 00 00 
  801176:	ff d0                	callq  *%rax
  801178:	48 98                	cltq   
  80117a:	48 89 c2             	mov    %rax,%rdx
  80117d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  801183:	48 89 d0             	mov    %rdx,%rax
  801186:	48 c1 e0 03          	shl    $0x3,%rax
  80118a:	48 01 d0             	add    %rdx,%rax
  80118d:	48 c1 e0 05          	shl    $0x5,%rax
  801191:	48 89 c2             	mov    %rax,%rdx
  801194:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80119b:	00 00 00 
  80119e:	48 01 c2             	add    %rax,%rdx
  8011a1:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  8011a8:	00 00 00 
  8011ab:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011b2:	7e 14                	jle    8011c8 <libmain+0x7c>
		binaryname = argv[0];
  8011b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b8:	48 8b 10             	mov    (%rax),%rdx
  8011bb:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8011c2:	00 00 00 
  8011c5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8011c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011cf:	48 89 d6             	mov    %rdx,%rsi
  8011d2:	89 c7                	mov    %eax,%edi
  8011d4:	48 b8 4d 0b 80 00 00 	movabs $0x800b4d,%rax
  8011db:	00 00 00 
  8011de:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8011e0:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  8011e7:	00 00 00 
  8011ea:	ff d0                	callq  *%rax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   
	...

00000000008011f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8011f0:	55                   	push   %rbp
  8011f1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8011f4:	48 b8 c9 3a 80 00 00 	movabs $0x803ac9,%rax
  8011fb:	00 00 00 
  8011fe:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  801200:	bf 00 00 00 00       	mov    $0x0,%edi
  801205:	48 b8 e4 29 80 00 00 	movabs $0x8029e4,%rax
  80120c:	00 00 00 
  80120f:	ff d0                	callq  *%rax
}
  801211:	5d                   	pop    %rbp
  801212:	c3                   	retq   
	...

0000000000801214 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801214:	55                   	push   %rbp
  801215:	48 89 e5             	mov    %rsp,%rbp
  801218:	53                   	push   %rbx
  801219:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801220:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801227:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80122d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801234:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80123b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801242:	84 c0                	test   %al,%al
  801244:	74 23                	je     801269 <_panic+0x55>
  801246:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80124d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801251:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801255:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801259:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80125d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801261:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801265:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801269:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801270:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801277:	00 00 00 
  80127a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801281:	00 00 00 
  801284:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801288:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80128f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801296:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80129d:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8012a4:	00 00 00 
  8012a7:	48 8b 18             	mov    (%rax),%rbx
  8012aa:	48 b8 28 2a 80 00 00 	movabs $0x802a28,%rax
  8012b1:	00 00 00 
  8012b4:	ff d0                	callq  *%rax
  8012b6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8012bc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012c3:	41 89 c8             	mov    %ecx,%r8d
  8012c6:	48 89 d1             	mov    %rdx,%rcx
  8012c9:	48 89 da             	mov    %rbx,%rdx
  8012cc:	89 c6                	mov    %eax,%esi
  8012ce:	48 bf 40 68 80 00 00 	movabs $0x806840,%rdi
  8012d5:	00 00 00 
  8012d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dd:	49 b9 4f 14 80 00 00 	movabs $0x80144f,%r9
  8012e4:	00 00 00 
  8012e7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012ea:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8012f1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012f8:	48 89 d6             	mov    %rdx,%rsi
  8012fb:	48 89 c7             	mov    %rax,%rdi
  8012fe:	48 b8 a3 13 80 00 00 	movabs $0x8013a3,%rax
  801305:	00 00 00 
  801308:	ff d0                	callq  *%rax
	cprintf("\n");
  80130a:	48 bf 63 68 80 00 00 	movabs $0x806863,%rdi
  801311:	00 00 00 
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
  801319:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  801320:	00 00 00 
  801323:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801325:	cc                   	int3   
  801326:	eb fd                	jmp    801325 <_panic+0x111>

0000000000801328 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801328:	55                   	push   %rbp
  801329:	48 89 e5             	mov    %rsp,%rbp
  80132c:	48 83 ec 10          	sub    $0x10,%rsp
  801330:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801333:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  801337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133b:	8b 00                	mov    (%rax),%eax
  80133d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801340:	89 d6                	mov    %edx,%esi
  801342:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801346:	48 63 d0             	movslq %eax,%rdx
  801349:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80134e:	8d 50 01             	lea    0x1(%rax),%edx
  801351:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801355:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135b:	8b 00                	mov    (%rax),%eax
  80135d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801362:	75 2c                	jne    801390 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  801364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801368:	8b 00                	mov    (%rax),%eax
  80136a:	48 98                	cltq   
  80136c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801370:	48 83 c2 08          	add    $0x8,%rdx
  801374:	48 89 c6             	mov    %rax,%rsi
  801377:	48 89 d7             	mov    %rdx,%rdi
  80137a:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  801381:	00 00 00 
  801384:	ff d0                	callq  *%rax
		b->idx = 0;
  801386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801394:	8b 40 04             	mov    0x4(%rax),%eax
  801397:	8d 50 01             	lea    0x1(%rax),%edx
  80139a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139e:	89 50 04             	mov    %edx,0x4(%rax)
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8013ae:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8013b5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8013bc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8013c3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8013ca:	48 8b 0a             	mov    (%rdx),%rcx
  8013cd:	48 89 08             	mov    %rcx,(%rax)
  8013d0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013d4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013d8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013dc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8013e0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8013e7:	00 00 00 
	b.cnt = 0;
  8013ea:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8013f1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8013f4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8013fb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801402:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801409:	48 89 c6             	mov    %rax,%rsi
  80140c:	48 bf 28 13 80 00 00 	movabs $0x801328,%rdi
  801413:	00 00 00 
  801416:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  80141d:	00 00 00 
  801420:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801422:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801428:	48 98                	cltq   
  80142a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801431:	48 83 c2 08          	add    $0x8,%rdx
  801435:	48 89 c6             	mov    %rax,%rsi
  801438:	48 89 d7             	mov    %rdx,%rdi
  80143b:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  801442:	00 00 00 
  801445:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  801447:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80144d:	c9                   	leaveq 
  80144e:	c3                   	retq   

000000000080144f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80144f:	55                   	push   %rbp
  801450:	48 89 e5             	mov    %rsp,%rbp
  801453:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80145a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801461:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801468:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80146f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801476:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80147d:	84 c0                	test   %al,%al
  80147f:	74 20                	je     8014a1 <cprintf+0x52>
  801481:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801485:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801489:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80148d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801491:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801495:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801499:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80149d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014a1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8014a8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8014af:	00 00 00 
  8014b2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8014b9:	00 00 00 
  8014bc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014c0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014c7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014ce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8014d5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014dc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014e3:	48 8b 0a             	mov    (%rdx),%rcx
  8014e6:	48 89 08             	mov    %rcx,(%rax)
  8014e9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014ed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014f5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8014f9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801500:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801507:	48 89 d6             	mov    %rdx,%rsi
  80150a:	48 89 c7             	mov    %rax,%rdi
  80150d:	48 b8 a3 13 80 00 00 	movabs $0x8013a3,%rax
  801514:	00 00 00 
  801517:	ff d0                	callq  *%rax
  801519:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80151f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801525:	c9                   	leaveq 
  801526:	c3                   	retq   
	...

0000000000801528 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801528:	55                   	push   %rbp
  801529:	48 89 e5             	mov    %rsp,%rbp
  80152c:	48 83 ec 30          	sub    $0x30,%rsp
  801530:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801534:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801538:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80153c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80153f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  801543:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801547:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80154a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80154e:	77 52                	ja     8015a2 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801550:	8b 45 e0             	mov    -0x20(%rbp),%eax
  801553:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801557:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80155a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80155e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801562:	ba 00 00 00 00       	mov    $0x0,%edx
  801567:	48 f7 75 d0          	divq   -0x30(%rbp)
  80156b:	48 89 c2             	mov    %rax,%rdx
  80156e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801571:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801574:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157c:	41 89 f9             	mov    %edi,%r9d
  80157f:	48 89 c7             	mov    %rax,%rdi
  801582:	48 b8 28 15 80 00 00 	movabs $0x801528,%rax
  801589:	00 00 00 
  80158c:	ff d0                	callq  *%rax
  80158e:	eb 1c                	jmp    8015ac <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801590:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801594:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801597:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80159b:	48 89 d6             	mov    %rdx,%rsi
  80159e:	89 c7                	mov    %eax,%edi
  8015a0:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015a2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8015a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8015aa:	7f e4                	jg     801590 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015ac:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8015af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b8:	48 f7 f1             	div    %rcx
  8015bb:	48 89 d0             	mov    %rdx,%rax
  8015be:	48 ba 48 6a 80 00 00 	movabs $0x806a48,%rdx
  8015c5:	00 00 00 
  8015c8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8015cc:	0f be c0             	movsbl %al,%eax
  8015cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015d3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8015d7:	48 89 d6             	mov    %rdx,%rsi
  8015da:	89 c7                	mov    %eax,%edi
  8015dc:	ff d1                	callq  *%rcx
}
  8015de:	c9                   	leaveq 
  8015df:	c3                   	retq   

00000000008015e0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015e0:	55                   	push   %rbp
  8015e1:	48 89 e5             	mov    %rsp,%rbp
  8015e4:	48 83 ec 20          	sub    $0x20,%rsp
  8015e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8015ef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8015f3:	7e 52                	jle    801647 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8015f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f9:	8b 00                	mov    (%rax),%eax
  8015fb:	83 f8 30             	cmp    $0x30,%eax
  8015fe:	73 24                	jae    801624 <getuint+0x44>
  801600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801604:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160c:	8b 00                	mov    (%rax),%eax
  80160e:	89 c0                	mov    %eax,%eax
  801610:	48 01 d0             	add    %rdx,%rax
  801613:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801617:	8b 12                	mov    (%rdx),%edx
  801619:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80161c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801620:	89 0a                	mov    %ecx,(%rdx)
  801622:	eb 17                	jmp    80163b <getuint+0x5b>
  801624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801628:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80162c:	48 89 d0             	mov    %rdx,%rax
  80162f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801637:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80163b:	48 8b 00             	mov    (%rax),%rax
  80163e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801642:	e9 a3 00 00 00       	jmpq   8016ea <getuint+0x10a>
	else if (lflag)
  801647:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80164b:	74 4f                	je     80169c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80164d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801651:	8b 00                	mov    (%rax),%eax
  801653:	83 f8 30             	cmp    $0x30,%eax
  801656:	73 24                	jae    80167c <getuint+0x9c>
  801658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801664:	8b 00                	mov    (%rax),%eax
  801666:	89 c0                	mov    %eax,%eax
  801668:	48 01 d0             	add    %rdx,%rax
  80166b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80166f:	8b 12                	mov    (%rdx),%edx
  801671:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801674:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801678:	89 0a                	mov    %ecx,(%rdx)
  80167a:	eb 17                	jmp    801693 <getuint+0xb3>
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801684:	48 89 d0             	mov    %rdx,%rax
  801687:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80168b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80168f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801693:	48 8b 00             	mov    (%rax),%rax
  801696:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80169a:	eb 4e                	jmp    8016ea <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80169c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a0:	8b 00                	mov    (%rax),%eax
  8016a2:	83 f8 30             	cmp    $0x30,%eax
  8016a5:	73 24                	jae    8016cb <getuint+0xeb>
  8016a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8016af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b3:	8b 00                	mov    (%rax),%eax
  8016b5:	89 c0                	mov    %eax,%eax
  8016b7:	48 01 d0             	add    %rdx,%rax
  8016ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016be:	8b 12                	mov    (%rdx),%edx
  8016c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c7:	89 0a                	mov    %ecx,(%rdx)
  8016c9:	eb 17                	jmp    8016e2 <getuint+0x102>
  8016cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8016d3:	48 89 d0             	mov    %rdx,%rax
  8016d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016e2:	8b 00                	mov    (%rax),%eax
  8016e4:	89 c0                	mov    %eax,%eax
  8016e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8016ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016ee:	c9                   	leaveq 
  8016ef:	c3                   	retq   

00000000008016f0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016f0:	55                   	push   %rbp
  8016f1:	48 89 e5             	mov    %rsp,%rbp
  8016f4:	48 83 ec 20          	sub    $0x20,%rsp
  8016f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8016ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801703:	7e 52                	jle    801757 <getint+0x67>
		x=va_arg(*ap, long long);
  801705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801709:	8b 00                	mov    (%rax),%eax
  80170b:	83 f8 30             	cmp    $0x30,%eax
  80170e:	73 24                	jae    801734 <getint+0x44>
  801710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801714:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171c:	8b 00                	mov    (%rax),%eax
  80171e:	89 c0                	mov    %eax,%eax
  801720:	48 01 d0             	add    %rdx,%rax
  801723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801727:	8b 12                	mov    (%rdx),%edx
  801729:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80172c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801730:	89 0a                	mov    %ecx,(%rdx)
  801732:	eb 17                	jmp    80174b <getint+0x5b>
  801734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801738:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80173c:	48 89 d0             	mov    %rdx,%rax
  80173f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801743:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801747:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80174b:	48 8b 00             	mov    (%rax),%rax
  80174e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801752:	e9 a3 00 00 00       	jmpq   8017fa <getint+0x10a>
	else if (lflag)
  801757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80175b:	74 4f                	je     8017ac <getint+0xbc>
		x=va_arg(*ap, long);
  80175d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801761:	8b 00                	mov    (%rax),%eax
  801763:	83 f8 30             	cmp    $0x30,%eax
  801766:	73 24                	jae    80178c <getint+0x9c>
  801768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801774:	8b 00                	mov    (%rax),%eax
  801776:	89 c0                	mov    %eax,%eax
  801778:	48 01 d0             	add    %rdx,%rax
  80177b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80177f:	8b 12                	mov    (%rdx),%edx
  801781:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801784:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801788:	89 0a                	mov    %ecx,(%rdx)
  80178a:	eb 17                	jmp    8017a3 <getint+0xb3>
  80178c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801790:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801794:	48 89 d0             	mov    %rdx,%rax
  801797:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80179b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80179f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017a3:	48 8b 00             	mov    (%rax),%rax
  8017a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017aa:	eb 4e                	jmp    8017fa <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8017ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017b0:	8b 00                	mov    (%rax),%eax
  8017b2:	83 f8 30             	cmp    $0x30,%eax
  8017b5:	73 24                	jae    8017db <getint+0xeb>
  8017b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c3:	8b 00                	mov    (%rax),%eax
  8017c5:	89 c0                	mov    %eax,%eax
  8017c7:	48 01 d0             	add    %rdx,%rax
  8017ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ce:	8b 12                	mov    (%rdx),%edx
  8017d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d7:	89 0a                	mov    %ecx,(%rdx)
  8017d9:	eb 17                	jmp    8017f2 <getint+0x102>
  8017db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017e3:	48 89 d0             	mov    %rdx,%rax
  8017e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017f2:	8b 00                	mov    (%rax),%eax
  8017f4:	48 98                	cltq   
  8017f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8017fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017fe:	c9                   	leaveq 
  8017ff:	c3                   	retq   

0000000000801800 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801800:	55                   	push   %rbp
  801801:	48 89 e5             	mov    %rsp,%rbp
  801804:	41 54                	push   %r12
  801806:	53                   	push   %rbx
  801807:	48 83 ec 60          	sub    $0x60,%rsp
  80180b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80180f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801813:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801817:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80181b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80181f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801823:	48 8b 0a             	mov    (%rdx),%rcx
  801826:	48 89 08             	mov    %rcx,(%rax)
  801829:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80182d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801831:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801835:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801839:	eb 17                	jmp    801852 <vprintfmt+0x52>
			if (ch == '\0')
  80183b:	85 db                	test   %ebx,%ebx
  80183d:	0f 84 d7 04 00 00    	je     801d1a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  801843:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801847:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80184b:	48 89 c6             	mov    %rax,%rsi
  80184e:	89 df                	mov    %ebx,%edi
  801850:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801852:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801856:	0f b6 00             	movzbl (%rax),%eax
  801859:	0f b6 d8             	movzbl %al,%ebx
  80185c:	83 fb 25             	cmp    $0x25,%ebx
  80185f:	0f 95 c0             	setne  %al
  801862:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801867:	84 c0                	test   %al,%al
  801869:	75 d0                	jne    80183b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80186b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80186f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801876:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80187d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801884:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80188b:	eb 04                	jmp    801891 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80188d:	90                   	nop
  80188e:	eb 01                	jmp    801891 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  801890:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801891:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801895:	0f b6 00             	movzbl (%rax),%eax
  801898:	0f b6 d8             	movzbl %al,%ebx
  80189b:	89 d8                	mov    %ebx,%eax
  80189d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8018a2:	83 e8 23             	sub    $0x23,%eax
  8018a5:	83 f8 55             	cmp    $0x55,%eax
  8018a8:	0f 87 38 04 00 00    	ja     801ce6 <vprintfmt+0x4e6>
  8018ae:	89 c0                	mov    %eax,%eax
  8018b0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8018b7:	00 
  8018b8:	48 b8 70 6a 80 00 00 	movabs $0x806a70,%rax
  8018bf:	00 00 00 
  8018c2:	48 01 d0             	add    %rdx,%rax
  8018c5:	48 8b 00             	mov    (%rax),%rax
  8018c8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8018ca:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8018ce:	eb c1                	jmp    801891 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018d0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8018d4:	eb bb                	jmp    801891 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8018dd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8018e0:	89 d0                	mov    %edx,%eax
  8018e2:	c1 e0 02             	shl    $0x2,%eax
  8018e5:	01 d0                	add    %edx,%eax
  8018e7:	01 c0                	add    %eax,%eax
  8018e9:	01 d8                	add    %ebx,%eax
  8018eb:	83 e8 30             	sub    $0x30,%eax
  8018ee:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8018f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018f5:	0f b6 00             	movzbl (%rax),%eax
  8018f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8018fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8018fe:	7e 63                	jle    801963 <vprintfmt+0x163>
  801900:	83 fb 39             	cmp    $0x39,%ebx
  801903:	7f 5e                	jg     801963 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801905:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80190a:	eb d1                	jmp    8018dd <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80190c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80190f:	83 f8 30             	cmp    $0x30,%eax
  801912:	73 17                	jae    80192b <vprintfmt+0x12b>
  801914:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801918:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80191b:	89 c0                	mov    %eax,%eax
  80191d:	48 01 d0             	add    %rdx,%rax
  801920:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801923:	83 c2 08             	add    $0x8,%edx
  801926:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801929:	eb 0f                	jmp    80193a <vprintfmt+0x13a>
  80192b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80192f:	48 89 d0             	mov    %rdx,%rax
  801932:	48 83 c2 08          	add    $0x8,%rdx
  801936:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80193a:	8b 00                	mov    (%rax),%eax
  80193c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80193f:	eb 23                	jmp    801964 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  801941:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801945:	0f 89 42 ff ff ff    	jns    80188d <vprintfmt+0x8d>
				width = 0;
  80194b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801952:	e9 36 ff ff ff       	jmpq   80188d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801957:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80195e:	e9 2e ff ff ff       	jmpq   801891 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801963:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801964:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801968:	0f 89 22 ff ff ff    	jns    801890 <vprintfmt+0x90>
				width = precision, precision = -1;
  80196e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801971:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801974:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80197b:	e9 10 ff ff ff       	jmpq   801890 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801980:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801984:	e9 08 ff ff ff       	jmpq   801891 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801989:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80198c:	83 f8 30             	cmp    $0x30,%eax
  80198f:	73 17                	jae    8019a8 <vprintfmt+0x1a8>
  801991:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801995:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801998:	89 c0                	mov    %eax,%eax
  80199a:	48 01 d0             	add    %rdx,%rax
  80199d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019a0:	83 c2 08             	add    $0x8,%edx
  8019a3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019a6:	eb 0f                	jmp    8019b7 <vprintfmt+0x1b7>
  8019a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019ac:	48 89 d0             	mov    %rdx,%rax
  8019af:	48 83 c2 08          	add    $0x8,%rdx
  8019b3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019b7:	8b 00                	mov    (%rax),%eax
  8019b9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8019bd:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8019c1:	48 89 d6             	mov    %rdx,%rsi
  8019c4:	89 c7                	mov    %eax,%edi
  8019c6:	ff d1                	callq  *%rcx
			break;
  8019c8:	e9 47 03 00 00       	jmpq   801d14 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8019cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019d0:	83 f8 30             	cmp    $0x30,%eax
  8019d3:	73 17                	jae    8019ec <vprintfmt+0x1ec>
  8019d5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019dc:	89 c0                	mov    %eax,%eax
  8019de:	48 01 d0             	add    %rdx,%rax
  8019e1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019e4:	83 c2 08             	add    $0x8,%edx
  8019e7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019ea:	eb 0f                	jmp    8019fb <vprintfmt+0x1fb>
  8019ec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019f0:	48 89 d0             	mov    %rdx,%rax
  8019f3:	48 83 c2 08          	add    $0x8,%rdx
  8019f7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019fb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8019fd:	85 db                	test   %ebx,%ebx
  8019ff:	79 02                	jns    801a03 <vprintfmt+0x203>
				err = -err;
  801a01:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801a03:	83 fb 10             	cmp    $0x10,%ebx
  801a06:	7f 16                	jg     801a1e <vprintfmt+0x21e>
  801a08:	48 b8 c0 69 80 00 00 	movabs $0x8069c0,%rax
  801a0f:	00 00 00 
  801a12:	48 63 d3             	movslq %ebx,%rdx
  801a15:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801a19:	4d 85 e4             	test   %r12,%r12
  801a1c:	75 2e                	jne    801a4c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  801a1e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a26:	89 d9                	mov    %ebx,%ecx
  801a28:	48 ba 59 6a 80 00 00 	movabs $0x806a59,%rdx
  801a2f:	00 00 00 
  801a32:	48 89 c7             	mov    %rax,%rdi
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3a:	49 b8 24 1d 80 00 00 	movabs $0x801d24,%r8
  801a41:	00 00 00 
  801a44:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a47:	e9 c8 02 00 00       	jmpq   801d14 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a4c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a54:	4c 89 e1             	mov    %r12,%rcx
  801a57:	48 ba 62 6a 80 00 00 	movabs $0x806a62,%rdx
  801a5e:	00 00 00 
  801a61:	48 89 c7             	mov    %rax,%rdi
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
  801a69:	49 b8 24 1d 80 00 00 	movabs $0x801d24,%r8
  801a70:	00 00 00 
  801a73:	41 ff d0             	callq  *%r8
			break;
  801a76:	e9 99 02 00 00       	jmpq   801d14 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801a7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a7e:	83 f8 30             	cmp    $0x30,%eax
  801a81:	73 17                	jae    801a9a <vprintfmt+0x29a>
  801a83:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a8a:	89 c0                	mov    %eax,%eax
  801a8c:	48 01 d0             	add    %rdx,%rax
  801a8f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a92:	83 c2 08             	add    $0x8,%edx
  801a95:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a98:	eb 0f                	jmp    801aa9 <vprintfmt+0x2a9>
  801a9a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801a9e:	48 89 d0             	mov    %rdx,%rax
  801aa1:	48 83 c2 08          	add    $0x8,%rdx
  801aa5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801aa9:	4c 8b 20             	mov    (%rax),%r12
  801aac:	4d 85 e4             	test   %r12,%r12
  801aaf:	75 0a                	jne    801abb <vprintfmt+0x2bb>
				p = "(null)";
  801ab1:	49 bc 65 6a 80 00 00 	movabs $0x806a65,%r12
  801ab8:	00 00 00 
			if (width > 0 && padc != '-')
  801abb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801abf:	7e 7a                	jle    801b3b <vprintfmt+0x33b>
  801ac1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801ac5:	74 74                	je     801b3b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  801ac7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801aca:	48 98                	cltq   
  801acc:	48 89 c6             	mov    %rax,%rsi
  801acf:	4c 89 e7             	mov    %r12,%rdi
  801ad2:	48 b8 2e 21 80 00 00 	movabs $0x80212e,%rax
  801ad9:	00 00 00 
  801adc:	ff d0                	callq  *%rax
  801ade:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801ae1:	eb 17                	jmp    801afa <vprintfmt+0x2fa>
					putch(padc, putdat);
  801ae3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  801ae7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801aeb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  801aef:	48 89 d6             	mov    %rdx,%rsi
  801af2:	89 c7                	mov    %eax,%edi
  801af4:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801af6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801afa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801afe:	7f e3                	jg     801ae3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b00:	eb 39                	jmp    801b3b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  801b02:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801b06:	74 1e                	je     801b26 <vprintfmt+0x326>
  801b08:	83 fb 1f             	cmp    $0x1f,%ebx
  801b0b:	7e 05                	jle    801b12 <vprintfmt+0x312>
  801b0d:	83 fb 7e             	cmp    $0x7e,%ebx
  801b10:	7e 14                	jle    801b26 <vprintfmt+0x326>
					putch('?', putdat);
  801b12:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801b16:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b1a:	48 89 c6             	mov    %rax,%rsi
  801b1d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801b22:	ff d2                	callq  *%rdx
  801b24:	eb 0f                	jmp    801b35 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801b26:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801b2a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b2e:	48 89 c6             	mov    %rax,%rsi
  801b31:	89 df                	mov    %ebx,%edi
  801b33:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b39:	eb 01                	jmp    801b3c <vprintfmt+0x33c>
  801b3b:	90                   	nop
  801b3c:	41 0f b6 04 24       	movzbl (%r12),%eax
  801b41:	0f be d8             	movsbl %al,%ebx
  801b44:	85 db                	test   %ebx,%ebx
  801b46:	0f 95 c0             	setne  %al
  801b49:	49 83 c4 01          	add    $0x1,%r12
  801b4d:	84 c0                	test   %al,%al
  801b4f:	74 28                	je     801b79 <vprintfmt+0x379>
  801b51:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b55:	78 ab                	js     801b02 <vprintfmt+0x302>
  801b57:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801b5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b5f:	79 a1                	jns    801b02 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b61:	eb 16                	jmp    801b79 <vprintfmt+0x379>
				putch(' ', putdat);
  801b63:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801b67:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b6b:	48 89 c6             	mov    %rax,%rsi
  801b6e:	bf 20 00 00 00       	mov    $0x20,%edi
  801b73:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b75:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b7d:	7f e4                	jg     801b63 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  801b7f:	e9 90 01 00 00       	jmpq   801d14 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801b84:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801b88:	be 03 00 00 00       	mov    $0x3,%esi
  801b8d:	48 89 c7             	mov    %rax,%rdi
  801b90:	48 b8 f0 16 80 00 00 	movabs $0x8016f0,%rax
  801b97:	00 00 00 
  801b9a:	ff d0                	callq  *%rax
  801b9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba4:	48 85 c0             	test   %rax,%rax
  801ba7:	79 1d                	jns    801bc6 <vprintfmt+0x3c6>
				putch('-', putdat);
  801ba9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801bad:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801bb1:	48 89 c6             	mov    %rax,%rsi
  801bb4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801bb9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  801bbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbf:	48 f7 d8             	neg    %rax
  801bc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801bc6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bcd:	e9 d5 00 00 00       	jmpq   801ca7 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801bd2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801bd6:	be 03 00 00 00       	mov    $0x3,%esi
  801bdb:	48 89 c7             	mov    %rax,%rdi
  801bde:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	callq  *%rax
  801bea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801bee:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bf5:	e9 ad 00 00 00       	jmpq   801ca7 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  801bfa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801bfe:	be 03 00 00 00       	mov    $0x3,%esi
  801c03:	48 89 c7             	mov    %rax,%rdi
  801c06:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801c0d:	00 00 00 
  801c10:	ff d0                	callq  *%rax
  801c12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  801c16:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801c1d:	e9 85 00 00 00       	jmpq   801ca7 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  801c22:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801c26:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801c2a:	48 89 c6             	mov    %rax,%rsi
  801c2d:	bf 30 00 00 00       	mov    $0x30,%edi
  801c32:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801c34:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801c38:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801c3c:	48 89 c6             	mov    %rax,%rsi
  801c3f:	bf 78 00 00 00       	mov    $0x78,%edi
  801c44:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801c46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c49:	83 f8 30             	cmp    $0x30,%eax
  801c4c:	73 17                	jae    801c65 <vprintfmt+0x465>
  801c4e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801c52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c55:	89 c0                	mov    %eax,%eax
  801c57:	48 01 d0             	add    %rdx,%rax
  801c5a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801c5d:	83 c2 08             	add    $0x8,%edx
  801c60:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c63:	eb 0f                	jmp    801c74 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  801c65:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801c69:	48 89 d0             	mov    %rdx,%rax
  801c6c:	48 83 c2 08          	add    $0x8,%rdx
  801c70:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801c74:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801c7b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801c82:	eb 23                	jmp    801ca7 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801c84:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c88:	be 03 00 00 00       	mov    $0x3,%esi
  801c8d:	48 89 c7             	mov    %rax,%rdi
  801c90:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801c97:	00 00 00 
  801c9a:	ff d0                	callq  *%rax
  801c9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801ca0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801ca7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801cac:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801caf:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801cb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cb6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801cba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cbe:	45 89 c1             	mov    %r8d,%r9d
  801cc1:	41 89 f8             	mov    %edi,%r8d
  801cc4:	48 89 c7             	mov    %rax,%rdi
  801cc7:	48 b8 28 15 80 00 00 	movabs $0x801528,%rax
  801cce:	00 00 00 
  801cd1:	ff d0                	callq  *%rax
			break;
  801cd3:	eb 3f                	jmp    801d14 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801cd5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801cd9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801cdd:	48 89 c6             	mov    %rax,%rsi
  801ce0:	89 df                	mov    %ebx,%edi
  801ce2:	ff d2                	callq  *%rdx
			break;
  801ce4:	eb 2e                	jmp    801d14 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ce6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801cea:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801cee:	48 89 c6             	mov    %rax,%rsi
  801cf1:	bf 25 00 00 00       	mov    $0x25,%edi
  801cf6:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801cf8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801cfd:	eb 05                	jmp    801d04 <vprintfmt+0x504>
  801cff:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d04:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801d08:	48 83 e8 01          	sub    $0x1,%rax
  801d0c:	0f b6 00             	movzbl (%rax),%eax
  801d0f:	3c 25                	cmp    $0x25,%al
  801d11:	75 ec                	jne    801cff <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  801d13:	90                   	nop
		}
	}
  801d14:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d15:	e9 38 fb ff ff       	jmpq   801852 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801d1a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  801d1b:	48 83 c4 60          	add    $0x60,%rsp
  801d1f:	5b                   	pop    %rbx
  801d20:	41 5c                	pop    %r12
  801d22:	5d                   	pop    %rbp
  801d23:	c3                   	retq   

0000000000801d24 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801d24:	55                   	push   %rbp
  801d25:	48 89 e5             	mov    %rsp,%rbp
  801d28:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801d2f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801d36:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801d3d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801d44:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801d4b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801d52:	84 c0                	test   %al,%al
  801d54:	74 20                	je     801d76 <printfmt+0x52>
  801d56:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801d5a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801d5e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801d62:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801d66:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801d6a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801d6e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801d72:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801d76:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801d7d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801d84:	00 00 00 
  801d87:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801d8e:	00 00 00 
  801d91:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d95:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801d9c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801da3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801daa:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801db1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801db8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801dbf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801dc6:	48 89 c7             	mov    %rax,%rdi
  801dc9:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  801dd0:	00 00 00 
  801dd3:	ff d0                	callq  *%rax
	va_end(ap);
}
  801dd5:	c9                   	leaveq 
  801dd6:	c3                   	retq   

0000000000801dd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801dd7:	55                   	push   %rbp
  801dd8:	48 89 e5             	mov    %rsp,%rbp
  801ddb:	48 83 ec 10          	sub    $0x10,%rsp
  801ddf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801de6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dea:	8b 40 10             	mov    0x10(%rax),%eax
  801ded:	8d 50 01             	lea    0x1(%rax),%edx
  801df0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dfb:	48 8b 10             	mov    (%rax),%rdx
  801dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e02:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e06:	48 39 c2             	cmp    %rax,%rdx
  801e09:	73 17                	jae    801e22 <sprintputch+0x4b>
		*b->buf++ = ch;
  801e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e0f:	48 8b 00             	mov    (%rax),%rax
  801e12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e15:	88 10                	mov    %dl,(%rax)
  801e17:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e1f:	48 89 10             	mov    %rdx,(%rax)
}
  801e22:	c9                   	leaveq 
  801e23:	c3                   	retq   

0000000000801e24 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e24:	55                   	push   %rbp
  801e25:	48 89 e5             	mov    %rsp,%rbp
  801e28:	48 83 ec 50          	sub    $0x50,%rsp
  801e2c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801e30:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801e33:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801e37:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801e3b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801e3f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e43:	48 8b 0a             	mov    (%rdx),%rcx
  801e46:	48 89 08             	mov    %rcx,(%rax)
  801e49:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e4d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e51:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e55:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e59:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e5d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801e61:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801e64:	48 98                	cltq   
  801e66:	48 83 e8 01          	sub    $0x1,%rax
  801e6a:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801e6e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801e72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801e79:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801e7e:	74 06                	je     801e86 <vsnprintf+0x62>
  801e80:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801e84:	7f 07                	jg     801e8d <vsnprintf+0x69>
		return -E_INVAL;
  801e86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e8b:	eb 2f                	jmp    801ebc <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801e8d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801e91:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e95:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e99:	48 89 c6             	mov    %rax,%rsi
  801e9c:	48 bf d7 1d 80 00 00 	movabs $0x801dd7,%rdi
  801ea3:	00 00 00 
  801ea6:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  801ead:	00 00 00 
  801eb0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801eb2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801eb6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801eb9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801ebc:	c9                   	leaveq 
  801ebd:	c3                   	retq   

0000000000801ebe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ebe:	55                   	push   %rbp
  801ebf:	48 89 e5             	mov    %rsp,%rbp
  801ec2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ec9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801ed0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801ed6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801edd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801ee4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801eeb:	84 c0                	test   %al,%al
  801eed:	74 20                	je     801f0f <snprintf+0x51>
  801eef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801ef3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801ef7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801efb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801eff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801f03:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801f07:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801f0b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801f0f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801f16:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801f1d:	00 00 00 
  801f20:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801f27:	00 00 00 
  801f2a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f2e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801f35:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f3c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801f43:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801f4a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801f51:	48 8b 0a             	mov    (%rdx),%rcx
  801f54:	48 89 08             	mov    %rcx,(%rax)
  801f57:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f5b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f5f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f63:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801f67:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801f6e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801f75:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801f7b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f82:	48 89 c7             	mov    %rax,%rdi
  801f85:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  801f8c:	00 00 00 
  801f8f:	ff d0                	callq  *%rax
  801f91:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801f97:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801f9d:	c9                   	leaveq 
  801f9e:	c3                   	retq   
	...

0000000000801fa0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801fa0:	55                   	push   %rbp
  801fa1:	48 89 e5             	mov    %rsp,%rbp
  801fa4:	48 83 ec 20          	sub    $0x20,%rsp
  801fa8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801fac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801fb1:	74 27                	je     801fda <readline+0x3a>
		fprintf(1, "%s", prompt);
  801fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb7:	48 89 c2             	mov    %rax,%rdx
  801fba:	48 be 20 6d 80 00 00 	movabs $0x806d20,%rsi
  801fc1:	00 00 00 
  801fc4:	bf 01 00 00 00       	mov    $0x1,%edi
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	48 b9 28 46 80 00 00 	movabs $0x804628,%rcx
  801fd5:	00 00 00 
  801fd8:	ff d1                	callq  *%rcx
#endif

	i = 0;
  801fda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  801fe1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe6:	48 b8 0c 0f 80 00 00 	movabs $0x800f0c,%rax
  801fed:	00 00 00 
  801ff0:	ff d0                	callq  *%rax
  801ff2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801ff5:	eb 01                	jmp    801ff8 <readline+0x58>
			if (echoing)
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
  801ff7:	90                   	nop
#endif

	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
  801ff8:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  801fff:	00 00 00 
  802002:	ff d0                	callq  *%rax
  802004:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  802007:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80200b:	79 30                	jns    80203d <readline+0x9d>
			if (c != -E_EOF)
  80200d:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  802011:	74 20                	je     802033 <readline+0x93>
				cprintf("read error: %e\n", c);
  802013:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802016:	89 c6                	mov    %eax,%esi
  802018:	48 bf 23 6d 80 00 00 	movabs $0x806d23,%rdi
  80201f:	00 00 00 
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	48 ba 4f 14 80 00 00 	movabs $0x80144f,%rdx
  80202e:	00 00 00 
  802031:	ff d2                	callq  *%rdx
			return NULL;
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
  802038:	e9 c0 00 00 00       	jmpq   8020fd <readline+0x15d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80203d:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  802041:	74 06                	je     802049 <readline+0xa9>
  802043:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  802047:	75 26                	jne    80206f <readline+0xcf>
  802049:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80204d:	7e 20                	jle    80206f <readline+0xcf>
			if (echoing)
  80204f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802053:	74 11                	je     802066 <readline+0xc6>
				cputchar('\b');
  802055:	bf 08 00 00 00       	mov    $0x8,%edi
  80205a:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
			i--;
  802066:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80206a:	e9 89 00 00 00       	jmpq   8020f8 <readline+0x158>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80206f:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802073:	7e 3d                	jle    8020b2 <readline+0x112>
  802075:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80207c:	7f 34                	jg     8020b2 <readline+0x112>
			if (echoing)
  80207e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802082:	74 11                	je     802095 <readline+0xf5>
				cputchar(c);
  802084:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802087:	89 c7                	mov    %eax,%edi
  802089:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  802090:	00 00 00 
  802093:	ff d0                	callq  *%rax
			buf[i++] = c;
  802095:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802098:	89 c1                	mov    %eax,%ecx
  80209a:	48 ba 40 a0 80 00 00 	movabs $0x80a040,%rdx
  8020a1:	00 00 00 
  8020a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a7:	48 98                	cltq   
  8020a9:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8020ac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020b0:	eb 46                	jmp    8020f8 <readline+0x158>
		} else if (c == '\n' || c == '\r') {
  8020b2:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8020b6:	74 0a                	je     8020c2 <readline+0x122>
  8020b8:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8020bc:	0f 85 35 ff ff ff    	jne    801ff7 <readline+0x57>
			if (echoing)
  8020c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020c6:	74 11                	je     8020d9 <readline+0x139>
				cputchar('\n');
  8020c8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020cd:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  8020d4:	00 00 00 
  8020d7:	ff d0                	callq  *%rax
			buf[i] = 0;
  8020d9:	48 ba 40 a0 80 00 00 	movabs $0x80a040,%rdx
  8020e0:	00 00 00 
  8020e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e6:	48 98                	cltq   
  8020e8:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8020ec:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  8020f3:	00 00 00 
  8020f6:	eb 05                	jmp    8020fd <readline+0x15d>
		}
	}
  8020f8:	e9 fa fe ff ff       	jmpq   801ff7 <readline+0x57>
}
  8020fd:	c9                   	leaveq 
  8020fe:	c3                   	retq   
	...

0000000000802100 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	48 83 ec 18          	sub    $0x18,%rsp
  802108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80210c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802113:	eb 09                	jmp    80211e <strlen+0x1e>
		n++;
  802115:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802119:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80211e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802122:	0f b6 00             	movzbl (%rax),%eax
  802125:	84 c0                	test   %al,%al
  802127:	75 ec                	jne    802115 <strlen+0x15>
		n++;
	return n;
  802129:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80212c:	c9                   	leaveq 
  80212d:	c3                   	retq   

000000000080212e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80212e:	55                   	push   %rbp
  80212f:	48 89 e5             	mov    %rsp,%rbp
  802132:	48 83 ec 20          	sub    $0x20,%rsp
  802136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80213a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80213e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802145:	eb 0e                	jmp    802155 <strnlen+0x27>
		n++;
  802147:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80214b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802150:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802155:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80215a:	74 0b                	je     802167 <strnlen+0x39>
  80215c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802160:	0f b6 00             	movzbl (%rax),%eax
  802163:	84 c0                	test   %al,%al
  802165:	75 e0                	jne    802147 <strnlen+0x19>
		n++;
	return n;
  802167:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80216a:	c9                   	leaveq 
  80216b:	c3                   	retq   

000000000080216c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
  802170:	48 83 ec 20          	sub    $0x20,%rsp
  802174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80217c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802180:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802184:	90                   	nop
  802185:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802189:	0f b6 10             	movzbl (%rax),%edx
  80218c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802190:	88 10                	mov    %dl,(%rax)
  802192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802196:	0f b6 00             	movzbl (%rax),%eax
  802199:	84 c0                	test   %al,%al
  80219b:	0f 95 c0             	setne  %al
  80219e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8021a3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8021a8:	84 c0                	test   %al,%al
  8021aa:	75 d9                	jne    802185 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8021ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8021b0:	c9                   	leaveq 
  8021b1:	c3                   	retq   

00000000008021b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8021b2:	55                   	push   %rbp
  8021b3:	48 89 e5             	mov    %rsp,%rbp
  8021b6:	48 83 ec 20          	sub    $0x20,%rsp
  8021ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8021c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c6:	48 89 c7             	mov    %rax,%rdi
  8021c9:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8021d0:	00 00 00 
  8021d3:	ff d0                	callq  *%rax
  8021d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8021d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021db:	48 98                	cltq   
  8021dd:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8021e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021e5:	48 89 d6             	mov    %rdx,%rsi
  8021e8:	48 89 c7             	mov    %rax,%rdi
  8021eb:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8021f2:	00 00 00 
  8021f5:	ff d0                	callq  *%rax
	return dst;
  8021f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8021fb:	c9                   	leaveq 
  8021fc:	c3                   	retq   

00000000008021fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8021fd:	55                   	push   %rbp
  8021fe:	48 89 e5             	mov    %rsp,%rbp
  802201:	48 83 ec 28          	sub    $0x28,%rsp
  802205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802209:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80220d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802215:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802219:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802220:	00 
  802221:	eb 27                	jmp    80224a <strncpy+0x4d>
		*dst++ = *src;
  802223:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802227:	0f b6 10             	movzbl (%rax),%edx
  80222a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222e:	88 10                	mov    %dl,(%rax)
  802230:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802235:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802239:	0f b6 00             	movzbl (%rax),%eax
  80223c:	84 c0                	test   %al,%al
  80223e:	74 05                	je     802245 <strncpy+0x48>
			src++;
  802240:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802245:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80224a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802252:	72 cf                	jb     802223 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802258:	c9                   	leaveq 
  802259:	c3                   	retq   

000000000080225a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80225a:	55                   	push   %rbp
  80225b:	48 89 e5             	mov    %rsp,%rbp
  80225e:	48 83 ec 28          	sub    $0x28,%rsp
  802262:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802266:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80226a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80226e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802272:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802276:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80227b:	74 37                	je     8022b4 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80227d:	eb 17                	jmp    802296 <strlcpy+0x3c>
			*dst++ = *src++;
  80227f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802283:	0f b6 10             	movzbl (%rax),%edx
  802286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228a:	88 10                	mov    %dl,(%rax)
  80228c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802291:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802296:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80229b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022a0:	74 0b                	je     8022ad <strlcpy+0x53>
  8022a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a6:	0f b6 00             	movzbl (%rax),%eax
  8022a9:	84 c0                	test   %al,%al
  8022ab:	75 d2                	jne    80227f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8022ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8022b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022bc:	48 89 d1             	mov    %rdx,%rcx
  8022bf:	48 29 c1             	sub    %rax,%rcx
  8022c2:	48 89 c8             	mov    %rcx,%rax
}
  8022c5:	c9                   	leaveq 
  8022c6:	c3                   	retq   

00000000008022c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022c7:	55                   	push   %rbp
  8022c8:	48 89 e5             	mov    %rsp,%rbp
  8022cb:	48 83 ec 10          	sub    $0x10,%rsp
  8022cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8022d7:	eb 0a                	jmp    8022e3 <strcmp+0x1c>
		p++, q++;
  8022d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8022e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e7:	0f b6 00             	movzbl (%rax),%eax
  8022ea:	84 c0                	test   %al,%al
  8022ec:	74 12                	je     802300 <strcmp+0x39>
  8022ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f2:	0f b6 10             	movzbl (%rax),%edx
  8022f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f9:	0f b6 00             	movzbl (%rax),%eax
  8022fc:	38 c2                	cmp    %al,%dl
  8022fe:	74 d9                	je     8022d9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802304:	0f b6 00             	movzbl (%rax),%eax
  802307:	0f b6 d0             	movzbl %al,%edx
  80230a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230e:	0f b6 00             	movzbl (%rax),%eax
  802311:	0f b6 c0             	movzbl %al,%eax
  802314:	89 d1                	mov    %edx,%ecx
  802316:	29 c1                	sub    %eax,%ecx
  802318:	89 c8                	mov    %ecx,%eax
}
  80231a:	c9                   	leaveq 
  80231b:	c3                   	retq   

000000000080231c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80231c:	55                   	push   %rbp
  80231d:	48 89 e5             	mov    %rsp,%rbp
  802320:	48 83 ec 18          	sub    $0x18,%rsp
  802324:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802328:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80232c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802330:	eb 0f                	jmp    802341 <strncmp+0x25>
		n--, p++, q++;
  802332:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802337:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80233c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802341:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802346:	74 1d                	je     802365 <strncmp+0x49>
  802348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234c:	0f b6 00             	movzbl (%rax),%eax
  80234f:	84 c0                	test   %al,%al
  802351:	74 12                	je     802365 <strncmp+0x49>
  802353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802357:	0f b6 10             	movzbl (%rax),%edx
  80235a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235e:	0f b6 00             	movzbl (%rax),%eax
  802361:	38 c2                	cmp    %al,%dl
  802363:	74 cd                	je     802332 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802365:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80236a:	75 07                	jne    802373 <strncmp+0x57>
		return 0;
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	eb 1a                	jmp    80238d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802377:	0f b6 00             	movzbl (%rax),%eax
  80237a:	0f b6 d0             	movzbl %al,%edx
  80237d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802381:	0f b6 00             	movzbl (%rax),%eax
  802384:	0f b6 c0             	movzbl %al,%eax
  802387:	89 d1                	mov    %edx,%ecx
  802389:	29 c1                	sub    %eax,%ecx
  80238b:	89 c8                	mov    %ecx,%eax
}
  80238d:	c9                   	leaveq 
  80238e:	c3                   	retq   

000000000080238f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80238f:	55                   	push   %rbp
  802390:	48 89 e5             	mov    %rsp,%rbp
  802393:	48 83 ec 10          	sub    $0x10,%rsp
  802397:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023a0:	eb 17                	jmp    8023b9 <strchr+0x2a>
		if (*s == c)
  8023a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a6:	0f b6 00             	movzbl (%rax),%eax
  8023a9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023ac:	75 06                	jne    8023b4 <strchr+0x25>
			return (char *) s;
  8023ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b2:	eb 15                	jmp    8023c9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8023b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023bd:	0f b6 00             	movzbl (%rax),%eax
  8023c0:	84 c0                	test   %al,%al
  8023c2:	75 de                	jne    8023a2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c9:	c9                   	leaveq 
  8023ca:	c3                   	retq   

00000000008023cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023cb:	55                   	push   %rbp
  8023cc:	48 89 e5             	mov    %rsp,%rbp
  8023cf:	48 83 ec 10          	sub    $0x10,%rsp
  8023d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023d7:	89 f0                	mov    %esi,%eax
  8023d9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023dc:	eb 11                	jmp    8023ef <strfind+0x24>
		if (*s == c)
  8023de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e2:	0f b6 00             	movzbl (%rax),%eax
  8023e5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023e8:	74 12                	je     8023fc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8023ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f3:	0f b6 00             	movzbl (%rax),%eax
  8023f6:	84 c0                	test   %al,%al
  8023f8:	75 e4                	jne    8023de <strfind+0x13>
  8023fa:	eb 01                	jmp    8023fd <strfind+0x32>
		if (*s == c)
			break;
  8023fc:	90                   	nop
	return (char *) s;
  8023fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802401:	c9                   	leaveq 
  802402:	c3                   	retq   

0000000000802403 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802403:	55                   	push   %rbp
  802404:	48 89 e5             	mov    %rsp,%rbp
  802407:	48 83 ec 18          	sub    $0x18,%rsp
  80240b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80240f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802412:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802416:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80241b:	75 06                	jne    802423 <memset+0x20>
		return v;
  80241d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802421:	eb 69                	jmp    80248c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802427:	83 e0 03             	and    $0x3,%eax
  80242a:	48 85 c0             	test   %rax,%rax
  80242d:	75 48                	jne    802477 <memset+0x74>
  80242f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802433:	83 e0 03             	and    $0x3,%eax
  802436:	48 85 c0             	test   %rax,%rax
  802439:	75 3c                	jne    802477 <memset+0x74>
		c &= 0xFF;
  80243b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802442:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802445:	89 c2                	mov    %eax,%edx
  802447:	c1 e2 18             	shl    $0x18,%edx
  80244a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80244d:	c1 e0 10             	shl    $0x10,%eax
  802450:	09 c2                	or     %eax,%edx
  802452:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802455:	c1 e0 08             	shl    $0x8,%eax
  802458:	09 d0                	or     %edx,%eax
  80245a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80245d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802461:	48 89 c1             	mov    %rax,%rcx
  802464:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802468:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80246c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80246f:	48 89 d7             	mov    %rdx,%rdi
  802472:	fc                   	cld    
  802473:	f3 ab                	rep stos %eax,%es:(%rdi)
  802475:	eb 11                	jmp    802488 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802477:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80247b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80247e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802482:	48 89 d7             	mov    %rdx,%rdi
  802485:	fc                   	cld    
  802486:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80248c:	c9                   	leaveq 
  80248d:	c3                   	retq   

000000000080248e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80248e:	55                   	push   %rbp
  80248f:	48 89 e5             	mov    %rsp,%rbp
  802492:	48 83 ec 28          	sub    $0x28,%rsp
  802496:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80249a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80249e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8024a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8024aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8024b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024ba:	0f 83 88 00 00 00    	jae    802548 <memmove+0xba>
  8024c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024c8:	48 01 d0             	add    %rdx,%rax
  8024cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024cf:	76 77                	jbe    802548 <memmove+0xba>
		s += n;
  8024d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8024d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024dd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8024e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e5:	83 e0 03             	and    $0x3,%eax
  8024e8:	48 85 c0             	test   %rax,%rax
  8024eb:	75 3b                	jne    802528 <memmove+0x9a>
  8024ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f1:	83 e0 03             	and    $0x3,%eax
  8024f4:	48 85 c0             	test   %rax,%rax
  8024f7:	75 2f                	jne    802528 <memmove+0x9a>
  8024f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024fd:	83 e0 03             	and    $0x3,%eax
  802500:	48 85 c0             	test   %rax,%rax
  802503:	75 23                	jne    802528 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802509:	48 83 e8 04          	sub    $0x4,%rax
  80250d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802511:	48 83 ea 04          	sub    $0x4,%rdx
  802515:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802519:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80251d:	48 89 c7             	mov    %rax,%rdi
  802520:	48 89 d6             	mov    %rdx,%rsi
  802523:	fd                   	std    
  802524:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802526:	eb 1d                	jmp    802545 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802534:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253c:	48 89 d7             	mov    %rdx,%rdi
  80253f:	48 89 c1             	mov    %rax,%rcx
  802542:	fd                   	std    
  802543:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802545:	fc                   	cld    
  802546:	eb 57                	jmp    80259f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254c:	83 e0 03             	and    $0x3,%eax
  80254f:	48 85 c0             	test   %rax,%rax
  802552:	75 36                	jne    80258a <memmove+0xfc>
  802554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802558:	83 e0 03             	and    $0x3,%eax
  80255b:	48 85 c0             	test   %rax,%rax
  80255e:	75 2a                	jne    80258a <memmove+0xfc>
  802560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802564:	83 e0 03             	and    $0x3,%eax
  802567:	48 85 c0             	test   %rax,%rax
  80256a:	75 1e                	jne    80258a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80256c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802570:	48 89 c1             	mov    %rax,%rcx
  802573:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80257f:	48 89 c7             	mov    %rax,%rdi
  802582:	48 89 d6             	mov    %rdx,%rsi
  802585:	fc                   	cld    
  802586:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802588:	eb 15                	jmp    80259f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80258a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80258e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802592:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802596:	48 89 c7             	mov    %rax,%rdi
  802599:	48 89 d6             	mov    %rdx,%rsi
  80259c:	fc                   	cld    
  80259d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80259f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8025a3:	c9                   	leaveq 
  8025a4:	c3                   	retq   

00000000008025a5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8025a5:	55                   	push   %rbp
  8025a6:	48 89 e5             	mov    %rsp,%rbp
  8025a9:	48 83 ec 18          	sub    $0x18,%rsp
  8025ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8025b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c5:	48 89 ce             	mov    %rcx,%rsi
  8025c8:	48 89 c7             	mov    %rax,%rdi
  8025cb:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
}
  8025d7:	c9                   	leaveq 
  8025d8:	c3                   	retq   

00000000008025d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8025d9:	55                   	push   %rbp
  8025da:	48 89 e5             	mov    %rsp,%rbp
  8025dd:	48 83 ec 28          	sub    $0x28,%rsp
  8025e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8025ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8025f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8025fd:	eb 38                	jmp    802637 <memcmp+0x5e>
		if (*s1 != *s2)
  8025ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802603:	0f b6 10             	movzbl (%rax),%edx
  802606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260a:	0f b6 00             	movzbl (%rax),%eax
  80260d:	38 c2                	cmp    %al,%dl
  80260f:	74 1c                	je     80262d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  802611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802615:	0f b6 00             	movzbl (%rax),%eax
  802618:	0f b6 d0             	movzbl %al,%edx
  80261b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261f:	0f b6 00             	movzbl (%rax),%eax
  802622:	0f b6 c0             	movzbl %al,%eax
  802625:	89 d1                	mov    %edx,%ecx
  802627:	29 c1                	sub    %eax,%ecx
  802629:	89 c8                	mov    %ecx,%eax
  80262b:	eb 20                	jmp    80264d <memcmp+0x74>
		s1++, s2++;
  80262d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802632:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802637:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80263c:	0f 95 c0             	setne  %al
  80263f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802644:	84 c0                	test   %al,%al
  802646:	75 b7                	jne    8025ff <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264d:	c9                   	leaveq 
  80264e:	c3                   	retq   

000000000080264f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80264f:	55                   	push   %rbp
  802650:	48 89 e5             	mov    %rsp,%rbp
  802653:	48 83 ec 28          	sub    $0x28,%rsp
  802657:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80265b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80265e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80266a:	48 01 d0             	add    %rdx,%rax
  80266d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802671:	eb 13                	jmp    802686 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  802673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802677:	0f b6 10             	movzbl (%rax),%edx
  80267a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80267d:	38 c2                	cmp    %al,%dl
  80267f:	74 11                	je     802692 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802681:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80268e:	72 e3                	jb     802673 <memfind+0x24>
  802690:	eb 01                	jmp    802693 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802692:	90                   	nop
	return (void *) s;
  802693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802697:	c9                   	leaveq 
  802698:	c3                   	retq   

0000000000802699 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802699:	55                   	push   %rbp
  80269a:	48 89 e5             	mov    %rsp,%rbp
  80269d:	48 83 ec 38          	sub    $0x38,%rsp
  8026a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026a9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8026ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8026b3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8026ba:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026bb:	eb 05                	jmp    8026c2 <strtol+0x29>
		s++;
  8026bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c6:	0f b6 00             	movzbl (%rax),%eax
  8026c9:	3c 20                	cmp    $0x20,%al
  8026cb:	74 f0                	je     8026bd <strtol+0x24>
  8026cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d1:	0f b6 00             	movzbl (%rax),%eax
  8026d4:	3c 09                	cmp    $0x9,%al
  8026d6:	74 e5                	je     8026bd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8026d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026dc:	0f b6 00             	movzbl (%rax),%eax
  8026df:	3c 2b                	cmp    $0x2b,%al
  8026e1:	75 07                	jne    8026ea <strtol+0x51>
		s++;
  8026e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026e8:	eb 17                	jmp    802701 <strtol+0x68>
	else if (*s == '-')
  8026ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ee:	0f b6 00             	movzbl (%rax),%eax
  8026f1:	3c 2d                	cmp    $0x2d,%al
  8026f3:	75 0c                	jne    802701 <strtol+0x68>
		s++, neg = 1;
  8026f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802701:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802705:	74 06                	je     80270d <strtol+0x74>
  802707:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80270b:	75 28                	jne    802735 <strtol+0x9c>
  80270d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802711:	0f b6 00             	movzbl (%rax),%eax
  802714:	3c 30                	cmp    $0x30,%al
  802716:	75 1d                	jne    802735 <strtol+0x9c>
  802718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271c:	48 83 c0 01          	add    $0x1,%rax
  802720:	0f b6 00             	movzbl (%rax),%eax
  802723:	3c 78                	cmp    $0x78,%al
  802725:	75 0e                	jne    802735 <strtol+0x9c>
		s += 2, base = 16;
  802727:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80272c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802733:	eb 2c                	jmp    802761 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802735:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802739:	75 19                	jne    802754 <strtol+0xbb>
  80273b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273f:	0f b6 00             	movzbl (%rax),%eax
  802742:	3c 30                	cmp    $0x30,%al
  802744:	75 0e                	jne    802754 <strtol+0xbb>
		s++, base = 8;
  802746:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80274b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802752:	eb 0d                	jmp    802761 <strtol+0xc8>
	else if (base == 0)
  802754:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802758:	75 07                	jne    802761 <strtol+0xc8>
		base = 10;
  80275a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802765:	0f b6 00             	movzbl (%rax),%eax
  802768:	3c 2f                	cmp    $0x2f,%al
  80276a:	7e 1d                	jle    802789 <strtol+0xf0>
  80276c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802770:	0f b6 00             	movzbl (%rax),%eax
  802773:	3c 39                	cmp    $0x39,%al
  802775:	7f 12                	jg     802789 <strtol+0xf0>
			dig = *s - '0';
  802777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277b:	0f b6 00             	movzbl (%rax),%eax
  80277e:	0f be c0             	movsbl %al,%eax
  802781:	83 e8 30             	sub    $0x30,%eax
  802784:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802787:	eb 4e                	jmp    8027d7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278d:	0f b6 00             	movzbl (%rax),%eax
  802790:	3c 60                	cmp    $0x60,%al
  802792:	7e 1d                	jle    8027b1 <strtol+0x118>
  802794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802798:	0f b6 00             	movzbl (%rax),%eax
  80279b:	3c 7a                	cmp    $0x7a,%al
  80279d:	7f 12                	jg     8027b1 <strtol+0x118>
			dig = *s - 'a' + 10;
  80279f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a3:	0f b6 00             	movzbl (%rax),%eax
  8027a6:	0f be c0             	movsbl %al,%eax
  8027a9:	83 e8 57             	sub    $0x57,%eax
  8027ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027af:	eb 26                	jmp    8027d7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8027b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b5:	0f b6 00             	movzbl (%rax),%eax
  8027b8:	3c 40                	cmp    $0x40,%al
  8027ba:	7e 47                	jle    802803 <strtol+0x16a>
  8027bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c0:	0f b6 00             	movzbl (%rax),%eax
  8027c3:	3c 5a                	cmp    $0x5a,%al
  8027c5:	7f 3c                	jg     802803 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8027c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027cb:	0f b6 00             	movzbl (%rax),%eax
  8027ce:	0f be c0             	movsbl %al,%eax
  8027d1:	83 e8 37             	sub    $0x37,%eax
  8027d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8027d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027da:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8027dd:	7d 23                	jge    802802 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8027df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027e4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027e7:	48 98                	cltq   
  8027e9:	48 89 c2             	mov    %rax,%rdx
  8027ec:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8027f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f4:	48 98                	cltq   
  8027f6:	48 01 d0             	add    %rdx,%rax
  8027f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8027fd:	e9 5f ff ff ff       	jmpq   802761 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802802:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802803:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802808:	74 0b                	je     802815 <strtol+0x17c>
		*endptr = (char *) s;
  80280a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80280e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802812:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  802815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802819:	74 09                	je     802824 <strtol+0x18b>
  80281b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281f:	48 f7 d8             	neg    %rax
  802822:	eb 04                	jmp    802828 <strtol+0x18f>
  802824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802828:	c9                   	leaveq 
  802829:	c3                   	retq   

000000000080282a <strstr>:

char * strstr(const char *in, const char *str)
{
  80282a:	55                   	push   %rbp
  80282b:	48 89 e5             	mov    %rsp,%rbp
  80282e:	48 83 ec 30          	sub    $0x30,%rsp
  802832:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802836:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80283a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80283e:	0f b6 00             	movzbl (%rax),%eax
  802841:	88 45 ff             	mov    %al,-0x1(%rbp)
  802844:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  802849:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80284d:	75 06                	jne    802855 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80284f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802853:	eb 68                	jmp    8028bd <strstr+0x93>

    len = strlen(str);
  802855:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802859:	48 89 c7             	mov    %rax,%rdi
  80285c:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  802863:	00 00 00 
  802866:	ff d0                	callq  *%rax
  802868:	48 98                	cltq   
  80286a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80286e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802872:	0f b6 00             	movzbl (%rax),%eax
  802875:	88 45 ef             	mov    %al,-0x11(%rbp)
  802878:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80287d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802881:	75 07                	jne    80288a <strstr+0x60>
                return (char *) 0;
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	eb 33                	jmp    8028bd <strstr+0x93>
        } while (sc != c);
  80288a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80288e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802891:	75 db                	jne    80286e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  802893:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802897:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80289b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289f:	48 89 ce             	mov    %rcx,%rsi
  8028a2:	48 89 c7             	mov    %rax,%rdi
  8028a5:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  8028ac:	00 00 00 
  8028af:	ff d0                	callq  *%rax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	75 b9                	jne    80286e <strstr+0x44>

    return (char *) (in - 1);
  8028b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b9:	48 83 e8 01          	sub    $0x1,%rax
}
  8028bd:	c9                   	leaveq 
  8028be:	c3                   	retq   
	...

00000000008028c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8028c0:	55                   	push   %rbp
  8028c1:	48 89 e5             	mov    %rsp,%rbp
  8028c4:	53                   	push   %rbx
  8028c5:	48 83 ec 58          	sub    $0x58,%rsp
  8028c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028cc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8028cf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8028d3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8028d7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8028db:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028e2:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8028e5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8028e9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8028ed:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8028f1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8028f5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8028f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8028fc:	4c 89 c3             	mov    %r8,%rbx
  8028ff:	cd 30                	int    $0x30
  802901:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  802905:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  802909:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80290d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802911:	74 3e                	je     802951 <syscall+0x91>
  802913:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802918:	7e 37                	jle    802951 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80291a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80291e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802921:	49 89 d0             	mov    %rdx,%r8
  802924:	89 c1                	mov    %eax,%ecx
  802926:	48 ba 33 6d 80 00 00 	movabs $0x806d33,%rdx
  80292d:	00 00 00 
  802930:	be 23 00 00 00       	mov    $0x23,%esi
  802935:	48 bf 50 6d 80 00 00 	movabs $0x806d50,%rdi
  80293c:	00 00 00 
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
  802944:	49 b9 14 12 80 00 00 	movabs $0x801214,%r9
  80294b:	00 00 00 
  80294e:	41 ff d1             	callq  *%r9

	return ret;
  802951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802955:	48 83 c4 58          	add    $0x58,%rsp
  802959:	5b                   	pop    %rbx
  80295a:	5d                   	pop    %rbp
  80295b:	c3                   	retq   

000000000080295c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80295c:	55                   	push   %rbp
  80295d:	48 89 e5             	mov    %rsp,%rbp
  802960:	48 83 ec 20          	sub    $0x20,%rsp
  802964:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802968:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80296c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802970:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802974:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80297b:	00 
  80297c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802982:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802988:	48 89 d1             	mov    %rdx,%rcx
  80298b:	48 89 c2             	mov    %rax,%rdx
  80298e:	be 00 00 00 00       	mov    $0x0,%esi
  802993:	bf 00 00 00 00       	mov    $0x0,%edi
  802998:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	callq  *%rax
}
  8029a4:	c9                   	leaveq 
  8029a5:	c3                   	retq   

00000000008029a6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
  8029aa:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8029ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029b5:	00 
  8029b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8029c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029cc:	be 00 00 00 00       	mov    $0x0,%esi
  8029d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8029d6:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  8029dd:	00 00 00 
  8029e0:	ff d0                	callq  *%rax
}
  8029e2:	c9                   	leaveq 
  8029e3:	c3                   	retq   

00000000008029e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8029e4:	55                   	push   %rbp
  8029e5:	48 89 e5             	mov    %rsp,%rbp
  8029e8:	48 83 ec 20          	sub    $0x20,%rsp
  8029ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8029ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f2:	48 98                	cltq   
  8029f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029fb:	00 
  8029fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a08:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a0d:	48 89 c2             	mov    %rax,%rdx
  802a10:	be 01 00 00 00       	mov    $0x1,%esi
  802a15:	bf 03 00 00 00       	mov    $0x3,%edi
  802a1a:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
}
  802a26:	c9                   	leaveq 
  802a27:	c3                   	retq   

0000000000802a28 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802a28:	55                   	push   %rbp
  802a29:	48 89 e5             	mov    %rsp,%rbp
  802a2c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802a30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a37:	00 
  802a38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a44:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a49:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4e:	be 00 00 00 00       	mov    $0x0,%esi
  802a53:	bf 02 00 00 00       	mov    $0x2,%edi
  802a58:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802a5f:	00 00 00 
  802a62:	ff d0                	callq  *%rax
}
  802a64:	c9                   	leaveq 
  802a65:	c3                   	retq   

0000000000802a66 <sys_yield>:

void
sys_yield(void)
{
  802a66:	55                   	push   %rbp
  802a67:	48 89 e5             	mov    %rsp,%rbp
  802a6a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802a6e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a75:	00 
  802a76:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a7c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a82:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a87:	ba 00 00 00 00       	mov    $0x0,%edx
  802a8c:	be 00 00 00 00       	mov    $0x0,%esi
  802a91:	bf 0b 00 00 00       	mov    $0xb,%edi
  802a96:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	callq  *%rax
}
  802aa2:	c9                   	leaveq 
  802aa3:	c3                   	retq   

0000000000802aa4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802aa4:	55                   	push   %rbp
  802aa5:	48 89 e5             	mov    %rsp,%rbp
  802aa8:	48 83 ec 20          	sub    $0x20,%rsp
  802aac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802aaf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ab3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802ab6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab9:	48 63 c8             	movslq %eax,%rcx
  802abc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac3:	48 98                	cltq   
  802ac5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802acc:	00 
  802acd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ad3:	49 89 c8             	mov    %rcx,%r8
  802ad6:	48 89 d1             	mov    %rdx,%rcx
  802ad9:	48 89 c2             	mov    %rax,%rdx
  802adc:	be 01 00 00 00       	mov    $0x1,%esi
  802ae1:	bf 04 00 00 00       	mov    $0x4,%edi
  802ae6:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
}
  802af2:	c9                   	leaveq 
  802af3:	c3                   	retq   

0000000000802af4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802af4:	55                   	push   %rbp
  802af5:	48 89 e5             	mov    %rsp,%rbp
  802af8:	48 83 ec 30          	sub    $0x30,%rsp
  802afc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802aff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b03:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802b06:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b0a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802b0e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b11:	48 63 c8             	movslq %eax,%rcx
  802b14:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802b18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b1b:	48 63 f0             	movslq %eax,%rsi
  802b1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b25:	48 98                	cltq   
  802b27:	48 89 0c 24          	mov    %rcx,(%rsp)
  802b2b:	49 89 f9             	mov    %rdi,%r9
  802b2e:	49 89 f0             	mov    %rsi,%r8
  802b31:	48 89 d1             	mov    %rdx,%rcx
  802b34:	48 89 c2             	mov    %rax,%rdx
  802b37:	be 01 00 00 00       	mov    $0x1,%esi
  802b3c:	bf 05 00 00 00       	mov    $0x5,%edi
  802b41:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802b48:	00 00 00 
  802b4b:	ff d0                	callq  *%rax
}
  802b4d:	c9                   	leaveq 
  802b4e:	c3                   	retq   

0000000000802b4f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802b4f:	55                   	push   %rbp
  802b50:	48 89 e5             	mov    %rsp,%rbp
  802b53:	48 83 ec 20          	sub    $0x20,%rsp
  802b57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802b5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b65:	48 98                	cltq   
  802b67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b6e:	00 
  802b6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b7b:	48 89 d1             	mov    %rdx,%rcx
  802b7e:	48 89 c2             	mov    %rax,%rdx
  802b81:	be 01 00 00 00       	mov    $0x1,%esi
  802b86:	bf 06 00 00 00       	mov    $0x6,%edi
  802b8b:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802b92:	00 00 00 
  802b95:	ff d0                	callq  *%rax
}
  802b97:	c9                   	leaveq 
  802b98:	c3                   	retq   

0000000000802b99 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802b99:	55                   	push   %rbp
  802b9a:	48 89 e5             	mov    %rsp,%rbp
  802b9d:	48 83 ec 20          	sub    $0x20,%rsp
  802ba1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ba4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802ba7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802baa:	48 63 d0             	movslq %eax,%rdx
  802bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb0:	48 98                	cltq   
  802bb2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bb9:	00 
  802bba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802bc6:	48 89 d1             	mov    %rdx,%rcx
  802bc9:	48 89 c2             	mov    %rax,%rdx
  802bcc:	be 01 00 00 00       	mov    $0x1,%esi
  802bd1:	bf 08 00 00 00       	mov    $0x8,%edi
  802bd6:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	callq  *%rax
}
  802be2:	c9                   	leaveq 
  802be3:	c3                   	retq   

0000000000802be4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802be4:	55                   	push   %rbp
  802be5:	48 89 e5             	mov    %rsp,%rbp
  802be8:	48 83 ec 20          	sub    $0x20,%rsp
  802bec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802bf3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfa:	48 98                	cltq   
  802bfc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c03:	00 
  802c04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c10:	48 89 d1             	mov    %rdx,%rcx
  802c13:	48 89 c2             	mov    %rax,%rdx
  802c16:	be 01 00 00 00       	mov    $0x1,%esi
  802c1b:	bf 09 00 00 00       	mov    $0x9,%edi
  802c20:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802c27:	00 00 00 
  802c2a:	ff d0                	callq  *%rax
}
  802c2c:	c9                   	leaveq 
  802c2d:	c3                   	retq   

0000000000802c2e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802c2e:	55                   	push   %rbp
  802c2f:	48 89 e5             	mov    %rsp,%rbp
  802c32:	48 83 ec 20          	sub    $0x20,%rsp
  802c36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802c3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c44:	48 98                	cltq   
  802c46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c4d:	00 
  802c4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c5a:	48 89 d1             	mov    %rdx,%rcx
  802c5d:	48 89 c2             	mov    %rax,%rdx
  802c60:	be 01 00 00 00       	mov    $0x1,%esi
  802c65:	bf 0a 00 00 00       	mov    $0xa,%edi
  802c6a:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802c71:	00 00 00 
  802c74:	ff d0                	callq  *%rax
}
  802c76:	c9                   	leaveq 
  802c77:	c3                   	retq   

0000000000802c78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802c78:	55                   	push   %rbp
  802c79:	48 89 e5             	mov    %rsp,%rbp
  802c7c:	48 83 ec 30          	sub    $0x30,%rsp
  802c80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c87:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c8b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802c8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c91:	48 63 f0             	movslq %eax,%rsi
  802c94:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9b:	48 98                	cltq   
  802c9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ca1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ca8:	00 
  802ca9:	49 89 f1             	mov    %rsi,%r9
  802cac:	49 89 c8             	mov    %rcx,%r8
  802caf:	48 89 d1             	mov    %rdx,%rcx
  802cb2:	48 89 c2             	mov    %rax,%rdx
  802cb5:	be 00 00 00 00       	mov    $0x0,%esi
  802cba:	bf 0c 00 00 00       	mov    $0xc,%edi
  802cbf:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	callq  *%rax
}
  802ccb:	c9                   	leaveq 
  802ccc:	c3                   	retq   

0000000000802ccd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802ccd:	55                   	push   %rbp
  802cce:	48 89 e5             	mov    %rsp,%rbp
  802cd1:	48 83 ec 20          	sub    $0x20,%rsp
  802cd5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802cd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cdd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ce4:	00 
  802ce5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ceb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  802cf6:	48 89 c2             	mov    %rax,%rdx
  802cf9:	be 01 00 00 00       	mov    $0x1,%esi
  802cfe:	bf 0d 00 00 00       	mov    $0xd,%edi
  802d03:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802d0a:	00 00 00 
  802d0d:	ff d0                	callq  *%rax
}
  802d0f:	c9                   	leaveq 
  802d10:	c3                   	retq   

0000000000802d11 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802d11:	55                   	push   %rbp
  802d12:	48 89 e5             	mov    %rsp,%rbp
  802d15:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802d19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d20:	00 
  802d21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d32:	ba 00 00 00 00       	mov    $0x0,%edx
  802d37:	be 00 00 00 00       	mov    $0x0,%esi
  802d3c:	bf 0e 00 00 00       	mov    $0xe,%edi
  802d41:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
}
  802d4d:	c9                   	leaveq 
  802d4e:	c3                   	retq   

0000000000802d4f <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  802d4f:	55                   	push   %rbp
  802d50:	48 89 e5             	mov    %rsp,%rbp
  802d53:	48 83 ec 20          	sub    $0x20,%rsp
  802d57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802d5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d6e:	00 
  802d6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d7b:	48 89 d1             	mov    %rdx,%rcx
  802d7e:	48 89 c2             	mov    %rax,%rdx
  802d81:	be 00 00 00 00       	mov    $0x0,%esi
  802d86:	bf 0f 00 00 00       	mov    $0xf,%edi
  802d8b:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
}
  802d97:	c9                   	leaveq 
  802d98:	c3                   	retq   

0000000000802d99 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802d99:	55                   	push   %rbp
  802d9a:	48 89 e5             	mov    %rsp,%rbp
  802d9d:	48 83 ec 20          	sub    $0x20,%rsp
  802da1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802da5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802da9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802db1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802db8:	00 
  802db9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802dbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802dc5:	48 89 d1             	mov    %rdx,%rcx
  802dc8:	48 89 c2             	mov    %rax,%rdx
  802dcb:	be 00 00 00 00       	mov    $0x0,%esi
  802dd0:	bf 10 00 00 00       	mov    $0x10,%edi
  802dd5:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  802ddc:	00 00 00 
  802ddf:	ff d0                	callq  *%rax
}
  802de1:	c9                   	leaveq 
  802de2:	c3                   	retq   
	...

0000000000802de4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802de4:	55                   	push   %rbp
  802de5:	48 89 e5             	mov    %rsp,%rbp
  802de8:	48 83 ec 30          	sub    $0x30,%rsp
  802dec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802df0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df4:	48 8b 00             	mov    (%rax),%rax
  802df7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802dfb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dff:	48 8b 40 08          	mov    0x8(%rax),%rax
  802e03:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  802e06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e09:	83 e0 02             	and    $0x2,%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 23                	je     802e33 <pgfault+0x4f>
  802e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e14:	48 89 c2             	mov    %rax,%rdx
  802e17:	48 c1 ea 0c          	shr    $0xc,%rdx
  802e1b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e22:	01 00 00 
  802e25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e29:	25 00 08 00 00       	and    $0x800,%eax
  802e2e:	48 85 c0             	test   %rax,%rax
  802e31:	75 2a                	jne    802e5d <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  802e33:	48 ba 60 6d 80 00 00 	movabs $0x806d60,%rdx
  802e3a:	00 00 00 
  802e3d:	be 1c 00 00 00       	mov    $0x1c,%esi
  802e42:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  802e49:	00 00 00 
  802e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e51:	48 b9 14 12 80 00 00 	movabs $0x801214,%rcx
  802e58:	00 00 00 
  802e5b:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  802e5d:	ba 07 00 00 00       	mov    $0x7,%edx
  802e62:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802e67:	bf 00 00 00 00       	mov    $0x0,%edi
  802e6c:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
  802e78:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802e7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e7f:	79 30                	jns    802eb1 <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  802e81:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e84:	89 c1                	mov    %eax,%ecx
  802e86:	48 ba a0 6d 80 00 00 	movabs $0x806da0,%rdx
  802e8d:	00 00 00 
  802e90:	be 26 00 00 00       	mov    $0x26,%esi
  802e95:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  802e9c:	00 00 00 
  802e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea4:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  802eab:	00 00 00 
  802eae:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  802eb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802ec3:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ec8:	48 89 c6             	mov    %rax,%rsi
  802ecb:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802ed0:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  802ed7:	00 00 00 
  802eda:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  802edc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  802ee4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ee8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802eee:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802ef4:	48 89 c1             	mov    %rax,%rcx
  802ef7:	ba 00 00 00 00       	mov    $0x0,%edx
  802efc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802f01:	bf 00 00 00 00       	mov    $0x0,%edi
  802f06:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
  802f12:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802f15:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802f19:	79 30                	jns    802f4b <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  802f1b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f1e:	89 c1                	mov    %eax,%ecx
  802f20:	48 ba c8 6d 80 00 00 	movabs $0x806dc8,%rdx
  802f27:	00 00 00 
  802f2a:	be 2b 00 00 00       	mov    $0x2b,%esi
  802f2f:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  802f36:	00 00 00 
  802f39:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3e:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  802f45:	00 00 00 
  802f48:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  802f4b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802f50:	bf 00 00 00 00       	mov    $0x0,%edi
  802f55:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
  802f61:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802f64:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802f68:	79 30                	jns    802f9a <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  802f6a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f6d:	89 c1                	mov    %eax,%ecx
  802f6f:	48 ba f0 6d 80 00 00 	movabs $0x806df0,%rdx
  802f76:	00 00 00 
  802f79:	be 2e 00 00 00       	mov    $0x2e,%esi
  802f7e:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  802f85:	00 00 00 
  802f88:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8d:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  802f94:	00 00 00 
  802f97:	41 ff d0             	callq  *%r8
	
}
  802f9a:	c9                   	leaveq 
  802f9b:	c3                   	retq   

0000000000802f9c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802f9c:	55                   	push   %rbp
  802f9d:	48 89 e5             	mov    %rsp,%rbp
  802fa0:	48 83 ec 30          	sub    $0x30,%rsp
  802fa4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fa7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  802faa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802fb1:	01 00 00 
  802fb4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802fb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  802fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc3:	25 07 0e 00 00       	and    $0xe07,%eax
  802fc8:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  802fcb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802fce:	48 c1 e0 0c          	shl    $0xc,%rax
  802fd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  802fd6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fd9:	25 00 04 00 00       	and    $0x400,%eax
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	74 5c                	je     80303e <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  802fe2:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802fe5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fe9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff0:	41 89 f0             	mov    %esi,%r8d
  802ff3:	48 89 c6             	mov    %rax,%rsi
  802ff6:	bf 00 00 00 00       	mov    $0x0,%edi
  802ffb:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  803002:	00 00 00 
  803005:	ff d0                	callq  *%rax
  803007:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  80300a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80300e:	0f 89 60 01 00 00    	jns    803174 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  803014:	48 ba 18 6e 80 00 00 	movabs $0x806e18,%rdx
  80301b:	00 00 00 
  80301e:	be 4d 00 00 00       	mov    $0x4d,%esi
  803023:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  80302a:	00 00 00 
  80302d:	b8 00 00 00 00       	mov    $0x0,%eax
  803032:	48 b9 14 12 80 00 00 	movabs $0x801214,%rcx
  803039:	00 00 00 
  80303c:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  80303e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803041:	83 e0 02             	and    $0x2,%eax
  803044:	85 c0                	test   %eax,%eax
  803046:	75 10                	jne    803058 <duppage+0xbc>
  803048:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80304b:	25 00 08 00 00       	and    $0x800,%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	0f 84 c4 00 00 00    	je     80311c <duppage+0x180>
	{
		perm |= PTE_COW;
  803058:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  80305f:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  803063:	8b 75 f4             	mov    -0xc(%rbp),%esi
  803066:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80306a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80306d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803071:	41 89 f0             	mov    %esi,%r8d
  803074:	48 89 c6             	mov    %rax,%rsi
  803077:	bf 00 00 00 00       	mov    $0x0,%edi
  80307c:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  803083:	00 00 00 
  803086:	ff d0                	callq  *%rax
  803088:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  80308b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80308f:	79 2a                	jns    8030bb <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  803091:	48 ba 48 6e 80 00 00 	movabs $0x806e48,%rdx
  803098:	00 00 00 
  80309b:	be 56 00 00 00       	mov    $0x56,%esi
  8030a0:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  8030a7:	00 00 00 
  8030aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8030af:	48 b9 14 12 80 00 00 	movabs $0x801214,%rcx
  8030b6:	00 00 00 
  8030b9:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  8030bb:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  8030be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c6:	41 89 c8             	mov    %ecx,%r8d
  8030c9:	48 89 d1             	mov    %rdx,%rcx
  8030cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8030d1:	48 89 c6             	mov    %rax,%rsi
  8030d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8030d9:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  8030e0:	00 00 00 
  8030e3:	ff d0                	callq  *%rax
  8030e5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8030e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8030ec:	0f 89 82 00 00 00    	jns    803174 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  8030f2:	48 ba 48 6e 80 00 00 	movabs $0x806e48,%rdx
  8030f9:	00 00 00 
  8030fc:	be 59 00 00 00       	mov    $0x59,%esi
  803101:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  803108:	00 00 00 
  80310b:	b8 00 00 00 00       	mov    $0x0,%eax
  803110:	48 b9 14 12 80 00 00 	movabs $0x801214,%rcx
  803117:	00 00 00 
  80311a:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  80311c:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80311f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803123:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312a:	41 89 f0             	mov    %esi,%r8d
  80312d:	48 89 c6             	mov    %rax,%rsi
  803130:	bf 00 00 00 00       	mov    $0x0,%edi
  803135:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  80313c:	00 00 00 
  80313f:	ff d0                	callq  *%rax
  803141:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  803144:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803148:	79 2a                	jns    803174 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  80314a:	48 ba 80 6e 80 00 00 	movabs $0x806e80,%rdx
  803151:	00 00 00 
  803154:	be 60 00 00 00       	mov    $0x60,%esi
  803159:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  803160:	00 00 00 
  803163:	b8 00 00 00 00       	mov    $0x0,%eax
  803168:	48 b9 14 12 80 00 00 	movabs $0x801214,%rcx
  80316f:	00 00 00 
  803172:	ff d1                	callq  *%rcx
	}
	return 0;
  803174:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803179:	c9                   	leaveq 
  80317a:	c3                   	retq   

000000000080317b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80317b:	55                   	push   %rbp
  80317c:	48 89 e5             	mov    %rsp,%rbp
  80317f:	53                   	push   %rbx
  803180:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  803184:	48 bf e4 2d 80 00 00 	movabs $0x802de4,%rdi
  80318b:	00 00 00 
  80318e:	48 b8 1c 62 80 00 00 	movabs $0x80621c,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80319a:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  8031a1:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8031a4:	cd 30                	int    $0x30
  8031a6:	89 c3                	mov    %eax,%ebx
  8031a8:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8031ab:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  8031ae:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  8031b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8031b5:	79 30                	jns    8031e7 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  8031b7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8031ba:	89 c1                	mov    %eax,%ecx
  8031bc:	48 ba a4 6e 80 00 00 	movabs $0x806ea4,%rdx
  8031c3:	00 00 00 
  8031c6:	be 7f 00 00 00       	mov    $0x7f,%esi
  8031cb:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  8031d2:	00 00 00 
  8031d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031da:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  8031e1:	00 00 00 
  8031e4:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  8031e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8031eb:	75 4c                	jne    803239 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  8031ed:	48 b8 28 2a 80 00 00 	movabs $0x802a28,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
  8031f9:	48 98                	cltq   
  8031fb:	48 89 c2             	mov    %rax,%rdx
  8031fe:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803204:	48 89 d0             	mov    %rdx,%rax
  803207:	48 c1 e0 03          	shl    $0x3,%rax
  80320b:	48 01 d0             	add    %rdx,%rax
  80320e:	48 c1 e0 05          	shl    $0x5,%rax
  803212:	48 89 c2             	mov    %rax,%rdx
  803215:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80321c:	00 00 00 
  80321f:	48 01 c2             	add    %rax,%rdx
  803222:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  803229:	00 00 00 
  80322c:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  80322f:	b8 00 00 00 00       	mov    $0x0,%eax
  803234:	e9 38 02 00 00       	jmpq   803471 <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  803239:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80323c:	ba 07 00 00 00       	mov    $0x7,%edx
  803241:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803246:	89 c7                	mov    %eax,%edi
  803248:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  80324f:	00 00 00 
  803252:	ff d0                	callq  *%rax
  803254:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  803257:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80325b:	79 30                	jns    80328d <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  80325d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  803260:	89 c1                	mov    %eax,%ecx
  803262:	48 ba b8 6e 80 00 00 	movabs $0x806eb8,%rdx
  803269:	00 00 00 
  80326c:	be 8b 00 00 00       	mov    $0x8b,%esi
  803271:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  803278:	00 00 00 
  80327b:	b8 00 00 00 00       	mov    $0x0,%eax
  803280:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  803287:	00 00 00 
  80328a:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  80328d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  803294:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  80329b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  8032a2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  8032a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8032b0:	e9 0a 01 00 00       	jmpq   8033bf <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  8032b5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8032bc:	01 00 00 
  8032bf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032c2:	48 63 d2             	movslq %edx,%rdx
  8032c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032c9:	83 e0 01             	and    $0x1,%eax
  8032cc:	84 c0                	test   %al,%al
  8032ce:	0f 84 e7 00 00 00    	je     8033bb <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  8032d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  8032db:	e9 cf 00 00 00       	jmpq   8033af <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  8032e0:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8032e7:	01 00 00 
  8032ea:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032ed:	48 63 d2             	movslq %edx,%rdx
  8032f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032f4:	83 e0 01             	and    $0x1,%eax
  8032f7:	84 c0                	test   %al,%al
  8032f9:	0f 84 a0 00 00 00    	je     80339f <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8032ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  803306:	e9 85 00 00 00       	jmpq   803390 <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  80330b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803312:	01 00 00 
  803315:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803318:	48 63 d2             	movslq %edx,%rdx
  80331b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80331f:	83 e0 01             	and    $0x1,%eax
  803322:	84 c0                	test   %al,%al
  803324:	74 56                	je     80337c <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  803326:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  80332d:	eb 42                	jmp    803371 <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  80332f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803336:	01 00 00 
  803339:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80333c:	48 63 d2             	movslq %edx,%rdx
  80333f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803343:	83 e0 01             	and    $0x1,%eax
  803346:	84 c0                	test   %al,%al
  803348:	74 1f                	je     803369 <fork+0x1ee>
  80334a:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  803351:	74 16                	je     803369 <fork+0x1ee>
									 duppage(envid,d1);
  803353:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803356:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803359:	89 d6                	mov    %edx,%esi
  80335b:	89 c7                	mov    %eax,%edi
  80335d:	48 b8 9c 2f 80 00 00 	movabs $0x802f9c,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  803369:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  80336d:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  803371:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  803378:	7e b5                	jle    80332f <fork+0x1b4>
  80337a:	eb 0c                	jmp    803388 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  80337c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80337f:	83 c0 01             	add    $0x1,%eax
  803382:	c1 e0 09             	shl    $0x9,%eax
  803385:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  803388:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  80338c:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  803390:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  803397:	0f 8e 6e ff ff ff    	jle    80330b <fork+0x190>
  80339d:	eb 0c                	jmp    8033ab <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  80339f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033a2:	83 c0 01             	add    $0x1,%eax
  8033a5:	c1 e0 09             	shl    $0x9,%eax
  8033a8:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  8033ab:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  8033af:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033b2:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  8033b5:	0f 8c 25 ff ff ff    	jl     8032e0 <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8033bb:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8033bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033c2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8033c5:	0f 8c ea fe ff ff    	jl     8032b5 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8033cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033ce:	48 be e0 62 80 00 00 	movabs $0x8062e0,%rsi
  8033d5:	00 00 00 
  8033d8:	89 c7                	mov    %eax,%edi
  8033da:	48 b8 2e 2c 80 00 00 	movabs $0x802c2e,%rax
  8033e1:	00 00 00 
  8033e4:	ff d0                	callq  *%rax
  8033e6:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8033e9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8033ed:	79 30                	jns    80341f <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  8033ef:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8033f2:	89 c1                	mov    %eax,%ecx
  8033f4:	48 ba d8 6e 80 00 00 	movabs $0x806ed8,%rdx
  8033fb:	00 00 00 
  8033fe:	be ad 00 00 00       	mov    $0xad,%esi
  803403:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  80340a:	00 00 00 
  80340d:	b8 00 00 00 00       	mov    $0x0,%eax
  803412:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  803419:	00 00 00 
  80341c:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  80341f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803422:	be 02 00 00 00       	mov    $0x2,%esi
  803427:	89 c7                	mov    %eax,%edi
  803429:	48 b8 99 2b 80 00 00 	movabs $0x802b99,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  803438:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80343c:	79 30                	jns    80346e <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  80343e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  803441:	89 c1                	mov    %eax,%ecx
  803443:	48 ba 08 6f 80 00 00 	movabs $0x806f08,%rdx
  80344a:	00 00 00 
  80344d:	be b0 00 00 00       	mov    $0xb0,%esi
  803452:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  803459:	00 00 00 
  80345c:	b8 00 00 00 00       	mov    $0x0,%eax
  803461:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  803468:	00 00 00 
  80346b:	41 ff d0             	callq  *%r8
	return envid;
  80346e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  803471:	48 83 c4 48          	add    $0x48,%rsp
  803475:	5b                   	pop    %rbx
  803476:	5d                   	pop    %rbp
  803477:	c3                   	retq   

0000000000803478 <sfork>:

// Challenge!
int
sfork(void)
{
  803478:	55                   	push   %rbp
  803479:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80347c:	48 ba 2c 6f 80 00 00 	movabs $0x806f2c,%rdx
  803483:	00 00 00 
  803486:	be b8 00 00 00       	mov    $0xb8,%esi
  80348b:	48 bf 95 6d 80 00 00 	movabs $0x806d95,%rdi
  803492:	00 00 00 
  803495:	b8 00 00 00 00       	mov    $0x0,%eax
  80349a:	48 b9 14 12 80 00 00 	movabs $0x801214,%rcx
  8034a1:	00 00 00 
  8034a4:	ff d1                	callq  *%rcx
	...

00000000008034a8 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8034a8:	55                   	push   %rbp
  8034a9:	48 89 e5             	mov    %rsp,%rbp
  8034ac:	48 83 ec 18          	sub    $0x18,%rsp
  8034b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  8034bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034c4:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8034c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034cf:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8034d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d7:	8b 00                	mov    (%rax),%eax
  8034d9:	83 f8 01             	cmp    $0x1,%eax
  8034dc:	7e 13                	jle    8034f1 <argstart+0x49>
  8034de:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8034e3:	74 0c                	je     8034f1 <argstart+0x49>
  8034e5:	48 b8 42 6f 80 00 00 	movabs $0x806f42,%rax
  8034ec:	00 00 00 
  8034ef:	eb 05                	jmp    8034f6 <argstart+0x4e>
  8034f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034fa:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8034fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803502:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803509:	00 
}
  80350a:	c9                   	leaveq 
  80350b:	c3                   	retq   

000000000080350c <argnext>:

int
argnext(struct Argstate *args)
{
  80350c:	55                   	push   %rbp
  80350d:	48 89 e5             	mov    %rsp,%rbp
  803510:	48 83 ec 20          	sub    $0x20,%rsp
  803514:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  803518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351c:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803523:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  803524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803528:	48 8b 40 10          	mov    0x10(%rax),%rax
  80352c:	48 85 c0             	test   %rax,%rax
  80352f:	75 0a                	jne    80353b <argnext+0x2f>
		return -1;
  803531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803536:	e9 24 01 00 00       	jmpq   80365f <argnext+0x153>

	if (!*args->curarg) {
  80353b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80353f:	48 8b 40 10          	mov    0x10(%rax),%rax
  803543:	0f b6 00             	movzbl (%rax),%eax
  803546:	84 c0                	test   %al,%al
  803548:	0f 85 d5 00 00 00    	jne    803623 <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80354e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803552:	48 8b 00             	mov    (%rax),%rax
  803555:	8b 00                	mov    (%rax),%eax
  803557:	83 f8 01             	cmp    $0x1,%eax
  80355a:	0f 84 ee 00 00 00    	je     80364e <argnext+0x142>
		    || args->argv[1][0] != '-'
  803560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803564:	48 8b 40 08          	mov    0x8(%rax),%rax
  803568:	48 83 c0 08          	add    $0x8,%rax
  80356c:	48 8b 00             	mov    (%rax),%rax
  80356f:	0f b6 00             	movzbl (%rax),%eax
  803572:	3c 2d                	cmp    $0x2d,%al
  803574:	0f 85 d4 00 00 00    	jne    80364e <argnext+0x142>
		    || args->argv[1][1] == '\0')
  80357a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803582:	48 83 c0 08          	add    $0x8,%rax
  803586:	48 8b 00             	mov    (%rax),%rax
  803589:	48 83 c0 01          	add    $0x1,%rax
  80358d:	0f b6 00             	movzbl (%rax),%eax
  803590:	84 c0                	test   %al,%al
  803592:	0f 84 b6 00 00 00    	je     80364e <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  803598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359c:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035a0:	48 83 c0 08          	add    $0x8,%rax
  8035a4:	48 8b 00             	mov    (%rax),%rax
  8035a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035af:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8035b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b7:	48 8b 00             	mov    (%rax),%rax
  8035ba:	8b 00                	mov    (%rax),%eax
  8035bc:	83 e8 01             	sub    $0x1,%eax
  8035bf:	48 98                	cltq   
  8035c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035c8:	00 
  8035c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035cd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035d1:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8035d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035dd:	48 83 c0 08          	add    $0x8,%rax
  8035e1:	48 89 ce             	mov    %rcx,%rsi
  8035e4:	48 89 c7             	mov    %rax,%rdi
  8035e7:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
		(*args->argc)--;
  8035f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f7:	48 8b 00             	mov    (%rax),%rax
  8035fa:	8b 10                	mov    (%rax),%edx
  8035fc:	83 ea 01             	sub    $0x1,%edx
  8035ff:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  803601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803605:	48 8b 40 10          	mov    0x10(%rax),%rax
  803609:	0f b6 00             	movzbl (%rax),%eax
  80360c:	3c 2d                	cmp    $0x2d,%al
  80360e:	75 13                	jne    803623 <argnext+0x117>
  803610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803614:	48 8b 40 10          	mov    0x10(%rax),%rax
  803618:	48 83 c0 01          	add    $0x1,%rax
  80361c:	0f b6 00             	movzbl (%rax),%eax
  80361f:	84 c0                	test   %al,%al
  803621:	74 2a                	je     80364d <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  803623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803627:	48 8b 40 10          	mov    0x10(%rax),%rax
  80362b:	0f b6 00             	movzbl (%rax),%eax
  80362e:	0f b6 c0             	movzbl %al,%eax
  803631:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  803634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803638:	48 8b 40 10          	mov    0x10(%rax),%rax
  80363c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803644:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  803648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364b:	eb 12                	jmp    80365f <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  80364d:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

    endofargs:
	args->curarg = 0;
  80364e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803652:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803659:	00 
	return -1;
  80365a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80365f:	c9                   	leaveq 
  803660:	c3                   	retq   

0000000000803661 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803661:	55                   	push   %rbp
  803662:	48 89 e5             	mov    %rsp,%rbp
  803665:	48 83 ec 10          	sub    $0x10,%rsp
  803669:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80366d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803671:	48 8b 40 18          	mov    0x18(%rax),%rax
  803675:	48 85 c0             	test   %rax,%rax
  803678:	74 0a                	je     803684 <argvalue+0x23>
  80367a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367e:	48 8b 40 18          	mov    0x18(%rax),%rax
  803682:	eb 13                	jmp    803697 <argvalue+0x36>
  803684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803688:	48 89 c7             	mov    %rax,%rdi
  80368b:	48 b8 99 36 80 00 00 	movabs $0x803699,%rax
  803692:	00 00 00 
  803695:	ff d0                	callq  *%rax
}
  803697:	c9                   	leaveq 
  803698:	c3                   	retq   

0000000000803699 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  803699:	55                   	push   %rbp
  80369a:	48 89 e5             	mov    %rsp,%rbp
  80369d:	48 83 ec 10          	sub    $0x10,%rsp
  8036a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  8036a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8036ad:	48 85 c0             	test   %rax,%rax
  8036b0:	75 0a                	jne    8036bc <argnextvalue+0x23>
		return 0;
  8036b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b7:	e9 c8 00 00 00       	jmpq   803784 <argnextvalue+0xeb>
	if (*args->curarg) {
  8036bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8036c4:	0f b6 00             	movzbl (%rax),%eax
  8036c7:	84 c0                	test   %al,%al
  8036c9:	74 27                	je     8036f2 <argnextvalue+0x59>
		args->argvalue = args->curarg;
  8036cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d7:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8036db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036df:	48 ba 42 6f 80 00 00 	movabs $0x806f42,%rdx
  8036e6:	00 00 00 
  8036e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8036ed:	e9 8a 00 00 00       	jmpq   80377c <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  8036f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f6:	48 8b 00             	mov    (%rax),%rax
  8036f9:	8b 00                	mov    (%rax),%eax
  8036fb:	83 f8 01             	cmp    $0x1,%eax
  8036fe:	7e 64                	jle    803764 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  803700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803704:	48 8b 40 08          	mov    0x8(%rax),%rax
  803708:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80370c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803710:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803714:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803718:	48 8b 00             	mov    (%rax),%rax
  80371b:	8b 00                	mov    (%rax),%eax
  80371d:	83 e8 01             	sub    $0x1,%eax
  803720:	48 98                	cltq   
  803722:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803729:	00 
  80372a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80372e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803732:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80373e:	48 83 c0 08          	add    $0x8,%rax
  803742:	48 89 ce             	mov    %rcx,%rsi
  803745:	48 89 c7             	mov    %rax,%rdi
  803748:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  80374f:	00 00 00 
  803752:	ff d0                	callq  *%rax
		(*args->argc)--;
  803754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803758:	48 8b 00             	mov    (%rax),%rax
  80375b:	8b 10                	mov    (%rax),%edx
  80375d:	83 ea 01             	sub    $0x1,%edx
  803760:	89 10                	mov    %edx,(%rax)
  803762:	eb 18                	jmp    80377c <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  803764:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803768:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80376f:	00 
		args->curarg = 0;
  803770:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803774:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80377b:	00 
	}
	return (char*) args->argvalue;
  80377c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803780:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803784:	c9                   	leaveq 
  803785:	c3                   	retq   
	...

0000000000803788 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  803788:	55                   	push   %rbp
  803789:	48 89 e5             	mov    %rsp,%rbp
  80378c:	48 83 ec 08          	sub    $0x8,%rsp
  803790:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  803794:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803798:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80379f:	ff ff ff 
  8037a2:	48 01 d0             	add    %rdx,%rax
  8037a5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8037a9:	c9                   	leaveq 
  8037aa:	c3                   	retq   

00000000008037ab <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8037ab:	55                   	push   %rbp
  8037ac:	48 89 e5             	mov    %rsp,%rbp
  8037af:	48 83 ec 08          	sub    $0x8,%rsp
  8037b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8037b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bb:	48 89 c7             	mov    %rax,%rdi
  8037be:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  8037c5:	00 00 00 
  8037c8:	ff d0                	callq  *%rax
  8037ca:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8037d0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8037d4:	c9                   	leaveq 
  8037d5:	c3                   	retq   

00000000008037d6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8037d6:	55                   	push   %rbp
  8037d7:	48 89 e5             	mov    %rsp,%rbp
  8037da:	48 83 ec 18          	sub    $0x18,%rsp
  8037de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8037e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037e9:	eb 6b                	jmp    803856 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8037eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ee:	48 98                	cltq   
  8037f0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8037f6:	48 c1 e0 0c          	shl    $0xc,%rax
  8037fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8037fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803802:	48 89 c2             	mov    %rax,%rdx
  803805:	48 c1 ea 15          	shr    $0x15,%rdx
  803809:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803810:	01 00 00 
  803813:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803817:	83 e0 01             	and    $0x1,%eax
  80381a:	48 85 c0             	test   %rax,%rax
  80381d:	74 21                	je     803840 <fd_alloc+0x6a>
  80381f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803823:	48 89 c2             	mov    %rax,%rdx
  803826:	48 c1 ea 0c          	shr    $0xc,%rdx
  80382a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803831:	01 00 00 
  803834:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803838:	83 e0 01             	and    $0x1,%eax
  80383b:	48 85 c0             	test   %rax,%rax
  80383e:	75 12                	jne    803852 <fd_alloc+0x7c>
			*fd_store = fd;
  803840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803844:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803848:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80384b:	b8 00 00 00 00       	mov    $0x0,%eax
  803850:	eb 1a                	jmp    80386c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803852:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803856:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80385a:	7e 8f                	jle    8037eb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80385c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803860:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803867:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80386c:	c9                   	leaveq 
  80386d:	c3                   	retq   

000000000080386e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80386e:	55                   	push   %rbp
  80386f:	48 89 e5             	mov    %rsp,%rbp
  803872:	48 83 ec 20          	sub    $0x20,%rsp
  803876:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803879:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80387d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803881:	78 06                	js     803889 <fd_lookup+0x1b>
  803883:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803887:	7e 07                	jle    803890 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803889:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80388e:	eb 6c                	jmp    8038fc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803890:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803893:	48 98                	cltq   
  803895:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80389b:	48 c1 e0 0c          	shl    $0xc,%rax
  80389f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8038a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a7:	48 89 c2             	mov    %rax,%rdx
  8038aa:	48 c1 ea 15          	shr    $0x15,%rdx
  8038ae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038b5:	01 00 00 
  8038b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038bc:	83 e0 01             	and    $0x1,%eax
  8038bf:	48 85 c0             	test   %rax,%rax
  8038c2:	74 21                	je     8038e5 <fd_lookup+0x77>
  8038c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c8:	48 89 c2             	mov    %rax,%rdx
  8038cb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8038cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038d6:	01 00 00 
  8038d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038dd:	83 e0 01             	and    $0x1,%eax
  8038e0:	48 85 c0             	test   %rax,%rax
  8038e3:	75 07                	jne    8038ec <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8038e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8038ea:	eb 10                	jmp    8038fc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8038ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038f4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8038f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038fc:	c9                   	leaveq 
  8038fd:	c3                   	retq   

00000000008038fe <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8038fe:	55                   	push   %rbp
  8038ff:	48 89 e5             	mov    %rsp,%rbp
  803902:	48 83 ec 30          	sub    $0x30,%rsp
  803906:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80390a:	89 f0                	mov    %esi,%eax
  80390c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80390f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803913:	48 89 c7             	mov    %rax,%rdi
  803916:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  80391d:	00 00 00 
  803920:	ff d0                	callq  *%rax
  803922:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803926:	48 89 d6             	mov    %rdx,%rsi
  803929:	89 c7                	mov    %eax,%edi
  80392b:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
  803937:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80393a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393e:	78 0a                	js     80394a <fd_close+0x4c>
	    || fd != fd2)
  803940:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803944:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803948:	74 12                	je     80395c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80394a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80394e:	74 05                	je     803955 <fd_close+0x57>
  803950:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803953:	eb 05                	jmp    80395a <fd_close+0x5c>
  803955:	b8 00 00 00 00       	mov    $0x0,%eax
  80395a:	eb 69                	jmp    8039c5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80395c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803960:	8b 00                	mov    (%rax),%eax
  803962:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803966:	48 89 d6             	mov    %rdx,%rsi
  803969:	89 c7                	mov    %eax,%edi
  80396b:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
  803977:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80397a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397e:	78 2a                	js     8039aa <fd_close+0xac>
		if (dev->dev_close)
  803980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803984:	48 8b 40 20          	mov    0x20(%rax),%rax
  803988:	48 85 c0             	test   %rax,%rax
  80398b:	74 16                	je     8039a3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80398d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803991:	48 8b 50 20          	mov    0x20(%rax),%rdx
  803995:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803999:	48 89 c7             	mov    %rax,%rdi
  80399c:	ff d2                	callq  *%rdx
  80399e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a1:	eb 07                	jmp    8039aa <fd_close+0xac>
		else
			r = 0;
  8039a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8039aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ae:	48 89 c6             	mov    %rax,%rsi
  8039b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b6:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
	return r;
  8039c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039c5:	c9                   	leaveq 
  8039c6:	c3                   	retq   

00000000008039c7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8039c7:	55                   	push   %rbp
  8039c8:	48 89 e5             	mov    %rsp,%rbp
  8039cb:	48 83 ec 20          	sub    $0x20,%rsp
  8039cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8039d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039dd:	eb 41                	jmp    803a20 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8039df:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8039e6:	00 00 00 
  8039e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ec:	48 63 d2             	movslq %edx,%rdx
  8039ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039f3:	8b 00                	mov    (%rax),%eax
  8039f5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8039f8:	75 22                	jne    803a1c <dev_lookup+0x55>
			*dev = devtab[i];
  8039fa:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803a01:	00 00 00 
  803a04:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a07:	48 63 d2             	movslq %edx,%rdx
  803a0a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803a0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a12:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803a15:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1a:	eb 60                	jmp    803a7c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803a1c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803a20:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803a27:	00 00 00 
  803a2a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a2d:	48 63 d2             	movslq %edx,%rdx
  803a30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a34:	48 85 c0             	test   %rax,%rax
  803a37:	75 a6                	jne    8039df <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803a39:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  803a40:	00 00 00 
  803a43:	48 8b 00             	mov    (%rax),%rax
  803a46:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a4c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a4f:	89 c6                	mov    %eax,%esi
  803a51:	48 bf 48 6f 80 00 00 	movabs $0x806f48,%rdi
  803a58:	00 00 00 
  803a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a60:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  803a67:	00 00 00 
  803a6a:	ff d1                	callq  *%rcx
	*dev = 0;
  803a6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a70:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803a77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803a7c:	c9                   	leaveq 
  803a7d:	c3                   	retq   

0000000000803a7e <close>:

int
close(int fdnum)
{
  803a7e:	55                   	push   %rbp
  803a7f:	48 89 e5             	mov    %rsp,%rbp
  803a82:	48 83 ec 20          	sub    $0x20,%rsp
  803a86:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a89:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a90:	48 89 d6             	mov    %rdx,%rsi
  803a93:	89 c7                	mov    %eax,%edi
  803a95:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803a9c:	00 00 00 
  803a9f:	ff d0                	callq  *%rax
  803aa1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aa8:	79 05                	jns    803aaf <close+0x31>
		return r;
  803aaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aad:	eb 18                	jmp    803ac7 <close+0x49>
	else
		return fd_close(fd, 1);
  803aaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab3:	be 01 00 00 00       	mov    $0x1,%esi
  803ab8:	48 89 c7             	mov    %rax,%rdi
  803abb:	48 b8 fe 38 80 00 00 	movabs $0x8038fe,%rax
  803ac2:	00 00 00 
  803ac5:	ff d0                	callq  *%rax
}
  803ac7:	c9                   	leaveq 
  803ac8:	c3                   	retq   

0000000000803ac9 <close_all>:

void
close_all(void)
{
  803ac9:	55                   	push   %rbp
  803aca:	48 89 e5             	mov    %rsp,%rbp
  803acd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803ad1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ad8:	eb 15                	jmp    803aef <close_all+0x26>
		close(i);
  803ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803add:	89 c7                	mov    %eax,%edi
  803adf:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  803ae6:	00 00 00 
  803ae9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803aeb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803aef:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803af3:	7e e5                	jle    803ada <close_all+0x11>
		close(i);
}
  803af5:	c9                   	leaveq 
  803af6:	c3                   	retq   

0000000000803af7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803af7:	55                   	push   %rbp
  803af8:	48 89 e5             	mov    %rsp,%rbp
  803afb:	48 83 ec 40          	sub    $0x40,%rsp
  803aff:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803b02:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803b05:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803b09:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803b0c:	48 89 d6             	mov    %rdx,%rsi
  803b0f:	89 c7                	mov    %eax,%edi
  803b11:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803b18:	00 00 00 
  803b1b:	ff d0                	callq  *%rax
  803b1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b24:	79 08                	jns    803b2e <dup+0x37>
		return r;
  803b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b29:	e9 70 01 00 00       	jmpq   803c9e <dup+0x1a7>
	close(newfdnum);
  803b2e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803b31:	89 c7                	mov    %eax,%edi
  803b33:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  803b3a:	00 00 00 
  803b3d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803b3f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803b42:	48 98                	cltq   
  803b44:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803b4a:	48 c1 e0 0c          	shl    $0xc,%rax
  803b4e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803b52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b56:	48 89 c7             	mov    %rax,%rdi
  803b59:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  803b60:	00 00 00 
  803b63:	ff d0                	callq  *%rax
  803b65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803b69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6d:	48 89 c7             	mov    %rax,%rdi
  803b70:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
  803b7c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803b80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b84:	48 89 c2             	mov    %rax,%rdx
  803b87:	48 c1 ea 15          	shr    $0x15,%rdx
  803b8b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b92:	01 00 00 
  803b95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b99:	83 e0 01             	and    $0x1,%eax
  803b9c:	84 c0                	test   %al,%al
  803b9e:	74 71                	je     803c11 <dup+0x11a>
  803ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba4:	48 89 c2             	mov    %rax,%rdx
  803ba7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803bab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bb2:	01 00 00 
  803bb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bb9:	83 e0 01             	and    $0x1,%eax
  803bbc:	84 c0                	test   %al,%al
  803bbe:	74 51                	je     803c11 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803bc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bc4:	48 89 c2             	mov    %rax,%rdx
  803bc7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803bcb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bd2:	01 00 00 
  803bd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bd9:	89 c1                	mov    %eax,%ecx
  803bdb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  803be1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803be5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803be9:	41 89 c8             	mov    %ecx,%r8d
  803bec:	48 89 d1             	mov    %rdx,%rcx
  803bef:	ba 00 00 00 00       	mov    $0x0,%edx
  803bf4:	48 89 c6             	mov    %rax,%rsi
  803bf7:	bf 00 00 00 00       	mov    $0x0,%edi
  803bfc:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  803c03:	00 00 00 
  803c06:	ff d0                	callq  *%rax
  803c08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0f:	78 56                	js     803c67 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803c11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c15:	48 89 c2             	mov    %rax,%rdx
  803c18:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c1c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c23:	01 00 00 
  803c26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c2a:	89 c1                	mov    %eax,%ecx
  803c2c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  803c32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c3a:	41 89 c8             	mov    %ecx,%r8d
  803c3d:	48 89 d1             	mov    %rdx,%rcx
  803c40:	ba 00 00 00 00       	mov    $0x0,%edx
  803c45:	48 89 c6             	mov    %rax,%rsi
  803c48:	bf 00 00 00 00       	mov    $0x0,%edi
  803c4d:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  803c54:	00 00 00 
  803c57:	ff d0                	callq  *%rax
  803c59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c60:	78 08                	js     803c6a <dup+0x173>
		goto err;

	return newfdnum;
  803c62:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803c65:	eb 37                	jmp    803c9e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  803c67:	90                   	nop
  803c68:	eb 01                	jmp    803c6b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  803c6a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803c6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c6f:	48 89 c6             	mov    %rax,%rsi
  803c72:	bf 00 00 00 00       	mov    $0x0,%edi
  803c77:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  803c7e:	00 00 00 
  803c81:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803c83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c87:	48 89 c6             	mov    %rax,%rsi
  803c8a:	bf 00 00 00 00       	mov    $0x0,%edi
  803c8f:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax
	return r;
  803c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c9e:	c9                   	leaveq 
  803c9f:	c3                   	retq   

0000000000803ca0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803ca0:	55                   	push   %rbp
  803ca1:	48 89 e5             	mov    %rsp,%rbp
  803ca4:	48 83 ec 40          	sub    $0x40,%rsp
  803ca8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803cab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803caf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803cb3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cb7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cba:	48 89 d6             	mov    %rdx,%rsi
  803cbd:	89 c7                	mov    %eax,%edi
  803cbf:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803cc6:	00 00 00 
  803cc9:	ff d0                	callq  *%rax
  803ccb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd2:	78 24                	js     803cf8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803cd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd8:	8b 00                	mov    (%rax),%eax
  803cda:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cde:	48 89 d6             	mov    %rdx,%rsi
  803ce1:	89 c7                	mov    %eax,%edi
  803ce3:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803cea:	00 00 00 
  803ced:	ff d0                	callq  *%rax
  803cef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf6:	79 05                	jns    803cfd <read+0x5d>
		return r;
  803cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cfb:	eb 7a                	jmp    803d77 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803cfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d01:	8b 40 08             	mov    0x8(%rax),%eax
  803d04:	83 e0 03             	and    $0x3,%eax
  803d07:	83 f8 01             	cmp    $0x1,%eax
  803d0a:	75 3a                	jne    803d46 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803d0c:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  803d13:	00 00 00 
  803d16:	48 8b 00             	mov    (%rax),%rax
  803d19:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d1f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d22:	89 c6                	mov    %eax,%esi
  803d24:	48 bf 67 6f 80 00 00 	movabs $0x806f67,%rdi
  803d2b:	00 00 00 
  803d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d33:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  803d3a:	00 00 00 
  803d3d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803d3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803d44:	eb 31                	jmp    803d77 <read+0xd7>
	}
	if (!dev->dev_read)
  803d46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d4a:	48 8b 40 10          	mov    0x10(%rax),%rax
  803d4e:	48 85 c0             	test   %rax,%rax
  803d51:	75 07                	jne    803d5a <read+0xba>
		return -E_NOT_SUPP;
  803d53:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803d58:	eb 1d                	jmp    803d77 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  803d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  803d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d66:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803d6a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803d6e:	48 89 ce             	mov    %rcx,%rsi
  803d71:	48 89 c7             	mov    %rax,%rdi
  803d74:	41 ff d0             	callq  *%r8
}
  803d77:	c9                   	leaveq 
  803d78:	c3                   	retq   

0000000000803d79 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803d79:	55                   	push   %rbp
  803d7a:	48 89 e5             	mov    %rsp,%rbp
  803d7d:	48 83 ec 30          	sub    $0x30,%rsp
  803d81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d88:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803d8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d93:	eb 46                	jmp    803ddb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d98:	48 98                	cltq   
  803d9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803d9e:	48 29 c2             	sub    %rax,%rdx
  803da1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da4:	48 98                	cltq   
  803da6:	48 89 c1             	mov    %rax,%rcx
  803da9:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  803dad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803db0:	48 89 ce             	mov    %rcx,%rsi
  803db3:	89 c7                	mov    %eax,%edi
  803db5:	48 b8 a0 3c 80 00 00 	movabs $0x803ca0,%rax
  803dbc:	00 00 00 
  803dbf:	ff d0                	callq  *%rax
  803dc1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803dc4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803dc8:	79 05                	jns    803dcf <readn+0x56>
			return m;
  803dca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dcd:	eb 1d                	jmp    803dec <readn+0x73>
		if (m == 0)
  803dcf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803dd3:	74 13                	je     803de8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803dd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dd8:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dde:	48 98                	cltq   
  803de0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803de4:	72 af                	jb     803d95 <readn+0x1c>
  803de6:	eb 01                	jmp    803de9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803de8:	90                   	nop
	}
	return tot;
  803de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dec:	c9                   	leaveq 
  803ded:	c3                   	retq   

0000000000803dee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803dee:	55                   	push   %rbp
  803def:	48 89 e5             	mov    %rsp,%rbp
  803df2:	48 83 ec 40          	sub    $0x40,%rsp
  803df6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803df9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dfd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803e01:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e05:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e08:	48 89 d6             	mov    %rdx,%rsi
  803e0b:	89 c7                	mov    %eax,%edi
  803e0d:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803e14:	00 00 00 
  803e17:	ff d0                	callq  *%rax
  803e19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e20:	78 24                	js     803e46 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e26:	8b 00                	mov    (%rax),%eax
  803e28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e2c:	48 89 d6             	mov    %rdx,%rsi
  803e2f:	89 c7                	mov    %eax,%edi
  803e31:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
  803e3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e44:	79 05                	jns    803e4b <write+0x5d>
		return r;
  803e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e49:	eb 79                	jmp    803ec4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e4f:	8b 40 08             	mov    0x8(%rax),%eax
  803e52:	83 e0 03             	and    $0x3,%eax
  803e55:	85 c0                	test   %eax,%eax
  803e57:	75 3a                	jne    803e93 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803e59:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  803e60:	00 00 00 
  803e63:	48 8b 00             	mov    (%rax),%rax
  803e66:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e6c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e6f:	89 c6                	mov    %eax,%esi
  803e71:	48 bf 83 6f 80 00 00 	movabs $0x806f83,%rdi
  803e78:	00 00 00 
  803e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e80:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  803e87:	00 00 00 
  803e8a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803e8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e91:	eb 31                	jmp    803ec4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e97:	48 8b 40 18          	mov    0x18(%rax),%rax
  803e9b:	48 85 c0             	test   %rax,%rax
  803e9e:	75 07                	jne    803ea7 <write+0xb9>
		return -E_NOT_SUPP;
  803ea0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803ea5:	eb 1d                	jmp    803ec4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  803ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eab:	4c 8b 40 18          	mov    0x18(%rax),%r8
  803eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eb3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803eb7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803ebb:	48 89 ce             	mov    %rcx,%rsi
  803ebe:	48 89 c7             	mov    %rax,%rdi
  803ec1:	41 ff d0             	callq  *%r8
}
  803ec4:	c9                   	leaveq 
  803ec5:	c3                   	retq   

0000000000803ec6 <seek>:

int
seek(int fdnum, off_t offset)
{
  803ec6:	55                   	push   %rbp
  803ec7:	48 89 e5             	mov    %rsp,%rbp
  803eca:	48 83 ec 18          	sub    $0x18,%rsp
  803ece:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ed1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ed4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ed8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803edb:	48 89 d6             	mov    %rdx,%rsi
  803ede:	89 c7                	mov    %eax,%edi
  803ee0:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803ee7:	00 00 00 
  803eea:	ff d0                	callq  *%rax
  803eec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef3:	79 05                	jns    803efa <seek+0x34>
		return r;
  803ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef8:	eb 0f                	jmp    803f09 <seek+0x43>
	fd->fd_offset = offset;
  803efa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803efe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f01:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f09:	c9                   	leaveq 
  803f0a:	c3                   	retq   

0000000000803f0b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803f0b:	55                   	push   %rbp
  803f0c:	48 89 e5             	mov    %rsp,%rbp
  803f0f:	48 83 ec 30          	sub    $0x30,%rsp
  803f13:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803f16:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803f19:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f1d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f20:	48 89 d6             	mov    %rdx,%rsi
  803f23:	89 c7                	mov    %eax,%edi
  803f25:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803f2c:	00 00 00 
  803f2f:	ff d0                	callq  *%rax
  803f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f38:	78 24                	js     803f5e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f3e:	8b 00                	mov    (%rax),%eax
  803f40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f44:	48 89 d6             	mov    %rdx,%rsi
  803f47:	89 c7                	mov    %eax,%edi
  803f49:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803f50:	00 00 00 
  803f53:	ff d0                	callq  *%rax
  803f55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f5c:	79 05                	jns    803f63 <ftruncate+0x58>
		return r;
  803f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f61:	eb 72                	jmp    803fd5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f67:	8b 40 08             	mov    0x8(%rax),%eax
  803f6a:	83 e0 03             	and    $0x3,%eax
  803f6d:	85 c0                	test   %eax,%eax
  803f6f:	75 3a                	jne    803fab <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803f71:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  803f78:	00 00 00 
  803f7b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803f7e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f84:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f87:	89 c6                	mov    %eax,%esi
  803f89:	48 bf a0 6f 80 00 00 	movabs $0x806fa0,%rdi
  803f90:	00 00 00 
  803f93:	b8 00 00 00 00       	mov    $0x0,%eax
  803f98:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  803f9f:	00 00 00 
  803fa2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803fa4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803fa9:	eb 2a                	jmp    803fd5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803faf:	48 8b 40 30          	mov    0x30(%rax),%rax
  803fb3:	48 85 c0             	test   %rax,%rax
  803fb6:	75 07                	jne    803fbf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803fb8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803fbd:	eb 16                	jmp    803fd5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  803fc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fcb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803fce:	89 d6                	mov    %edx,%esi
  803fd0:	48 89 c7             	mov    %rax,%rdi
  803fd3:	ff d1                	callq  *%rcx
}
  803fd5:	c9                   	leaveq 
  803fd6:	c3                   	retq   

0000000000803fd7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803fd7:	55                   	push   %rbp
  803fd8:	48 89 e5             	mov    %rsp,%rbp
  803fdb:	48 83 ec 30          	sub    $0x30,%rsp
  803fdf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803fe2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803fe6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fed:	48 89 d6             	mov    %rdx,%rsi
  803ff0:	89 c7                	mov    %eax,%edi
  803ff2:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803ff9:	00 00 00 
  803ffc:	ff d0                	callq  *%rax
  803ffe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804001:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804005:	78 24                	js     80402b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  804007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80400b:	8b 00                	mov    (%rax),%eax
  80400d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804011:	48 89 d6             	mov    %rdx,%rsi
  804014:	89 c7                	mov    %eax,%edi
  804016:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  80401d:	00 00 00 
  804020:	ff d0                	callq  *%rax
  804022:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804025:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804029:	79 05                	jns    804030 <fstat+0x59>
		return r;
  80402b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402e:	eb 5e                	jmp    80408e <fstat+0xb7>
	if (!dev->dev_stat)
  804030:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804034:	48 8b 40 28          	mov    0x28(%rax),%rax
  804038:	48 85 c0             	test   %rax,%rax
  80403b:	75 07                	jne    804044 <fstat+0x6d>
		return -E_NOT_SUPP;
  80403d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804042:	eb 4a                	jmp    80408e <fstat+0xb7>
	stat->st_name[0] = 0;
  804044:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804048:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80404b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80404f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  804056:	00 00 00 
	stat->st_isdir = 0;
  804059:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80405d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804064:	00 00 00 
	stat->st_dev = dev;
  804067:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80406b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80406f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  804076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80407a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80407e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804082:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804086:	48 89 d6             	mov    %rdx,%rsi
  804089:	48 89 c7             	mov    %rax,%rdi
  80408c:	ff d1                	callq  *%rcx
}
  80408e:	c9                   	leaveq 
  80408f:	c3                   	retq   

0000000000804090 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  804090:	55                   	push   %rbp
  804091:	48 89 e5             	mov    %rsp,%rbp
  804094:	48 83 ec 20          	sub    $0x20,%rsp
  804098:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80409c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8040a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a4:	be 00 00 00 00       	mov    $0x0,%esi
  8040a9:	48 89 c7             	mov    %rax,%rdi
  8040ac:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  8040b3:	00 00 00 
  8040b6:	ff d0                	callq  *%rax
  8040b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040bf:	79 05                	jns    8040c6 <stat+0x36>
		return fd;
  8040c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c4:	eb 2f                	jmp    8040f5 <stat+0x65>
	r = fstat(fd, stat);
  8040c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040cd:	48 89 d6             	mov    %rdx,%rsi
  8040d0:	89 c7                	mov    %eax,%edi
  8040d2:	48 b8 d7 3f 80 00 00 	movabs $0x803fd7,%rax
  8040d9:	00 00 00 
  8040dc:	ff d0                	callq  *%rax
  8040de:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8040e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040e4:	89 c7                	mov    %eax,%edi
  8040e6:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
	return r;
  8040f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8040f5:	c9                   	leaveq 
  8040f6:	c3                   	retq   
	...

00000000008040f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8040f8:	55                   	push   %rbp
  8040f9:	48 89 e5             	mov    %rsp,%rbp
  8040fc:	48 83 ec 10          	sub    $0x10,%rsp
  804100:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804103:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  804107:	48 b8 50 a4 80 00 00 	movabs $0x80a450,%rax
  80410e:	00 00 00 
  804111:	8b 00                	mov    (%rax),%eax
  804113:	85 c0                	test   %eax,%eax
  804115:	75 1d                	jne    804134 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  804117:	bf 01 00 00 00       	mov    $0x1,%edi
  80411c:	48 b8 ef 64 80 00 00 	movabs $0x8064ef,%rax
  804123:	00 00 00 
  804126:	ff d0                	callq  *%rax
  804128:	48 ba 50 a4 80 00 00 	movabs $0x80a450,%rdx
  80412f:	00 00 00 
  804132:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  804134:	48 b8 50 a4 80 00 00 	movabs $0x80a450,%rax
  80413b:	00 00 00 
  80413e:	8b 00                	mov    (%rax),%eax
  804140:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804143:	b9 07 00 00 00       	mov    $0x7,%ecx
  804148:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80414f:	00 00 00 
  804152:	89 c7                	mov    %eax,%edi
  804154:	48 b8 2c 64 80 00 00 	movabs $0x80642c,%rax
  80415b:	00 00 00 
  80415e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  804160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804164:	ba 00 00 00 00       	mov    $0x0,%edx
  804169:	48 89 c6             	mov    %rax,%rsi
  80416c:	bf 00 00 00 00       	mov    $0x0,%edi
  804171:	48 b8 6c 63 80 00 00 	movabs $0x80636c,%rax
  804178:	00 00 00 
  80417b:	ff d0                	callq  *%rax
}
  80417d:	c9                   	leaveq 
  80417e:	c3                   	retq   

000000000080417f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80417f:	55                   	push   %rbp
  804180:	48 89 e5             	mov    %rsp,%rbp
  804183:	48 83 ec 20          	sub    $0x20,%rsp
  804187:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80418b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80418e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804192:	48 89 c7             	mov    %rax,%rdi
  804195:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  80419c:	00 00 00 
  80419f:	ff d0                	callq  *%rax
  8041a1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8041a6:	7e 0a                	jle    8041b2 <open+0x33>
                return -E_BAD_PATH;
  8041a8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8041ad:	e9 a5 00 00 00       	jmpq   804257 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8041b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8041b6:	48 89 c7             	mov    %rax,%rdi
  8041b9:	48 b8 d6 37 80 00 00 	movabs $0x8037d6,%rax
  8041c0:	00 00 00 
  8041c3:	ff d0                	callq  *%rax
  8041c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041cc:	79 08                	jns    8041d6 <open+0x57>
		return r;
  8041ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d1:	e9 81 00 00 00       	jmpq   804257 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8041d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041da:	48 89 c6             	mov    %rax,%rsi
  8041dd:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  8041e4:	00 00 00 
  8041e7:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8041ee:	00 00 00 
  8041f1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8041f3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041fa:	00 00 00 
  8041fd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804200:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  804206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80420a:	48 89 c6             	mov    %rax,%rsi
  80420d:	bf 01 00 00 00       	mov    $0x1,%edi
  804212:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  804219:	00 00 00 
  80421c:	ff d0                	callq  *%rax
  80421e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  804221:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804225:	79 1d                	jns    804244 <open+0xc5>
	{
		fd_close(fd,0);
  804227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80422b:	be 00 00 00 00       	mov    $0x0,%esi
  804230:	48 89 c7             	mov    %rax,%rdi
  804233:	48 b8 fe 38 80 00 00 	movabs $0x8038fe,%rax
  80423a:	00 00 00 
  80423d:	ff d0                	callq  *%rax
		return r;
  80423f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804242:	eb 13                	jmp    804257 <open+0xd8>
	}
	return fd2num(fd);
  804244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804248:	48 89 c7             	mov    %rax,%rdi
  80424b:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  804252:	00 00 00 
  804255:	ff d0                	callq  *%rax
	


}
  804257:	c9                   	leaveq 
  804258:	c3                   	retq   

0000000000804259 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  804259:	55                   	push   %rbp
  80425a:	48 89 e5             	mov    %rsp,%rbp
  80425d:	48 83 ec 10          	sub    $0x10,%rsp
  804261:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  804265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804269:	8b 50 0c             	mov    0xc(%rax),%edx
  80426c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804273:	00 00 00 
  804276:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  804278:	be 00 00 00 00       	mov    $0x0,%esi
  80427d:	bf 06 00 00 00       	mov    $0x6,%edi
  804282:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  804289:	00 00 00 
  80428c:	ff d0                	callq  *%rax
}
  80428e:	c9                   	leaveq 
  80428f:	c3                   	retq   

0000000000804290 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  804290:	55                   	push   %rbp
  804291:	48 89 e5             	mov    %rsp,%rbp
  804294:	48 83 ec 30          	sub    $0x30,%rsp
  804298:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80429c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8042a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8042ab:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042b2:	00 00 00 
  8042b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8042b7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042be:	00 00 00 
  8042c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8042c5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8042c9:	be 00 00 00 00       	mov    $0x0,%esi
  8042ce:	bf 03 00 00 00       	mov    $0x3,%edi
  8042d3:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  8042da:	00 00 00 
  8042dd:	ff d0                	callq  *%rax
  8042df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042e6:	79 05                	jns    8042ed <devfile_read+0x5d>
	{
		return r;
  8042e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042eb:	eb 2c                	jmp    804319 <devfile_read+0x89>
	}
	if(r > 0)
  8042ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042f1:	7e 23                	jle    804316 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8042f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f6:	48 63 d0             	movslq %eax,%rdx
  8042f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042fd:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804304:	00 00 00 
  804307:	48 89 c7             	mov    %rax,%rdi
  80430a:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  804311:	00 00 00 
  804314:	ff d0                	callq  *%rax
	return r;
  804316:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  804319:	c9                   	leaveq 
  80431a:	c3                   	retq   

000000000080431b <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80431b:	55                   	push   %rbp
  80431c:	48 89 e5             	mov    %rsp,%rbp
  80431f:	48 83 ec 30          	sub    $0x30,%rsp
  804323:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804327:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80432b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80432f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804333:	8b 50 0c             	mov    0xc(%rax),%edx
  804336:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80433d:	00 00 00 
  804340:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  804342:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  804349:	00 
  80434a:	76 08                	jbe    804354 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  80434c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  804353:	00 
	fsipcbuf.write.req_n=n;
  804354:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80435b:	00 00 00 
  80435e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804362:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  804366:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80436a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80436e:	48 89 c6             	mov    %rax,%rsi
  804371:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  804378:	00 00 00 
  80437b:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  804382:	00 00 00 
  804385:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  804387:	be 00 00 00 00       	mov    $0x0,%esi
  80438c:	bf 04 00 00 00       	mov    $0x4,%edi
  804391:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  804398:	00 00 00 
  80439b:	ff d0                	callq  *%rax
  80439d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8043a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8043a3:	c9                   	leaveq 
  8043a4:	c3                   	retq   

00000000008043a5 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8043a5:	55                   	push   %rbp
  8043a6:	48 89 e5             	mov    %rsp,%rbp
  8043a9:	48 83 ec 10          	sub    $0x10,%rsp
  8043ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043b1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8043b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b8:	8b 50 0c             	mov    0xc(%rax),%edx
  8043bb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043c2:	00 00 00 
  8043c5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8043c7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043ce:	00 00 00 
  8043d1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8043d4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8043d7:	be 00 00 00 00       	mov    $0x0,%esi
  8043dc:	bf 02 00 00 00       	mov    $0x2,%edi
  8043e1:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  8043e8:	00 00 00 
  8043eb:	ff d0                	callq  *%rax
}
  8043ed:	c9                   	leaveq 
  8043ee:	c3                   	retq   

00000000008043ef <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8043ef:	55                   	push   %rbp
  8043f0:	48 89 e5             	mov    %rsp,%rbp
  8043f3:	48 83 ec 20          	sub    $0x20,%rsp
  8043f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8043ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804403:	8b 50 0c             	mov    0xc(%rax),%edx
  804406:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80440d:	00 00 00 
  804410:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  804412:	be 00 00 00 00       	mov    $0x0,%esi
  804417:	bf 05 00 00 00       	mov    $0x5,%edi
  80441c:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  804423:	00 00 00 
  804426:	ff d0                	callq  *%rax
  804428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80442b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80442f:	79 05                	jns    804436 <devfile_stat+0x47>
		return r;
  804431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804434:	eb 56                	jmp    80448c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  804436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80443a:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804441:	00 00 00 
  804444:	48 89 c7             	mov    %rax,%rdi
  804447:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  80444e:	00 00 00 
  804451:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  804453:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80445a:	00 00 00 
  80445d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  804463:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804467:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80446d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804474:	00 00 00 
  804477:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80447d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804481:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  804487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80448c:	c9                   	leaveq 
  80448d:	c3                   	retq   
	...

0000000000804490 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  804490:	55                   	push   %rbp
  804491:	48 89 e5             	mov    %rsp,%rbp
  804494:	48 83 ec 20          	sub    $0x20,%rsp
  804498:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80449c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044a0:	8b 40 0c             	mov    0xc(%rax),%eax
  8044a3:	85 c0                	test   %eax,%eax
  8044a5:	7e 67                	jle    80450e <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8044a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ab:	8b 40 04             	mov    0x4(%rax),%eax
  8044ae:	48 63 d0             	movslq %eax,%rdx
  8044b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b5:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8044b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044bd:	8b 00                	mov    (%rax),%eax
  8044bf:	48 89 ce             	mov    %rcx,%rsi
  8044c2:	89 c7                	mov    %eax,%edi
  8044c4:	48 b8 ee 3d 80 00 00 	movabs $0x803dee,%rax
  8044cb:	00 00 00 
  8044ce:	ff d0                	callq  *%rax
  8044d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8044d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044d7:	7e 13                	jle    8044ec <writebuf+0x5c>
			b->result += result;
  8044d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044dd:	8b 40 08             	mov    0x8(%rax),%eax
  8044e0:	89 c2                	mov    %eax,%edx
  8044e2:	03 55 fc             	add    -0x4(%rbp),%edx
  8044e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044e9:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8044ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044f0:	8b 40 04             	mov    0x4(%rax),%eax
  8044f3:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8044f6:	74 16                	je     80450e <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8044f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8044fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804501:	89 c2                	mov    %eax,%edx
  804503:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  804507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80450b:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80450e:	c9                   	leaveq 
  80450f:	c3                   	retq   

0000000000804510 <putch>:

static void
putch(int ch, void *thunk)
{
  804510:	55                   	push   %rbp
  804511:	48 89 e5             	mov    %rsp,%rbp
  804514:	48 83 ec 20          	sub    $0x20,%rsp
  804518:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80451b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80451f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804523:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  804527:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80452b:	8b 40 04             	mov    0x4(%rax),%eax
  80452e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804531:	89 d6                	mov    %edx,%esi
  804533:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804537:	48 63 d0             	movslq %eax,%rdx
  80453a:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  80453f:	8d 50 01             	lea    0x1(%rax),%edx
  804542:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804546:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  804549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80454d:	8b 40 04             	mov    0x4(%rax),%eax
  804550:	3d 00 01 00 00       	cmp    $0x100,%eax
  804555:	75 1e                	jne    804575 <putch+0x65>
		writebuf(b);
  804557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80455b:	48 89 c7             	mov    %rax,%rdi
  80455e:	48 b8 90 44 80 00 00 	movabs $0x804490,%rax
  804565:	00 00 00 
  804568:	ff d0                	callq  *%rax
		b->idx = 0;
  80456a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80456e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  804575:	c9                   	leaveq 
  804576:	c3                   	retq   

0000000000804577 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  804577:	55                   	push   %rbp
  804578:	48 89 e5             	mov    %rsp,%rbp
  80457b:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804582:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  804588:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80458f:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  804596:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80459c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8045a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8045a9:	00 00 00 
	b.result = 0;
  8045ac:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8045b3:	00 00 00 
	b.error = 1;
  8045b6:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8045bd:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8045c0:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8045c7:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8045ce:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8045d5:	48 89 c6             	mov    %rax,%rsi
  8045d8:	48 bf 10 45 80 00 00 	movabs $0x804510,%rdi
  8045df:	00 00 00 
  8045e2:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  8045e9:	00 00 00 
  8045ec:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8045ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8045f4:	85 c0                	test   %eax,%eax
  8045f6:	7e 16                	jle    80460e <vfprintf+0x97>
		writebuf(&b);
  8045f8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8045ff:	48 89 c7             	mov    %rax,%rdi
  804602:	48 b8 90 44 80 00 00 	movabs $0x804490,%rax
  804609:	00 00 00 
  80460c:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80460e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804614:	85 c0                	test   %eax,%eax
  804616:	74 08                	je     804620 <vfprintf+0xa9>
  804618:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80461e:	eb 06                	jmp    804626 <vfprintf+0xaf>
  804620:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  804626:	c9                   	leaveq 
  804627:	c3                   	retq   

0000000000804628 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  804628:	55                   	push   %rbp
  804629:	48 89 e5             	mov    %rsp,%rbp
  80462c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804633:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  804639:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804640:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804647:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80464e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804655:	84 c0                	test   %al,%al
  804657:	74 20                	je     804679 <fprintf+0x51>
  804659:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80465d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804661:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804665:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804669:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80466d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804671:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804675:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804679:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804680:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  804687:	00 00 00 
  80468a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804691:	00 00 00 
  804694:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804698:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80469f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8046a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8046ad:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8046b4:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8046bb:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8046c1:	48 89 ce             	mov    %rcx,%rsi
  8046c4:	89 c7                	mov    %eax,%edi
  8046c6:	48 b8 77 45 80 00 00 	movabs $0x804577,%rax
  8046cd:	00 00 00 
  8046d0:	ff d0                	callq  *%rax
  8046d2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8046d8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8046de:	c9                   	leaveq 
  8046df:	c3                   	retq   

00000000008046e0 <printf>:

int
printf(const char *fmt, ...)
{
  8046e0:	55                   	push   %rbp
  8046e1:	48 89 e5             	mov    %rsp,%rbp
  8046e4:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8046eb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8046f2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8046f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804700:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804707:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80470e:	84 c0                	test   %al,%al
  804710:	74 20                	je     804732 <printf+0x52>
  804712:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804716:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80471a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80471e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804722:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804726:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80472a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80472e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804732:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804739:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804740:	00 00 00 
  804743:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80474a:	00 00 00 
  80474d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804751:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804758:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80475f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  804766:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80476d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804774:	48 89 c6             	mov    %rax,%rsi
  804777:	bf 01 00 00 00       	mov    $0x1,%edi
  80477c:	48 b8 77 45 80 00 00 	movabs $0x804577,%rax
  804783:	00 00 00 
  804786:	ff d0                	callq  *%rax
  804788:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80478e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804794:	c9                   	leaveq 
  804795:	c3                   	retq   
	...

0000000000804798 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804798:	55                   	push   %rbp
  804799:	48 89 e5             	mov    %rsp,%rbp
  80479c:	53                   	push   %rbx
  80479d:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  8047a4:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  8047ab:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8047b2:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  8047b9:	be 00 00 00 00       	mov    $0x0,%esi
  8047be:	48 89 c7             	mov    %rax,%rdi
  8047c1:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  8047c8:	00 00 00 
  8047cb:	ff d0                	callq  *%rax
  8047cd:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8047d0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8047d4:	79 08                	jns    8047de <spawn+0x46>
		return r;
  8047d6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8047d9:	e9 1d 03 00 00       	jmpq   804afb <spawn+0x363>
	fd = r;
  8047de:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8047e1:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8047e4:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  8047eb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8047ef:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  8047f6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8047f9:	ba 00 02 00 00       	mov    $0x200,%edx
  8047fe:	48 89 ce             	mov    %rcx,%rsi
  804801:	89 c7                	mov    %eax,%edi
  804803:	48 b8 79 3d 80 00 00 	movabs $0x803d79,%rax
  80480a:	00 00 00 
  80480d:	ff d0                	callq  *%rax
  80480f:	3d 00 02 00 00       	cmp    $0x200,%eax
  804814:	75 0d                	jne    804823 <spawn+0x8b>
	    || elf->e_magic != ELF_MAGIC) {
  804816:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80481a:	8b 00                	mov    (%rax),%eax
  80481c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804821:	74 43                	je     804866 <spawn+0xce>
		close(fd);
  804823:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804826:	89 c7                	mov    %eax,%edi
  804828:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  80482f:	00 00 00 
  804832:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804834:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804838:	8b 00                	mov    (%rax),%eax
  80483a:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80483f:	89 c6                	mov    %eax,%esi
  804841:	48 bf c8 6f 80 00 00 	movabs $0x806fc8,%rdi
  804848:	00 00 00 
  80484b:	b8 00 00 00 00       	mov    $0x0,%eax
  804850:	48 b9 4f 14 80 00 00 	movabs $0x80144f,%rcx
  804857:	00 00 00 
  80485a:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80485c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804861:	e9 95 02 00 00       	jmpq   804afb <spawn+0x363>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804866:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  80486d:	00 00 00 
  804870:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  804876:	cd 30                	int    $0x30
  804878:	89 c3                	mov    %eax,%ebx
  80487a:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80487d:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804880:	89 45 d8             	mov    %eax,-0x28(%rbp)
  804883:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804887:	79 08                	jns    804891 <spawn+0xf9>
		return r;
  804889:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80488c:	e9 6a 02 00 00       	jmpq   804afb <spawn+0x363>
	child = r;
  804891:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804894:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804897:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80489a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80489f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048a6:	00 00 00 
  8048a9:	48 63 d0             	movslq %eax,%rdx
  8048ac:	48 89 d0             	mov    %rdx,%rax
  8048af:	48 c1 e0 03          	shl    $0x3,%rax
  8048b3:	48 01 d0             	add    %rdx,%rax
  8048b6:	48 c1 e0 05          	shl    $0x5,%rax
  8048ba:	48 01 c8             	add    %rcx,%rax
  8048bd:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  8048c4:	48 89 c6             	mov    %rax,%rsi
  8048c7:	b8 18 00 00 00       	mov    $0x18,%eax
  8048cc:	48 89 d7             	mov    %rdx,%rdi
  8048cf:	48 89 c1             	mov    %rax,%rcx
  8048d2:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8048d5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8048d9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8048dd:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8048e4:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  8048eb:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8048f2:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  8048f9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8048fc:	48 89 ce             	mov    %rcx,%rsi
  8048ff:	89 c7                	mov    %eax,%edi
  804901:	48 b8 53 4d 80 00 00 	movabs $0x804d53,%rax
  804908:	00 00 00 
  80490b:	ff d0                	callq  *%rax
  80490d:	89 45 d8             	mov    %eax,-0x28(%rbp)
  804910:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804914:	79 08                	jns    80491e <spawn+0x186>
		return r;
  804916:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804919:	e9 dd 01 00 00       	jmpq   804afb <spawn+0x363>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80491e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804922:	48 8b 40 20          	mov    0x20(%rax),%rax
  804926:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  80492d:	48 01 d0             	add    %rdx,%rax
  804930:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804934:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80493b:	eb 7a                	jmp    8049b7 <spawn+0x21f>
		if (ph->p_type != ELF_PROG_LOAD)
  80493d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804941:	8b 00                	mov    (%rax),%eax
  804943:	83 f8 01             	cmp    $0x1,%eax
  804946:	75 65                	jne    8049ad <spawn+0x215>
			continue;
		perm = PTE_P | PTE_U;
  804948:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80494f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804953:	8b 40 04             	mov    0x4(%rax),%eax
  804956:	83 e0 02             	and    $0x2,%eax
  804959:	85 c0                	test   %eax,%eax
  80495b:	74 04                	je     804961 <spawn+0x1c9>
			perm |= PTE_W;
  80495d:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804961:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804965:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804969:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80496c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804970:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804974:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804978:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80497c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804980:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804984:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  804987:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80498a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80498d:	89 3c 24             	mov    %edi,(%rsp)
  804990:	89 c7                	mov    %eax,%edi
  804992:	48 b8 c3 4f 80 00 00 	movabs $0x804fc3,%rax
  804999:	00 00 00 
  80499c:	ff d0                	callq  *%rax
  80499e:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8049a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8049a5:	0f 88 2a 01 00 00    	js     804ad5 <spawn+0x33d>
  8049ab:	eb 01                	jmp    8049ae <spawn+0x216>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  8049ad:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8049ae:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8049b2:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  8049b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8049bb:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8049bf:	0f b7 c0             	movzwl %ax,%eax
  8049c2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8049c5:	0f 8f 72 ff ff ff    	jg     80493d <spawn+0x1a5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8049cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8049ce:	89 c7                	mov    %eax,%edi
  8049d0:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  8049d7:	00 00 00 
  8049da:	ff d0                	callq  *%rax
	fd = -1;
  8049dc:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8049e3:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8049e6:	89 c7                	mov    %eax,%edi
  8049e8:	48 b8 aa 51 80 00 00 	movabs $0x8051aa,%rax
  8049ef:	00 00 00 
  8049f2:	ff d0                	callq  *%rax
  8049f4:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8049f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8049fb:	79 30                	jns    804a2d <spawn+0x295>
		panic("copy_shared_pages: %e", r);
  8049fd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804a00:	89 c1                	mov    %eax,%ecx
  804a02:	48 ba e2 6f 80 00 00 	movabs $0x806fe2,%rdx
  804a09:	00 00 00 
  804a0c:	be 82 00 00 00       	mov    $0x82,%esi
  804a11:	48 bf f8 6f 80 00 00 	movabs $0x806ff8,%rdi
  804a18:	00 00 00 
  804a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  804a20:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  804a27:	00 00 00 
  804a2a:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804a2d:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  804a34:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804a37:	48 89 d6             	mov    %rdx,%rsi
  804a3a:	89 c7                	mov    %eax,%edi
  804a3c:	48 b8 e4 2b 80 00 00 	movabs $0x802be4,%rax
  804a43:	00 00 00 
  804a46:	ff d0                	callq  *%rax
  804a48:	89 45 d8             	mov    %eax,-0x28(%rbp)
  804a4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804a4f:	79 30                	jns    804a81 <spawn+0x2e9>
		panic("sys_env_set_trapframe: %e", r);
  804a51:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804a54:	89 c1                	mov    %eax,%ecx
  804a56:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  804a5d:	00 00 00 
  804a60:	be 85 00 00 00       	mov    $0x85,%esi
  804a65:	48 bf f8 6f 80 00 00 	movabs $0x806ff8,%rdi
  804a6c:	00 00 00 
  804a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  804a74:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  804a7b:	00 00 00 
  804a7e:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804a81:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804a84:	be 02 00 00 00       	mov    $0x2,%esi
  804a89:	89 c7                	mov    %eax,%edi
  804a8b:	48 b8 99 2b 80 00 00 	movabs $0x802b99,%rax
  804a92:	00 00 00 
  804a95:	ff d0                	callq  *%rax
  804a97:	89 45 d8             	mov    %eax,-0x28(%rbp)
  804a9a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804a9e:	79 30                	jns    804ad0 <spawn+0x338>
		panic("sys_env_set_status: %e", r);
  804aa0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804aa3:	89 c1                	mov    %eax,%ecx
  804aa5:	48 ba 1e 70 80 00 00 	movabs $0x80701e,%rdx
  804aac:	00 00 00 
  804aaf:	be 88 00 00 00       	mov    $0x88,%esi
  804ab4:	48 bf f8 6f 80 00 00 	movabs $0x806ff8,%rdi
  804abb:	00 00 00 
  804abe:	b8 00 00 00 00       	mov    $0x0,%eax
  804ac3:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  804aca:	00 00 00 
  804acd:	41 ff d0             	callq  *%r8

	return child;
  804ad0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804ad3:	eb 26                	jmp    804afb <spawn+0x363>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804ad5:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804ad6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804ad9:	89 c7                	mov    %eax,%edi
  804adb:	48 b8 e4 29 80 00 00 	movabs $0x8029e4,%rax
  804ae2:	00 00 00 
  804ae5:	ff d0                	callq  *%rax
	close(fd);
  804ae7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804aea:	89 c7                	mov    %eax,%edi
  804aec:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  804af3:	00 00 00 
  804af6:	ff d0                	callq  *%rax
	return r;
  804af8:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  804afb:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  804b02:	5b                   	pop    %rbx
  804b03:	5d                   	pop    %rbp
  804b04:	c3                   	retq   

0000000000804b05 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804b05:	55                   	push   %rbp
  804b06:	48 89 e5             	mov    %rsp,%rbp
  804b09:	53                   	push   %rbx
  804b0a:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  804b11:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  804b18:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  804b1f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804b26:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804b2d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804b34:	84 c0                	test   %al,%al
  804b36:	74 23                	je     804b5b <spawnl+0x56>
  804b38:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804b3f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804b43:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804b47:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804b4b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804b4f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804b53:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804b57:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804b5b:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804b62:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  804b69:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804b6c:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  804b73:	00 00 00 
  804b76:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  804b7d:	00 00 00 
  804b80:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804b84:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  804b8b:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  804b92:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804b99:	eb 07                	jmp    804ba2 <spawnl+0x9d>
		argc++;
  804b9b:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804ba2:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  804ba8:	83 f8 30             	cmp    $0x30,%eax
  804bab:	73 23                	jae    804bd0 <spawnl+0xcb>
  804bad:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  804bb4:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  804bba:	89 c0                	mov    %eax,%eax
  804bbc:	48 01 d0             	add    %rdx,%rax
  804bbf:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  804bc5:	83 c2 08             	add    $0x8,%edx
  804bc8:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  804bce:	eb 15                	jmp    804be5 <spawnl+0xe0>
  804bd0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804bd7:	48 89 d0             	mov    %rdx,%rax
  804bda:	48 83 c2 08          	add    $0x8,%rdx
  804bde:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  804be5:	48 8b 00             	mov    (%rax),%rax
  804be8:	48 85 c0             	test   %rax,%rax
  804beb:	75 ae                	jne    804b9b <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804bed:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  804bf3:	83 c0 02             	add    $0x2,%eax
  804bf6:	48 89 e2             	mov    %rsp,%rdx
  804bf9:	48 89 d3             	mov    %rdx,%rbx
  804bfc:	48 63 d0             	movslq %eax,%rdx
  804bff:	48 83 ea 01          	sub    $0x1,%rdx
  804c03:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  804c0a:	48 98                	cltq   
  804c0c:	48 c1 e0 03          	shl    $0x3,%rax
  804c10:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  804c14:	b8 10 00 00 00       	mov    $0x10,%eax
  804c19:	48 83 e8 01          	sub    $0x1,%rax
  804c1d:	48 01 d0             	add    %rdx,%rax
  804c20:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  804c27:	10 00 00 00 
  804c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  804c30:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  804c37:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804c3b:	48 29 c4             	sub    %rax,%rsp
  804c3e:	48 89 e0             	mov    %rsp,%rax
  804c41:	48 83 c0 0f          	add    $0xf,%rax
  804c45:	48 c1 e8 04          	shr    $0x4,%rax
  804c49:	48 c1 e0 04          	shl    $0x4,%rax
  804c4d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  804c54:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804c5b:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  804c62:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804c65:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  804c6b:	8d 50 01             	lea    0x1(%rax),%edx
  804c6e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804c75:	48 63 d2             	movslq %edx,%rdx
  804c78:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804c7f:	00 

	va_start(vl, arg0);
  804c80:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  804c87:	00 00 00 
  804c8a:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  804c91:	00 00 00 
  804c94:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804c98:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  804c9f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  804ca6:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  804cad:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  804cb4:	00 00 00 
  804cb7:	eb 63                	jmp    804d1c <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  804cb9:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  804cbf:	8d 70 01             	lea    0x1(%rax),%esi
  804cc2:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  804cc8:	83 f8 30             	cmp    $0x30,%eax
  804ccb:	73 23                	jae    804cf0 <spawnl+0x1eb>
  804ccd:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  804cd4:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  804cda:	89 c0                	mov    %eax,%eax
  804cdc:	48 01 d0             	add    %rdx,%rax
  804cdf:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  804ce5:	83 c2 08             	add    $0x8,%edx
  804ce8:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  804cee:	eb 15                	jmp    804d05 <spawnl+0x200>
  804cf0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804cf7:	48 89 d0             	mov    %rdx,%rax
  804cfa:	48 83 c2 08          	add    $0x8,%rdx
  804cfe:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  804d05:	48 8b 08             	mov    (%rax),%rcx
  804d08:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804d0f:	89 f2                	mov    %esi,%edx
  804d11:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804d15:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  804d1c:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  804d22:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  804d28:	77 8f                	ja     804cb9 <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804d2a:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  804d31:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804d38:	48 89 d6             	mov    %rdx,%rsi
  804d3b:	48 89 c7             	mov    %rax,%rdi
  804d3e:	48 b8 98 47 80 00 00 	movabs $0x804798,%rax
  804d45:	00 00 00 
  804d48:	ff d0                	callq  *%rax
  804d4a:	48 89 dc             	mov    %rbx,%rsp
}
  804d4d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804d51:	c9                   	leaveq 
  804d52:	c3                   	retq   

0000000000804d53 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  804d53:	55                   	push   %rbp
  804d54:	48 89 e5             	mov    %rsp,%rbp
  804d57:	48 83 ec 50          	sub    $0x50,%rsp
  804d5b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804d5e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804d62:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  804d66:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804d6d:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  804d75:	eb 2c                	jmp    804da3 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  804d77:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d7a:	48 98                	cltq   
  804d7c:	48 c1 e0 03          	shl    $0x3,%rax
  804d80:	48 03 45 c0          	add    -0x40(%rbp),%rax
  804d84:	48 8b 00             	mov    (%rax),%rax
  804d87:	48 89 c7             	mov    %rax,%rdi
  804d8a:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804d91:	00 00 00 
  804d94:	ff d0                	callq  *%rax
  804d96:	83 c0 01             	add    $0x1,%eax
  804d99:	48 98                	cltq   
  804d9b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  804d9f:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  804da3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804da6:	48 98                	cltq   
  804da8:	48 c1 e0 03          	shl    $0x3,%rax
  804dac:	48 03 45 c0          	add    -0x40(%rbp),%rax
  804db0:	48 8b 00             	mov    (%rax),%rax
  804db3:	48 85 c0             	test   %rax,%rax
  804db6:	75 bf                	jne    804d77 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  804db8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dbc:	48 f7 d8             	neg    %rax
  804dbf:	48 05 00 10 40 00    	add    $0x401000,%rax
  804dc5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  804dc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804dcd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804dd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804dd5:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  804dd9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804ddc:	83 c2 01             	add    $0x1,%edx
  804ddf:	c1 e2 03             	shl    $0x3,%edx
  804de2:	48 63 d2             	movslq %edx,%rdx
  804de5:	48 f7 da             	neg    %rdx
  804de8:	48 01 d0             	add    %rdx,%rax
  804deb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804def:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804df3:	48 83 e8 10          	sub    $0x10,%rax
  804df7:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804dfd:	77 0a                	ja     804e09 <init_stack+0xb6>
		return -E_NO_MEM;
  804dff:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804e04:	e9 b8 01 00 00       	jmpq   804fc1 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804e09:	ba 07 00 00 00       	mov    $0x7,%edx
  804e0e:	be 00 00 40 00       	mov    $0x400000,%esi
  804e13:	bf 00 00 00 00       	mov    $0x0,%edi
  804e18:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  804e1f:	00 00 00 
  804e22:	ff d0                	callq  *%rax
  804e24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e27:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e2b:	79 08                	jns    804e35 <init_stack+0xe2>
		return r;
  804e2d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e30:	e9 8c 01 00 00       	jmpq   804fc1 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804e35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804e3c:	eb 73                	jmp    804eb1 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  804e3e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e41:	48 98                	cltq   
  804e43:	48 c1 e0 03          	shl    $0x3,%rax
  804e47:	48 03 45 d0          	add    -0x30(%rbp),%rax
  804e4b:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  804e50:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  804e54:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  804e5b:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  804e5e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e61:	48 98                	cltq   
  804e63:	48 c1 e0 03          	shl    $0x3,%rax
  804e67:	48 03 45 c0          	add    -0x40(%rbp),%rax
  804e6b:	48 8b 10             	mov    (%rax),%rdx
  804e6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e72:	48 89 d6             	mov    %rdx,%rsi
  804e75:	48 89 c7             	mov    %rax,%rdi
  804e78:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  804e7f:	00 00 00 
  804e82:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804e84:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e87:	48 98                	cltq   
  804e89:	48 c1 e0 03          	shl    $0x3,%rax
  804e8d:	48 03 45 c0          	add    -0x40(%rbp),%rax
  804e91:	48 8b 00             	mov    (%rax),%rax
  804e94:	48 89 c7             	mov    %rax,%rdi
  804e97:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804e9e:	00 00 00 
  804ea1:	ff d0                	callq  *%rax
  804ea3:	48 98                	cltq   
  804ea5:	48 83 c0 01          	add    $0x1,%rax
  804ea9:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804ead:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804eb1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804eb4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804eb7:	7c 85                	jl     804e3e <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  804eb9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804ebc:	48 98                	cltq   
  804ebe:	48 c1 e0 03          	shl    $0x3,%rax
  804ec2:	48 03 45 d0          	add    -0x30(%rbp),%rax
  804ec6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804ecd:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804ed4:	00 
  804ed5:	74 35                	je     804f0c <init_stack+0x1b9>
  804ed7:	48 b9 38 70 80 00 00 	movabs $0x807038,%rcx
  804ede:	00 00 00 
  804ee1:	48 ba 5e 70 80 00 00 	movabs $0x80705e,%rdx
  804ee8:	00 00 00 
  804eeb:	be f1 00 00 00       	mov    $0xf1,%esi
  804ef0:	48 bf f8 6f 80 00 00 	movabs $0x806ff8,%rdi
  804ef7:	00 00 00 
  804efa:	b8 00 00 00 00       	mov    $0x0,%eax
  804eff:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  804f06:	00 00 00 
  804f09:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804f0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f10:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  804f14:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  804f19:	48 03 45 d0          	add    -0x30(%rbp),%rax
  804f1d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f23:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  804f26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f2a:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  804f2e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f31:	48 98                	cltq   
  804f33:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  804f36:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  804f3b:	48 03 45 d0          	add    -0x30(%rbp),%rax
  804f3f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f45:	48 89 c2             	mov    %rax,%rdx
  804f48:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804f4c:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804f4f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804f52:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  804f58:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804f5d:	89 c2                	mov    %eax,%edx
  804f5f:	be 00 00 40 00       	mov    $0x400000,%esi
  804f64:	bf 00 00 00 00       	mov    $0x0,%edi
  804f69:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  804f70:	00 00 00 
  804f73:	ff d0                	callq  *%rax
  804f75:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804f78:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f7c:	78 26                	js     804fa4 <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804f7e:	be 00 00 40 00       	mov    $0x400000,%esi
  804f83:	bf 00 00 00 00       	mov    $0x0,%edi
  804f88:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  804f8f:	00 00 00 
  804f92:	ff d0                	callq  *%rax
  804f94:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804f97:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f9b:	78 0a                	js     804fa7 <init_stack+0x254>
		goto error;

	return 0;
  804f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  804fa2:	eb 1d                	jmp    804fc1 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  804fa4:	90                   	nop
  804fa5:	eb 01                	jmp    804fa8 <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  804fa7:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  804fa8:	be 00 00 40 00       	mov    $0x400000,%esi
  804fad:	bf 00 00 00 00       	mov    $0x0,%edi
  804fb2:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  804fb9:	00 00 00 
  804fbc:	ff d0                	callq  *%rax
	return r;
  804fbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804fc1:	c9                   	leaveq 
  804fc2:	c3                   	retq   

0000000000804fc3 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  804fc3:	55                   	push   %rbp
  804fc4:	48 89 e5             	mov    %rsp,%rbp
  804fc7:	48 83 ec 50          	sub    $0x50,%rsp
  804fcb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804fce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804fd2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804fd6:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  804fd9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804fdd:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  804fe1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804fe5:	25 ff 0f 00 00       	and    $0xfff,%eax
  804fea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804fed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ff1:	74 21                	je     805014 <map_segment+0x51>
		va -= i;
  804ff3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ff6:	48 98                	cltq   
  804ff8:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  804ffc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fff:	48 98                	cltq   
  805001:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  805005:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805008:	48 98                	cltq   
  80500a:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80500e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805011:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80501b:	e9 74 01 00 00       	jmpq   805194 <map_segment+0x1d1>
		if (i >= filesz) {
  805020:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805023:	48 98                	cltq   
  805025:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  805029:	72 38                	jb     805063 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80502b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80502e:	48 98                	cltq   
  805030:	48 03 45 d0          	add    -0x30(%rbp),%rax
  805034:	48 89 c1             	mov    %rax,%rcx
  805037:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80503a:	8b 55 10             	mov    0x10(%rbp),%edx
  80503d:	48 89 ce             	mov    %rcx,%rsi
  805040:	89 c7                	mov    %eax,%edi
  805042:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  805049:	00 00 00 
  80504c:	ff d0                	callq  *%rax
  80504e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805051:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805055:	0f 89 32 01 00 00    	jns    80518d <map_segment+0x1ca>
				return r;
  80505b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80505e:	e9 45 01 00 00       	jmpq   8051a8 <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  805063:	ba 07 00 00 00       	mov    $0x7,%edx
  805068:	be 00 00 40 00       	mov    $0x400000,%esi
  80506d:	bf 00 00 00 00       	mov    $0x0,%edi
  805072:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  805079:	00 00 00 
  80507c:	ff d0                	callq  *%rax
  80507e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805081:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805085:	79 08                	jns    80508f <map_segment+0xcc>
				return r;
  805087:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80508a:	e9 19 01 00 00       	jmpq   8051a8 <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80508f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805092:	8b 55 bc             	mov    -0x44(%rbp),%edx
  805095:	01 c2                	add    %eax,%edx
  805097:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80509a:	89 d6                	mov    %edx,%esi
  80509c:	89 c7                	mov    %eax,%edi
  80509e:	48 b8 c6 3e 80 00 00 	movabs $0x803ec6,%rax
  8050a5:	00 00 00 
  8050a8:	ff d0                	callq  *%rax
  8050aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8050ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8050b1:	79 08                	jns    8050bb <map_segment+0xf8>
				return r;
  8050b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050b6:	e9 ed 00 00 00       	jmpq   8051a8 <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8050bb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8050c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050c5:	48 98                	cltq   
  8050c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8050cb:	48 89 d1             	mov    %rdx,%rcx
  8050ce:	48 29 c1             	sub    %rax,%rcx
  8050d1:	48 89 c8             	mov    %rcx,%rax
  8050d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8050d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050db:	48 63 d0             	movslq %eax,%rdx
  8050de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050e2:	48 39 c2             	cmp    %rax,%rdx
  8050e5:	48 0f 47 d0          	cmova  %rax,%rdx
  8050e9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8050ec:	be 00 00 40 00       	mov    $0x400000,%esi
  8050f1:	89 c7                	mov    %eax,%edi
  8050f3:	48 b8 79 3d 80 00 00 	movabs $0x803d79,%rax
  8050fa:	00 00 00 
  8050fd:	ff d0                	callq  *%rax
  8050ff:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805102:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805106:	79 08                	jns    805110 <map_segment+0x14d>
				return r;
  805108:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80510b:	e9 98 00 00 00       	jmpq   8051a8 <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  805110:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805113:	48 98                	cltq   
  805115:	48 03 45 d0          	add    -0x30(%rbp),%rax
  805119:	48 89 c2             	mov    %rax,%rdx
  80511c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80511f:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  805123:	48 89 d1             	mov    %rdx,%rcx
  805126:	89 c2                	mov    %eax,%edx
  805128:	be 00 00 40 00       	mov    $0x400000,%esi
  80512d:	bf 00 00 00 00       	mov    $0x0,%edi
  805132:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  805139:	00 00 00 
  80513c:	ff d0                	callq  *%rax
  80513e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805141:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805145:	79 30                	jns    805177 <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  805147:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80514a:	89 c1                	mov    %eax,%ecx
  80514c:	48 ba 73 70 80 00 00 	movabs $0x807073,%rdx
  805153:	00 00 00 
  805156:	be 24 01 00 00       	mov    $0x124,%esi
  80515b:	48 bf f8 6f 80 00 00 	movabs $0x806ff8,%rdi
  805162:	00 00 00 
  805165:	b8 00 00 00 00       	mov    $0x0,%eax
  80516a:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  805171:	00 00 00 
  805174:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  805177:	be 00 00 40 00       	mov    $0x400000,%esi
  80517c:	bf 00 00 00 00       	mov    $0x0,%edi
  805181:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  805188:	00 00 00 
  80518b:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80518d:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  805194:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805197:	48 98                	cltq   
  805199:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80519d:	0f 82 7d fe ff ff    	jb     805020 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8051a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8051a8:	c9                   	leaveq 
  8051a9:	c3                   	retq   

00000000008051aa <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8051aa:	55                   	push   %rbp
  8051ab:	48 89 e5             	mov    %rsp,%rbp
  8051ae:	48 83 ec 60          	sub    $0x60,%rsp
  8051b2:	89 7d ac             	mov    %edi,-0x54(%rbp)
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
  8051b5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
        vpdpe_entries = VPDPE(UTOP);
  8051bc:	c7 45 c0 00 02 00 00 	movl   $0x200,-0x40(%rbp)
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  8051c3:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8051ca:	00 
  8051cb:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8051d2:	00 
  8051d3:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8051da:	00 
  8051db:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8051e2:	00 
  8051e3:	e9 a6 01 00 00       	jmpq   80538e <copy_shared_pages+0x1e4>
        {
                if(uvpml4e[a] & PTE_P)
  8051e8:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8051ef:	01 00 00 
  8051f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8051f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8051fa:	83 e0 01             	and    $0x1,%eax
  8051fd:	84 c0                	test   %al,%al
  8051ff:	0f 84 74 01 00 00    	je     805379 <copy_shared_pages+0x1cf>
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  805205:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80520c:	00 
  80520d:	e9 56 01 00 00       	jmpq   805368 <copy_shared_pages+0x1be>
                        {
                                if(uvpde[b1] & PTE_P)
  805212:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  805219:	01 00 00 
  80521c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805220:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805224:	83 e0 01             	and    $0x1,%eax
  805227:	84 c0                	test   %al,%al
  805229:	0f 84 1f 01 00 00    	je     80534e <copy_shared_pages+0x1a4>
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  80522f:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  805236:	00 
  805237:	e9 02 01 00 00       	jmpq   80533e <copy_shared_pages+0x194>
                                        {
                                                if(uvpd[c1] & PTE_P)
  80523c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805243:	01 00 00 
  805246:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80524a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80524e:	83 e0 01             	and    $0x1,%eax
  805251:	84 c0                	test   %al,%al
  805253:	0f 84 cb 00 00 00    	je     805324 <copy_shared_pages+0x17a>
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  805259:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  805260:	00 
  805261:	e9 ae 00 00 00       	jmpq   805314 <copy_shared_pages+0x16a>
                                                        {
                                                                if((uvpt[d1] & PTE_SHARE))// && (f != VPN(UXSTACKTOP-PGSIZE)))
  805266:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80526d:	01 00 00 
  805270:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805274:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805278:	25 00 04 00 00       	and    $0x400,%eax
  80527d:	48 85 c0             	test   %rax,%rax
  805280:	0f 84 84 00 00 00    	je     80530a <copy_shared_pages+0x160>
                                                                {
                                                                        void* addr=(void *)(d1 << PGSHIFT);
  805286:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80528a:	48 c1 e0 0c          	shl    $0xc,%rax
  80528e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
                                                                        perm=uvpt[d1] & PTE_USER;
  805292:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805299:	01 00 00 
  80529c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8052a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8052a9:	89 45 b4             	mov    %eax,-0x4c(%rbp)
                                                                        //cprintf("f:%08x\tUTOP:%08x\taddr:%08x\tuvpt[f]:%08x\tperm:%08x\n",f,UTOP,addr,uvpt[f],perm);
                                                                        r = sys_page_map(0, addr, child, addr, perm);
  8052ac:	8b 75 b4             	mov    -0x4c(%rbp),%esi
  8052af:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  8052b3:	8b 55 ac             	mov    -0x54(%rbp),%edx
  8052b6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8052ba:	41 89 f0             	mov    %esi,%r8d
  8052bd:	48 89 c6             	mov    %rax,%rsi
  8052c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8052c5:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  8052cc:	00 00 00 
  8052cf:	ff d0                	callq  *%rax
  8052d1:	89 45 b0             	mov    %eax,-0x50(%rbp)
                                                                        if (r < 0)
  8052d4:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8052d8:	79 30                	jns    80530a <copy_shared_pages+0x160>
                                                                                panic("sys_page_map failed:%e",r);
  8052da:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8052dd:	89 c1                	mov    %eax,%ecx
  8052df:	48 ba 90 70 80 00 00 	movabs $0x807090,%rdx
  8052e6:	00 00 00 
  8052e9:	be 48 01 00 00       	mov    $0x148,%esi
  8052ee:	48 bf f8 6f 80 00 00 	movabs $0x806ff8,%rdi
  8052f5:	00 00 00 
  8052f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8052fd:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  805304:	00 00 00 
  805307:	41 ff d0             	callq  *%r8
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
                                        {
                                                if(uvpd[c1] & PTE_P)
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  80530a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80530f:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805314:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80531b:	00 
  80531c:	0f 86 44 ff ff ff    	jbe    805266 <copy_shared_pages+0xbc>
  805322:	eb 10                	jmp    805334 <copy_shared_pages+0x18a>
                                                                                panic("sys_page_map failed:%e",r);
                                                                }
                                                        }
                                                }
                                                else {
                                                        d1 = (c1+1)*NPTENTRIES;
  805324:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805328:	48 83 c0 01          	add    $0x1,%rax
  80532c:	48 c1 e0 09          	shl    $0x9,%rax
  805330:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
                        {
                                if(uvpde[b1] & PTE_P)
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  805334:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  805339:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80533e:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  805345:	00 
  805346:	0f 86 f0 fe ff ff    	jbe    80523c <copy_shared_pages+0x92>
  80534c:	eb 10                	jmp    80535e <copy_shared_pages+0x1b4>
                                                        d1 = (c1+1)*NPTENTRIES;
                                                }
                                        }
                                }
                                else {
                                        c1 = (b+1) * NPDENTRIES;
  80534e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805352:	48 83 c0 01          	add    $0x1,%rax
  805356:	48 c1 e0 09          	shl    $0x9,%rax
  80535a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
        {
                if(uvpml4e[a] & PTE_P)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  80535e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  805363:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  805368:	8b 45 c0             	mov    -0x40(%rbp),%eax
  80536b:	48 98                	cltq   
  80536d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  805371:	0f 87 9b fe ff ff    	ja     805212 <copy_shared_pages+0x68>
  805377:	eb 10                	jmp    805389 <copy_shared_pages+0x1df>
                                }
                        }
                }
                else
                {
                        b1=(a+1)*NPDPENTRIES;
  805379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80537d:	48 83 c0 01          	add    $0x1,%rax
  805381:	48 c1 e0 09          	shl    $0x9,%rax
  805385:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
{
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  805389:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80538e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  805391:	48 98                	cltq   
  805393:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  805397:	0f 87 4b fe ff ff    	ja     8051e8 <copy_shared_pages+0x3e>
                else
                {
                        b1=(a+1)*NPDPENTRIES;
                }
	}	
        return 0;
  80539d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8053a2:	c9                   	leaveq 
  8053a3:	c3                   	retq   

00000000008053a4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8053a4:	55                   	push   %rbp
  8053a5:	48 89 e5             	mov    %rsp,%rbp
  8053a8:	48 83 ec 20          	sub    $0x20,%rsp
  8053ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8053af:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8053b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8053b6:	48 89 d6             	mov    %rdx,%rsi
  8053b9:	89 c7                	mov    %eax,%edi
  8053bb:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  8053c2:	00 00 00 
  8053c5:	ff d0                	callq  *%rax
  8053c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053ce:	79 05                	jns    8053d5 <fd2sockid+0x31>
		return r;
  8053d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053d3:	eb 24                	jmp    8053f9 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8053d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053d9:	8b 10                	mov    (%rax),%edx
  8053db:	48 b8 e0 90 80 00 00 	movabs $0x8090e0,%rax
  8053e2:	00 00 00 
  8053e5:	8b 00                	mov    (%rax),%eax
  8053e7:	39 c2                	cmp    %eax,%edx
  8053e9:	74 07                	je     8053f2 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8053eb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8053f0:	eb 07                	jmp    8053f9 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8053f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053f6:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8053f9:	c9                   	leaveq 
  8053fa:	c3                   	retq   

00000000008053fb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8053fb:	55                   	push   %rbp
  8053fc:	48 89 e5             	mov    %rsp,%rbp
  8053ff:	48 83 ec 20          	sub    $0x20,%rsp
  805403:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  805406:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80540a:	48 89 c7             	mov    %rax,%rdi
  80540d:	48 b8 d6 37 80 00 00 	movabs $0x8037d6,%rax
  805414:	00 00 00 
  805417:	ff d0                	callq  *%rax
  805419:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80541c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805420:	78 26                	js     805448 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  805422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805426:	ba 07 04 00 00       	mov    $0x407,%edx
  80542b:	48 89 c6             	mov    %rax,%rsi
  80542e:	bf 00 00 00 00       	mov    $0x0,%edi
  805433:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  80543a:	00 00 00 
  80543d:	ff d0                	callq  *%rax
  80543f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805442:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805446:	79 16                	jns    80545e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  805448:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80544b:	89 c7                	mov    %eax,%edi
  80544d:	48 b8 08 59 80 00 00 	movabs $0x805908,%rax
  805454:	00 00 00 
  805457:	ff d0                	callq  *%rax
		return r;
  805459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80545c:	eb 3a                	jmp    805498 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80545e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805462:	48 ba e0 90 80 00 00 	movabs $0x8090e0,%rdx
  805469:	00 00 00 
  80546c:	8b 12                	mov    (%rdx),%edx
  80546e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  805470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805474:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80547b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80547f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805482:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  805485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805489:	48 89 c7             	mov    %rax,%rdi
  80548c:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  805493:	00 00 00 
  805496:	ff d0                	callq  *%rax
}
  805498:	c9                   	leaveq 
  805499:	c3                   	retq   

000000000080549a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80549a:	55                   	push   %rbp
  80549b:	48 89 e5             	mov    %rsp,%rbp
  80549e:	48 83 ec 30          	sub    $0x30,%rsp
  8054a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8054a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8054a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8054ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8054b0:	89 c7                	mov    %eax,%edi
  8054b2:	48 b8 a4 53 80 00 00 	movabs $0x8053a4,%rax
  8054b9:	00 00 00 
  8054bc:	ff d0                	callq  *%rax
  8054be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054c5:	79 05                	jns    8054cc <accept+0x32>
		return r;
  8054c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054ca:	eb 3b                	jmp    805507 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8054cc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8054d0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8054d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054d7:	48 89 ce             	mov    %rcx,%rsi
  8054da:	89 c7                	mov    %eax,%edi
  8054dc:	48 b8 e5 57 80 00 00 	movabs $0x8057e5,%rax
  8054e3:	00 00 00 
  8054e6:	ff d0                	callq  *%rax
  8054e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054ef:	79 05                	jns    8054f6 <accept+0x5c>
		return r;
  8054f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054f4:	eb 11                	jmp    805507 <accept+0x6d>
	return alloc_sockfd(r);
  8054f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054f9:	89 c7                	mov    %eax,%edi
  8054fb:	48 b8 fb 53 80 00 00 	movabs $0x8053fb,%rax
  805502:	00 00 00 
  805505:	ff d0                	callq  *%rax
}
  805507:	c9                   	leaveq 
  805508:	c3                   	retq   

0000000000805509 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805509:	55                   	push   %rbp
  80550a:	48 89 e5             	mov    %rsp,%rbp
  80550d:	48 83 ec 20          	sub    $0x20,%rsp
  805511:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805514:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805518:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80551b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80551e:	89 c7                	mov    %eax,%edi
  805520:	48 b8 a4 53 80 00 00 	movabs $0x8053a4,%rax
  805527:	00 00 00 
  80552a:	ff d0                	callq  *%rax
  80552c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80552f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805533:	79 05                	jns    80553a <bind+0x31>
		return r;
  805535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805538:	eb 1b                	jmp    805555 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80553a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80553d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805544:	48 89 ce             	mov    %rcx,%rsi
  805547:	89 c7                	mov    %eax,%edi
  805549:	48 b8 64 58 80 00 00 	movabs $0x805864,%rax
  805550:	00 00 00 
  805553:	ff d0                	callq  *%rax
}
  805555:	c9                   	leaveq 
  805556:	c3                   	retq   

0000000000805557 <shutdown>:

int
shutdown(int s, int how)
{
  805557:	55                   	push   %rbp
  805558:	48 89 e5             	mov    %rsp,%rbp
  80555b:	48 83 ec 20          	sub    $0x20,%rsp
  80555f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805562:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805565:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805568:	89 c7                	mov    %eax,%edi
  80556a:	48 b8 a4 53 80 00 00 	movabs $0x8053a4,%rax
  805571:	00 00 00 
  805574:	ff d0                	callq  *%rax
  805576:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80557d:	79 05                	jns    805584 <shutdown+0x2d>
		return r;
  80557f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805582:	eb 16                	jmp    80559a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  805584:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805587:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80558a:	89 d6                	mov    %edx,%esi
  80558c:	89 c7                	mov    %eax,%edi
  80558e:	48 b8 c8 58 80 00 00 	movabs $0x8058c8,%rax
  805595:	00 00 00 
  805598:	ff d0                	callq  *%rax
}
  80559a:	c9                   	leaveq 
  80559b:	c3                   	retq   

000000000080559c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80559c:	55                   	push   %rbp
  80559d:	48 89 e5             	mov    %rsp,%rbp
  8055a0:	48 83 ec 10          	sub    $0x10,%rsp
  8055a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8055a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055ac:	48 89 c7             	mov    %rax,%rdi
  8055af:	48 b8 74 65 80 00 00 	movabs $0x806574,%rax
  8055b6:	00 00 00 
  8055b9:	ff d0                	callq  *%rax
  8055bb:	83 f8 01             	cmp    $0x1,%eax
  8055be:	75 17                	jne    8055d7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8055c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055c4:	8b 40 0c             	mov    0xc(%rax),%eax
  8055c7:	89 c7                	mov    %eax,%edi
  8055c9:	48 b8 08 59 80 00 00 	movabs $0x805908,%rax
  8055d0:	00 00 00 
  8055d3:	ff d0                	callq  *%rax
  8055d5:	eb 05                	jmp    8055dc <devsock_close+0x40>
	else
		return 0;
  8055d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8055dc:	c9                   	leaveq 
  8055dd:	c3                   	retq   

00000000008055de <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8055de:	55                   	push   %rbp
  8055df:	48 89 e5             	mov    %rsp,%rbp
  8055e2:	48 83 ec 20          	sub    $0x20,%rsp
  8055e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8055ed:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8055f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055f3:	89 c7                	mov    %eax,%edi
  8055f5:	48 b8 a4 53 80 00 00 	movabs $0x8053a4,%rax
  8055fc:	00 00 00 
  8055ff:	ff d0                	callq  *%rax
  805601:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805604:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805608:	79 05                	jns    80560f <connect+0x31>
		return r;
  80560a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80560d:	eb 1b                	jmp    80562a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80560f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805612:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805619:	48 89 ce             	mov    %rcx,%rsi
  80561c:	89 c7                	mov    %eax,%edi
  80561e:	48 b8 35 59 80 00 00 	movabs $0x805935,%rax
  805625:	00 00 00 
  805628:	ff d0                	callq  *%rax
}
  80562a:	c9                   	leaveq 
  80562b:	c3                   	retq   

000000000080562c <listen>:

int
listen(int s, int backlog)
{
  80562c:	55                   	push   %rbp
  80562d:	48 89 e5             	mov    %rsp,%rbp
  805630:	48 83 ec 20          	sub    $0x20,%rsp
  805634:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805637:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80563a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80563d:	89 c7                	mov    %eax,%edi
  80563f:	48 b8 a4 53 80 00 00 	movabs $0x8053a4,%rax
  805646:	00 00 00 
  805649:	ff d0                	callq  *%rax
  80564b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80564e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805652:	79 05                	jns    805659 <listen+0x2d>
		return r;
  805654:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805657:	eb 16                	jmp    80566f <listen+0x43>
	return nsipc_listen(r, backlog);
  805659:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80565c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80565f:	89 d6                	mov    %edx,%esi
  805661:	89 c7                	mov    %eax,%edi
  805663:	48 b8 99 59 80 00 00 	movabs $0x805999,%rax
  80566a:	00 00 00 
  80566d:	ff d0                	callq  *%rax
}
  80566f:	c9                   	leaveq 
  805670:	c3                   	retq   

0000000000805671 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  805671:	55                   	push   %rbp
  805672:	48 89 e5             	mov    %rsp,%rbp
  805675:	48 83 ec 20          	sub    $0x20,%rsp
  805679:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80567d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805681:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  805685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805689:	89 c2                	mov    %eax,%edx
  80568b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80568f:	8b 40 0c             	mov    0xc(%rax),%eax
  805692:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  805696:	b9 00 00 00 00       	mov    $0x0,%ecx
  80569b:	89 c7                	mov    %eax,%edi
  80569d:	48 b8 d9 59 80 00 00 	movabs $0x8059d9,%rax
  8056a4:	00 00 00 
  8056a7:	ff d0                	callq  *%rax
}
  8056a9:	c9                   	leaveq 
  8056aa:	c3                   	retq   

00000000008056ab <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8056ab:	55                   	push   %rbp
  8056ac:	48 89 e5             	mov    %rsp,%rbp
  8056af:	48 83 ec 20          	sub    $0x20,%rsp
  8056b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8056b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8056bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8056bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056c3:	89 c2                	mov    %eax,%edx
  8056c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056c9:	8b 40 0c             	mov    0xc(%rax),%eax
  8056cc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8056d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8056d5:	89 c7                	mov    %eax,%edi
  8056d7:	48 b8 a5 5a 80 00 00 	movabs $0x805aa5,%rax
  8056de:	00 00 00 
  8056e1:	ff d0                	callq  *%rax
}
  8056e3:	c9                   	leaveq 
  8056e4:	c3                   	retq   

00000000008056e5 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8056e5:	55                   	push   %rbp
  8056e6:	48 89 e5             	mov    %rsp,%rbp
  8056e9:	48 83 ec 10          	sub    $0x10,%rsp
  8056ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8056f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8056f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056f9:	48 be ac 70 80 00 00 	movabs $0x8070ac,%rsi
  805700:	00 00 00 
  805703:	48 89 c7             	mov    %rax,%rdi
  805706:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  80570d:	00 00 00 
  805710:	ff d0                	callq  *%rax
	return 0;
  805712:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805717:	c9                   	leaveq 
  805718:	c3                   	retq   

0000000000805719 <socket>:

int
socket(int domain, int type, int protocol)
{
  805719:	55                   	push   %rbp
  80571a:	48 89 e5             	mov    %rsp,%rbp
  80571d:	48 83 ec 20          	sub    $0x20,%rsp
  805721:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805724:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805727:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80572a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80572d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805730:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805733:	89 ce                	mov    %ecx,%esi
  805735:	89 c7                	mov    %eax,%edi
  805737:	48 b8 5d 5b 80 00 00 	movabs $0x805b5d,%rax
  80573e:	00 00 00 
  805741:	ff d0                	callq  *%rax
  805743:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805746:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80574a:	79 05                	jns    805751 <socket+0x38>
		return r;
  80574c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80574f:	eb 11                	jmp    805762 <socket+0x49>
	return alloc_sockfd(r);
  805751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805754:	89 c7                	mov    %eax,%edi
  805756:	48 b8 fb 53 80 00 00 	movabs $0x8053fb,%rax
  80575d:	00 00 00 
  805760:	ff d0                	callq  *%rax
}
  805762:	c9                   	leaveq 
  805763:	c3                   	retq   

0000000000805764 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  805764:	55                   	push   %rbp
  805765:	48 89 e5             	mov    %rsp,%rbp
  805768:	48 83 ec 10          	sub    $0x10,%rsp
  80576c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80576f:	48 b8 64 a4 80 00 00 	movabs $0x80a464,%rax
  805776:	00 00 00 
  805779:	8b 00                	mov    (%rax),%eax
  80577b:	85 c0                	test   %eax,%eax
  80577d:	75 1d                	jne    80579c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80577f:	bf 02 00 00 00       	mov    $0x2,%edi
  805784:	48 b8 ef 64 80 00 00 	movabs $0x8064ef,%rax
  80578b:	00 00 00 
  80578e:	ff d0                	callq  *%rax
  805790:	48 ba 64 a4 80 00 00 	movabs $0x80a464,%rdx
  805797:	00 00 00 
  80579a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80579c:	48 b8 64 a4 80 00 00 	movabs $0x80a464,%rax
  8057a3:	00 00 00 
  8057a6:	8b 00                	mov    (%rax),%eax
  8057a8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8057ab:	b9 07 00 00 00       	mov    $0x7,%ecx
  8057b0:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  8057b7:	00 00 00 
  8057ba:	89 c7                	mov    %eax,%edi
  8057bc:	48 b8 2c 64 80 00 00 	movabs $0x80642c,%rax
  8057c3:	00 00 00 
  8057c6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8057c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8057cd:	be 00 00 00 00       	mov    $0x0,%esi
  8057d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8057d7:	48 b8 6c 63 80 00 00 	movabs $0x80636c,%rax
  8057de:	00 00 00 
  8057e1:	ff d0                	callq  *%rax
}
  8057e3:	c9                   	leaveq 
  8057e4:	c3                   	retq   

00000000008057e5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8057e5:	55                   	push   %rbp
  8057e6:	48 89 e5             	mov    %rsp,%rbp
  8057e9:	48 83 ec 30          	sub    $0x30,%rsp
  8057ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8057f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8057f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8057f8:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8057ff:	00 00 00 
  805802:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805805:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805807:	bf 01 00 00 00       	mov    $0x1,%edi
  80580c:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  805813:	00 00 00 
  805816:	ff d0                	callq  *%rax
  805818:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80581b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80581f:	78 3e                	js     80585f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  805821:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805828:	00 00 00 
  80582b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80582f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805833:	8b 40 10             	mov    0x10(%rax),%eax
  805836:	89 c2                	mov    %eax,%edx
  805838:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80583c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805840:	48 89 ce             	mov    %rcx,%rsi
  805843:	48 89 c7             	mov    %rax,%rdi
  805846:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  80584d:	00 00 00 
  805850:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  805852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805856:	8b 50 10             	mov    0x10(%rax),%edx
  805859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80585d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80585f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805862:	c9                   	leaveq 
  805863:	c3                   	retq   

0000000000805864 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805864:	55                   	push   %rbp
  805865:	48 89 e5             	mov    %rsp,%rbp
  805868:	48 83 ec 10          	sub    $0x10,%rsp
  80586c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80586f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805873:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  805876:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80587d:	00 00 00 
  805880:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805883:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  805885:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805888:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80588c:	48 89 c6             	mov    %rax,%rsi
  80588f:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805896:	00 00 00 
  805899:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  8058a0:	00 00 00 
  8058a3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8058a5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8058ac:	00 00 00 
  8058af:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8058b2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8058b5:	bf 02 00 00 00       	mov    $0x2,%edi
  8058ba:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  8058c1:	00 00 00 
  8058c4:	ff d0                	callq  *%rax
}
  8058c6:	c9                   	leaveq 
  8058c7:	c3                   	retq   

00000000008058c8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8058c8:	55                   	push   %rbp
  8058c9:	48 89 e5             	mov    %rsp,%rbp
  8058cc:	48 83 ec 10          	sub    $0x10,%rsp
  8058d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8058d3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8058d6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8058dd:	00 00 00 
  8058e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8058e3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8058e5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8058ec:	00 00 00 
  8058ef:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8058f2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8058f5:	bf 03 00 00 00       	mov    $0x3,%edi
  8058fa:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  805901:	00 00 00 
  805904:	ff d0                	callq  *%rax
}
  805906:	c9                   	leaveq 
  805907:	c3                   	retq   

0000000000805908 <nsipc_close>:

int
nsipc_close(int s)
{
  805908:	55                   	push   %rbp
  805909:	48 89 e5             	mov    %rsp,%rbp
  80590c:	48 83 ec 10          	sub    $0x10,%rsp
  805910:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  805913:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80591a:	00 00 00 
  80591d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805920:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  805922:	bf 04 00 00 00       	mov    $0x4,%edi
  805927:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  80592e:	00 00 00 
  805931:	ff d0                	callq  *%rax
}
  805933:	c9                   	leaveq 
  805934:	c3                   	retq   

0000000000805935 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805935:	55                   	push   %rbp
  805936:	48 89 e5             	mov    %rsp,%rbp
  805939:	48 83 ec 10          	sub    $0x10,%rsp
  80593d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805940:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805944:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  805947:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80594e:	00 00 00 
  805951:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805954:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  805956:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80595d:	48 89 c6             	mov    %rax,%rsi
  805960:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805967:	00 00 00 
  80596a:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  805971:	00 00 00 
  805974:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  805976:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80597d:	00 00 00 
  805980:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805983:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  805986:	bf 05 00 00 00       	mov    $0x5,%edi
  80598b:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  805992:	00 00 00 
  805995:	ff d0                	callq  *%rax
}
  805997:	c9                   	leaveq 
  805998:	c3                   	retq   

0000000000805999 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  805999:	55                   	push   %rbp
  80599a:	48 89 e5             	mov    %rsp,%rbp
  80599d:	48 83 ec 10          	sub    $0x10,%rsp
  8059a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8059a4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8059a7:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8059ae:	00 00 00 
  8059b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8059b4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8059b6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8059bd:	00 00 00 
  8059c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8059c3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8059c6:	bf 06 00 00 00       	mov    $0x6,%edi
  8059cb:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  8059d2:	00 00 00 
  8059d5:	ff d0                	callq  *%rax
}
  8059d7:	c9                   	leaveq 
  8059d8:	c3                   	retq   

00000000008059d9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8059d9:	55                   	push   %rbp
  8059da:	48 89 e5             	mov    %rsp,%rbp
  8059dd:	48 83 ec 30          	sub    $0x30,%rsp
  8059e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8059e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8059e8:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8059eb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8059ee:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8059f5:	00 00 00 
  8059f8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8059fb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8059fd:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a04:	00 00 00 
  805a07:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805a0a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  805a0d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a14:	00 00 00 
  805a17:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805a1a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  805a1d:	bf 07 00 00 00       	mov    $0x7,%edi
  805a22:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  805a29:	00 00 00 
  805a2c:	ff d0                	callq  *%rax
  805a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a35:	78 69                	js     805aa0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  805a37:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  805a3e:	7f 08                	jg     805a48 <nsipc_recv+0x6f>
  805a40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a43:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  805a46:	7e 35                	jle    805a7d <nsipc_recv+0xa4>
  805a48:	48 b9 b3 70 80 00 00 	movabs $0x8070b3,%rcx
  805a4f:	00 00 00 
  805a52:	48 ba c8 70 80 00 00 	movabs $0x8070c8,%rdx
  805a59:	00 00 00 
  805a5c:	be 61 00 00 00       	mov    $0x61,%esi
  805a61:	48 bf dd 70 80 00 00 	movabs $0x8070dd,%rdi
  805a68:	00 00 00 
  805a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  805a70:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  805a77:	00 00 00 
  805a7a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  805a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a80:	48 63 d0             	movslq %eax,%rdx
  805a83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a87:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  805a8e:	00 00 00 
  805a91:	48 89 c7             	mov    %rax,%rdi
  805a94:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  805a9b:	00 00 00 
  805a9e:	ff d0                	callq  *%rax
	}

	return r;
  805aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805aa3:	c9                   	leaveq 
  805aa4:	c3                   	retq   

0000000000805aa5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  805aa5:	55                   	push   %rbp
  805aa6:	48 89 e5             	mov    %rsp,%rbp
  805aa9:	48 83 ec 20          	sub    $0x20,%rsp
  805aad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805ab0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805ab4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805ab7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  805aba:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ac1:	00 00 00 
  805ac4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805ac7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  805ac9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  805ad0:	7e 35                	jle    805b07 <nsipc_send+0x62>
  805ad2:	48 b9 e9 70 80 00 00 	movabs $0x8070e9,%rcx
  805ad9:	00 00 00 
  805adc:	48 ba c8 70 80 00 00 	movabs $0x8070c8,%rdx
  805ae3:	00 00 00 
  805ae6:	be 6c 00 00 00       	mov    $0x6c,%esi
  805aeb:	48 bf dd 70 80 00 00 	movabs $0x8070dd,%rdi
  805af2:	00 00 00 
  805af5:	b8 00 00 00 00       	mov    $0x0,%eax
  805afa:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  805b01:	00 00 00 
  805b04:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  805b07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805b0a:	48 63 d0             	movslq %eax,%rdx
  805b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b11:	48 89 c6             	mov    %rax,%rsi
  805b14:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  805b1b:	00 00 00 
  805b1e:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  805b25:	00 00 00 
  805b28:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  805b2a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b31:	00 00 00 
  805b34:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805b37:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  805b3a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b41:	00 00 00 
  805b44:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805b47:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  805b4a:	bf 08 00 00 00       	mov    $0x8,%edi
  805b4f:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  805b56:	00 00 00 
  805b59:	ff d0                	callq  *%rax
}
  805b5b:	c9                   	leaveq 
  805b5c:	c3                   	retq   

0000000000805b5d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  805b5d:	55                   	push   %rbp
  805b5e:	48 89 e5             	mov    %rsp,%rbp
  805b61:	48 83 ec 10          	sub    $0x10,%rsp
  805b65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805b68:	89 75 f8             	mov    %esi,-0x8(%rbp)
  805b6b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  805b6e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b75:	00 00 00 
  805b78:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805b7b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  805b7d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b84:	00 00 00 
  805b87:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805b8a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  805b8d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b94:	00 00 00 
  805b97:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805b9a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  805b9d:	bf 09 00 00 00       	mov    $0x9,%edi
  805ba2:	48 b8 64 57 80 00 00 	movabs $0x805764,%rax
  805ba9:	00 00 00 
  805bac:	ff d0                	callq  *%rax
}
  805bae:	c9                   	leaveq 
  805baf:	c3                   	retq   

0000000000805bb0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805bb0:	55                   	push   %rbp
  805bb1:	48 89 e5             	mov    %rsp,%rbp
  805bb4:	53                   	push   %rbx
  805bb5:	48 83 ec 38          	sub    $0x38,%rsp
  805bb9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805bbd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805bc1:	48 89 c7             	mov    %rax,%rdi
  805bc4:	48 b8 d6 37 80 00 00 	movabs $0x8037d6,%rax
  805bcb:	00 00 00 
  805bce:	ff d0                	callq  *%rax
  805bd0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805bd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805bd7:	0f 88 bf 01 00 00    	js     805d9c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805bdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805be1:	ba 07 04 00 00       	mov    $0x407,%edx
  805be6:	48 89 c6             	mov    %rax,%rsi
  805be9:	bf 00 00 00 00       	mov    $0x0,%edi
  805bee:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  805bf5:	00 00 00 
  805bf8:	ff d0                	callq  *%rax
  805bfa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805bfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c01:	0f 88 95 01 00 00    	js     805d9c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805c07:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805c0b:	48 89 c7             	mov    %rax,%rdi
  805c0e:	48 b8 d6 37 80 00 00 	movabs $0x8037d6,%rax
  805c15:	00 00 00 
  805c18:	ff d0                	callq  *%rax
  805c1a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805c1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c21:	0f 88 5d 01 00 00    	js     805d84 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805c27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805c2b:	ba 07 04 00 00       	mov    $0x407,%edx
  805c30:	48 89 c6             	mov    %rax,%rsi
  805c33:	bf 00 00 00 00       	mov    $0x0,%edi
  805c38:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  805c3f:	00 00 00 
  805c42:	ff d0                	callq  *%rax
  805c44:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805c47:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c4b:	0f 88 33 01 00 00    	js     805d84 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805c51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805c55:	48 89 c7             	mov    %rax,%rdi
  805c58:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  805c5f:	00 00 00 
  805c62:	ff d0                	callq  *%rax
  805c64:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805c68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c6c:	ba 07 04 00 00       	mov    $0x407,%edx
  805c71:	48 89 c6             	mov    %rax,%rsi
  805c74:	bf 00 00 00 00       	mov    $0x0,%edi
  805c79:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  805c80:	00 00 00 
  805c83:	ff d0                	callq  *%rax
  805c85:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805c88:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c8c:	0f 88 d9 00 00 00    	js     805d6b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805c92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805c96:	48 89 c7             	mov    %rax,%rdi
  805c99:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  805ca0:	00 00 00 
  805ca3:	ff d0                	callq  *%rax
  805ca5:	48 89 c2             	mov    %rax,%rdx
  805ca8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805cac:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805cb2:	48 89 d1             	mov    %rdx,%rcx
  805cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  805cba:	48 89 c6             	mov    %rax,%rsi
  805cbd:	bf 00 00 00 00       	mov    $0x0,%edi
  805cc2:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  805cc9:	00 00 00 
  805ccc:	ff d0                	callq  *%rax
  805cce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805cd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805cd5:	78 79                	js     805d50 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  805cd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805cdb:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  805ce2:	00 00 00 
  805ce5:	8b 12                	mov    (%rdx),%edx
  805ce7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805ce9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ced:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  805cf4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805cf8:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  805cff:	00 00 00 
  805d02:	8b 12                	mov    (%rdx),%edx
  805d04:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805d06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d0a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805d11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805d15:	48 89 c7             	mov    %rax,%rdi
  805d18:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  805d1f:	00 00 00 
  805d22:	ff d0                	callq  *%rax
  805d24:	89 c2                	mov    %eax,%edx
  805d26:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805d2a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805d2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805d30:	48 8d 58 04          	lea    0x4(%rax),%rbx
  805d34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d38:	48 89 c7             	mov    %rax,%rdi
  805d3b:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  805d42:	00 00 00 
  805d45:	ff d0                	callq  *%rax
  805d47:	89 03                	mov    %eax,(%rbx)
	return 0;
  805d49:	b8 00 00 00 00       	mov    $0x0,%eax
  805d4e:	eb 4f                	jmp    805d9f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  805d50:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  805d51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d55:	48 89 c6             	mov    %rax,%rsi
  805d58:	bf 00 00 00 00       	mov    $0x0,%edi
  805d5d:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  805d64:	00 00 00 
  805d67:	ff d0                	callq  *%rax
  805d69:	eb 01                	jmp    805d6c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  805d6b:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  805d6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d70:	48 89 c6             	mov    %rax,%rsi
  805d73:	bf 00 00 00 00       	mov    $0x0,%edi
  805d78:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  805d7f:	00 00 00 
  805d82:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  805d84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805d88:	48 89 c6             	mov    %rax,%rsi
  805d8b:	bf 00 00 00 00       	mov    $0x0,%edi
  805d90:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  805d97:	00 00 00 
  805d9a:	ff d0                	callq  *%rax
    err:
	return r;
  805d9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805d9f:	48 83 c4 38          	add    $0x38,%rsp
  805da3:	5b                   	pop    %rbx
  805da4:	5d                   	pop    %rbp
  805da5:	c3                   	retq   

0000000000805da6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805da6:	55                   	push   %rbp
  805da7:	48 89 e5             	mov    %rsp,%rbp
  805daa:	53                   	push   %rbx
  805dab:	48 83 ec 28          	sub    $0x28,%rsp
  805daf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805db3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805db7:	eb 01                	jmp    805dba <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  805db9:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805dba:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  805dc1:	00 00 00 
  805dc4:	48 8b 00             	mov    (%rax),%rax
  805dc7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805dcd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  805dd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805dd4:	48 89 c7             	mov    %rax,%rdi
  805dd7:	48 b8 74 65 80 00 00 	movabs $0x806574,%rax
  805dde:	00 00 00 
  805de1:	ff d0                	callq  *%rax
  805de3:	89 c3                	mov    %eax,%ebx
  805de5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805de9:	48 89 c7             	mov    %rax,%rdi
  805dec:	48 b8 74 65 80 00 00 	movabs $0x806574,%rax
  805df3:	00 00 00 
  805df6:	ff d0                	callq  *%rax
  805df8:	39 c3                	cmp    %eax,%ebx
  805dfa:	0f 94 c0             	sete   %al
  805dfd:	0f b6 c0             	movzbl %al,%eax
  805e00:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  805e03:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  805e0a:	00 00 00 
  805e0d:	48 8b 00             	mov    (%rax),%rax
  805e10:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805e16:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  805e19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805e1c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805e1f:	75 0a                	jne    805e2b <_pipeisclosed+0x85>
			return ret;
  805e21:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  805e24:	48 83 c4 28          	add    $0x28,%rsp
  805e28:	5b                   	pop    %rbx
  805e29:	5d                   	pop    %rbp
  805e2a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  805e2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805e2e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805e31:	74 86                	je     805db9 <_pipeisclosed+0x13>
  805e33:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  805e37:	75 80                	jne    805db9 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805e39:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  805e40:	00 00 00 
  805e43:	48 8b 00             	mov    (%rax),%rax
  805e46:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805e4c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805e4f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805e52:	89 c6                	mov    %eax,%esi
  805e54:	48 bf fa 70 80 00 00 	movabs $0x8070fa,%rdi
  805e5b:	00 00 00 
  805e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  805e63:	49 b8 4f 14 80 00 00 	movabs $0x80144f,%r8
  805e6a:	00 00 00 
  805e6d:	41 ff d0             	callq  *%r8
	}
  805e70:	e9 44 ff ff ff       	jmpq   805db9 <_pipeisclosed+0x13>

0000000000805e75 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  805e75:	55                   	push   %rbp
  805e76:	48 89 e5             	mov    %rsp,%rbp
  805e79:	48 83 ec 30          	sub    $0x30,%rsp
  805e7d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805e80:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805e84:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805e87:	48 89 d6             	mov    %rdx,%rsi
  805e8a:	89 c7                	mov    %eax,%edi
  805e8c:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  805e93:	00 00 00 
  805e96:	ff d0                	callq  *%rax
  805e98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805e9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e9f:	79 05                	jns    805ea6 <pipeisclosed+0x31>
		return r;
  805ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ea4:	eb 31                	jmp    805ed7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805eaa:	48 89 c7             	mov    %rax,%rdi
  805ead:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  805eb4:	00 00 00 
  805eb7:	ff d0                	callq  *%rax
  805eb9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  805ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ec1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805ec5:	48 89 d6             	mov    %rdx,%rsi
  805ec8:	48 89 c7             	mov    %rax,%rdi
  805ecb:	48 b8 a6 5d 80 00 00 	movabs $0x805da6,%rax
  805ed2:	00 00 00 
  805ed5:	ff d0                	callq  *%rax
}
  805ed7:	c9                   	leaveq 
  805ed8:	c3                   	retq   

0000000000805ed9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805ed9:	55                   	push   %rbp
  805eda:	48 89 e5             	mov    %rsp,%rbp
  805edd:	48 83 ec 40          	sub    $0x40,%rsp
  805ee1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805ee5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805ee9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  805eed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ef1:	48 89 c7             	mov    %rax,%rdi
  805ef4:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  805efb:	00 00 00 
  805efe:	ff d0                	callq  *%rax
  805f00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805f04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805f0c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805f13:	00 
  805f14:	e9 97 00 00 00       	jmpq   805fb0 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  805f19:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805f1e:	74 09                	je     805f29 <devpipe_read+0x50>
				return i;
  805f20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f24:	e9 95 00 00 00       	jmpq   805fbe <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  805f29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805f2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f31:	48 89 d6             	mov    %rdx,%rsi
  805f34:	48 89 c7             	mov    %rax,%rdi
  805f37:	48 b8 a6 5d 80 00 00 	movabs $0x805da6,%rax
  805f3e:	00 00 00 
  805f41:	ff d0                	callq  *%rax
  805f43:	85 c0                	test   %eax,%eax
  805f45:	74 07                	je     805f4e <devpipe_read+0x75>
				return 0;
  805f47:	b8 00 00 00 00       	mov    $0x0,%eax
  805f4c:	eb 70                	jmp    805fbe <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  805f4e:	48 b8 66 2a 80 00 00 	movabs $0x802a66,%rax
  805f55:	00 00 00 
  805f58:	ff d0                	callq  *%rax
  805f5a:	eb 01                	jmp    805f5d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  805f5c:	90                   	nop
  805f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f61:	8b 10                	mov    (%rax),%edx
  805f63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f67:	8b 40 04             	mov    0x4(%rax),%eax
  805f6a:	39 c2                	cmp    %eax,%edx
  805f6c:	74 ab                	je     805f19 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805f76:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f7e:	8b 00                	mov    (%rax),%eax
  805f80:	89 c2                	mov    %eax,%edx
  805f82:	c1 fa 1f             	sar    $0x1f,%edx
  805f85:	c1 ea 1b             	shr    $0x1b,%edx
  805f88:	01 d0                	add    %edx,%eax
  805f8a:	83 e0 1f             	and    $0x1f,%eax
  805f8d:	29 d0                	sub    %edx,%eax
  805f8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805f93:	48 98                	cltq   
  805f95:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  805f9a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  805f9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805fa0:	8b 00                	mov    (%rax),%eax
  805fa2:	8d 50 01             	lea    0x1(%rax),%edx
  805fa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805fa9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805fab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805fb4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805fb8:	72 a2                	jb     805f5c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  805fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805fbe:	c9                   	leaveq 
  805fbf:	c3                   	retq   

0000000000805fc0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805fc0:	55                   	push   %rbp
  805fc1:	48 89 e5             	mov    %rsp,%rbp
  805fc4:	48 83 ec 40          	sub    $0x40,%rsp
  805fc8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805fcc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805fd0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  805fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fd8:	48 89 c7             	mov    %rax,%rdi
  805fdb:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  805fe2:	00 00 00 
  805fe5:	ff d0                	callq  *%rax
  805fe7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805feb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805fef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805ff3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805ffa:	00 
  805ffb:	e9 93 00 00 00       	jmpq   806093 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806000:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806004:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806008:	48 89 d6             	mov    %rdx,%rsi
  80600b:	48 89 c7             	mov    %rax,%rdi
  80600e:	48 b8 a6 5d 80 00 00 	movabs $0x805da6,%rax
  806015:	00 00 00 
  806018:	ff d0                	callq  *%rax
  80601a:	85 c0                	test   %eax,%eax
  80601c:	74 07                	je     806025 <devpipe_write+0x65>
				return 0;
  80601e:	b8 00 00 00 00       	mov    $0x0,%eax
  806023:	eb 7c                	jmp    8060a1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806025:	48 b8 66 2a 80 00 00 	movabs $0x802a66,%rax
  80602c:	00 00 00 
  80602f:	ff d0                	callq  *%rax
  806031:	eb 01                	jmp    806034 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806033:	90                   	nop
  806034:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806038:	8b 40 04             	mov    0x4(%rax),%eax
  80603b:	48 63 d0             	movslq %eax,%rdx
  80603e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806042:	8b 00                	mov    (%rax),%eax
  806044:	48 98                	cltq   
  806046:	48 83 c0 20          	add    $0x20,%rax
  80604a:	48 39 c2             	cmp    %rax,%rdx
  80604d:	73 b1                	jae    806000 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80604f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806053:	8b 40 04             	mov    0x4(%rax),%eax
  806056:	89 c2                	mov    %eax,%edx
  806058:	c1 fa 1f             	sar    $0x1f,%edx
  80605b:	c1 ea 1b             	shr    $0x1b,%edx
  80605e:	01 d0                	add    %edx,%eax
  806060:	83 e0 1f             	and    $0x1f,%eax
  806063:	29 d0                	sub    %edx,%eax
  806065:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806069:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80606d:	48 01 ca             	add    %rcx,%rdx
  806070:	0f b6 0a             	movzbl (%rdx),%ecx
  806073:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806077:	48 98                	cltq   
  806079:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80607d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806081:	8b 40 04             	mov    0x4(%rax),%eax
  806084:	8d 50 01             	lea    0x1(%rax),%edx
  806087:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80608b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80608e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806097:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80609b:	72 96                	jb     806033 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80609d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8060a1:	c9                   	leaveq 
  8060a2:	c3                   	retq   

00000000008060a3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8060a3:	55                   	push   %rbp
  8060a4:	48 89 e5             	mov    %rsp,%rbp
  8060a7:	48 83 ec 20          	sub    $0x20,%rsp
  8060ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8060af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8060b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060b7:	48 89 c7             	mov    %rax,%rdi
  8060ba:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  8060c1:	00 00 00 
  8060c4:	ff d0                	callq  *%rax
  8060c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8060ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8060ce:	48 be 0d 71 80 00 00 	movabs $0x80710d,%rsi
  8060d5:	00 00 00 
  8060d8:	48 89 c7             	mov    %rax,%rdi
  8060db:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8060e2:	00 00 00 
  8060e5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8060e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060eb:	8b 50 04             	mov    0x4(%rax),%edx
  8060ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060f2:	8b 00                	mov    (%rax),%eax
  8060f4:	29 c2                	sub    %eax,%edx
  8060f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8060fa:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  806100:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806104:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80610b:	00 00 00 
	stat->st_dev = &devpipe;
  80610e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806112:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  806119:	00 00 00 
  80611c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  806123:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806128:	c9                   	leaveq 
  806129:	c3                   	retq   

000000000080612a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80612a:	55                   	push   %rbp
  80612b:	48 89 e5             	mov    %rsp,%rbp
  80612e:	48 83 ec 10          	sub    $0x10,%rsp
  806132:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  806136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80613a:	48 89 c6             	mov    %rax,%rsi
  80613d:	bf 00 00 00 00       	mov    $0x0,%edi
  806142:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  806149:	00 00 00 
  80614c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80614e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806152:	48 89 c7             	mov    %rax,%rdi
  806155:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  80615c:	00 00 00 
  80615f:	ff d0                	callq  *%rax
  806161:	48 89 c6             	mov    %rax,%rsi
  806164:	bf 00 00 00 00       	mov    $0x0,%edi
  806169:	48 b8 4f 2b 80 00 00 	movabs $0x802b4f,%rax
  806170:	00 00 00 
  806173:	ff d0                	callq  *%rax
}
  806175:	c9                   	leaveq 
  806176:	c3                   	retq   
	...

0000000000806178 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  806178:	55                   	push   %rbp
  806179:	48 89 e5             	mov    %rsp,%rbp
  80617c:	48 83 ec 20          	sub    $0x20,%rsp
  806180:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  806183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806187:	75 35                	jne    8061be <wait+0x46>
  806189:	48 b9 14 71 80 00 00 	movabs $0x807114,%rcx
  806190:	00 00 00 
  806193:	48 ba 1f 71 80 00 00 	movabs $0x80711f,%rdx
  80619a:	00 00 00 
  80619d:	be 09 00 00 00       	mov    $0x9,%esi
  8061a2:	48 bf 34 71 80 00 00 	movabs $0x807134,%rdi
  8061a9:	00 00 00 
  8061ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8061b1:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  8061b8:	00 00 00 
  8061bb:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8061be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8061c1:	48 98                	cltq   
  8061c3:	48 89 c2             	mov    %rax,%rdx
  8061c6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8061cc:	48 89 d0             	mov    %rdx,%rax
  8061cf:	48 c1 e0 03          	shl    $0x3,%rax
  8061d3:	48 01 d0             	add    %rdx,%rax
  8061d6:	48 c1 e0 05          	shl    $0x5,%rax
  8061da:	48 89 c2             	mov    %rax,%rdx
  8061dd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8061e4:	00 00 00 
  8061e7:	48 01 d0             	add    %rdx,%rax
  8061ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8061ee:	eb 0c                	jmp    8061fc <wait+0x84>
		sys_yield();
  8061f0:	48 b8 66 2a 80 00 00 	movabs $0x802a66,%rax
  8061f7:	00 00 00 
  8061fa:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8061fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806200:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  806206:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  806209:	75 0e                	jne    806219 <wait+0xa1>
  80620b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80620f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  806215:	85 c0                	test   %eax,%eax
  806217:	75 d7                	jne    8061f0 <wait+0x78>
		sys_yield();
}
  806219:	c9                   	leaveq 
  80621a:	c3                   	retq   
	...

000000000080621c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80621c:	55                   	push   %rbp
  80621d:	48 89 e5             	mov    %rsp,%rbp
  806220:	48 83 ec 20          	sub    $0x20,%rsp
  806224:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  806228:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  80622f:	00 00 00 
  806232:	48 8b 00             	mov    (%rax),%rax
  806235:	48 85 c0             	test   %rax,%rax
  806238:	0f 85 8e 00 00 00    	jne    8062cc <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  80623e:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  806245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  80624c:	48 b8 28 2a 80 00 00 	movabs $0x802a28,%rax
  806253:	00 00 00 
  806256:	ff d0                	callq  *%rax
  806258:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  80625b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80625f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806262:	ba 07 00 00 00       	mov    $0x7,%edx
  806267:	48 89 ce             	mov    %rcx,%rsi
  80626a:	89 c7                	mov    %eax,%edi
  80626c:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  806273:	00 00 00 
  806276:	ff d0                	callq  *%rax
  806278:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  80627b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80627f:	74 30                	je     8062b1 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  806281:	8b 45 f0             	mov    -0x10(%rbp),%eax
  806284:	89 c1                	mov    %eax,%ecx
  806286:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  80628d:	00 00 00 
  806290:	be 24 00 00 00       	mov    $0x24,%esi
  806295:	48 bf 77 71 80 00 00 	movabs $0x807177,%rdi
  80629c:	00 00 00 
  80629f:	b8 00 00 00 00       	mov    $0x0,%eax
  8062a4:	49 b8 14 12 80 00 00 	movabs $0x801214,%r8
  8062ab:	00 00 00 
  8062ae:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8062b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8062b4:	48 be e0 62 80 00 00 	movabs $0x8062e0,%rsi
  8062bb:	00 00 00 
  8062be:	89 c7                	mov    %eax,%edi
  8062c0:	48 b8 2e 2c 80 00 00 	movabs $0x802c2e,%rax
  8062c7:	00 00 00 
  8062ca:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8062cc:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  8062d3:	00 00 00 
  8062d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8062da:	48 89 10             	mov    %rdx,(%rax)
}
  8062dd:	c9                   	leaveq 
  8062de:	c3                   	retq   
	...

00000000008062e0 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8062e0:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8062e3:	48 a1 00 e0 80 00 00 	movabs 0x80e000,%rax
  8062ea:	00 00 00 
	call *%rax
  8062ed:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  8062ef:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  8062f3:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  8062f7:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  8062fa:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  806301:	00 
		movq 120(%rsp), %rcx				// trap time rip
  806302:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  806307:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  80630a:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  80630b:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  80630e:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  806315:	00 08 
		POPA_						// copy the register contents to the registers
  806317:	4c 8b 3c 24          	mov    (%rsp),%r15
  80631b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  806320:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  806325:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80632a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80632f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  806334:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  806339:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80633e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  806343:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  806348:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80634d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  806352:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  806357:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80635c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  806361:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  806365:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  806369:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  80636a:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  80636b:	c3                   	retq   

000000000080636c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80636c:	55                   	push   %rbp
  80636d:	48 89 e5             	mov    %rsp,%rbp
  806370:	48 83 ec 30          	sub    $0x30,%rsp
  806374:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806378:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80637c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  806380:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806385:	74 18                	je     80639f <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  806387:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80638b:	48 89 c7             	mov    %rax,%rdi
  80638e:	48 b8 cd 2c 80 00 00 	movabs $0x802ccd,%rax
  806395:	00 00 00 
  806398:	ff d0                	callq  *%rax
  80639a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80639d:	eb 19                	jmp    8063b8 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80639f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8063a6:	00 00 00 
  8063a9:	48 b8 cd 2c 80 00 00 	movabs $0x802ccd,%rax
  8063b0:	00 00 00 
  8063b3:	ff d0                	callq  *%rax
  8063b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8063b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8063bc:	79 19                	jns    8063d7 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8063be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063c2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8063c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8063cc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8063d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063d5:	eb 53                	jmp    80642a <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8063d7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8063dc:	74 19                	je     8063f7 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8063de:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  8063e5:	00 00 00 
  8063e8:	48 8b 00             	mov    (%rax),%rax
  8063eb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8063f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063f5:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8063f7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8063fc:	74 19                	je     806417 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8063fe:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  806405:	00 00 00 
  806408:	48 8b 00             	mov    (%rax),%rax
  80640b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  806411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806415:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  806417:	48 b8 80 a4 80 00 00 	movabs $0x80a480,%rax
  80641e:	00 00 00 
  806421:	48 8b 00             	mov    (%rax),%rax
  806424:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80642a:	c9                   	leaveq 
  80642b:	c3                   	retq   

000000000080642c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80642c:	55                   	push   %rbp
  80642d:	48 89 e5             	mov    %rsp,%rbp
  806430:	48 83 ec 30          	sub    $0x30,%rsp
  806434:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806437:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80643a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80643e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  806441:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  806448:	e9 96 00 00 00       	jmpq   8064e3 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  80644d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806452:	74 20                	je     806474 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  806454:	8b 75 e8             	mov    -0x18(%rbp),%esi
  806457:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80645a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80645e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806461:	89 c7                	mov    %eax,%edi
  806463:	48 b8 78 2c 80 00 00 	movabs $0x802c78,%rax
  80646a:	00 00 00 
  80646d:	ff d0                	callq  *%rax
  80646f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806472:	eb 2d                	jmp    8064a1 <ipc_send+0x75>
		else if(pg==NULL)
  806474:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806479:	75 26                	jne    8064a1 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80647b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80647e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806481:	b9 00 00 00 00       	mov    $0x0,%ecx
  806486:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80648d:	00 00 00 
  806490:	89 c7                	mov    %eax,%edi
  806492:	48 b8 78 2c 80 00 00 	movabs $0x802c78,%rax
  806499:	00 00 00 
  80649c:	ff d0                	callq  *%rax
  80649e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8064a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064a5:	79 30                	jns    8064d7 <ipc_send+0xab>
  8064a7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8064ab:	74 2a                	je     8064d7 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8064ad:	48 ba 85 71 80 00 00 	movabs $0x807185,%rdx
  8064b4:	00 00 00 
  8064b7:	be 40 00 00 00       	mov    $0x40,%esi
  8064bc:	48 bf 9d 71 80 00 00 	movabs $0x80719d,%rdi
  8064c3:	00 00 00 
  8064c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8064cb:	48 b9 14 12 80 00 00 	movabs $0x801214,%rcx
  8064d2:	00 00 00 
  8064d5:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8064d7:	48 b8 66 2a 80 00 00 	movabs $0x802a66,%rax
  8064de:	00 00 00 
  8064e1:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8064e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064e7:	0f 85 60 ff ff ff    	jne    80644d <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8064ed:	c9                   	leaveq 
  8064ee:	c3                   	retq   

00000000008064ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8064ef:	55                   	push   %rbp
  8064f0:	48 89 e5             	mov    %rsp,%rbp
  8064f3:	48 83 ec 18          	sub    $0x18,%rsp
  8064f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8064fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806501:	eb 5e                	jmp    806561 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  806503:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80650a:	00 00 00 
  80650d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806510:	48 63 d0             	movslq %eax,%rdx
  806513:	48 89 d0             	mov    %rdx,%rax
  806516:	48 c1 e0 03          	shl    $0x3,%rax
  80651a:	48 01 d0             	add    %rdx,%rax
  80651d:	48 c1 e0 05          	shl    $0x5,%rax
  806521:	48 01 c8             	add    %rcx,%rax
  806524:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80652a:	8b 00                	mov    (%rax),%eax
  80652c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80652f:	75 2c                	jne    80655d <ipc_find_env+0x6e>
			return envs[i].env_id;
  806531:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  806538:	00 00 00 
  80653b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80653e:	48 63 d0             	movslq %eax,%rdx
  806541:	48 89 d0             	mov    %rdx,%rax
  806544:	48 c1 e0 03          	shl    $0x3,%rax
  806548:	48 01 d0             	add    %rdx,%rax
  80654b:	48 c1 e0 05          	shl    $0x5,%rax
  80654f:	48 01 c8             	add    %rcx,%rax
  806552:	48 05 c0 00 00 00    	add    $0xc0,%rax
  806558:	8b 40 08             	mov    0x8(%rax),%eax
  80655b:	eb 12                	jmp    80656f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80655d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  806561:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  806568:	7e 99                	jle    806503 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80656a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80656f:	c9                   	leaveq 
  806570:	c3                   	retq   
  806571:	00 00                	add    %al,(%rax)
	...

0000000000806574 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806574:	55                   	push   %rbp
  806575:	48 89 e5             	mov    %rsp,%rbp
  806578:	48 83 ec 18          	sub    $0x18,%rsp
  80657c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806584:	48 89 c2             	mov    %rax,%rdx
  806587:	48 c1 ea 15          	shr    $0x15,%rdx
  80658b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806592:	01 00 00 
  806595:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806599:	83 e0 01             	and    $0x1,%eax
  80659c:	48 85 c0             	test   %rax,%rax
  80659f:	75 07                	jne    8065a8 <pageref+0x34>
		return 0;
  8065a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8065a6:	eb 53                	jmp    8065fb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8065a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8065ac:	48 89 c2             	mov    %rax,%rdx
  8065af:	48 c1 ea 0c          	shr    $0xc,%rdx
  8065b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8065ba:	01 00 00 
  8065bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8065c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8065c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8065c9:	83 e0 01             	and    $0x1,%eax
  8065cc:	48 85 c0             	test   %rax,%rax
  8065cf:	75 07                	jne    8065d8 <pageref+0x64>
		return 0;
  8065d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8065d6:	eb 23                	jmp    8065fb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8065d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8065dc:	48 89 c2             	mov    %rax,%rdx
  8065df:	48 c1 ea 0c          	shr    $0xc,%rdx
  8065e3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8065ea:	00 00 00 
  8065ed:	48 c1 e2 04          	shl    $0x4,%rdx
  8065f1:	48 01 d0             	add    %rdx,%rax
  8065f4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8065f8:	0f b7 c0             	movzwl %ax,%eax
}
  8065fb:	c9                   	leaveq 
  8065fc:	c3                   	retq   
