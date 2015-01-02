
obj/user/faultregs.debug:     file format elf64-x86-64


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
  80003c:	e8 0b 0a 00 00       	callq  800a4c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 40          	sub    $0x40,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800050:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800054:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800058:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80005c:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	int mismatch = 0;
  800060:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800067:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80006b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80006f:	48 89 d1             	mov    %rdx,%rcx
  800072:	48 89 c2             	mov    %rax,%rdx
  800075:	48 be 00 47 80 00 00 	movabs $0x804700,%rsi
  80007c:	00 00 00 
  80007f:	48 bf 01 47 80 00 00 	movabs $0x804701,%rdi
  800086:	00 00 00 
  800089:	b8 00 00 00 00       	mov    $0x0,%eax
  80008e:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  800095:	00 00 00 
  800098:	41 ff d0             	callq  *%r8
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_rdi);
  80009b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80009f:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000a7:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000ab:	48 89 d1             	mov    %rdx,%rcx
  8000ae:	48 89 c2             	mov    %rax,%rdx
  8000b1:	48 be 11 47 80 00 00 	movabs $0x804711,%rsi
  8000b8:	00 00 00 
  8000bb:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  8000d1:	00 00 00 
  8000d4:	41 ff d0             	callq  *%r8
  8000d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000db:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e3:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e7:	48 39 c2             	cmp    %rax,%rdx
  8000ea:	75 1d                	jne    800109 <check_regs+0xc5>
  8000ec:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  8000f3:	00 00 00 
  8000f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fb:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800102:	00 00 00 
  800105:	ff d2                	callq  *%rdx
  800107:	eb 22                	jmp    80012b <check_regs+0xe7>
  800109:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  800110:	00 00 00 
  800113:	b8 00 00 00 00       	mov    $0x0,%eax
  800118:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  80011f:	00 00 00 
  800122:	ff d2                	callq  *%rdx
  800124:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esi, regs.reg_rsi);
  80012b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80012f:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800137:	48 8b 40 40          	mov    0x40(%rax),%rax
  80013b:	48 89 d1             	mov    %rdx,%rcx
  80013e:	48 89 c2             	mov    %rax,%rdx
  800141:	48 be 33 47 80 00 00 	movabs $0x804733,%rsi
  800148:	00 00 00 
  80014b:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  800152:	00 00 00 
  800155:	b8 00 00 00 00       	mov    $0x0,%eax
  80015a:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  800161:	00 00 00 
  800164:	41 ff d0             	callq  *%r8
  800167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016b:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800173:	48 8b 40 40          	mov    0x40(%rax),%rax
  800177:	48 39 c2             	cmp    %rax,%rdx
  80017a:	75 1d                	jne    800199 <check_regs+0x155>
  80017c:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  800183:	00 00 00 
  800186:	b8 00 00 00 00       	mov    $0x0,%eax
  80018b:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800192:	00 00 00 
  800195:	ff d2                	callq  *%rdx
  800197:	eb 22                	jmp    8001bb <check_regs+0x177>
  800199:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  8001a0:	00 00 00 
  8001a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a8:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8001af:	00 00 00 
  8001b2:	ff d2                	callq  *%rdx
  8001b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebp, regs.reg_rbp);
  8001bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8001bf:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001c7:	48 8b 40 50          	mov    0x50(%rax),%rax
  8001cb:	48 89 d1             	mov    %rdx,%rcx
  8001ce:	48 89 c2             	mov    %rax,%rdx
  8001d1:	48 be 37 47 80 00 00 	movabs $0x804737,%rsi
  8001d8:	00 00 00 
  8001db:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  8001e2:	00 00 00 
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  8001f1:	00 00 00 
  8001f4:	41 ff d0             	callq  *%r8
  8001f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fb:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800203:	48 8b 40 50          	mov    0x50(%rax),%rax
  800207:	48 39 c2             	cmp    %rax,%rdx
  80020a:	75 1d                	jne    800229 <check_regs+0x1e5>
  80020c:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  800213:	00 00 00 
  800216:	b8 00 00 00 00       	mov    $0x0,%eax
  80021b:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800222:	00 00 00 
  800225:	ff d2                	callq  *%rdx
  800227:	eb 22                	jmp    80024b <check_regs+0x207>
  800229:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  80023f:	00 00 00 
  800242:	ff d2                	callq  *%rdx
  800244:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebx, regs.reg_rbx);
  80024b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80024f:	48 8b 50 68          	mov    0x68(%rax),%rdx
  800253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800257:	48 8b 40 68          	mov    0x68(%rax),%rax
  80025b:	48 89 d1             	mov    %rdx,%rcx
  80025e:	48 89 c2             	mov    %rax,%rdx
  800261:	48 be 3b 47 80 00 00 	movabs $0x80473b,%rsi
  800268:	00 00 00 
  80026b:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  800272:	00 00 00 
  800275:	b8 00 00 00 00       	mov    $0x0,%eax
  80027a:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  800281:	00 00 00 
  800284:	41 ff d0             	callq  *%r8
  800287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028b:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800293:	48 8b 40 68          	mov    0x68(%rax),%rax
  800297:	48 39 c2             	cmp    %rax,%rdx
  80029a:	75 1d                	jne    8002b9 <check_regs+0x275>
  80029c:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  8002a3:	00 00 00 
  8002a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ab:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8002b2:	00 00 00 
  8002b5:	ff d2                	callq  *%rdx
  8002b7:	eb 22                	jmp    8002db <check_regs+0x297>
  8002b9:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8002cf:	00 00 00 
  8002d2:	ff d2                	callq  *%rdx
  8002d4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(edx, regs.reg_rdx);
  8002db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002df:	48 8b 50 58          	mov    0x58(%rax),%rdx
  8002e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e7:	48 8b 40 58          	mov    0x58(%rax),%rax
  8002eb:	48 89 d1             	mov    %rdx,%rcx
  8002ee:	48 89 c2             	mov    %rax,%rdx
  8002f1:	48 be 3f 47 80 00 00 	movabs $0x80473f,%rsi
  8002f8:	00 00 00 
  8002fb:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  800302:	00 00 00 
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  800311:	00 00 00 
  800314:	41 ff d0             	callq  *%r8
  800317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031b:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800323:	48 8b 40 58          	mov    0x58(%rax),%rax
  800327:	48 39 c2             	cmp    %rax,%rdx
  80032a:	75 1d                	jne    800349 <check_regs+0x305>
  80032c:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  800333:	00 00 00 
  800336:	b8 00 00 00 00       	mov    $0x0,%eax
  80033b:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800342:	00 00 00 
  800345:	ff d2                	callq  *%rdx
  800347:	eb 22                	jmp    80036b <check_regs+0x327>
  800349:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  800350:	00 00 00 
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  80035f:	00 00 00 
  800362:	ff d2                	callq  *%rdx
  800364:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ecx, regs.reg_rcx);
  80036b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036f:	48 8b 50 60          	mov    0x60(%rax),%rdx
  800373:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800377:	48 8b 40 60          	mov    0x60(%rax),%rax
  80037b:	48 89 d1             	mov    %rdx,%rcx
  80037e:	48 89 c2             	mov    %rax,%rdx
  800381:	48 be 43 47 80 00 00 	movabs $0x804743,%rsi
  800388:	00 00 00 
  80038b:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  800392:	00 00 00 
  800395:	b8 00 00 00 00       	mov    $0x0,%eax
  80039a:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  8003a1:	00 00 00 
  8003a4:	41 ff d0             	callq  *%r8
  8003a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ab:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b3:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b7:	48 39 c2             	cmp    %rax,%rdx
  8003ba:	75 1d                	jne    8003d9 <check_regs+0x395>
  8003bc:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx
  8003d7:	eb 22                	jmp    8003fb <check_regs+0x3b7>
  8003d9:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  8003e0:	00 00 00 
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8003ef:	00 00 00 
  8003f2:	ff d2                	callq  *%rdx
  8003f4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eax, regs.reg_rax);
  8003fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003ff:	48 8b 50 70          	mov    0x70(%rax),%rdx
  800403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800407:	48 8b 40 70          	mov    0x70(%rax),%rax
  80040b:	48 89 d1             	mov    %rdx,%rcx
  80040e:	48 89 c2             	mov    %rax,%rdx
  800411:	48 be 47 47 80 00 00 	movabs $0x804747,%rsi
  800418:	00 00 00 
  80041b:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  800422:	00 00 00 
  800425:	b8 00 00 00 00       	mov    $0x0,%eax
  80042a:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  800431:	00 00 00 
  800434:	41 ff d0             	callq  *%r8
  800437:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043b:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800443:	48 8b 40 70          	mov    0x70(%rax),%rax
  800447:	48 39 c2             	cmp    %rax,%rdx
  80044a:	75 1d                	jne    800469 <check_regs+0x425>
  80044c:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  800453:	00 00 00 
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
  80045b:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800462:	00 00 00 
  800465:	ff d2                	callq  *%rdx
  800467:	eb 22                	jmp    80048b <check_regs+0x447>
  800469:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  800470:	00 00 00 
  800473:	b8 00 00 00 00       	mov    $0x0,%eax
  800478:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  80047f:	00 00 00 
  800482:	ff d2                	callq  *%rdx
  800484:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eip, eip);
  80048b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80048f:	48 8b 50 78          	mov    0x78(%rax),%rdx
  800493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800497:	48 8b 40 78          	mov    0x78(%rax),%rax
  80049b:	48 89 d1             	mov    %rdx,%rcx
  80049e:	48 89 c2             	mov    %rax,%rdx
  8004a1:	48 be 4b 47 80 00 00 	movabs $0x80474b,%rsi
  8004a8:	00 00 00 
  8004ab:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  8004b2:	00 00 00 
  8004b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ba:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  8004c1:	00 00 00 
  8004c4:	41 ff d0             	callq  *%r8
  8004c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cb:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d3:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d7:	48 39 c2             	cmp    %rax,%rdx
  8004da:	75 1d                	jne    8004f9 <check_regs+0x4b5>
  8004dc:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  8004e3:	00 00 00 
  8004e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004eb:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8004f2:	00 00 00 
  8004f5:	ff d2                	callq  *%rdx
  8004f7:	eb 22                	jmp    80051b <check_regs+0x4d7>
  8004f9:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  800500:	00 00 00 
  800503:	b8 00 00 00 00       	mov    $0x0,%eax
  800508:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  80050f:	00 00 00 
  800512:	ff d2                	callq  *%rdx
  800514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eflags, eflags);
  80051b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051f:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052a:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800531:	48 89 d1             	mov    %rdx,%rcx
  800534:	48 89 c2             	mov    %rax,%rdx
  800537:	48 be 4f 47 80 00 00 	movabs $0x80474f,%rsi
  80053e:	00 00 00 
  800541:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  800548:	00 00 00 
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  800557:	00 00 00 
  80055a:	41 ff d0             	callq  *%r8
  80055d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800561:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056c:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800573:	48 39 c2             	cmp    %rax,%rdx
  800576:	75 1d                	jne    800595 <check_regs+0x551>
  800578:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  80057f:	00 00 00 
  800582:	b8 00 00 00 00       	mov    $0x0,%eax
  800587:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  80058e:	00 00 00 
  800591:	ff d2                	callq  *%rdx
  800593:	eb 22                	jmp    8005b7 <check_regs+0x573>
  800595:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  80059c:	00 00 00 
  80059f:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a4:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8005ab:	00 00 00 
  8005ae:	ff d2                	callq  *%rdx
  8005b0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esp, esp);
  8005b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005bb:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8005c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c6:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  8005cd:	48 89 d1             	mov    %rdx,%rcx
  8005d0:	48 89 c2             	mov    %rax,%rdx
  8005d3:	48 be 56 47 80 00 00 	movabs $0x804756,%rsi
  8005da:	00 00 00 
  8005dd:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  8005e4:	00 00 00 
  8005e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ec:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  8005f3:	00 00 00 
  8005f6:	41 ff d0             	callq  *%r8
  8005f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fd:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800608:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060f:	48 39 c2             	cmp    %rax,%rdx
  800612:	75 1d                	jne    800631 <check_regs+0x5ed>
  800614:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  80061b:	00 00 00 
  80061e:	b8 00 00 00 00       	mov    $0x0,%eax
  800623:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  80062a:	00 00 00 
  80062d:	ff d2                	callq  *%rdx
  80062f:	eb 22                	jmp    800653 <check_regs+0x60f>
  800631:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  800638:	00 00 00 
  80063b:	b8 00 00 00 00       	mov    $0x0,%eax
  800640:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800647:	00 00 00 
  80064a:	ff d2                	callq  *%rdx
  80064c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

#undef CHECK

	cprintf("Registers %s ", testname);
  800653:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800657:	48 89 c6             	mov    %rax,%rsi
  80065a:	48 bf 5a 47 80 00 00 	movabs $0x80475a,%rdi
  800661:	00 00 00 
  800664:	b8 00 00 00 00       	mov    $0x0,%eax
  800669:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800670:	00 00 00 
  800673:	ff d2                	callq  *%rdx
	if (!mismatch)
  800675:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800679:	75 1d                	jne    800698 <check_regs+0x654>
		cprintf("OK\n");
  80067b:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  800682:	00 00 00 
  800685:	b8 00 00 00 00       	mov    $0x0,%eax
  80068a:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800691:	00 00 00 
  800694:	ff d2                	callq  *%rdx
  800696:	eb 1b                	jmp    8006b3 <check_regs+0x66f>
	else
		cprintf("MISMATCH\n");
  800698:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  80069f:	00 00 00 
  8006a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a7:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8006ae:	00 00 00 
  8006b1:	ff d2                	callq  *%rdx
}
  8006b3:	c9                   	leaveq 
  8006b4:	c3                   	retq   

00000000008006b5 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8006b5:	55                   	push   %rbp
  8006b6:	48 89 e5             	mov    %rsp,%rbp
  8006b9:	48 83 ec 20          	sub    $0x20,%rsp
  8006bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (utf->utf_fault_va != (uint64_t)UTEMP)
  8006c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c5:	48 8b 00             	mov    (%rax),%rax
  8006c8:	48 3d 00 00 40 00    	cmp    $0x400000,%rax
  8006ce:	74 43                	je     800713 <pgfault+0x5e>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	48 8b 00             	mov    (%rax),%rax
  8006e2:	49 89 d0             	mov    %rdx,%r8
  8006e5:	48 89 c1             	mov    %rax,%rcx
  8006e8:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  8006ef:	00 00 00 
  8006f2:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006f7:	48 bf 99 47 80 00 00 	movabs $0x804799,%rdi
  8006fe:	00 00 00 
  800701:	b8 00 00 00 00       	mov    $0x0,%eax
  800706:	49 b9 14 0b 80 00 00 	movabs $0x800b14,%r9
  80070d:	00 00 00 
  800710:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  800713:	48 b8 c0 70 80 00 00 	movabs $0x8070c0,%rax
  80071a:	00 00 00 
  80071d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800721:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  800725:	48 89 08             	mov    %rcx,(%rax)
  800728:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  80072c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800730:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  800734:	48 89 48 10          	mov    %rcx,0x10(%rax)
  800738:	48 8b 4a 28          	mov    0x28(%rdx),%rcx
  80073c:	48 89 48 18          	mov    %rcx,0x18(%rax)
  800740:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
  800744:	48 89 48 20          	mov    %rcx,0x20(%rax)
  800748:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
  80074c:	48 89 48 28          	mov    %rcx,0x28(%rax)
  800750:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  800754:	48 89 48 30          	mov    %rcx,0x30(%rax)
  800758:	48 8b 4a 48          	mov    0x48(%rdx),%rcx
  80075c:	48 89 48 38          	mov    %rcx,0x38(%rax)
  800760:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
  800764:	48 89 48 40          	mov    %rcx,0x40(%rax)
  800768:	48 8b 4a 58          	mov    0x58(%rdx),%rcx
  80076c:	48 89 48 48          	mov    %rcx,0x48(%rax)
  800770:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
  800774:	48 89 48 50          	mov    %rcx,0x50(%rax)
  800778:	48 8b 4a 68          	mov    0x68(%rdx),%rcx
  80077c:	48 89 48 58          	mov    %rcx,0x58(%rax)
  800780:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
  800784:	48 89 48 60          	mov    %rcx,0x60(%rax)
  800788:	48 8b 4a 78          	mov    0x78(%rdx),%rcx
  80078c:	48 89 48 68          	mov    %rcx,0x68(%rax)
  800790:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  800797:	48 89 50 70          	mov    %rdx,0x70(%rax)
	during.eip = utf->utf_rip;
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8007a6:	48 b8 c0 70 80 00 00 	movabs $0x8070c0,%rax
  8007ad:	00 00 00 
  8007b0:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  8007b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b8:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007bf:	48 89 c2             	mov    %rax,%rdx
  8007c2:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8007c8:	48 b8 c0 70 80 00 00 	movabs $0x8070c0,%rax
  8007cf:	00 00 00 
  8007d2:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dd:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007e4:	48 b8 c0 70 80 00 00 	movabs $0x8070c0,%rax
  8007eb:	00 00 00 
  8007ee:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007f5:	49 b8 aa 47 80 00 00 	movabs $0x8047aa,%r8
  8007fc:	00 00 00 
  8007ff:	48 b9 b8 47 80 00 00 	movabs $0x8047b8,%rcx
  800806:	00 00 00 
  800809:	48 ba c0 70 80 00 00 	movabs $0x8070c0,%rdx
  800810:	00 00 00 
  800813:	48 be bf 47 80 00 00 	movabs $0x8047bf,%rsi
  80081a:	00 00 00 
  80081d:	48 bf 20 70 80 00 00 	movabs $0x807020,%rdi
  800824:	00 00 00 
  800827:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80082e:	00 00 00 
  800831:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800833:	ba 07 00 00 00       	mov    $0x7,%edx
  800838:	be 00 00 40 00       	mov    $0x400000,%esi
  80083d:	bf 00 00 00 00       	mov    $0x0,%edi
  800842:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  800849:	00 00 00 
  80084c:	ff d0                	callq  *%rax
  80084e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800851:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800855:	79 30                	jns    800887 <pgfault+0x1d2>
		panic("sys_page_alloc: %e", r);
  800857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80085a:	89 c1                	mov    %eax,%ecx
  80085c:	48 ba c6 47 80 00 00 	movabs $0x8047c6,%rdx
  800863:	00 00 00 
  800866:	be 6a 00 00 00       	mov    $0x6a,%esi
  80086b:	48 bf 99 47 80 00 00 	movabs $0x804799,%rdi
  800872:	00 00 00 
  800875:	b8 00 00 00 00       	mov    $0x0,%eax
  80087a:	49 b8 14 0b 80 00 00 	movabs $0x800b14,%r8
  800881:	00 00 00 
  800884:	41 ff d0             	callq  *%r8
}
  800887:	c9                   	leaveq 
  800888:	c3                   	retq   

0000000000800889 <umain>:

void
umain(int argc, char **argv)
{
  800889:	55                   	push   %rbp
  80088a:	48 89 e5             	mov    %rsp,%rbp
  80088d:	48 83 ec 10          	sub    $0x10,%rsp
  800891:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800894:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(pgfault);
  800898:	48 bf b5 06 80 00 00 	movabs $0x8006b5,%rdi
  80089f:	00 00 00 
  8008a2:	48 b8 84 25 80 00 00 	movabs $0x802584,%rax
  8008a9:	00 00 00 
  8008ac:	ff d0                	callq  *%rax

	__asm __volatile(
  8008ae:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8008b5:	00 00 00 
  8008b8:	48 ba 60 71 80 00 00 	movabs $0x807160,%rdx
  8008bf:	00 00 00 
  8008c2:	50                   	push   %rax
  8008c3:	52                   	push   %rdx
  8008c4:	50                   	push   %rax
  8008c5:	9c                   	pushfq 
  8008c6:	58                   	pop    %rax
  8008c7:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  8008cd:	50                   	push   %rax
  8008ce:	9d                   	popfq  
  8008cf:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  8008d4:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8008db:	48 8d 04 25 27 09 80 	lea    0x800927,%rax
  8008e2:	00 
  8008e3:	49 89 47 78          	mov    %rax,0x78(%r15)
  8008e7:	58                   	pop    %rax
  8008e8:	4d 89 77 08          	mov    %r14,0x8(%r15)
  8008ec:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  8008f0:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8008f4:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  8008f8:	4d 89 57 28          	mov    %r10,0x28(%r15)
  8008fc:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800900:	4d 89 47 38          	mov    %r8,0x38(%r15)
  800904:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800908:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  80090c:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800910:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800914:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800918:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  80091c:	49 89 47 70          	mov    %rax,0x70(%r15)
  800920:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800927:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  80092e:	2a 00 00 00 
  800932:	4c 8b 3c 24          	mov    (%rsp),%r15
  800936:	4d 89 77 08          	mov    %r14,0x8(%r15)
  80093a:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  80093e:	4d 89 67 18          	mov    %r12,0x18(%r15)
  800942:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800946:	4d 89 57 28          	mov    %r10,0x28(%r15)
  80094a:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  80094e:	4d 89 47 38          	mov    %r8,0x38(%r15)
  800952:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800956:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  80095a:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  80095e:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800962:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800966:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  80096a:	49 89 47 70          	mov    %rax,0x70(%r15)
  80096e:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800975:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  80097a:	4d 8b 77 08          	mov    0x8(%r15),%r14
  80097e:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  800982:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800986:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  80098a:	4d 8b 57 28          	mov    0x28(%r15),%r10
  80098e:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  800992:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800996:	49 8b 77 40          	mov    0x40(%r15),%rsi
  80099a:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  80099e:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  8009a2:	49 8b 57 58          	mov    0x58(%r15),%rdx
  8009a6:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  8009aa:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  8009ae:	49 8b 47 70          	mov    0x70(%r15),%rax
  8009b2:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  8009b9:	50                   	push   %rax
  8009ba:	9c                   	pushfq 
  8009bb:	58                   	pop    %rax
  8009bc:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  8009c1:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8009c8:	58                   	pop    %rax
		: : "r" (&before), "r" (&after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  8009c9:	b8 00 00 40 00       	mov    $0x400000,%eax
  8009ce:	8b 00                	mov    (%rax),%eax
  8009d0:	83 f8 2a             	cmp    $0x2a,%eax
  8009d3:	74 1b                	je     8009f0 <umain+0x167>
		cprintf("EIP after page-fault MISMATCH\n");
  8009d5:	48 bf e0 47 80 00 00 	movabs $0x8047e0,%rdi
  8009dc:	00 00 00 
  8009df:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e4:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  8009eb:	00 00 00 
  8009ee:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009f0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8009f7:	00 00 00 
  8009fa:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009fe:	48 b8 60 71 80 00 00 	movabs $0x807160,%rax
  800a05:	00 00 00 
  800a08:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  800a0c:	49 b8 ff 47 80 00 00 	movabs $0x8047ff,%r8
  800a13:	00 00 00 
  800a16:	48 b9 10 48 80 00 00 	movabs $0x804810,%rcx
  800a1d:	00 00 00 
  800a20:	48 ba 60 71 80 00 00 	movabs $0x807160,%rdx
  800a27:	00 00 00 
  800a2a:	48 be bf 47 80 00 00 	movabs $0x8047bf,%rsi
  800a31:	00 00 00 
  800a34:	48 bf 20 70 80 00 00 	movabs $0x807020,%rdi
  800a3b:	00 00 00 
  800a3e:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800a45:	00 00 00 
  800a48:	ff d0                	callq  *%rax
}
  800a4a:	c9                   	leaveq 
  800a4b:	c3                   	retq   

0000000000800a4c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a4c:	55                   	push   %rbp
  800a4d:	48 89 e5             	mov    %rsp,%rbp
  800a50:	48 83 ec 10          	sub    $0x10,%rsp
  800a54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800a5b:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  800a62:	00 00 00 
  800a65:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800a6c:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  800a73:	00 00 00 
  800a76:	ff d0                	callq  *%rax
  800a78:	48 98                	cltq   
  800a7a:	48 89 c2             	mov    %rax,%rdx
  800a7d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800a83:	48 89 d0             	mov    %rdx,%rax
  800a86:	48 c1 e0 03          	shl    $0x3,%rax
  800a8a:	48 01 d0             	add    %rdx,%rax
  800a8d:	48 c1 e0 05          	shl    $0x5,%rax
  800a91:	48 89 c2             	mov    %rax,%rdx
  800a94:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800a9b:	00 00 00 
  800a9e:	48 01 c2             	add    %rax,%rdx
  800aa1:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  800aa8:	00 00 00 
  800aab:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800aae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ab2:	7e 14                	jle    800ac8 <libmain+0x7c>
		binaryname = argv[0];
  800ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ab8:	48 8b 10             	mov    (%rax),%rdx
  800abb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ac2:	00 00 00 
  800ac5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800ac8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800acc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800acf:	48 89 d6             	mov    %rdx,%rsi
  800ad2:	89 c7                	mov    %eax,%edi
  800ad4:	48 b8 89 08 80 00 00 	movabs $0x800889,%rax
  800adb:	00 00 00 
  800ade:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800ae0:	48 b8 f0 0a 80 00 00 	movabs $0x800af0,%rax
  800ae7:	00 00 00 
  800aea:	ff d0                	callq  *%rax
}
  800aec:	c9                   	leaveq 
  800aed:	c3                   	retq   
	...

0000000000800af0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800af0:	55                   	push   %rbp
  800af1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800af4:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  800afb:	00 00 00 
  800afe:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800b00:	bf 00 00 00 00       	mov    $0x0,%edi
  800b05:	48 b8 84 21 80 00 00 	movabs $0x802184,%rax
  800b0c:	00 00 00 
  800b0f:	ff d0                	callq  *%rax
}
  800b11:	5d                   	pop    %rbp
  800b12:	c3                   	retq   
	...

0000000000800b14 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800b14:	55                   	push   %rbp
  800b15:	48 89 e5             	mov    %rsp,%rbp
  800b18:	53                   	push   %rbx
  800b19:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800b20:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800b27:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b2d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b34:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b3b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b42:	84 c0                	test   %al,%al
  800b44:	74 23                	je     800b69 <_panic+0x55>
  800b46:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b4d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b51:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b55:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b59:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b5d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b61:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b65:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b69:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b70:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b77:	00 00 00 
  800b7a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b81:	00 00 00 
  800b84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b88:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b8f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b96:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b9d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ba4:	00 00 00 
  800ba7:	48 8b 18             	mov    (%rax),%rbx
  800baa:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  800bb1:	00 00 00 
  800bb4:	ff d0                	callq  *%rax
  800bb6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800bbc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bc3:	41 89 c8             	mov    %ecx,%r8d
  800bc6:	48 89 d1             	mov    %rdx,%rcx
  800bc9:	48 89 da             	mov    %rbx,%rdx
  800bcc:	89 c6                	mov    %eax,%esi
  800bce:	48 bf 20 48 80 00 00 	movabs $0x804820,%rdi
  800bd5:	00 00 00 
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	49 b9 4f 0d 80 00 00 	movabs $0x800d4f,%r9
  800be4:	00 00 00 
  800be7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bea:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bf1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bf8:	48 89 d6             	mov    %rdx,%rsi
  800bfb:	48 89 c7             	mov    %rax,%rdi
  800bfe:	48 b8 a3 0c 80 00 00 	movabs $0x800ca3,%rax
  800c05:	00 00 00 
  800c08:	ff d0                	callq  *%rax
	cprintf("\n");
  800c0a:	48 bf 43 48 80 00 00 	movabs $0x804843,%rdi
  800c11:	00 00 00 
  800c14:	b8 00 00 00 00       	mov    $0x0,%eax
  800c19:	48 ba 4f 0d 80 00 00 	movabs $0x800d4f,%rdx
  800c20:	00 00 00 
  800c23:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c25:	cc                   	int3   
  800c26:	eb fd                	jmp    800c25 <_panic+0x111>

0000000000800c28 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800c28:	55                   	push   %rbp
  800c29:	48 89 e5             	mov    %rsp,%rbp
  800c2c:	48 83 ec 10          	sub    $0x10,%rsp
  800c30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3b:	8b 00                	mov    (%rax),%eax
  800c3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c40:	89 d6                	mov    %edx,%esi
  800c42:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800c46:	48 63 d0             	movslq %eax,%rdx
  800c49:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800c4e:	8d 50 01             	lea    0x1(%rax),%edx
  800c51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c55:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800c57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5b:	8b 00                	mov    (%rax),%eax
  800c5d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c62:	75 2c                	jne    800c90 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800c64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c68:	8b 00                	mov    (%rax),%eax
  800c6a:	48 98                	cltq   
  800c6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c70:	48 83 c2 08          	add    $0x8,%rdx
  800c74:	48 89 c6             	mov    %rax,%rsi
  800c77:	48 89 d7             	mov    %rdx,%rdi
  800c7a:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  800c81:	00 00 00 
  800c84:	ff d0                	callq  *%rax
		b->idx = 0;
  800c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c94:	8b 40 04             	mov    0x4(%rax),%eax
  800c97:	8d 50 01             	lea    0x1(%rax),%edx
  800c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800ca1:	c9                   	leaveq 
  800ca2:	c3                   	retq   

0000000000800ca3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800ca3:	55                   	push   %rbp
  800ca4:	48 89 e5             	mov    %rsp,%rbp
  800ca7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800cae:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800cb5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800cbc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800cc3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800cca:	48 8b 0a             	mov    (%rdx),%rcx
  800ccd:	48 89 08             	mov    %rcx,(%rax)
  800cd0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cd4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cd8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cdc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800ce0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ce7:	00 00 00 
	b.cnt = 0;
  800cea:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cf1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800cf4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cfb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800d02:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800d09:	48 89 c6             	mov    %rax,%rsi
  800d0c:	48 bf 28 0c 80 00 00 	movabs $0x800c28,%rdi
  800d13:	00 00 00 
  800d16:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  800d1d:	00 00 00 
  800d20:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800d22:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800d28:	48 98                	cltq   
  800d2a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d31:	48 83 c2 08          	add    $0x8,%rdx
  800d35:	48 89 c6             	mov    %rax,%rsi
  800d38:	48 89 d7             	mov    %rdx,%rdi
  800d3b:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  800d42:	00 00 00 
  800d45:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800d47:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d4d:	c9                   	leaveq 
  800d4e:	c3                   	retq   

0000000000800d4f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800d4f:	55                   	push   %rbp
  800d50:	48 89 e5             	mov    %rsp,%rbp
  800d53:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d5a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d61:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d68:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d6f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d76:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d7d:	84 c0                	test   %al,%al
  800d7f:	74 20                	je     800da1 <cprintf+0x52>
  800d81:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d85:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d89:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d8d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d91:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d95:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d99:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d9d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800da1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800da8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800daf:	00 00 00 
  800db2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800db9:	00 00 00 
  800dbc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dc7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dd5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ddc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800de3:	48 8b 0a             	mov    (%rdx),%rcx
  800de6:	48 89 08             	mov    %rcx,(%rax)
  800de9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ded:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800df1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800df5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800df9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800e00:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e07:	48 89 d6             	mov    %rdx,%rsi
  800e0a:	48 89 c7             	mov    %rax,%rdi
  800e0d:	48 b8 a3 0c 80 00 00 	movabs $0x800ca3,%rax
  800e14:	00 00 00 
  800e17:	ff d0                	callq  *%rax
  800e19:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800e1f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e25:	c9                   	leaveq 
  800e26:	c3                   	retq   
	...

0000000000800e28 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e28:	55                   	push   %rbp
  800e29:	48 89 e5             	mov    %rsp,%rbp
  800e2c:	48 83 ec 30          	sub    $0x30,%rsp
  800e30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800e38:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e3c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800e3f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800e43:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e47:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800e4a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800e4e:	77 52                	ja     800ea2 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e50:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800e53:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e57:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800e5a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800e5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
  800e67:	48 f7 75 d0          	divq   -0x30(%rbp)
  800e6b:	48 89 c2             	mov    %rax,%rdx
  800e6e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e71:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e74:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800e78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e7c:	41 89 f9             	mov    %edi,%r9d
  800e7f:	48 89 c7             	mov    %rax,%rdi
  800e82:	48 b8 28 0e 80 00 00 	movabs $0x800e28,%rax
  800e89:	00 00 00 
  800e8c:	ff d0                	callq  *%rax
  800e8e:	eb 1c                	jmp    800eac <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e94:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e97:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800e9b:	48 89 d6             	mov    %rdx,%rsi
  800e9e:	89 c7                	mov    %eax,%edi
  800ea0:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ea2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800ea6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800eaa:	7f e4                	jg     800e90 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800eac:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb8:	48 f7 f1             	div    %rcx
  800ebb:	48 89 d0             	mov    %rdx,%rax
  800ebe:	48 ba 28 4a 80 00 00 	movabs $0x804a28,%rdx
  800ec5:	00 00 00 
  800ec8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800ecc:	0f be c0             	movsbl %al,%eax
  800ecf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ed3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800ed7:	48 89 d6             	mov    %rdx,%rsi
  800eda:	89 c7                	mov    %eax,%edi
  800edc:	ff d1                	callq  *%rcx
}
  800ede:	c9                   	leaveq 
  800edf:	c3                   	retq   

0000000000800ee0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ee0:	55                   	push   %rbp
  800ee1:	48 89 e5             	mov    %rsp,%rbp
  800ee4:	48 83 ec 20          	sub    $0x20,%rsp
  800ee8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800eef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ef3:	7e 52                	jle    800f47 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef9:	8b 00                	mov    (%rax),%eax
  800efb:	83 f8 30             	cmp    $0x30,%eax
  800efe:	73 24                	jae    800f24 <getuint+0x44>
  800f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f04:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0c:	8b 00                	mov    (%rax),%eax
  800f0e:	89 c0                	mov    %eax,%eax
  800f10:	48 01 d0             	add    %rdx,%rax
  800f13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f17:	8b 12                	mov    (%rdx),%edx
  800f19:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f20:	89 0a                	mov    %ecx,(%rdx)
  800f22:	eb 17                	jmp    800f3b <getuint+0x5b>
  800f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f28:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f2c:	48 89 d0             	mov    %rdx,%rax
  800f2f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f37:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f3b:	48 8b 00             	mov    (%rax),%rax
  800f3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f42:	e9 a3 00 00 00       	jmpq   800fea <getuint+0x10a>
	else if (lflag)
  800f47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f4b:	74 4f                	je     800f9c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f51:	8b 00                	mov    (%rax),%eax
  800f53:	83 f8 30             	cmp    $0x30,%eax
  800f56:	73 24                	jae    800f7c <getuint+0x9c>
  800f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f64:	8b 00                	mov    (%rax),%eax
  800f66:	89 c0                	mov    %eax,%eax
  800f68:	48 01 d0             	add    %rdx,%rax
  800f6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f6f:	8b 12                	mov    (%rdx),%edx
  800f71:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f78:	89 0a                	mov    %ecx,(%rdx)
  800f7a:	eb 17                	jmp    800f93 <getuint+0xb3>
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f84:	48 89 d0             	mov    %rdx,%rax
  800f87:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f93:	48 8b 00             	mov    (%rax),%rax
  800f96:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f9a:	eb 4e                	jmp    800fea <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa0:	8b 00                	mov    (%rax),%eax
  800fa2:	83 f8 30             	cmp    $0x30,%eax
  800fa5:	73 24                	jae    800fcb <getuint+0xeb>
  800fa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb3:	8b 00                	mov    (%rax),%eax
  800fb5:	89 c0                	mov    %eax,%eax
  800fb7:	48 01 d0             	add    %rdx,%rax
  800fba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fbe:	8b 12                	mov    (%rdx),%edx
  800fc0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fc3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fc7:	89 0a                	mov    %ecx,(%rdx)
  800fc9:	eb 17                	jmp    800fe2 <getuint+0x102>
  800fcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fcf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fd3:	48 89 d0             	mov    %rdx,%rax
  800fd6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fde:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fe2:	8b 00                	mov    (%rax),%eax
  800fe4:	89 c0                	mov    %eax,%eax
  800fe6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fee:	c9                   	leaveq 
  800fef:	c3                   	retq   

0000000000800ff0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 83 ec 20          	sub    $0x20,%rsp
  800ff8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801003:	7e 52                	jle    801057 <getint+0x67>
		x=va_arg(*ap, long long);
  801005:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801009:	8b 00                	mov    (%rax),%eax
  80100b:	83 f8 30             	cmp    $0x30,%eax
  80100e:	73 24                	jae    801034 <getint+0x44>
  801010:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801014:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101c:	8b 00                	mov    (%rax),%eax
  80101e:	89 c0                	mov    %eax,%eax
  801020:	48 01 d0             	add    %rdx,%rax
  801023:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801027:	8b 12                	mov    (%rdx),%edx
  801029:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80102c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801030:	89 0a                	mov    %ecx,(%rdx)
  801032:	eb 17                	jmp    80104b <getint+0x5b>
  801034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801038:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80103c:	48 89 d0             	mov    %rdx,%rax
  80103f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801043:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801047:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80104b:	48 8b 00             	mov    (%rax),%rax
  80104e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801052:	e9 a3 00 00 00       	jmpq   8010fa <getint+0x10a>
	else if (lflag)
  801057:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80105b:	74 4f                	je     8010ac <getint+0xbc>
		x=va_arg(*ap, long);
  80105d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801061:	8b 00                	mov    (%rax),%eax
  801063:	83 f8 30             	cmp    $0x30,%eax
  801066:	73 24                	jae    80108c <getint+0x9c>
  801068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801074:	8b 00                	mov    (%rax),%eax
  801076:	89 c0                	mov    %eax,%eax
  801078:	48 01 d0             	add    %rdx,%rax
  80107b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80107f:	8b 12                	mov    (%rdx),%edx
  801081:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801084:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801088:	89 0a                	mov    %ecx,(%rdx)
  80108a:	eb 17                	jmp    8010a3 <getint+0xb3>
  80108c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801090:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801094:	48 89 d0             	mov    %rdx,%rax
  801097:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80109b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010a3:	48 8b 00             	mov    (%rax),%rax
  8010a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8010aa:	eb 4e                	jmp    8010fa <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8010ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b0:	8b 00                	mov    (%rax),%eax
  8010b2:	83 f8 30             	cmp    $0x30,%eax
  8010b5:	73 24                	jae    8010db <getint+0xeb>
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c3:	8b 00                	mov    (%rax),%eax
  8010c5:	89 c0                	mov    %eax,%eax
  8010c7:	48 01 d0             	add    %rdx,%rax
  8010ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ce:	8b 12                	mov    (%rdx),%edx
  8010d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d7:	89 0a                	mov    %ecx,(%rdx)
  8010d9:	eb 17                	jmp    8010f2 <getint+0x102>
  8010db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010e3:	48 89 d0             	mov    %rdx,%rax
  8010e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010f2:	8b 00                	mov    (%rax),%eax
  8010f4:	48 98                	cltq   
  8010f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010fe:	c9                   	leaveq 
  8010ff:	c3                   	retq   

0000000000801100 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	41 54                	push   %r12
  801106:	53                   	push   %rbx
  801107:	48 83 ec 60          	sub    $0x60,%rsp
  80110b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80110f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801113:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801117:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80111b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80111f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801123:	48 8b 0a             	mov    (%rdx),%rcx
  801126:	48 89 08             	mov    %rcx,(%rax)
  801129:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80112d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801131:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801135:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801139:	eb 17                	jmp    801152 <vprintfmt+0x52>
			if (ch == '\0')
  80113b:	85 db                	test   %ebx,%ebx
  80113d:	0f 84 d7 04 00 00    	je     80161a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  801143:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801147:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80114b:	48 89 c6             	mov    %rax,%rsi
  80114e:	89 df                	mov    %ebx,%edi
  801150:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801152:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801156:	0f b6 00             	movzbl (%rax),%eax
  801159:	0f b6 d8             	movzbl %al,%ebx
  80115c:	83 fb 25             	cmp    $0x25,%ebx
  80115f:	0f 95 c0             	setne  %al
  801162:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801167:	84 c0                	test   %al,%al
  801169:	75 d0                	jne    80113b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80116f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801176:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80117d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801184:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80118b:	eb 04                	jmp    801191 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80118d:	90                   	nop
  80118e:	eb 01                	jmp    801191 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  801190:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801191:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801195:	0f b6 00             	movzbl (%rax),%eax
  801198:	0f b6 d8             	movzbl %al,%ebx
  80119b:	89 d8                	mov    %ebx,%eax
  80119d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8011a2:	83 e8 23             	sub    $0x23,%eax
  8011a5:	83 f8 55             	cmp    $0x55,%eax
  8011a8:	0f 87 38 04 00 00    	ja     8015e6 <vprintfmt+0x4e6>
  8011ae:	89 c0                	mov    %eax,%eax
  8011b0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8011b7:	00 
  8011b8:	48 b8 50 4a 80 00 00 	movabs $0x804a50,%rax
  8011bf:	00 00 00 
  8011c2:	48 01 d0             	add    %rdx,%rax
  8011c5:	48 8b 00             	mov    (%rax),%rax
  8011c8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011ca:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8011ce:	eb c1                	jmp    801191 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011d0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8011d4:	eb bb                	jmp    801191 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011dd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	c1 e0 02             	shl    $0x2,%eax
  8011e5:	01 d0                	add    %edx,%eax
  8011e7:	01 c0                	add    %eax,%eax
  8011e9:	01 d8                	add    %ebx,%eax
  8011eb:	83 e8 30             	sub    $0x30,%eax
  8011ee:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011f5:	0f b6 00             	movzbl (%rax),%eax
  8011f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8011fe:	7e 63                	jle    801263 <vprintfmt+0x163>
  801200:	83 fb 39             	cmp    $0x39,%ebx
  801203:	7f 5e                	jg     801263 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801205:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80120a:	eb d1                	jmp    8011dd <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80120c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80120f:	83 f8 30             	cmp    $0x30,%eax
  801212:	73 17                	jae    80122b <vprintfmt+0x12b>
  801214:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801218:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80121b:	89 c0                	mov    %eax,%eax
  80121d:	48 01 d0             	add    %rdx,%rax
  801220:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801223:	83 c2 08             	add    $0x8,%edx
  801226:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801229:	eb 0f                	jmp    80123a <vprintfmt+0x13a>
  80122b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80122f:	48 89 d0             	mov    %rdx,%rax
  801232:	48 83 c2 08          	add    $0x8,%rdx
  801236:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80123a:	8b 00                	mov    (%rax),%eax
  80123c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80123f:	eb 23                	jmp    801264 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  801241:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801245:	0f 89 42 ff ff ff    	jns    80118d <vprintfmt+0x8d>
				width = 0;
  80124b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801252:	e9 36 ff ff ff       	jmpq   80118d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801257:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80125e:	e9 2e ff ff ff       	jmpq   801191 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801263:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801264:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801268:	0f 89 22 ff ff ff    	jns    801190 <vprintfmt+0x90>
				width = precision, precision = -1;
  80126e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801271:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801274:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80127b:	e9 10 ff ff ff       	jmpq   801190 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801280:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801284:	e9 08 ff ff ff       	jmpq   801191 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801289:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80128c:	83 f8 30             	cmp    $0x30,%eax
  80128f:	73 17                	jae    8012a8 <vprintfmt+0x1a8>
  801291:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801295:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801298:	89 c0                	mov    %eax,%eax
  80129a:	48 01 d0             	add    %rdx,%rax
  80129d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012a0:	83 c2 08             	add    $0x8,%edx
  8012a3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012a6:	eb 0f                	jmp    8012b7 <vprintfmt+0x1b7>
  8012a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012ac:	48 89 d0             	mov    %rdx,%rax
  8012af:	48 83 c2 08          	add    $0x8,%rdx
  8012b3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012b7:	8b 00                	mov    (%rax),%eax
  8012b9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012bd:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8012c1:	48 89 d6             	mov    %rdx,%rsi
  8012c4:	89 c7                	mov    %eax,%edi
  8012c6:	ff d1                	callq  *%rcx
			break;
  8012c8:	e9 47 03 00 00       	jmpq   801614 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8012cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012d0:	83 f8 30             	cmp    $0x30,%eax
  8012d3:	73 17                	jae    8012ec <vprintfmt+0x1ec>
  8012d5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012dc:	89 c0                	mov    %eax,%eax
  8012de:	48 01 d0             	add    %rdx,%rax
  8012e1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012e4:	83 c2 08             	add    $0x8,%edx
  8012e7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012ea:	eb 0f                	jmp    8012fb <vprintfmt+0x1fb>
  8012ec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012f0:	48 89 d0             	mov    %rdx,%rax
  8012f3:	48 83 c2 08          	add    $0x8,%rdx
  8012f7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012fb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012fd:	85 db                	test   %ebx,%ebx
  8012ff:	79 02                	jns    801303 <vprintfmt+0x203>
				err = -err;
  801301:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801303:	83 fb 10             	cmp    $0x10,%ebx
  801306:	7f 16                	jg     80131e <vprintfmt+0x21e>
  801308:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  80130f:	00 00 00 
  801312:	48 63 d3             	movslq %ebx,%rdx
  801315:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801319:	4d 85 e4             	test   %r12,%r12
  80131c:	75 2e                	jne    80134c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80131e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801322:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801326:	89 d9                	mov    %ebx,%ecx
  801328:	48 ba 39 4a 80 00 00 	movabs $0x804a39,%rdx
  80132f:	00 00 00 
  801332:	48 89 c7             	mov    %rax,%rdi
  801335:	b8 00 00 00 00       	mov    $0x0,%eax
  80133a:	49 b8 24 16 80 00 00 	movabs $0x801624,%r8
  801341:	00 00 00 
  801344:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801347:	e9 c8 02 00 00       	jmpq   801614 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80134c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801350:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801354:	4c 89 e1             	mov    %r12,%rcx
  801357:	48 ba 42 4a 80 00 00 	movabs $0x804a42,%rdx
  80135e:	00 00 00 
  801361:	48 89 c7             	mov    %rax,%rdi
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
  801369:	49 b8 24 16 80 00 00 	movabs $0x801624,%r8
  801370:	00 00 00 
  801373:	41 ff d0             	callq  *%r8
			break;
  801376:	e9 99 02 00 00       	jmpq   801614 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80137b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80137e:	83 f8 30             	cmp    $0x30,%eax
  801381:	73 17                	jae    80139a <vprintfmt+0x29a>
  801383:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801387:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80138a:	89 c0                	mov    %eax,%eax
  80138c:	48 01 d0             	add    %rdx,%rax
  80138f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801392:	83 c2 08             	add    $0x8,%edx
  801395:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801398:	eb 0f                	jmp    8013a9 <vprintfmt+0x2a9>
  80139a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80139e:	48 89 d0             	mov    %rdx,%rax
  8013a1:	48 83 c2 08          	add    $0x8,%rdx
  8013a5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013a9:	4c 8b 20             	mov    (%rax),%r12
  8013ac:	4d 85 e4             	test   %r12,%r12
  8013af:	75 0a                	jne    8013bb <vprintfmt+0x2bb>
				p = "(null)";
  8013b1:	49 bc 45 4a 80 00 00 	movabs $0x804a45,%r12
  8013b8:	00 00 00 
			if (width > 0 && padc != '-')
  8013bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013bf:	7e 7a                	jle    80143b <vprintfmt+0x33b>
  8013c1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8013c5:	74 74                	je     80143b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8013ca:	48 98                	cltq   
  8013cc:	48 89 c6             	mov    %rax,%rsi
  8013cf:	4c 89 e7             	mov    %r12,%rdi
  8013d2:	48 b8 ce 18 80 00 00 	movabs $0x8018ce,%rax
  8013d9:	00 00 00 
  8013dc:	ff d0                	callq  *%rax
  8013de:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013e1:	eb 17                	jmp    8013fa <vprintfmt+0x2fa>
					putch(padc, putdat);
  8013e3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8013e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013eb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8013ef:	48 89 d6             	mov    %rdx,%rsi
  8013f2:	89 c7                	mov    %eax,%edi
  8013f4:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013f6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013fe:	7f e3                	jg     8013e3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801400:	eb 39                	jmp    80143b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  801402:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801406:	74 1e                	je     801426 <vprintfmt+0x326>
  801408:	83 fb 1f             	cmp    $0x1f,%ebx
  80140b:	7e 05                	jle    801412 <vprintfmt+0x312>
  80140d:	83 fb 7e             	cmp    $0x7e,%ebx
  801410:	7e 14                	jle    801426 <vprintfmt+0x326>
					putch('?', putdat);
  801412:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801416:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80141a:	48 89 c6             	mov    %rax,%rsi
  80141d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801422:	ff d2                	callq  *%rdx
  801424:	eb 0f                	jmp    801435 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801426:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80142a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80142e:	48 89 c6             	mov    %rax,%rsi
  801431:	89 df                	mov    %ebx,%edi
  801433:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801435:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801439:	eb 01                	jmp    80143c <vprintfmt+0x33c>
  80143b:	90                   	nop
  80143c:	41 0f b6 04 24       	movzbl (%r12),%eax
  801441:	0f be d8             	movsbl %al,%ebx
  801444:	85 db                	test   %ebx,%ebx
  801446:	0f 95 c0             	setne  %al
  801449:	49 83 c4 01          	add    $0x1,%r12
  80144d:	84 c0                	test   %al,%al
  80144f:	74 28                	je     801479 <vprintfmt+0x379>
  801451:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801455:	78 ab                	js     801402 <vprintfmt+0x302>
  801457:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80145b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80145f:	79 a1                	jns    801402 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801461:	eb 16                	jmp    801479 <vprintfmt+0x379>
				putch(' ', putdat);
  801463:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801467:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80146b:	48 89 c6             	mov    %rax,%rsi
  80146e:	bf 20 00 00 00       	mov    $0x20,%edi
  801473:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801475:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801479:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80147d:	7f e4                	jg     801463 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80147f:	e9 90 01 00 00       	jmpq   801614 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801484:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801488:	be 03 00 00 00       	mov    $0x3,%esi
  80148d:	48 89 c7             	mov    %rax,%rdi
  801490:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  801497:	00 00 00 
  80149a:	ff d0                	callq  *%rax
  80149c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8014a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a4:	48 85 c0             	test   %rax,%rax
  8014a7:	79 1d                	jns    8014c6 <vprintfmt+0x3c6>
				putch('-', putdat);
  8014a9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8014ad:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8014b1:	48 89 c6             	mov    %rax,%rsi
  8014b4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8014b9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8014bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bf:	48 f7 d8             	neg    %rax
  8014c2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8014c6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014cd:	e9 d5 00 00 00       	jmpq   8015a7 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8014d2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014d6:	be 03 00 00 00       	mov    $0x3,%esi
  8014db:	48 89 c7             	mov    %rax,%rdi
  8014de:	48 b8 e0 0e 80 00 00 	movabs $0x800ee0,%rax
  8014e5:	00 00 00 
  8014e8:	ff d0                	callq  *%rax
  8014ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014ee:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014f5:	e9 ad 00 00 00       	jmpq   8015a7 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  8014fa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014fe:	be 03 00 00 00       	mov    $0x3,%esi
  801503:	48 89 c7             	mov    %rax,%rdi
  801506:	48 b8 e0 0e 80 00 00 	movabs $0x800ee0,%rax
  80150d:	00 00 00 
  801510:	ff d0                	callq  *%rax
  801512:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  801516:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80151d:	e9 85 00 00 00       	jmpq   8015a7 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  801522:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801526:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80152a:	48 89 c6             	mov    %rax,%rsi
  80152d:	bf 30 00 00 00       	mov    $0x30,%edi
  801532:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801534:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801538:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80153c:	48 89 c6             	mov    %rax,%rsi
  80153f:	bf 78 00 00 00       	mov    $0x78,%edi
  801544:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801546:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801549:	83 f8 30             	cmp    $0x30,%eax
  80154c:	73 17                	jae    801565 <vprintfmt+0x465>
  80154e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801552:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801555:	89 c0                	mov    %eax,%eax
  801557:	48 01 d0             	add    %rdx,%rax
  80155a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80155d:	83 c2 08             	add    $0x8,%edx
  801560:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801563:	eb 0f                	jmp    801574 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  801565:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801569:	48 89 d0             	mov    %rdx,%rax
  80156c:	48 83 c2 08          	add    $0x8,%rdx
  801570:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801574:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801577:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80157b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801582:	eb 23                	jmp    8015a7 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801584:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801588:	be 03 00 00 00       	mov    $0x3,%esi
  80158d:	48 89 c7             	mov    %rax,%rdi
  801590:	48 b8 e0 0e 80 00 00 	movabs $0x800ee0,%rax
  801597:	00 00 00 
  80159a:	ff d0                	callq  *%rax
  80159c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8015a0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015a7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8015ac:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8015af:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8015b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015b6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8015ba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015be:	45 89 c1             	mov    %r8d,%r9d
  8015c1:	41 89 f8             	mov    %edi,%r8d
  8015c4:	48 89 c7             	mov    %rax,%rdi
  8015c7:	48 b8 28 0e 80 00 00 	movabs $0x800e28,%rax
  8015ce:	00 00 00 
  8015d1:	ff d0                	callq  *%rax
			break;
  8015d3:	eb 3f                	jmp    801614 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8015d9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8015dd:	48 89 c6             	mov    %rax,%rsi
  8015e0:	89 df                	mov    %ebx,%edi
  8015e2:	ff d2                	callq  *%rdx
			break;
  8015e4:	eb 2e                	jmp    801614 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015e6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8015ea:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8015ee:	48 89 c6             	mov    %rax,%rsi
  8015f1:	bf 25 00 00 00       	mov    $0x25,%edi
  8015f6:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015f8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015fd:	eb 05                	jmp    801604 <vprintfmt+0x504>
  8015ff:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801604:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801608:	48 83 e8 01          	sub    $0x1,%rax
  80160c:	0f b6 00             	movzbl (%rax),%eax
  80160f:	3c 25                	cmp    $0x25,%al
  801611:	75 ec                	jne    8015ff <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  801613:	90                   	nop
		}
	}
  801614:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801615:	e9 38 fb ff ff       	jmpq   801152 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  80161a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  80161b:	48 83 c4 60          	add    $0x60,%rsp
  80161f:	5b                   	pop    %rbx
  801620:	41 5c                	pop    %r12
  801622:	5d                   	pop    %rbp
  801623:	c3                   	retq   

0000000000801624 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801624:	55                   	push   %rbp
  801625:	48 89 e5             	mov    %rsp,%rbp
  801628:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80162f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801636:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80163d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801644:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80164b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801652:	84 c0                	test   %al,%al
  801654:	74 20                	je     801676 <printfmt+0x52>
  801656:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80165a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80165e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801662:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801666:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80166a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80166e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801672:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801676:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80167d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801684:	00 00 00 
  801687:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80168e:	00 00 00 
  801691:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801695:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80169c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8016a3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8016aa:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8016b1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8016b8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8016bf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8016c6:	48 89 c7             	mov    %rax,%rdi
  8016c9:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8016d0:	00 00 00 
  8016d3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8016d5:	c9                   	leaveq 
  8016d6:	c3                   	retq   

00000000008016d7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016d7:	55                   	push   %rbp
  8016d8:	48 89 e5             	mov    %rsp,%rbp
  8016db:	48 83 ec 10          	sub    $0x10,%rsp
  8016df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ea:	8b 40 10             	mov    0x10(%rax),%eax
  8016ed:	8d 50 01             	lea    0x1(%rax),%edx
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fb:	48 8b 10             	mov    (%rax),%rdx
  8016fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801702:	48 8b 40 08          	mov    0x8(%rax),%rax
  801706:	48 39 c2             	cmp    %rax,%rdx
  801709:	73 17                	jae    801722 <sprintputch+0x4b>
		*b->buf++ = ch;
  80170b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170f:	48 8b 00             	mov    (%rax),%rax
  801712:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801715:	88 10                	mov    %dl,(%rax)
  801717:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80171b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171f:	48 89 10             	mov    %rdx,(%rax)
}
  801722:	c9                   	leaveq 
  801723:	c3                   	retq   

0000000000801724 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801724:	55                   	push   %rbp
  801725:	48 89 e5             	mov    %rsp,%rbp
  801728:	48 83 ec 50          	sub    $0x50,%rsp
  80172c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801730:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801733:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801737:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80173b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80173f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801743:	48 8b 0a             	mov    (%rdx),%rcx
  801746:	48 89 08             	mov    %rcx,(%rax)
  801749:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80174d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801751:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801755:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801759:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80175d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801761:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801764:	48 98                	cltq   
  801766:	48 83 e8 01          	sub    $0x1,%rax
  80176a:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80176e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801772:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801779:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80177e:	74 06                	je     801786 <vsnprintf+0x62>
  801780:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801784:	7f 07                	jg     80178d <vsnprintf+0x69>
		return -E_INVAL;
  801786:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178b:	eb 2f                	jmp    8017bc <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80178d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801791:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801795:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801799:	48 89 c6             	mov    %rax,%rsi
  80179c:	48 bf d7 16 80 00 00 	movabs $0x8016d7,%rdi
  8017a3:	00 00 00 
  8017a6:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8017b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8017b9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8017bc:	c9                   	leaveq 
  8017bd:	c3                   	retq   

00000000008017be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017be:	55                   	push   %rbp
  8017bf:	48 89 e5             	mov    %rsp,%rbp
  8017c2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8017c9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8017d0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8017d6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017dd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017e4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017eb:	84 c0                	test   %al,%al
  8017ed:	74 20                	je     80180f <snprintf+0x51>
  8017ef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017f3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017f7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017fb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017ff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801803:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801807:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80180b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80180f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801816:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80181d:	00 00 00 
  801820:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801827:	00 00 00 
  80182a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80182e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801835:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80183c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801843:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80184a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801851:	48 8b 0a             	mov    (%rdx),%rcx
  801854:	48 89 08             	mov    %rcx,(%rax)
  801857:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80185b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80185f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801863:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801867:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80186e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801875:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80187b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801882:	48 89 c7             	mov    %rax,%rdi
  801885:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  80188c:	00 00 00 
  80188f:	ff d0                	callq  *%rax
  801891:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801897:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80189d:	c9                   	leaveq 
  80189e:	c3                   	retq   
	...

00000000008018a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018a0:	55                   	push   %rbp
  8018a1:	48 89 e5             	mov    %rsp,%rbp
  8018a4:	48 83 ec 18          	sub    $0x18,%rsp
  8018a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8018ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018b3:	eb 09                	jmp    8018be <strlen+0x1e>
		n++;
  8018b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c2:	0f b6 00             	movzbl (%rax),%eax
  8018c5:	84 c0                	test   %al,%al
  8018c7:	75 ec                	jne    8018b5 <strlen+0x15>
		n++;
	return n;
  8018c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018cc:	c9                   	leaveq 
  8018cd:	c3                   	retq   

00000000008018ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018ce:	55                   	push   %rbp
  8018cf:	48 89 e5             	mov    %rsp,%rbp
  8018d2:	48 83 ec 20          	sub    $0x20,%rsp
  8018d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018e5:	eb 0e                	jmp    8018f5 <strnlen+0x27>
		n++;
  8018e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018eb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018f0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018f5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018fa:	74 0b                	je     801907 <strnlen+0x39>
  8018fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801900:	0f b6 00             	movzbl (%rax),%eax
  801903:	84 c0                	test   %al,%al
  801905:	75 e0                	jne    8018e7 <strnlen+0x19>
		n++;
	return n;
  801907:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80190a:	c9                   	leaveq 
  80190b:	c3                   	retq   

000000000080190c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80190c:	55                   	push   %rbp
  80190d:	48 89 e5             	mov    %rsp,%rbp
  801910:	48 83 ec 20          	sub    $0x20,%rsp
  801914:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801918:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80191c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801920:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801924:	90                   	nop
  801925:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801929:	0f b6 10             	movzbl (%rax),%edx
  80192c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801930:	88 10                	mov    %dl,(%rax)
  801932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801936:	0f b6 00             	movzbl (%rax),%eax
  801939:	84 c0                	test   %al,%al
  80193b:	0f 95 c0             	setne  %al
  80193e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801943:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801948:	84 c0                	test   %al,%al
  80194a:	75 d9                	jne    801925 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80194c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801950:	c9                   	leaveq 
  801951:	c3                   	retq   

0000000000801952 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801952:	55                   	push   %rbp
  801953:	48 89 e5             	mov    %rsp,%rbp
  801956:	48 83 ec 20          	sub    $0x20,%rsp
  80195a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80195e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801966:	48 89 c7             	mov    %rax,%rdi
  801969:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  801970:	00 00 00 
  801973:	ff d0                	callq  *%rax
  801975:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197b:	48 98                	cltq   
  80197d:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801981:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801985:	48 89 d6             	mov    %rdx,%rsi
  801988:	48 89 c7             	mov    %rax,%rdi
  80198b:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  801992:	00 00 00 
  801995:	ff d0                	callq  *%rax
	return dst;
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80199b:	c9                   	leaveq 
  80199c:	c3                   	retq   

000000000080199d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	48 83 ec 28          	sub    $0x28,%rsp
  8019a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8019b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8019b9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019c0:	00 
  8019c1:	eb 27                	jmp    8019ea <strncpy+0x4d>
		*dst++ = *src;
  8019c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019c7:	0f b6 10             	movzbl (%rax),%edx
  8019ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ce:	88 10                	mov    %dl,(%rax)
  8019d0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8019d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019d9:	0f b6 00             	movzbl (%rax),%eax
  8019dc:	84 c0                	test   %al,%al
  8019de:	74 05                	je     8019e5 <strncpy+0x48>
			src++;
  8019e0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ee:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019f2:	72 cf                	jb     8019c3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019f8:	c9                   	leaveq 
  8019f9:	c3                   	retq   

00000000008019fa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019fa:	55                   	push   %rbp
  8019fb:	48 89 e5             	mov    %rsp,%rbp
  8019fe:	48 83 ec 28          	sub    $0x28,%rsp
  801a02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a0a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801a16:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a1b:	74 37                	je     801a54 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801a1d:	eb 17                	jmp    801a36 <strlcpy+0x3c>
			*dst++ = *src++;
  801a1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a23:	0f b6 10             	movzbl (%rax),%edx
  801a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2a:	88 10                	mov    %dl,(%rax)
  801a2c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a31:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a36:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a3b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a40:	74 0b                	je     801a4d <strlcpy+0x53>
  801a42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a46:	0f b6 00             	movzbl (%rax),%eax
  801a49:	84 c0                	test   %al,%al
  801a4b:	75 d2                	jne    801a1f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a51:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5c:	48 89 d1             	mov    %rdx,%rcx
  801a5f:	48 29 c1             	sub    %rax,%rcx
  801a62:	48 89 c8             	mov    %rcx,%rax
}
  801a65:	c9                   	leaveq 
  801a66:	c3                   	retq   

0000000000801a67 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a67:	55                   	push   %rbp
  801a68:	48 89 e5             	mov    %rsp,%rbp
  801a6b:	48 83 ec 10          	sub    $0x10,%rsp
  801a6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a77:	eb 0a                	jmp    801a83 <strcmp+0x1c>
		p++, q++;
  801a79:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a7e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a87:	0f b6 00             	movzbl (%rax),%eax
  801a8a:	84 c0                	test   %al,%al
  801a8c:	74 12                	je     801aa0 <strcmp+0x39>
  801a8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a92:	0f b6 10             	movzbl (%rax),%edx
  801a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a99:	0f b6 00             	movzbl (%rax),%eax
  801a9c:	38 c2                	cmp    %al,%dl
  801a9e:	74 d9                	je     801a79 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801aa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa4:	0f b6 00             	movzbl (%rax),%eax
  801aa7:	0f b6 d0             	movzbl %al,%edx
  801aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aae:	0f b6 00             	movzbl (%rax),%eax
  801ab1:	0f b6 c0             	movzbl %al,%eax
  801ab4:	89 d1                	mov    %edx,%ecx
  801ab6:	29 c1                	sub    %eax,%ecx
  801ab8:	89 c8                	mov    %ecx,%eax
}
  801aba:	c9                   	leaveq 
  801abb:	c3                   	retq   

0000000000801abc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	48 83 ec 18          	sub    $0x18,%rsp
  801ac4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ac8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801acc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801ad0:	eb 0f                	jmp    801ae1 <strncmp+0x25>
		n--, p++, q++;
  801ad2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801ad7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801adc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ae1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ae6:	74 1d                	je     801b05 <strncmp+0x49>
  801ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aec:	0f b6 00             	movzbl (%rax),%eax
  801aef:	84 c0                	test   %al,%al
  801af1:	74 12                	je     801b05 <strncmp+0x49>
  801af3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af7:	0f b6 10             	movzbl (%rax),%edx
  801afa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801afe:	0f b6 00             	movzbl (%rax),%eax
  801b01:	38 c2                	cmp    %al,%dl
  801b03:	74 cd                	je     801ad2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801b05:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b0a:	75 07                	jne    801b13 <strncmp+0x57>
		return 0;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b11:	eb 1a                	jmp    801b2d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801b13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b17:	0f b6 00             	movzbl (%rax),%eax
  801b1a:	0f b6 d0             	movzbl %al,%edx
  801b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b21:	0f b6 00             	movzbl (%rax),%eax
  801b24:	0f b6 c0             	movzbl %al,%eax
  801b27:	89 d1                	mov    %edx,%ecx
  801b29:	29 c1                	sub    %eax,%ecx
  801b2b:	89 c8                	mov    %ecx,%eax
}
  801b2d:	c9                   	leaveq 
  801b2e:	c3                   	retq   

0000000000801b2f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b2f:	55                   	push   %rbp
  801b30:	48 89 e5             	mov    %rsp,%rbp
  801b33:	48 83 ec 10          	sub    $0x10,%rsp
  801b37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b3b:	89 f0                	mov    %esi,%eax
  801b3d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b40:	eb 17                	jmp    801b59 <strchr+0x2a>
		if (*s == c)
  801b42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b46:	0f b6 00             	movzbl (%rax),%eax
  801b49:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b4c:	75 06                	jne    801b54 <strchr+0x25>
			return (char *) s;
  801b4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b52:	eb 15                	jmp    801b69 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b54:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5d:	0f b6 00             	movzbl (%rax),%eax
  801b60:	84 c0                	test   %al,%al
  801b62:	75 de                	jne    801b42 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b69:	c9                   	leaveq 
  801b6a:	c3                   	retq   

0000000000801b6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b6b:	55                   	push   %rbp
  801b6c:	48 89 e5             	mov    %rsp,%rbp
  801b6f:	48 83 ec 10          	sub    $0x10,%rsp
  801b73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b77:	89 f0                	mov    %esi,%eax
  801b79:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b7c:	eb 11                	jmp    801b8f <strfind+0x24>
		if (*s == c)
  801b7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b82:	0f b6 00             	movzbl (%rax),%eax
  801b85:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b88:	74 12                	je     801b9c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b8a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b93:	0f b6 00             	movzbl (%rax),%eax
  801b96:	84 c0                	test   %al,%al
  801b98:	75 e4                	jne    801b7e <strfind+0x13>
  801b9a:	eb 01                	jmp    801b9d <strfind+0x32>
		if (*s == c)
			break;
  801b9c:	90                   	nop
	return (char *) s;
  801b9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801ba1:	c9                   	leaveq 
  801ba2:	c3                   	retq   

0000000000801ba3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 18          	sub    $0x18,%rsp
  801bab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801baf:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801bb2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801bb6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bbb:	75 06                	jne    801bc3 <memset+0x20>
		return v;
  801bbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc1:	eb 69                	jmp    801c2c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801bc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc7:	83 e0 03             	and    $0x3,%eax
  801bca:	48 85 c0             	test   %rax,%rax
  801bcd:	75 48                	jne    801c17 <memset+0x74>
  801bcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd3:	83 e0 03             	and    $0x3,%eax
  801bd6:	48 85 c0             	test   %rax,%rax
  801bd9:	75 3c                	jne    801c17 <memset+0x74>
		c &= 0xFF;
  801bdb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801be2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801be5:	89 c2                	mov    %eax,%edx
  801be7:	c1 e2 18             	shl    $0x18,%edx
  801bea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bed:	c1 e0 10             	shl    $0x10,%eax
  801bf0:	09 c2                	or     %eax,%edx
  801bf2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf5:	c1 e0 08             	shl    $0x8,%eax
  801bf8:	09 d0                	or     %edx,%eax
  801bfa:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c01:	48 89 c1             	mov    %rax,%rcx
  801c04:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801c08:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c0c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c0f:	48 89 d7             	mov    %rdx,%rdi
  801c12:	fc                   	cld    
  801c13:	f3 ab                	rep stos %eax,%es:(%rdi)
  801c15:	eb 11                	jmp    801c28 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801c17:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c1b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c1e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c22:	48 89 d7             	mov    %rdx,%rdi
  801c25:	fc                   	cld    
  801c26:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801c28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c2c:	c9                   	leaveq 
  801c2d:	c3                   	retq   

0000000000801c2e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801c2e:	55                   	push   %rbp
  801c2f:	48 89 e5             	mov    %rsp,%rbp
  801c32:	48 83 ec 28          	sub    $0x28,%rsp
  801c36:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c3a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c3e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c46:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c4e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c56:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c5a:	0f 83 88 00 00 00    	jae    801ce8 <memmove+0xba>
  801c60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c64:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c68:	48 01 d0             	add    %rdx,%rax
  801c6b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c6f:	76 77                	jbe    801ce8 <memmove+0xba>
		s += n;
  801c71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c75:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c85:	83 e0 03             	and    $0x3,%eax
  801c88:	48 85 c0             	test   %rax,%rax
  801c8b:	75 3b                	jne    801cc8 <memmove+0x9a>
  801c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c91:	83 e0 03             	and    $0x3,%eax
  801c94:	48 85 c0             	test   %rax,%rax
  801c97:	75 2f                	jne    801cc8 <memmove+0x9a>
  801c99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9d:	83 e0 03             	and    $0x3,%eax
  801ca0:	48 85 c0             	test   %rax,%rax
  801ca3:	75 23                	jne    801cc8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca9:	48 83 e8 04          	sub    $0x4,%rax
  801cad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cb1:	48 83 ea 04          	sub    $0x4,%rdx
  801cb5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801cb9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801cbd:	48 89 c7             	mov    %rax,%rdi
  801cc0:	48 89 d6             	mov    %rdx,%rsi
  801cc3:	fd                   	std    
  801cc4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cc6:	eb 1d                	jmp    801ce5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801cc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801cd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cdc:	48 89 d7             	mov    %rdx,%rdi
  801cdf:	48 89 c1             	mov    %rax,%rcx
  801ce2:	fd                   	std    
  801ce3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ce5:	fc                   	cld    
  801ce6:	eb 57                	jmp    801d3f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cec:	83 e0 03             	and    $0x3,%eax
  801cef:	48 85 c0             	test   %rax,%rax
  801cf2:	75 36                	jne    801d2a <memmove+0xfc>
  801cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf8:	83 e0 03             	and    $0x3,%eax
  801cfb:	48 85 c0             	test   %rax,%rax
  801cfe:	75 2a                	jne    801d2a <memmove+0xfc>
  801d00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d04:	83 e0 03             	and    $0x3,%eax
  801d07:	48 85 c0             	test   %rax,%rax
  801d0a:	75 1e                	jne    801d2a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d10:	48 89 c1             	mov    %rax,%rcx
  801d13:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d1b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d1f:	48 89 c7             	mov    %rax,%rdi
  801d22:	48 89 d6             	mov    %rdx,%rsi
  801d25:	fc                   	cld    
  801d26:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d28:	eb 15                	jmp    801d3f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d2e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d32:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d36:	48 89 c7             	mov    %rax,%rdi
  801d39:	48 89 d6             	mov    %rdx,%rsi
  801d3c:	fc                   	cld    
  801d3d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d43:	c9                   	leaveq 
  801d44:	c3                   	retq   

0000000000801d45 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d45:	55                   	push   %rbp
  801d46:	48 89 e5             	mov    %rsp,%rbp
  801d49:	48 83 ec 18          	sub    $0x18,%rsp
  801d4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d55:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d59:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d5d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d65:	48 89 ce             	mov    %rcx,%rsi
  801d68:	48 89 c7             	mov    %rax,%rdi
  801d6b:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  801d72:	00 00 00 
  801d75:	ff d0                	callq  *%rax
}
  801d77:	c9                   	leaveq 
  801d78:	c3                   	retq   

0000000000801d79 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d79:	55                   	push   %rbp
  801d7a:	48 89 e5             	mov    %rsp,%rbp
  801d7d:	48 83 ec 28          	sub    $0x28,%rsp
  801d81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d89:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d91:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d99:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d9d:	eb 38                	jmp    801dd7 <memcmp+0x5e>
		if (*s1 != *s2)
  801d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da3:	0f b6 10             	movzbl (%rax),%edx
  801da6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801daa:	0f b6 00             	movzbl (%rax),%eax
  801dad:	38 c2                	cmp    %al,%dl
  801daf:	74 1c                	je     801dcd <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801db1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db5:	0f b6 00             	movzbl (%rax),%eax
  801db8:	0f b6 d0             	movzbl %al,%edx
  801dbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dbf:	0f b6 00             	movzbl (%rax),%eax
  801dc2:	0f b6 c0             	movzbl %al,%eax
  801dc5:	89 d1                	mov    %edx,%ecx
  801dc7:	29 c1                	sub    %eax,%ecx
  801dc9:	89 c8                	mov    %ecx,%eax
  801dcb:	eb 20                	jmp    801ded <memcmp+0x74>
		s1++, s2++;
  801dcd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801dd2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801dd7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ddc:	0f 95 c0             	setne  %al
  801ddf:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801de4:	84 c0                	test   %al,%al
  801de6:	75 b7                	jne    801d9f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ded:	c9                   	leaveq 
  801dee:	c3                   	retq   

0000000000801def <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801def:	55                   	push   %rbp
  801df0:	48 89 e5             	mov    %rsp,%rbp
  801df3:	48 83 ec 28          	sub    $0x28,%rsp
  801df7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dfb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dfe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801e02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e0a:	48 01 d0             	add    %rdx,%rax
  801e0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801e11:	eb 13                	jmp    801e26 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e17:	0f b6 10             	movzbl (%rax),%edx
  801e1a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e1d:	38 c2                	cmp    %al,%dl
  801e1f:	74 11                	je     801e32 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e21:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801e2e:	72 e3                	jb     801e13 <memfind+0x24>
  801e30:	eb 01                	jmp    801e33 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801e32:	90                   	nop
	return (void *) s;
  801e33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e37:	c9                   	leaveq 
  801e38:	c3                   	retq   

0000000000801e39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e39:	55                   	push   %rbp
  801e3a:	48 89 e5             	mov    %rsp,%rbp
  801e3d:	48 83 ec 38          	sub    $0x38,%rsp
  801e41:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e45:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e49:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e53:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e5a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e5b:	eb 05                	jmp    801e62 <strtol+0x29>
		s++;
  801e5d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e66:	0f b6 00             	movzbl (%rax),%eax
  801e69:	3c 20                	cmp    $0x20,%al
  801e6b:	74 f0                	je     801e5d <strtol+0x24>
  801e6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e71:	0f b6 00             	movzbl (%rax),%eax
  801e74:	3c 09                	cmp    $0x9,%al
  801e76:	74 e5                	je     801e5d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7c:	0f b6 00             	movzbl (%rax),%eax
  801e7f:	3c 2b                	cmp    $0x2b,%al
  801e81:	75 07                	jne    801e8a <strtol+0x51>
		s++;
  801e83:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e88:	eb 17                	jmp    801ea1 <strtol+0x68>
	else if (*s == '-')
  801e8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8e:	0f b6 00             	movzbl (%rax),%eax
  801e91:	3c 2d                	cmp    $0x2d,%al
  801e93:	75 0c                	jne    801ea1 <strtol+0x68>
		s++, neg = 1;
  801e95:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e9a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ea1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ea5:	74 06                	je     801ead <strtol+0x74>
  801ea7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801eab:	75 28                	jne    801ed5 <strtol+0x9c>
  801ead:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb1:	0f b6 00             	movzbl (%rax),%eax
  801eb4:	3c 30                	cmp    $0x30,%al
  801eb6:	75 1d                	jne    801ed5 <strtol+0x9c>
  801eb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebc:	48 83 c0 01          	add    $0x1,%rax
  801ec0:	0f b6 00             	movzbl (%rax),%eax
  801ec3:	3c 78                	cmp    $0x78,%al
  801ec5:	75 0e                	jne    801ed5 <strtol+0x9c>
		s += 2, base = 16;
  801ec7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801ecc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801ed3:	eb 2c                	jmp    801f01 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801ed5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ed9:	75 19                	jne    801ef4 <strtol+0xbb>
  801edb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801edf:	0f b6 00             	movzbl (%rax),%eax
  801ee2:	3c 30                	cmp    $0x30,%al
  801ee4:	75 0e                	jne    801ef4 <strtol+0xbb>
		s++, base = 8;
  801ee6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801eeb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ef2:	eb 0d                	jmp    801f01 <strtol+0xc8>
	else if (base == 0)
  801ef4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ef8:	75 07                	jne    801f01 <strtol+0xc8>
		base = 10;
  801efa:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801f01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f05:	0f b6 00             	movzbl (%rax),%eax
  801f08:	3c 2f                	cmp    $0x2f,%al
  801f0a:	7e 1d                	jle    801f29 <strtol+0xf0>
  801f0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f10:	0f b6 00             	movzbl (%rax),%eax
  801f13:	3c 39                	cmp    $0x39,%al
  801f15:	7f 12                	jg     801f29 <strtol+0xf0>
			dig = *s - '0';
  801f17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1b:	0f b6 00             	movzbl (%rax),%eax
  801f1e:	0f be c0             	movsbl %al,%eax
  801f21:	83 e8 30             	sub    $0x30,%eax
  801f24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f27:	eb 4e                	jmp    801f77 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801f29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f2d:	0f b6 00             	movzbl (%rax),%eax
  801f30:	3c 60                	cmp    $0x60,%al
  801f32:	7e 1d                	jle    801f51 <strtol+0x118>
  801f34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f38:	0f b6 00             	movzbl (%rax),%eax
  801f3b:	3c 7a                	cmp    $0x7a,%al
  801f3d:	7f 12                	jg     801f51 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f43:	0f b6 00             	movzbl (%rax),%eax
  801f46:	0f be c0             	movsbl %al,%eax
  801f49:	83 e8 57             	sub    $0x57,%eax
  801f4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f4f:	eb 26                	jmp    801f77 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f55:	0f b6 00             	movzbl (%rax),%eax
  801f58:	3c 40                	cmp    $0x40,%al
  801f5a:	7e 47                	jle    801fa3 <strtol+0x16a>
  801f5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f60:	0f b6 00             	movzbl (%rax),%eax
  801f63:	3c 5a                	cmp    $0x5a,%al
  801f65:	7f 3c                	jg     801fa3 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801f67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6b:	0f b6 00             	movzbl (%rax),%eax
  801f6e:	0f be c0             	movsbl %al,%eax
  801f71:	83 e8 37             	sub    $0x37,%eax
  801f74:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f7a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f7d:	7d 23                	jge    801fa2 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801f7f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f84:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f87:	48 98                	cltq   
  801f89:	48 89 c2             	mov    %rax,%rdx
  801f8c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801f91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f94:	48 98                	cltq   
  801f96:	48 01 d0             	add    %rdx,%rax
  801f99:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f9d:	e9 5f ff ff ff       	jmpq   801f01 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801fa2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801fa3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801fa8:	74 0b                	je     801fb5 <strtol+0x17c>
		*endptr = (char *) s;
  801faa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fb2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801fb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb9:	74 09                	je     801fc4 <strtol+0x18b>
  801fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbf:	48 f7 d8             	neg    %rax
  801fc2:	eb 04                	jmp    801fc8 <strtol+0x18f>
  801fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801fc8:	c9                   	leaveq 
  801fc9:	c3                   	retq   

0000000000801fca <strstr>:

char * strstr(const char *in, const char *str)
{
  801fca:	55                   	push   %rbp
  801fcb:	48 89 e5             	mov    %rsp,%rbp
  801fce:	48 83 ec 30          	sub    $0x30,%rsp
  801fd2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fd6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801fda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fde:	0f b6 00             	movzbl (%rax),%eax
  801fe1:	88 45 ff             	mov    %al,-0x1(%rbp)
  801fe4:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801fe9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fed:	75 06                	jne    801ff5 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801fef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff3:	eb 68                	jmp    80205d <strstr+0x93>

    len = strlen(str);
  801ff5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ff9:	48 89 c7             	mov    %rax,%rdi
  801ffc:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  802003:	00 00 00 
  802006:	ff d0                	callq  *%rax
  802008:	48 98                	cltq   
  80200a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80200e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802012:	0f b6 00             	movzbl (%rax),%eax
  802015:	88 45 ef             	mov    %al,-0x11(%rbp)
  802018:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80201d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802021:	75 07                	jne    80202a <strstr+0x60>
                return (char *) 0;
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
  802028:	eb 33                	jmp    80205d <strstr+0x93>
        } while (sc != c);
  80202a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80202e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802031:	75 db                	jne    80200e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  802033:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802037:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80203b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80203f:	48 89 ce             	mov    %rcx,%rsi
  802042:	48 89 c7             	mov    %rax,%rdi
  802045:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80204c:	00 00 00 
  80204f:	ff d0                	callq  *%rax
  802051:	85 c0                	test   %eax,%eax
  802053:	75 b9                	jne    80200e <strstr+0x44>

    return (char *) (in - 1);
  802055:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802059:	48 83 e8 01          	sub    $0x1,%rax
}
  80205d:	c9                   	leaveq 
  80205e:	c3                   	retq   
	...

0000000000802060 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802060:	55                   	push   %rbp
  802061:	48 89 e5             	mov    %rsp,%rbp
  802064:	53                   	push   %rbx
  802065:	48 83 ec 58          	sub    $0x58,%rsp
  802069:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80206c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80206f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802073:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802077:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80207b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80207f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802082:	89 45 ac             	mov    %eax,-0x54(%rbp)
  802085:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802089:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80208d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802091:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802095:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802099:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80209c:	4c 89 c3             	mov    %r8,%rbx
  80209f:	cd 30                	int    $0x30
  8020a1:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8020a5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8020a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8020ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8020b1:	74 3e                	je     8020f1 <syscall+0x91>
  8020b3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020b8:	7e 37                	jle    8020f1 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8020ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020c1:	49 89 d0             	mov    %rdx,%r8
  8020c4:	89 c1                	mov    %eax,%ecx
  8020c6:	48 ba 00 4d 80 00 00 	movabs $0x804d00,%rdx
  8020cd:	00 00 00 
  8020d0:	be 23 00 00 00       	mov    $0x23,%esi
  8020d5:	48 bf 1d 4d 80 00 00 	movabs $0x804d1d,%rdi
  8020dc:	00 00 00 
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	49 b9 14 0b 80 00 00 	movabs $0x800b14,%r9
  8020eb:	00 00 00 
  8020ee:	41 ff d1             	callq  *%r9

	return ret;
  8020f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020f5:	48 83 c4 58          	add    $0x58,%rsp
  8020f9:	5b                   	pop    %rbx
  8020fa:	5d                   	pop    %rbp
  8020fb:	c3                   	retq   

00000000008020fc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020fc:	55                   	push   %rbp
  8020fd:	48 89 e5             	mov    %rsp,%rbp
  802100:	48 83 ec 20          	sub    $0x20,%rsp
  802104:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802108:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80210c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802110:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802114:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80211b:	00 
  80211c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802122:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802128:	48 89 d1             	mov    %rdx,%rcx
  80212b:	48 89 c2             	mov    %rax,%rdx
  80212e:	be 00 00 00 00       	mov    $0x0,%esi
  802133:	bf 00 00 00 00       	mov    $0x0,%edi
  802138:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax
}
  802144:	c9                   	leaveq 
  802145:	c3                   	retq   

0000000000802146 <sys_cgetc>:

int
sys_cgetc(void)
{
  802146:	55                   	push   %rbp
  802147:	48 89 e5             	mov    %rsp,%rbp
  80214a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80214e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802155:	00 
  802156:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80215c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802162:	b9 00 00 00 00       	mov    $0x0,%ecx
  802167:	ba 00 00 00 00       	mov    $0x0,%edx
  80216c:	be 00 00 00 00       	mov    $0x0,%esi
  802171:	bf 01 00 00 00       	mov    $0x1,%edi
  802176:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  80217d:	00 00 00 
  802180:	ff d0                	callq  *%rax
}
  802182:	c9                   	leaveq 
  802183:	c3                   	retq   

0000000000802184 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802184:	55                   	push   %rbp
  802185:	48 89 e5             	mov    %rsp,%rbp
  802188:	48 83 ec 20          	sub    $0x20,%rsp
  80218c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80218f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802192:	48 98                	cltq   
  802194:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80219b:	00 
  80219c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021ad:	48 89 c2             	mov    %rax,%rdx
  8021b0:	be 01 00 00 00       	mov    $0x1,%esi
  8021b5:	bf 03 00 00 00       	mov    $0x3,%edi
  8021ba:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  8021c1:	00 00 00 
  8021c4:	ff d0                	callq  *%rax
}
  8021c6:	c9                   	leaveq 
  8021c7:	c3                   	retq   

00000000008021c8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8021c8:	55                   	push   %rbp
  8021c9:	48 89 e5             	mov    %rsp,%rbp
  8021cc:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8021d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021d7:	00 
  8021d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ee:	be 00 00 00 00       	mov    $0x0,%esi
  8021f3:	bf 02 00 00 00       	mov    $0x2,%edi
  8021f8:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  8021ff:	00 00 00 
  802202:	ff d0                	callq  *%rax
}
  802204:	c9                   	leaveq 
  802205:	c3                   	retq   

0000000000802206 <sys_yield>:

void
sys_yield(void)
{
  802206:	55                   	push   %rbp
  802207:	48 89 e5             	mov    %rsp,%rbp
  80220a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80220e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802215:	00 
  802216:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80221c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802222:	b9 00 00 00 00       	mov    $0x0,%ecx
  802227:	ba 00 00 00 00       	mov    $0x0,%edx
  80222c:	be 00 00 00 00       	mov    $0x0,%esi
  802231:	bf 0b 00 00 00       	mov    $0xb,%edi
  802236:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  80223d:	00 00 00 
  802240:	ff d0                	callq  *%rax
}
  802242:	c9                   	leaveq 
  802243:	c3                   	retq   

0000000000802244 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802244:	55                   	push   %rbp
  802245:	48 89 e5             	mov    %rsp,%rbp
  802248:	48 83 ec 20          	sub    $0x20,%rsp
  80224c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80224f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802253:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802256:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802259:	48 63 c8             	movslq %eax,%rcx
  80225c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802263:	48 98                	cltq   
  802265:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80226c:	00 
  80226d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802273:	49 89 c8             	mov    %rcx,%r8
  802276:	48 89 d1             	mov    %rdx,%rcx
  802279:	48 89 c2             	mov    %rax,%rdx
  80227c:	be 01 00 00 00       	mov    $0x1,%esi
  802281:	bf 04 00 00 00       	mov    $0x4,%edi
  802286:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  80228d:	00 00 00 
  802290:	ff d0                	callq  *%rax
}
  802292:	c9                   	leaveq 
  802293:	c3                   	retq   

0000000000802294 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802294:	55                   	push   %rbp
  802295:	48 89 e5             	mov    %rsp,%rbp
  802298:	48 83 ec 30          	sub    $0x30,%rsp
  80229c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80229f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8022a3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8022a6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8022aa:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8022ae:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022b1:	48 63 c8             	movslq %eax,%rcx
  8022b4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8022b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022bb:	48 63 f0             	movslq %eax,%rsi
  8022be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c5:	48 98                	cltq   
  8022c7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8022cb:	49 89 f9             	mov    %rdi,%r9
  8022ce:	49 89 f0             	mov    %rsi,%r8
  8022d1:	48 89 d1             	mov    %rdx,%rcx
  8022d4:	48 89 c2             	mov    %rax,%rdx
  8022d7:	be 01 00 00 00       	mov    $0x1,%esi
  8022dc:	bf 05 00 00 00       	mov    $0x5,%edi
  8022e1:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  8022e8:	00 00 00 
  8022eb:	ff d0                	callq  *%rax
}
  8022ed:	c9                   	leaveq 
  8022ee:	c3                   	retq   

00000000008022ef <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022ef:	55                   	push   %rbp
  8022f0:	48 89 e5             	mov    %rsp,%rbp
  8022f3:	48 83 ec 20          	sub    $0x20,%rsp
  8022f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802302:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802305:	48 98                	cltq   
  802307:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80230e:	00 
  80230f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802315:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80231b:	48 89 d1             	mov    %rdx,%rcx
  80231e:	48 89 c2             	mov    %rax,%rdx
  802321:	be 01 00 00 00       	mov    $0x1,%esi
  802326:	bf 06 00 00 00       	mov    $0x6,%edi
  80232b:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  802332:	00 00 00 
  802335:	ff d0                	callq  *%rax
}
  802337:	c9                   	leaveq 
  802338:	c3                   	retq   

0000000000802339 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802339:	55                   	push   %rbp
  80233a:	48 89 e5             	mov    %rsp,%rbp
  80233d:	48 83 ec 20          	sub    $0x20,%rsp
  802341:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802344:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802347:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80234a:	48 63 d0             	movslq %eax,%rdx
  80234d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802350:	48 98                	cltq   
  802352:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802359:	00 
  80235a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802360:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802366:	48 89 d1             	mov    %rdx,%rcx
  802369:	48 89 c2             	mov    %rax,%rdx
  80236c:	be 01 00 00 00       	mov    $0x1,%esi
  802371:	bf 08 00 00 00       	mov    $0x8,%edi
  802376:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  80237d:	00 00 00 
  802380:	ff d0                	callq  *%rax
}
  802382:	c9                   	leaveq 
  802383:	c3                   	retq   

0000000000802384 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802384:	55                   	push   %rbp
  802385:	48 89 e5             	mov    %rsp,%rbp
  802388:	48 83 ec 20          	sub    $0x20,%rsp
  80238c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80238f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802393:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802397:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239a:	48 98                	cltq   
  80239c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023a3:	00 
  8023a4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023b0:	48 89 d1             	mov    %rdx,%rcx
  8023b3:	48 89 c2             	mov    %rax,%rdx
  8023b6:	be 01 00 00 00       	mov    $0x1,%esi
  8023bb:	bf 09 00 00 00       	mov    $0x9,%edi
  8023c0:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	callq  *%rax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 20          	sub    $0x20,%rsp
  8023d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8023dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e4:	48 98                	cltq   
  8023e6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023ed:	00 
  8023ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023fa:	48 89 d1             	mov    %rdx,%rcx
  8023fd:	48 89 c2             	mov    %rax,%rdx
  802400:	be 01 00 00 00       	mov    $0x1,%esi
  802405:	bf 0a 00 00 00       	mov    $0xa,%edi
  80240a:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  802411:	00 00 00 
  802414:	ff d0                	callq  *%rax
}
  802416:	c9                   	leaveq 
  802417:	c3                   	retq   

0000000000802418 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802418:	55                   	push   %rbp
  802419:	48 89 e5             	mov    %rsp,%rbp
  80241c:	48 83 ec 30          	sub    $0x30,%rsp
  802420:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802423:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802427:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80242b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80242e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802431:	48 63 f0             	movslq %eax,%rsi
  802434:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243b:	48 98                	cltq   
  80243d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802441:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802448:	00 
  802449:	49 89 f1             	mov    %rsi,%r9
  80244c:	49 89 c8             	mov    %rcx,%r8
  80244f:	48 89 d1             	mov    %rdx,%rcx
  802452:	48 89 c2             	mov    %rax,%rdx
  802455:	be 00 00 00 00       	mov    $0x0,%esi
  80245a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80245f:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  802466:	00 00 00 
  802469:	ff d0                	callq  *%rax
}
  80246b:	c9                   	leaveq 
  80246c:	c3                   	retq   

000000000080246d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80246d:	55                   	push   %rbp
  80246e:	48 89 e5             	mov    %rsp,%rbp
  802471:	48 83 ec 20          	sub    $0x20,%rsp
  802475:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802484:	00 
  802485:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80248b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802491:	b9 00 00 00 00       	mov    $0x0,%ecx
  802496:	48 89 c2             	mov    %rax,%rdx
  802499:	be 01 00 00 00       	mov    $0x1,%esi
  80249e:	bf 0d 00 00 00       	mov    $0xd,%edi
  8024a3:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  8024aa:	00 00 00 
  8024ad:	ff d0                	callq  *%rax
}
  8024af:	c9                   	leaveq 
  8024b0:	c3                   	retq   

00000000008024b1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8024b1:	55                   	push   %rbp
  8024b2:	48 89 e5             	mov    %rsp,%rbp
  8024b5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8024b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024c0:	00 
  8024c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d7:	be 00 00 00 00       	mov    $0x0,%esi
  8024dc:	bf 0e 00 00 00       	mov    $0xe,%edi
  8024e1:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  8024e8:	00 00 00 
  8024eb:	ff d0                	callq  *%rax
}
  8024ed:	c9                   	leaveq 
  8024ee:	c3                   	retq   

00000000008024ef <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  8024ef:	55                   	push   %rbp
  8024f0:	48 89 e5             	mov    %rsp,%rbp
  8024f3:	48 83 ec 20          	sub    $0x20,%rsp
  8024f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8024ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802503:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802507:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80250e:	00 
  80250f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802515:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80251b:	48 89 d1             	mov    %rdx,%rcx
  80251e:	48 89 c2             	mov    %rax,%rdx
  802521:	be 00 00 00 00       	mov    $0x0,%esi
  802526:	bf 0f 00 00 00       	mov    $0xf,%edi
  80252b:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  802532:	00 00 00 
  802535:	ff d0                	callq  *%rax
}
  802537:	c9                   	leaveq 
  802538:	c3                   	retq   

0000000000802539 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802539:	55                   	push   %rbp
  80253a:	48 89 e5             	mov    %rsp,%rbp
  80253d:	48 83 ec 20          	sub    $0x20,%rsp
  802541:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802545:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802551:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802558:	00 
  802559:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80255f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802565:	48 89 d1             	mov    %rdx,%rcx
  802568:	48 89 c2             	mov    %rax,%rdx
  80256b:	be 00 00 00 00       	mov    $0x0,%esi
  802570:	bf 10 00 00 00       	mov    $0x10,%edi
  802575:	48 b8 60 20 80 00 00 	movabs $0x802060,%rax
  80257c:	00 00 00 
  80257f:	ff d0                	callq  *%rax
}
  802581:	c9                   	leaveq 
  802582:	c3                   	retq   
	...

0000000000802584 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802584:	55                   	push   %rbp
  802585:	48 89 e5             	mov    %rsp,%rbp
  802588:	48 83 ec 20          	sub    $0x20,%rsp
  80258c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  802590:	48 b8 38 72 80 00 00 	movabs $0x807238,%rax
  802597:	00 00 00 
  80259a:	48 8b 00             	mov    (%rax),%rax
  80259d:	48 85 c0             	test   %rax,%rax
  8025a0:	0f 85 8e 00 00 00    	jne    802634 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  8025a6:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  8025ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  8025b4:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
  8025c0:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  8025c3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8025c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025ca:	ba 07 00 00 00       	mov    $0x7,%edx
  8025cf:	48 89 ce             	mov    %rcx,%rsi
  8025d2:	89 c7                	mov    %eax,%edi
  8025d4:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  8025db:	00 00 00 
  8025de:	ff d0                	callq  *%rax
  8025e0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  8025e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8025e7:	74 30                	je     802619 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  8025e9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8025ec:	89 c1                	mov    %eax,%ecx
  8025ee:	48 ba 30 4d 80 00 00 	movabs $0x804d30,%rdx
  8025f5:	00 00 00 
  8025f8:	be 24 00 00 00       	mov    $0x24,%esi
  8025fd:	48 bf 67 4d 80 00 00 	movabs $0x804d67,%rdi
  802604:	00 00 00 
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
  80260c:	49 b8 14 0b 80 00 00 	movabs $0x800b14,%r8
  802613:	00 00 00 
  802616:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  802619:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80261c:	48 be 48 26 80 00 00 	movabs $0x802648,%rsi
  802623:	00 00 00 
  802626:	89 c7                	mov    %eax,%edi
  802628:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80262f:	00 00 00 
  802632:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802634:	48 b8 38 72 80 00 00 	movabs $0x807238,%rax
  80263b:	00 00 00 
  80263e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802642:	48 89 10             	mov    %rdx,(%rax)
}
  802645:	c9                   	leaveq 
  802646:	c3                   	retq   
	...

0000000000802648 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  802648:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80264b:	48 a1 38 72 80 00 00 	movabs 0x807238,%rax
  802652:	00 00 00 
	call *%rax
  802655:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  802657:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  80265b:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  80265f:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  802662:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802669:	00 
		movq 120(%rsp), %rcx				// trap time rip
  80266a:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  80266f:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  802672:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  802673:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  802676:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  80267d:	00 08 
		POPA_						// copy the register contents to the registers
  80267f:	4c 8b 3c 24          	mov    (%rsp),%r15
  802683:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802688:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80268d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802692:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802697:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80269c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8026a1:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8026a6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8026ab:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8026b0:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8026b5:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8026ba:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8026bf:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8026c4:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8026c9:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  8026cd:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  8026d1:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  8026d2:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  8026d3:	c3                   	retq   

00000000008026d4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026d4:	55                   	push   %rbp
  8026d5:	48 89 e5             	mov    %rsp,%rbp
  8026d8:	48 83 ec 08          	sub    $0x8,%rsp
  8026dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026e4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026eb:	ff ff ff 
  8026ee:	48 01 d0             	add    %rdx,%rax
  8026f1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026f5:	c9                   	leaveq 
  8026f6:	c3                   	retq   

00000000008026f7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026f7:	55                   	push   %rbp
  8026f8:	48 89 e5             	mov    %rsp,%rbp
  8026fb:	48 83 ec 08          	sub    $0x8,%rsp
  8026ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802707:	48 89 c7             	mov    %rax,%rdi
  80270a:	48 b8 d4 26 80 00 00 	movabs $0x8026d4,%rax
  802711:	00 00 00 
  802714:	ff d0                	callq  *%rax
  802716:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80271c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802720:	c9                   	leaveq 
  802721:	c3                   	retq   

0000000000802722 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802722:	55                   	push   %rbp
  802723:	48 89 e5             	mov    %rsp,%rbp
  802726:	48 83 ec 18          	sub    $0x18,%rsp
  80272a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80272e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802735:	eb 6b                	jmp    8027a2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802737:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273a:	48 98                	cltq   
  80273c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802742:	48 c1 e0 0c          	shl    $0xc,%rax
  802746:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80274a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274e:	48 89 c2             	mov    %rax,%rdx
  802751:	48 c1 ea 15          	shr    $0x15,%rdx
  802755:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80275c:	01 00 00 
  80275f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802763:	83 e0 01             	and    $0x1,%eax
  802766:	48 85 c0             	test   %rax,%rax
  802769:	74 21                	je     80278c <fd_alloc+0x6a>
  80276b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276f:	48 89 c2             	mov    %rax,%rdx
  802772:	48 c1 ea 0c          	shr    $0xc,%rdx
  802776:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80277d:	01 00 00 
  802780:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802784:	83 e0 01             	and    $0x1,%eax
  802787:	48 85 c0             	test   %rax,%rax
  80278a:	75 12                	jne    80279e <fd_alloc+0x7c>
			*fd_store = fd;
  80278c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802790:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802794:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802797:	b8 00 00 00 00       	mov    $0x0,%eax
  80279c:	eb 1a                	jmp    8027b8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80279e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027a2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027a6:	7e 8f                	jle    802737 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ac:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027b3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027b8:	c9                   	leaveq 
  8027b9:	c3                   	retq   

00000000008027ba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027ba:	55                   	push   %rbp
  8027bb:	48 89 e5             	mov    %rsp,%rbp
  8027be:	48 83 ec 20          	sub    $0x20,%rsp
  8027c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027cd:	78 06                	js     8027d5 <fd_lookup+0x1b>
  8027cf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027d3:	7e 07                	jle    8027dc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027da:	eb 6c                	jmp    802848 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027df:	48 98                	cltq   
  8027e1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027e7:	48 c1 e0 0c          	shl    $0xc,%rax
  8027eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027f3:	48 89 c2             	mov    %rax,%rdx
  8027f6:	48 c1 ea 15          	shr    $0x15,%rdx
  8027fa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802801:	01 00 00 
  802804:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802808:	83 e0 01             	and    $0x1,%eax
  80280b:	48 85 c0             	test   %rax,%rax
  80280e:	74 21                	je     802831 <fd_lookup+0x77>
  802810:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802814:	48 89 c2             	mov    %rax,%rdx
  802817:	48 c1 ea 0c          	shr    $0xc,%rdx
  80281b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802822:	01 00 00 
  802825:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802829:	83 e0 01             	and    $0x1,%eax
  80282c:	48 85 c0             	test   %rax,%rax
  80282f:	75 07                	jne    802838 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802831:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802836:	eb 10                	jmp    802848 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802838:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80283c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802840:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802843:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802848:	c9                   	leaveq 
  802849:	c3                   	retq   

000000000080284a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80284a:	55                   	push   %rbp
  80284b:	48 89 e5             	mov    %rsp,%rbp
  80284e:	48 83 ec 30          	sub    $0x30,%rsp
  802852:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802856:	89 f0                	mov    %esi,%eax
  802858:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80285b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80285f:	48 89 c7             	mov    %rax,%rdi
  802862:	48 b8 d4 26 80 00 00 	movabs $0x8026d4,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
  80286e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802872:	48 89 d6             	mov    %rdx,%rsi
  802875:	89 c7                	mov    %eax,%edi
  802877:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  80287e:	00 00 00 
  802881:	ff d0                	callq  *%rax
  802883:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288a:	78 0a                	js     802896 <fd_close+0x4c>
	    || fd != fd2)
  80288c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802890:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802894:	74 12                	je     8028a8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802896:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80289a:	74 05                	je     8028a1 <fd_close+0x57>
  80289c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289f:	eb 05                	jmp    8028a6 <fd_close+0x5c>
  8028a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a6:	eb 69                	jmp    802911 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ac:	8b 00                	mov    (%rax),%eax
  8028ae:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b2:	48 89 d6             	mov    %rdx,%rsi
  8028b5:	89 c7                	mov    %eax,%edi
  8028b7:	48 b8 13 29 80 00 00 	movabs $0x802913,%rax
  8028be:	00 00 00 
  8028c1:	ff d0                	callq  *%rax
  8028c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ca:	78 2a                	js     8028f6 <fd_close+0xac>
		if (dev->dev_close)
  8028cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028d4:	48 85 c0             	test   %rax,%rax
  8028d7:	74 16                	je     8028ef <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028dd:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8028e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e5:	48 89 c7             	mov    %rax,%rdi
  8028e8:	ff d2                	callq  *%rdx
  8028ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ed:	eb 07                	jmp    8028f6 <fd_close+0xac>
		else
			r = 0;
  8028ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fa:	48 89 c6             	mov    %rax,%rsi
  8028fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802902:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  802909:	00 00 00 
  80290c:	ff d0                	callq  *%rax
	return r;
  80290e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802911:	c9                   	leaveq 
  802912:	c3                   	retq   

0000000000802913 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802913:	55                   	push   %rbp
  802914:	48 89 e5             	mov    %rsp,%rbp
  802917:	48 83 ec 20          	sub    $0x20,%rsp
  80291b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80291e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802922:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802929:	eb 41                	jmp    80296c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80292b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802932:	00 00 00 
  802935:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802938:	48 63 d2             	movslq %edx,%rdx
  80293b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293f:	8b 00                	mov    (%rax),%eax
  802941:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802944:	75 22                	jne    802968 <dev_lookup+0x55>
			*dev = devtab[i];
  802946:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80294d:	00 00 00 
  802950:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802953:	48 63 d2             	movslq %edx,%rdx
  802956:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80295a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802961:	b8 00 00 00 00       	mov    $0x0,%eax
  802966:	eb 60                	jmp    8029c8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802968:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80296c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802973:	00 00 00 
  802976:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802979:	48 63 d2             	movslq %edx,%rdx
  80297c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802980:	48 85 c0             	test   %rax,%rax
  802983:	75 a6                	jne    80292b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802985:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  80298c:	00 00 00 
  80298f:	48 8b 00             	mov    (%rax),%rax
  802992:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802998:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80299b:	89 c6                	mov    %eax,%esi
  80299d:	48 bf 78 4d 80 00 00 	movabs $0x804d78,%rdi
  8029a4:	00 00 00 
  8029a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ac:	48 b9 4f 0d 80 00 00 	movabs $0x800d4f,%rcx
  8029b3:	00 00 00 
  8029b6:	ff d1                	callq  *%rcx
	*dev = 0;
  8029b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029bc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029c8:	c9                   	leaveq 
  8029c9:	c3                   	retq   

00000000008029ca <close>:

int
close(int fdnum)
{
  8029ca:	55                   	push   %rbp
  8029cb:	48 89 e5             	mov    %rsp,%rbp
  8029ce:	48 83 ec 20          	sub    $0x20,%rsp
  8029d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029d5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029dc:	48 89 d6             	mov    %rdx,%rsi
  8029df:	89 c7                	mov    %eax,%edi
  8029e1:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	callq  *%rax
  8029ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f4:	79 05                	jns    8029fb <close+0x31>
		return r;
  8029f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f9:	eb 18                	jmp    802a13 <close+0x49>
	else
		return fd_close(fd, 1);
  8029fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ff:	be 01 00 00 00       	mov    $0x1,%esi
  802a04:	48 89 c7             	mov    %rax,%rdi
  802a07:	48 b8 4a 28 80 00 00 	movabs $0x80284a,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
}
  802a13:	c9                   	leaveq 
  802a14:	c3                   	retq   

0000000000802a15 <close_all>:

void
close_all(void)
{
  802a15:	55                   	push   %rbp
  802a16:	48 89 e5             	mov    %rsp,%rbp
  802a19:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a24:	eb 15                	jmp    802a3b <close_all+0x26>
		close(i);
  802a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a29:	89 c7                	mov    %eax,%edi
  802a2b:	48 b8 ca 29 80 00 00 	movabs $0x8029ca,%rax
  802a32:	00 00 00 
  802a35:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a37:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a3b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a3f:	7e e5                	jle    802a26 <close_all+0x11>
		close(i);
}
  802a41:	c9                   	leaveq 
  802a42:	c3                   	retq   

0000000000802a43 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a43:	55                   	push   %rbp
  802a44:	48 89 e5             	mov    %rsp,%rbp
  802a47:	48 83 ec 40          	sub    $0x40,%rsp
  802a4b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a4e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a51:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a55:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a58:	48 89 d6             	mov    %rdx,%rsi
  802a5b:	89 c7                	mov    %eax,%edi
  802a5d:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax
  802a69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a70:	79 08                	jns    802a7a <dup+0x37>
		return r;
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	e9 70 01 00 00       	jmpq   802bea <dup+0x1a7>
	close(newfdnum);
  802a7a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a7d:	89 c7                	mov    %eax,%edi
  802a7f:	48 b8 ca 29 80 00 00 	movabs $0x8029ca,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a8b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a8e:	48 98                	cltq   
  802a90:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a96:	48 c1 e0 0c          	shl    $0xc,%rax
  802a9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa2:	48 89 c7             	mov    %rax,%rdi
  802aa5:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	callq  *%rax
  802ab1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab9:	48 89 c7             	mov    %rax,%rdi
  802abc:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
  802ac8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad0:	48 89 c2             	mov    %rax,%rdx
  802ad3:	48 c1 ea 15          	shr    $0x15,%rdx
  802ad7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ade:	01 00 00 
  802ae1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ae5:	83 e0 01             	and    $0x1,%eax
  802ae8:	84 c0                	test   %al,%al
  802aea:	74 71                	je     802b5d <dup+0x11a>
  802aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af0:	48 89 c2             	mov    %rax,%rdx
  802af3:	48 c1 ea 0c          	shr    $0xc,%rdx
  802af7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802afe:	01 00 00 
  802b01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b05:	83 e0 01             	and    $0x1,%eax
  802b08:	84 c0                	test   %al,%al
  802b0a:	74 51                	je     802b5d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b10:	48 89 c2             	mov    %rax,%rdx
  802b13:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b17:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b1e:	01 00 00 
  802b21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b25:	89 c1                	mov    %eax,%ecx
  802b27:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802b2d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b35:	41 89 c8             	mov    %ecx,%r8d
  802b38:	48 89 d1             	mov    %rdx,%rcx
  802b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b40:	48 89 c6             	mov    %rax,%rsi
  802b43:	bf 00 00 00 00       	mov    $0x0,%edi
  802b48:	48 b8 94 22 80 00 00 	movabs $0x802294,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5b:	78 56                	js     802bb3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b61:	48 89 c2             	mov    %rax,%rdx
  802b64:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b68:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b6f:	01 00 00 
  802b72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b76:	89 c1                	mov    %eax,%ecx
  802b78:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802b7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b86:	41 89 c8             	mov    %ecx,%r8d
  802b89:	48 89 d1             	mov    %rdx,%rcx
  802b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b91:	48 89 c6             	mov    %rax,%rsi
  802b94:	bf 00 00 00 00       	mov    $0x0,%edi
  802b99:	48 b8 94 22 80 00 00 	movabs $0x802294,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax
  802ba5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bac:	78 08                	js     802bb6 <dup+0x173>
		goto err;

	return newfdnum;
  802bae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bb1:	eb 37                	jmp    802bea <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802bb3:	90                   	nop
  802bb4:	eb 01                	jmp    802bb7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802bb6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbb:	48 89 c6             	mov    %rax,%rsi
  802bbe:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc3:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  802bca:	00 00 00 
  802bcd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd3:	48 89 c6             	mov    %rax,%rsi
  802bd6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bdb:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
	return r;
  802be7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bea:	c9                   	leaveq 
  802beb:	c3                   	retq   

0000000000802bec <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bec:	55                   	push   %rbp
  802bed:	48 89 e5             	mov    %rsp,%rbp
  802bf0:	48 83 ec 40          	sub    $0x40,%rsp
  802bf4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bfb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c03:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c06:	48 89 d6             	mov    %rdx,%rsi
  802c09:	89 c7                	mov    %eax,%edi
  802c0b:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
  802c17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1e:	78 24                	js     802c44 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c24:	8b 00                	mov    (%rax),%eax
  802c26:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c2a:	48 89 d6             	mov    %rdx,%rsi
  802c2d:	89 c7                	mov    %eax,%edi
  802c2f:	48 b8 13 29 80 00 00 	movabs $0x802913,%rax
  802c36:	00 00 00 
  802c39:	ff d0                	callq  *%rax
  802c3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c42:	79 05                	jns    802c49 <read+0x5d>
		return r;
  802c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c47:	eb 7a                	jmp    802cc3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4d:	8b 40 08             	mov    0x8(%rax),%eax
  802c50:	83 e0 03             	and    $0x3,%eax
  802c53:	83 f8 01             	cmp    $0x1,%eax
  802c56:	75 3a                	jne    802c92 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c58:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  802c5f:	00 00 00 
  802c62:	48 8b 00             	mov    (%rax),%rax
  802c65:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c6b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c6e:	89 c6                	mov    %eax,%esi
  802c70:	48 bf 97 4d 80 00 00 	movabs $0x804d97,%rdi
  802c77:	00 00 00 
  802c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7f:	48 b9 4f 0d 80 00 00 	movabs $0x800d4f,%rcx
  802c86:	00 00 00 
  802c89:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c90:	eb 31                	jmp    802cc3 <read+0xd7>
	}
	if (!dev->dev_read)
  802c92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c96:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c9a:	48 85 c0             	test   %rax,%rax
  802c9d:	75 07                	jne    802ca6 <read+0xba>
		return -E_NOT_SUPP;
  802c9f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ca4:	eb 1d                	jmp    802cc3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802ca6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802caa:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802cae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cb6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cba:	48 89 ce             	mov    %rcx,%rsi
  802cbd:	48 89 c7             	mov    %rax,%rdi
  802cc0:	41 ff d0             	callq  *%r8
}
  802cc3:	c9                   	leaveq 
  802cc4:	c3                   	retq   

0000000000802cc5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cc5:	55                   	push   %rbp
  802cc6:	48 89 e5             	mov    %rsp,%rbp
  802cc9:	48 83 ec 30          	sub    $0x30,%rsp
  802ccd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cdf:	eb 46                	jmp    802d27 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ce1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce4:	48 98                	cltq   
  802ce6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cea:	48 29 c2             	sub    %rax,%rdx
  802ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf0:	48 98                	cltq   
  802cf2:	48 89 c1             	mov    %rax,%rcx
  802cf5:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cfc:	48 89 ce             	mov    %rcx,%rsi
  802cff:	89 c7                	mov    %eax,%edi
  802d01:	48 b8 ec 2b 80 00 00 	movabs $0x802bec,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
  802d0d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d10:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d14:	79 05                	jns    802d1b <readn+0x56>
			return m;
  802d16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d19:	eb 1d                	jmp    802d38 <readn+0x73>
		if (m == 0)
  802d1b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d1f:	74 13                	je     802d34 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d24:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2a:	48 98                	cltq   
  802d2c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d30:	72 af                	jb     802ce1 <readn+0x1c>
  802d32:	eb 01                	jmp    802d35 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802d34:	90                   	nop
	}
	return tot;
  802d35:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d38:	c9                   	leaveq 
  802d39:	c3                   	retq   

0000000000802d3a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d3a:	55                   	push   %rbp
  802d3b:	48 89 e5             	mov    %rsp,%rbp
  802d3e:	48 83 ec 40          	sub    $0x40,%rsp
  802d42:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d45:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d49:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d4d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d54:	48 89 d6             	mov    %rdx,%rsi
  802d57:	89 c7                	mov    %eax,%edi
  802d59:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
  802d65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6c:	78 24                	js     802d92 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d72:	8b 00                	mov    (%rax),%eax
  802d74:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d78:	48 89 d6             	mov    %rdx,%rsi
  802d7b:	89 c7                	mov    %eax,%edi
  802d7d:	48 b8 13 29 80 00 00 	movabs $0x802913,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax
  802d89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d90:	79 05                	jns    802d97 <write+0x5d>
		return r;
  802d92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d95:	eb 79                	jmp    802e10 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9b:	8b 40 08             	mov    0x8(%rax),%eax
  802d9e:	83 e0 03             	and    $0x3,%eax
  802da1:	85 c0                	test   %eax,%eax
  802da3:	75 3a                	jne    802ddf <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802da5:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  802dac:	00 00 00 
  802daf:	48 8b 00             	mov    (%rax),%rax
  802db2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802db8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dbb:	89 c6                	mov    %eax,%esi
  802dbd:	48 bf b3 4d 80 00 00 	movabs $0x804db3,%rdi
  802dc4:	00 00 00 
  802dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcc:	48 b9 4f 0d 80 00 00 	movabs $0x800d4f,%rcx
  802dd3:	00 00 00 
  802dd6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802dd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ddd:	eb 31                	jmp    802e10 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ddf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802de7:	48 85 c0             	test   %rax,%rax
  802dea:	75 07                	jne    802df3 <write+0xb9>
		return -E_NOT_SUPP;
  802dec:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802df1:	eb 1d                	jmp    802e10 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802df3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df7:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e03:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e07:	48 89 ce             	mov    %rcx,%rsi
  802e0a:	48 89 c7             	mov    %rax,%rdi
  802e0d:	41 ff d0             	callq  *%r8
}
  802e10:	c9                   	leaveq 
  802e11:	c3                   	retq   

0000000000802e12 <seek>:

int
seek(int fdnum, off_t offset)
{
  802e12:	55                   	push   %rbp
  802e13:	48 89 e5             	mov    %rsp,%rbp
  802e16:	48 83 ec 18          	sub    $0x18,%rsp
  802e1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e1d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e24:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e27:	48 89 d6             	mov    %rdx,%rsi
  802e2a:	89 c7                	mov    %eax,%edi
  802e2c:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
  802e38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3f:	79 05                	jns    802e46 <seek+0x34>
		return r;
  802e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e44:	eb 0f                	jmp    802e55 <seek+0x43>
	fd->fd_offset = offset;
  802e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e4d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e55:	c9                   	leaveq 
  802e56:	c3                   	retq   

0000000000802e57 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e57:	55                   	push   %rbp
  802e58:	48 89 e5             	mov    %rsp,%rbp
  802e5b:	48 83 ec 30          	sub    $0x30,%rsp
  802e5f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e62:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e65:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e69:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e6c:	48 89 d6             	mov    %rdx,%rsi
  802e6f:	89 c7                	mov    %eax,%edi
  802e71:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  802e78:	00 00 00 
  802e7b:	ff d0                	callq  *%rax
  802e7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e84:	78 24                	js     802eaa <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8a:	8b 00                	mov    (%rax),%eax
  802e8c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e90:	48 89 d6             	mov    %rdx,%rsi
  802e93:	89 c7                	mov    %eax,%edi
  802e95:	48 b8 13 29 80 00 00 	movabs $0x802913,%rax
  802e9c:	00 00 00 
  802e9f:	ff d0                	callq  *%rax
  802ea1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea8:	79 05                	jns    802eaf <ftruncate+0x58>
		return r;
  802eaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ead:	eb 72                	jmp    802f21 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb3:	8b 40 08             	mov    0x8(%rax),%eax
  802eb6:	83 e0 03             	and    $0x3,%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	75 3a                	jne    802ef7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ebd:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  802ec4:	00 00 00 
  802ec7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802eca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ed0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ed3:	89 c6                	mov    %eax,%esi
  802ed5:	48 bf d0 4d 80 00 00 	movabs $0x804dd0,%rdi
  802edc:	00 00 00 
  802edf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee4:	48 b9 4f 0d 80 00 00 	movabs $0x800d4f,%rcx
  802eeb:	00 00 00 
  802eee:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ef0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef5:	eb 2a                	jmp    802f21 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ef7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efb:	48 8b 40 30          	mov    0x30(%rax),%rax
  802eff:	48 85 c0             	test   %rax,%rax
  802f02:	75 07                	jne    802f0b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f04:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f09:	eb 16                	jmp    802f21 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802f13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f17:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802f1a:	89 d6                	mov    %edx,%esi
  802f1c:	48 89 c7             	mov    %rax,%rdi
  802f1f:	ff d1                	callq  *%rcx
}
  802f21:	c9                   	leaveq 
  802f22:	c3                   	retq   

0000000000802f23 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f23:	55                   	push   %rbp
  802f24:	48 89 e5             	mov    %rsp,%rbp
  802f27:	48 83 ec 30          	sub    $0x30,%rsp
  802f2b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f2e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f32:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f36:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f39:	48 89 d6             	mov    %rdx,%rsi
  802f3c:	89 c7                	mov    %eax,%edi
  802f3e:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  802f45:	00 00 00 
  802f48:	ff d0                	callq  *%rax
  802f4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f51:	78 24                	js     802f77 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f57:	8b 00                	mov    (%rax),%eax
  802f59:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f5d:	48 89 d6             	mov    %rdx,%rsi
  802f60:	89 c7                	mov    %eax,%edi
  802f62:	48 b8 13 29 80 00 00 	movabs $0x802913,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
  802f6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f75:	79 05                	jns    802f7c <fstat+0x59>
		return r;
  802f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7a:	eb 5e                	jmp    802fda <fstat+0xb7>
	if (!dev->dev_stat)
  802f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f80:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f84:	48 85 c0             	test   %rax,%rax
  802f87:	75 07                	jne    802f90 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f89:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f8e:	eb 4a                	jmp    802fda <fstat+0xb7>
	stat->st_name[0] = 0;
  802f90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f94:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802fa2:	00 00 00 
	stat->st_isdir = 0;
  802fa5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fb0:	00 00 00 
	stat->st_dev = dev;
  802fb3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fb7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fbb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fce:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802fd2:	48 89 d6             	mov    %rdx,%rsi
  802fd5:	48 89 c7             	mov    %rax,%rdi
  802fd8:	ff d1                	callq  *%rcx
}
  802fda:	c9                   	leaveq 
  802fdb:	c3                   	retq   

0000000000802fdc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fdc:	55                   	push   %rbp
  802fdd:	48 89 e5             	mov    %rsp,%rbp
  802fe0:	48 83 ec 20          	sub    $0x20,%rsp
  802fe4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fe8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802fec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff0:	be 00 00 00 00       	mov    $0x0,%esi
  802ff5:	48 89 c7             	mov    %rax,%rdi
  802ff8:	48 b8 cb 30 80 00 00 	movabs $0x8030cb,%rax
  802fff:	00 00 00 
  803002:	ff d0                	callq  *%rax
  803004:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300b:	79 05                	jns    803012 <stat+0x36>
		return fd;
  80300d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803010:	eb 2f                	jmp    803041 <stat+0x65>
	r = fstat(fd, stat);
  803012:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803016:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803019:	48 89 d6             	mov    %rdx,%rsi
  80301c:	89 c7                	mov    %eax,%edi
  80301e:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  803025:	00 00 00 
  803028:	ff d0                	callq  *%rax
  80302a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80302d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803030:	89 c7                	mov    %eax,%edi
  803032:	48 b8 ca 29 80 00 00 	movabs $0x8029ca,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
	return r;
  80303e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803041:	c9                   	leaveq 
  803042:	c3                   	retq   
	...

0000000000803044 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803044:	55                   	push   %rbp
  803045:	48 89 e5             	mov    %rsp,%rbp
  803048:	48 83 ec 10          	sub    $0x10,%rsp
  80304c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80304f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803053:	48 b8 10 72 80 00 00 	movabs $0x807210,%rax
  80305a:	00 00 00 
  80305d:	8b 00                	mov    (%rax),%eax
  80305f:	85 c0                	test   %eax,%eax
  803061:	75 1d                	jne    803080 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803063:	bf 01 00 00 00       	mov    $0x1,%edi
  803068:	48 b8 e7 45 80 00 00 	movabs $0x8045e7,%rax
  80306f:	00 00 00 
  803072:	ff d0                	callq  *%rax
  803074:	48 ba 10 72 80 00 00 	movabs $0x807210,%rdx
  80307b:	00 00 00 
  80307e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803080:	48 b8 10 72 80 00 00 	movabs $0x807210,%rax
  803087:	00 00 00 
  80308a:	8b 00                	mov    (%rax),%eax
  80308c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80308f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803094:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80309b:	00 00 00 
  80309e:	89 c7                	mov    %eax,%edi
  8030a0:	48 b8 24 45 80 00 00 	movabs $0x804524,%rax
  8030a7:	00 00 00 
  8030aa:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8030ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8030b5:	48 89 c6             	mov    %rax,%rsi
  8030b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8030bd:	48 b8 64 44 80 00 00 	movabs $0x804464,%rax
  8030c4:	00 00 00 
  8030c7:	ff d0                	callq  *%rax
}
  8030c9:	c9                   	leaveq 
  8030ca:	c3                   	retq   

00000000008030cb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030cb:	55                   	push   %rbp
  8030cc:	48 89 e5             	mov    %rsp,%rbp
  8030cf:	48 83 ec 20          	sub    $0x20,%rsp
  8030d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8030da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030de:	48 89 c7             	mov    %rax,%rdi
  8030e1:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  8030e8:	00 00 00 
  8030eb:	ff d0                	callq  *%rax
  8030ed:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030f2:	7e 0a                	jle    8030fe <open+0x33>
                return -E_BAD_PATH;
  8030f4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030f9:	e9 a5 00 00 00       	jmpq   8031a3 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8030fe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803102:	48 89 c7             	mov    %rax,%rdi
  803105:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
  803111:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803114:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803118:	79 08                	jns    803122 <open+0x57>
		return r;
  80311a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311d:	e9 81 00 00 00       	jmpq   8031a3 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  803122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803126:	48 89 c6             	mov    %rax,%rsi
  803129:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803130:	00 00 00 
  803133:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80313f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803146:	00 00 00 
  803149:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80314c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  803152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803156:	48 89 c6             	mov    %rax,%rsi
  803159:	bf 01 00 00 00       	mov    $0x1,%edi
  80315e:	48 b8 44 30 80 00 00 	movabs $0x803044,%rax
  803165:	00 00 00 
  803168:	ff d0                	callq  *%rax
  80316a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  80316d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803171:	79 1d                	jns    803190 <open+0xc5>
	{
		fd_close(fd,0);
  803173:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803177:	be 00 00 00 00       	mov    $0x0,%esi
  80317c:	48 89 c7             	mov    %rax,%rdi
  80317f:	48 b8 4a 28 80 00 00 	movabs $0x80284a,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax
		return r;
  80318b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318e:	eb 13                	jmp    8031a3 <open+0xd8>
	}
	return fd2num(fd);
  803190:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803194:	48 89 c7             	mov    %rax,%rdi
  803197:	48 b8 d4 26 80 00 00 	movabs $0x8026d4,%rax
  80319e:	00 00 00 
  8031a1:	ff d0                	callq  *%rax
	


}
  8031a3:	c9                   	leaveq 
  8031a4:	c3                   	retq   

00000000008031a5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8031a5:	55                   	push   %rbp
  8031a6:	48 89 e5             	mov    %rsp,%rbp
  8031a9:	48 83 ec 10          	sub    $0x10,%rsp
  8031ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b5:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031bf:	00 00 00 
  8031c2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031c4:	be 00 00 00 00       	mov    $0x0,%esi
  8031c9:	bf 06 00 00 00       	mov    $0x6,%edi
  8031ce:	48 b8 44 30 80 00 00 	movabs $0x803044,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	callq  *%rax
}
  8031da:	c9                   	leaveq 
  8031db:	c3                   	retq   

00000000008031dc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031dc:	55                   	push   %rbp
  8031dd:	48 89 e5             	mov    %rsp,%rbp
  8031e0:	48 83 ec 30          	sub    $0x30,%rsp
  8031e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f4:	8b 50 0c             	mov    0xc(%rax),%edx
  8031f7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031fe:	00 00 00 
  803201:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803203:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320a:	00 00 00 
  80320d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803211:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803215:	be 00 00 00 00       	mov    $0x0,%esi
  80321a:	bf 03 00 00 00       	mov    $0x3,%edi
  80321f:	48 b8 44 30 80 00 00 	movabs $0x803044,%rax
  803226:	00 00 00 
  803229:	ff d0                	callq  *%rax
  80322b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80322e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803232:	79 05                	jns    803239 <devfile_read+0x5d>
	{
		return r;
  803234:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803237:	eb 2c                	jmp    803265 <devfile_read+0x89>
	}
	if(r > 0)
  803239:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323d:	7e 23                	jle    803262 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80323f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803242:	48 63 d0             	movslq %eax,%rdx
  803245:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803249:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803250:	00 00 00 
  803253:	48 89 c7             	mov    %rax,%rdi
  803256:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
	return r;
  803262:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  803265:	c9                   	leaveq 
  803266:	c3                   	retq   

0000000000803267 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803267:	55                   	push   %rbp
  803268:	48 89 e5             	mov    %rsp,%rbp
  80326b:	48 83 ec 30          	sub    $0x30,%rsp
  80326f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803273:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803277:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80327b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327f:	8b 50 0c             	mov    0xc(%rax),%edx
  803282:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803289:	00 00 00 
  80328c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80328e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803295:	00 
  803296:	76 08                	jbe    8032a0 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  803298:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80329f:	00 
	fsipcbuf.write.req_n=n;
  8032a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032a7:	00 00 00 
  8032aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032ae:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8032b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ba:	48 89 c6             	mov    %rax,%rsi
  8032bd:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8032c4:	00 00 00 
  8032c7:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8032d3:	be 00 00 00 00       	mov    $0x0,%esi
  8032d8:	bf 04 00 00 00       	mov    $0x4,%edi
  8032dd:	48 b8 44 30 80 00 00 	movabs $0x803044,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	callq  *%rax
  8032e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8032ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032ef:	c9                   	leaveq 
  8032f0:	c3                   	retq   

00000000008032f1 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8032f1:	55                   	push   %rbp
  8032f2:	48 89 e5             	mov    %rsp,%rbp
  8032f5:	48 83 ec 10          	sub    $0x10,%rsp
  8032f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032fd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803304:	8b 50 0c             	mov    0xc(%rax),%edx
  803307:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80330e:	00 00 00 
  803311:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  803313:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80331a:	00 00 00 
  80331d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803320:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803323:	be 00 00 00 00       	mov    $0x0,%esi
  803328:	bf 02 00 00 00       	mov    $0x2,%edi
  80332d:	48 b8 44 30 80 00 00 	movabs $0x803044,%rax
  803334:	00 00 00 
  803337:	ff d0                	callq  *%rax
}
  803339:	c9                   	leaveq 
  80333a:	c3                   	retq   

000000000080333b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80333b:	55                   	push   %rbp
  80333c:	48 89 e5             	mov    %rsp,%rbp
  80333f:	48 83 ec 20          	sub    $0x20,%rsp
  803343:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803347:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80334b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334f:	8b 50 0c             	mov    0xc(%rax),%edx
  803352:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803359:	00 00 00 
  80335c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80335e:	be 00 00 00 00       	mov    $0x0,%esi
  803363:	bf 05 00 00 00       	mov    $0x5,%edi
  803368:	48 b8 44 30 80 00 00 	movabs $0x803044,%rax
  80336f:	00 00 00 
  803372:	ff d0                	callq  *%rax
  803374:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803377:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337b:	79 05                	jns    803382 <devfile_stat+0x47>
		return r;
  80337d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803380:	eb 56                	jmp    8033d8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803386:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80338d:	00 00 00 
  803390:	48 89 c7             	mov    %rax,%rdi
  803393:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  80339a:	00 00 00 
  80339d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80339f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033a6:	00 00 00 
  8033a9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033b9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033c0:	00 00 00 
  8033c3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8033c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033cd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8033d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d8:	c9                   	leaveq 
  8033d9:	c3                   	retq   
	...

00000000008033dc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8033dc:	55                   	push   %rbp
  8033dd:	48 89 e5             	mov    %rsp,%rbp
  8033e0:	48 83 ec 20          	sub    $0x20,%rsp
  8033e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8033e7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ee:	48 89 d6             	mov    %rdx,%rsi
  8033f1:	89 c7                	mov    %eax,%edi
  8033f3:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  8033fa:	00 00 00 
  8033fd:	ff d0                	callq  *%rax
  8033ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803406:	79 05                	jns    80340d <fd2sockid+0x31>
		return r;
  803408:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340b:	eb 24                	jmp    803431 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80340d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803411:	8b 10                	mov    (%rax),%edx
  803413:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80341a:	00 00 00 
  80341d:	8b 00                	mov    (%rax),%eax
  80341f:	39 c2                	cmp    %eax,%edx
  803421:	74 07                	je     80342a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803423:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803428:	eb 07                	jmp    803431 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80342a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803431:	c9                   	leaveq 
  803432:	c3                   	retq   

0000000000803433 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803433:	55                   	push   %rbp
  803434:	48 89 e5             	mov    %rsp,%rbp
  803437:	48 83 ec 20          	sub    $0x20,%rsp
  80343b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80343e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803442:	48 89 c7             	mov    %rax,%rdi
  803445:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  80344c:	00 00 00 
  80344f:	ff d0                	callq  *%rax
  803451:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803454:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803458:	78 26                	js     803480 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80345a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80345e:	ba 07 04 00 00       	mov    $0x407,%edx
  803463:	48 89 c6             	mov    %rax,%rsi
  803466:	bf 00 00 00 00       	mov    $0x0,%edi
  80346b:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  803472:	00 00 00 
  803475:	ff d0                	callq  *%rax
  803477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80347e:	79 16                	jns    803496 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803480:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803483:	89 c7                	mov    %eax,%edi
  803485:	48 b8 40 39 80 00 00 	movabs $0x803940,%rax
  80348c:	00 00 00 
  80348f:	ff d0                	callq  *%rax
		return r;
  803491:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803494:	eb 3a                	jmp    8034d0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8034a1:	00 00 00 
  8034a4:	8b 12                	mov    (%rdx),%edx
  8034a6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8034a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ac:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8034b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034ba:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8034bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c1:	48 89 c7             	mov    %rax,%rdi
  8034c4:	48 b8 d4 26 80 00 00 	movabs $0x8026d4,%rax
  8034cb:	00 00 00 
  8034ce:	ff d0                	callq  *%rax
}
  8034d0:	c9                   	leaveq 
  8034d1:	c3                   	retq   

00000000008034d2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034d2:	55                   	push   %rbp
  8034d3:	48 89 e5             	mov    %rsp,%rbp
  8034d6:	48 83 ec 30          	sub    $0x30,%rsp
  8034da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e8:	89 c7                	mov    %eax,%edi
  8034ea:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
  8034f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034fd:	79 05                	jns    803504 <accept+0x32>
		return r;
  8034ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803502:	eb 3b                	jmp    80353f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803504:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803508:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80350c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350f:	48 89 ce             	mov    %rcx,%rsi
  803512:	89 c7                	mov    %eax,%edi
  803514:	48 b8 1d 38 80 00 00 	movabs $0x80381d,%rax
  80351b:	00 00 00 
  80351e:	ff d0                	callq  *%rax
  803520:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803523:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803527:	79 05                	jns    80352e <accept+0x5c>
		return r;
  803529:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352c:	eb 11                	jmp    80353f <accept+0x6d>
	return alloc_sockfd(r);
  80352e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803531:	89 c7                	mov    %eax,%edi
  803533:	48 b8 33 34 80 00 00 	movabs $0x803433,%rax
  80353a:	00 00 00 
  80353d:	ff d0                	callq  *%rax
}
  80353f:	c9                   	leaveq 
  803540:	c3                   	retq   

0000000000803541 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803541:	55                   	push   %rbp
  803542:	48 89 e5             	mov    %rsp,%rbp
  803545:	48 83 ec 20          	sub    $0x20,%rsp
  803549:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80354c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803550:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803553:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803556:	89 c7                	mov    %eax,%edi
  803558:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
  803564:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803567:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356b:	79 05                	jns    803572 <bind+0x31>
		return r;
  80356d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803570:	eb 1b                	jmp    80358d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803572:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803575:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357c:	48 89 ce             	mov    %rcx,%rsi
  80357f:	89 c7                	mov    %eax,%edi
  803581:	48 b8 9c 38 80 00 00 	movabs $0x80389c,%rax
  803588:	00 00 00 
  80358b:	ff d0                	callq  *%rax
}
  80358d:	c9                   	leaveq 
  80358e:	c3                   	retq   

000000000080358f <shutdown>:

int
shutdown(int s, int how)
{
  80358f:	55                   	push   %rbp
  803590:	48 89 e5             	mov    %rsp,%rbp
  803593:	48 83 ec 20          	sub    $0x20,%rsp
  803597:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80359a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80359d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a0:	89 c7                	mov    %eax,%edi
  8035a2:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  8035a9:	00 00 00 
  8035ac:	ff d0                	callq  *%rax
  8035ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b5:	79 05                	jns    8035bc <shutdown+0x2d>
		return r;
  8035b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ba:	eb 16                	jmp    8035d2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8035bc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c2:	89 d6                	mov    %edx,%esi
  8035c4:	89 c7                	mov    %eax,%edi
  8035c6:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  8035cd:	00 00 00 
  8035d0:	ff d0                	callq  *%rax
}
  8035d2:	c9                   	leaveq 
  8035d3:	c3                   	retq   

00000000008035d4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8035d4:	55                   	push   %rbp
  8035d5:	48 89 e5             	mov    %rsp,%rbp
  8035d8:	48 83 ec 10          	sub    $0x10,%rsp
  8035dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8035e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e4:	48 89 c7             	mov    %rax,%rdi
  8035e7:	48 b8 6c 46 80 00 00 	movabs $0x80466c,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
  8035f3:	83 f8 01             	cmp    $0x1,%eax
  8035f6:	75 17                	jne    80360f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8035f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035fc:	8b 40 0c             	mov    0xc(%rax),%eax
  8035ff:	89 c7                	mov    %eax,%edi
  803601:	48 b8 40 39 80 00 00 	movabs $0x803940,%rax
  803608:	00 00 00 
  80360b:	ff d0                	callq  *%rax
  80360d:	eb 05                	jmp    803614 <devsock_close+0x40>
	else
		return 0;
  80360f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803614:	c9                   	leaveq 
  803615:	c3                   	retq   

0000000000803616 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803616:	55                   	push   %rbp
  803617:	48 89 e5             	mov    %rsp,%rbp
  80361a:	48 83 ec 20          	sub    $0x20,%rsp
  80361e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803621:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803625:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803628:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80362b:	89 c7                	mov    %eax,%edi
  80362d:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  803634:	00 00 00 
  803637:	ff d0                	callq  *%rax
  803639:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80363c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803640:	79 05                	jns    803647 <connect+0x31>
		return r;
  803642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803645:	eb 1b                	jmp    803662 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803647:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80364a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80364e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803651:	48 89 ce             	mov    %rcx,%rsi
  803654:	89 c7                	mov    %eax,%edi
  803656:	48 b8 6d 39 80 00 00 	movabs $0x80396d,%rax
  80365d:	00 00 00 
  803660:	ff d0                	callq  *%rax
}
  803662:	c9                   	leaveq 
  803663:	c3                   	retq   

0000000000803664 <listen>:

int
listen(int s, int backlog)
{
  803664:	55                   	push   %rbp
  803665:	48 89 e5             	mov    %rsp,%rbp
  803668:	48 83 ec 20          	sub    $0x20,%rsp
  80366c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80366f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803672:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803675:	89 c7                	mov    %eax,%edi
  803677:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  80367e:	00 00 00 
  803681:	ff d0                	callq  *%rax
  803683:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803686:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80368a:	79 05                	jns    803691 <listen+0x2d>
		return r;
  80368c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368f:	eb 16                	jmp    8036a7 <listen+0x43>
	return nsipc_listen(r, backlog);
  803691:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803694:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803697:	89 d6                	mov    %edx,%esi
  803699:	89 c7                	mov    %eax,%edi
  80369b:	48 b8 d1 39 80 00 00 	movabs $0x8039d1,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
}
  8036a7:	c9                   	leaveq 
  8036a8:	c3                   	retq   

00000000008036a9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8036a9:	55                   	push   %rbp
  8036aa:	48 89 e5             	mov    %rsp,%rbp
  8036ad:	48 83 ec 20          	sub    $0x20,%rsp
  8036b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c1:	89 c2                	mov    %eax,%edx
  8036c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c7:	8b 40 0c             	mov    0xc(%rax),%eax
  8036ca:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8036d3:	89 c7                	mov    %eax,%edi
  8036d5:	48 b8 11 3a 80 00 00 	movabs $0x803a11,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
}
  8036e1:	c9                   	leaveq 
  8036e2:	c3                   	retq   

00000000008036e3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8036e3:	55                   	push   %rbp
  8036e4:	48 89 e5             	mov    %rsp,%rbp
  8036e7:	48 83 ec 20          	sub    $0x20,%rsp
  8036eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8036f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036fb:	89 c2                	mov    %eax,%edx
  8036fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803701:	8b 40 0c             	mov    0xc(%rax),%eax
  803704:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803708:	b9 00 00 00 00       	mov    $0x0,%ecx
  80370d:	89 c7                	mov    %eax,%edi
  80370f:	48 b8 dd 3a 80 00 00 	movabs $0x803add,%rax
  803716:	00 00 00 
  803719:	ff d0                	callq  *%rax
}
  80371b:	c9                   	leaveq 
  80371c:	c3                   	retq   

000000000080371d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80371d:	55                   	push   %rbp
  80371e:	48 89 e5             	mov    %rsp,%rbp
  803721:	48 83 ec 10          	sub    $0x10,%rsp
  803725:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803729:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80372d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803731:	48 be fb 4d 80 00 00 	movabs $0x804dfb,%rsi
  803738:	00 00 00 
  80373b:	48 89 c7             	mov    %rax,%rdi
  80373e:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  803745:	00 00 00 
  803748:	ff d0                	callq  *%rax
	return 0;
  80374a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80374f:	c9                   	leaveq 
  803750:	c3                   	retq   

0000000000803751 <socket>:

int
socket(int domain, int type, int protocol)
{
  803751:	55                   	push   %rbp
  803752:	48 89 e5             	mov    %rsp,%rbp
  803755:	48 83 ec 20          	sub    $0x20,%rsp
  803759:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80375c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80375f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803762:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803765:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803768:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376b:	89 ce                	mov    %ecx,%esi
  80376d:	89 c7                	mov    %eax,%edi
  80376f:	48 b8 95 3b 80 00 00 	movabs $0x803b95,%rax
  803776:	00 00 00 
  803779:	ff d0                	callq  *%rax
  80377b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80377e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803782:	79 05                	jns    803789 <socket+0x38>
		return r;
  803784:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803787:	eb 11                	jmp    80379a <socket+0x49>
	return alloc_sockfd(r);
  803789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378c:	89 c7                	mov    %eax,%edi
  80378e:	48 b8 33 34 80 00 00 	movabs $0x803433,%rax
  803795:	00 00 00 
  803798:	ff d0                	callq  *%rax
}
  80379a:	c9                   	leaveq 
  80379b:	c3                   	retq   

000000000080379c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80379c:	55                   	push   %rbp
  80379d:	48 89 e5             	mov    %rsp,%rbp
  8037a0:	48 83 ec 10          	sub    $0x10,%rsp
  8037a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8037a7:	48 b8 1c 72 80 00 00 	movabs $0x80721c,%rax
  8037ae:	00 00 00 
  8037b1:	8b 00                	mov    (%rax),%eax
  8037b3:	85 c0                	test   %eax,%eax
  8037b5:	75 1d                	jne    8037d4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8037b7:	bf 02 00 00 00       	mov    $0x2,%edi
  8037bc:	48 b8 e7 45 80 00 00 	movabs $0x8045e7,%rax
  8037c3:	00 00 00 
  8037c6:	ff d0                	callq  *%rax
  8037c8:	48 ba 1c 72 80 00 00 	movabs $0x80721c,%rdx
  8037cf:	00 00 00 
  8037d2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8037d4:	48 b8 1c 72 80 00 00 	movabs $0x80721c,%rax
  8037db:	00 00 00 
  8037de:	8b 00                	mov    (%rax),%eax
  8037e0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8037e3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8037e8:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8037ef:	00 00 00 
  8037f2:	89 c7                	mov    %eax,%edi
  8037f4:	48 b8 24 45 80 00 00 	movabs $0x804524,%rax
  8037fb:	00 00 00 
  8037fe:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803800:	ba 00 00 00 00       	mov    $0x0,%edx
  803805:	be 00 00 00 00       	mov    $0x0,%esi
  80380a:	bf 00 00 00 00       	mov    $0x0,%edi
  80380f:	48 b8 64 44 80 00 00 	movabs $0x804464,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
}
  80381b:	c9                   	leaveq 
  80381c:	c3                   	retq   

000000000080381d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80381d:	55                   	push   %rbp
  80381e:	48 89 e5             	mov    %rsp,%rbp
  803821:	48 83 ec 30          	sub    $0x30,%rsp
  803825:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803828:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80382c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803830:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803837:	00 00 00 
  80383a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80383d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80383f:	bf 01 00 00 00       	mov    $0x1,%edi
  803844:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  80384b:	00 00 00 
  80384e:	ff d0                	callq  *%rax
  803850:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803853:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803857:	78 3e                	js     803897 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803859:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803860:	00 00 00 
  803863:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803867:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386b:	8b 40 10             	mov    0x10(%rax),%eax
  80386e:	89 c2                	mov    %eax,%edx
  803870:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803874:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803878:	48 89 ce             	mov    %rcx,%rsi
  80387b:	48 89 c7             	mov    %rax,%rdi
  80387e:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  803885:	00 00 00 
  803888:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80388a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80388e:	8b 50 10             	mov    0x10(%rax),%edx
  803891:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803895:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803897:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80389a:	c9                   	leaveq 
  80389b:	c3                   	retq   

000000000080389c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80389c:	55                   	push   %rbp
  80389d:	48 89 e5             	mov    %rsp,%rbp
  8038a0:	48 83 ec 10          	sub    $0x10,%rsp
  8038a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038ab:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8038ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b5:	00 00 00 
  8038b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038bb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038bd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c4:	48 89 c6             	mov    %rax,%rsi
  8038c7:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8038ce:	00 00 00 
  8038d1:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  8038d8:	00 00 00 
  8038db:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8038dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038e4:	00 00 00 
  8038e7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038ea:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8038ed:	bf 02 00 00 00       	mov    $0x2,%edi
  8038f2:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  8038f9:	00 00 00 
  8038fc:	ff d0                	callq  *%rax
}
  8038fe:	c9                   	leaveq 
  8038ff:	c3                   	retq   

0000000000803900 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803900:	55                   	push   %rbp
  803901:	48 89 e5             	mov    %rsp,%rbp
  803904:	48 83 ec 10          	sub    $0x10,%rsp
  803908:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80390b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80390e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803915:	00 00 00 
  803918:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80391b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80391d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803924:	00 00 00 
  803927:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80392a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80392d:	bf 03 00 00 00       	mov    $0x3,%edi
  803932:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  803939:	00 00 00 
  80393c:	ff d0                	callq  *%rax
}
  80393e:	c9                   	leaveq 
  80393f:	c3                   	retq   

0000000000803940 <nsipc_close>:

int
nsipc_close(int s)
{
  803940:	55                   	push   %rbp
  803941:	48 89 e5             	mov    %rsp,%rbp
  803944:	48 83 ec 10          	sub    $0x10,%rsp
  803948:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80394b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803952:	00 00 00 
  803955:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803958:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80395a:	bf 04 00 00 00       	mov    $0x4,%edi
  80395f:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  803966:	00 00 00 
  803969:	ff d0                	callq  *%rax
}
  80396b:	c9                   	leaveq 
  80396c:	c3                   	retq   

000000000080396d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80396d:	55                   	push   %rbp
  80396e:	48 89 e5             	mov    %rsp,%rbp
  803971:	48 83 ec 10          	sub    $0x10,%rsp
  803975:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803978:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80397c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80397f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803986:	00 00 00 
  803989:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80398c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80398e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803991:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803995:	48 89 c6             	mov    %rax,%rsi
  803998:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80399f:	00 00 00 
  8039a2:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  8039a9:	00 00 00 
  8039ac:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8039ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b5:	00 00 00 
  8039b8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039bb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8039be:	bf 05 00 00 00       	mov    $0x5,%edi
  8039c3:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  8039ca:	00 00 00 
  8039cd:	ff d0                	callq  *%rax
}
  8039cf:	c9                   	leaveq 
  8039d0:	c3                   	retq   

00000000008039d1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8039d1:	55                   	push   %rbp
  8039d2:	48 89 e5             	mov    %rsp,%rbp
  8039d5:	48 83 ec 10          	sub    $0x10,%rsp
  8039d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039dc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8039df:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e6:	00 00 00 
  8039e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ec:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8039ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039f5:	00 00 00 
  8039f8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039fb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8039fe:	bf 06 00 00 00       	mov    $0x6,%edi
  803a03:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  803a0a:	00 00 00 
  803a0d:	ff d0                	callq  *%rax
}
  803a0f:	c9                   	leaveq 
  803a10:	c3                   	retq   

0000000000803a11 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a11:	55                   	push   %rbp
  803a12:	48 89 e5             	mov    %rsp,%rbp
  803a15:	48 83 ec 30          	sub    $0x30,%rsp
  803a19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a20:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803a23:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803a26:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a2d:	00 00 00 
  803a30:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a33:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803a35:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a3c:	00 00 00 
  803a3f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a42:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803a45:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a4c:	00 00 00 
  803a4f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a52:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a55:	bf 07 00 00 00       	mov    $0x7,%edi
  803a5a:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
  803a66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a6d:	78 69                	js     803ad8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803a6f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803a76:	7f 08                	jg     803a80 <nsipc_recv+0x6f>
  803a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803a7e:	7e 35                	jle    803ab5 <nsipc_recv+0xa4>
  803a80:	48 b9 02 4e 80 00 00 	movabs $0x804e02,%rcx
  803a87:	00 00 00 
  803a8a:	48 ba 17 4e 80 00 00 	movabs $0x804e17,%rdx
  803a91:	00 00 00 
  803a94:	be 61 00 00 00       	mov    $0x61,%esi
  803a99:	48 bf 2c 4e 80 00 00 	movabs $0x804e2c,%rdi
  803aa0:	00 00 00 
  803aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa8:	49 b8 14 0b 80 00 00 	movabs $0x800b14,%r8
  803aaf:	00 00 00 
  803ab2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab8:	48 63 d0             	movslq %eax,%rdx
  803abb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abf:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803ac6:	00 00 00 
  803ac9:	48 89 c7             	mov    %rax,%rdi
  803acc:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  803ad3:	00 00 00 
  803ad6:	ff d0                	callq  *%rax
	}

	return r;
  803ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803adb:	c9                   	leaveq 
  803adc:	c3                   	retq   

0000000000803add <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803add:	55                   	push   %rbp
  803ade:	48 89 e5             	mov    %rsp,%rbp
  803ae1:	48 83 ec 20          	sub    $0x20,%rsp
  803ae5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ae8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803aec:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803aef:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803af2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803af9:	00 00 00 
  803afc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aff:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b01:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803b08:	7e 35                	jle    803b3f <nsipc_send+0x62>
  803b0a:	48 b9 38 4e 80 00 00 	movabs $0x804e38,%rcx
  803b11:	00 00 00 
  803b14:	48 ba 17 4e 80 00 00 	movabs $0x804e17,%rdx
  803b1b:	00 00 00 
  803b1e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803b23:	48 bf 2c 4e 80 00 00 	movabs $0x804e2c,%rdi
  803b2a:	00 00 00 
  803b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b32:	49 b8 14 0b 80 00 00 	movabs $0x800b14,%r8
  803b39:	00 00 00 
  803b3c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b42:	48 63 d0             	movslq %eax,%rdx
  803b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b49:	48 89 c6             	mov    %rax,%rsi
  803b4c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803b53:	00 00 00 
  803b56:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  803b5d:	00 00 00 
  803b60:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803b62:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b69:	00 00 00 
  803b6c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b6f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803b72:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b79:	00 00 00 
  803b7c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b7f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803b82:	bf 08 00 00 00       	mov    $0x8,%edi
  803b87:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
}
  803b93:	c9                   	leaveq 
  803b94:	c3                   	retq   

0000000000803b95 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b95:	55                   	push   %rbp
  803b96:	48 89 e5             	mov    %rsp,%rbp
  803b99:	48 83 ec 10          	sub    $0x10,%rsp
  803b9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ba0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ba3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ba6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bad:	00 00 00 
  803bb0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bb3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803bb5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bbc:	00 00 00 
  803bbf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bc2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803bc5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bcc:	00 00 00 
  803bcf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803bd2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803bd5:	bf 09 00 00 00       	mov    $0x9,%edi
  803bda:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  803be1:	00 00 00 
  803be4:	ff d0                	callq  *%rax
}
  803be6:	c9                   	leaveq 
  803be7:	c3                   	retq   

0000000000803be8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803be8:	55                   	push   %rbp
  803be9:	48 89 e5             	mov    %rsp,%rbp
  803bec:	53                   	push   %rbx
  803bed:	48 83 ec 38          	sub    $0x38,%rsp
  803bf1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803bf5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803bf9:	48 89 c7             	mov    %rax,%rdi
  803bfc:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  803c03:	00 00 00 
  803c06:	ff d0                	callq  *%rax
  803c08:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c0f:	0f 88 bf 01 00 00    	js     803dd4 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c19:	ba 07 04 00 00       	mov    $0x407,%edx
  803c1e:	48 89 c6             	mov    %rax,%rsi
  803c21:	bf 00 00 00 00       	mov    $0x0,%edi
  803c26:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  803c2d:	00 00 00 
  803c30:	ff d0                	callq  *%rax
  803c32:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c35:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c39:	0f 88 95 01 00 00    	js     803dd4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c3f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c43:	48 89 c7             	mov    %rax,%rdi
  803c46:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
  803c52:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c55:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c59:	0f 88 5d 01 00 00    	js     803dbc <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c63:	ba 07 04 00 00       	mov    $0x407,%edx
  803c68:	48 89 c6             	mov    %rax,%rsi
  803c6b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c70:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  803c77:	00 00 00 
  803c7a:	ff d0                	callq  *%rax
  803c7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c83:	0f 88 33 01 00 00    	js     803dbc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c8d:	48 89 c7             	mov    %rax,%rdi
  803c90:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  803c97:	00 00 00 
  803c9a:	ff d0                	callq  *%rax
  803c9c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ca0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ca4:	ba 07 04 00 00       	mov    $0x407,%edx
  803ca9:	48 89 c6             	mov    %rax,%rsi
  803cac:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb1:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  803cb8:	00 00 00 
  803cbb:	ff d0                	callq  *%rax
  803cbd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cc4:	0f 88 d9 00 00 00    	js     803da3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cce:	48 89 c7             	mov    %rax,%rdi
  803cd1:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  803cd8:	00 00 00 
  803cdb:	ff d0                	callq  *%rax
  803cdd:	48 89 c2             	mov    %rax,%rdx
  803ce0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ce4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803cea:	48 89 d1             	mov    %rdx,%rcx
  803ced:	ba 00 00 00 00       	mov    $0x0,%edx
  803cf2:	48 89 c6             	mov    %rax,%rsi
  803cf5:	bf 00 00 00 00       	mov    $0x0,%edi
  803cfa:	48 b8 94 22 80 00 00 	movabs $0x802294,%rax
  803d01:	00 00 00 
  803d04:	ff d0                	callq  *%rax
  803d06:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d09:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d0d:	78 79                	js     803d88 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803d0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d13:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803d1a:	00 00 00 
  803d1d:	8b 12                	mov    (%rdx),%edx
  803d1f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d30:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803d37:	00 00 00 
  803d3a:	8b 12                	mov    (%rdx),%edx
  803d3c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d42:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803d49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d4d:	48 89 c7             	mov    %rax,%rdi
  803d50:	48 b8 d4 26 80 00 00 	movabs $0x8026d4,%rax
  803d57:	00 00 00 
  803d5a:	ff d0                	callq  *%rax
  803d5c:	89 c2                	mov    %eax,%edx
  803d5e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d62:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803d64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d68:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d70:	48 89 c7             	mov    %rax,%rdi
  803d73:	48 b8 d4 26 80 00 00 	movabs $0x8026d4,%rax
  803d7a:	00 00 00 
  803d7d:	ff d0                	callq  *%rax
  803d7f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d81:	b8 00 00 00 00       	mov    $0x0,%eax
  803d86:	eb 4f                	jmp    803dd7 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803d88:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803d89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d8d:	48 89 c6             	mov    %rax,%rsi
  803d90:	bf 00 00 00 00       	mov    $0x0,%edi
  803d95:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  803d9c:	00 00 00 
  803d9f:	ff d0                	callq  *%rax
  803da1:	eb 01                	jmp    803da4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803da3:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803da4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da8:	48 89 c6             	mov    %rax,%rsi
  803dab:	bf 00 00 00 00       	mov    $0x0,%edi
  803db0:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  803db7:	00 00 00 
  803dba:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803dbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dc0:	48 89 c6             	mov    %rax,%rsi
  803dc3:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc8:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  803dcf:	00 00 00 
  803dd2:	ff d0                	callq  *%rax
    err:
	return r;
  803dd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803dd7:	48 83 c4 38          	add    $0x38,%rsp
  803ddb:	5b                   	pop    %rbx
  803ddc:	5d                   	pop    %rbp
  803ddd:	c3                   	retq   

0000000000803dde <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803dde:	55                   	push   %rbp
  803ddf:	48 89 e5             	mov    %rsp,%rbp
  803de2:	53                   	push   %rbx
  803de3:	48 83 ec 28          	sub    $0x28,%rsp
  803de7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803deb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803def:	eb 01                	jmp    803df2 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803df1:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803df2:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  803df9:	00 00 00 
  803dfc:	48 8b 00             	mov    (%rax),%rax
  803dff:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e05:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e0c:	48 89 c7             	mov    %rax,%rdi
  803e0f:	48 b8 6c 46 80 00 00 	movabs $0x80466c,%rax
  803e16:	00 00 00 
  803e19:	ff d0                	callq  *%rax
  803e1b:	89 c3                	mov    %eax,%ebx
  803e1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e21:	48 89 c7             	mov    %rax,%rdi
  803e24:	48 b8 6c 46 80 00 00 	movabs $0x80466c,%rax
  803e2b:	00 00 00 
  803e2e:	ff d0                	callq  *%rax
  803e30:	39 c3                	cmp    %eax,%ebx
  803e32:	0f 94 c0             	sete   %al
  803e35:	0f b6 c0             	movzbl %al,%eax
  803e38:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e3b:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  803e42:	00 00 00 
  803e45:	48 8b 00             	mov    (%rax),%rax
  803e48:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e4e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e51:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e54:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e57:	75 0a                	jne    803e63 <_pipeisclosed+0x85>
			return ret;
  803e59:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803e5c:	48 83 c4 28          	add    $0x28,%rsp
  803e60:	5b                   	pop    %rbx
  803e61:	5d                   	pop    %rbp
  803e62:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803e63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e66:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e69:	74 86                	je     803df1 <_pipeisclosed+0x13>
  803e6b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803e6f:	75 80                	jne    803df1 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803e71:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  803e78:	00 00 00 
  803e7b:	48 8b 00             	mov    (%rax),%rax
  803e7e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803e84:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e8a:	89 c6                	mov    %eax,%esi
  803e8c:	48 bf 49 4e 80 00 00 	movabs $0x804e49,%rdi
  803e93:	00 00 00 
  803e96:	b8 00 00 00 00       	mov    $0x0,%eax
  803e9b:	49 b8 4f 0d 80 00 00 	movabs $0x800d4f,%r8
  803ea2:	00 00 00 
  803ea5:	41 ff d0             	callq  *%r8
	}
  803ea8:	e9 44 ff ff ff       	jmpq   803df1 <_pipeisclosed+0x13>

0000000000803ead <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803ead:	55                   	push   %rbp
  803eae:	48 89 e5             	mov    %rsp,%rbp
  803eb1:	48 83 ec 30          	sub    $0x30,%rsp
  803eb5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803eb8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ebc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ebf:	48 89 d6             	mov    %rdx,%rsi
  803ec2:	89 c7                	mov    %eax,%edi
  803ec4:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  803ecb:	00 00 00 
  803ece:	ff d0                	callq  *%rax
  803ed0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ed3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ed7:	79 05                	jns    803ede <pipeisclosed+0x31>
		return r;
  803ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803edc:	eb 31                	jmp    803f0f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ede:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee2:	48 89 c7             	mov    %rax,%rdi
  803ee5:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  803eec:	00 00 00 
  803eef:	ff d0                	callq  *%rax
  803ef1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803efd:	48 89 d6             	mov    %rdx,%rsi
  803f00:	48 89 c7             	mov    %rax,%rdi
  803f03:	48 b8 de 3d 80 00 00 	movabs $0x803dde,%rax
  803f0a:	00 00 00 
  803f0d:	ff d0                	callq  *%rax
}
  803f0f:	c9                   	leaveq 
  803f10:	c3                   	retq   

0000000000803f11 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f11:	55                   	push   %rbp
  803f12:	48 89 e5             	mov    %rsp,%rbp
  803f15:	48 83 ec 40          	sub    $0x40,%rsp
  803f19:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f29:	48 89 c7             	mov    %rax,%rdi
  803f2c:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  803f33:	00 00 00 
  803f36:	ff d0                	callq  *%rax
  803f38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f44:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f4b:	00 
  803f4c:	e9 97 00 00 00       	jmpq   803fe8 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f51:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f56:	74 09                	je     803f61 <devpipe_read+0x50>
				return i;
  803f58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f5c:	e9 95 00 00 00       	jmpq   803ff6 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803f61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f69:	48 89 d6             	mov    %rdx,%rsi
  803f6c:	48 89 c7             	mov    %rax,%rdi
  803f6f:	48 b8 de 3d 80 00 00 	movabs $0x803dde,%rax
  803f76:	00 00 00 
  803f79:	ff d0                	callq  *%rax
  803f7b:	85 c0                	test   %eax,%eax
  803f7d:	74 07                	je     803f86 <devpipe_read+0x75>
				return 0;
  803f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f84:	eb 70                	jmp    803ff6 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f86:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  803f8d:	00 00 00 
  803f90:	ff d0                	callq  *%rax
  803f92:	eb 01                	jmp    803f95 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f94:	90                   	nop
  803f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f99:	8b 10                	mov    (%rax),%edx
  803f9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f9f:	8b 40 04             	mov    0x4(%rax),%eax
  803fa2:	39 c2                	cmp    %eax,%edx
  803fa4:	74 ab                	je     803f51 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803fa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803faa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fae:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fb6:	8b 00                	mov    (%rax),%eax
  803fb8:	89 c2                	mov    %eax,%edx
  803fba:	c1 fa 1f             	sar    $0x1f,%edx
  803fbd:	c1 ea 1b             	shr    $0x1b,%edx
  803fc0:	01 d0                	add    %edx,%eax
  803fc2:	83 e0 1f             	and    $0x1f,%eax
  803fc5:	29 d0                	sub    %edx,%eax
  803fc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fcb:	48 98                	cltq   
  803fcd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803fd2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd8:	8b 00                	mov    (%rax),%eax
  803fda:	8d 50 01             	lea    0x1(%rax),%edx
  803fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803fe3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fec:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ff0:	72 a2                	jb     803f94 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ff2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ff6:	c9                   	leaveq 
  803ff7:	c3                   	retq   

0000000000803ff8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ff8:	55                   	push   %rbp
  803ff9:	48 89 e5             	mov    %rsp,%rbp
  803ffc:	48 83 ec 40          	sub    $0x40,%rsp
  804000:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804004:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804008:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80400c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804010:	48 89 c7             	mov    %rax,%rdi
  804013:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  80401a:	00 00 00 
  80401d:	ff d0                	callq  *%rax
  80401f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804023:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804027:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80402b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804032:	00 
  804033:	e9 93 00 00 00       	jmpq   8040cb <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804038:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80403c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804040:	48 89 d6             	mov    %rdx,%rsi
  804043:	48 89 c7             	mov    %rax,%rdi
  804046:	48 b8 de 3d 80 00 00 	movabs $0x803dde,%rax
  80404d:	00 00 00 
  804050:	ff d0                	callq  *%rax
  804052:	85 c0                	test   %eax,%eax
  804054:	74 07                	je     80405d <devpipe_write+0x65>
				return 0;
  804056:	b8 00 00 00 00       	mov    $0x0,%eax
  80405b:	eb 7c                	jmp    8040d9 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80405d:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  804064:	00 00 00 
  804067:	ff d0                	callq  *%rax
  804069:	eb 01                	jmp    80406c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80406b:	90                   	nop
  80406c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804070:	8b 40 04             	mov    0x4(%rax),%eax
  804073:	48 63 d0             	movslq %eax,%rdx
  804076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80407a:	8b 00                	mov    (%rax),%eax
  80407c:	48 98                	cltq   
  80407e:	48 83 c0 20          	add    $0x20,%rax
  804082:	48 39 c2             	cmp    %rax,%rdx
  804085:	73 b1                	jae    804038 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804087:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408b:	8b 40 04             	mov    0x4(%rax),%eax
  80408e:	89 c2                	mov    %eax,%edx
  804090:	c1 fa 1f             	sar    $0x1f,%edx
  804093:	c1 ea 1b             	shr    $0x1b,%edx
  804096:	01 d0                	add    %edx,%eax
  804098:	83 e0 1f             	and    $0x1f,%eax
  80409b:	29 d0                	sub    %edx,%eax
  80409d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8040a1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8040a5:	48 01 ca             	add    %rcx,%rdx
  8040a8:	0f b6 0a             	movzbl (%rdx),%ecx
  8040ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040af:	48 98                	cltq   
  8040b1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8040b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b9:	8b 40 04             	mov    0x4(%rax),%eax
  8040bc:	8d 50 01             	lea    0x1(%rax),%edx
  8040bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040cf:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040d3:	72 96                	jb     80406b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8040d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040d9:	c9                   	leaveq 
  8040da:	c3                   	retq   

00000000008040db <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8040db:	55                   	push   %rbp
  8040dc:	48 89 e5             	mov    %rsp,%rbp
  8040df:	48 83 ec 20          	sub    $0x20,%rsp
  8040e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8040eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ef:	48 89 c7             	mov    %rax,%rdi
  8040f2:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  8040f9:	00 00 00 
  8040fc:	ff d0                	callq  *%rax
  8040fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804102:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804106:	48 be 5c 4e 80 00 00 	movabs $0x804e5c,%rsi
  80410d:	00 00 00 
  804110:	48 89 c7             	mov    %rax,%rdi
  804113:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  80411a:	00 00 00 
  80411d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80411f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804123:	8b 50 04             	mov    0x4(%rax),%edx
  804126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80412a:	8b 00                	mov    (%rax),%eax
  80412c:	29 c2                	sub    %eax,%edx
  80412e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804132:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804138:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80413c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804143:	00 00 00 
	stat->st_dev = &devpipe;
  804146:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80414a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  804151:	00 00 00 
  804154:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80415b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804160:	c9                   	leaveq 
  804161:	c3                   	retq   

0000000000804162 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804162:	55                   	push   %rbp
  804163:	48 89 e5             	mov    %rsp,%rbp
  804166:	48 83 ec 10          	sub    $0x10,%rsp
  80416a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80416e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804172:	48 89 c6             	mov    %rax,%rsi
  804175:	bf 00 00 00 00       	mov    $0x0,%edi
  80417a:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  804181:	00 00 00 
  804184:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804186:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80418a:	48 89 c7             	mov    %rax,%rdi
  80418d:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  804194:	00 00 00 
  804197:	ff d0                	callq  *%rax
  804199:	48 89 c6             	mov    %rax,%rsi
  80419c:	bf 00 00 00 00       	mov    $0x0,%edi
  8041a1:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  8041a8:	00 00 00 
  8041ab:	ff d0                	callq  *%rax
}
  8041ad:	c9                   	leaveq 
  8041ae:	c3                   	retq   
	...

00000000008041b0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8041b0:	55                   	push   %rbp
  8041b1:	48 89 e5             	mov    %rsp,%rbp
  8041b4:	48 83 ec 20          	sub    $0x20,%rsp
  8041b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8041bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041be:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8041c1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8041c5:	be 01 00 00 00       	mov    $0x1,%esi
  8041ca:	48 89 c7             	mov    %rax,%rdi
  8041cd:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  8041d4:	00 00 00 
  8041d7:	ff d0                	callq  *%rax
}
  8041d9:	c9                   	leaveq 
  8041da:	c3                   	retq   

00000000008041db <getchar>:

int
getchar(void)
{
  8041db:	55                   	push   %rbp
  8041dc:	48 89 e5             	mov    %rsp,%rbp
  8041df:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8041e3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8041e7:	ba 01 00 00 00       	mov    $0x1,%edx
  8041ec:	48 89 c6             	mov    %rax,%rsi
  8041ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8041f4:	48 b8 ec 2b 80 00 00 	movabs $0x802bec,%rax
  8041fb:	00 00 00 
  8041fe:	ff d0                	callq  *%rax
  804200:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804203:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804207:	79 05                	jns    80420e <getchar+0x33>
		return r;
  804209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80420c:	eb 14                	jmp    804222 <getchar+0x47>
	if (r < 1)
  80420e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804212:	7f 07                	jg     80421b <getchar+0x40>
		return -E_EOF;
  804214:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804219:	eb 07                	jmp    804222 <getchar+0x47>
	return c;
  80421b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80421f:	0f b6 c0             	movzbl %al,%eax
}
  804222:	c9                   	leaveq 
  804223:	c3                   	retq   

0000000000804224 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804224:	55                   	push   %rbp
  804225:	48 89 e5             	mov    %rsp,%rbp
  804228:	48 83 ec 20          	sub    $0x20,%rsp
  80422c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80422f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804233:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804236:	48 89 d6             	mov    %rdx,%rsi
  804239:	89 c7                	mov    %eax,%edi
  80423b:	48 b8 ba 27 80 00 00 	movabs $0x8027ba,%rax
  804242:	00 00 00 
  804245:	ff d0                	callq  *%rax
  804247:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80424a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80424e:	79 05                	jns    804255 <iscons+0x31>
		return r;
  804250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804253:	eb 1a                	jmp    80426f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804259:	8b 10                	mov    (%rax),%edx
  80425b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804262:	00 00 00 
  804265:	8b 00                	mov    (%rax),%eax
  804267:	39 c2                	cmp    %eax,%edx
  804269:	0f 94 c0             	sete   %al
  80426c:	0f b6 c0             	movzbl %al,%eax
}
  80426f:	c9                   	leaveq 
  804270:	c3                   	retq   

0000000000804271 <opencons>:

int
opencons(void)
{
  804271:	55                   	push   %rbp
  804272:	48 89 e5             	mov    %rsp,%rbp
  804275:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804279:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80427d:	48 89 c7             	mov    %rax,%rdi
  804280:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  804287:	00 00 00 
  80428a:	ff d0                	callq  *%rax
  80428c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80428f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804293:	79 05                	jns    80429a <opencons+0x29>
		return r;
  804295:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804298:	eb 5b                	jmp    8042f5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80429a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80429e:	ba 07 04 00 00       	mov    $0x407,%edx
  8042a3:	48 89 c6             	mov    %rax,%rsi
  8042a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8042ab:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  8042b2:	00 00 00 
  8042b5:	ff d0                	callq  *%rax
  8042b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042be:	79 05                	jns    8042c5 <opencons+0x54>
		return r;
  8042c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c3:	eb 30                	jmp    8042f5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8042c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8042d0:	00 00 00 
  8042d3:	8b 12                	mov    (%rdx),%edx
  8042d5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8042d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8042e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e6:	48 89 c7             	mov    %rax,%rdi
  8042e9:	48 b8 d4 26 80 00 00 	movabs $0x8026d4,%rax
  8042f0:	00 00 00 
  8042f3:	ff d0                	callq  *%rax
}
  8042f5:	c9                   	leaveq 
  8042f6:	c3                   	retq   

00000000008042f7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8042f7:	55                   	push   %rbp
  8042f8:	48 89 e5             	mov    %rsp,%rbp
  8042fb:	48 83 ec 30          	sub    $0x30,%rsp
  8042ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804303:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804307:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80430b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804310:	75 13                	jne    804325 <devcons_read+0x2e>
		return 0;
  804312:	b8 00 00 00 00       	mov    $0x0,%eax
  804317:	eb 49                	jmp    804362 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804319:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  804320:	00 00 00 
  804323:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804325:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  80432c:	00 00 00 
  80432f:	ff d0                	callq  *%rax
  804331:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804334:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804338:	74 df                	je     804319 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80433a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80433e:	79 05                	jns    804345 <devcons_read+0x4e>
		return c;
  804340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804343:	eb 1d                	jmp    804362 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804345:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804349:	75 07                	jne    804352 <devcons_read+0x5b>
		return 0;
  80434b:	b8 00 00 00 00       	mov    $0x0,%eax
  804350:	eb 10                	jmp    804362 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804352:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804355:	89 c2                	mov    %eax,%edx
  804357:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80435b:	88 10                	mov    %dl,(%rax)
	return 1;
  80435d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804362:	c9                   	leaveq 
  804363:	c3                   	retq   

0000000000804364 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804364:	55                   	push   %rbp
  804365:	48 89 e5             	mov    %rsp,%rbp
  804368:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80436f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804376:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80437d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804384:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80438b:	eb 77                	jmp    804404 <devcons_write+0xa0>
		m = n - tot;
  80438d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804394:	89 c2                	mov    %eax,%edx
  804396:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804399:	89 d1                	mov    %edx,%ecx
  80439b:	29 c1                	sub    %eax,%ecx
  80439d:	89 c8                	mov    %ecx,%eax
  80439f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8043a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043a5:	83 f8 7f             	cmp    $0x7f,%eax
  8043a8:	76 07                	jbe    8043b1 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8043aa:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8043b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043b4:	48 63 d0             	movslq %eax,%rdx
  8043b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ba:	48 98                	cltq   
  8043bc:	48 89 c1             	mov    %rax,%rcx
  8043bf:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8043c6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8043cd:	48 89 ce             	mov    %rcx,%rsi
  8043d0:	48 89 c7             	mov    %rax,%rdi
  8043d3:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  8043da:	00 00 00 
  8043dd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8043df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043e2:	48 63 d0             	movslq %eax,%rdx
  8043e5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8043ec:	48 89 d6             	mov    %rdx,%rsi
  8043ef:	48 89 c7             	mov    %rax,%rdi
  8043f2:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  8043f9:	00 00 00 
  8043fc:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8043fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804401:	01 45 fc             	add    %eax,-0x4(%rbp)
  804404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804407:	48 98                	cltq   
  804409:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804410:	0f 82 77 ff ff ff    	jb     80438d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804416:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804419:	c9                   	leaveq 
  80441a:	c3                   	retq   

000000000080441b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80441b:	55                   	push   %rbp
  80441c:	48 89 e5             	mov    %rsp,%rbp
  80441f:	48 83 ec 08          	sub    $0x8,%rsp
  804423:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804427:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80442c:	c9                   	leaveq 
  80442d:	c3                   	retq   

000000000080442e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80442e:	55                   	push   %rbp
  80442f:	48 89 e5             	mov    %rsp,%rbp
  804432:	48 83 ec 10          	sub    $0x10,%rsp
  804436:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80443a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80443e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804442:	48 be 68 4e 80 00 00 	movabs $0x804e68,%rsi
  804449:	00 00 00 
  80444c:	48 89 c7             	mov    %rax,%rdi
  80444f:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  804456:	00 00 00 
  804459:	ff d0                	callq  *%rax
	return 0;
  80445b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804460:	c9                   	leaveq 
  804461:	c3                   	retq   
	...

0000000000804464 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804464:	55                   	push   %rbp
  804465:	48 89 e5             	mov    %rsp,%rbp
  804468:	48 83 ec 30          	sub    $0x30,%rsp
  80446c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804470:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804474:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  804478:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80447d:	74 18                	je     804497 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80447f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804483:	48 89 c7             	mov    %rax,%rdi
  804486:	48 b8 6d 24 80 00 00 	movabs $0x80246d,%rax
  80448d:	00 00 00 
  804490:	ff d0                	callq  *%rax
  804492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804495:	eb 19                	jmp    8044b0 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  804497:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80449e:	00 00 00 
  8044a1:	48 b8 6d 24 80 00 00 	movabs $0x80246d,%rax
  8044a8:	00 00 00 
  8044ab:	ff d0                	callq  *%rax
  8044ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8044b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b4:	79 19                	jns    8044cf <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8044b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ba:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8044c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044c4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8044ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044cd:	eb 53                	jmp    804522 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8044cf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8044d4:	74 19                	je     8044ef <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8044d6:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  8044dd:	00 00 00 
  8044e0:	48 8b 00             	mov    (%rax),%rax
  8044e3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8044e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ed:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8044ef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044f4:	74 19                	je     80450f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8044f6:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  8044fd:	00 00 00 
  804500:	48 8b 00             	mov    (%rax),%rax
  804503:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80450d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80450f:	48 b8 30 72 80 00 00 	movabs $0x807230,%rax
  804516:	00 00 00 
  804519:	48 8b 00             	mov    (%rax),%rax
  80451c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  804522:	c9                   	leaveq 
  804523:	c3                   	retq   

0000000000804524 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804524:	55                   	push   %rbp
  804525:	48 89 e5             	mov    %rsp,%rbp
  804528:	48 83 ec 30          	sub    $0x30,%rsp
  80452c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80452f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804532:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804536:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  804539:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804540:	e9 96 00 00 00       	jmpq   8045db <ipc_send+0xb7>
	{
		if(pg!=NULL)
  804545:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80454a:	74 20                	je     80456c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  80454c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80454f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804552:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804556:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804559:	89 c7                	mov    %eax,%edi
  80455b:	48 b8 18 24 80 00 00 	movabs $0x802418,%rax
  804562:	00 00 00 
  804565:	ff d0                	callq  *%rax
  804567:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80456a:	eb 2d                	jmp    804599 <ipc_send+0x75>
		else if(pg==NULL)
  80456c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804571:	75 26                	jne    804599 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  804573:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804576:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804579:	b9 00 00 00 00       	mov    $0x0,%ecx
  80457e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804585:	00 00 00 
  804588:	89 c7                	mov    %eax,%edi
  80458a:	48 b8 18 24 80 00 00 	movabs $0x802418,%rax
  804591:	00 00 00 
  804594:	ff d0                	callq  *%rax
  804596:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  804599:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80459d:	79 30                	jns    8045cf <ipc_send+0xab>
  80459f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8045a3:	74 2a                	je     8045cf <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8045a5:	48 ba 6f 4e 80 00 00 	movabs $0x804e6f,%rdx
  8045ac:	00 00 00 
  8045af:	be 40 00 00 00       	mov    $0x40,%esi
  8045b4:	48 bf 87 4e 80 00 00 	movabs $0x804e87,%rdi
  8045bb:	00 00 00 
  8045be:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c3:	48 b9 14 0b 80 00 00 	movabs $0x800b14,%rcx
  8045ca:	00 00 00 
  8045cd:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8045cf:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  8045d6:	00 00 00 
  8045d9:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8045db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045df:	0f 85 60 ff ff ff    	jne    804545 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8045e5:	c9                   	leaveq 
  8045e6:	c3                   	retq   

00000000008045e7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8045e7:	55                   	push   %rbp
  8045e8:	48 89 e5             	mov    %rsp,%rbp
  8045eb:	48 83 ec 18          	sub    $0x18,%rsp
  8045ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8045f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045f9:	eb 5e                	jmp    804659 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8045fb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804602:	00 00 00 
  804605:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804608:	48 63 d0             	movslq %eax,%rdx
  80460b:	48 89 d0             	mov    %rdx,%rax
  80460e:	48 c1 e0 03          	shl    $0x3,%rax
  804612:	48 01 d0             	add    %rdx,%rax
  804615:	48 c1 e0 05          	shl    $0x5,%rax
  804619:	48 01 c8             	add    %rcx,%rax
  80461c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804622:	8b 00                	mov    (%rax),%eax
  804624:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804627:	75 2c                	jne    804655 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804629:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804630:	00 00 00 
  804633:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804636:	48 63 d0             	movslq %eax,%rdx
  804639:	48 89 d0             	mov    %rdx,%rax
  80463c:	48 c1 e0 03          	shl    $0x3,%rax
  804640:	48 01 d0             	add    %rdx,%rax
  804643:	48 c1 e0 05          	shl    $0x5,%rax
  804647:	48 01 c8             	add    %rcx,%rax
  80464a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804650:	8b 40 08             	mov    0x8(%rax),%eax
  804653:	eb 12                	jmp    804667 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804655:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804659:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804660:	7e 99                	jle    8045fb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804662:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804667:	c9                   	leaveq 
  804668:	c3                   	retq   
  804669:	00 00                	add    %al,(%rax)
	...

000000000080466c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80466c:	55                   	push   %rbp
  80466d:	48 89 e5             	mov    %rsp,%rbp
  804670:	48 83 ec 18          	sub    $0x18,%rsp
  804674:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80467c:	48 89 c2             	mov    %rax,%rdx
  80467f:	48 c1 ea 15          	shr    $0x15,%rdx
  804683:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80468a:	01 00 00 
  80468d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804691:	83 e0 01             	and    $0x1,%eax
  804694:	48 85 c0             	test   %rax,%rax
  804697:	75 07                	jne    8046a0 <pageref+0x34>
		return 0;
  804699:	b8 00 00 00 00       	mov    $0x0,%eax
  80469e:	eb 53                	jmp    8046f3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8046a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046a4:	48 89 c2             	mov    %rax,%rdx
  8046a7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8046ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8046b2:	01 00 00 
  8046b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8046bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046c1:	83 e0 01             	and    $0x1,%eax
  8046c4:	48 85 c0             	test   %rax,%rax
  8046c7:	75 07                	jne    8046d0 <pageref+0x64>
		return 0;
  8046c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ce:	eb 23                	jmp    8046f3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8046d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046d4:	48 89 c2             	mov    %rax,%rdx
  8046d7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8046db:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8046e2:	00 00 00 
  8046e5:	48 c1 e2 04          	shl    $0x4,%rdx
  8046e9:	48 01 d0             	add    %rdx,%rax
  8046ec:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8046f0:	0f b7 c0             	movzwl %ax,%eax
}
  8046f3:	c9                   	leaveq 
  8046f4:	c3                   	retq   
