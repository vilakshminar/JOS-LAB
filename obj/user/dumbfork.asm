
obj/user/dumbfork.debug:     file format elf64-x86-64


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
  80003c:	e8 33 03 00 00       	callq  800374 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  800053:	48 b8 04 02 80 00 00 	movabs $0x800204,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800069:	eb 4f                	jmp    8000ba <umain+0x76>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80006b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80006f:	74 0c                	je     80007d <umain+0x39>
  800071:	48 b8 e0 3e 80 00 00 	movabs $0x803ee0,%rax
  800078:	00 00 00 
  80007b:	eb 0a                	jmp    800087 <umain+0x43>
  80007d:	48 b8 e7 3e 80 00 00 	movabs $0x803ee7,%rax
  800084:	00 00 00 
  800087:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80008a:	48 89 c2             	mov    %rax,%rdx
  80008d:	89 ce                	mov    %ecx,%esi
  80008f:	48 bf ed 3e 80 00 00 	movabs $0x803eed,%rdi
  800096:	00 00 00 
  800099:	b8 00 00 00 00       	mov    $0x0,%eax
  80009e:	48 b9 77 06 80 00 00 	movabs $0x800677,%rcx
  8000a5:	00 00 00 
  8000a8:	ff d1                	callq  *%rcx
		sys_yield();
  8000aa:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8000b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000be:	74 07                	je     8000c7 <umain+0x83>
  8000c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8000c5:	eb 05                	jmp    8000cc <umain+0x88>
  8000c7:	b8 14 00 00 00       	mov    $0x14,%eax
  8000cc:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000cf:	7f 9a                	jg     80006b <umain+0x27>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <duppage>:

void
duppage(envid_t dstenv, void *addr)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 20          	sub    $0x20,%rsp
  8000db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8000e2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8000e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e9:	ba 07 00 00 00       	mov    $0x7,%edx
  8000ee:	48 89 ce             	mov    %rcx,%rsi
  8000f1:	89 c7                	mov    %eax,%edi
  8000f3:	48 b8 6c 1b 80 00 00 	movabs $0x801b6c,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
  8000ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800106:	79 30                	jns    800138 <duppage+0x65>
		panic("sys_page_alloc: %e", r);
  800108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010b:	89 c1                	mov    %eax,%ecx
  80010d:	48 ba ff 3e 80 00 00 	movabs $0x803eff,%rdx
  800114:	00 00 00 
  800117:	be 20 00 00 00       	mov    $0x20,%esi
  80011c:	48 bf 12 3f 80 00 00 	movabs $0x803f12,%rdi
  800123:	00 00 00 
  800126:	b8 00 00 00 00       	mov    $0x0,%eax
  80012b:	49 b8 3c 04 80 00 00 	movabs $0x80043c,%r8
  800132:	00 00 00 
  800135:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800138:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80013c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80013f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800145:	b9 00 00 40 00       	mov    $0x400000,%ecx
  80014a:	ba 00 00 00 00       	mov    $0x0,%edx
  80014f:	89 c7                	mov    %eax,%edi
  800151:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
  800158:	00 00 00 
  80015b:	ff d0                	callq  *%rax
  80015d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800160:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800164:	79 30                	jns    800196 <duppage+0xc3>
		panic("sys_page_map: %e", r);
  800166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800169:	89 c1                	mov    %eax,%ecx
  80016b:	48 ba 22 3f 80 00 00 	movabs $0x803f22,%rdx
  800172:	00 00 00 
  800175:	be 22 00 00 00       	mov    $0x22,%esi
  80017a:	48 bf 12 3f 80 00 00 	movabs $0x803f12,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	49 b8 3c 04 80 00 00 	movabs $0x80043c,%r8
  800190:	00 00 00 
  800193:	41 ff d0             	callq  *%r8
	memmove(UTEMP, addr, PGSIZE);
  800196:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80019a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80019f:	48 89 c6             	mov    %rax,%rsi
  8001a2:	bf 00 00 40 00       	mov    $0x400000,%edi
  8001a7:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8001b3:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bd:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
  8001c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d0:	79 30                	jns    800202 <duppage+0x12f>
		panic("sys_page_unmap: %e", r);
  8001d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d5:	89 c1                	mov    %eax,%ecx
  8001d7:	48 ba 33 3f 80 00 00 	movabs $0x803f33,%rdx
  8001de:	00 00 00 
  8001e1:	be 25 00 00 00       	mov    $0x25,%esi
  8001e6:	48 bf 12 3f 80 00 00 	movabs $0x803f12,%rdi
  8001ed:	00 00 00 
  8001f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f5:	49 b8 3c 04 80 00 00 	movabs $0x80043c,%r8
  8001fc:	00 00 00 
  8001ff:	41 ff d0             	callq  *%r8
}
  800202:	c9                   	leaveq 
  800203:	c3                   	retq   

0000000000800204 <dumbfork>:

envid_t
dumbfork(void)
{
  800204:	55                   	push   %rbp
  800205:	48 89 e5             	mov    %rsp,%rbp
  800208:	53                   	push   %rbx
  800209:	48 83 ec 38          	sub    $0x38,%rsp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80020d:	c7 45 cc 07 00 00 00 	movl   $0x7,-0x34(%rbp)
  800214:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800217:	cd 30                	int    $0x30
  800219:	89 c3                	mov    %eax,%ebx
  80021b:	89 5d d8             	mov    %ebx,-0x28(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80021e:	8b 45 d8             	mov    -0x28(%rbp),%eax
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
  800221:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (envid < 0)
  800224:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800228:	79 30                	jns    80025a <dumbfork+0x56>
		panic("sys_exofork: %e", envid);
  80022a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022d:	89 c1                	mov    %eax,%ecx
  80022f:	48 ba 46 3f 80 00 00 	movabs $0x803f46,%rdx
  800236:	00 00 00 
  800239:	be 37 00 00 00       	mov    $0x37,%esi
  80023e:	48 bf 12 3f 80 00 00 	movabs $0x803f12,%rdi
  800245:	00 00 00 
  800248:	b8 00 00 00 00       	mov    $0x0,%eax
  80024d:	49 b8 3c 04 80 00 00 	movabs $0x80043c,%r8
  800254:	00 00 00 
  800257:	41 ff d0             	callq  *%r8
	if (envid == 0) {
  80025a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025e:	75 4c                	jne    8002ac <dumbfork+0xa8>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800260:	48 b8 f0 1a 80 00 00 	movabs $0x801af0,%rax
  800267:	00 00 00 
  80026a:	ff d0                	callq  *%rax
  80026c:	48 98                	cltq   
  80026e:	48 89 c2             	mov    %rax,%rdx
  800271:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800277:	48 89 d0             	mov    %rdx,%rax
  80027a:	48 c1 e0 03          	shl    $0x3,%rax
  80027e:	48 01 d0             	add    %rdx,%rax
  800281:	48 c1 e0 05          	shl    $0x5,%rax
  800285:	48 89 c2             	mov    %rax,%rdx
  800288:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80028f:	00 00 00 
  800292:	48 01 c2             	add    %rax,%rdx
  800295:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80029c:	00 00 00 
  80029f:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8002a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a7:	e9 be 00 00 00       	jmpq   80036a <dumbfork+0x166>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8002ac:	48 c7 45 d0 00 00 80 	movq   $0x800000,-0x30(%rbp)
  8002b3:	00 
  8002b4:	eb 26                	jmp    8002dc <dumbfork+0xd8>
		duppage(envid, addr);
  8002b6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8002ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bd:	48 89 d6             	mov    %rdx,%rsi
  8002c0:	89 c7                	mov    %eax,%edi
  8002c2:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8002c9:	00 00 00 
  8002cc:	ff d0                	callq  *%rax
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8002ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8002d2:	48 05 00 10 00 00    	add    $0x1000,%rax
  8002d8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8002dc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8002e0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8002e7:	00 00 00 
  8002ea:	48 39 c2             	cmp    %rax,%rdx
  8002ed:	72 c7                	jb     8002b6 <dumbfork+0xb2>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8002ef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002f3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8002f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002fb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800301:	48 89 c2             	mov    %rax,%rdx
  800304:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800307:	48 89 d6             	mov    %rdx,%rsi
  80030a:	89 c7                	mov    %eax,%edi
  80030c:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800318:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80031b:	be 02 00 00 00       	mov    $0x2,%esi
  800320:	89 c7                	mov    %eax,%edi
  800322:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  800329:	00 00 00 
  80032c:	ff d0                	callq  *%rax
  80032e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800331:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800335:	79 30                	jns    800367 <dumbfork+0x163>
		panic("sys_env_set_status: %e", r);
  800337:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80033a:	89 c1                	mov    %eax,%ecx
  80033c:	48 ba 56 3f 80 00 00 	movabs $0x803f56,%rdx
  800343:	00 00 00 
  800346:	be 4c 00 00 00       	mov    $0x4c,%esi
  80034b:	48 bf 12 3f 80 00 00 	movabs $0x803f12,%rdi
  800352:	00 00 00 
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	49 b8 3c 04 80 00 00 	movabs $0x80043c,%r8
  800361:	00 00 00 
  800364:	41 ff d0             	callq  *%r8

	return envid;
  800367:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80036a:	48 83 c4 38          	add    $0x38,%rsp
  80036e:	5b                   	pop    %rbx
  80036f:	5d                   	pop    %rbp
  800370:	c3                   	retq   
  800371:	00 00                	add    %al,(%rax)
	...

0000000000800374 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800374:	55                   	push   %rbp
  800375:	48 89 e5             	mov    %rsp,%rbp
  800378:	48 83 ec 10          	sub    $0x10,%rsp
  80037c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80037f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800383:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80038a:	00 00 00 
  80038d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800394:	48 b8 f0 1a 80 00 00 	movabs $0x801af0,%rax
  80039b:	00 00 00 
  80039e:	ff d0                	callq  *%rax
  8003a0:	48 98                	cltq   
  8003a2:	48 89 c2             	mov    %rax,%rdx
  8003a5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8003ab:	48 89 d0             	mov    %rdx,%rax
  8003ae:	48 c1 e0 03          	shl    $0x3,%rax
  8003b2:	48 01 d0             	add    %rdx,%rax
  8003b5:	48 c1 e0 05          	shl    $0x5,%rax
  8003b9:	48 89 c2             	mov    %rax,%rdx
  8003bc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003c3:	00 00 00 
  8003c6:	48 01 c2             	add    %rax,%rdx
  8003c9:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8003d0:	00 00 00 
  8003d3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003da:	7e 14                	jle    8003f0 <libmain+0x7c>
		binaryname = argv[0];
  8003dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e0:	48 8b 10             	mov    (%rax),%rdx
  8003e3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003ea:	00 00 00 
  8003ed:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f7:	48 89 d6             	mov    %rdx,%rsi
  8003fa:	89 c7                	mov    %eax,%edi
  8003fc:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800403:	00 00 00 
  800406:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800408:	48 b8 18 04 80 00 00 	movabs $0x800418,%rax
  80040f:	00 00 00 
  800412:	ff d0                	callq  *%rax
}
  800414:	c9                   	leaveq 
  800415:	c3                   	retq   
	...

0000000000800418 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800418:	55                   	push   %rbp
  800419:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80041c:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  800423:	00 00 00 
  800426:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800428:	bf 00 00 00 00       	mov    $0x0,%edi
  80042d:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  800434:	00 00 00 
  800437:	ff d0                	callq  *%rax
}
  800439:	5d                   	pop    %rbp
  80043a:	c3                   	retq   
	...

000000000080043c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80043c:	55                   	push   %rbp
  80043d:	48 89 e5             	mov    %rsp,%rbp
  800440:	53                   	push   %rbx
  800441:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800448:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80044f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800455:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80045c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800463:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80046a:	84 c0                	test   %al,%al
  80046c:	74 23                	je     800491 <_panic+0x55>
  80046e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800475:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800479:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80047d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800481:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800485:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800489:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80048d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800491:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800498:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80049f:	00 00 00 
  8004a2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004a9:	00 00 00 
  8004ac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004b0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004b7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004be:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004cc:	00 00 00 
  8004cf:	48 8b 18             	mov    (%rax),%rbx
  8004d2:	48 b8 f0 1a 80 00 00 	movabs $0x801af0,%rax
  8004d9:	00 00 00 
  8004dc:	ff d0                	callq  *%rax
  8004de:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004e4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004eb:	41 89 c8             	mov    %ecx,%r8d
  8004ee:	48 89 d1             	mov    %rdx,%rcx
  8004f1:	48 89 da             	mov    %rbx,%rdx
  8004f4:	89 c6                	mov    %eax,%esi
  8004f6:	48 bf 78 3f 80 00 00 	movabs $0x803f78,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b9 77 06 80 00 00 	movabs $0x800677,%r9
  80050c:	00 00 00 
  80050f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800512:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800519:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800520:	48 89 d6             	mov    %rdx,%rsi
  800523:	48 89 c7             	mov    %rax,%rdi
  800526:	48 b8 cb 05 80 00 00 	movabs $0x8005cb,%rax
  80052d:	00 00 00 
  800530:	ff d0                	callq  *%rax
	cprintf("\n");
  800532:	48 bf 9b 3f 80 00 00 	movabs $0x803f9b,%rdi
  800539:	00 00 00 
  80053c:	b8 00 00 00 00       	mov    $0x0,%eax
  800541:	48 ba 77 06 80 00 00 	movabs $0x800677,%rdx
  800548:	00 00 00 
  80054b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80054d:	cc                   	int3   
  80054e:	eb fd                	jmp    80054d <_panic+0x111>

0000000000800550 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800550:	55                   	push   %rbp
  800551:	48 89 e5             	mov    %rsp,%rbp
  800554:	48 83 ec 10          	sub    $0x10,%rsp
  800558:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80055b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80055f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800563:	8b 00                	mov    (%rax),%eax
  800565:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800568:	89 d6                	mov    %edx,%esi
  80056a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80056e:	48 63 d0             	movslq %eax,%rdx
  800571:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800576:	8d 50 01             	lea    0x1(%rax),%edx
  800579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057d:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80057f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800583:	8b 00                	mov    (%rax),%eax
  800585:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058a:	75 2c                	jne    8005b8 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  80058c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800590:	8b 00                	mov    (%rax),%eax
  800592:	48 98                	cltq   
  800594:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800598:	48 83 c2 08          	add    $0x8,%rdx
  80059c:	48 89 c6             	mov    %rax,%rsi
  80059f:	48 89 d7             	mov    %rdx,%rdi
  8005a2:	48 b8 24 1a 80 00 00 	movabs $0x801a24,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	callq  *%rax
		b->idx = 0;
  8005ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8005b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005bc:	8b 40 04             	mov    0x4(%rax),%eax
  8005bf:	8d 50 01             	lea    0x1(%rax),%edx
  8005c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005c9:	c9                   	leaveq 
  8005ca:	c3                   	retq   

00000000008005cb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005cb:	55                   	push   %rbp
  8005cc:	48 89 e5             	mov    %rsp,%rbp
  8005cf:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005d6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005dd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8005e4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005eb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005f2:	48 8b 0a             	mov    (%rdx),%rcx
  8005f5:	48 89 08             	mov    %rcx,(%rax)
  8005f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800600:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800604:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800608:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80060f:	00 00 00 
	b.cnt = 0;
  800612:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800619:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80061c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800623:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80062a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800631:	48 89 c6             	mov    %rax,%rsi
  800634:	48 bf 50 05 80 00 00 	movabs $0x800550,%rdi
  80063b:	00 00 00 
  80063e:	48 b8 28 0a 80 00 00 	movabs $0x800a28,%rax
  800645:	00 00 00 
  800648:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80064a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800650:	48 98                	cltq   
  800652:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800659:	48 83 c2 08          	add    $0x8,%rdx
  80065d:	48 89 c6             	mov    %rax,%rsi
  800660:	48 89 d7             	mov    %rdx,%rdi
  800663:	48 b8 24 1a 80 00 00 	movabs $0x801a24,%rax
  80066a:	00 00 00 
  80066d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80066f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800675:	c9                   	leaveq 
  800676:	c3                   	retq   

0000000000800677 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800677:	55                   	push   %rbp
  800678:	48 89 e5             	mov    %rsp,%rbp
  80067b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800682:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800689:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800690:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800697:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80069e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006a5:	84 c0                	test   %al,%al
  8006a7:	74 20                	je     8006c9 <cprintf+0x52>
  8006a9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006ad:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006b1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006b5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006b9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006bd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006c1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006c5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006c9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8006d0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006d7:	00 00 00 
  8006da:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006e1:	00 00 00 
  8006e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006e8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006ef:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006f6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006fd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800704:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80070b:	48 8b 0a             	mov    (%rdx),%rcx
  80070e:	48 89 08             	mov    %rcx,(%rax)
  800711:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800715:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800719:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80071d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800721:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800728:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80072f:	48 89 d6             	mov    %rdx,%rsi
  800732:	48 89 c7             	mov    %rax,%rdi
  800735:	48 b8 cb 05 80 00 00 	movabs $0x8005cb,%rax
  80073c:	00 00 00 
  80073f:	ff d0                	callq  *%rax
  800741:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800747:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80074d:	c9                   	leaveq 
  80074e:	c3                   	retq   
	...

0000000000800750 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800750:	55                   	push   %rbp
  800751:	48 89 e5             	mov    %rsp,%rbp
  800754:	48 83 ec 30          	sub    $0x30,%rsp
  800758:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80075c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800760:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800764:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800767:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80076b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80076f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800772:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800776:	77 52                	ja     8007ca <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800778:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80077b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80077f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800782:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	ba 00 00 00 00       	mov    $0x0,%edx
  80078f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800793:	48 89 c2             	mov    %rax,%rdx
  800796:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800799:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80079c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8007a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a4:	41 89 f9             	mov    %edi,%r9d
  8007a7:	48 89 c7             	mov    %rax,%rdi
  8007aa:	48 b8 50 07 80 00 00 	movabs $0x800750,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
  8007b6:	eb 1c                	jmp    8007d4 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8007bf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8007c3:	48 89 d6             	mov    %rdx,%rsi
  8007c6:	89 c7                	mov    %eax,%edi
  8007c8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ca:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8007ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8007d2:	7f e4                	jg     8007b8 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007d4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e0:	48 f7 f1             	div    %rcx
  8007e3:	48 89 d0             	mov    %rdx,%rax
  8007e6:	48 ba 68 41 80 00 00 	movabs $0x804168,%rdx
  8007ed:	00 00 00 
  8007f0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007f4:	0f be c0             	movsbl %al,%eax
  8007f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007fb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8007ff:	48 89 d6             	mov    %rdx,%rsi
  800802:	89 c7                	mov    %eax,%edi
  800804:	ff d1                	callq  *%rcx
}
  800806:	c9                   	leaveq 
  800807:	c3                   	retq   

0000000000800808 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800808:	55                   	push   %rbp
  800809:	48 89 e5             	mov    %rsp,%rbp
  80080c:	48 83 ec 20          	sub    $0x20,%rsp
  800810:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800814:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800817:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80081b:	7e 52                	jle    80086f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80081d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800821:	8b 00                	mov    (%rax),%eax
  800823:	83 f8 30             	cmp    $0x30,%eax
  800826:	73 24                	jae    80084c <getuint+0x44>
  800828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800834:	8b 00                	mov    (%rax),%eax
  800836:	89 c0                	mov    %eax,%eax
  800838:	48 01 d0             	add    %rdx,%rax
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	8b 12                	mov    (%rdx),%edx
  800841:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	89 0a                	mov    %ecx,(%rdx)
  80084a:	eb 17                	jmp    800863 <getuint+0x5b>
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800854:	48 89 d0             	mov    %rdx,%rax
  800857:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80085b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800863:	48 8b 00             	mov    (%rax),%rax
  800866:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80086a:	e9 a3 00 00 00       	jmpq   800912 <getuint+0x10a>
	else if (lflag)
  80086f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800873:	74 4f                	je     8008c4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800879:	8b 00                	mov    (%rax),%eax
  80087b:	83 f8 30             	cmp    $0x30,%eax
  80087e:	73 24                	jae    8008a4 <getuint+0x9c>
  800880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800884:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088c:	8b 00                	mov    (%rax),%eax
  80088e:	89 c0                	mov    %eax,%eax
  800890:	48 01 d0             	add    %rdx,%rax
  800893:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800897:	8b 12                	mov    (%rdx),%edx
  800899:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a0:	89 0a                	mov    %ecx,(%rdx)
  8008a2:	eb 17                	jmp    8008bb <getuint+0xb3>
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ac:	48 89 d0             	mov    %rdx,%rax
  8008af:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bb:	48 8b 00             	mov    (%rax),%rax
  8008be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c2:	eb 4e                	jmp    800912 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c8:	8b 00                	mov    (%rax),%eax
  8008ca:	83 f8 30             	cmp    $0x30,%eax
  8008cd:	73 24                	jae    8008f3 <getuint+0xeb>
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	8b 00                	mov    (%rax),%eax
  8008dd:	89 c0                	mov    %eax,%eax
  8008df:	48 01 d0             	add    %rdx,%rax
  8008e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e6:	8b 12                	mov    (%rdx),%edx
  8008e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ef:	89 0a                	mov    %ecx,(%rdx)
  8008f1:	eb 17                	jmp    80090a <getuint+0x102>
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008fb:	48 89 d0             	mov    %rdx,%rax
  8008fe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800902:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800906:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090a:	8b 00                	mov    (%rax),%eax
  80090c:	89 c0                	mov    %eax,%eax
  80090e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800912:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800916:	c9                   	leaveq 
  800917:	c3                   	retq   

0000000000800918 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800918:	55                   	push   %rbp
  800919:	48 89 e5             	mov    %rsp,%rbp
  80091c:	48 83 ec 20          	sub    $0x20,%rsp
  800920:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800924:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800927:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80092b:	7e 52                	jle    80097f <getint+0x67>
		x=va_arg(*ap, long long);
  80092d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800931:	8b 00                	mov    (%rax),%eax
  800933:	83 f8 30             	cmp    $0x30,%eax
  800936:	73 24                	jae    80095c <getint+0x44>
  800938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800944:	8b 00                	mov    (%rax),%eax
  800946:	89 c0                	mov    %eax,%eax
  800948:	48 01 d0             	add    %rdx,%rax
  80094b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094f:	8b 12                	mov    (%rdx),%edx
  800951:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800954:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800958:	89 0a                	mov    %ecx,(%rdx)
  80095a:	eb 17                	jmp    800973 <getint+0x5b>
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800964:	48 89 d0             	mov    %rdx,%rax
  800967:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80096b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800973:	48 8b 00             	mov    (%rax),%rax
  800976:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097a:	e9 a3 00 00 00       	jmpq   800a22 <getint+0x10a>
	else if (lflag)
  80097f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800983:	74 4f                	je     8009d4 <getint+0xbc>
		x=va_arg(*ap, long);
  800985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800989:	8b 00                	mov    (%rax),%eax
  80098b:	83 f8 30             	cmp    $0x30,%eax
  80098e:	73 24                	jae    8009b4 <getint+0x9c>
  800990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800994:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099c:	8b 00                	mov    (%rax),%eax
  80099e:	89 c0                	mov    %eax,%eax
  8009a0:	48 01 d0             	add    %rdx,%rax
  8009a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a7:	8b 12                	mov    (%rdx),%edx
  8009a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b0:	89 0a                	mov    %ecx,(%rdx)
  8009b2:	eb 17                	jmp    8009cb <getint+0xb3>
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009bc:	48 89 d0             	mov    %rdx,%rax
  8009bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cb:	48 8b 00             	mov    (%rax),%rax
  8009ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d2:	eb 4e                	jmp    800a22 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d8:	8b 00                	mov    (%rax),%eax
  8009da:	83 f8 30             	cmp    $0x30,%eax
  8009dd:	73 24                	jae    800a03 <getint+0xeb>
  8009df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009eb:	8b 00                	mov    (%rax),%eax
  8009ed:	89 c0                	mov    %eax,%eax
  8009ef:	48 01 d0             	add    %rdx,%rax
  8009f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f6:	8b 12                	mov    (%rdx),%edx
  8009f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ff:	89 0a                	mov    %ecx,(%rdx)
  800a01:	eb 17                	jmp    800a1a <getint+0x102>
  800a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a07:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a0b:	48 89 d0             	mov    %rdx,%rax
  800a0e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a16:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a1a:	8b 00                	mov    (%rax),%eax
  800a1c:	48 98                	cltq   
  800a1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a26:	c9                   	leaveq 
  800a27:	c3                   	retq   

0000000000800a28 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a28:	55                   	push   %rbp
  800a29:	48 89 e5             	mov    %rsp,%rbp
  800a2c:	41 54                	push   %r12
  800a2e:	53                   	push   %rbx
  800a2f:	48 83 ec 60          	sub    $0x60,%rsp
  800a33:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a37:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a3b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a3f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a47:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a4b:	48 8b 0a             	mov    (%rdx),%rcx
  800a4e:	48 89 08             	mov    %rcx,(%rax)
  800a51:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a55:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a59:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a5d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a61:	eb 17                	jmp    800a7a <vprintfmt+0x52>
			if (ch == '\0')
  800a63:	85 db                	test   %ebx,%ebx
  800a65:	0f 84 d7 04 00 00    	je     800f42 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800a6b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a6f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a73:	48 89 c6             	mov    %rax,%rsi
  800a76:	89 df                	mov    %ebx,%edi
  800a78:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a7e:	0f b6 00             	movzbl (%rax),%eax
  800a81:	0f b6 d8             	movzbl %al,%ebx
  800a84:	83 fb 25             	cmp    $0x25,%ebx
  800a87:	0f 95 c0             	setne  %al
  800a8a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a8f:	84 c0                	test   %al,%al
  800a91:	75 d0                	jne    800a63 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a93:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a97:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a9e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800aa5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800aac:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800ab3:	eb 04                	jmp    800ab9 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800ab5:	90                   	nop
  800ab6:	eb 01                	jmp    800ab9 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800ab8:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ab9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800abd:	0f b6 00             	movzbl (%rax),%eax
  800ac0:	0f b6 d8             	movzbl %al,%ebx
  800ac3:	89 d8                	mov    %ebx,%eax
  800ac5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800aca:	83 e8 23             	sub    $0x23,%eax
  800acd:	83 f8 55             	cmp    $0x55,%eax
  800ad0:	0f 87 38 04 00 00    	ja     800f0e <vprintfmt+0x4e6>
  800ad6:	89 c0                	mov    %eax,%eax
  800ad8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800adf:	00 
  800ae0:	48 b8 90 41 80 00 00 	movabs $0x804190,%rax
  800ae7:	00 00 00 
  800aea:	48 01 d0             	add    %rdx,%rax
  800aed:	48 8b 00             	mov    (%rax),%rax
  800af0:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800af2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800af6:	eb c1                	jmp    800ab9 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800af8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800afc:	eb bb                	jmp    800ab9 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800afe:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b05:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b08:	89 d0                	mov    %edx,%eax
  800b0a:	c1 e0 02             	shl    $0x2,%eax
  800b0d:	01 d0                	add    %edx,%eax
  800b0f:	01 c0                	add    %eax,%eax
  800b11:	01 d8                	add    %ebx,%eax
  800b13:	83 e8 30             	sub    $0x30,%eax
  800b16:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b19:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b1d:	0f b6 00             	movzbl (%rax),%eax
  800b20:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b23:	83 fb 2f             	cmp    $0x2f,%ebx
  800b26:	7e 63                	jle    800b8b <vprintfmt+0x163>
  800b28:	83 fb 39             	cmp    $0x39,%ebx
  800b2b:	7f 5e                	jg     800b8b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b2d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b32:	eb d1                	jmp    800b05 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800b34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b37:	83 f8 30             	cmp    $0x30,%eax
  800b3a:	73 17                	jae    800b53 <vprintfmt+0x12b>
  800b3c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b43:	89 c0                	mov    %eax,%eax
  800b45:	48 01 d0             	add    %rdx,%rax
  800b48:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4b:	83 c2 08             	add    $0x8,%edx
  800b4e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b51:	eb 0f                	jmp    800b62 <vprintfmt+0x13a>
  800b53:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b57:	48 89 d0             	mov    %rdx,%rax
  800b5a:	48 83 c2 08          	add    $0x8,%rdx
  800b5e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b62:	8b 00                	mov    (%rax),%eax
  800b64:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b67:	eb 23                	jmp    800b8c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800b69:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6d:	0f 89 42 ff ff ff    	jns    800ab5 <vprintfmt+0x8d>
				width = 0;
  800b73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b7a:	e9 36 ff ff ff       	jmpq   800ab5 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800b7f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b86:	e9 2e ff ff ff       	jmpq   800ab9 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b8b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b90:	0f 89 22 ff ff ff    	jns    800ab8 <vprintfmt+0x90>
				width = precision, precision = -1;
  800b96:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b99:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b9c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ba3:	e9 10 ff ff ff       	jmpq   800ab8 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ba8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800bac:	e9 08 ff ff ff       	jmpq   800ab9 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb4:	83 f8 30             	cmp    $0x30,%eax
  800bb7:	73 17                	jae    800bd0 <vprintfmt+0x1a8>
  800bb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	89 c0                	mov    %eax,%eax
  800bc2:	48 01 d0             	add    %rdx,%rax
  800bc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc8:	83 c2 08             	add    $0x8,%edx
  800bcb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bce:	eb 0f                	jmp    800bdf <vprintfmt+0x1b7>
  800bd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd4:	48 89 d0             	mov    %rdx,%rax
  800bd7:	48 83 c2 08          	add    $0x8,%rdx
  800bdb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be5:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800be9:	48 89 d6             	mov    %rdx,%rsi
  800bec:	89 c7                	mov    %eax,%edi
  800bee:	ff d1                	callq  *%rcx
			break;
  800bf0:	e9 47 03 00 00       	jmpq   800f3c <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800bf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf8:	83 f8 30             	cmp    $0x30,%eax
  800bfb:	73 17                	jae    800c14 <vprintfmt+0x1ec>
  800bfd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c04:	89 c0                	mov    %eax,%eax
  800c06:	48 01 d0             	add    %rdx,%rax
  800c09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0c:	83 c2 08             	add    $0x8,%edx
  800c0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c12:	eb 0f                	jmp    800c23 <vprintfmt+0x1fb>
  800c14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c18:	48 89 d0             	mov    %rdx,%rax
  800c1b:	48 83 c2 08          	add    $0x8,%rdx
  800c1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c23:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	79 02                	jns    800c2b <vprintfmt+0x203>
				err = -err;
  800c29:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c2b:	83 fb 10             	cmp    $0x10,%ebx
  800c2e:	7f 16                	jg     800c46 <vprintfmt+0x21e>
  800c30:	48 b8 e0 40 80 00 00 	movabs $0x8040e0,%rax
  800c37:	00 00 00 
  800c3a:	48 63 d3             	movslq %ebx,%rdx
  800c3d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c41:	4d 85 e4             	test   %r12,%r12
  800c44:	75 2e                	jne    800c74 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800c46:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4e:	89 d9                	mov    %ebx,%ecx
  800c50:	48 ba 79 41 80 00 00 	movabs $0x804179,%rdx
  800c57:	00 00 00 
  800c5a:	48 89 c7             	mov    %rax,%rdi
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	49 b8 4c 0f 80 00 00 	movabs $0x800f4c,%r8
  800c69:	00 00 00 
  800c6c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c6f:	e9 c8 02 00 00       	jmpq   800f3c <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c74:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7c:	4c 89 e1             	mov    %r12,%rcx
  800c7f:	48 ba 82 41 80 00 00 	movabs $0x804182,%rdx
  800c86:	00 00 00 
  800c89:	48 89 c7             	mov    %rax,%rdi
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	49 b8 4c 0f 80 00 00 	movabs $0x800f4c,%r8
  800c98:	00 00 00 
  800c9b:	41 ff d0             	callq  *%r8
			break;
  800c9e:	e9 99 02 00 00       	jmpq   800f3c <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ca3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca6:	83 f8 30             	cmp    $0x30,%eax
  800ca9:	73 17                	jae    800cc2 <vprintfmt+0x29a>
  800cab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800caf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb2:	89 c0                	mov    %eax,%eax
  800cb4:	48 01 d0             	add    %rdx,%rax
  800cb7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cba:	83 c2 08             	add    $0x8,%edx
  800cbd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc0:	eb 0f                	jmp    800cd1 <vprintfmt+0x2a9>
  800cc2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc6:	48 89 d0             	mov    %rdx,%rax
  800cc9:	48 83 c2 08          	add    $0x8,%rdx
  800ccd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd1:	4c 8b 20             	mov    (%rax),%r12
  800cd4:	4d 85 e4             	test   %r12,%r12
  800cd7:	75 0a                	jne    800ce3 <vprintfmt+0x2bb>
				p = "(null)";
  800cd9:	49 bc 85 41 80 00 00 	movabs $0x804185,%r12
  800ce0:	00 00 00 
			if (width > 0 && padc != '-')
  800ce3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce7:	7e 7a                	jle    800d63 <vprintfmt+0x33b>
  800ce9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ced:	74 74                	je     800d63 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cef:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cf2:	48 98                	cltq   
  800cf4:	48 89 c6             	mov    %rax,%rsi
  800cf7:	4c 89 e7             	mov    %r12,%rdi
  800cfa:	48 b8 f6 11 80 00 00 	movabs $0x8011f6,%rax
  800d01:	00 00 00 
  800d04:	ff d0                	callq  *%rax
  800d06:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d09:	eb 17                	jmp    800d22 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800d0b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800d0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d13:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800d17:	48 89 d6             	mov    %rdx,%rsi
  800d1a:	89 c7                	mov    %eax,%edi
  800d1c:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d26:	7f e3                	jg     800d0b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d28:	eb 39                	jmp    800d63 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800d2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d2e:	74 1e                	je     800d4e <vprintfmt+0x326>
  800d30:	83 fb 1f             	cmp    $0x1f,%ebx
  800d33:	7e 05                	jle    800d3a <vprintfmt+0x312>
  800d35:	83 fb 7e             	cmp    $0x7e,%ebx
  800d38:	7e 14                	jle    800d4e <vprintfmt+0x326>
					putch('?', putdat);
  800d3a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d3e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d42:	48 89 c6             	mov    %rax,%rsi
  800d45:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d4a:	ff d2                	callq  *%rdx
  800d4c:	eb 0f                	jmp    800d5d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800d4e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d52:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d56:	48 89 c6             	mov    %rax,%rsi
  800d59:	89 df                	mov    %ebx,%edi
  800d5b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d5d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d61:	eb 01                	jmp    800d64 <vprintfmt+0x33c>
  800d63:	90                   	nop
  800d64:	41 0f b6 04 24       	movzbl (%r12),%eax
  800d69:	0f be d8             	movsbl %al,%ebx
  800d6c:	85 db                	test   %ebx,%ebx
  800d6e:	0f 95 c0             	setne  %al
  800d71:	49 83 c4 01          	add    $0x1,%r12
  800d75:	84 c0                	test   %al,%al
  800d77:	74 28                	je     800da1 <vprintfmt+0x379>
  800d79:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d7d:	78 ab                	js     800d2a <vprintfmt+0x302>
  800d7f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d83:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d87:	79 a1                	jns    800d2a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	eb 16                	jmp    800da1 <vprintfmt+0x379>
				putch(' ', putdat);
  800d8b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d8f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d93:	48 89 c6             	mov    %rax,%rsi
  800d96:	bf 20 00 00 00       	mov    $0x20,%edi
  800d9b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d9d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800da1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800da5:	7f e4                	jg     800d8b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800da7:	e9 90 01 00 00       	jmpq   800f3c <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800dac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db0:	be 03 00 00 00       	mov    $0x3,%esi
  800db5:	48 89 c7             	mov    %rax,%rdi
  800db8:	48 b8 18 09 80 00 00 	movabs $0x800918,%rax
  800dbf:	00 00 00 
  800dc2:	ff d0                	callq  *%rax
  800dc4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcc:	48 85 c0             	test   %rax,%rax
  800dcf:	79 1d                	jns    800dee <vprintfmt+0x3c6>
				putch('-', putdat);
  800dd1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dd5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dd9:	48 89 c6             	mov    %rax,%rsi
  800ddc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800de1:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de7:	48 f7 d8             	neg    %rax
  800dea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dee:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800df5:	e9 d5 00 00 00       	jmpq   800ecf <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dfa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dfe:	be 03 00 00 00       	mov    $0x3,%esi
  800e03:	48 89 c7             	mov    %rax,%rdi
  800e06:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800e0d:	00 00 00 
  800e10:	ff d0                	callq  *%rax
  800e12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e16:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e1d:	e9 ad 00 00 00       	jmpq   800ecf <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800e22:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e26:	be 03 00 00 00       	mov    $0x3,%esi
  800e2b:	48 89 c7             	mov    %rax,%rdi
  800e2e:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800e35:	00 00 00 
  800e38:	ff d0                	callq  *%rax
  800e3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800e3e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e45:	e9 85 00 00 00       	jmpq   800ecf <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800e4a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e4e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e52:	48 89 c6             	mov    %rax,%rsi
  800e55:	bf 30 00 00 00       	mov    $0x30,%edi
  800e5a:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800e5c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e60:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e64:	48 89 c6             	mov    %rax,%rsi
  800e67:	bf 78 00 00 00       	mov    $0x78,%edi
  800e6c:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e71:	83 f8 30             	cmp    $0x30,%eax
  800e74:	73 17                	jae    800e8d <vprintfmt+0x465>
  800e76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e7d:	89 c0                	mov    %eax,%eax
  800e7f:	48 01 d0             	add    %rdx,%rax
  800e82:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e85:	83 c2 08             	add    $0x8,%edx
  800e88:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e8b:	eb 0f                	jmp    800e9c <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800e8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e91:	48 89 d0             	mov    %rdx,%rax
  800e94:	48 83 c2 08          	add    $0x8,%rdx
  800e98:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e9c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ea3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800eaa:	eb 23                	jmp    800ecf <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800eac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eb0:	be 03 00 00 00       	mov    $0x3,%esi
  800eb5:	48 89 c7             	mov    %rax,%rdi
  800eb8:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800ebf:	00 00 00 
  800ec2:	ff d0                	callq  *%rax
  800ec4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ec8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ecf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ed4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ed7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ede:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ee2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee6:	45 89 c1             	mov    %r8d,%r9d
  800ee9:	41 89 f8             	mov    %edi,%r8d
  800eec:	48 89 c7             	mov    %rax,%rdi
  800eef:	48 b8 50 07 80 00 00 	movabs $0x800750,%rax
  800ef6:	00 00 00 
  800ef9:	ff d0                	callq  *%rax
			break;
  800efb:	eb 3f                	jmp    800f3c <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800efd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f01:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f05:	48 89 c6             	mov    %rax,%rsi
  800f08:	89 df                	mov    %ebx,%edi
  800f0a:	ff d2                	callq  *%rdx
			break;
  800f0c:	eb 2e                	jmp    800f3c <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f0e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f12:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f16:	48 89 c6             	mov    %rax,%rsi
  800f19:	bf 25 00 00 00       	mov    $0x25,%edi
  800f1e:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f20:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f25:	eb 05                	jmp    800f2c <vprintfmt+0x504>
  800f27:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f2c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f30:	48 83 e8 01          	sub    $0x1,%rax
  800f34:	0f b6 00             	movzbl (%rax),%eax
  800f37:	3c 25                	cmp    $0x25,%al
  800f39:	75 ec                	jne    800f27 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800f3b:	90                   	nop
		}
	}
  800f3c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f3d:	e9 38 fb ff ff       	jmpq   800a7a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800f42:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800f43:	48 83 c4 60          	add    $0x60,%rsp
  800f47:	5b                   	pop    %rbx
  800f48:	41 5c                	pop    %r12
  800f4a:	5d                   	pop    %rbp
  800f4b:	c3                   	retq   

0000000000800f4c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f4c:	55                   	push   %rbp
  800f4d:	48 89 e5             	mov    %rsp,%rbp
  800f50:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f57:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f5e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f65:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f6c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f73:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f7a:	84 c0                	test   %al,%al
  800f7c:	74 20                	je     800f9e <printfmt+0x52>
  800f7e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f82:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f86:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f8a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f8e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f92:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f96:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f9a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f9e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fa5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fac:	00 00 00 
  800faf:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fb6:	00 00 00 
  800fb9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fbd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fc4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fcb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fd2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fd9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fe0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fe7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fee:	48 89 c7             	mov    %rax,%rdi
  800ff1:	48 b8 28 0a 80 00 00 	movabs $0x800a28,%rax
  800ff8:	00 00 00 
  800ffb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ffd:	c9                   	leaveq 
  800ffe:	c3                   	retq   

0000000000800fff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fff:	55                   	push   %rbp
  801000:	48 89 e5             	mov    %rsp,%rbp
  801003:	48 83 ec 10          	sub    $0x10,%rsp
  801007:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80100a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80100e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801012:	8b 40 10             	mov    0x10(%rax),%eax
  801015:	8d 50 01             	lea    0x1(%rax),%edx
  801018:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80101f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801023:	48 8b 10             	mov    (%rax),%rdx
  801026:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80102e:	48 39 c2             	cmp    %rax,%rdx
  801031:	73 17                	jae    80104a <sprintputch+0x4b>
		*b->buf++ = ch;
  801033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801037:	48 8b 00             	mov    (%rax),%rax
  80103a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80103d:	88 10                	mov    %dl,(%rax)
  80103f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801047:	48 89 10             	mov    %rdx,(%rax)
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 83 ec 50          	sub    $0x50,%rsp
  801054:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801058:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80105b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80105f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801063:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801067:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80106b:	48 8b 0a             	mov    (%rdx),%rcx
  80106e:	48 89 08             	mov    %rcx,(%rax)
  801071:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801075:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801079:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80107d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801081:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801085:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801089:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80108c:	48 98                	cltq   
  80108e:	48 83 e8 01          	sub    $0x1,%rax
  801092:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801096:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80109a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010a1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010a6:	74 06                	je     8010ae <vsnprintf+0x62>
  8010a8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010ac:	7f 07                	jg     8010b5 <vsnprintf+0x69>
		return -E_INVAL;
  8010ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b3:	eb 2f                	jmp    8010e4 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010b5:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010b9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010bd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010c1:	48 89 c6             	mov    %rax,%rsi
  8010c4:	48 bf ff 0f 80 00 00 	movabs $0x800fff,%rdi
  8010cb:	00 00 00 
  8010ce:	48 b8 28 0a 80 00 00 	movabs $0x800a28,%rax
  8010d5:	00 00 00 
  8010d8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010de:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010e1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010e4:	c9                   	leaveq 
  8010e5:	c3                   	retq   

00000000008010e6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010e6:	55                   	push   %rbp
  8010e7:	48 89 e5             	mov    %rsp,%rbp
  8010ea:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010f1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010f8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010fe:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801105:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80110c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801113:	84 c0                	test   %al,%al
  801115:	74 20                	je     801137 <snprintf+0x51>
  801117:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80111b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80111f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801123:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801127:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80112b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80112f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801133:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801137:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80113e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801145:	00 00 00 
  801148:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80114f:	00 00 00 
  801152:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801156:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80115d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801164:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80116b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801172:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801179:	48 8b 0a             	mov    (%rdx),%rcx
  80117c:	48 89 08             	mov    %rcx,(%rax)
  80117f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801183:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801187:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80118b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80118f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801196:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80119d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011a3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011aa:	48 89 c7             	mov    %rax,%rdi
  8011ad:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8011b4:	00 00 00 
  8011b7:	ff d0                	callq  *%rax
  8011b9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011bf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011c5:	c9                   	leaveq 
  8011c6:	c3                   	retq   
	...

00000000008011c8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011c8:	55                   	push   %rbp
  8011c9:	48 89 e5             	mov    %rsp,%rbp
  8011cc:	48 83 ec 18          	sub    $0x18,%rsp
  8011d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011db:	eb 09                	jmp    8011e6 <strlen+0x1e>
		n++;
  8011dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011e1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ea:	0f b6 00             	movzbl (%rax),%eax
  8011ed:	84 c0                	test   %al,%al
  8011ef:	75 ec                	jne    8011dd <strlen+0x15>
		n++;
	return n;
  8011f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011f4:	c9                   	leaveq 
  8011f5:	c3                   	retq   

00000000008011f6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011f6:	55                   	push   %rbp
  8011f7:	48 89 e5             	mov    %rsp,%rbp
  8011fa:	48 83 ec 20          	sub    $0x20,%rsp
  8011fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801202:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801206:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80120d:	eb 0e                	jmp    80121d <strnlen+0x27>
		n++;
  80120f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801213:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801218:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80121d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801222:	74 0b                	je     80122f <strnlen+0x39>
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	0f b6 00             	movzbl (%rax),%eax
  80122b:	84 c0                	test   %al,%al
  80122d:	75 e0                	jne    80120f <strnlen+0x19>
		n++;
	return n;
  80122f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801232:	c9                   	leaveq 
  801233:	c3                   	retq   

0000000000801234 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801234:	55                   	push   %rbp
  801235:	48 89 e5             	mov    %rsp,%rbp
  801238:	48 83 ec 20          	sub    $0x20,%rsp
  80123c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801240:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801248:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80124c:	90                   	nop
  80124d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801251:	0f b6 10             	movzbl (%rax),%edx
  801254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801258:	88 10                	mov    %dl,(%rax)
  80125a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125e:	0f b6 00             	movzbl (%rax),%eax
  801261:	84 c0                	test   %al,%al
  801263:	0f 95 c0             	setne  %al
  801266:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80126b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801270:	84 c0                	test   %al,%al
  801272:	75 d9                	jne    80124d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801278:	c9                   	leaveq 
  801279:	c3                   	retq   

000000000080127a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80127a:	55                   	push   %rbp
  80127b:	48 89 e5             	mov    %rsp,%rbp
  80127e:	48 83 ec 20          	sub    $0x20,%rsp
  801282:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801286:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80128a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128e:	48 89 c7             	mov    %rax,%rdi
  801291:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801298:	00 00 00 
  80129b:	ff d0                	callq  *%rax
  80129d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012a3:	48 98                	cltq   
  8012a5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8012a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012ad:	48 89 d6             	mov    %rdx,%rsi
  8012b0:	48 89 c7             	mov    %rax,%rdi
  8012b3:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  8012ba:	00 00 00 
  8012bd:	ff d0                	callq  *%rax
	return dst;
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012c3:	c9                   	leaveq 
  8012c4:	c3                   	retq   

00000000008012c5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012c5:	55                   	push   %rbp
  8012c6:	48 89 e5             	mov    %rsp,%rbp
  8012c9:	48 83 ec 28          	sub    $0x28,%rsp
  8012cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012e1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012e8:	00 
  8012e9:	eb 27                	jmp    801312 <strncpy+0x4d>
		*dst++ = *src;
  8012eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ef:	0f b6 10             	movzbl (%rax),%edx
  8012f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f6:	88 10                	mov    %dl,(%rax)
  8012f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801301:	0f b6 00             	movzbl (%rax),%eax
  801304:	84 c0                	test   %al,%al
  801306:	74 05                	je     80130d <strncpy+0x48>
			src++;
  801308:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80130d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801316:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80131a:	72 cf                	jb     8012eb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801320:	c9                   	leaveq 
  801321:	c3                   	retq   

0000000000801322 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801322:	55                   	push   %rbp
  801323:	48 89 e5             	mov    %rsp,%rbp
  801326:	48 83 ec 28          	sub    $0x28,%rsp
  80132a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801332:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80133e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801343:	74 37                	je     80137c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801345:	eb 17                	jmp    80135e <strlcpy+0x3c>
			*dst++ = *src++;
  801347:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134b:	0f b6 10             	movzbl (%rax),%edx
  80134e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801352:	88 10                	mov    %dl,(%rax)
  801354:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801359:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80135e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801363:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801368:	74 0b                	je     801375 <strlcpy+0x53>
  80136a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136e:	0f b6 00             	movzbl (%rax),%eax
  801371:	84 c0                	test   %al,%al
  801373:	75 d2                	jne    801347 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801379:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80137c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801384:	48 89 d1             	mov    %rdx,%rcx
  801387:	48 29 c1             	sub    %rax,%rcx
  80138a:	48 89 c8             	mov    %rcx,%rax
}
  80138d:	c9                   	leaveq 
  80138e:	c3                   	retq   

000000000080138f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80138f:	55                   	push   %rbp
  801390:	48 89 e5             	mov    %rsp,%rbp
  801393:	48 83 ec 10          	sub    $0x10,%rsp
  801397:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80139f:	eb 0a                	jmp    8013ab <strcmp+0x1c>
		p++, q++;
  8013a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	84 c0                	test   %al,%al
  8013b4:	74 12                	je     8013c8 <strcmp+0x39>
  8013b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ba:	0f b6 10             	movzbl (%rax),%edx
  8013bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c1:	0f b6 00             	movzbl (%rax),%eax
  8013c4:	38 c2                	cmp    %al,%dl
  8013c6:	74 d9                	je     8013a1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cc:	0f b6 00             	movzbl (%rax),%eax
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d6:	0f b6 00             	movzbl (%rax),%eax
  8013d9:	0f b6 c0             	movzbl %al,%eax
  8013dc:	89 d1                	mov    %edx,%ecx
  8013de:	29 c1                	sub    %eax,%ecx
  8013e0:	89 c8                	mov    %ecx,%eax
}
  8013e2:	c9                   	leaveq 
  8013e3:	c3                   	retq   

00000000008013e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013e4:	55                   	push   %rbp
  8013e5:	48 89 e5             	mov    %rsp,%rbp
  8013e8:	48 83 ec 18          	sub    $0x18,%rsp
  8013ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013f8:	eb 0f                	jmp    801409 <strncmp+0x25>
		n--, p++, q++;
  8013fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801404:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801409:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80140e:	74 1d                	je     80142d <strncmp+0x49>
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801414:	0f b6 00             	movzbl (%rax),%eax
  801417:	84 c0                	test   %al,%al
  801419:	74 12                	je     80142d <strncmp+0x49>
  80141b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141f:	0f b6 10             	movzbl (%rax),%edx
  801422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	38 c2                	cmp    %al,%dl
  80142b:	74 cd                	je     8013fa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80142d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801432:	75 07                	jne    80143b <strncmp+0x57>
		return 0;
  801434:	b8 00 00 00 00       	mov    $0x0,%eax
  801439:	eb 1a                	jmp    801455 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80143b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143f:	0f b6 00             	movzbl (%rax),%eax
  801442:	0f b6 d0             	movzbl %al,%edx
  801445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801449:	0f b6 00             	movzbl (%rax),%eax
  80144c:	0f b6 c0             	movzbl %al,%eax
  80144f:	89 d1                	mov    %edx,%ecx
  801451:	29 c1                	sub    %eax,%ecx
  801453:	89 c8                	mov    %ecx,%eax
}
  801455:	c9                   	leaveq 
  801456:	c3                   	retq   

0000000000801457 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801457:	55                   	push   %rbp
  801458:	48 89 e5             	mov    %rsp,%rbp
  80145b:	48 83 ec 10          	sub    $0x10,%rsp
  80145f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801463:	89 f0                	mov    %esi,%eax
  801465:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801468:	eb 17                	jmp    801481 <strchr+0x2a>
		if (*s == c)
  80146a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146e:	0f b6 00             	movzbl (%rax),%eax
  801471:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801474:	75 06                	jne    80147c <strchr+0x25>
			return (char *) s;
  801476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147a:	eb 15                	jmp    801491 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	84 c0                	test   %al,%al
  80148a:	75 de                	jne    80146a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801491:	c9                   	leaveq 
  801492:	c3                   	retq   

0000000000801493 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801493:	55                   	push   %rbp
  801494:	48 89 e5             	mov    %rsp,%rbp
  801497:	48 83 ec 10          	sub    $0x10,%rsp
  80149b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149f:	89 f0                	mov    %esi,%eax
  8014a1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014a4:	eb 11                	jmp    8014b7 <strfind+0x24>
		if (*s == c)
  8014a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014aa:	0f b6 00             	movzbl (%rax),%eax
  8014ad:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014b0:	74 12                	je     8014c4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bb:	0f b6 00             	movzbl (%rax),%eax
  8014be:	84 c0                	test   %al,%al
  8014c0:	75 e4                	jne    8014a6 <strfind+0x13>
  8014c2:	eb 01                	jmp    8014c5 <strfind+0x32>
		if (*s == c)
			break;
  8014c4:	90                   	nop
	return (char *) s;
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014c9:	c9                   	leaveq 
  8014ca:	c3                   	retq   

00000000008014cb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014cb:	55                   	push   %rbp
  8014cc:	48 89 e5             	mov    %rsp,%rbp
  8014cf:	48 83 ec 18          	sub    $0x18,%rsp
  8014d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014e3:	75 06                	jne    8014eb <memset+0x20>
		return v;
  8014e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e9:	eb 69                	jmp    801554 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ef:	83 e0 03             	and    $0x3,%eax
  8014f2:	48 85 c0             	test   %rax,%rax
  8014f5:	75 48                	jne    80153f <memset+0x74>
  8014f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fb:	83 e0 03             	and    $0x3,%eax
  8014fe:	48 85 c0             	test   %rax,%rax
  801501:	75 3c                	jne    80153f <memset+0x74>
		c &= 0xFF;
  801503:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80150a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150d:	89 c2                	mov    %eax,%edx
  80150f:	c1 e2 18             	shl    $0x18,%edx
  801512:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801515:	c1 e0 10             	shl    $0x10,%eax
  801518:	09 c2                	or     %eax,%edx
  80151a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80151d:	c1 e0 08             	shl    $0x8,%eax
  801520:	09 d0                	or     %edx,%eax
  801522:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801529:	48 89 c1             	mov    %rax,%rcx
  80152c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801530:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801534:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801537:	48 89 d7             	mov    %rdx,%rdi
  80153a:	fc                   	cld    
  80153b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80153d:	eb 11                	jmp    801550 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80153f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801543:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801546:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80154a:	48 89 d7             	mov    %rdx,%rdi
  80154d:	fc                   	cld    
  80154e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801554:	c9                   	leaveq 
  801555:	c3                   	retq   

0000000000801556 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801556:	55                   	push   %rbp
  801557:	48 89 e5             	mov    %rsp,%rbp
  80155a:	48 83 ec 28          	sub    $0x28,%rsp
  80155e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801562:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801566:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80156a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801576:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80157a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801582:	0f 83 88 00 00 00    	jae    801610 <memmove+0xba>
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801590:	48 01 d0             	add    %rdx,%rax
  801593:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801597:	76 77                	jbe    801610 <memmove+0xba>
		s += n;
  801599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ad:	83 e0 03             	and    $0x3,%eax
  8015b0:	48 85 c0             	test   %rax,%rax
  8015b3:	75 3b                	jne    8015f0 <memmove+0x9a>
  8015b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b9:	83 e0 03             	and    $0x3,%eax
  8015bc:	48 85 c0             	test   %rax,%rax
  8015bf:	75 2f                	jne    8015f0 <memmove+0x9a>
  8015c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c5:	83 e0 03             	and    $0x3,%eax
  8015c8:	48 85 c0             	test   %rax,%rax
  8015cb:	75 23                	jne    8015f0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d1:	48 83 e8 04          	sub    $0x4,%rax
  8015d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d9:	48 83 ea 04          	sub    $0x4,%rdx
  8015dd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015e1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015e5:	48 89 c7             	mov    %rax,%rdi
  8015e8:	48 89 d6             	mov    %rdx,%rsi
  8015eb:	fd                   	std    
  8015ec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ee:	eb 1d                	jmp    80160d <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801604:	48 89 d7             	mov    %rdx,%rdi
  801607:	48 89 c1             	mov    %rax,%rcx
  80160a:	fd                   	std    
  80160b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80160d:	fc                   	cld    
  80160e:	eb 57                	jmp    801667 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801614:	83 e0 03             	and    $0x3,%eax
  801617:	48 85 c0             	test   %rax,%rax
  80161a:	75 36                	jne    801652 <memmove+0xfc>
  80161c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801620:	83 e0 03             	and    $0x3,%eax
  801623:	48 85 c0             	test   %rax,%rax
  801626:	75 2a                	jne    801652 <memmove+0xfc>
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	83 e0 03             	and    $0x3,%eax
  80162f:	48 85 c0             	test   %rax,%rax
  801632:	75 1e                	jne    801652 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801638:	48 89 c1             	mov    %rax,%rcx
  80163b:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80163f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801643:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801647:	48 89 c7             	mov    %rax,%rdi
  80164a:	48 89 d6             	mov    %rdx,%rsi
  80164d:	fc                   	cld    
  80164e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801650:	eb 15                	jmp    801667 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801656:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80165a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80165e:	48 89 c7             	mov    %rax,%rdi
  801661:	48 89 d6             	mov    %rdx,%rsi
  801664:	fc                   	cld    
  801665:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80166b:	c9                   	leaveq 
  80166c:	c3                   	retq   

000000000080166d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80166d:	55                   	push   %rbp
  80166e:	48 89 e5             	mov    %rsp,%rbp
  801671:	48 83 ec 18          	sub    $0x18,%rsp
  801675:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801679:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80167d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801681:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801685:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168d:	48 89 ce             	mov    %rcx,%rsi
  801690:	48 89 c7             	mov    %rax,%rdi
  801693:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  80169a:	00 00 00 
  80169d:	ff d0                	callq  *%rax
}
  80169f:	c9                   	leaveq 
  8016a0:	c3                   	retq   

00000000008016a1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016a1:	55                   	push   %rbp
  8016a2:	48 89 e5             	mov    %rsp,%rbp
  8016a5:	48 83 ec 28          	sub    $0x28,%rsp
  8016a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016c5:	eb 38                	jmp    8016ff <memcmp+0x5e>
		if (*s1 != *s2)
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	0f b6 10             	movzbl (%rax),%edx
  8016ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d2:	0f b6 00             	movzbl (%rax),%eax
  8016d5:	38 c2                	cmp    %al,%dl
  8016d7:	74 1c                	je     8016f5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8016d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	0f b6 d0             	movzbl %al,%edx
  8016e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e7:	0f b6 00             	movzbl (%rax),%eax
  8016ea:	0f b6 c0             	movzbl %al,%eax
  8016ed:	89 d1                	mov    %edx,%ecx
  8016ef:	29 c1                	sub    %eax,%ecx
  8016f1:	89 c8                	mov    %ecx,%eax
  8016f3:	eb 20                	jmp    801715 <memcmp+0x74>
		s1++, s2++;
  8016f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016fa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801704:	0f 95 c0             	setne  %al
  801707:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80170c:	84 c0                	test   %al,%al
  80170e:	75 b7                	jne    8016c7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801715:	c9                   	leaveq 
  801716:	c3                   	retq   

0000000000801717 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801717:	55                   	push   %rbp
  801718:	48 89 e5             	mov    %rsp,%rbp
  80171b:	48 83 ec 28          	sub    $0x28,%rsp
  80171f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801723:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801726:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80172a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801732:	48 01 d0             	add    %rdx,%rax
  801735:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801739:	eb 13                	jmp    80174e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80173b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173f:	0f b6 10             	movzbl (%rax),%edx
  801742:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801745:	38 c2                	cmp    %al,%dl
  801747:	74 11                	je     80175a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801749:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80174e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801752:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801756:	72 e3                	jb     80173b <memfind+0x24>
  801758:	eb 01                	jmp    80175b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80175a:	90                   	nop
	return (void *) s;
  80175b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80175f:	c9                   	leaveq 
  801760:	c3                   	retq   

0000000000801761 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801761:	55                   	push   %rbp
  801762:	48 89 e5             	mov    %rsp,%rbp
  801765:	48 83 ec 38          	sub    $0x38,%rsp
  801769:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80176d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801771:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801774:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80177b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801782:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801783:	eb 05                	jmp    80178a <strtol+0x29>
		s++;
  801785:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178e:	0f b6 00             	movzbl (%rax),%eax
  801791:	3c 20                	cmp    $0x20,%al
  801793:	74 f0                	je     801785 <strtol+0x24>
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	3c 09                	cmp    $0x9,%al
  80179e:	74 e5                	je     801785 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a4:	0f b6 00             	movzbl (%rax),%eax
  8017a7:	3c 2b                	cmp    $0x2b,%al
  8017a9:	75 07                	jne    8017b2 <strtol+0x51>
		s++;
  8017ab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b0:	eb 17                	jmp    8017c9 <strtol+0x68>
	else if (*s == '-')
  8017b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b6:	0f b6 00             	movzbl (%rax),%eax
  8017b9:	3c 2d                	cmp    $0x2d,%al
  8017bb:	75 0c                	jne    8017c9 <strtol+0x68>
		s++, neg = 1;
  8017bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017cd:	74 06                	je     8017d5 <strtol+0x74>
  8017cf:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017d3:	75 28                	jne    8017fd <strtol+0x9c>
  8017d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d9:	0f b6 00             	movzbl (%rax),%eax
  8017dc:	3c 30                	cmp    $0x30,%al
  8017de:	75 1d                	jne    8017fd <strtol+0x9c>
  8017e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e4:	48 83 c0 01          	add    $0x1,%rax
  8017e8:	0f b6 00             	movzbl (%rax),%eax
  8017eb:	3c 78                	cmp    $0x78,%al
  8017ed:	75 0e                	jne    8017fd <strtol+0x9c>
		s += 2, base = 16;
  8017ef:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017f4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017fb:	eb 2c                	jmp    801829 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801801:	75 19                	jne    80181c <strtol+0xbb>
  801803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801807:	0f b6 00             	movzbl (%rax),%eax
  80180a:	3c 30                	cmp    $0x30,%al
  80180c:	75 0e                	jne    80181c <strtol+0xbb>
		s++, base = 8;
  80180e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801813:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80181a:	eb 0d                	jmp    801829 <strtol+0xc8>
	else if (base == 0)
  80181c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801820:	75 07                	jne    801829 <strtol+0xc8>
		base = 10;
  801822:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182d:	0f b6 00             	movzbl (%rax),%eax
  801830:	3c 2f                	cmp    $0x2f,%al
  801832:	7e 1d                	jle    801851 <strtol+0xf0>
  801834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801838:	0f b6 00             	movzbl (%rax),%eax
  80183b:	3c 39                	cmp    $0x39,%al
  80183d:	7f 12                	jg     801851 <strtol+0xf0>
			dig = *s - '0';
  80183f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801843:	0f b6 00             	movzbl (%rax),%eax
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 30             	sub    $0x30,%eax
  80184c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80184f:	eb 4e                	jmp    80189f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801851:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801855:	0f b6 00             	movzbl (%rax),%eax
  801858:	3c 60                	cmp    $0x60,%al
  80185a:	7e 1d                	jle    801879 <strtol+0x118>
  80185c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801860:	0f b6 00             	movzbl (%rax),%eax
  801863:	3c 7a                	cmp    $0x7a,%al
  801865:	7f 12                	jg     801879 <strtol+0x118>
			dig = *s - 'a' + 10;
  801867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186b:	0f b6 00             	movzbl (%rax),%eax
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	83 e8 57             	sub    $0x57,%eax
  801874:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801877:	eb 26                	jmp    80189f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	0f b6 00             	movzbl (%rax),%eax
  801880:	3c 40                	cmp    $0x40,%al
  801882:	7e 47                	jle    8018cb <strtol+0x16a>
  801884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801888:	0f b6 00             	movzbl (%rax),%eax
  80188b:	3c 5a                	cmp    $0x5a,%al
  80188d:	7f 3c                	jg     8018cb <strtol+0x16a>
			dig = *s - 'A' + 10;
  80188f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801893:	0f b6 00             	movzbl (%rax),%eax
  801896:	0f be c0             	movsbl %al,%eax
  801899:	83 e8 37             	sub    $0x37,%eax
  80189c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80189f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018a2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018a5:	7d 23                	jge    8018ca <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8018a7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ac:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018af:	48 98                	cltq   
  8018b1:	48 89 c2             	mov    %rax,%rdx
  8018b4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8018b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018bc:	48 98                	cltq   
  8018be:	48 01 d0             	add    %rdx,%rax
  8018c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018c5:	e9 5f ff ff ff       	jmpq   801829 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018ca:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018cb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018d0:	74 0b                	je     8018dd <strtol+0x17c>
		*endptr = (char *) s;
  8018d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018da:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018e1:	74 09                	je     8018ec <strtol+0x18b>
  8018e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e7:	48 f7 d8             	neg    %rax
  8018ea:	eb 04                	jmp    8018f0 <strtol+0x18f>
  8018ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018f0:	c9                   	leaveq 
  8018f1:	c3                   	retq   

00000000008018f2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018f2:	55                   	push   %rbp
  8018f3:	48 89 e5             	mov    %rsp,%rbp
  8018f6:	48 83 ec 30          	sub    $0x30,%rsp
  8018fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801902:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801906:	0f b6 00             	movzbl (%rax),%eax
  801909:	88 45 ff             	mov    %al,-0x1(%rbp)
  80190c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801911:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801915:	75 06                	jne    80191d <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	eb 68                	jmp    801985 <strstr+0x93>

    len = strlen(str);
  80191d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801921:	48 89 c7             	mov    %rax,%rdi
  801924:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  80192b:	00 00 00 
  80192e:	ff d0                	callq  *%rax
  801930:	48 98                	cltq   
  801932:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193a:	0f b6 00             	movzbl (%rax),%eax
  80193d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801940:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801945:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801949:	75 07                	jne    801952 <strstr+0x60>
                return (char *) 0;
  80194b:	b8 00 00 00 00       	mov    $0x0,%eax
  801950:	eb 33                	jmp    801985 <strstr+0x93>
        } while (sc != c);
  801952:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801956:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801959:	75 db                	jne    801936 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80195b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801967:	48 89 ce             	mov    %rcx,%rsi
  80196a:	48 89 c7             	mov    %rax,%rdi
  80196d:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  801974:	00 00 00 
  801977:	ff d0                	callq  *%rax
  801979:	85 c0                	test   %eax,%eax
  80197b:	75 b9                	jne    801936 <strstr+0x44>

    return (char *) (in - 1);
  80197d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801981:	48 83 e8 01          	sub    $0x1,%rax
}
  801985:	c9                   	leaveq 
  801986:	c3                   	retq   
	...

0000000000801988 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801988:	55                   	push   %rbp
  801989:	48 89 e5             	mov    %rsp,%rbp
  80198c:	53                   	push   %rbx
  80198d:	48 83 ec 58          	sub    $0x58,%rsp
  801991:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801994:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801997:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80199b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80199f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019a3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019aa:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8019ad:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019b1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019b5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019b9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019bd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019c1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8019c4:	4c 89 c3             	mov    %r8,%rbx
  8019c7:	cd 30                	int    $0x30
  8019c9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8019cd:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8019d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019d9:	74 3e                	je     801a19 <syscall+0x91>
  8019db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019e0:	7e 37                	jle    801a19 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019e6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019e9:	49 89 d0             	mov    %rdx,%r8
  8019ec:	89 c1                	mov    %eax,%ecx
  8019ee:	48 ba 40 44 80 00 00 	movabs $0x804440,%rdx
  8019f5:	00 00 00 
  8019f8:	be 23 00 00 00       	mov    $0x23,%esi
  8019fd:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801a04:	00 00 00 
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0c:	49 b9 3c 04 80 00 00 	movabs $0x80043c,%r9
  801a13:	00 00 00 
  801a16:	41 ff d1             	callq  *%r9

	return ret;
  801a19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a1d:	48 83 c4 58          	add    $0x58,%rsp
  801a21:	5b                   	pop    %rbx
  801a22:	5d                   	pop    %rbp
  801a23:	c3                   	retq   

0000000000801a24 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a24:	55                   	push   %rbp
  801a25:	48 89 e5             	mov    %rsp,%rbp
  801a28:	48 83 ec 20          	sub    $0x20,%rsp
  801a2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a43:	00 
  801a44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a50:	48 89 d1             	mov    %rdx,%rcx
  801a53:	48 89 c2             	mov    %rax,%rdx
  801a56:	be 00 00 00 00       	mov    $0x0,%esi
  801a5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801a60:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801a67:	00 00 00 
  801a6a:	ff d0                	callq  *%rax
}
  801a6c:	c9                   	leaveq 
  801a6d:	c3                   	retq   

0000000000801a6e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a6e:	55                   	push   %rbp
  801a6f:	48 89 e5             	mov    %rsp,%rbp
  801a72:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a76:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7d:	00 
  801a7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a94:	be 00 00 00 00       	mov    $0x0,%esi
  801a99:	bf 01 00 00 00       	mov    $0x1,%edi
  801a9e:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801aa5:	00 00 00 
  801aa8:	ff d0                	callq  *%rax
}
  801aaa:	c9                   	leaveq 
  801aab:	c3                   	retq   

0000000000801aac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801aac:	55                   	push   %rbp
  801aad:	48 89 e5             	mov    %rsp,%rbp
  801ab0:	48 83 ec 20          	sub    $0x20,%rsp
  801ab4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aba:	48 98                	cltq   
  801abc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac3:	00 
  801ac4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad5:	48 89 c2             	mov    %rax,%rdx
  801ad8:	be 01 00 00 00       	mov    $0x1,%esi
  801add:	bf 03 00 00 00       	mov    $0x3,%edi
  801ae2:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801ae9:	00 00 00 
  801aec:	ff d0                	callq  *%rax
}
  801aee:	c9                   	leaveq 
  801aef:	c3                   	retq   

0000000000801af0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801af0:	55                   	push   %rbp
  801af1:	48 89 e5             	mov    %rsp,%rbp
  801af4:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801af8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aff:	00 
  801b00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b11:	ba 00 00 00 00       	mov    $0x0,%edx
  801b16:	be 00 00 00 00       	mov    $0x0,%esi
  801b1b:	bf 02 00 00 00       	mov    $0x2,%edi
  801b20:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801b27:	00 00 00 
  801b2a:	ff d0                	callq  *%rax
}
  801b2c:	c9                   	leaveq 
  801b2d:	c3                   	retq   

0000000000801b2e <sys_yield>:

void
sys_yield(void)
{
  801b2e:	55                   	push   %rbp
  801b2f:	48 89 e5             	mov    %rsp,%rbp
  801b32:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3d:	00 
  801b3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b54:	be 00 00 00 00       	mov    $0x0,%esi
  801b59:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b5e:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801b65:	00 00 00 
  801b68:	ff d0                	callq  *%rax
}
  801b6a:	c9                   	leaveq 
  801b6b:	c3                   	retq   

0000000000801b6c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b6c:	55                   	push   %rbp
  801b6d:	48 89 e5             	mov    %rsp,%rbp
  801b70:	48 83 ec 20          	sub    $0x20,%rsp
  801b74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b7b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b81:	48 63 c8             	movslq %eax,%rcx
  801b84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8b:	48 98                	cltq   
  801b8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b94:	00 
  801b95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9b:	49 89 c8             	mov    %rcx,%r8
  801b9e:	48 89 d1             	mov    %rdx,%rcx
  801ba1:	48 89 c2             	mov    %rax,%rdx
  801ba4:	be 01 00 00 00       	mov    $0x1,%esi
  801ba9:	bf 04 00 00 00       	mov    $0x4,%edi
  801bae:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801bb5:	00 00 00 
  801bb8:	ff d0                	callq  *%rax
}
  801bba:	c9                   	leaveq 
  801bbb:	c3                   	retq   

0000000000801bbc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	48 83 ec 30          	sub    $0x30,%rsp
  801bc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bcb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bce:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bd2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bd6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bd9:	48 63 c8             	movslq %eax,%rcx
  801bdc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801be0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801be3:	48 63 f0             	movslq %eax,%rsi
  801be6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bed:	48 98                	cltq   
  801bef:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bf3:	49 89 f9             	mov    %rdi,%r9
  801bf6:	49 89 f0             	mov    %rsi,%r8
  801bf9:	48 89 d1             	mov    %rdx,%rcx
  801bfc:	48 89 c2             	mov    %rax,%rdx
  801bff:	be 01 00 00 00       	mov    $0x1,%esi
  801c04:	bf 05 00 00 00       	mov    $0x5,%edi
  801c09:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801c10:	00 00 00 
  801c13:	ff d0                	callq  *%rax
}
  801c15:	c9                   	leaveq 
  801c16:	c3                   	retq   

0000000000801c17 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c17:	55                   	push   %rbp
  801c18:	48 89 e5             	mov    %rsp,%rbp
  801c1b:	48 83 ec 20          	sub    $0x20,%rsp
  801c1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2d:	48 98                	cltq   
  801c2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c36:	00 
  801c37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c43:	48 89 d1             	mov    %rdx,%rcx
  801c46:	48 89 c2             	mov    %rax,%rdx
  801c49:	be 01 00 00 00       	mov    $0x1,%esi
  801c4e:	bf 06 00 00 00       	mov    $0x6,%edi
  801c53:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	callq  *%rax
}
  801c5f:	c9                   	leaveq 
  801c60:	c3                   	retq   

0000000000801c61 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c61:	55                   	push   %rbp
  801c62:	48 89 e5             	mov    %rsp,%rbp
  801c65:	48 83 ec 20          	sub    $0x20,%rsp
  801c69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c6c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c72:	48 63 d0             	movslq %eax,%rdx
  801c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c78:	48 98                	cltq   
  801c7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c81:	00 
  801c82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8e:	48 89 d1             	mov    %rdx,%rcx
  801c91:	48 89 c2             	mov    %rax,%rdx
  801c94:	be 01 00 00 00       	mov    $0x1,%esi
  801c99:	bf 08 00 00 00       	mov    $0x8,%edi
  801c9e:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801ca5:	00 00 00 
  801ca8:	ff d0                	callq  *%rax
}
  801caa:	c9                   	leaveq 
  801cab:	c3                   	retq   

0000000000801cac <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cac:	55                   	push   %rbp
  801cad:	48 89 e5             	mov    %rsp,%rbp
  801cb0:	48 83 ec 20          	sub    $0x20,%rsp
  801cb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc2:	48 98                	cltq   
  801cc4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ccb:	00 
  801ccc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd8:	48 89 d1             	mov    %rdx,%rcx
  801cdb:	48 89 c2             	mov    %rax,%rdx
  801cde:	be 01 00 00 00       	mov    $0x1,%esi
  801ce3:	bf 09 00 00 00       	mov    $0x9,%edi
  801ce8:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801cef:	00 00 00 
  801cf2:	ff d0                	callq  *%rax
}
  801cf4:	c9                   	leaveq 
  801cf5:	c3                   	retq   

0000000000801cf6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cf6:	55                   	push   %rbp
  801cf7:	48 89 e5             	mov    %rsp,%rbp
  801cfa:	48 83 ec 20          	sub    $0x20,%rsp
  801cfe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0c:	48 98                	cltq   
  801d0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d15:	00 
  801d16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d22:	48 89 d1             	mov    %rdx,%rcx
  801d25:	48 89 c2             	mov    %rax,%rdx
  801d28:	be 01 00 00 00       	mov    $0x1,%esi
  801d2d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d32:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801d39:	00 00 00 
  801d3c:	ff d0                	callq  *%rax
}
  801d3e:	c9                   	leaveq 
  801d3f:	c3                   	retq   

0000000000801d40 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d40:	55                   	push   %rbp
  801d41:	48 89 e5             	mov    %rsp,%rbp
  801d44:	48 83 ec 30          	sub    $0x30,%rsp
  801d48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d4f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d53:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d56:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d59:	48 63 f0             	movslq %eax,%rsi
  801d5c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d63:	48 98                	cltq   
  801d65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d70:	00 
  801d71:	49 89 f1             	mov    %rsi,%r9
  801d74:	49 89 c8             	mov    %rcx,%r8
  801d77:	48 89 d1             	mov    %rdx,%rcx
  801d7a:	48 89 c2             	mov    %rax,%rdx
  801d7d:	be 00 00 00 00       	mov    $0x0,%esi
  801d82:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d87:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
}
  801d93:	c9                   	leaveq 
  801d94:	c3                   	retq   

0000000000801d95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
  801d99:	48 83 ec 20          	sub    $0x20,%rsp
  801d9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dac:	00 
  801dad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dbe:	48 89 c2             	mov    %rax,%rdx
  801dc1:	be 01 00 00 00       	mov    $0x1,%esi
  801dc6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801dcb:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801dd2:	00 00 00 
  801dd5:	ff d0                	callq  *%rax
}
  801dd7:	c9                   	leaveq 
  801dd8:	c3                   	retq   

0000000000801dd9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801dd9:	55                   	push   %rbp
  801dda:	48 89 e5             	mov    %rsp,%rbp
  801ddd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801de1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de8:	00 
  801de9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801def:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801dff:	be 00 00 00 00       	mov    $0x0,%esi
  801e04:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e09:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801e10:	00 00 00 
  801e13:	ff d0                	callq  *%rax
}
  801e15:	c9                   	leaveq 
  801e16:	c3                   	retq   

0000000000801e17 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801e17:	55                   	push   %rbp
  801e18:	48 89 e5             	mov    %rsp,%rbp
  801e1b:	48 83 ec 20          	sub    $0x20,%rsp
  801e1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801e27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e36:	00 
  801e37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e43:	48 89 d1             	mov    %rdx,%rcx
  801e46:	48 89 c2             	mov    %rax,%rdx
  801e49:	be 00 00 00 00       	mov    $0x0,%esi
  801e4e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e53:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801e5a:	00 00 00 
  801e5d:	ff d0                	callq  *%rax
}
  801e5f:	c9                   	leaveq 
  801e60:	c3                   	retq   

0000000000801e61 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801e61:	55                   	push   %rbp
  801e62:	48 89 e5             	mov    %rsp,%rbp
  801e65:	48 83 ec 20          	sub    $0x20,%rsp
  801e69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801e71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e80:	00 
  801e81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e8d:	48 89 d1             	mov    %rdx,%rcx
  801e90:	48 89 c2             	mov    %rax,%rdx
  801e93:	be 00 00 00 00       	mov    $0x0,%esi
  801e98:	bf 10 00 00 00       	mov    $0x10,%edi
  801e9d:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  801ea4:	00 00 00 
  801ea7:	ff d0                	callq  *%rax
}
  801ea9:	c9                   	leaveq 
  801eaa:	c3                   	retq   
	...

0000000000801eac <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801eac:	55                   	push   %rbp
  801ead:	48 89 e5             	mov    %rsp,%rbp
  801eb0:	48 83 ec 08          	sub    $0x8,%rsp
  801eb4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801eb8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ebc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ec3:	ff ff ff 
  801ec6:	48 01 d0             	add    %rdx,%rax
  801ec9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ecd:	c9                   	leaveq 
  801ece:	c3                   	retq   

0000000000801ecf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ecf:	55                   	push   %rbp
  801ed0:	48 89 e5             	mov    %rsp,%rbp
  801ed3:	48 83 ec 08          	sub    $0x8,%rsp
  801ed7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801edb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801edf:	48 89 c7             	mov    %rax,%rdi
  801ee2:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	callq  *%rax
  801eee:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ef4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ef8:	c9                   	leaveq 
  801ef9:	c3                   	retq   

0000000000801efa <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801efa:	55                   	push   %rbp
  801efb:	48 89 e5             	mov    %rsp,%rbp
  801efe:	48 83 ec 18          	sub    $0x18,%rsp
  801f02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f0d:	eb 6b                	jmp    801f7a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f12:	48 98                	cltq   
  801f14:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f1a:	48 c1 e0 0c          	shl    $0xc,%rax
  801f1e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f26:	48 89 c2             	mov    %rax,%rdx
  801f29:	48 c1 ea 15          	shr    $0x15,%rdx
  801f2d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f34:	01 00 00 
  801f37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3b:	83 e0 01             	and    $0x1,%eax
  801f3e:	48 85 c0             	test   %rax,%rax
  801f41:	74 21                	je     801f64 <fd_alloc+0x6a>
  801f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f47:	48 89 c2             	mov    %rax,%rdx
  801f4a:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f55:	01 00 00 
  801f58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5c:	83 e0 01             	and    $0x1,%eax
  801f5f:	48 85 c0             	test   %rax,%rax
  801f62:	75 12                	jne    801f76 <fd_alloc+0x7c>
			*fd_store = fd;
  801f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	eb 1a                	jmp    801f90 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f76:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f7a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f7e:	7e 8f                	jle    801f0f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f84:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f8b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f90:	c9                   	leaveq 
  801f91:	c3                   	retq   

0000000000801f92 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f92:	55                   	push   %rbp
  801f93:	48 89 e5             	mov    %rsp,%rbp
  801f96:	48 83 ec 20          	sub    $0x20,%rsp
  801f9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fa5:	78 06                	js     801fad <fd_lookup+0x1b>
  801fa7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fab:	7e 07                	jle    801fb4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fb2:	eb 6c                	jmp    802020 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801fb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fb7:	48 98                	cltq   
  801fb9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fbf:	48 c1 e0 0c          	shl    $0xc,%rax
  801fc3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fcb:	48 89 c2             	mov    %rax,%rdx
  801fce:	48 c1 ea 15          	shr    $0x15,%rdx
  801fd2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fd9:	01 00 00 
  801fdc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe0:	83 e0 01             	and    $0x1,%eax
  801fe3:	48 85 c0             	test   %rax,%rax
  801fe6:	74 21                	je     802009 <fd_lookup+0x77>
  801fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fec:	48 89 c2             	mov    %rax,%rdx
  801fef:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ff3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ffa:	01 00 00 
  801ffd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802001:	83 e0 01             	and    $0x1,%eax
  802004:	48 85 c0             	test   %rax,%rax
  802007:	75 07                	jne    802010 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802009:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80200e:	eb 10                	jmp    802020 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802010:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802014:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802018:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80201b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802020:	c9                   	leaveq 
  802021:	c3                   	retq   

0000000000802022 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802022:	55                   	push   %rbp
  802023:	48 89 e5             	mov    %rsp,%rbp
  802026:	48 83 ec 30          	sub    $0x30,%rsp
  80202a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80202e:	89 f0                	mov    %esi,%eax
  802030:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802033:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802037:	48 89 c7             	mov    %rax,%rdi
  80203a:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
  802046:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80204a:	48 89 d6             	mov    %rdx,%rsi
  80204d:	89 c7                	mov    %eax,%edi
  80204f:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  802056:	00 00 00 
  802059:	ff d0                	callq  *%rax
  80205b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80205e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802062:	78 0a                	js     80206e <fd_close+0x4c>
	    || fd != fd2)
  802064:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802068:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80206c:	74 12                	je     802080 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80206e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802072:	74 05                	je     802079 <fd_close+0x57>
  802074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802077:	eb 05                	jmp    80207e <fd_close+0x5c>
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
  80207e:	eb 69                	jmp    8020e9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802080:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802084:	8b 00                	mov    (%rax),%eax
  802086:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80208a:	48 89 d6             	mov    %rdx,%rsi
  80208d:	89 c7                	mov    %eax,%edi
  80208f:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802096:	00 00 00 
  802099:	ff d0                	callq  *%rax
  80209b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80209e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a2:	78 2a                	js     8020ce <fd_close+0xac>
		if (dev->dev_close)
  8020a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020ac:	48 85 c0             	test   %rax,%rax
  8020af:	74 16                	je     8020c7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8020b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8020b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bd:	48 89 c7             	mov    %rax,%rdi
  8020c0:	ff d2                	callq  *%rdx
  8020c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020c5:	eb 07                	jmp    8020ce <fd_close+0xac>
		else
			r = 0;
  8020c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d2:	48 89 c6             	mov    %rax,%rsi
  8020d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020da:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	callq  *%rax
	return r;
  8020e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020e9:	c9                   	leaveq 
  8020ea:	c3                   	retq   

00000000008020eb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020eb:	55                   	push   %rbp
  8020ec:	48 89 e5             	mov    %rsp,%rbp
  8020ef:	48 83 ec 20          	sub    $0x20,%rsp
  8020f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802101:	eb 41                	jmp    802144 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802103:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80210a:	00 00 00 
  80210d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802110:	48 63 d2             	movslq %edx,%rdx
  802113:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802117:	8b 00                	mov    (%rax),%eax
  802119:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80211c:	75 22                	jne    802140 <dev_lookup+0x55>
			*dev = devtab[i];
  80211e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802125:	00 00 00 
  802128:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80212b:	48 63 d2             	movslq %edx,%rdx
  80212e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802132:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802136:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	eb 60                	jmp    8021a0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802140:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802144:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80214b:	00 00 00 
  80214e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802151:	48 63 d2             	movslq %edx,%rdx
  802154:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802158:	48 85 c0             	test   %rax,%rax
  80215b:	75 a6                	jne    802103 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80215d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802164:	00 00 00 
  802167:	48 8b 00             	mov    (%rax),%rax
  80216a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802170:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802173:	89 c6                	mov    %eax,%esi
  802175:	48 bf 70 44 80 00 00 	movabs $0x804470,%rdi
  80217c:	00 00 00 
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	48 b9 77 06 80 00 00 	movabs $0x800677,%rcx
  80218b:	00 00 00 
  80218e:	ff d1                	callq  *%rcx
	*dev = 0;
  802190:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802194:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80219b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021a0:	c9                   	leaveq 
  8021a1:	c3                   	retq   

00000000008021a2 <close>:

int
close(int fdnum)
{
  8021a2:	55                   	push   %rbp
  8021a3:	48 89 e5             	mov    %rsp,%rbp
  8021a6:	48 83 ec 20          	sub    $0x20,%rsp
  8021aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021b4:	48 89 d6             	mov    %rdx,%rsi
  8021b7:	89 c7                	mov    %eax,%edi
  8021b9:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
  8021c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cc:	79 05                	jns    8021d3 <close+0x31>
		return r;
  8021ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d1:	eb 18                	jmp    8021eb <close+0x49>
	else
		return fd_close(fd, 1);
  8021d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d7:	be 01 00 00 00       	mov    $0x1,%esi
  8021dc:	48 89 c7             	mov    %rax,%rdi
  8021df:	48 b8 22 20 80 00 00 	movabs $0x802022,%rax
  8021e6:	00 00 00 
  8021e9:	ff d0                	callq  *%rax
}
  8021eb:	c9                   	leaveq 
  8021ec:	c3                   	retq   

00000000008021ed <close_all>:

void
close_all(void)
{
  8021ed:	55                   	push   %rbp
  8021ee:	48 89 e5             	mov    %rsp,%rbp
  8021f1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021fc:	eb 15                	jmp    802213 <close_all+0x26>
		close(i);
  8021fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802201:	89 c7                	mov    %eax,%edi
  802203:	48 b8 a2 21 80 00 00 	movabs $0x8021a2,%rax
  80220a:	00 00 00 
  80220d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80220f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802213:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802217:	7e e5                	jle    8021fe <close_all+0x11>
		close(i);
}
  802219:	c9                   	leaveq 
  80221a:	c3                   	retq   

000000000080221b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80221b:	55                   	push   %rbp
  80221c:	48 89 e5             	mov    %rsp,%rbp
  80221f:	48 83 ec 40          	sub    $0x40,%rsp
  802223:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802226:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802229:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80222d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802230:	48 89 d6             	mov    %rdx,%rsi
  802233:	89 c7                	mov    %eax,%edi
  802235:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  80223c:	00 00 00 
  80223f:	ff d0                	callq  *%rax
  802241:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802244:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802248:	79 08                	jns    802252 <dup+0x37>
		return r;
  80224a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80224d:	e9 70 01 00 00       	jmpq   8023c2 <dup+0x1a7>
	close(newfdnum);
  802252:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802255:	89 c7                	mov    %eax,%edi
  802257:	48 b8 a2 21 80 00 00 	movabs $0x8021a2,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802263:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802266:	48 98                	cltq   
  802268:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80226e:	48 c1 e0 0c          	shl    $0xc,%rax
  802272:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802276:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80227a:	48 89 c7             	mov    %rax,%rdi
  80227d:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  802284:	00 00 00 
  802287:	ff d0                	callq  *%rax
  802289:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80228d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802291:	48 89 c7             	mov    %rax,%rdi
  802294:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  80229b:	00 00 00 
  80229e:	ff d0                	callq  *%rax
  8022a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a8:	48 89 c2             	mov    %rax,%rdx
  8022ab:	48 c1 ea 15          	shr    $0x15,%rdx
  8022af:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022b6:	01 00 00 
  8022b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022bd:	83 e0 01             	and    $0x1,%eax
  8022c0:	84 c0                	test   %al,%al
  8022c2:	74 71                	je     802335 <dup+0x11a>
  8022c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c8:	48 89 c2             	mov    %rax,%rdx
  8022cb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d6:	01 00 00 
  8022d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022dd:	83 e0 01             	and    $0x1,%eax
  8022e0:	84 c0                	test   %al,%al
  8022e2:	74 51                	je     802335 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e8:	48 89 c2             	mov    %rax,%rdx
  8022eb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f6:	01 00 00 
  8022f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fd:	89 c1                	mov    %eax,%ecx
  8022ff:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802305:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230d:	41 89 c8             	mov    %ecx,%r8d
  802310:	48 89 d1             	mov    %rdx,%rcx
  802313:	ba 00 00 00 00       	mov    $0x0,%edx
  802318:	48 89 c6             	mov    %rax,%rsi
  80231b:	bf 00 00 00 00       	mov    $0x0,%edi
  802320:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
  802327:	00 00 00 
  80232a:	ff d0                	callq  *%rax
  80232c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802333:	78 56                	js     80238b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802339:	48 89 c2             	mov    %rax,%rdx
  80233c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802340:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802347:	01 00 00 
  80234a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80234e:	89 c1                	mov    %eax,%ecx
  802350:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80235a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80235e:	41 89 c8             	mov    %ecx,%r8d
  802361:	48 89 d1             	mov    %rdx,%rcx
  802364:	ba 00 00 00 00       	mov    $0x0,%edx
  802369:	48 89 c6             	mov    %rax,%rsi
  80236c:	bf 00 00 00 00       	mov    $0x0,%edi
  802371:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
  802378:	00 00 00 
  80237b:	ff d0                	callq  *%rax
  80237d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802380:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802384:	78 08                	js     80238e <dup+0x173>
		goto err;

	return newfdnum;
  802386:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802389:	eb 37                	jmp    8023c2 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80238b:	90                   	nop
  80238c:	eb 01                	jmp    80238f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80238e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80238f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802393:	48 89 c6             	mov    %rax,%rsi
  802396:	bf 00 00 00 00       	mov    $0x0,%edi
  80239b:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  8023a2:	00 00 00 
  8023a5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ab:	48 89 c6             	mov    %rax,%rsi
  8023ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b3:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax
	return r;
  8023bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023c2:	c9                   	leaveq 
  8023c3:	c3                   	retq   

00000000008023c4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023c4:	55                   	push   %rbp
  8023c5:	48 89 e5             	mov    %rsp,%rbp
  8023c8:	48 83 ec 40          	sub    $0x40,%rsp
  8023cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023d3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023d7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023db:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023de:	48 89 d6             	mov    %rdx,%rsi
  8023e1:	89 c7                	mov    %eax,%edi
  8023e3:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  8023ea:	00 00 00 
  8023ed:	ff d0                	callq  *%rax
  8023ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f6:	78 24                	js     80241c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fc:	8b 00                	mov    (%rax),%eax
  8023fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802402:	48 89 d6             	mov    %rdx,%rsi
  802405:	89 c7                	mov    %eax,%edi
  802407:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  80240e:	00 00 00 
  802411:	ff d0                	callq  *%rax
  802413:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802416:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241a:	79 05                	jns    802421 <read+0x5d>
		return r;
  80241c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241f:	eb 7a                	jmp    80249b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802425:	8b 40 08             	mov    0x8(%rax),%eax
  802428:	83 e0 03             	and    $0x3,%eax
  80242b:	83 f8 01             	cmp    $0x1,%eax
  80242e:	75 3a                	jne    80246a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802430:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802437:	00 00 00 
  80243a:	48 8b 00             	mov    (%rax),%rax
  80243d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802443:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802446:	89 c6                	mov    %eax,%esi
  802448:	48 bf 8f 44 80 00 00 	movabs $0x80448f,%rdi
  80244f:	00 00 00 
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
  802457:	48 b9 77 06 80 00 00 	movabs $0x800677,%rcx
  80245e:	00 00 00 
  802461:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802463:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802468:	eb 31                	jmp    80249b <read+0xd7>
	}
	if (!dev->dev_read)
  80246a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802472:	48 85 c0             	test   %rax,%rax
  802475:	75 07                	jne    80247e <read+0xba>
		return -E_NOT_SUPP;
  802477:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80247c:	eb 1d                	jmp    80249b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80247e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802482:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80248e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802492:	48 89 ce             	mov    %rcx,%rsi
  802495:	48 89 c7             	mov    %rax,%rdi
  802498:	41 ff d0             	callq  *%r8
}
  80249b:	c9                   	leaveq 
  80249c:	c3                   	retq   

000000000080249d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80249d:	55                   	push   %rbp
  80249e:	48 89 e5             	mov    %rsp,%rbp
  8024a1:	48 83 ec 30          	sub    $0x30,%rsp
  8024a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024b7:	eb 46                	jmp    8024ff <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bc:	48 98                	cltq   
  8024be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024c2:	48 29 c2             	sub    %rax,%rdx
  8024c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c8:	48 98                	cltq   
  8024ca:	48 89 c1             	mov    %rax,%rcx
  8024cd:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8024d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024d4:	48 89 ce             	mov    %rcx,%rsi
  8024d7:	89 c7                	mov    %eax,%edi
  8024d9:	48 b8 c4 23 80 00 00 	movabs $0x8023c4,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	callq  *%rax
  8024e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024ec:	79 05                	jns    8024f3 <readn+0x56>
			return m;
  8024ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024f1:	eb 1d                	jmp    802510 <readn+0x73>
		if (m == 0)
  8024f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024f7:	74 13                	je     80250c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024fc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802502:	48 98                	cltq   
  802504:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802508:	72 af                	jb     8024b9 <readn+0x1c>
  80250a:	eb 01                	jmp    80250d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80250c:	90                   	nop
	}
	return tot;
  80250d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802510:	c9                   	leaveq 
  802511:	c3                   	retq   

0000000000802512 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802512:	55                   	push   %rbp
  802513:	48 89 e5             	mov    %rsp,%rbp
  802516:	48 83 ec 40          	sub    $0x40,%rsp
  80251a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80251d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802521:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802525:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802529:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80252c:	48 89 d6             	mov    %rdx,%rsi
  80252f:	89 c7                	mov    %eax,%edi
  802531:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  802538:	00 00 00 
  80253b:	ff d0                	callq  *%rax
  80253d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802540:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802544:	78 24                	js     80256a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254a:	8b 00                	mov    (%rax),%eax
  80254c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802550:	48 89 d6             	mov    %rdx,%rsi
  802553:	89 c7                	mov    %eax,%edi
  802555:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  80255c:	00 00 00 
  80255f:	ff d0                	callq  *%rax
  802561:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802564:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802568:	79 05                	jns    80256f <write+0x5d>
		return r;
  80256a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256d:	eb 79                	jmp    8025e8 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80256f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802573:	8b 40 08             	mov    0x8(%rax),%eax
  802576:	83 e0 03             	and    $0x3,%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	75 3a                	jne    8025b7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80257d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802584:	00 00 00 
  802587:	48 8b 00             	mov    (%rax),%rax
  80258a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802590:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802593:	89 c6                	mov    %eax,%esi
  802595:	48 bf ab 44 80 00 00 	movabs $0x8044ab,%rdi
  80259c:	00 00 00 
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	48 b9 77 06 80 00 00 	movabs $0x800677,%rcx
  8025ab:	00 00 00 
  8025ae:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025b5:	eb 31                	jmp    8025e8 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025bf:	48 85 c0             	test   %rax,%rax
  8025c2:	75 07                	jne    8025cb <write+0xb9>
		return -E_NOT_SUPP;
  8025c4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c9:	eb 1d                	jmp    8025e8 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8025cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cf:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8025d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025db:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025df:	48 89 ce             	mov    %rcx,%rsi
  8025e2:	48 89 c7             	mov    %rax,%rdi
  8025e5:	41 ff d0             	callq  *%r8
}
  8025e8:	c9                   	leaveq 
  8025e9:	c3                   	retq   

00000000008025ea <seek>:

int
seek(int fdnum, off_t offset)
{
  8025ea:	55                   	push   %rbp
  8025eb:	48 89 e5             	mov    %rsp,%rbp
  8025ee:	48 83 ec 18          	sub    $0x18,%rsp
  8025f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025f5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025ff:	48 89 d6             	mov    %rdx,%rsi
  802602:	89 c7                	mov    %eax,%edi
  802604:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  80260b:	00 00 00 
  80260e:	ff d0                	callq  *%rax
  802610:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802613:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802617:	79 05                	jns    80261e <seek+0x34>
		return r;
  802619:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261c:	eb 0f                	jmp    80262d <seek+0x43>
	fd->fd_offset = offset;
  80261e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802622:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802625:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262d:	c9                   	leaveq 
  80262e:	c3                   	retq   

000000000080262f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80262f:	55                   	push   %rbp
  802630:	48 89 e5             	mov    %rsp,%rbp
  802633:	48 83 ec 30          	sub    $0x30,%rsp
  802637:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80263a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80263d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802641:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802644:	48 89 d6             	mov    %rdx,%rsi
  802647:	89 c7                	mov    %eax,%edi
  802649:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  802650:	00 00 00 
  802653:	ff d0                	callq  *%rax
  802655:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802658:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265c:	78 24                	js     802682 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80265e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802662:	8b 00                	mov    (%rax),%eax
  802664:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802668:	48 89 d6             	mov    %rdx,%rsi
  80266b:	89 c7                	mov    %eax,%edi
  80266d:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802674:	00 00 00 
  802677:	ff d0                	callq  *%rax
  802679:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802680:	79 05                	jns    802687 <ftruncate+0x58>
		return r;
  802682:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802685:	eb 72                	jmp    8026f9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268b:	8b 40 08             	mov    0x8(%rax),%eax
  80268e:	83 e0 03             	and    $0x3,%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	75 3a                	jne    8026cf <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802695:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80269c:	00 00 00 
  80269f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026a8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026ab:	89 c6                	mov    %eax,%esi
  8026ad:	48 bf c8 44 80 00 00 	movabs $0x8044c8,%rdi
  8026b4:	00 00 00 
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bc:	48 b9 77 06 80 00 00 	movabs $0x800677,%rcx
  8026c3:	00 00 00 
  8026c6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026cd:	eb 2a                	jmp    8026f9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8026cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026d7:	48 85 c0             	test   %rax,%rax
  8026da:	75 07                	jne    8026e3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026dc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026e1:	eb 16                	jmp    8026f9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e7:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8026eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ef:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8026f2:	89 d6                	mov    %edx,%esi
  8026f4:	48 89 c7             	mov    %rax,%rdi
  8026f7:	ff d1                	callq  *%rcx
}
  8026f9:	c9                   	leaveq 
  8026fa:	c3                   	retq   

00000000008026fb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026fb:	55                   	push   %rbp
  8026fc:	48 89 e5             	mov    %rsp,%rbp
  8026ff:	48 83 ec 30          	sub    $0x30,%rsp
  802703:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802706:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80270a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80270e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802711:	48 89 d6             	mov    %rdx,%rsi
  802714:	89 c7                	mov    %eax,%edi
  802716:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  80271d:	00 00 00 
  802720:	ff d0                	callq  *%rax
  802722:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802725:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802729:	78 24                	js     80274f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80272b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272f:	8b 00                	mov    (%rax),%eax
  802731:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802735:	48 89 d6             	mov    %rdx,%rsi
  802738:	89 c7                	mov    %eax,%edi
  80273a:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802741:	00 00 00 
  802744:	ff d0                	callq  *%rax
  802746:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802749:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80274d:	79 05                	jns    802754 <fstat+0x59>
		return r;
  80274f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802752:	eb 5e                	jmp    8027b2 <fstat+0xb7>
	if (!dev->dev_stat)
  802754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802758:	48 8b 40 28          	mov    0x28(%rax),%rax
  80275c:	48 85 c0             	test   %rax,%rax
  80275f:	75 07                	jne    802768 <fstat+0x6d>
		return -E_NOT_SUPP;
  802761:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802766:	eb 4a                	jmp    8027b2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802768:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80276c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80276f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802773:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80277a:	00 00 00 
	stat->st_isdir = 0;
  80277d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802781:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802788:	00 00 00 
	stat->st_dev = dev;
  80278b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80278f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802793:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80279a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8027a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8027aa:	48 89 d6             	mov    %rdx,%rsi
  8027ad:	48 89 c7             	mov    %rax,%rdi
  8027b0:	ff d1                	callq  *%rcx
}
  8027b2:	c9                   	leaveq 
  8027b3:	c3                   	retq   

00000000008027b4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027b4:	55                   	push   %rbp
  8027b5:	48 89 e5             	mov    %rsp,%rbp
  8027b8:	48 83 ec 20          	sub    $0x20,%rsp
  8027bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c8:	be 00 00 00 00       	mov    $0x0,%esi
  8027cd:	48 89 c7             	mov    %rax,%rdi
  8027d0:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  8027d7:	00 00 00 
  8027da:	ff d0                	callq  *%rax
  8027dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e3:	79 05                	jns    8027ea <stat+0x36>
		return fd;
  8027e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e8:	eb 2f                	jmp    802819 <stat+0x65>
	r = fstat(fd, stat);
  8027ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f1:	48 89 d6             	mov    %rdx,%rsi
  8027f4:	89 c7                	mov    %eax,%edi
  8027f6:	48 b8 fb 26 80 00 00 	movabs $0x8026fb,%rax
  8027fd:	00 00 00 
  802800:	ff d0                	callq  *%rax
  802802:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802808:	89 c7                	mov    %eax,%edi
  80280a:	48 b8 a2 21 80 00 00 	movabs $0x8021a2,%rax
  802811:	00 00 00 
  802814:	ff d0                	callq  *%rax
	return r;
  802816:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802819:	c9                   	leaveq 
  80281a:	c3                   	retq   
	...

000000000080281c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80281c:	55                   	push   %rbp
  80281d:	48 89 e5             	mov    %rsp,%rbp
  802820:	48 83 ec 10          	sub    $0x10,%rsp
  802824:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802827:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80282b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802832:	00 00 00 
  802835:	8b 00                	mov    (%rax),%eax
  802837:	85 c0                	test   %eax,%eax
  802839:	75 1d                	jne    802858 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80283b:	bf 01 00 00 00       	mov    $0x1,%edi
  802840:	48 b8 bf 3d 80 00 00 	movabs $0x803dbf,%rax
  802847:	00 00 00 
  80284a:	ff d0                	callq  *%rax
  80284c:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  802853:	00 00 00 
  802856:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802858:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80285f:	00 00 00 
  802862:	8b 00                	mov    (%rax),%eax
  802864:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802867:	b9 07 00 00 00       	mov    $0x7,%ecx
  80286c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802873:	00 00 00 
  802876:	89 c7                	mov    %eax,%edi
  802878:	48 b8 fc 3c 80 00 00 	movabs $0x803cfc,%rax
  80287f:	00 00 00 
  802882:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802888:	ba 00 00 00 00       	mov    $0x0,%edx
  80288d:	48 89 c6             	mov    %rax,%rsi
  802890:	bf 00 00 00 00       	mov    $0x0,%edi
  802895:	48 b8 3c 3c 80 00 00 	movabs $0x803c3c,%rax
  80289c:	00 00 00 
  80289f:	ff d0                	callq  *%rax
}
  8028a1:	c9                   	leaveq 
  8028a2:	c3                   	retq   

00000000008028a3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028a3:	55                   	push   %rbp
  8028a4:	48 89 e5             	mov    %rsp,%rbp
  8028a7:	48 83 ec 20          	sub    $0x20,%rsp
  8028ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8028b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b6:	48 89 c7             	mov    %rax,%rdi
  8028b9:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
  8028c5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028ca:	7e 0a                	jle    8028d6 <open+0x33>
                return -E_BAD_PATH;
  8028cc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028d1:	e9 a5 00 00 00       	jmpq   80297b <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8028d6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8028da:	48 89 c7             	mov    %rax,%rdi
  8028dd:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax
  8028e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f0:	79 08                	jns    8028fa <open+0x57>
		return r;
  8028f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f5:	e9 81 00 00 00       	jmpq   80297b <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8028fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fe:	48 89 c6             	mov    %rax,%rsi
  802901:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802908:	00 00 00 
  80290b:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  802912:	00 00 00 
  802915:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802917:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80291e:	00 00 00 
  802921:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802924:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  80292a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292e:	48 89 c6             	mov    %rax,%rsi
  802931:	bf 01 00 00 00       	mov    $0x1,%edi
  802936:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  80293d:	00 00 00 
  802940:	ff d0                	callq  *%rax
  802942:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802945:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802949:	79 1d                	jns    802968 <open+0xc5>
	{
		fd_close(fd,0);
  80294b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80294f:	be 00 00 00 00       	mov    $0x0,%esi
  802954:	48 89 c7             	mov    %rax,%rdi
  802957:	48 b8 22 20 80 00 00 	movabs $0x802022,%rax
  80295e:	00 00 00 
  802961:	ff d0                	callq  *%rax
		return r;
  802963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802966:	eb 13                	jmp    80297b <open+0xd8>
	}
	return fd2num(fd);
  802968:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296c:	48 89 c7             	mov    %rax,%rdi
  80296f:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  802976:	00 00 00 
  802979:	ff d0                	callq  *%rax
	


}
  80297b:	c9                   	leaveq 
  80297c:	c3                   	retq   

000000000080297d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80297d:	55                   	push   %rbp
  80297e:	48 89 e5             	mov    %rsp,%rbp
  802981:	48 83 ec 10          	sub    $0x10,%rsp
  802985:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802989:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80298d:	8b 50 0c             	mov    0xc(%rax),%edx
  802990:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802997:	00 00 00 
  80299a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80299c:	be 00 00 00 00       	mov    $0x0,%esi
  8029a1:	bf 06 00 00 00       	mov    $0x6,%edi
  8029a6:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  8029ad:	00 00 00 
  8029b0:	ff d0                	callq  *%rax
}
  8029b2:	c9                   	leaveq 
  8029b3:	c3                   	retq   

00000000008029b4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029b4:	55                   	push   %rbp
  8029b5:	48 89 e5             	mov    %rsp,%rbp
  8029b8:	48 83 ec 30          	sub    $0x30,%rsp
  8029bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cc:	8b 50 0c             	mov    0xc(%rax),%edx
  8029cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d6:	00 00 00 
  8029d9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029db:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029e2:	00 00 00 
  8029e5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029e9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8029ed:	be 00 00 00 00       	mov    $0x0,%esi
  8029f2:	bf 03 00 00 00       	mov    $0x3,%edi
  8029f7:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  8029fe:	00 00 00 
  802a01:	ff d0                	callq  *%rax
  802a03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0a:	79 05                	jns    802a11 <devfile_read+0x5d>
	{
		return r;
  802a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0f:	eb 2c                	jmp    802a3d <devfile_read+0x89>
	}
	if(r > 0)
  802a11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a15:	7e 23                	jle    802a3a <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1a:	48 63 d0             	movslq %eax,%rdx
  802a1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a21:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a28:	00 00 00 
  802a2b:	48 89 c7             	mov    %rax,%rdi
  802a2e:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  802a35:	00 00 00 
  802a38:	ff d0                	callq  *%rax
	return r;
  802a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802a3d:	c9                   	leaveq 
  802a3e:	c3                   	retq   

0000000000802a3f <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a3f:	55                   	push   %rbp
  802a40:	48 89 e5             	mov    %rsp,%rbp
  802a43:	48 83 ec 30          	sub    $0x30,%rsp
  802a47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a4f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802a53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a57:	8b 50 0c             	mov    0xc(%rax),%edx
  802a5a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a61:	00 00 00 
  802a64:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802a66:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a6d:	00 
  802a6e:	76 08                	jbe    802a78 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802a70:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a77:	00 
	fsipcbuf.write.req_n=n;
  802a78:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a7f:	00 00 00 
  802a82:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a86:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802a8a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a92:	48 89 c6             	mov    %rax,%rsi
  802a95:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a9c:	00 00 00 
  802a9f:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802aab:	be 00 00 00 00       	mov    $0x0,%esi
  802ab0:	bf 04 00 00 00       	mov    $0x4,%edi
  802ab5:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
  802ac1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ac7:	c9                   	leaveq 
  802ac8:	c3                   	retq   

0000000000802ac9 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802ac9:	55                   	push   %rbp
  802aca:	48 89 e5             	mov    %rsp,%rbp
  802acd:	48 83 ec 10          	sub    $0x10,%rsp
  802ad1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ad5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ad8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802adc:	8b 50 0c             	mov    0xc(%rax),%edx
  802adf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ae6:	00 00 00 
  802ae9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802aeb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802af2:	00 00 00 
  802af5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802af8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802afb:	be 00 00 00 00       	mov    $0x0,%esi
  802b00:	bf 02 00 00 00       	mov    $0x2,%edi
  802b05:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  802b0c:	00 00 00 
  802b0f:	ff d0                	callq  *%rax
}
  802b11:	c9                   	leaveq 
  802b12:	c3                   	retq   

0000000000802b13 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b13:	55                   	push   %rbp
  802b14:	48 89 e5             	mov    %rsp,%rbp
  802b17:	48 83 ec 20          	sub    $0x20,%rsp
  802b1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b27:	8b 50 0c             	mov    0xc(%rax),%edx
  802b2a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b31:	00 00 00 
  802b34:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b36:	be 00 00 00 00       	mov    $0x0,%esi
  802b3b:	bf 05 00 00 00       	mov    $0x5,%edi
  802b40:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  802b47:	00 00 00 
  802b4a:	ff d0                	callq  *%rax
  802b4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b53:	79 05                	jns    802b5a <devfile_stat+0x47>
		return r;
  802b55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b58:	eb 56                	jmp    802bb0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b5e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b65:	00 00 00 
  802b68:	48 89 c7             	mov    %rax,%rdi
  802b6b:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b77:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b7e:	00 00 00 
  802b81:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b8b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b91:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b98:	00 00 00 
  802b9b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ba1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb0:	c9                   	leaveq 
  802bb1:	c3                   	retq   
	...

0000000000802bb4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802bb4:	55                   	push   %rbp
  802bb5:	48 89 e5             	mov    %rsp,%rbp
  802bb8:	48 83 ec 20          	sub    $0x20,%rsp
  802bbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802bbf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bc6:	48 89 d6             	mov    %rdx,%rsi
  802bc9:	89 c7                	mov    %eax,%edi
  802bcb:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
  802bd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bde:	79 05                	jns    802be5 <fd2sockid+0x31>
		return r;
  802be0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be3:	eb 24                	jmp    802c09 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802be5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be9:	8b 10                	mov    (%rax),%edx
  802beb:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802bf2:	00 00 00 
  802bf5:	8b 00                	mov    (%rax),%eax
  802bf7:	39 c2                	cmp    %eax,%edx
  802bf9:	74 07                	je     802c02 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802bfb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c00:	eb 07                	jmp    802c09 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c06:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802c09:	c9                   	leaveq 
  802c0a:	c3                   	retq   

0000000000802c0b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802c0b:	55                   	push   %rbp
  802c0c:	48 89 e5             	mov    %rsp,%rbp
  802c0f:	48 83 ec 20          	sub    $0x20,%rsp
  802c13:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802c16:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c1a:	48 89 c7             	mov    %rax,%rdi
  802c1d:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
  802c29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c30:	78 26                	js     802c58 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802c32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c36:	ba 07 04 00 00       	mov    $0x407,%edx
  802c3b:	48 89 c6             	mov    %rax,%rsi
  802c3e:	bf 00 00 00 00       	mov    $0x0,%edi
  802c43:	48 b8 6c 1b 80 00 00 	movabs $0x801b6c,%rax
  802c4a:	00 00 00 
  802c4d:	ff d0                	callq  *%rax
  802c4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c56:	79 16                	jns    802c6e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802c58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c5b:	89 c7                	mov    %eax,%edi
  802c5d:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  802c64:	00 00 00 
  802c67:	ff d0                	callq  *%rax
		return r;
  802c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6c:	eb 3a                	jmp    802ca8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802c6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c72:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802c79:	00 00 00 
  802c7c:	8b 12                	mov    (%rdx),%edx
  802c7e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802c80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c84:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c92:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c99:	48 89 c7             	mov    %rax,%rdi
  802c9c:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
}
  802ca8:	c9                   	leaveq 
  802ca9:	c3                   	retq   

0000000000802caa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802caa:	55                   	push   %rbp
  802cab:	48 89 e5             	mov    %rsp,%rbp
  802cae:	48 83 ec 30          	sub    $0x30,%rsp
  802cb2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cb9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc0:	89 c7                	mov    %eax,%edi
  802cc2:	48 b8 b4 2b 80 00 00 	movabs $0x802bb4,%rax
  802cc9:	00 00 00 
  802ccc:	ff d0                	callq  *%rax
  802cce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd5:	79 05                	jns    802cdc <accept+0x32>
		return r;
  802cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cda:	eb 3b                	jmp    802d17 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802cdc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ce0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce7:	48 89 ce             	mov    %rcx,%rsi
  802cea:	89 c7                	mov    %eax,%edi
  802cec:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	callq  *%rax
  802cf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cff:	79 05                	jns    802d06 <accept+0x5c>
		return r;
  802d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d04:	eb 11                	jmp    802d17 <accept+0x6d>
	return alloc_sockfd(r);
  802d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d09:	89 c7                	mov    %eax,%edi
  802d0b:	48 b8 0b 2c 80 00 00 	movabs $0x802c0b,%rax
  802d12:	00 00 00 
  802d15:	ff d0                	callq  *%rax
}
  802d17:	c9                   	leaveq 
  802d18:	c3                   	retq   

0000000000802d19 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802d19:	55                   	push   %rbp
  802d1a:	48 89 e5             	mov    %rsp,%rbp
  802d1d:	48 83 ec 20          	sub    $0x20,%rsp
  802d21:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d28:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d2e:	89 c7                	mov    %eax,%edi
  802d30:	48 b8 b4 2b 80 00 00 	movabs $0x802bb4,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	callq  *%rax
  802d3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d43:	79 05                	jns    802d4a <bind+0x31>
		return r;
  802d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d48:	eb 1b                	jmp    802d65 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802d4a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d4d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d54:	48 89 ce             	mov    %rcx,%rsi
  802d57:	89 c7                	mov    %eax,%edi
  802d59:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
}
  802d65:	c9                   	leaveq 
  802d66:	c3                   	retq   

0000000000802d67 <shutdown>:

int
shutdown(int s, int how)
{
  802d67:	55                   	push   %rbp
  802d68:	48 89 e5             	mov    %rsp,%rbp
  802d6b:	48 83 ec 20          	sub    $0x20,%rsp
  802d6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d72:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d75:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d78:	89 c7                	mov    %eax,%edi
  802d7a:	48 b8 b4 2b 80 00 00 	movabs $0x802bb4,%rax
  802d81:	00 00 00 
  802d84:	ff d0                	callq  *%rax
  802d86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8d:	79 05                	jns    802d94 <shutdown+0x2d>
		return r;
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d92:	eb 16                	jmp    802daa <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802d94:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9a:	89 d6                	mov    %edx,%esi
  802d9c:	89 c7                	mov    %eax,%edi
  802d9e:	48 b8 d8 30 80 00 00 	movabs $0x8030d8,%rax
  802da5:	00 00 00 
  802da8:	ff d0                	callq  *%rax
}
  802daa:	c9                   	leaveq 
  802dab:	c3                   	retq   

0000000000802dac <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802dac:	55                   	push   %rbp
  802dad:	48 89 e5             	mov    %rsp,%rbp
  802db0:	48 83 ec 10          	sub    $0x10,%rsp
  802db4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802db8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dbc:	48 89 c7             	mov    %rax,%rdi
  802dbf:	48 b8 44 3e 80 00 00 	movabs $0x803e44,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	callq  *%rax
  802dcb:	83 f8 01             	cmp    $0x1,%eax
  802dce:	75 17                	jne    802de7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd4:	8b 40 0c             	mov    0xc(%rax),%eax
  802dd7:	89 c7                	mov    %eax,%edi
  802dd9:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	callq  *%rax
  802de5:	eb 05                	jmp    802dec <devsock_close+0x40>
	else
		return 0;
  802de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dec:	c9                   	leaveq 
  802ded:	c3                   	retq   

0000000000802dee <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802dee:	55                   	push   %rbp
  802def:	48 89 e5             	mov    %rsp,%rbp
  802df2:	48 83 ec 20          	sub    $0x20,%rsp
  802df6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802df9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dfd:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e03:	89 c7                	mov    %eax,%edi
  802e05:	48 b8 b4 2b 80 00 00 	movabs $0x802bb4,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
  802e11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e18:	79 05                	jns    802e1f <connect+0x31>
		return r;
  802e1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1d:	eb 1b                	jmp    802e3a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802e1f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e22:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e29:	48 89 ce             	mov    %rcx,%rsi
  802e2c:	89 c7                	mov    %eax,%edi
  802e2e:	48 b8 45 31 80 00 00 	movabs $0x803145,%rax
  802e35:	00 00 00 
  802e38:	ff d0                	callq  *%rax
}
  802e3a:	c9                   	leaveq 
  802e3b:	c3                   	retq   

0000000000802e3c <listen>:

int
listen(int s, int backlog)
{
  802e3c:	55                   	push   %rbp
  802e3d:	48 89 e5             	mov    %rsp,%rbp
  802e40:	48 83 ec 20          	sub    $0x20,%rsp
  802e44:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e47:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e4d:	89 c7                	mov    %eax,%edi
  802e4f:	48 b8 b4 2b 80 00 00 	movabs $0x802bb4,%rax
  802e56:	00 00 00 
  802e59:	ff d0                	callq  *%rax
  802e5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e62:	79 05                	jns    802e69 <listen+0x2d>
		return r;
  802e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e67:	eb 16                	jmp    802e7f <listen+0x43>
	return nsipc_listen(r, backlog);
  802e69:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6f:	89 d6                	mov    %edx,%esi
  802e71:	89 c7                	mov    %eax,%edi
  802e73:	48 b8 a9 31 80 00 00 	movabs $0x8031a9,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
}
  802e7f:	c9                   	leaveq 
  802e80:	c3                   	retq   

0000000000802e81 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802e81:	55                   	push   %rbp
  802e82:	48 89 e5             	mov    %rsp,%rbp
  802e85:	48 83 ec 20          	sub    $0x20,%rsp
  802e89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e91:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e99:	89 c2                	mov    %eax,%edx
  802e9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9f:	8b 40 0c             	mov    0xc(%rax),%eax
  802ea2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802ea6:	b9 00 00 00 00       	mov    $0x0,%ecx
  802eab:	89 c7                	mov    %eax,%edi
  802ead:	48 b8 e9 31 80 00 00 	movabs $0x8031e9,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
}
  802eb9:	c9                   	leaveq 
  802eba:	c3                   	retq   

0000000000802ebb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802ebb:	55                   	push   %rbp
  802ebc:	48 89 e5             	mov    %rsp,%rbp
  802ebf:	48 83 ec 20          	sub    $0x20,%rsp
  802ec3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ec7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ecb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed3:	89 c2                	mov    %eax,%edx
  802ed5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed9:	8b 40 0c             	mov    0xc(%rax),%eax
  802edc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802ee0:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ee5:	89 c7                	mov    %eax,%edi
  802ee7:	48 b8 b5 32 80 00 00 	movabs $0x8032b5,%rax
  802eee:	00 00 00 
  802ef1:	ff d0                	callq  *%rax
}
  802ef3:	c9                   	leaveq 
  802ef4:	c3                   	retq   

0000000000802ef5 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802ef5:	55                   	push   %rbp
  802ef6:	48 89 e5             	mov    %rsp,%rbp
  802ef9:	48 83 ec 10          	sub    $0x10,%rsp
  802efd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f09:	48 be f3 44 80 00 00 	movabs $0x8044f3,%rsi
  802f10:	00 00 00 
  802f13:	48 89 c7             	mov    %rax,%rdi
  802f16:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  802f1d:	00 00 00 
  802f20:	ff d0                	callq  *%rax
	return 0;
  802f22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f27:	c9                   	leaveq 
  802f28:	c3                   	retq   

0000000000802f29 <socket>:

int
socket(int domain, int type, int protocol)
{
  802f29:	55                   	push   %rbp
  802f2a:	48 89 e5             	mov    %rsp,%rbp
  802f2d:	48 83 ec 20          	sub    $0x20,%rsp
  802f31:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f34:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802f37:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802f3a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f3d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802f40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f43:	89 ce                	mov    %ecx,%esi
  802f45:	89 c7                	mov    %eax,%edi
  802f47:	48 b8 6d 33 80 00 00 	movabs $0x80336d,%rax
  802f4e:	00 00 00 
  802f51:	ff d0                	callq  *%rax
  802f53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5a:	79 05                	jns    802f61 <socket+0x38>
		return r;
  802f5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5f:	eb 11                	jmp    802f72 <socket+0x49>
	return alloc_sockfd(r);
  802f61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f64:	89 c7                	mov    %eax,%edi
  802f66:	48 b8 0b 2c 80 00 00 	movabs $0x802c0b,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
}
  802f72:	c9                   	leaveq 
  802f73:	c3                   	retq   

0000000000802f74 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802f74:	55                   	push   %rbp
  802f75:	48 89 e5             	mov    %rsp,%rbp
  802f78:	48 83 ec 10          	sub    $0x10,%rsp
  802f7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802f7f:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  802f86:	00 00 00 
  802f89:	8b 00                	mov    (%rax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	75 1d                	jne    802fac <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802f8f:	bf 02 00 00 00       	mov    $0x2,%edi
  802f94:	48 b8 bf 3d 80 00 00 	movabs $0x803dbf,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
  802fa0:	48 ba 2c 70 80 00 00 	movabs $0x80702c,%rdx
  802fa7:	00 00 00 
  802faa:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802fac:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  802fb3:	00 00 00 
  802fb6:	8b 00                	mov    (%rax),%eax
  802fb8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fbb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802fc0:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802fc7:	00 00 00 
  802fca:	89 c7                	mov    %eax,%edi
  802fcc:	48 b8 fc 3c 80 00 00 	movabs $0x803cfc,%rax
  802fd3:	00 00 00 
  802fd6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802fd8:	ba 00 00 00 00       	mov    $0x0,%edx
  802fdd:	be 00 00 00 00       	mov    $0x0,%esi
  802fe2:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe7:	48 b8 3c 3c 80 00 00 	movabs $0x803c3c,%rax
  802fee:	00 00 00 
  802ff1:	ff d0                	callq  *%rax
}
  802ff3:	c9                   	leaveq 
  802ff4:	c3                   	retq   

0000000000802ff5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ff5:	55                   	push   %rbp
  802ff6:	48 89 e5             	mov    %rsp,%rbp
  802ff9:	48 83 ec 30          	sub    $0x30,%rsp
  802ffd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803000:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803004:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803008:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80300f:	00 00 00 
  803012:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803015:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803017:	bf 01 00 00 00       	mov    $0x1,%edi
  80301c:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  803023:	00 00 00 
  803026:	ff d0                	callq  *%rax
  803028:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80302b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302f:	78 3e                	js     80306f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803031:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803038:	00 00 00 
  80303b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80303f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803043:	8b 40 10             	mov    0x10(%rax),%eax
  803046:	89 c2                	mov    %eax,%edx
  803048:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80304c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803050:	48 89 ce             	mov    %rcx,%rsi
  803053:	48 89 c7             	mov    %rax,%rdi
  803056:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  80305d:	00 00 00 
  803060:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803062:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803066:	8b 50 10             	mov    0x10(%rax),%edx
  803069:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80306d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80306f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803072:	c9                   	leaveq 
  803073:	c3                   	retq   

0000000000803074 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803074:	55                   	push   %rbp
  803075:	48 89 e5             	mov    %rsp,%rbp
  803078:	48 83 ec 10          	sub    $0x10,%rsp
  80307c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80307f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803083:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803086:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80308d:	00 00 00 
  803090:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803093:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803095:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309c:	48 89 c6             	mov    %rax,%rsi
  80309f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8030a6:	00 00 00 
  8030a9:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8030b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030bc:	00 00 00 
  8030bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030c2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8030c5:	bf 02 00 00 00       	mov    $0x2,%edi
  8030ca:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
}
  8030d6:	c9                   	leaveq 
  8030d7:	c3                   	retq   

00000000008030d8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8030d8:	55                   	push   %rbp
  8030d9:	48 89 e5             	mov    %rsp,%rbp
  8030dc:	48 83 ec 10          	sub    $0x10,%rsp
  8030e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030e3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8030e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030ed:	00 00 00 
  8030f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030f3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8030f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030fc:	00 00 00 
  8030ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803102:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803105:	bf 03 00 00 00       	mov    $0x3,%edi
  80310a:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
}
  803116:	c9                   	leaveq 
  803117:	c3                   	retq   

0000000000803118 <nsipc_close>:

int
nsipc_close(int s)
{
  803118:	55                   	push   %rbp
  803119:	48 89 e5             	mov    %rsp,%rbp
  80311c:	48 83 ec 10          	sub    $0x10,%rsp
  803120:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803123:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80312a:	00 00 00 
  80312d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803130:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803132:	bf 04 00 00 00       	mov    $0x4,%edi
  803137:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  80313e:	00 00 00 
  803141:	ff d0                	callq  *%rax
}
  803143:	c9                   	leaveq 
  803144:	c3                   	retq   

0000000000803145 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803145:	55                   	push   %rbp
  803146:	48 89 e5             	mov    %rsp,%rbp
  803149:	48 83 ec 10          	sub    $0x10,%rsp
  80314d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803150:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803154:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803157:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80315e:	00 00 00 
  803161:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803164:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803166:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316d:	48 89 c6             	mov    %rax,%rsi
  803170:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803177:	00 00 00 
  80317a:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  803181:	00 00 00 
  803184:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803186:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80318d:	00 00 00 
  803190:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803193:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803196:	bf 05 00 00 00       	mov    $0x5,%edi
  80319b:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  8031a2:	00 00 00 
  8031a5:	ff d0                	callq  *%rax
}
  8031a7:	c9                   	leaveq 
  8031a8:	c3                   	retq   

00000000008031a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8031a9:	55                   	push   %rbp
  8031aa:	48 89 e5             	mov    %rsp,%rbp
  8031ad:	48 83 ec 10          	sub    $0x10,%rsp
  8031b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031b4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8031b7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031be:	00 00 00 
  8031c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031c4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8031c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031cd:	00 00 00 
  8031d0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031d3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8031d6:	bf 06 00 00 00       	mov    $0x6,%edi
  8031db:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax
}
  8031e7:	c9                   	leaveq 
  8031e8:	c3                   	retq   

00000000008031e9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8031e9:	55                   	push   %rbp
  8031ea:	48 89 e5             	mov    %rsp,%rbp
  8031ed:	48 83 ec 30          	sub    $0x30,%rsp
  8031f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031f8:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8031fb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8031fe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803205:	00 00 00 
  803208:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80320b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80320d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803214:	00 00 00 
  803217:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80321a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80321d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803224:	00 00 00 
  803227:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80322a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80322d:	bf 07 00 00 00       	mov    $0x7,%edi
  803232:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
  80323e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803241:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803245:	78 69                	js     8032b0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803247:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80324e:	7f 08                	jg     803258 <nsipc_recv+0x6f>
  803250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803253:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803256:	7e 35                	jle    80328d <nsipc_recv+0xa4>
  803258:	48 b9 fa 44 80 00 00 	movabs $0x8044fa,%rcx
  80325f:	00 00 00 
  803262:	48 ba 0f 45 80 00 00 	movabs $0x80450f,%rdx
  803269:	00 00 00 
  80326c:	be 61 00 00 00       	mov    $0x61,%esi
  803271:	48 bf 24 45 80 00 00 	movabs $0x804524,%rdi
  803278:	00 00 00 
  80327b:	b8 00 00 00 00       	mov    $0x0,%eax
  803280:	49 b8 3c 04 80 00 00 	movabs $0x80043c,%r8
  803287:	00 00 00 
  80328a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80328d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803290:	48 63 d0             	movslq %eax,%rdx
  803293:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803297:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80329e:	00 00 00 
  8032a1:	48 89 c7             	mov    %rax,%rdi
  8032a4:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  8032ab:	00 00 00 
  8032ae:	ff d0                	callq  *%rax
	}

	return r;
  8032b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032b3:	c9                   	leaveq 
  8032b4:	c3                   	retq   

00000000008032b5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8032b5:	55                   	push   %rbp
  8032b6:	48 89 e5             	mov    %rsp,%rbp
  8032b9:	48 83 ec 20          	sub    $0x20,%rsp
  8032bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8032c7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8032ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d1:	00 00 00 
  8032d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032d7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8032d9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8032e0:	7e 35                	jle    803317 <nsipc_send+0x62>
  8032e2:	48 b9 30 45 80 00 00 	movabs $0x804530,%rcx
  8032e9:	00 00 00 
  8032ec:	48 ba 0f 45 80 00 00 	movabs $0x80450f,%rdx
  8032f3:	00 00 00 
  8032f6:	be 6c 00 00 00       	mov    $0x6c,%esi
  8032fb:	48 bf 24 45 80 00 00 	movabs $0x804524,%rdi
  803302:	00 00 00 
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
  80330a:	49 b8 3c 04 80 00 00 	movabs $0x80043c,%r8
  803311:	00 00 00 
  803314:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803317:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80331a:	48 63 d0             	movslq %eax,%rdx
  80331d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803321:	48 89 c6             	mov    %rax,%rsi
  803324:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80332b:	00 00 00 
  80332e:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  803335:	00 00 00 
  803338:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80333a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803341:	00 00 00 
  803344:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803347:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80334a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803351:	00 00 00 
  803354:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803357:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80335a:	bf 08 00 00 00       	mov    $0x8,%edi
  80335f:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  803366:	00 00 00 
  803369:	ff d0                	callq  *%rax
}
  80336b:	c9                   	leaveq 
  80336c:	c3                   	retq   

000000000080336d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80336d:	55                   	push   %rbp
  80336e:	48 89 e5             	mov    %rsp,%rbp
  803371:	48 83 ec 10          	sub    $0x10,%rsp
  803375:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803378:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80337b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80337e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803385:	00 00 00 
  803388:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80338b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80338d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803394:	00 00 00 
  803397:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80339a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80339d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033a4:	00 00 00 
  8033a7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033aa:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8033ad:	bf 09 00 00 00       	mov    $0x9,%edi
  8033b2:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  8033b9:	00 00 00 
  8033bc:	ff d0                	callq  *%rax
}
  8033be:	c9                   	leaveq 
  8033bf:	c3                   	retq   

00000000008033c0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8033c0:	55                   	push   %rbp
  8033c1:	48 89 e5             	mov    %rsp,%rbp
  8033c4:	53                   	push   %rbx
  8033c5:	48 83 ec 38          	sub    $0x38,%rsp
  8033c9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8033cd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8033d1:	48 89 c7             	mov    %rax,%rdi
  8033d4:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
  8033e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033e7:	0f 88 bf 01 00 00    	js     8035ac <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f1:	ba 07 04 00 00       	mov    $0x407,%edx
  8033f6:	48 89 c6             	mov    %rax,%rsi
  8033f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033fe:	48 b8 6c 1b 80 00 00 	movabs $0x801b6c,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
  80340a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80340d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803411:	0f 88 95 01 00 00    	js     8035ac <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803417:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80341b:	48 89 c7             	mov    %rax,%rdi
  80341e:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  803425:	00 00 00 
  803428:	ff d0                	callq  *%rax
  80342a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80342d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803431:	0f 88 5d 01 00 00    	js     803594 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803437:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343b:	ba 07 04 00 00       	mov    $0x407,%edx
  803440:	48 89 c6             	mov    %rax,%rsi
  803443:	bf 00 00 00 00       	mov    $0x0,%edi
  803448:	48 b8 6c 1b 80 00 00 	movabs $0x801b6c,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
  803454:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803457:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80345b:	0f 88 33 01 00 00    	js     803594 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803461:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803465:	48 89 c7             	mov    %rax,%rdi
  803468:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  80346f:	00 00 00 
  803472:	ff d0                	callq  *%rax
  803474:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803478:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347c:	ba 07 04 00 00       	mov    $0x407,%edx
  803481:	48 89 c6             	mov    %rax,%rsi
  803484:	bf 00 00 00 00       	mov    $0x0,%edi
  803489:	48 b8 6c 1b 80 00 00 	movabs $0x801b6c,%rax
  803490:	00 00 00 
  803493:	ff d0                	callq  *%rax
  803495:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803498:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80349c:	0f 88 d9 00 00 00    	js     80357b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034a6:	48 89 c7             	mov    %rax,%rdi
  8034a9:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
  8034b5:	48 89 c2             	mov    %rax,%rdx
  8034b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034bc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8034c2:	48 89 d1             	mov    %rdx,%rcx
  8034c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8034ca:	48 89 c6             	mov    %rax,%rsi
  8034cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d2:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
  8034de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034e5:	78 79                	js     803560 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8034e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034eb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8034f2:	00 00 00 
  8034f5:	8b 12                	mov    (%rdx),%edx
  8034f7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8034f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803504:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803508:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80350f:	00 00 00 
  803512:	8b 12                	mov    (%rdx),%edx
  803514:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803516:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80351a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803525:	48 89 c7             	mov    %rax,%rdi
  803528:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  80352f:	00 00 00 
  803532:	ff d0                	callq  *%rax
  803534:	89 c2                	mov    %eax,%edx
  803536:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80353a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80353c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803540:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803544:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803548:	48 89 c7             	mov    %rax,%rdi
  80354b:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax
  803557:	89 03                	mov    %eax,(%rbx)
	return 0;
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
  80355e:	eb 4f                	jmp    8035af <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803560:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803561:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803565:	48 89 c6             	mov    %rax,%rsi
  803568:	bf 00 00 00 00       	mov    $0x0,%edi
  80356d:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  803574:	00 00 00 
  803577:	ff d0                	callq  *%rax
  803579:	eb 01                	jmp    80357c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80357b:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80357c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803580:	48 89 c6             	mov    %rax,%rsi
  803583:	bf 00 00 00 00       	mov    $0x0,%edi
  803588:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803598:	48 89 c6             	mov    %rax,%rsi
  80359b:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a0:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  8035a7:	00 00 00 
  8035aa:	ff d0                	callq  *%rax
    err:
	return r;
  8035ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035af:	48 83 c4 38          	add    $0x38,%rsp
  8035b3:	5b                   	pop    %rbx
  8035b4:	5d                   	pop    %rbp
  8035b5:	c3                   	retq   

00000000008035b6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035b6:	55                   	push   %rbp
  8035b7:	48 89 e5             	mov    %rsp,%rbp
  8035ba:	53                   	push   %rbx
  8035bb:	48 83 ec 28          	sub    $0x28,%rsp
  8035bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035c7:	eb 01                	jmp    8035ca <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8035c9:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8035ca:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8035d1:	00 00 00 
  8035d4:	48 8b 00             	mov    (%rax),%rax
  8035d7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8035e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e4:	48 89 c7             	mov    %rax,%rdi
  8035e7:	48 b8 44 3e 80 00 00 	movabs $0x803e44,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
  8035f3:	89 c3                	mov    %eax,%ebx
  8035f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035f9:	48 89 c7             	mov    %rax,%rdi
  8035fc:	48 b8 44 3e 80 00 00 	movabs $0x803e44,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
  803608:	39 c3                	cmp    %eax,%ebx
  80360a:	0f 94 c0             	sete   %al
  80360d:	0f b6 c0             	movzbl %al,%eax
  803610:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803613:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80361a:	00 00 00 
  80361d:	48 8b 00             	mov    (%rax),%rax
  803620:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803626:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803629:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80362c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80362f:	75 0a                	jne    80363b <_pipeisclosed+0x85>
			return ret;
  803631:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803634:	48 83 c4 28          	add    $0x28,%rsp
  803638:	5b                   	pop    %rbx
  803639:	5d                   	pop    %rbp
  80363a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80363b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80363e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803641:	74 86                	je     8035c9 <_pipeisclosed+0x13>
  803643:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803647:	75 80                	jne    8035c9 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803649:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803650:	00 00 00 
  803653:	48 8b 00             	mov    (%rax),%rax
  803656:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80365c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80365f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803662:	89 c6                	mov    %eax,%esi
  803664:	48 bf 41 45 80 00 00 	movabs $0x804541,%rdi
  80366b:	00 00 00 
  80366e:	b8 00 00 00 00       	mov    $0x0,%eax
  803673:	49 b8 77 06 80 00 00 	movabs $0x800677,%r8
  80367a:	00 00 00 
  80367d:	41 ff d0             	callq  *%r8
	}
  803680:	e9 44 ff ff ff       	jmpq   8035c9 <_pipeisclosed+0x13>

0000000000803685 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803685:	55                   	push   %rbp
  803686:	48 89 e5             	mov    %rsp,%rbp
  803689:	48 83 ec 30          	sub    $0x30,%rsp
  80368d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803690:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803694:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803697:	48 89 d6             	mov    %rdx,%rsi
  80369a:	89 c7                	mov    %eax,%edi
  80369c:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
  8036a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036af:	79 05                	jns    8036b6 <pipeisclosed+0x31>
		return r;
  8036b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b4:	eb 31                	jmp    8036e7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8036b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ba:	48 89 c7             	mov    %rax,%rdi
  8036bd:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  8036c4:	00 00 00 
  8036c7:	ff d0                	callq  *%rax
  8036c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8036cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036d5:	48 89 d6             	mov    %rdx,%rsi
  8036d8:	48 89 c7             	mov    %rax,%rdi
  8036db:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
}
  8036e7:	c9                   	leaveq 
  8036e8:	c3                   	retq   

00000000008036e9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8036e9:	55                   	push   %rbp
  8036ea:	48 89 e5             	mov    %rsp,%rbp
  8036ed:	48 83 ec 40          	sub    $0x40,%rsp
  8036f1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036f5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036f9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8036fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803701:	48 89 c7             	mov    %rax,%rdi
  803704:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
  803710:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803714:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803718:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80371c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803723:	00 
  803724:	e9 97 00 00 00       	jmpq   8037c0 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803729:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80372e:	74 09                	je     803739 <devpipe_read+0x50>
				return i;
  803730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803734:	e9 95 00 00 00       	jmpq   8037ce <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803739:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80373d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803741:	48 89 d6             	mov    %rdx,%rsi
  803744:	48 89 c7             	mov    %rax,%rdi
  803747:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  80374e:	00 00 00 
  803751:	ff d0                	callq  *%rax
  803753:	85 c0                	test   %eax,%eax
  803755:	74 07                	je     80375e <devpipe_read+0x75>
				return 0;
  803757:	b8 00 00 00 00       	mov    $0x0,%eax
  80375c:	eb 70                	jmp    8037ce <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80375e:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  803765:	00 00 00 
  803768:	ff d0                	callq  *%rax
  80376a:	eb 01                	jmp    80376d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80376c:	90                   	nop
  80376d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803771:	8b 10                	mov    (%rax),%edx
  803773:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803777:	8b 40 04             	mov    0x4(%rax),%eax
  80377a:	39 c2                	cmp    %eax,%edx
  80377c:	74 ab                	je     803729 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80377e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803782:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803786:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80378a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378e:	8b 00                	mov    (%rax),%eax
  803790:	89 c2                	mov    %eax,%edx
  803792:	c1 fa 1f             	sar    $0x1f,%edx
  803795:	c1 ea 1b             	shr    $0x1b,%edx
  803798:	01 d0                	add    %edx,%eax
  80379a:	83 e0 1f             	and    $0x1f,%eax
  80379d:	29 d0                	sub    %edx,%eax
  80379f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037a3:	48 98                	cltq   
  8037a5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8037aa:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8037ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b0:	8b 00                	mov    (%rax),%eax
  8037b2:	8d 50 01             	lea    0x1(%rax),%edx
  8037b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037c8:	72 a2                	jb     80376c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8037ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037ce:	c9                   	leaveq 
  8037cf:	c3                   	retq   

00000000008037d0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037d0:	55                   	push   %rbp
  8037d1:	48 89 e5             	mov    %rsp,%rbp
  8037d4:	48 83 ec 40          	sub    $0x40,%rsp
  8037d8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037dc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037e0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8037e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e8:	48 89 c7             	mov    %rax,%rdi
  8037eb:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  8037f2:	00 00 00 
  8037f5:	ff d0                	callq  *%rax
  8037f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803803:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80380a:	00 
  80380b:	e9 93 00 00 00       	jmpq   8038a3 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803810:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803814:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803818:	48 89 d6             	mov    %rdx,%rsi
  80381b:	48 89 c7             	mov    %rax,%rdi
  80381e:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  803825:	00 00 00 
  803828:	ff d0                	callq  *%rax
  80382a:	85 c0                	test   %eax,%eax
  80382c:	74 07                	je     803835 <devpipe_write+0x65>
				return 0;
  80382e:	b8 00 00 00 00       	mov    $0x0,%eax
  803833:	eb 7c                	jmp    8038b1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803835:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
  803841:	eb 01                	jmp    803844 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803843:	90                   	nop
  803844:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803848:	8b 40 04             	mov    0x4(%rax),%eax
  80384b:	48 63 d0             	movslq %eax,%rdx
  80384e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803852:	8b 00                	mov    (%rax),%eax
  803854:	48 98                	cltq   
  803856:	48 83 c0 20          	add    $0x20,%rax
  80385a:	48 39 c2             	cmp    %rax,%rdx
  80385d:	73 b1                	jae    803810 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80385f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803863:	8b 40 04             	mov    0x4(%rax),%eax
  803866:	89 c2                	mov    %eax,%edx
  803868:	c1 fa 1f             	sar    $0x1f,%edx
  80386b:	c1 ea 1b             	shr    $0x1b,%edx
  80386e:	01 d0                	add    %edx,%eax
  803870:	83 e0 1f             	and    $0x1f,%eax
  803873:	29 d0                	sub    %edx,%eax
  803875:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803879:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80387d:	48 01 ca             	add    %rcx,%rdx
  803880:	0f b6 0a             	movzbl (%rdx),%ecx
  803883:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803887:	48 98                	cltq   
  803889:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80388d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803891:	8b 40 04             	mov    0x4(%rax),%eax
  803894:	8d 50 01             	lea    0x1(%rax),%edx
  803897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80389e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038ab:	72 96                	jb     803843 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8038ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038b1:	c9                   	leaveq 
  8038b2:	c3                   	retq   

00000000008038b3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8038b3:	55                   	push   %rbp
  8038b4:	48 89 e5             	mov    %rsp,%rbp
  8038b7:	48 83 ec 20          	sub    $0x20,%rsp
  8038bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8038c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c7:	48 89 c7             	mov    %rax,%rdi
  8038ca:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  8038d1:	00 00 00 
  8038d4:	ff d0                	callq  *%rax
  8038d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8038da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038de:	48 be 54 45 80 00 00 	movabs $0x804554,%rsi
  8038e5:	00 00 00 
  8038e8:	48 89 c7             	mov    %rax,%rdi
  8038eb:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  8038f2:	00 00 00 
  8038f5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8038f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038fb:	8b 50 04             	mov    0x4(%rax),%edx
  8038fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803902:	8b 00                	mov    (%rax),%eax
  803904:	29 c2                	sub    %eax,%edx
  803906:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803910:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803914:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80391b:	00 00 00 
	stat->st_dev = &devpipe;
  80391e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803922:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803929:	00 00 00 
  80392c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803938:	c9                   	leaveq 
  803939:	c3                   	retq   

000000000080393a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80393a:	55                   	push   %rbp
  80393b:	48 89 e5             	mov    %rsp,%rbp
  80393e:	48 83 ec 10          	sub    $0x10,%rsp
  803942:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803946:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80394a:	48 89 c6             	mov    %rax,%rsi
  80394d:	bf 00 00 00 00       	mov    $0x0,%edi
  803952:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  803959:	00 00 00 
  80395c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80395e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803962:	48 89 c7             	mov    %rax,%rdi
  803965:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  80396c:	00 00 00 
  80396f:	ff d0                	callq  *%rax
  803971:	48 89 c6             	mov    %rax,%rsi
  803974:	bf 00 00 00 00       	mov    $0x0,%edi
  803979:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  803980:	00 00 00 
  803983:	ff d0                	callq  *%rax
}
  803985:	c9                   	leaveq 
  803986:	c3                   	retq   
	...

0000000000803988 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803988:	55                   	push   %rbp
  803989:	48 89 e5             	mov    %rsp,%rbp
  80398c:	48 83 ec 20          	sub    $0x20,%rsp
  803990:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803993:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803996:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803999:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80399d:	be 01 00 00 00       	mov    $0x1,%esi
  8039a2:	48 89 c7             	mov    %rax,%rdi
  8039a5:	48 b8 24 1a 80 00 00 	movabs $0x801a24,%rax
  8039ac:	00 00 00 
  8039af:	ff d0                	callq  *%rax
}
  8039b1:	c9                   	leaveq 
  8039b2:	c3                   	retq   

00000000008039b3 <getchar>:

int
getchar(void)
{
  8039b3:	55                   	push   %rbp
  8039b4:	48 89 e5             	mov    %rsp,%rbp
  8039b7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8039bb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8039bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8039c4:	48 89 c6             	mov    %rax,%rsi
  8039c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8039cc:	48 b8 c4 23 80 00 00 	movabs $0x8023c4,%rax
  8039d3:	00 00 00 
  8039d6:	ff d0                	callq  *%rax
  8039d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8039db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039df:	79 05                	jns    8039e6 <getchar+0x33>
		return r;
  8039e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e4:	eb 14                	jmp    8039fa <getchar+0x47>
	if (r < 1)
  8039e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ea:	7f 07                	jg     8039f3 <getchar+0x40>
		return -E_EOF;
  8039ec:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8039f1:	eb 07                	jmp    8039fa <getchar+0x47>
	return c;
  8039f3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8039f7:	0f b6 c0             	movzbl %al,%eax
}
  8039fa:	c9                   	leaveq 
  8039fb:	c3                   	retq   

00000000008039fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8039fc:	55                   	push   %rbp
  8039fd:	48 89 e5             	mov    %rsp,%rbp
  803a00:	48 83 ec 20          	sub    $0x20,%rsp
  803a04:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a0b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a0e:	48 89 d6             	mov    %rdx,%rsi
  803a11:	89 c7                	mov    %eax,%edi
  803a13:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  803a1a:	00 00 00 
  803a1d:	ff d0                	callq  *%rax
  803a1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a26:	79 05                	jns    803a2d <iscons+0x31>
		return r;
  803a28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2b:	eb 1a                	jmp    803a47 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a31:	8b 10                	mov    (%rax),%edx
  803a33:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803a3a:	00 00 00 
  803a3d:	8b 00                	mov    (%rax),%eax
  803a3f:	39 c2                	cmp    %eax,%edx
  803a41:	0f 94 c0             	sete   %al
  803a44:	0f b6 c0             	movzbl %al,%eax
}
  803a47:	c9                   	leaveq 
  803a48:	c3                   	retq   

0000000000803a49 <opencons>:

int
opencons(void)
{
  803a49:	55                   	push   %rbp
  803a4a:	48 89 e5             	mov    %rsp,%rbp
  803a4d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803a51:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803a55:	48 89 c7             	mov    %rax,%rdi
  803a58:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  803a5f:	00 00 00 
  803a62:	ff d0                	callq  *%rax
  803a64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a6b:	79 05                	jns    803a72 <opencons+0x29>
		return r;
  803a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a70:	eb 5b                	jmp    803acd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a76:	ba 07 04 00 00       	mov    $0x407,%edx
  803a7b:	48 89 c6             	mov    %rax,%rsi
  803a7e:	bf 00 00 00 00       	mov    $0x0,%edi
  803a83:	48 b8 6c 1b 80 00 00 	movabs $0x801b6c,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
  803a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a96:	79 05                	jns    803a9d <opencons+0x54>
		return r;
  803a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9b:	eb 30                	jmp    803acd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803a9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803aa8:	00 00 00 
  803aab:	8b 12                	mov    (%rdx),%edx
  803aad:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803aaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803aba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abe:	48 89 c7             	mov    %rax,%rdi
  803ac1:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  803ac8:	00 00 00 
  803acb:	ff d0                	callq  *%rax
}
  803acd:	c9                   	leaveq 
  803ace:	c3                   	retq   

0000000000803acf <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803acf:	55                   	push   %rbp
  803ad0:	48 89 e5             	mov    %rsp,%rbp
  803ad3:	48 83 ec 30          	sub    $0x30,%rsp
  803ad7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803adb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803adf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803ae3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ae8:	75 13                	jne    803afd <devcons_read+0x2e>
		return 0;
  803aea:	b8 00 00 00 00       	mov    $0x0,%eax
  803aef:	eb 49                	jmp    803b3a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803af1:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  803af8:	00 00 00 
  803afb:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803afd:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  803b04:	00 00 00 
  803b07:	ff d0                	callq  *%rax
  803b09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b10:	74 df                	je     803af1 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803b12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b16:	79 05                	jns    803b1d <devcons_read+0x4e>
		return c;
  803b18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b1b:	eb 1d                	jmp    803b3a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803b1d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803b21:	75 07                	jne    803b2a <devcons_read+0x5b>
		return 0;
  803b23:	b8 00 00 00 00       	mov    $0x0,%eax
  803b28:	eb 10                	jmp    803b3a <devcons_read+0x6b>
	*(char*)vbuf = c;
  803b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2d:	89 c2                	mov    %eax,%edx
  803b2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b33:	88 10                	mov    %dl,(%rax)
	return 1;
  803b35:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803b3a:	c9                   	leaveq 
  803b3b:	c3                   	retq   

0000000000803b3c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b3c:	55                   	push   %rbp
  803b3d:	48 89 e5             	mov    %rsp,%rbp
  803b40:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803b47:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803b4e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803b55:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b63:	eb 77                	jmp    803bdc <devcons_write+0xa0>
		m = n - tot;
  803b65:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803b6c:	89 c2                	mov    %eax,%edx
  803b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b71:	89 d1                	mov    %edx,%ecx
  803b73:	29 c1                	sub    %eax,%ecx
  803b75:	89 c8                	mov    %ecx,%eax
  803b77:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803b7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b7d:	83 f8 7f             	cmp    $0x7f,%eax
  803b80:	76 07                	jbe    803b89 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803b82:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803b89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b8c:	48 63 d0             	movslq %eax,%rdx
  803b8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b92:	48 98                	cltq   
  803b94:	48 89 c1             	mov    %rax,%rcx
  803b97:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803b9e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ba5:	48 89 ce             	mov    %rcx,%rsi
  803ba8:	48 89 c7             	mov    %rax,%rdi
  803bab:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  803bb2:	00 00 00 
  803bb5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803bb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bba:	48 63 d0             	movslq %eax,%rdx
  803bbd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803bc4:	48 89 d6             	mov    %rdx,%rsi
  803bc7:	48 89 c7             	mov    %rax,%rdi
  803bca:	48 b8 24 1a 80 00 00 	movabs $0x801a24,%rax
  803bd1:	00 00 00 
  803bd4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803bd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bd9:	01 45 fc             	add    %eax,-0x4(%rbp)
  803bdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bdf:	48 98                	cltq   
  803be1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803be8:	0f 82 77 ff ff ff    	jb     803b65 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bf1:	c9                   	leaveq 
  803bf2:	c3                   	retq   

0000000000803bf3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803bf3:	55                   	push   %rbp
  803bf4:	48 89 e5             	mov    %rsp,%rbp
  803bf7:	48 83 ec 08          	sub    $0x8,%rsp
  803bfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c04:	c9                   	leaveq 
  803c05:	c3                   	retq   

0000000000803c06 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803c06:	55                   	push   %rbp
  803c07:	48 89 e5             	mov    %rsp,%rbp
  803c0a:	48 83 ec 10          	sub    $0x10,%rsp
  803c0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803c16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c1a:	48 be 60 45 80 00 00 	movabs $0x804560,%rsi
  803c21:	00 00 00 
  803c24:	48 89 c7             	mov    %rax,%rdi
  803c27:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  803c2e:	00 00 00 
  803c31:	ff d0                	callq  *%rax
	return 0;
  803c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c38:	c9                   	leaveq 
  803c39:	c3                   	retq   
	...

0000000000803c3c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c3c:	55                   	push   %rbp
  803c3d:	48 89 e5             	mov    %rsp,%rbp
  803c40:	48 83 ec 30          	sub    $0x30,%rsp
  803c44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c4c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803c50:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c55:	74 18                	je     803c6f <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803c57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c5b:	48 89 c7             	mov    %rax,%rdi
  803c5e:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  803c65:	00 00 00 
  803c68:	ff d0                	callq  *%rax
  803c6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c6d:	eb 19                	jmp    803c88 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803c6f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803c76:	00 00 00 
  803c79:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  803c80:	00 00 00 
  803c83:	ff d0                	callq  *%rax
  803c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c8c:	79 19                	jns    803ca7 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c92:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c9c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803ca2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca5:	eb 53                	jmp    803cfa <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803ca7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803cac:	74 19                	je     803cc7 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803cae:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803cb5:	00 00 00 
  803cb8:	48 8b 00             	mov    (%rax),%rax
  803cbb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803cc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cc5:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803cc7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ccc:	74 19                	je     803ce7 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803cce:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803cd5:	00 00 00 
  803cd8:	48 8b 00             	mov    (%rax),%rax
  803cdb:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ce1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce5:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803ce7:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803cee:	00 00 00 
  803cf1:	48 8b 00             	mov    (%rax),%rax
  803cf4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803cfa:	c9                   	leaveq 
  803cfb:	c3                   	retq   

0000000000803cfc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803cfc:	55                   	push   %rbp
  803cfd:	48 89 e5             	mov    %rsp,%rbp
  803d00:	48 83 ec 30          	sub    $0x30,%rsp
  803d04:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d07:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d0a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d0e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803d11:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803d18:	e9 96 00 00 00       	jmpq   803db3 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803d1d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d22:	74 20                	je     803d44 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803d24:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d27:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d2a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d31:	89 c7                	mov    %eax,%edi
  803d33:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  803d3a:	00 00 00 
  803d3d:	ff d0                	callq  *%rax
  803d3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d42:	eb 2d                	jmp    803d71 <ipc_send+0x75>
		else if(pg==NULL)
  803d44:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d49:	75 26                	jne    803d71 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803d4b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d4e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d51:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d56:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d5d:	00 00 00 
  803d60:	89 c7                	mov    %eax,%edi
  803d62:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  803d69:	00 00 00 
  803d6c:	ff d0                	callq  *%rax
  803d6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803d71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d75:	79 30                	jns    803da7 <ipc_send+0xab>
  803d77:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d7b:	74 2a                	je     803da7 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803d7d:	48 ba 67 45 80 00 00 	movabs $0x804567,%rdx
  803d84:	00 00 00 
  803d87:	be 40 00 00 00       	mov    $0x40,%esi
  803d8c:	48 bf 7f 45 80 00 00 	movabs $0x80457f,%rdi
  803d93:	00 00 00 
  803d96:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9b:	48 b9 3c 04 80 00 00 	movabs $0x80043c,%rcx
  803da2:	00 00 00 
  803da5:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803da7:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  803dae:	00 00 00 
  803db1:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803db3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db7:	0f 85 60 ff ff ff    	jne    803d1d <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803dbd:	c9                   	leaveq 
  803dbe:	c3                   	retq   

0000000000803dbf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803dbf:	55                   	push   %rbp
  803dc0:	48 89 e5             	mov    %rsp,%rbp
  803dc3:	48 83 ec 18          	sub    $0x18,%rsp
  803dc7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803dca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dd1:	eb 5e                	jmp    803e31 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803dd3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803dda:	00 00 00 
  803ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de0:	48 63 d0             	movslq %eax,%rdx
  803de3:	48 89 d0             	mov    %rdx,%rax
  803de6:	48 c1 e0 03          	shl    $0x3,%rax
  803dea:	48 01 d0             	add    %rdx,%rax
  803ded:	48 c1 e0 05          	shl    $0x5,%rax
  803df1:	48 01 c8             	add    %rcx,%rax
  803df4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803dfa:	8b 00                	mov    (%rax),%eax
  803dfc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dff:	75 2c                	jne    803e2d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803e01:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e08:	00 00 00 
  803e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0e:	48 63 d0             	movslq %eax,%rdx
  803e11:	48 89 d0             	mov    %rdx,%rax
  803e14:	48 c1 e0 03          	shl    $0x3,%rax
  803e18:	48 01 d0             	add    %rdx,%rax
  803e1b:	48 c1 e0 05          	shl    $0x5,%rax
  803e1f:	48 01 c8             	add    %rcx,%rax
  803e22:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e28:	8b 40 08             	mov    0x8(%rax),%eax
  803e2b:	eb 12                	jmp    803e3f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803e2d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e31:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e38:	7e 99                	jle    803dd3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e3f:	c9                   	leaveq 
  803e40:	c3                   	retq   
  803e41:	00 00                	add    %al,(%rax)
	...

0000000000803e44 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e44:	55                   	push   %rbp
  803e45:	48 89 e5             	mov    %rsp,%rbp
  803e48:	48 83 ec 18          	sub    $0x18,%rsp
  803e4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e54:	48 89 c2             	mov    %rax,%rdx
  803e57:	48 c1 ea 15          	shr    $0x15,%rdx
  803e5b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e62:	01 00 00 
  803e65:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e69:	83 e0 01             	and    $0x1,%eax
  803e6c:	48 85 c0             	test   %rax,%rax
  803e6f:	75 07                	jne    803e78 <pageref+0x34>
		return 0;
  803e71:	b8 00 00 00 00       	mov    $0x0,%eax
  803e76:	eb 53                	jmp    803ecb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e7c:	48 89 c2             	mov    %rax,%rdx
  803e7f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803e83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e8a:	01 00 00 
  803e8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e91:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e99:	83 e0 01             	and    $0x1,%eax
  803e9c:	48 85 c0             	test   %rax,%rax
  803e9f:	75 07                	jne    803ea8 <pageref+0x64>
		return 0;
  803ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea6:	eb 23                	jmp    803ecb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eac:	48 89 c2             	mov    %rax,%rdx
  803eaf:	48 c1 ea 0c          	shr    $0xc,%rdx
  803eb3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803eba:	00 00 00 
  803ebd:	48 c1 e2 04          	shl    $0x4,%rdx
  803ec1:	48 01 d0             	add    %rdx,%rax
  803ec4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803ec8:	0f b7 c0             	movzwl %ax,%eax
}
  803ecb:	c9                   	leaveq 
  803ecc:	c3                   	retq   
