
obj/user/faultevilhandler.debug:     file format elf64-x86-64


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
  80003c:	e8 53 00 00 00       	callq  800094 <libmain>
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
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800053:	ba 07 00 00 00       	mov    $0x7,%edx
  800058:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80005d:	bf 00 00 00 00       	mov    $0x0,%edi
  800062:	48 b8 40 03 80 00 00 	movabs $0x800340,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  80006e:	be 20 00 10 f0       	mov    $0xf0100020,%esi
  800073:	bf 00 00 00 00       	mov    $0x0,%edi
  800078:	48 b8 ca 04 80 00 00 	movabs $0x8004ca,%rax
  80007f:	00 00 00 
  800082:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  800084:	b8 00 00 00 00       	mov    $0x0,%eax
  800089:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80008f:	c9                   	leaveq 
  800090:	c3                   	retq   
  800091:	00 00                	add    %al,(%rax)
	...

0000000000800094 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800094:	55                   	push   %rbp
  800095:	48 89 e5             	mov    %rsp,%rbp
  800098:	48 83 ec 10          	sub    $0x10,%rsp
  80009c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80009f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000a3:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8000aa:	00 00 00 
  8000ad:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8000b4:	48 b8 c4 02 80 00 00 	movabs $0x8002c4,%rax
  8000bb:	00 00 00 
  8000be:	ff d0                	callq  *%rax
  8000c0:	48 98                	cltq   
  8000c2:	48 89 c2             	mov    %rax,%rdx
  8000c5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8000cb:	48 89 d0             	mov    %rdx,%rax
  8000ce:	48 c1 e0 03          	shl    $0x3,%rax
  8000d2:	48 01 d0             	add    %rdx,%rax
  8000d5:	48 c1 e0 05          	shl    $0x5,%rax
  8000d9:	48 89 c2             	mov    %rax,%rdx
  8000dc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000e3:	00 00 00 
  8000e6:	48 01 c2             	add    %rax,%rdx
  8000e9:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8000f0:	00 00 00 
  8000f3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000fa:	7e 14                	jle    800110 <libmain+0x7c>
		binaryname = argv[0];
  8000fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800100:	48 8b 10             	mov    (%rax),%rdx
  800103:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80010a:	00 00 00 
  80010d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800110:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800114:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800117:	48 89 d6             	mov    %rdx,%rsi
  80011a:	89 c7                	mov    %eax,%edi
  80011c:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800128:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  80012f:	00 00 00 
  800132:	ff d0                	callq  *%rax
}
  800134:	c9                   	leaveq 
  800135:	c3                   	retq   
	...

0000000000800138 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800138:	55                   	push   %rbp
  800139:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80013c:	48 b8 c1 09 80 00 00 	movabs $0x8009c1,%rax
  800143:	00 00 00 
  800146:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800148:	bf 00 00 00 00       	mov    $0x0,%edi
  80014d:	48 b8 80 02 80 00 00 	movabs $0x800280,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
}
  800159:	5d                   	pop    %rbp
  80015a:	c3                   	retq   
	...

000000000080015c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80015c:	55                   	push   %rbp
  80015d:	48 89 e5             	mov    %rsp,%rbp
  800160:	53                   	push   %rbx
  800161:	48 83 ec 58          	sub    $0x58,%rsp
  800165:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800168:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80016b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80016f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800173:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800177:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80017b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80017e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  800181:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800185:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800189:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80018d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800191:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800195:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800198:	4c 89 c3             	mov    %r8,%rbx
  80019b:	cd 30                	int    $0x30
  80019d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8001a1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8001a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8001ad:	74 3e                	je     8001ed <syscall+0x91>
  8001af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8001b4:	7e 37                	jle    8001ed <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8001ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001bd:	49 89 d0             	mov    %rdx,%r8
  8001c0:	89 c1                	mov    %eax,%ecx
  8001c2:	48 ba 0a 3c 80 00 00 	movabs $0x803c0a,%rdx
  8001c9:	00 00 00 
  8001cc:	be 23 00 00 00       	mov    $0x23,%esi
  8001d1:	48 bf 27 3c 80 00 00 	movabs $0x803c27,%rdi
  8001d8:	00 00 00 
  8001db:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e0:	49 b9 10 24 80 00 00 	movabs $0x802410,%r9
  8001e7:	00 00 00 
  8001ea:	41 ff d1             	callq  *%r9

	return ret;
  8001ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001f1:	48 83 c4 58          	add    $0x58,%rsp
  8001f5:	5b                   	pop    %rbx
  8001f6:	5d                   	pop    %rbp
  8001f7:	c3                   	retq   

00000000008001f8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001f8:	55                   	push   %rbp
  8001f9:	48 89 e5             	mov    %rsp,%rbp
  8001fc:	48 83 ec 20          	sub    $0x20,%rsp
  800200:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800204:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80020c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800210:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800217:	00 
  800218:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80021e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800224:	48 89 d1             	mov    %rdx,%rcx
  800227:	48 89 c2             	mov    %rax,%rdx
  80022a:	be 00 00 00 00       	mov    $0x0,%esi
  80022f:	bf 00 00 00 00       	mov    $0x0,%edi
  800234:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	callq  *%rax
}
  800240:	c9                   	leaveq 
  800241:	c3                   	retq   

0000000000800242 <sys_cgetc>:

int
sys_cgetc(void)
{
  800242:	55                   	push   %rbp
  800243:	48 89 e5             	mov    %rsp,%rbp
  800246:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80024a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800251:	00 
  800252:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800258:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80025e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800263:	ba 00 00 00 00       	mov    $0x0,%edx
  800268:	be 00 00 00 00       	mov    $0x0,%esi
  80026d:	bf 01 00 00 00       	mov    $0x1,%edi
  800272:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  800279:	00 00 00 
  80027c:	ff d0                	callq  *%rax
}
  80027e:	c9                   	leaveq 
  80027f:	c3                   	retq   

0000000000800280 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800280:	55                   	push   %rbp
  800281:	48 89 e5             	mov    %rsp,%rbp
  800284:	48 83 ec 20          	sub    $0x20,%rsp
  800288:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80028b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80028e:	48 98                	cltq   
  800290:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800297:	00 
  800298:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80029e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a9:	48 89 c2             	mov    %rax,%rdx
  8002ac:	be 01 00 00 00       	mov    $0x1,%esi
  8002b1:	bf 03 00 00 00       	mov    $0x3,%edi
  8002b6:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
}
  8002c2:	c9                   	leaveq 
  8002c3:	c3                   	retq   

00000000008002c4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8002c4:	55                   	push   %rbp
  8002c5:	48 89 e5             	mov    %rsp,%rbp
  8002c8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d3:	00 
  8002d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ea:	be 00 00 00 00       	mov    $0x0,%esi
  8002ef:	bf 02 00 00 00       	mov    $0x2,%edi
  8002f4:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  8002fb:	00 00 00 
  8002fe:	ff d0                	callq  *%rax
}
  800300:	c9                   	leaveq 
  800301:	c3                   	retq   

0000000000800302 <sys_yield>:

void
sys_yield(void)
{
  800302:	55                   	push   %rbp
  800303:	48 89 e5             	mov    %rsp,%rbp
  800306:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80030a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800311:	00 
  800312:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800318:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80031e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800323:	ba 00 00 00 00       	mov    $0x0,%edx
  800328:	be 00 00 00 00       	mov    $0x0,%esi
  80032d:	bf 0b 00 00 00       	mov    $0xb,%edi
  800332:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
}
  80033e:	c9                   	leaveq 
  80033f:	c3                   	retq   

0000000000800340 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800340:	55                   	push   %rbp
  800341:	48 89 e5             	mov    %rsp,%rbp
  800344:	48 83 ec 20          	sub    $0x20,%rsp
  800348:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80034f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800352:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800355:	48 63 c8             	movslq %eax,%rcx
  800358:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	48 98                	cltq   
  800361:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800368:	00 
  800369:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80036f:	49 89 c8             	mov    %rcx,%r8
  800372:	48 89 d1             	mov    %rdx,%rcx
  800375:	48 89 c2             	mov    %rax,%rdx
  800378:	be 01 00 00 00       	mov    $0x1,%esi
  80037d:	bf 04 00 00 00       	mov    $0x4,%edi
  800382:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  800389:	00 00 00 
  80038c:	ff d0                	callq  *%rax
}
  80038e:	c9                   	leaveq 
  80038f:	c3                   	retq   

0000000000800390 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800390:	55                   	push   %rbp
  800391:	48 89 e5             	mov    %rsp,%rbp
  800394:	48 83 ec 30          	sub    $0x30,%rsp
  800398:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80039f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8003a2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003a6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8003aa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003ad:	48 63 c8             	movslq %eax,%rcx
  8003b0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8003b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003b7:	48 63 f0             	movslq %eax,%rsi
  8003ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c1:	48 98                	cltq   
  8003c3:	48 89 0c 24          	mov    %rcx,(%rsp)
  8003c7:	49 89 f9             	mov    %rdi,%r9
  8003ca:	49 89 f0             	mov    %rsi,%r8
  8003cd:	48 89 d1             	mov    %rdx,%rcx
  8003d0:	48 89 c2             	mov    %rax,%rdx
  8003d3:	be 01 00 00 00       	mov    $0x1,%esi
  8003d8:	bf 05 00 00 00       	mov    $0x5,%edi
  8003dd:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  8003e4:	00 00 00 
  8003e7:	ff d0                	callq  *%rax
}
  8003e9:	c9                   	leaveq 
  8003ea:	c3                   	retq   

00000000008003eb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
  8003ef:	48 83 ec 20          	sub    $0x20,%rsp
  8003f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800401:	48 98                	cltq   
  800403:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80040a:	00 
  80040b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800411:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800417:	48 89 d1             	mov    %rdx,%rcx
  80041a:	48 89 c2             	mov    %rax,%rdx
  80041d:	be 01 00 00 00       	mov    $0x1,%esi
  800422:	bf 06 00 00 00       	mov    $0x6,%edi
  800427:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
}
  800433:	c9                   	leaveq 
  800434:	c3                   	retq   

0000000000800435 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800435:	55                   	push   %rbp
  800436:	48 89 e5             	mov    %rsp,%rbp
  800439:	48 83 ec 20          	sub    $0x20,%rsp
  80043d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800440:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800443:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800446:	48 63 d0             	movslq %eax,%rdx
  800449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80044c:	48 98                	cltq   
  80044e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800455:	00 
  800456:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80045c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800462:	48 89 d1             	mov    %rdx,%rcx
  800465:	48 89 c2             	mov    %rax,%rdx
  800468:	be 01 00 00 00       	mov    $0x1,%esi
  80046d:	bf 08 00 00 00       	mov    $0x8,%edi
  800472:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
}
  80047e:	c9                   	leaveq 
  80047f:	c3                   	retq   

0000000000800480 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800480:	55                   	push   %rbp
  800481:	48 89 e5             	mov    %rsp,%rbp
  800484:	48 83 ec 20          	sub    $0x20,%rsp
  800488:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80048b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80048f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800496:	48 98                	cltq   
  800498:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80049f:	00 
  8004a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004ac:	48 89 d1             	mov    %rdx,%rcx
  8004af:	48 89 c2             	mov    %rax,%rdx
  8004b2:	be 01 00 00 00       	mov    $0x1,%esi
  8004b7:	bf 09 00 00 00       	mov    $0x9,%edi
  8004bc:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  8004c3:	00 00 00 
  8004c6:	ff d0                	callq  *%rax
}
  8004c8:	c9                   	leaveq 
  8004c9:	c3                   	retq   

00000000008004ca <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8004ca:	55                   	push   %rbp
  8004cb:	48 89 e5             	mov    %rsp,%rbp
  8004ce:	48 83 ec 20          	sub    $0x20,%rsp
  8004d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e0:	48 98                	cltq   
  8004e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004e9:	00 
  8004ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004f6:	48 89 d1             	mov    %rdx,%rcx
  8004f9:	48 89 c2             	mov    %rax,%rdx
  8004fc:	be 01 00 00 00       	mov    $0x1,%esi
  800501:	bf 0a 00 00 00       	mov    $0xa,%edi
  800506:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  80050d:	00 00 00 
  800510:	ff d0                	callq  *%rax
}
  800512:	c9                   	leaveq 
  800513:	c3                   	retq   

0000000000800514 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800514:	55                   	push   %rbp
  800515:	48 89 e5             	mov    %rsp,%rbp
  800518:	48 83 ec 30          	sub    $0x30,%rsp
  80051c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80051f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800523:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800527:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80052a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80052d:	48 63 f0             	movslq %eax,%rsi
  800530:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800537:	48 98                	cltq   
  800539:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80053d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800544:	00 
  800545:	49 89 f1             	mov    %rsi,%r9
  800548:	49 89 c8             	mov    %rcx,%r8
  80054b:	48 89 d1             	mov    %rdx,%rcx
  80054e:	48 89 c2             	mov    %rax,%rdx
  800551:	be 00 00 00 00       	mov    $0x0,%esi
  800556:	bf 0c 00 00 00       	mov    $0xc,%edi
  80055b:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  800562:	00 00 00 
  800565:	ff d0                	callq  *%rax
}
  800567:	c9                   	leaveq 
  800568:	c3                   	retq   

0000000000800569 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800569:	55                   	push   %rbp
  80056a:	48 89 e5             	mov    %rsp,%rbp
  80056d:	48 83 ec 20          	sub    $0x20,%rsp
  800571:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800579:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800580:	00 
  800581:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800587:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80058d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800592:	48 89 c2             	mov    %rax,%rdx
  800595:	be 01 00 00 00       	mov    $0x1,%esi
  80059a:	bf 0d 00 00 00       	mov    $0xd,%edi
  80059f:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  8005a6:	00 00 00 
  8005a9:	ff d0                	callq  *%rax
}
  8005ab:	c9                   	leaveq 
  8005ac:	c3                   	retq   

00000000008005ad <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8005ad:	55                   	push   %rbp
  8005ae:	48 89 e5             	mov    %rsp,%rbp
  8005b1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8005b5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005bc:	00 
  8005bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d3:	be 00 00 00 00       	mov    $0x0,%esi
  8005d8:	bf 0e 00 00 00       	mov    $0xe,%edi
  8005dd:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  8005e4:	00 00 00 
  8005e7:	ff d0                	callq  *%rax
}
  8005e9:	c9                   	leaveq 
  8005ea:	c3                   	retq   

00000000008005eb <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  8005eb:	55                   	push   %rbp
  8005ec:	48 89 e5             	mov    %rsp,%rbp
  8005ef:	48 83 ec 20          	sub    $0x20,%rsp
  8005f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8005fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800603:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80060a:	00 
  80060b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800611:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800617:	48 89 d1             	mov    %rdx,%rcx
  80061a:	48 89 c2             	mov    %rax,%rdx
  80061d:	be 00 00 00 00       	mov    $0x0,%esi
  800622:	bf 0f 00 00 00       	mov    $0xf,%edi
  800627:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  80062e:	00 00 00 
  800631:	ff d0                	callq  *%rax
}
  800633:	c9                   	leaveq 
  800634:	c3                   	retq   

0000000000800635 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  800635:	55                   	push   %rbp
  800636:	48 89 e5             	mov    %rsp,%rbp
  800639:	48 83 ec 20          	sub    $0x20,%rsp
  80063d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800641:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  800645:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800649:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800654:	00 
  800655:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80065b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800661:	48 89 d1             	mov    %rdx,%rcx
  800664:	48 89 c2             	mov    %rax,%rdx
  800667:	be 00 00 00 00       	mov    $0x0,%esi
  80066c:	bf 10 00 00 00       	mov    $0x10,%edi
  800671:	48 b8 5c 01 80 00 00 	movabs $0x80015c,%rax
  800678:	00 00 00 
  80067b:	ff d0                	callq  *%rax
}
  80067d:	c9                   	leaveq 
  80067e:	c3                   	retq   
	...

0000000000800680 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800680:	55                   	push   %rbp
  800681:	48 89 e5             	mov    %rsp,%rbp
  800684:	48 83 ec 08          	sub    $0x8,%rsp
  800688:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80068c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800690:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800697:	ff ff ff 
  80069a:	48 01 d0             	add    %rdx,%rax
  80069d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8006a1:	c9                   	leaveq 
  8006a2:	c3                   	retq   

00000000008006a3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8006a3:	55                   	push   %rbp
  8006a4:	48 89 e5             	mov    %rsp,%rbp
  8006a7:	48 83 ec 08          	sub    $0x8,%rsp
  8006ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8006af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006b3:	48 89 c7             	mov    %rax,%rdi
  8006b6:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  8006bd:	00 00 00 
  8006c0:	ff d0                	callq  *%rax
  8006c2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006c8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006cc:	c9                   	leaveq 
  8006cd:	c3                   	retq   

00000000008006ce <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8006ce:	55                   	push   %rbp
  8006cf:	48 89 e5             	mov    %rsp,%rbp
  8006d2:	48 83 ec 18          	sub    $0x18,%rsp
  8006d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8006e1:	eb 6b                	jmp    80074e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8006e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006e6:	48 98                	cltq   
  8006e8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006ee:	48 c1 e0 0c          	shl    $0xc,%rax
  8006f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006fa:	48 89 c2             	mov    %rax,%rdx
  8006fd:	48 c1 ea 15          	shr    $0x15,%rdx
  800701:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800708:	01 00 00 
  80070b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80070f:	83 e0 01             	and    $0x1,%eax
  800712:	48 85 c0             	test   %rax,%rax
  800715:	74 21                	je     800738 <fd_alloc+0x6a>
  800717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071b:	48 89 c2             	mov    %rax,%rdx
  80071e:	48 c1 ea 0c          	shr    $0xc,%rdx
  800722:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800729:	01 00 00 
  80072c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800730:	83 e0 01             	and    $0x1,%eax
  800733:	48 85 c0             	test   %rax,%rax
  800736:	75 12                	jne    80074a <fd_alloc+0x7c>
			*fd_store = fd;
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800740:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800743:	b8 00 00 00 00       	mov    $0x0,%eax
  800748:	eb 1a                	jmp    800764 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80074a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80074e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800752:	7e 8f                	jle    8006e3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80075f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800764:	c9                   	leaveq 
  800765:	c3                   	retq   

0000000000800766 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800766:	55                   	push   %rbp
  800767:	48 89 e5             	mov    %rsp,%rbp
  80076a:	48 83 ec 20          	sub    $0x20,%rsp
  80076e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800771:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800775:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800779:	78 06                	js     800781 <fd_lookup+0x1b>
  80077b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80077f:	7e 07                	jle    800788 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800781:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800786:	eb 6c                	jmp    8007f4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800788:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80078b:	48 98                	cltq   
  80078d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800793:	48 c1 e0 0c          	shl    $0xc,%rax
  800797:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80079b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80079f:	48 89 c2             	mov    %rax,%rdx
  8007a2:	48 c1 ea 15          	shr    $0x15,%rdx
  8007a6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8007ad:	01 00 00 
  8007b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007b4:	83 e0 01             	and    $0x1,%eax
  8007b7:	48 85 c0             	test   %rax,%rax
  8007ba:	74 21                	je     8007dd <fd_lookup+0x77>
  8007bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007c0:	48 89 c2             	mov    %rax,%rdx
  8007c3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8007c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007ce:	01 00 00 
  8007d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d5:	83 e0 01             	and    $0x1,%eax
  8007d8:	48 85 c0             	test   %rax,%rax
  8007db:	75 07                	jne    8007e4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e2:	eb 10                	jmp    8007f4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8007e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007ec:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007f4:	c9                   	leaveq 
  8007f5:	c3                   	retq   

00000000008007f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007f6:	55                   	push   %rbp
  8007f7:	48 89 e5             	mov    %rsp,%rbp
  8007fa:	48 83 ec 30          	sub    $0x30,%rsp
  8007fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800802:	89 f0                	mov    %esi,%eax
  800804:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80080b:	48 89 c7             	mov    %rax,%rdi
  80080e:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800815:	00 00 00 
  800818:	ff d0                	callq  *%rax
  80081a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80081e:	48 89 d6             	mov    %rdx,%rsi
  800821:	89 c7                	mov    %eax,%edi
  800823:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
  80082f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800832:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800836:	78 0a                	js     800842 <fd_close+0x4c>
	    || fd != fd2)
  800838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80083c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800840:	74 12                	je     800854 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800842:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800846:	74 05                	je     80084d <fd_close+0x57>
  800848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80084b:	eb 05                	jmp    800852 <fd_close+0x5c>
  80084d:	b8 00 00 00 00       	mov    $0x0,%eax
  800852:	eb 69                	jmp    8008bd <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800858:	8b 00                	mov    (%rax),%eax
  80085a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80085e:	48 89 d6             	mov    %rdx,%rsi
  800861:	89 c7                	mov    %eax,%edi
  800863:	48 b8 bf 08 80 00 00 	movabs $0x8008bf,%rax
  80086a:	00 00 00 
  80086d:	ff d0                	callq  *%rax
  80086f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800872:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800876:	78 2a                	js     8008a2 <fd_close+0xac>
		if (dev->dev_close)
  800878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087c:	48 8b 40 20          	mov    0x20(%rax),%rax
  800880:	48 85 c0             	test   %rax,%rax
  800883:	74 16                	je     80089b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800889:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80088d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800891:	48 89 c7             	mov    %rax,%rdi
  800894:	ff d2                	callq  *%rdx
  800896:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800899:	eb 07                	jmp    8008a2 <fd_close+0xac>
		else
			r = 0;
  80089b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8008a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a6:	48 89 c6             	mov    %rax,%rsi
  8008a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ae:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  8008b5:	00 00 00 
  8008b8:	ff d0                	callq  *%rax
	return r;
  8008ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8008bd:	c9                   	leaveq 
  8008be:	c3                   	retq   

00000000008008bf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008bf:	55                   	push   %rbp
  8008c0:	48 89 e5             	mov    %rsp,%rbp
  8008c3:	48 83 ec 20          	sub    $0x20,%rsp
  8008c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8008ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8008ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008d5:	eb 41                	jmp    800918 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8008d7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008de:	00 00 00 
  8008e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008e4:	48 63 d2             	movslq %edx,%rdx
  8008e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008f0:	75 22                	jne    800914 <dev_lookup+0x55>
			*dev = devtab[i];
  8008f2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008f9:	00 00 00 
  8008fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008ff:	48 63 d2             	movslq %edx,%rdx
  800902:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800906:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80090a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	eb 60                	jmp    800974 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800914:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800918:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80091f:	00 00 00 
  800922:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800925:	48 63 d2             	movslq %edx,%rdx
  800928:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80092c:	48 85 c0             	test   %rax,%rax
  80092f:	75 a6                	jne    8008d7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800931:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800938:	00 00 00 
  80093b:	48 8b 00             	mov    (%rax),%rax
  80093e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800944:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800947:	89 c6                	mov    %eax,%esi
  800949:	48 bf 38 3c 80 00 00 	movabs $0x803c38,%rdi
  800950:	00 00 00 
  800953:	b8 00 00 00 00       	mov    $0x0,%eax
  800958:	48 b9 4b 26 80 00 00 	movabs $0x80264b,%rcx
  80095f:	00 00 00 
  800962:	ff d1                	callq  *%rcx
	*dev = 0;
  800964:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800968:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80096f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800974:	c9                   	leaveq 
  800975:	c3                   	retq   

0000000000800976 <close>:

int
close(int fdnum)
{
  800976:	55                   	push   %rbp
  800977:	48 89 e5             	mov    %rsp,%rbp
  80097a:	48 83 ec 20          	sub    $0x20,%rsp
  80097e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800981:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800985:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800988:	48 89 d6             	mov    %rdx,%rsi
  80098b:	89 c7                	mov    %eax,%edi
  80098d:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  800994:	00 00 00 
  800997:	ff d0                	callq  *%rax
  800999:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80099c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009a0:	79 05                	jns    8009a7 <close+0x31>
		return r;
  8009a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a5:	eb 18                	jmp    8009bf <close+0x49>
	else
		return fd_close(fd, 1);
  8009a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009ab:	be 01 00 00 00       	mov    $0x1,%esi
  8009b0:	48 89 c7             	mov    %rax,%rdi
  8009b3:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  8009ba:	00 00 00 
  8009bd:	ff d0                	callq  *%rax
}
  8009bf:	c9                   	leaveq 
  8009c0:	c3                   	retq   

00000000008009c1 <close_all>:

void
close_all(void)
{
  8009c1:	55                   	push   %rbp
  8009c2:	48 89 e5             	mov    %rsp,%rbp
  8009c5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8009c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8009d0:	eb 15                	jmp    8009e7 <close_all+0x26>
		close(i);
  8009d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009d5:	89 c7                	mov    %eax,%edi
  8009d7:	48 b8 76 09 80 00 00 	movabs $0x800976,%rax
  8009de:	00 00 00 
  8009e1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8009e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8009e7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8009eb:	7e e5                	jle    8009d2 <close_all+0x11>
		close(i);
}
  8009ed:	c9                   	leaveq 
  8009ee:	c3                   	retq   

00000000008009ef <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009ef:	55                   	push   %rbp
  8009f0:	48 89 e5             	mov    %rsp,%rbp
  8009f3:	48 83 ec 40          	sub    $0x40,%rsp
  8009f7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009fa:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009fd:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800a01:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800a04:	48 89 d6             	mov    %rdx,%rsi
  800a07:	89 c7                	mov    %eax,%edi
  800a09:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  800a10:	00 00 00 
  800a13:	ff d0                	callq  *%rax
  800a15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a1c:	79 08                	jns    800a26 <dup+0x37>
		return r;
  800a1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a21:	e9 70 01 00 00       	jmpq   800b96 <dup+0x1a7>
	close(newfdnum);
  800a26:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a29:	89 c7                	mov    %eax,%edi
  800a2b:	48 b8 76 09 80 00 00 	movabs $0x800976,%rax
  800a32:	00 00 00 
  800a35:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800a37:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a3a:	48 98                	cltq   
  800a3c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a42:	48 c1 e0 0c          	shl    $0xc,%rax
  800a46:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4e:	48 89 c7             	mov    %rax,%rdi
  800a51:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  800a58:	00 00 00 
  800a5b:	ff d0                	callq  *%rax
  800a5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a65:	48 89 c7             	mov    %rax,%rdi
  800a68:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  800a6f:	00 00 00 
  800a72:	ff d0                	callq  *%rax
  800a74:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 89 c2             	mov    %rax,%rdx
  800a7f:	48 c1 ea 15          	shr    $0x15,%rdx
  800a83:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a8a:	01 00 00 
  800a8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a91:	83 e0 01             	and    $0x1,%eax
  800a94:	84 c0                	test   %al,%al
  800a96:	74 71                	je     800b09 <dup+0x11a>
  800a98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9c:	48 89 c2             	mov    %rax,%rdx
  800a9f:	48 c1 ea 0c          	shr    $0xc,%rdx
  800aa3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800aaa:	01 00 00 
  800aad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ab1:	83 e0 01             	and    $0x1,%eax
  800ab4:	84 c0                	test   %al,%al
  800ab6:	74 51                	je     800b09 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abc:	48 89 c2             	mov    %rax,%rdx
  800abf:	48 c1 ea 0c          	shr    $0xc,%rdx
  800ac3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800aca:	01 00 00 
  800acd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ad1:	89 c1                	mov    %eax,%ecx
  800ad3:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800ad9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae1:	41 89 c8             	mov    %ecx,%r8d
  800ae4:	48 89 d1             	mov    %rdx,%rcx
  800ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aec:	48 89 c6             	mov    %rax,%rsi
  800aef:	bf 00 00 00 00       	mov    $0x0,%edi
  800af4:	48 b8 90 03 80 00 00 	movabs $0x800390,%rax
  800afb:	00 00 00 
  800afe:	ff d0                	callq  *%rax
  800b00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b07:	78 56                	js     800b5f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800b09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b0d:	48 89 c2             	mov    %rax,%rdx
  800b10:	48 c1 ea 0c          	shr    $0xc,%rdx
  800b14:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b1b:	01 00 00 
  800b1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b22:	89 c1                	mov    %eax,%ecx
  800b24:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800b2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b32:	41 89 c8             	mov    %ecx,%r8d
  800b35:	48 89 d1             	mov    %rdx,%rcx
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3d:	48 89 c6             	mov    %rax,%rsi
  800b40:	bf 00 00 00 00       	mov    $0x0,%edi
  800b45:	48 b8 90 03 80 00 00 	movabs $0x800390,%rax
  800b4c:	00 00 00 
  800b4f:	ff d0                	callq  *%rax
  800b51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b58:	78 08                	js     800b62 <dup+0x173>
		goto err;

	return newfdnum;
  800b5a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b5d:	eb 37                	jmp    800b96 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  800b5f:	90                   	nop
  800b60:	eb 01                	jmp    800b63 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  800b62:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800b63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b67:	48 89 c6             	mov    %rax,%rsi
  800b6a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6f:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  800b76:	00 00 00 
  800b79:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b7f:	48 89 c6             	mov    %rax,%rsi
  800b82:	bf 00 00 00 00       	mov    $0x0,%edi
  800b87:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  800b8e:	00 00 00 
  800b91:	ff d0                	callq  *%rax
	return r;
  800b93:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b96:	c9                   	leaveq 
  800b97:	c3                   	retq   

0000000000800b98 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b98:	55                   	push   %rbp
  800b99:	48 89 e5             	mov    %rsp,%rbp
  800b9c:	48 83 ec 40          	sub    $0x40,%rsp
  800ba0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ba3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800ba7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800baf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bb2:	48 89 d6             	mov    %rdx,%rsi
  800bb5:	89 c7                	mov    %eax,%edi
  800bb7:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  800bbe:	00 00 00 
  800bc1:	ff d0                	callq  *%rax
  800bc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bca:	78 24                	js     800bf0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd0:	8b 00                	mov    (%rax),%eax
  800bd2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800bd6:	48 89 d6             	mov    %rdx,%rsi
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	48 b8 bf 08 80 00 00 	movabs $0x8008bf,%rax
  800be2:	00 00 00 
  800be5:	ff d0                	callq  *%rax
  800be7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bee:	79 05                	jns    800bf5 <read+0x5d>
		return r;
  800bf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bf3:	eb 7a                	jmp    800c6f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf9:	8b 40 08             	mov    0x8(%rax),%eax
  800bfc:	83 e0 03             	and    $0x3,%eax
  800bff:	83 f8 01             	cmp    $0x1,%eax
  800c02:	75 3a                	jne    800c3e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c04:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800c0b:	00 00 00 
  800c0e:	48 8b 00             	mov    (%rax),%rax
  800c11:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c17:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c1a:	89 c6                	mov    %eax,%esi
  800c1c:	48 bf 57 3c 80 00 00 	movabs $0x803c57,%rdi
  800c23:	00 00 00 
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2b:	48 b9 4b 26 80 00 00 	movabs $0x80264b,%rcx
  800c32:	00 00 00 
  800c35:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c3c:	eb 31                	jmp    800c6f <read+0xd7>
	}
	if (!dev->dev_read)
  800c3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c42:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c46:	48 85 c0             	test   %rax,%rax
  800c49:	75 07                	jne    800c52 <read+0xba>
		return -E_NOT_SUPP;
  800c4b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c50:	eb 1d                	jmp    800c6f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  800c52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c56:	4c 8b 40 10          	mov    0x10(%rax),%r8
  800c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c5e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c62:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800c66:	48 89 ce             	mov    %rcx,%rsi
  800c69:	48 89 c7             	mov    %rax,%rdi
  800c6c:	41 ff d0             	callq  *%r8
}
  800c6f:	c9                   	leaveq 
  800c70:	c3                   	retq   

0000000000800c71 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c71:	55                   	push   %rbp
  800c72:	48 89 e5             	mov    %rsp,%rbp
  800c75:	48 83 ec 30          	sub    $0x30,%rsp
  800c79:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c8b:	eb 46                	jmp    800cd3 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c90:	48 98                	cltq   
  800c92:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c96:	48 29 c2             	sub    %rax,%rdx
  800c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c9c:	48 98                	cltq   
  800c9e:	48 89 c1             	mov    %rax,%rcx
  800ca1:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  800ca5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ca8:	48 89 ce             	mov    %rcx,%rsi
  800cab:	89 c7                	mov    %eax,%edi
  800cad:	48 b8 98 0b 80 00 00 	movabs $0x800b98,%rax
  800cb4:	00 00 00 
  800cb7:	ff d0                	callq  *%rax
  800cb9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800cbc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800cc0:	79 05                	jns    800cc7 <readn+0x56>
			return m;
  800cc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cc5:	eb 1d                	jmp    800ce4 <readn+0x73>
		if (m == 0)
  800cc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ccb:	74 13                	je     800ce0 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ccd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cd0:	01 45 fc             	add    %eax,-0x4(%rbp)
  800cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cd6:	48 98                	cltq   
  800cd8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800cdc:	72 af                	jb     800c8d <readn+0x1c>
  800cde:	eb 01                	jmp    800ce1 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  800ce0:	90                   	nop
	}
	return tot;
  800ce1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ce4:	c9                   	leaveq 
  800ce5:	c3                   	retq   

0000000000800ce6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800ce6:	55                   	push   %rbp
  800ce7:	48 89 e5             	mov    %rsp,%rbp
  800cea:	48 83 ec 40          	sub    $0x40,%rsp
  800cee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cf1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800cf5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cfd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d00:	48 89 d6             	mov    %rdx,%rsi
  800d03:	89 c7                	mov    %eax,%edi
  800d05:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	callq  *%rax
  800d11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d18:	78 24                	js     800d3e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1e:	8b 00                	mov    (%rax),%eax
  800d20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d24:	48 89 d6             	mov    %rdx,%rsi
  800d27:	89 c7                	mov    %eax,%edi
  800d29:	48 b8 bf 08 80 00 00 	movabs $0x8008bf,%rax
  800d30:	00 00 00 
  800d33:	ff d0                	callq  *%rax
  800d35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d3c:	79 05                	jns    800d43 <write+0x5d>
		return r;
  800d3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d41:	eb 79                	jmp    800dbc <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d47:	8b 40 08             	mov    0x8(%rax),%eax
  800d4a:	83 e0 03             	and    $0x3,%eax
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	75 3a                	jne    800d8b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d51:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800d58:	00 00 00 
  800d5b:	48 8b 00             	mov    (%rax),%rax
  800d5e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d64:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d67:	89 c6                	mov    %eax,%esi
  800d69:	48 bf 73 3c 80 00 00 	movabs $0x803c73,%rdi
  800d70:	00 00 00 
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
  800d78:	48 b9 4b 26 80 00 00 	movabs $0x80264b,%rcx
  800d7f:	00 00 00 
  800d82:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d89:	eb 31                	jmp    800dbc <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8f:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d93:	48 85 c0             	test   %rax,%rax
  800d96:	75 07                	jne    800d9f <write+0xb9>
		return -E_NOT_SUPP;
  800d98:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d9d:	eb 1d                	jmp    800dbc <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  800d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da3:	4c 8b 40 18          	mov    0x18(%rax),%r8
  800da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800daf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800db3:	48 89 ce             	mov    %rcx,%rsi
  800db6:	48 89 c7             	mov    %rax,%rdi
  800db9:	41 ff d0             	callq  *%r8
}
  800dbc:	c9                   	leaveq 
  800dbd:	c3                   	retq   

0000000000800dbe <seek>:

int
seek(int fdnum, off_t offset)
{
  800dbe:	55                   	push   %rbp
  800dbf:	48 89 e5             	mov    %rsp,%rbp
  800dc2:	48 83 ec 18          	sub    $0x18,%rsp
  800dc6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800dc9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800dcc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800dd3:	48 89 d6             	mov    %rdx,%rsi
  800dd6:	89 c7                	mov    %eax,%edi
  800dd8:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  800ddf:	00 00 00 
  800de2:	ff d0                	callq  *%rax
  800de4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800de7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800deb:	79 05                	jns    800df2 <seek+0x34>
		return r;
  800ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800df0:	eb 0f                	jmp    800e01 <seek+0x43>
	fd->fd_offset = offset;
  800df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800df9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e01:	c9                   	leaveq 
  800e02:	c3                   	retq   

0000000000800e03 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e03:	55                   	push   %rbp
  800e04:	48 89 e5             	mov    %rsp,%rbp
  800e07:	48 83 ec 30          	sub    $0x30,%rsp
  800e0b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e0e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e18:	48 89 d6             	mov    %rdx,%rsi
  800e1b:	89 c7                	mov    %eax,%edi
  800e1d:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	callq  *%rax
  800e29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e30:	78 24                	js     800e56 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e36:	8b 00                	mov    (%rax),%eax
  800e38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e3c:	48 89 d6             	mov    %rdx,%rsi
  800e3f:	89 c7                	mov    %eax,%edi
  800e41:	48 b8 bf 08 80 00 00 	movabs $0x8008bf,%rax
  800e48:	00 00 00 
  800e4b:	ff d0                	callq  *%rax
  800e4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e54:	79 05                	jns    800e5b <ftruncate+0x58>
		return r;
  800e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e59:	eb 72                	jmp    800ecd <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5f:	8b 40 08             	mov    0x8(%rax),%eax
  800e62:	83 e0 03             	and    $0x3,%eax
  800e65:	85 c0                	test   %eax,%eax
  800e67:	75 3a                	jne    800ea3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e69:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800e70:	00 00 00 
  800e73:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e7f:	89 c6                	mov    %eax,%esi
  800e81:	48 bf 90 3c 80 00 00 	movabs $0x803c90,%rdi
  800e88:	00 00 00 
  800e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e90:	48 b9 4b 26 80 00 00 	movabs $0x80264b,%rcx
  800e97:	00 00 00 
  800e9a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea1:	eb 2a                	jmp    800ecd <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800ea3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea7:	48 8b 40 30          	mov    0x30(%rax),%rax
  800eab:	48 85 c0             	test   %rax,%rax
  800eae:	75 07                	jne    800eb7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800eb0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800eb5:	eb 16                	jmp    800ecd <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ebb:	48 8b 48 30          	mov    0x30(%rax),%rcx
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ec6:	89 d6                	mov    %edx,%esi
  800ec8:	48 89 c7             	mov    %rax,%rdi
  800ecb:	ff d1                	callq  *%rcx
}
  800ecd:	c9                   	leaveq 
  800ece:	c3                   	retq   

0000000000800ecf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800ecf:	55                   	push   %rbp
  800ed0:	48 89 e5             	mov    %rsp,%rbp
  800ed3:	48 83 ec 30          	sub    $0x30,%rsp
  800ed7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800eda:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ede:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ee2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ee5:	48 89 d6             	mov    %rdx,%rsi
  800ee8:	89 c7                	mov    %eax,%edi
  800eea:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  800ef1:	00 00 00 
  800ef4:	ff d0                	callq  *%rax
  800ef6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ef9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800efd:	78 24                	js     800f23 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800eff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f03:	8b 00                	mov    (%rax),%eax
  800f05:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f09:	48 89 d6             	mov    %rdx,%rsi
  800f0c:	89 c7                	mov    %eax,%edi
  800f0e:	48 b8 bf 08 80 00 00 	movabs $0x8008bf,%rax
  800f15:	00 00 00 
  800f18:	ff d0                	callq  *%rax
  800f1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f21:	79 05                	jns    800f28 <fstat+0x59>
		return r;
  800f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f26:	eb 5e                	jmp    800f86 <fstat+0xb7>
	if (!dev->dev_stat)
  800f28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2c:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f30:	48 85 c0             	test   %rax,%rax
  800f33:	75 07                	jne    800f3c <fstat+0x6d>
		return -E_NOT_SUPP;
  800f35:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f3a:	eb 4a                	jmp    800f86 <fstat+0xb7>
	stat->st_name[0] = 0;
  800f3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f40:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800f43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f47:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800f4e:	00 00 00 
	stat->st_isdir = 0;
  800f51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f55:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f5c:	00 00 00 
	stat->st_dev = dev;
  800f5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f67:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f72:	48 8b 48 28          	mov    0x28(%rax),%rcx
  800f76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800f7e:	48 89 d6             	mov    %rdx,%rsi
  800f81:	48 89 c7             	mov    %rax,%rdi
  800f84:	ff d1                	callq  *%rcx
}
  800f86:	c9                   	leaveq 
  800f87:	c3                   	retq   

0000000000800f88 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f88:	55                   	push   %rbp
  800f89:	48 89 e5             	mov    %rsp,%rbp
  800f8c:	48 83 ec 20          	sub    $0x20,%rsp
  800f90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	be 00 00 00 00       	mov    $0x0,%esi
  800fa1:	48 89 c7             	mov    %rax,%rdi
  800fa4:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  800fab:	00 00 00 
  800fae:	ff d0                	callq  *%rax
  800fb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fb7:	79 05                	jns    800fbe <stat+0x36>
		return fd;
  800fb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fbc:	eb 2f                	jmp    800fed <stat+0x65>
	r = fstat(fd, stat);
  800fbe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fc5:	48 89 d6             	mov    %rdx,%rsi
  800fc8:	89 c7                	mov    %eax,%edi
  800fca:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  800fd1:	00 00 00 
  800fd4:	ff d0                	callq  *%rax
  800fd6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800fd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fdc:	89 c7                	mov    %eax,%edi
  800fde:	48 b8 76 09 80 00 00 	movabs $0x800976,%rax
  800fe5:	00 00 00 
  800fe8:	ff d0                	callq  *%rax
	return r;
  800fea:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800fed:	c9                   	leaveq 
  800fee:	c3                   	retq   
	...

0000000000800ff0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 83 ec 10          	sub    $0x10,%rsp
  800ff8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ffb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800fff:	48 b8 18 70 80 00 00 	movabs $0x807018,%rax
  801006:	00 00 00 
  801009:	8b 00                	mov    (%rax),%eax
  80100b:	85 c0                	test   %eax,%eax
  80100d:	75 1d                	jne    80102c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80100f:	bf 01 00 00 00       	mov    $0x1,%edi
  801014:	48 b8 df 3a 80 00 00 	movabs $0x803adf,%rax
  80101b:	00 00 00 
  80101e:	ff d0                	callq  *%rax
  801020:	48 ba 18 70 80 00 00 	movabs $0x807018,%rdx
  801027:	00 00 00 
  80102a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80102c:	48 b8 18 70 80 00 00 	movabs $0x807018,%rax
  801033:	00 00 00 
  801036:	8b 00                	mov    (%rax),%eax
  801038:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80103b:	b9 07 00 00 00       	mov    $0x7,%ecx
  801040:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801047:	00 00 00 
  80104a:	89 c7                	mov    %eax,%edi
  80104c:	48 b8 1c 3a 80 00 00 	movabs $0x803a1c,%rax
  801053:	00 00 00 
  801056:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  801058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105c:	ba 00 00 00 00       	mov    $0x0,%edx
  801061:	48 89 c6             	mov    %rax,%rsi
  801064:	bf 00 00 00 00       	mov    $0x0,%edi
  801069:	48 b8 5c 39 80 00 00 	movabs $0x80395c,%rax
  801070:	00 00 00 
  801073:	ff d0                	callq  *%rax
}
  801075:	c9                   	leaveq 
  801076:	c3                   	retq   

0000000000801077 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801077:	55                   	push   %rbp
  801078:	48 89 e5             	mov    %rsp,%rbp
  80107b:	48 83 ec 20          	sub    $0x20,%rsp
  80107f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801083:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  801086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108a:	48 89 c7             	mov    %rax,%rdi
  80108d:	48 b8 9c 31 80 00 00 	movabs $0x80319c,%rax
  801094:	00 00 00 
  801097:	ff d0                	callq  *%rax
  801099:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80109e:	7e 0a                	jle    8010aa <open+0x33>
                return -E_BAD_PATH;
  8010a0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8010a5:	e9 a5 00 00 00       	jmpq   80114f <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8010aa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8010ae:	48 89 c7             	mov    %rax,%rdi
  8010b1:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  8010b8:	00 00 00 
  8010bb:	ff d0                	callq  *%rax
  8010bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c4:	79 08                	jns    8010ce <open+0x57>
		return r;
  8010c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c9:	e9 81 00 00 00       	jmpq   80114f <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8010ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d2:	48 89 c6             	mov    %rax,%rsi
  8010d5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8010dc:	00 00 00 
  8010df:	48 b8 08 32 80 00 00 	movabs $0x803208,%rax
  8010e6:	00 00 00 
  8010e9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8010eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8010f2:	00 00 00 
  8010f5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8010f8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8010fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801102:	48 89 c6             	mov    %rax,%rsi
  801105:	bf 01 00 00 00       	mov    $0x1,%edi
  80110a:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  801111:	00 00 00 
  801114:	ff d0                	callq  *%rax
  801116:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  801119:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80111d:	79 1d                	jns    80113c <open+0xc5>
	{
		fd_close(fd,0);
  80111f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801123:	be 00 00 00 00       	mov    $0x0,%esi
  801128:	48 89 c7             	mov    %rax,%rdi
  80112b:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  801132:	00 00 00 
  801135:	ff d0                	callq  *%rax
		return r;
  801137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80113a:	eb 13                	jmp    80114f <open+0xd8>
	}
	return fd2num(fd);
  80113c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801140:	48 89 c7             	mov    %rax,%rdi
  801143:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  80114a:	00 00 00 
  80114d:	ff d0                	callq  *%rax
	


}
  80114f:	c9                   	leaveq 
  801150:	c3                   	retq   

0000000000801151 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801151:	55                   	push   %rbp
  801152:	48 89 e5             	mov    %rsp,%rbp
  801155:	48 83 ec 10          	sub    $0x10,%rsp
  801159:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80115d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801161:	8b 50 0c             	mov    0xc(%rax),%edx
  801164:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80116b:	00 00 00 
  80116e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801170:	be 00 00 00 00       	mov    $0x0,%esi
  801175:	bf 06 00 00 00       	mov    $0x6,%edi
  80117a:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  801181:	00 00 00 
  801184:	ff d0                	callq  *%rax
}
  801186:	c9                   	leaveq 
  801187:	c3                   	retq   

0000000000801188 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801188:	55                   	push   %rbp
  801189:	48 89 e5             	mov    %rsp,%rbp
  80118c:	48 83 ec 30          	sub    $0x30,%rsp
  801190:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801194:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801198:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	8b 50 0c             	mov    0xc(%rax),%edx
  8011a3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011aa:	00 00 00 
  8011ad:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8011af:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011b6:	00 00 00 
  8011b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011bd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8011c1:	be 00 00 00 00       	mov    $0x0,%esi
  8011c6:	bf 03 00 00 00       	mov    $0x3,%edi
  8011cb:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  8011d2:	00 00 00 
  8011d5:	ff d0                	callq  *%rax
  8011d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011de:	79 05                	jns    8011e5 <devfile_read+0x5d>
	{
		return r;
  8011e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e3:	eb 2c                	jmp    801211 <devfile_read+0x89>
	}
	if(r > 0)
  8011e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011e9:	7e 23                	jle    80120e <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8011eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ee:	48 63 d0             	movslq %eax,%rdx
  8011f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8011fc:	00 00 00 
  8011ff:	48 89 c7             	mov    %rax,%rdi
  801202:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  801209:	00 00 00 
  80120c:	ff d0                	callq  *%rax
	return r;
  80120e:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  801211:	c9                   	leaveq 
  801212:	c3                   	retq   

0000000000801213 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801213:	55                   	push   %rbp
  801214:	48 89 e5             	mov    %rsp,%rbp
  801217:	48 83 ec 30          	sub    $0x30,%rsp
  80121b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801223:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  801227:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122b:	8b 50 0c             	mov    0xc(%rax),%edx
  80122e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801235:	00 00 00 
  801238:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80123a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801241:	00 
  801242:	76 08                	jbe    80124c <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  801244:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80124b:	00 
	fsipcbuf.write.req_n=n;
  80124c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801253:	00 00 00 
  801256:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80125a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80125e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801262:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801266:	48 89 c6             	mov    %rax,%rsi
  801269:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801270:	00 00 00 
  801273:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  80127a:	00 00 00 
  80127d:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80127f:	be 00 00 00 00       	mov    $0x0,%esi
  801284:	bf 04 00 00 00       	mov    $0x4,%edi
  801289:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  801290:	00 00 00 
  801293:	ff d0                	callq  *%rax
  801295:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  801298:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 10          	sub    $0x10,%rsp
  8012a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b0:	8b 50 0c             	mov    0xc(%rax),%edx
  8012b3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012ba:	00 00 00 
  8012bd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8012bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012c6:	00 00 00 
  8012c9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8012cc:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012cf:	be 00 00 00 00       	mov    $0x0,%esi
  8012d4:	bf 02 00 00 00       	mov    $0x2,%edi
  8012d9:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  8012e0:	00 00 00 
  8012e3:	ff d0                	callq  *%rax
}
  8012e5:	c9                   	leaveq 
  8012e6:	c3                   	retq   

00000000008012e7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012e7:	55                   	push   %rbp
  8012e8:	48 89 e5             	mov    %rsp,%rbp
  8012eb:	48 83 ec 20          	sub    $0x20,%rsp
  8012ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fb:	8b 50 0c             	mov    0xc(%rax),%edx
  8012fe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801305:	00 00 00 
  801308:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80130a:	be 00 00 00 00       	mov    $0x0,%esi
  80130f:	bf 05 00 00 00       	mov    $0x5,%edi
  801314:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  80131b:	00 00 00 
  80131e:	ff d0                	callq  *%rax
  801320:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801323:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801327:	79 05                	jns    80132e <devfile_stat+0x47>
		return r;
  801329:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80132c:	eb 56                	jmp    801384 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80132e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801332:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801339:	00 00 00 
  80133c:	48 89 c7             	mov    %rax,%rdi
  80133f:	48 b8 08 32 80 00 00 	movabs $0x803208,%rax
  801346:	00 00 00 
  801349:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80134b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801352:	00 00 00 
  801355:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80135b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801365:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80136c:	00 00 00 
  80136f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801375:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801379:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801384:	c9                   	leaveq 
  801385:	c3                   	retq   
	...

0000000000801388 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801388:	55                   	push   %rbp
  801389:	48 89 e5             	mov    %rsp,%rbp
  80138c:	48 83 ec 20          	sub    $0x20,%rsp
  801390:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801393:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801397:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80139a:	48 89 d6             	mov    %rdx,%rsi
  80139d:	89 c7                	mov    %eax,%edi
  80139f:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  8013a6:	00 00 00 
  8013a9:	ff d0                	callq  *%rax
  8013ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013b2:	79 05                	jns    8013b9 <fd2sockid+0x31>
		return r;
  8013b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013b7:	eb 24                	jmp    8013dd <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8013b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bd:	8b 10                	mov    (%rax),%edx
  8013bf:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8013c6:	00 00 00 
  8013c9:	8b 00                	mov    (%rax),%eax
  8013cb:	39 c2                	cmp    %eax,%edx
  8013cd:	74 07                	je     8013d6 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8013cf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8013d4:	eb 07                	jmp    8013dd <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8013d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013da:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8013dd:	c9                   	leaveq 
  8013de:	c3                   	retq   

00000000008013df <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8013df:	55                   	push   %rbp
  8013e0:	48 89 e5             	mov    %rsp,%rbp
  8013e3:	48 83 ec 20          	sub    $0x20,%rsp
  8013e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8013ea:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8013ee:	48 89 c7             	mov    %rax,%rdi
  8013f1:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  8013f8:	00 00 00 
  8013fb:	ff d0                	callq  *%rax
  8013fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801400:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801404:	78 26                	js     80142c <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140a:	ba 07 04 00 00       	mov    $0x407,%edx
  80140f:	48 89 c6             	mov    %rax,%rsi
  801412:	bf 00 00 00 00       	mov    $0x0,%edi
  801417:	48 b8 40 03 80 00 00 	movabs $0x800340,%rax
  80141e:	00 00 00 
  801421:	ff d0                	callq  *%rax
  801423:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801426:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80142a:	79 16                	jns    801442 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80142c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80142f:	89 c7                	mov    %eax,%edi
  801431:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801438:	00 00 00 
  80143b:	ff d0                	callq  *%rax
		return r;
  80143d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801440:	eb 3a                	jmp    80147c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801446:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80144d:	00 00 00 
  801450:	8b 12                	mov    (%rdx),%edx
  801452:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801458:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80145f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801463:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801466:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146d:	48 89 c7             	mov    %rax,%rdi
  801470:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  801477:	00 00 00 
  80147a:	ff d0                	callq  *%rax
}
  80147c:	c9                   	leaveq 
  80147d:	c3                   	retq   

000000000080147e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80147e:	55                   	push   %rbp
  80147f:	48 89 e5             	mov    %rsp,%rbp
  801482:	48 83 ec 30          	sub    $0x30,%rsp
  801486:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801489:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80148d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801491:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801494:	89 c7                	mov    %eax,%edi
  801496:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  80149d:	00 00 00 
  8014a0:	ff d0                	callq  *%rax
  8014a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014a9:	79 05                	jns    8014b0 <accept+0x32>
		return r;
  8014ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014ae:	eb 3b                	jmp    8014eb <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8014b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014b4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8014b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014bb:	48 89 ce             	mov    %rcx,%rsi
  8014be:	89 c7                	mov    %eax,%edi
  8014c0:	48 b8 c9 17 80 00 00 	movabs $0x8017c9,%rax
  8014c7:	00 00 00 
  8014ca:	ff d0                	callq  *%rax
  8014cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014d3:	79 05                	jns    8014da <accept+0x5c>
		return r;
  8014d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014d8:	eb 11                	jmp    8014eb <accept+0x6d>
	return alloc_sockfd(r);
  8014da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014dd:	89 c7                	mov    %eax,%edi
  8014df:	48 b8 df 13 80 00 00 	movabs $0x8013df,%rax
  8014e6:	00 00 00 
  8014e9:	ff d0                	callq  *%rax
}
  8014eb:	c9                   	leaveq 
  8014ec:	c3                   	retq   

00000000008014ed <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8014ed:	55                   	push   %rbp
  8014ee:	48 89 e5             	mov    %rsp,%rbp
  8014f1:	48 83 ec 20          	sub    $0x20,%rsp
  8014f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014fc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8014ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801502:	89 c7                	mov    %eax,%edi
  801504:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  80150b:	00 00 00 
  80150e:	ff d0                	callq  *%rax
  801510:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801513:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801517:	79 05                	jns    80151e <bind+0x31>
		return r;
  801519:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80151c:	eb 1b                	jmp    801539 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80151e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801521:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801528:	48 89 ce             	mov    %rcx,%rsi
  80152b:	89 c7                	mov    %eax,%edi
  80152d:	48 b8 48 18 80 00 00 	movabs $0x801848,%rax
  801534:	00 00 00 
  801537:	ff d0                	callq  *%rax
}
  801539:	c9                   	leaveq 
  80153a:	c3                   	retq   

000000000080153b <shutdown>:

int
shutdown(int s, int how)
{
  80153b:	55                   	push   %rbp
  80153c:	48 89 e5             	mov    %rsp,%rbp
  80153f:	48 83 ec 20          	sub    $0x20,%rsp
  801543:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801546:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80154c:	89 c7                	mov    %eax,%edi
  80154e:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  801555:	00 00 00 
  801558:	ff d0                	callq  *%rax
  80155a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80155d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801561:	79 05                	jns    801568 <shutdown+0x2d>
		return r;
  801563:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801566:	eb 16                	jmp    80157e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801568:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80156b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80156e:	89 d6                	mov    %edx,%esi
  801570:	89 c7                	mov    %eax,%edi
  801572:	48 b8 ac 18 80 00 00 	movabs $0x8018ac,%rax
  801579:	00 00 00 
  80157c:	ff d0                	callq  *%rax
}
  80157e:	c9                   	leaveq 
  80157f:	c3                   	retq   

0000000000801580 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801580:	55                   	push   %rbp
  801581:	48 89 e5             	mov    %rsp,%rbp
  801584:	48 83 ec 10          	sub    $0x10,%rsp
  801588:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	48 89 c7             	mov    %rax,%rdi
  801593:	48 b8 64 3b 80 00 00 	movabs $0x803b64,%rax
  80159a:	00 00 00 
  80159d:	ff d0                	callq  *%rax
  80159f:	83 f8 01             	cmp    $0x1,%eax
  8015a2:	75 17                	jne    8015bb <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8015a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a8:	8b 40 0c             	mov    0xc(%rax),%eax
  8015ab:	89 c7                	mov    %eax,%edi
  8015ad:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  8015b4:	00 00 00 
  8015b7:	ff d0                	callq  *%rax
  8015b9:	eb 05                	jmp    8015c0 <devsock_close+0x40>
	else
		return 0;
  8015bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c0:	c9                   	leaveq 
  8015c1:	c3                   	retq   

00000000008015c2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8015c2:	55                   	push   %rbp
  8015c3:	48 89 e5             	mov    %rsp,%rbp
  8015c6:	48 83 ec 20          	sub    $0x20,%rsp
  8015ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8015cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015d1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8015d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015d7:	89 c7                	mov    %eax,%edi
  8015d9:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  8015e0:	00 00 00 
  8015e3:	ff d0                	callq  *%rax
  8015e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015ec:	79 05                	jns    8015f3 <connect+0x31>
		return r;
  8015ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015f1:	eb 1b                	jmp    80160e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8015f3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8015f6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015fd:	48 89 ce             	mov    %rcx,%rsi
  801600:	89 c7                	mov    %eax,%edi
  801602:	48 b8 19 19 80 00 00 	movabs $0x801919,%rax
  801609:	00 00 00 
  80160c:	ff d0                	callq  *%rax
}
  80160e:	c9                   	leaveq 
  80160f:	c3                   	retq   

0000000000801610 <listen>:

int
listen(int s, int backlog)
{
  801610:	55                   	push   %rbp
  801611:	48 89 e5             	mov    %rsp,%rbp
  801614:	48 83 ec 20          	sub    $0x20,%rsp
  801618:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80161b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80161e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801621:	89 c7                	mov    %eax,%edi
  801623:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  80162a:	00 00 00 
  80162d:	ff d0                	callq  *%rax
  80162f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801632:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801636:	79 05                	jns    80163d <listen+0x2d>
		return r;
  801638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80163b:	eb 16                	jmp    801653 <listen+0x43>
	return nsipc_listen(r, backlog);
  80163d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801640:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801643:	89 d6                	mov    %edx,%esi
  801645:	89 c7                	mov    %eax,%edi
  801647:	48 b8 7d 19 80 00 00 	movabs $0x80197d,%rax
  80164e:	00 00 00 
  801651:	ff d0                	callq  *%rax
}
  801653:	c9                   	leaveq 
  801654:	c3                   	retq   

0000000000801655 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801655:	55                   	push   %rbp
  801656:	48 89 e5             	mov    %rsp,%rbp
  801659:	48 83 ec 20          	sub    $0x20,%rsp
  80165d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801661:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801665:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166d:	89 c2                	mov    %eax,%edx
  80166f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801673:	8b 40 0c             	mov    0xc(%rax),%eax
  801676:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80167a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167f:	89 c7                	mov    %eax,%edi
  801681:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  801688:	00 00 00 
  80168b:	ff d0                	callq  *%rax
}
  80168d:	c9                   	leaveq 
  80168e:	c3                   	retq   

000000000080168f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80168f:	55                   	push   %rbp
  801690:	48 89 e5             	mov    %rsp,%rbp
  801693:	48 83 ec 20          	sub    $0x20,%rsp
  801697:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80169f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8016a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a7:	89 c2                	mov    %eax,%edx
  8016a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ad:	8b 40 0c             	mov    0xc(%rax),%eax
  8016b0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8016b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b9:	89 c7                	mov    %eax,%edi
  8016bb:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  8016c2:	00 00 00 
  8016c5:	ff d0                	callq  *%rax
}
  8016c7:	c9                   	leaveq 
  8016c8:	c3                   	retq   

00000000008016c9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016c9:	55                   	push   %rbp
  8016ca:	48 89 e5             	mov    %rsp,%rbp
  8016cd:	48 83 ec 10          	sub    $0x10,%rsp
  8016d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8016d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016dd:	48 be bb 3c 80 00 00 	movabs $0x803cbb,%rsi
  8016e4:	00 00 00 
  8016e7:	48 89 c7             	mov    %rax,%rdi
  8016ea:	48 b8 08 32 80 00 00 	movabs $0x803208,%rax
  8016f1:	00 00 00 
  8016f4:	ff d0                	callq  *%rax
	return 0;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fb:	c9                   	leaveq 
  8016fc:	c3                   	retq   

00000000008016fd <socket>:

int
socket(int domain, int type, int protocol)
{
  8016fd:	55                   	push   %rbp
  8016fe:	48 89 e5             	mov    %rsp,%rbp
  801701:	48 83 ec 20          	sub    $0x20,%rsp
  801705:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801708:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80170b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80170e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801711:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801714:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801717:	89 ce                	mov    %ecx,%esi
  801719:	89 c7                	mov    %eax,%edi
  80171b:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  801722:	00 00 00 
  801725:	ff d0                	callq  *%rax
  801727:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80172a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80172e:	79 05                	jns    801735 <socket+0x38>
		return r;
  801730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801733:	eb 11                	jmp    801746 <socket+0x49>
	return alloc_sockfd(r);
  801735:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801738:	89 c7                	mov    %eax,%edi
  80173a:	48 b8 df 13 80 00 00 	movabs $0x8013df,%rax
  801741:	00 00 00 
  801744:	ff d0                	callq  *%rax
}
  801746:	c9                   	leaveq 
  801747:	c3                   	retq   

0000000000801748 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801748:	55                   	push   %rbp
  801749:	48 89 e5             	mov    %rsp,%rbp
  80174c:	48 83 ec 10          	sub    $0x10,%rsp
  801750:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801753:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  80175a:	00 00 00 
  80175d:	8b 00                	mov    (%rax),%eax
  80175f:	85 c0                	test   %eax,%eax
  801761:	75 1d                	jne    801780 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801763:	bf 02 00 00 00       	mov    $0x2,%edi
  801768:	48 b8 df 3a 80 00 00 	movabs $0x803adf,%rax
  80176f:	00 00 00 
  801772:	ff d0                	callq  *%rax
  801774:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  80177b:	00 00 00 
  80177e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801780:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  801787:	00 00 00 
  80178a:	8b 00                	mov    (%rax),%eax
  80178c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80178f:	b9 07 00 00 00       	mov    $0x7,%ecx
  801794:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80179b:	00 00 00 
  80179e:	89 c7                	mov    %eax,%edi
  8017a0:	48 b8 1c 3a 80 00 00 	movabs $0x803a1c,%rax
  8017a7:	00 00 00 
  8017aa:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8017ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b1:	be 00 00 00 00       	mov    $0x0,%esi
  8017b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8017bb:	48 b8 5c 39 80 00 00 	movabs $0x80395c,%rax
  8017c2:	00 00 00 
  8017c5:	ff d0                	callq  *%rax
}
  8017c7:	c9                   	leaveq 
  8017c8:	c3                   	retq   

00000000008017c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017c9:	55                   	push   %rbp
  8017ca:	48 89 e5             	mov    %rsp,%rbp
  8017cd:	48 83 ec 30          	sub    $0x30,%rsp
  8017d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8017dc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8017e3:	00 00 00 
  8017e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8017e9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8017eb:	bf 01 00 00 00       	mov    $0x1,%edi
  8017f0:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
  8017fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801803:	78 3e                	js     801843 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801805:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80180c:	00 00 00 
  80180f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801817:	8b 40 10             	mov    0x10(%rax),%eax
  80181a:	89 c2                	mov    %eax,%edx
  80181c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801820:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801824:	48 89 ce             	mov    %rcx,%rsi
  801827:	48 89 c7             	mov    %rax,%rdi
  80182a:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  801831:	00 00 00 
  801834:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801836:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80183a:	8b 50 10             	mov    0x10(%rax),%edx
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801843:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801846:	c9                   	leaveq 
  801847:	c3                   	retq   

0000000000801848 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801848:	55                   	push   %rbp
  801849:	48 89 e5             	mov    %rsp,%rbp
  80184c:	48 83 ec 10          	sub    $0x10,%rsp
  801850:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801853:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801857:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80185a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801861:	00 00 00 
  801864:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801867:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801869:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80186c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801870:	48 89 c6             	mov    %rax,%rsi
  801873:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80187a:	00 00 00 
  80187d:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  801884:	00 00 00 
  801887:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801889:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801890:	00 00 00 
  801893:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801896:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801899:	bf 02 00 00 00       	mov    $0x2,%edi
  80189e:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  8018a5:	00 00 00 
  8018a8:	ff d0                	callq  *%rax
}
  8018aa:	c9                   	leaveq 
  8018ab:	c3                   	retq   

00000000008018ac <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8018ac:	55                   	push   %rbp
  8018ad:	48 89 e5             	mov    %rsp,%rbp
  8018b0:	48 83 ec 10          	sub    $0x10,%rsp
  8018b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8018ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018c1:	00 00 00 
  8018c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018c7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8018c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018d0:	00 00 00 
  8018d3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8018d6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8018d9:	bf 03 00 00 00       	mov    $0x3,%edi
  8018de:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  8018e5:	00 00 00 
  8018e8:	ff d0                	callq  *%rax
}
  8018ea:	c9                   	leaveq 
  8018eb:	c3                   	retq   

00000000008018ec <nsipc_close>:

int
nsipc_close(int s)
{
  8018ec:	55                   	push   %rbp
  8018ed:	48 89 e5             	mov    %rsp,%rbp
  8018f0:	48 83 ec 10          	sub    $0x10,%rsp
  8018f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8018f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018fe:	00 00 00 
  801901:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801904:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  801906:	bf 04 00 00 00       	mov    $0x4,%edi
  80190b:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  801912:	00 00 00 
  801915:	ff d0                	callq  *%rax
}
  801917:	c9                   	leaveq 
  801918:	c3                   	retq   

0000000000801919 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801919:	55                   	push   %rbp
  80191a:	48 89 e5             	mov    %rsp,%rbp
  80191d:	48 83 ec 10          	sub    $0x10,%rsp
  801921:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801924:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801928:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80192b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801932:	00 00 00 
  801935:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801938:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80193a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80193d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801941:	48 89 c6             	mov    %rax,%rsi
  801944:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80194b:	00 00 00 
  80194e:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  801955:	00 00 00 
  801958:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80195a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801961:	00 00 00 
  801964:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801967:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80196a:	bf 05 00 00 00       	mov    $0x5,%edi
  80196f:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  801976:	00 00 00 
  801979:	ff d0                	callq  *%rax
}
  80197b:	c9                   	leaveq 
  80197c:	c3                   	retq   

000000000080197d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80197d:	55                   	push   %rbp
  80197e:	48 89 e5             	mov    %rsp,%rbp
  801981:	48 83 ec 10          	sub    $0x10,%rsp
  801985:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801988:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80198b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801992:	00 00 00 
  801995:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801998:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80199a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019a1:	00 00 00 
  8019a4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8019a7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8019aa:	bf 06 00 00 00       	mov    $0x6,%edi
  8019af:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	callq  *%rax
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 30          	sub    $0x30,%rsp
  8019c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8019c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019cc:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8019cf:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8019d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019d9:	00 00 00 
  8019dc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8019df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8019e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019e8:	00 00 00 
  8019eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8019ee:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8019f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019f8:	00 00 00 
  8019fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8019fe:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a01:	bf 07 00 00 00       	mov    $0x7,%edi
  801a06:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  801a0d:	00 00 00 
  801a10:	ff d0                	callq  *%rax
  801a12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a19:	78 69                	js     801a84 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801a1b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801a22:	7f 08                	jg     801a2c <nsipc_recv+0x6f>
  801a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a27:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801a2a:	7e 35                	jle    801a61 <nsipc_recv+0xa4>
  801a2c:	48 b9 c2 3c 80 00 00 	movabs $0x803cc2,%rcx
  801a33:	00 00 00 
  801a36:	48 ba d7 3c 80 00 00 	movabs $0x803cd7,%rdx
  801a3d:	00 00 00 
  801a40:	be 61 00 00 00       	mov    $0x61,%esi
  801a45:	48 bf ec 3c 80 00 00 	movabs $0x803cec,%rdi
  801a4c:	00 00 00 
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a54:	49 b8 10 24 80 00 00 	movabs $0x802410,%r8
  801a5b:	00 00 00 
  801a5e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a64:	48 63 d0             	movslq %eax,%rdx
  801a67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a6b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801a72:	00 00 00 
  801a75:	48 89 c7             	mov    %rax,%rdi
  801a78:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	callq  *%rax
	}

	return r;
  801a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801a87:	c9                   	leaveq 
  801a88:	c3                   	retq   

0000000000801a89 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a89:	55                   	push   %rbp
  801a8a:	48 89 e5             	mov    %rsp,%rbp
  801a8d:	48 83 ec 20          	sub    $0x20,%rsp
  801a91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a98:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a9b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801a9e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801aa5:	00 00 00 
  801aa8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801aab:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801aad:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801ab4:	7e 35                	jle    801aeb <nsipc_send+0x62>
  801ab6:	48 b9 f8 3c 80 00 00 	movabs $0x803cf8,%rcx
  801abd:	00 00 00 
  801ac0:	48 ba d7 3c 80 00 00 	movabs $0x803cd7,%rdx
  801ac7:	00 00 00 
  801aca:	be 6c 00 00 00       	mov    $0x6c,%esi
  801acf:	48 bf ec 3c 80 00 00 	movabs $0x803cec,%rdi
  801ad6:	00 00 00 
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ade:	49 b8 10 24 80 00 00 	movabs $0x802410,%r8
  801ae5:	00 00 00 
  801ae8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801aeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aee:	48 63 d0             	movslq %eax,%rdx
  801af1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af5:	48 89 c6             	mov    %rax,%rsi
  801af8:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801aff:	00 00 00 
  801b02:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  801b09:	00 00 00 
  801b0c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801b0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b15:	00 00 00 
  801b18:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b1b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801b1e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b25:	00 00 00 
  801b28:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801b2b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801b2e:	bf 08 00 00 00       	mov    $0x8,%edi
  801b33:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  801b3a:	00 00 00 
  801b3d:	ff d0                	callq  *%rax
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 10          	sub    $0x10,%rsp
  801b49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801b4f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801b52:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b59:	00 00 00 
  801b5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b5f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801b61:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b68:	00 00 00 
  801b6b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b6e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801b71:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b78:	00 00 00 
  801b7b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801b7e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801b81:	bf 09 00 00 00       	mov    $0x9,%edi
  801b86:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  801b8d:	00 00 00 
  801b90:	ff d0                	callq  *%rax
}
  801b92:	c9                   	leaveq 
  801b93:	c3                   	retq   

0000000000801b94 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b94:	55                   	push   %rbp
  801b95:	48 89 e5             	mov    %rsp,%rbp
  801b98:	53                   	push   %rbx
  801b99:	48 83 ec 38          	sub    $0x38,%rsp
  801b9d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ba1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801ba5:	48 89 c7             	mov    %rax,%rdi
  801ba8:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  801baf:	00 00 00 
  801bb2:	ff d0                	callq  *%rax
  801bb4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801bbb:	0f 88 bf 01 00 00    	js     801d80 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc5:	ba 07 04 00 00       	mov    $0x407,%edx
  801bca:	48 89 c6             	mov    %rax,%rsi
  801bcd:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd2:	48 b8 40 03 80 00 00 	movabs $0x800340,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
  801bde:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801be1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801be5:	0f 88 95 01 00 00    	js     801d80 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801beb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bef:	48 89 c7             	mov    %rax,%rdi
  801bf2:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	callq  *%rax
  801bfe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c01:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c05:	0f 88 5d 01 00 00    	js     801d68 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c0f:	ba 07 04 00 00       	mov    $0x407,%edx
  801c14:	48 89 c6             	mov    %rax,%rsi
  801c17:	bf 00 00 00 00       	mov    $0x0,%edi
  801c1c:	48 b8 40 03 80 00 00 	movabs $0x800340,%rax
  801c23:	00 00 00 
  801c26:	ff d0                	callq  *%rax
  801c28:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c2f:	0f 88 33 01 00 00    	js     801d68 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801c35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c39:	48 89 c7             	mov    %rax,%rdi
  801c3c:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  801c43:	00 00 00 
  801c46:	ff d0                	callq  *%rax
  801c48:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c50:	ba 07 04 00 00       	mov    $0x407,%edx
  801c55:	48 89 c6             	mov    %rax,%rsi
  801c58:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5d:	48 b8 40 03 80 00 00 	movabs $0x800340,%rax
  801c64:	00 00 00 
  801c67:	ff d0                	callq  *%rax
  801c69:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c70:	0f 88 d9 00 00 00    	js     801d4f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c7a:	48 89 c7             	mov    %rax,%rdi
  801c7d:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  801c84:	00 00 00 
  801c87:	ff d0                	callq  *%rax
  801c89:	48 89 c2             	mov    %rax,%rdx
  801c8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c90:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801c96:	48 89 d1             	mov    %rdx,%rcx
  801c99:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9e:	48 89 c6             	mov    %rax,%rsi
  801ca1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca6:	48 b8 90 03 80 00 00 	movabs $0x800390,%rax
  801cad:	00 00 00 
  801cb0:	ff d0                	callq  *%rax
  801cb2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801cb9:	78 79                	js     801d34 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801cbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cbf:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801cc6:	00 00 00 
  801cc9:	8b 12                	mov    (%rdx),%edx
  801ccb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801ccd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801cd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cdc:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801ce3:	00 00 00 
  801ce6:	8b 12                	mov    (%rdx),%edx
  801ce8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801cea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cee:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801cf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf9:	48 89 c7             	mov    %rax,%rdi
  801cfc:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  801d03:	00 00 00 
  801d06:	ff d0                	callq  *%rax
  801d08:	89 c2                	mov    %eax,%edx
  801d0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d0e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801d10:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d14:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801d18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d1c:	48 89 c7             	mov    %rax,%rdi
  801d1f:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	callq  *%rax
  801d2b:	89 03                	mov    %eax,(%rbx)
	return 0;
  801d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d32:	eb 4f                	jmp    801d83 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  801d34:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  801d35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d39:	48 89 c6             	mov    %rax,%rsi
  801d3c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d41:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  801d48:	00 00 00 
  801d4b:	ff d0                	callq  *%rax
  801d4d:	eb 01                	jmp    801d50 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  801d4f:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  801d50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d54:	48 89 c6             	mov    %rax,%rsi
  801d57:	bf 00 00 00 00       	mov    $0x0,%edi
  801d5c:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  801d63:	00 00 00 
  801d66:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  801d68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d6c:	48 89 c6             	mov    %rax,%rsi
  801d6f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d74:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	callq  *%rax
    err:
	return r;
  801d80:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801d83:	48 83 c4 38          	add    $0x38,%rsp
  801d87:	5b                   	pop    %rbx
  801d88:	5d                   	pop    %rbp
  801d89:	c3                   	retq   

0000000000801d8a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d8a:	55                   	push   %rbp
  801d8b:	48 89 e5             	mov    %rsp,%rbp
  801d8e:	53                   	push   %rbx
  801d8f:	48 83 ec 28          	sub    $0x28,%rsp
  801d93:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d97:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801d9b:	eb 01                	jmp    801d9e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  801d9d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d9e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801da5:	00 00 00 
  801da8:	48 8b 00             	mov    (%rax),%rax
  801dab:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801db1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801db4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db8:	48 89 c7             	mov    %rax,%rdi
  801dbb:	48 b8 64 3b 80 00 00 	movabs $0x803b64,%rax
  801dc2:	00 00 00 
  801dc5:	ff d0                	callq  *%rax
  801dc7:	89 c3                	mov    %eax,%ebx
  801dc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dcd:	48 89 c7             	mov    %rax,%rdi
  801dd0:	48 b8 64 3b 80 00 00 	movabs $0x803b64,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
  801ddc:	39 c3                	cmp    %eax,%ebx
  801dde:	0f 94 c0             	sete   %al
  801de1:	0f b6 c0             	movzbl %al,%eax
  801de4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801de7:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801dee:	00 00 00 
  801df1:	48 8b 00             	mov    (%rax),%rax
  801df4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801dfa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801dfd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e00:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801e03:	75 0a                	jne    801e0f <_pipeisclosed+0x85>
			return ret;
  801e05:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801e08:	48 83 c4 28          	add    $0x28,%rsp
  801e0c:	5b                   	pop    %rbx
  801e0d:	5d                   	pop    %rbp
  801e0e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801e0f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e12:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801e15:	74 86                	je     801d9d <_pipeisclosed+0x13>
  801e17:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801e1b:	75 80                	jne    801d9d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e1d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801e24:	00 00 00 
  801e27:	48 8b 00             	mov    (%rax),%rax
  801e2a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801e30:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801e33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e36:	89 c6                	mov    %eax,%esi
  801e38:	48 bf 09 3d 80 00 00 	movabs $0x803d09,%rdi
  801e3f:	00 00 00 
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
  801e47:	49 b8 4b 26 80 00 00 	movabs $0x80264b,%r8
  801e4e:	00 00 00 
  801e51:	41 ff d0             	callq  *%r8
	}
  801e54:	e9 44 ff ff ff       	jmpq   801d9d <_pipeisclosed+0x13>

0000000000801e59 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  801e59:	55                   	push   %rbp
  801e5a:	48 89 e5             	mov    %rsp,%rbp
  801e5d:	48 83 ec 30          	sub    $0x30,%rsp
  801e61:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e64:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e6b:	48 89 d6             	mov    %rdx,%rsi
  801e6e:	89 c7                	mov    %eax,%edi
  801e70:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  801e77:	00 00 00 
  801e7a:	ff d0                	callq  *%rax
  801e7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e83:	79 05                	jns    801e8a <pipeisclosed+0x31>
		return r;
  801e85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e88:	eb 31                	jmp    801ebb <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801e8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8e:	48 89 c7             	mov    %rax,%rdi
  801e91:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  801e98:	00 00 00 
  801e9b:	ff d0                	callq  *%rax
  801e9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801ea1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea9:	48 89 d6             	mov    %rdx,%rsi
  801eac:	48 89 c7             	mov    %rax,%rdi
  801eaf:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  801eb6:	00 00 00 
  801eb9:	ff d0                	callq  *%rax
}
  801ebb:	c9                   	leaveq 
  801ebc:	c3                   	retq   

0000000000801ebd <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ebd:	55                   	push   %rbp
  801ebe:	48 89 e5             	mov    %rsp,%rbp
  801ec1:	48 83 ec 40          	sub    $0x40,%rsp
  801ec5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ec9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801ecd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed5:	48 89 c7             	mov    %rax,%rdi
  801ed8:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  801edf:	00 00 00 
  801ee2:	ff d0                	callq  *%rax
  801ee4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801ee8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801eec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801ef0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801ef7:	00 
  801ef8:	e9 97 00 00 00       	jmpq   801f94 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801efd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801f02:	74 09                	je     801f0d <devpipe_read+0x50>
				return i;
  801f04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f08:	e9 95 00 00 00       	jmpq   801fa2 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f15:	48 89 d6             	mov    %rdx,%rsi
  801f18:	48 89 c7             	mov    %rax,%rdi
  801f1b:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
  801f27:	85 c0                	test   %eax,%eax
  801f29:	74 07                	je     801f32 <devpipe_read+0x75>
				return 0;
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f30:	eb 70                	jmp    801fa2 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f32:	48 b8 02 03 80 00 00 	movabs $0x800302,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	callq  *%rax
  801f3e:	eb 01                	jmp    801f41 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f40:	90                   	nop
  801f41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f45:	8b 10                	mov    (%rax),%edx
  801f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4b:	8b 40 04             	mov    0x4(%rax),%eax
  801f4e:	39 c2                	cmp    %eax,%edx
  801f50:	74 ab                	je     801efd <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f5a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801f5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f62:	8b 00                	mov    (%rax),%eax
  801f64:	89 c2                	mov    %eax,%edx
  801f66:	c1 fa 1f             	sar    $0x1f,%edx
  801f69:	c1 ea 1b             	shr    $0x1b,%edx
  801f6c:	01 d0                	add    %edx,%eax
  801f6e:	83 e0 1f             	and    $0x1f,%eax
  801f71:	29 d0                	sub    %edx,%eax
  801f73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f77:	48 98                	cltq   
  801f79:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801f7e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f84:	8b 00                	mov    (%rax),%eax
  801f86:	8d 50 01             	lea    0x1(%rax),%edx
  801f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f8f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f98:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801f9c:	72 a2                	jb     801f40 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801fa2:	c9                   	leaveq 
  801fa3:	c3                   	retq   

0000000000801fa4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fa4:	55                   	push   %rbp
  801fa5:	48 89 e5             	mov    %rsp,%rbp
  801fa8:	48 83 ec 40          	sub    $0x40,%rsp
  801fac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fb0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801fb4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fbc:	48 89 c7             	mov    %rax,%rdi
  801fbf:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  801fc6:	00 00 00 
  801fc9:	ff d0                	callq  *%rax
  801fcb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801fcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801fd7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801fde:	00 
  801fdf:	e9 93 00 00 00       	jmpq   802077 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fe4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fe8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fec:	48 89 d6             	mov    %rdx,%rsi
  801fef:	48 89 c7             	mov    %rax,%rdi
  801ff2:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
  801ffe:	85 c0                	test   %eax,%eax
  802000:	74 07                	je     802009 <devpipe_write+0x65>
				return 0;
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
  802007:	eb 7c                	jmp    802085 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802009:	48 b8 02 03 80 00 00 	movabs $0x800302,%rax
  802010:	00 00 00 
  802013:	ff d0                	callq  *%rax
  802015:	eb 01                	jmp    802018 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802017:	90                   	nop
  802018:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201c:	8b 40 04             	mov    0x4(%rax),%eax
  80201f:	48 63 d0             	movslq %eax,%rdx
  802022:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802026:	8b 00                	mov    (%rax),%eax
  802028:	48 98                	cltq   
  80202a:	48 83 c0 20          	add    $0x20,%rax
  80202e:	48 39 c2             	cmp    %rax,%rdx
  802031:	73 b1                	jae    801fe4 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802037:	8b 40 04             	mov    0x4(%rax),%eax
  80203a:	89 c2                	mov    %eax,%edx
  80203c:	c1 fa 1f             	sar    $0x1f,%edx
  80203f:	c1 ea 1b             	shr    $0x1b,%edx
  802042:	01 d0                	add    %edx,%eax
  802044:	83 e0 1f             	and    $0x1f,%eax
  802047:	29 d0                	sub    %edx,%eax
  802049:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80204d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802051:	48 01 ca             	add    %rcx,%rdx
  802054:	0f b6 0a             	movzbl (%rdx),%ecx
  802057:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205b:	48 98                	cltq   
  80205d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802061:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802065:	8b 40 04             	mov    0x4(%rax),%eax
  802068:	8d 50 01             	lea    0x1(%rax),%edx
  80206b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80206f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802072:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802077:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80207b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80207f:	72 96                	jb     802017 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802081:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802085:	c9                   	leaveq 
  802086:	c3                   	retq   

0000000000802087 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802087:	55                   	push   %rbp
  802088:	48 89 e5             	mov    %rsp,%rbp
  80208b:	48 83 ec 20          	sub    $0x20,%rsp
  80208f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802093:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209b:	48 89 c7             	mov    %rax,%rdi
  80209e:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	callq  *%rax
  8020aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8020ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020b2:	48 be 1c 3d 80 00 00 	movabs $0x803d1c,%rsi
  8020b9:	00 00 00 
  8020bc:	48 89 c7             	mov    %rax,%rdi
  8020bf:	48 b8 08 32 80 00 00 	movabs $0x803208,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8020cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cf:	8b 50 04             	mov    0x4(%rax),%edx
  8020d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d6:	8b 00                	mov    (%rax),%eax
  8020d8:	29 c2                	sub    %eax,%edx
  8020da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020de:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8020e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8020ef:	00 00 00 
	stat->st_dev = &devpipe;
  8020f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8020fd:	00 00 00 
  802100:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210c:	c9                   	leaveq 
  80210d:	c3                   	retq   

000000000080210e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80210e:	55                   	push   %rbp
  80210f:	48 89 e5             	mov    %rsp,%rbp
  802112:	48 83 ec 10          	sub    $0x10,%rsp
  802116:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80211a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211e:	48 89 c6             	mov    %rax,%rsi
  802121:	bf 00 00 00 00       	mov    $0x0,%edi
  802126:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  80212d:	00 00 00 
  802130:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802136:	48 89 c7             	mov    %rax,%rdi
  802139:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  802140:	00 00 00 
  802143:	ff d0                	callq  *%rax
  802145:	48 89 c6             	mov    %rax,%rsi
  802148:	bf 00 00 00 00       	mov    $0x0,%edi
  80214d:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  802154:	00 00 00 
  802157:	ff d0                	callq  *%rax
}
  802159:	c9                   	leaveq 
  80215a:	c3                   	retq   
	...

000000000080215c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80215c:	55                   	push   %rbp
  80215d:	48 89 e5             	mov    %rsp,%rbp
  802160:	48 83 ec 20          	sub    $0x20,%rsp
  802164:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802167:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80216a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80216d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802171:	be 01 00 00 00       	mov    $0x1,%esi
  802176:	48 89 c7             	mov    %rax,%rdi
  802179:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  802180:	00 00 00 
  802183:	ff d0                	callq  *%rax
}
  802185:	c9                   	leaveq 
  802186:	c3                   	retq   

0000000000802187 <getchar>:

int
getchar(void)
{
  802187:	55                   	push   %rbp
  802188:	48 89 e5             	mov    %rsp,%rbp
  80218b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80218f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802193:	ba 01 00 00 00       	mov    $0x1,%edx
  802198:	48 89 c6             	mov    %rax,%rsi
  80219b:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a0:	48 b8 98 0b 80 00 00 	movabs $0x800b98,%rax
  8021a7:	00 00 00 
  8021aa:	ff d0                	callq  *%rax
  8021ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8021af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b3:	79 05                	jns    8021ba <getchar+0x33>
		return r;
  8021b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b8:	eb 14                	jmp    8021ce <getchar+0x47>
	if (r < 1)
  8021ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021be:	7f 07                	jg     8021c7 <getchar+0x40>
		return -E_EOF;
  8021c0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8021c5:	eb 07                	jmp    8021ce <getchar+0x47>
	return c;
  8021c7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8021cb:	0f b6 c0             	movzbl %al,%eax
}
  8021ce:	c9                   	leaveq 
  8021cf:	c3                   	retq   

00000000008021d0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021d0:	55                   	push   %rbp
  8021d1:	48 89 e5             	mov    %rsp,%rbp
  8021d4:	48 83 ec 20          	sub    $0x20,%rsp
  8021d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021db:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021e2:	48 89 d6             	mov    %rdx,%rsi
  8021e5:	89 c7                	mov    %eax,%edi
  8021e7:	48 b8 66 07 80 00 00 	movabs $0x800766,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	callq  *%rax
  8021f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fa:	79 05                	jns    802201 <iscons+0x31>
		return r;
  8021fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ff:	eb 1a                	jmp    80221b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802205:	8b 10                	mov    (%rax),%edx
  802207:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80220e:	00 00 00 
  802211:	8b 00                	mov    (%rax),%eax
  802213:	39 c2                	cmp    %eax,%edx
  802215:	0f 94 c0             	sete   %al
  802218:	0f b6 c0             	movzbl %al,%eax
}
  80221b:	c9                   	leaveq 
  80221c:	c3                   	retq   

000000000080221d <opencons>:

int
opencons(void)
{
  80221d:	55                   	push   %rbp
  80221e:	48 89 e5             	mov    %rsp,%rbp
  802221:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802225:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802229:	48 89 c7             	mov    %rax,%rdi
  80222c:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  802233:	00 00 00 
  802236:	ff d0                	callq  *%rax
  802238:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223f:	79 05                	jns    802246 <opencons+0x29>
		return r;
  802241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802244:	eb 5b                	jmp    8022a1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224a:	ba 07 04 00 00       	mov    $0x407,%edx
  80224f:	48 89 c6             	mov    %rax,%rsi
  802252:	bf 00 00 00 00       	mov    $0x0,%edi
  802257:	48 b8 40 03 80 00 00 	movabs $0x800340,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax
  802263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802266:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80226a:	79 05                	jns    802271 <opencons+0x54>
		return r;
  80226c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226f:	eb 30                	jmp    8022a1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802275:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80227c:	00 00 00 
  80227f:	8b 12                	mov    (%rdx),%edx
  802281:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802287:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80228e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802292:	48 89 c7             	mov    %rax,%rdi
  802295:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  80229c:	00 00 00 
  80229f:	ff d0                	callq  *%rax
}
  8022a1:	c9                   	leaveq 
  8022a2:	c3                   	retq   

00000000008022a3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022a3:	55                   	push   %rbp
  8022a4:	48 89 e5             	mov    %rsp,%rbp
  8022a7:	48 83 ec 30          	sub    $0x30,%rsp
  8022ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8022b7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022bc:	75 13                	jne    8022d1 <devcons_read+0x2e>
		return 0;
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c3:	eb 49                	jmp    80230e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8022c5:	48 b8 02 03 80 00 00 	movabs $0x800302,%rax
  8022cc:	00 00 00 
  8022cf:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8022d1:	48 b8 42 02 80 00 00 	movabs $0x800242,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
  8022dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e4:	74 df                	je     8022c5 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8022e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ea:	79 05                	jns    8022f1 <devcons_read+0x4e>
		return c;
  8022ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ef:	eb 1d                	jmp    80230e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8022f1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8022f5:	75 07                	jne    8022fe <devcons_read+0x5b>
		return 0;
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	eb 10                	jmp    80230e <devcons_read+0x6b>
	*(char*)vbuf = c;
  8022fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802301:	89 c2                	mov    %eax,%edx
  802303:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802307:	88 10                	mov    %dl,(%rax)
	return 1;
  802309:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80230e:	c9                   	leaveq 
  80230f:	c3                   	retq   

0000000000802310 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802310:	55                   	push   %rbp
  802311:	48 89 e5             	mov    %rsp,%rbp
  802314:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80231b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802322:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802329:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802337:	eb 77                	jmp    8023b0 <devcons_write+0xa0>
		m = n - tot;
  802339:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802340:	89 c2                	mov    %eax,%edx
  802342:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802345:	89 d1                	mov    %edx,%ecx
  802347:	29 c1                	sub    %eax,%ecx
  802349:	89 c8                	mov    %ecx,%eax
  80234b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80234e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802351:	83 f8 7f             	cmp    $0x7f,%eax
  802354:	76 07                	jbe    80235d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  802356:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80235d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802360:	48 63 d0             	movslq %eax,%rdx
  802363:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802366:	48 98                	cltq   
  802368:	48 89 c1             	mov    %rax,%rcx
  80236b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  802372:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802379:	48 89 ce             	mov    %rcx,%rsi
  80237c:	48 89 c7             	mov    %rax,%rdi
  80237f:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  802386:	00 00 00 
  802389:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80238b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80238e:	48 63 d0             	movslq %eax,%rdx
  802391:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802398:	48 89 d6             	mov    %rdx,%rsi
  80239b:	48 89 c7             	mov    %rax,%rdi
  80239e:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  8023a5:	00 00 00 
  8023a8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023ad:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b3:	48 98                	cltq   
  8023b5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8023bc:	0f 82 77 ff ff ff    	jb     802339 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8023c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023c5:	c9                   	leaveq 
  8023c6:	c3                   	retq   

00000000008023c7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8023c7:	55                   	push   %rbp
  8023c8:	48 89 e5             	mov    %rsp,%rbp
  8023cb:	48 83 ec 08          	sub    $0x8,%rsp
  8023cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d8:	c9                   	leaveq 
  8023d9:	c3                   	retq   

00000000008023da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023da:	55                   	push   %rbp
  8023db:	48 89 e5             	mov    %rsp,%rbp
  8023de:	48 83 ec 10          	sub    $0x10,%rsp
  8023e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8023ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ee:	48 be 28 3d 80 00 00 	movabs $0x803d28,%rsi
  8023f5:	00 00 00 
  8023f8:	48 89 c7             	mov    %rax,%rdi
  8023fb:	48 b8 08 32 80 00 00 	movabs $0x803208,%rax
  802402:	00 00 00 
  802405:	ff d0                	callq  *%rax
	return 0;
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240c:	c9                   	leaveq 
  80240d:	c3                   	retq   
	...

0000000000802410 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802410:	55                   	push   %rbp
  802411:	48 89 e5             	mov    %rsp,%rbp
  802414:	53                   	push   %rbx
  802415:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80241c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802423:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802429:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802430:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802437:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80243e:	84 c0                	test   %al,%al
  802440:	74 23                	je     802465 <_panic+0x55>
  802442:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802449:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80244d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802451:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802455:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802459:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80245d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802461:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802465:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80246c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802473:	00 00 00 
  802476:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80247d:	00 00 00 
  802480:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802484:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80248b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802492:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802499:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024a0:	00 00 00 
  8024a3:	48 8b 18             	mov    (%rax),%rbx
  8024a6:	48 b8 c4 02 80 00 00 	movabs $0x8002c4,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	callq  *%rax
  8024b2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8024b8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8024bf:	41 89 c8             	mov    %ecx,%r8d
  8024c2:	48 89 d1             	mov    %rdx,%rcx
  8024c5:	48 89 da             	mov    %rbx,%rdx
  8024c8:	89 c6                	mov    %eax,%esi
  8024ca:	48 bf 30 3d 80 00 00 	movabs $0x803d30,%rdi
  8024d1:	00 00 00 
  8024d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d9:	49 b9 4b 26 80 00 00 	movabs $0x80264b,%r9
  8024e0:	00 00 00 
  8024e3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024e6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8024ed:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8024f4:	48 89 d6             	mov    %rdx,%rsi
  8024f7:	48 89 c7             	mov    %rax,%rdi
  8024fa:	48 b8 9f 25 80 00 00 	movabs $0x80259f,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
	cprintf("\n");
  802506:	48 bf 53 3d 80 00 00 	movabs $0x803d53,%rdi
  80250d:	00 00 00 
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
  802515:	48 ba 4b 26 80 00 00 	movabs $0x80264b,%rdx
  80251c:	00 00 00 
  80251f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802521:	cc                   	int3   
  802522:	eb fd                	jmp    802521 <_panic+0x111>

0000000000802524 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  802524:	55                   	push   %rbp
  802525:	48 89 e5             	mov    %rsp,%rbp
  802528:	48 83 ec 10          	sub    $0x10,%rsp
  80252c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80252f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  802533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802537:	8b 00                	mov    (%rax),%eax
  802539:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80253c:	89 d6                	mov    %edx,%esi
  80253e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802542:	48 63 d0             	movslq %eax,%rdx
  802545:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80254a:	8d 50 01             	lea    0x1(%rax),%edx
  80254d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802551:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  802553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802557:	8b 00                	mov    (%rax),%eax
  802559:	3d ff 00 00 00       	cmp    $0xff,%eax
  80255e:	75 2c                	jne    80258c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  802560:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802564:	8b 00                	mov    (%rax),%eax
  802566:	48 98                	cltq   
  802568:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80256c:	48 83 c2 08          	add    $0x8,%rdx
  802570:	48 89 c6             	mov    %rax,%rsi
  802573:	48 89 d7             	mov    %rdx,%rdi
  802576:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
		b->idx = 0;
  802582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802586:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80258c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802590:	8b 40 04             	mov    0x4(%rax),%eax
  802593:	8d 50 01             	lea    0x1(%rax),%edx
  802596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80259d:	c9                   	leaveq 
  80259e:	c3                   	retq   

000000000080259f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80259f:	55                   	push   %rbp
  8025a0:	48 89 e5             	mov    %rsp,%rbp
  8025a3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8025aa:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8025b1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8025b8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8025bf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8025c6:	48 8b 0a             	mov    (%rdx),%rcx
  8025c9:	48 89 08             	mov    %rcx,(%rax)
  8025cc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8025d0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8025d4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8025d8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8025dc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8025e3:	00 00 00 
	b.cnt = 0;
  8025e6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8025ed:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8025f0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8025f7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8025fe:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802605:	48 89 c6             	mov    %rax,%rsi
  802608:	48 bf 24 25 80 00 00 	movabs $0x802524,%rdi
  80260f:	00 00 00 
  802612:	48 b8 fc 29 80 00 00 	movabs $0x8029fc,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80261e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802624:	48 98                	cltq   
  802626:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80262d:	48 83 c2 08          	add    $0x8,%rdx
  802631:	48 89 c6             	mov    %rax,%rsi
  802634:	48 89 d7             	mov    %rdx,%rdi
  802637:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  80263e:	00 00 00 
  802641:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  802643:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802649:	c9                   	leaveq 
  80264a:	c3                   	retq   

000000000080264b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80264b:	55                   	push   %rbp
  80264c:	48 89 e5             	mov    %rsp,%rbp
  80264f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802656:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80265d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802664:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80266b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802672:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802679:	84 c0                	test   %al,%al
  80267b:	74 20                	je     80269d <cprintf+0x52>
  80267d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802681:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802685:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802689:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80268d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802691:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802695:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802699:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80269d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8026a4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8026ab:	00 00 00 
  8026ae:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8026b5:	00 00 00 
  8026b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8026bc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8026c3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8026ca:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8026d1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8026d8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8026df:	48 8b 0a             	mov    (%rdx),%rcx
  8026e2:	48 89 08             	mov    %rcx,(%rax)
  8026e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8026e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8026ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8026f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8026f5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8026fc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802703:	48 89 d6             	mov    %rdx,%rsi
  802706:	48 89 c7             	mov    %rax,%rdi
  802709:	48 b8 9f 25 80 00 00 	movabs $0x80259f,%rax
  802710:	00 00 00 
  802713:	ff d0                	callq  *%rax
  802715:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80271b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802721:	c9                   	leaveq 
  802722:	c3                   	retq   
	...

0000000000802724 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802724:	55                   	push   %rbp
  802725:	48 89 e5             	mov    %rsp,%rbp
  802728:	48 83 ec 30          	sub    $0x30,%rsp
  80272c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802730:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802734:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802738:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80273b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80273f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802743:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802746:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80274a:	77 52                	ja     80279e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80274c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80274f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802753:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802756:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80275a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80275e:	ba 00 00 00 00       	mov    $0x0,%edx
  802763:	48 f7 75 d0          	divq   -0x30(%rbp)
  802767:	48 89 c2             	mov    %rax,%rdx
  80276a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80276d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802770:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802774:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802778:	41 89 f9             	mov    %edi,%r9d
  80277b:	48 89 c7             	mov    %rax,%rdi
  80277e:	48 b8 24 27 80 00 00 	movabs $0x802724,%rax
  802785:	00 00 00 
  802788:	ff d0                	callq  *%rax
  80278a:	eb 1c                	jmp    8027a8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80278c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802790:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802793:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802797:	48 89 d6             	mov    %rdx,%rsi
  80279a:	89 c7                	mov    %eax,%edi
  80279c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80279e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8027a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8027a6:	7f e4                	jg     80278c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8027a8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8027ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027af:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b4:	48 f7 f1             	div    %rcx
  8027b7:	48 89 d0             	mov    %rdx,%rax
  8027ba:	48 ba 28 3f 80 00 00 	movabs $0x803f28,%rdx
  8027c1:	00 00 00 
  8027c4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8027c8:	0f be c0             	movsbl %al,%eax
  8027cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027cf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8027d3:	48 89 d6             	mov    %rdx,%rsi
  8027d6:	89 c7                	mov    %eax,%edi
  8027d8:	ff d1                	callq  *%rcx
}
  8027da:	c9                   	leaveq 
  8027db:	c3                   	retq   

00000000008027dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8027dc:	55                   	push   %rbp
  8027dd:	48 89 e5             	mov    %rsp,%rbp
  8027e0:	48 83 ec 20          	sub    $0x20,%rsp
  8027e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8027eb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8027ef:	7e 52                	jle    802843 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8027f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f5:	8b 00                	mov    (%rax),%eax
  8027f7:	83 f8 30             	cmp    $0x30,%eax
  8027fa:	73 24                	jae    802820 <getuint+0x44>
  8027fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802800:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802808:	8b 00                	mov    (%rax),%eax
  80280a:	89 c0                	mov    %eax,%eax
  80280c:	48 01 d0             	add    %rdx,%rax
  80280f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802813:	8b 12                	mov    (%rdx),%edx
  802815:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802818:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80281c:	89 0a                	mov    %ecx,(%rdx)
  80281e:	eb 17                	jmp    802837 <getuint+0x5b>
  802820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802824:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802828:	48 89 d0             	mov    %rdx,%rax
  80282b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80282f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802833:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802837:	48 8b 00             	mov    (%rax),%rax
  80283a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80283e:	e9 a3 00 00 00       	jmpq   8028e6 <getuint+0x10a>
	else if (lflag)
  802843:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802847:	74 4f                	je     802898 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284d:	8b 00                	mov    (%rax),%eax
  80284f:	83 f8 30             	cmp    $0x30,%eax
  802852:	73 24                	jae    802878 <getuint+0x9c>
  802854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802858:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80285c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802860:	8b 00                	mov    (%rax),%eax
  802862:	89 c0                	mov    %eax,%eax
  802864:	48 01 d0             	add    %rdx,%rax
  802867:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80286b:	8b 12                	mov    (%rdx),%edx
  80286d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802870:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802874:	89 0a                	mov    %ecx,(%rdx)
  802876:	eb 17                	jmp    80288f <getuint+0xb3>
  802878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802880:	48 89 d0             	mov    %rdx,%rax
  802883:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802887:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80288b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80288f:	48 8b 00             	mov    (%rax),%rax
  802892:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802896:	eb 4e                	jmp    8028e6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289c:	8b 00                	mov    (%rax),%eax
  80289e:	83 f8 30             	cmp    $0x30,%eax
  8028a1:	73 24                	jae    8028c7 <getuint+0xeb>
  8028a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8028ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028af:	8b 00                	mov    (%rax),%eax
  8028b1:	89 c0                	mov    %eax,%eax
  8028b3:	48 01 d0             	add    %rdx,%rax
  8028b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028ba:	8b 12                	mov    (%rdx),%edx
  8028bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8028bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028c3:	89 0a                	mov    %ecx,(%rdx)
  8028c5:	eb 17                	jmp    8028de <getuint+0x102>
  8028c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8028cf:	48 89 d0             	mov    %rdx,%rax
  8028d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8028d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8028de:	8b 00                	mov    (%rax),%eax
  8028e0:	89 c0                	mov    %eax,%eax
  8028e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8028e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8028ea:	c9                   	leaveq 
  8028eb:	c3                   	retq   

00000000008028ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8028ec:	55                   	push   %rbp
  8028ed:	48 89 e5             	mov    %rsp,%rbp
  8028f0:	48 83 ec 20          	sub    $0x20,%rsp
  8028f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8028fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8028ff:	7e 52                	jle    802953 <getint+0x67>
		x=va_arg(*ap, long long);
  802901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802905:	8b 00                	mov    (%rax),%eax
  802907:	83 f8 30             	cmp    $0x30,%eax
  80290a:	73 24                	jae    802930 <getint+0x44>
  80290c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802910:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802918:	8b 00                	mov    (%rax),%eax
  80291a:	89 c0                	mov    %eax,%eax
  80291c:	48 01 d0             	add    %rdx,%rax
  80291f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802923:	8b 12                	mov    (%rdx),%edx
  802925:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802928:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80292c:	89 0a                	mov    %ecx,(%rdx)
  80292e:	eb 17                	jmp    802947 <getint+0x5b>
  802930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802934:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802938:	48 89 d0             	mov    %rdx,%rax
  80293b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80293f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802943:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802947:	48 8b 00             	mov    (%rax),%rax
  80294a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80294e:	e9 a3 00 00 00       	jmpq   8029f6 <getint+0x10a>
	else if (lflag)
  802953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802957:	74 4f                	je     8029a8 <getint+0xbc>
		x=va_arg(*ap, long);
  802959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295d:	8b 00                	mov    (%rax),%eax
  80295f:	83 f8 30             	cmp    $0x30,%eax
  802962:	73 24                	jae    802988 <getint+0x9c>
  802964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802968:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80296c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802970:	8b 00                	mov    (%rax),%eax
  802972:	89 c0                	mov    %eax,%eax
  802974:	48 01 d0             	add    %rdx,%rax
  802977:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80297b:	8b 12                	mov    (%rdx),%edx
  80297d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802984:	89 0a                	mov    %ecx,(%rdx)
  802986:	eb 17                	jmp    80299f <getint+0xb3>
  802988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802990:	48 89 d0             	mov    %rdx,%rax
  802993:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802997:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80299b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80299f:	48 8b 00             	mov    (%rax),%rax
  8029a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8029a6:	eb 4e                	jmp    8029f6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8029a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ac:	8b 00                	mov    (%rax),%eax
  8029ae:	83 f8 30             	cmp    $0x30,%eax
  8029b1:	73 24                	jae    8029d7 <getint+0xeb>
  8029b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8029bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bf:	8b 00                	mov    (%rax),%eax
  8029c1:	89 c0                	mov    %eax,%eax
  8029c3:	48 01 d0             	add    %rdx,%rax
  8029c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ca:	8b 12                	mov    (%rdx),%edx
  8029cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8029cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029d3:	89 0a                	mov    %ecx,(%rdx)
  8029d5:	eb 17                	jmp    8029ee <getint+0x102>
  8029d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8029df:	48 89 d0             	mov    %rdx,%rax
  8029e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8029e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8029ee:	8b 00                	mov    (%rax),%eax
  8029f0:	48 98                	cltq   
  8029f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8029f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8029fa:	c9                   	leaveq 
  8029fb:	c3                   	retq   

00000000008029fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8029fc:	55                   	push   %rbp
  8029fd:	48 89 e5             	mov    %rsp,%rbp
  802a00:	41 54                	push   %r12
  802a02:	53                   	push   %rbx
  802a03:	48 83 ec 60          	sub    $0x60,%rsp
  802a07:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802a0b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802a0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802a13:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802a17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802a1b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802a1f:	48 8b 0a             	mov    (%rdx),%rcx
  802a22:	48 89 08             	mov    %rcx,(%rax)
  802a25:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a29:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a2d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a31:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802a35:	eb 17                	jmp    802a4e <vprintfmt+0x52>
			if (ch == '\0')
  802a37:	85 db                	test   %ebx,%ebx
  802a39:	0f 84 d7 04 00 00    	je     802f16 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  802a3f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802a43:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802a47:	48 89 c6             	mov    %rax,%rsi
  802a4a:	89 df                	mov    %ebx,%edi
  802a4c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802a4e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802a52:	0f b6 00             	movzbl (%rax),%eax
  802a55:	0f b6 d8             	movzbl %al,%ebx
  802a58:	83 fb 25             	cmp    $0x25,%ebx
  802a5b:	0f 95 c0             	setne  %al
  802a5e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802a63:	84 c0                	test   %al,%al
  802a65:	75 d0                	jne    802a37 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802a67:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802a6b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802a72:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802a79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802a80:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  802a87:	eb 04                	jmp    802a8d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  802a89:	90                   	nop
  802a8a:	eb 01                	jmp    802a8d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  802a8c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802a8d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802a91:	0f b6 00             	movzbl (%rax),%eax
  802a94:	0f b6 d8             	movzbl %al,%ebx
  802a97:	89 d8                	mov    %ebx,%eax
  802a99:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802a9e:	83 e8 23             	sub    $0x23,%eax
  802aa1:	83 f8 55             	cmp    $0x55,%eax
  802aa4:	0f 87 38 04 00 00    	ja     802ee2 <vprintfmt+0x4e6>
  802aaa:	89 c0                	mov    %eax,%eax
  802aac:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802ab3:	00 
  802ab4:	48 b8 50 3f 80 00 00 	movabs $0x803f50,%rax
  802abb:	00 00 00 
  802abe:	48 01 d0             	add    %rdx,%rax
  802ac1:	48 8b 00             	mov    (%rax),%rax
  802ac4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  802ac6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802aca:	eb c1                	jmp    802a8d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802acc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802ad0:	eb bb                	jmp    802a8d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802ad2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802ad9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802adc:	89 d0                	mov    %edx,%eax
  802ade:	c1 e0 02             	shl    $0x2,%eax
  802ae1:	01 d0                	add    %edx,%eax
  802ae3:	01 c0                	add    %eax,%eax
  802ae5:	01 d8                	add    %ebx,%eax
  802ae7:	83 e8 30             	sub    $0x30,%eax
  802aea:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802aed:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802af1:	0f b6 00             	movzbl (%rax),%eax
  802af4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802af7:	83 fb 2f             	cmp    $0x2f,%ebx
  802afa:	7e 63                	jle    802b5f <vprintfmt+0x163>
  802afc:	83 fb 39             	cmp    $0x39,%ebx
  802aff:	7f 5e                	jg     802b5f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802b01:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802b06:	eb d1                	jmp    802ad9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  802b08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b0b:	83 f8 30             	cmp    $0x30,%eax
  802b0e:	73 17                	jae    802b27 <vprintfmt+0x12b>
  802b10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b17:	89 c0                	mov    %eax,%eax
  802b19:	48 01 d0             	add    %rdx,%rax
  802b1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802b1f:	83 c2 08             	add    $0x8,%edx
  802b22:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802b25:	eb 0f                	jmp    802b36 <vprintfmt+0x13a>
  802b27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b2b:	48 89 d0             	mov    %rdx,%rax
  802b2e:	48 83 c2 08          	add    $0x8,%rdx
  802b32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802b36:	8b 00                	mov    (%rax),%eax
  802b38:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802b3b:	eb 23                	jmp    802b60 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  802b3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802b41:	0f 89 42 ff ff ff    	jns    802a89 <vprintfmt+0x8d>
				width = 0;
  802b47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802b4e:	e9 36 ff ff ff       	jmpq   802a89 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  802b53:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802b5a:	e9 2e ff ff ff       	jmpq   802a8d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  802b5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  802b60:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802b64:	0f 89 22 ff ff ff    	jns    802a8c <vprintfmt+0x90>
				width = precision, precision = -1;
  802b6a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802b6d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802b70:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802b77:	e9 10 ff ff ff       	jmpq   802a8c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802b7c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802b80:	e9 08 ff ff ff       	jmpq   802a8d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802b85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b88:	83 f8 30             	cmp    $0x30,%eax
  802b8b:	73 17                	jae    802ba4 <vprintfmt+0x1a8>
  802b8d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b94:	89 c0                	mov    %eax,%eax
  802b96:	48 01 d0             	add    %rdx,%rax
  802b99:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802b9c:	83 c2 08             	add    $0x8,%edx
  802b9f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ba2:	eb 0f                	jmp    802bb3 <vprintfmt+0x1b7>
  802ba4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ba8:	48 89 d0             	mov    %rdx,%rax
  802bab:	48 83 c2 08          	add    $0x8,%rdx
  802baf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802bb3:	8b 00                	mov    (%rax),%eax
  802bb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802bb9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  802bbd:	48 89 d6             	mov    %rdx,%rsi
  802bc0:	89 c7                	mov    %eax,%edi
  802bc2:	ff d1                	callq  *%rcx
			break;
  802bc4:	e9 47 03 00 00       	jmpq   802f10 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  802bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802bcc:	83 f8 30             	cmp    $0x30,%eax
  802bcf:	73 17                	jae    802be8 <vprintfmt+0x1ec>
  802bd1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bd5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802bd8:	89 c0                	mov    %eax,%eax
  802bda:	48 01 d0             	add    %rdx,%rax
  802bdd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802be0:	83 c2 08             	add    $0x8,%edx
  802be3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802be6:	eb 0f                	jmp    802bf7 <vprintfmt+0x1fb>
  802be8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802bec:	48 89 d0             	mov    %rdx,%rax
  802bef:	48 83 c2 08          	add    $0x8,%rdx
  802bf3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802bf7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802bf9:	85 db                	test   %ebx,%ebx
  802bfb:	79 02                	jns    802bff <vprintfmt+0x203>
				err = -err;
  802bfd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802bff:	83 fb 10             	cmp    $0x10,%ebx
  802c02:	7f 16                	jg     802c1a <vprintfmt+0x21e>
  802c04:	48 b8 a0 3e 80 00 00 	movabs $0x803ea0,%rax
  802c0b:	00 00 00 
  802c0e:	48 63 d3             	movslq %ebx,%rdx
  802c11:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802c15:	4d 85 e4             	test   %r12,%r12
  802c18:	75 2e                	jne    802c48 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  802c1a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802c1e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c22:	89 d9                	mov    %ebx,%ecx
  802c24:	48 ba 39 3f 80 00 00 	movabs $0x803f39,%rdx
  802c2b:	00 00 00 
  802c2e:	48 89 c7             	mov    %rax,%rdi
  802c31:	b8 00 00 00 00       	mov    $0x0,%eax
  802c36:	49 b8 20 2f 80 00 00 	movabs $0x802f20,%r8
  802c3d:	00 00 00 
  802c40:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802c43:	e9 c8 02 00 00       	jmpq   802f10 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802c48:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802c4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c50:	4c 89 e1             	mov    %r12,%rcx
  802c53:	48 ba 42 3f 80 00 00 	movabs $0x803f42,%rdx
  802c5a:	00 00 00 
  802c5d:	48 89 c7             	mov    %rax,%rdi
  802c60:	b8 00 00 00 00       	mov    $0x0,%eax
  802c65:	49 b8 20 2f 80 00 00 	movabs $0x802f20,%r8
  802c6c:	00 00 00 
  802c6f:	41 ff d0             	callq  *%r8
			break;
  802c72:	e9 99 02 00 00       	jmpq   802f10 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802c77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c7a:	83 f8 30             	cmp    $0x30,%eax
  802c7d:	73 17                	jae    802c96 <vprintfmt+0x29a>
  802c7f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c86:	89 c0                	mov    %eax,%eax
  802c88:	48 01 d0             	add    %rdx,%rax
  802c8b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c8e:	83 c2 08             	add    $0x8,%edx
  802c91:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c94:	eb 0f                	jmp    802ca5 <vprintfmt+0x2a9>
  802c96:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c9a:	48 89 d0             	mov    %rdx,%rax
  802c9d:	48 83 c2 08          	add    $0x8,%rdx
  802ca1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ca5:	4c 8b 20             	mov    (%rax),%r12
  802ca8:	4d 85 e4             	test   %r12,%r12
  802cab:	75 0a                	jne    802cb7 <vprintfmt+0x2bb>
				p = "(null)";
  802cad:	49 bc 45 3f 80 00 00 	movabs $0x803f45,%r12
  802cb4:	00 00 00 
			if (width > 0 && padc != '-')
  802cb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802cbb:	7e 7a                	jle    802d37 <vprintfmt+0x33b>
  802cbd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802cc1:	74 74                	je     802d37 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  802cc3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802cc6:	48 98                	cltq   
  802cc8:	48 89 c6             	mov    %rax,%rsi
  802ccb:	4c 89 e7             	mov    %r12,%rdi
  802cce:	48 b8 ca 31 80 00 00 	movabs $0x8031ca,%rax
  802cd5:	00 00 00 
  802cd8:	ff d0                	callq  *%rax
  802cda:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802cdd:	eb 17                	jmp    802cf6 <vprintfmt+0x2fa>
					putch(padc, putdat);
  802cdf:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  802ce3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ce7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  802ceb:	48 89 d6             	mov    %rdx,%rsi
  802cee:	89 c7                	mov    %eax,%edi
  802cf0:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802cf2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802cf6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802cfa:	7f e3                	jg     802cdf <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802cfc:	eb 39                	jmp    802d37 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  802cfe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802d02:	74 1e                	je     802d22 <vprintfmt+0x326>
  802d04:	83 fb 1f             	cmp    $0x1f,%ebx
  802d07:	7e 05                	jle    802d0e <vprintfmt+0x312>
  802d09:	83 fb 7e             	cmp    $0x7e,%ebx
  802d0c:	7e 14                	jle    802d22 <vprintfmt+0x326>
					putch('?', putdat);
  802d0e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d12:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d16:	48 89 c6             	mov    %rax,%rsi
  802d19:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802d1e:	ff d2                	callq  *%rdx
  802d20:	eb 0f                	jmp    802d31 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  802d22:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d26:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d2a:	48 89 c6             	mov    %rax,%rsi
  802d2d:	89 df                	mov    %ebx,%edi
  802d2f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802d31:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802d35:	eb 01                	jmp    802d38 <vprintfmt+0x33c>
  802d37:	90                   	nop
  802d38:	41 0f b6 04 24       	movzbl (%r12),%eax
  802d3d:	0f be d8             	movsbl %al,%ebx
  802d40:	85 db                	test   %ebx,%ebx
  802d42:	0f 95 c0             	setne  %al
  802d45:	49 83 c4 01          	add    $0x1,%r12
  802d49:	84 c0                	test   %al,%al
  802d4b:	74 28                	je     802d75 <vprintfmt+0x379>
  802d4d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802d51:	78 ab                	js     802cfe <vprintfmt+0x302>
  802d53:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802d57:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802d5b:	79 a1                	jns    802cfe <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802d5d:	eb 16                	jmp    802d75 <vprintfmt+0x379>
				putch(' ', putdat);
  802d5f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d63:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d67:	48 89 c6             	mov    %rax,%rsi
  802d6a:	bf 20 00 00 00       	mov    $0x20,%edi
  802d6f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802d71:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802d75:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d79:	7f e4                	jg     802d5f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  802d7b:	e9 90 01 00 00       	jmpq   802f10 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802d80:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802d84:	be 03 00 00 00       	mov    $0x3,%esi
  802d89:	48 89 c7             	mov    %rax,%rdi
  802d8c:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  802d93:	00 00 00 
  802d96:	ff d0                	callq  *%rax
  802d98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802d9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da0:	48 85 c0             	test   %rax,%rax
  802da3:	79 1d                	jns    802dc2 <vprintfmt+0x3c6>
				putch('-', putdat);
  802da5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802da9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802dad:	48 89 c6             	mov    %rax,%rsi
  802db0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802db5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  802db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbb:	48 f7 d8             	neg    %rax
  802dbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802dc2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802dc9:	e9 d5 00 00 00       	jmpq   802ea3 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802dce:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802dd2:	be 03 00 00 00       	mov    $0x3,%esi
  802dd7:	48 89 c7             	mov    %rax,%rdi
  802dda:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802de1:	00 00 00 
  802de4:	ff d0                	callq  *%rax
  802de6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802dea:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802df1:	e9 ad 00 00 00       	jmpq   802ea3 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  802df6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802dfa:	be 03 00 00 00       	mov    $0x3,%esi
  802dff:	48 89 c7             	mov    %rax,%rdi
  802e02:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
  802e0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  802e12:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  802e19:	e9 85 00 00 00       	jmpq   802ea3 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  802e1e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802e22:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802e26:	48 89 c6             	mov    %rax,%rsi
  802e29:	bf 30 00 00 00       	mov    $0x30,%edi
  802e2e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  802e30:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802e34:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802e38:	48 89 c6             	mov    %rax,%rsi
  802e3b:	bf 78 00 00 00       	mov    $0x78,%edi
  802e40:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802e42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e45:	83 f8 30             	cmp    $0x30,%eax
  802e48:	73 17                	jae    802e61 <vprintfmt+0x465>
  802e4a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e51:	89 c0                	mov    %eax,%eax
  802e53:	48 01 d0             	add    %rdx,%rax
  802e56:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e59:	83 c2 08             	add    $0x8,%edx
  802e5c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802e5f:	eb 0f                	jmp    802e70 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  802e61:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e65:	48 89 d0             	mov    %rdx,%rax
  802e68:	48 83 c2 08          	add    $0x8,%rdx
  802e6c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e70:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802e73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802e77:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802e7e:	eb 23                	jmp    802ea3 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802e80:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e84:	be 03 00 00 00       	mov    $0x3,%esi
  802e89:	48 89 c7             	mov    %rax,%rdi
  802e8c:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802e93:	00 00 00 
  802e96:	ff d0                	callq  *%rax
  802e98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802e9c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802ea3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802ea8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802eab:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802eae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eb2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802eb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802eba:	45 89 c1             	mov    %r8d,%r9d
  802ebd:	41 89 f8             	mov    %edi,%r8d
  802ec0:	48 89 c7             	mov    %rax,%rdi
  802ec3:	48 b8 24 27 80 00 00 	movabs $0x802724,%rax
  802eca:	00 00 00 
  802ecd:	ff d0                	callq  *%rax
			break;
  802ecf:	eb 3f                	jmp    802f10 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802ed1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802ed5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802ed9:	48 89 c6             	mov    %rax,%rsi
  802edc:	89 df                	mov    %ebx,%edi
  802ede:	ff d2                	callq  *%rdx
			break;
  802ee0:	eb 2e                	jmp    802f10 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802ee2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802ee6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802eea:	48 89 c6             	mov    %rax,%rsi
  802eed:	bf 25 00 00 00       	mov    $0x25,%edi
  802ef2:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  802ef4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802ef9:	eb 05                	jmp    802f00 <vprintfmt+0x504>
  802efb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802f00:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802f04:	48 83 e8 01          	sub    $0x1,%rax
  802f08:	0f b6 00             	movzbl (%rax),%eax
  802f0b:	3c 25                	cmp    $0x25,%al
  802f0d:	75 ec                	jne    802efb <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  802f0f:	90                   	nop
		}
	}
  802f10:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802f11:	e9 38 fb ff ff       	jmpq   802a4e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  802f16:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  802f17:	48 83 c4 60          	add    $0x60,%rsp
  802f1b:	5b                   	pop    %rbx
  802f1c:	41 5c                	pop    %r12
  802f1e:	5d                   	pop    %rbp
  802f1f:	c3                   	retq   

0000000000802f20 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802f20:	55                   	push   %rbp
  802f21:	48 89 e5             	mov    %rsp,%rbp
  802f24:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802f2b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802f32:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802f39:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f40:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f47:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f4e:	84 c0                	test   %al,%al
  802f50:	74 20                	je     802f72 <printfmt+0x52>
  802f52:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f56:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f5a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f5e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f62:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f66:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f6a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f6e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f72:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802f79:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802f80:	00 00 00 
  802f83:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802f8a:	00 00 00 
  802f8d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f91:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802f98:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f9f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802fa6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802fad:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802fb4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802fbb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802fc2:	48 89 c7             	mov    %rax,%rdi
  802fc5:	48 b8 fc 29 80 00 00 	movabs $0x8029fc,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
	va_end(ap);
}
  802fd1:	c9                   	leaveq 
  802fd2:	c3                   	retq   

0000000000802fd3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802fd3:	55                   	push   %rbp
  802fd4:	48 89 e5             	mov    %rsp,%rbp
  802fd7:	48 83 ec 10          	sub    $0x10,%rsp
  802fdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe6:	8b 40 10             	mov    0x10(%rax),%eax
  802fe9:	8d 50 01             	lea    0x1(%rax),%edx
  802fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff7:	48 8b 10             	mov    (%rax),%rdx
  802ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffe:	48 8b 40 08          	mov    0x8(%rax),%rax
  803002:	48 39 c2             	cmp    %rax,%rdx
  803005:	73 17                	jae    80301e <sprintputch+0x4b>
		*b->buf++ = ch;
  803007:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300b:	48 8b 00             	mov    (%rax),%rax
  80300e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803011:	88 10                	mov    %dl,(%rax)
  803013:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301b:	48 89 10             	mov    %rdx,(%rax)
}
  80301e:	c9                   	leaveq 
  80301f:	c3                   	retq   

0000000000803020 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803020:	55                   	push   %rbp
  803021:	48 89 e5             	mov    %rsp,%rbp
  803024:	48 83 ec 50          	sub    $0x50,%rsp
  803028:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80302c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80302f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803033:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803037:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80303b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80303f:	48 8b 0a             	mov    (%rdx),%rcx
  803042:	48 89 08             	mov    %rcx,(%rax)
  803045:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803049:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80304d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803051:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803055:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803059:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80305d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803060:	48 98                	cltq   
  803062:	48 83 e8 01          	sub    $0x1,%rax
  803066:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80306a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80306e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803075:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80307a:	74 06                	je     803082 <vsnprintf+0x62>
  80307c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803080:	7f 07                	jg     803089 <vsnprintf+0x69>
		return -E_INVAL;
  803082:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803087:	eb 2f                	jmp    8030b8 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803089:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80308d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803091:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803095:	48 89 c6             	mov    %rax,%rsi
  803098:	48 bf d3 2f 80 00 00 	movabs $0x802fd3,%rdi
  80309f:	00 00 00 
  8030a2:	48 b8 fc 29 80 00 00 	movabs $0x8029fc,%rax
  8030a9:	00 00 00 
  8030ac:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8030ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030b2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8030b5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8030b8:	c9                   	leaveq 
  8030b9:	c3                   	retq   

00000000008030ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8030ba:	55                   	push   %rbp
  8030bb:	48 89 e5             	mov    %rsp,%rbp
  8030be:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8030c5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8030cc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8030d2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8030d9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8030e0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8030e7:	84 c0                	test   %al,%al
  8030e9:	74 20                	je     80310b <snprintf+0x51>
  8030eb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030ef:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030f3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030f7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030fb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030ff:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803103:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803107:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80310b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803112:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803119:	00 00 00 
  80311c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803123:	00 00 00 
  803126:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80312a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803131:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803138:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80313f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803146:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80314d:	48 8b 0a             	mov    (%rdx),%rcx
  803150:	48 89 08             	mov    %rcx,(%rax)
  803153:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803157:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80315b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80315f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803163:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80316a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803171:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803177:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80317e:	48 89 c7             	mov    %rax,%rdi
  803181:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
  80318d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803193:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803199:	c9                   	leaveq 
  80319a:	c3                   	retq   
	...

000000000080319c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80319c:	55                   	push   %rbp
  80319d:	48 89 e5             	mov    %rsp,%rbp
  8031a0:	48 83 ec 18          	sub    $0x18,%rsp
  8031a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8031a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031af:	eb 09                	jmp    8031ba <strlen+0x1e>
		n++;
  8031b1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8031b5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8031ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031be:	0f b6 00             	movzbl (%rax),%eax
  8031c1:	84 c0                	test   %al,%al
  8031c3:	75 ec                	jne    8031b1 <strlen+0x15>
		n++;
	return n;
  8031c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031c8:	c9                   	leaveq 
  8031c9:	c3                   	retq   

00000000008031ca <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8031ca:	55                   	push   %rbp
  8031cb:	48 89 e5             	mov    %rsp,%rbp
  8031ce:	48 83 ec 20          	sub    $0x20,%rsp
  8031d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8031da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031e1:	eb 0e                	jmp    8031f1 <strnlen+0x27>
		n++;
  8031e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8031e7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8031ec:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8031f1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031f6:	74 0b                	je     803203 <strnlen+0x39>
  8031f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fc:	0f b6 00             	movzbl (%rax),%eax
  8031ff:	84 c0                	test   %al,%al
  803201:	75 e0                	jne    8031e3 <strnlen+0x19>
		n++;
	return n;
  803203:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803206:	c9                   	leaveq 
  803207:	c3                   	retq   

0000000000803208 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803208:	55                   	push   %rbp
  803209:	48 89 e5             	mov    %rsp,%rbp
  80320c:	48 83 ec 20          	sub    $0x20,%rsp
  803210:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803214:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803220:	90                   	nop
  803221:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803225:	0f b6 10             	movzbl (%rax),%edx
  803228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80322c:	88 10                	mov    %dl,(%rax)
  80322e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803232:	0f b6 00             	movzbl (%rax),%eax
  803235:	84 c0                	test   %al,%al
  803237:	0f 95 c0             	setne  %al
  80323a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80323f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803244:	84 c0                	test   %al,%al
  803246:	75 d9                	jne    803221 <strcpy+0x19>
		/* do nothing */;
	return ret;
  803248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80324c:	c9                   	leaveq 
  80324d:	c3                   	retq   

000000000080324e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80324e:	55                   	push   %rbp
  80324f:	48 89 e5             	mov    %rsp,%rbp
  803252:	48 83 ec 20          	sub    $0x20,%rsp
  803256:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80325a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80325e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803262:	48 89 c7             	mov    %rax,%rdi
  803265:	48 b8 9c 31 80 00 00 	movabs $0x80319c,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
  803271:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  803274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803277:	48 98                	cltq   
  803279:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80327d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803281:	48 89 d6             	mov    %rdx,%rsi
  803284:	48 89 c7             	mov    %rax,%rdi
  803287:	48 b8 08 32 80 00 00 	movabs $0x803208,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
	return dst;
  803293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803297:	c9                   	leaveq 
  803298:	c3                   	retq   

0000000000803299 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  803299:	55                   	push   %rbp
  80329a:	48 89 e5             	mov    %rsp,%rbp
  80329d:	48 83 ec 28          	sub    $0x28,%rsp
  8032a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8032ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8032b5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032bc:	00 
  8032bd:	eb 27                	jmp    8032e6 <strncpy+0x4d>
		*dst++ = *src;
  8032bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c3:	0f b6 10             	movzbl (%rax),%edx
  8032c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ca:	88 10                	mov    %dl,(%rax)
  8032cc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8032d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032d5:	0f b6 00             	movzbl (%rax),%eax
  8032d8:	84 c0                	test   %al,%al
  8032da:	74 05                	je     8032e1 <strncpy+0x48>
			src++;
  8032dc:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8032e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ea:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8032ee:	72 cf                	jb     8032bf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8032f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032f4:	c9                   	leaveq 
  8032f5:	c3                   	retq   

00000000008032f6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8032f6:	55                   	push   %rbp
  8032f7:	48 89 e5             	mov    %rsp,%rbp
  8032fa:	48 83 ec 28          	sub    $0x28,%rsp
  8032fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803302:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803306:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80330a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80330e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  803312:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803317:	74 37                	je     803350 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  803319:	eb 17                	jmp    803332 <strlcpy+0x3c>
			*dst++ = *src++;
  80331b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80331f:	0f b6 10             	movzbl (%rax),%edx
  803322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803326:	88 10                	mov    %dl,(%rax)
  803328:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80332d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  803332:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  803337:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80333c:	74 0b                	je     803349 <strlcpy+0x53>
  80333e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803342:	0f b6 00             	movzbl (%rax),%eax
  803345:	84 c0                	test   %al,%al
  803347:	75 d2                	jne    80331b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  803349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  803350:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803358:	48 89 d1             	mov    %rdx,%rcx
  80335b:	48 29 c1             	sub    %rax,%rcx
  80335e:	48 89 c8             	mov    %rcx,%rax
}
  803361:	c9                   	leaveq 
  803362:	c3                   	retq   

0000000000803363 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803363:	55                   	push   %rbp
  803364:	48 89 e5             	mov    %rsp,%rbp
  803367:	48 83 ec 10          	sub    $0x10,%rsp
  80336b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80336f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  803373:	eb 0a                	jmp    80337f <strcmp+0x1c>
		p++, q++;
  803375:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80337a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80337f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803383:	0f b6 00             	movzbl (%rax),%eax
  803386:	84 c0                	test   %al,%al
  803388:	74 12                	je     80339c <strcmp+0x39>
  80338a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80338e:	0f b6 10             	movzbl (%rax),%edx
  803391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803395:	0f b6 00             	movzbl (%rax),%eax
  803398:	38 c2                	cmp    %al,%dl
  80339a:	74 d9                	je     803375 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80339c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a0:	0f b6 00             	movzbl (%rax),%eax
  8033a3:	0f b6 d0             	movzbl %al,%edx
  8033a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033aa:	0f b6 00             	movzbl (%rax),%eax
  8033ad:	0f b6 c0             	movzbl %al,%eax
  8033b0:	89 d1                	mov    %edx,%ecx
  8033b2:	29 c1                	sub    %eax,%ecx
  8033b4:	89 c8                	mov    %ecx,%eax
}
  8033b6:	c9                   	leaveq 
  8033b7:	c3                   	retq   

00000000008033b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8033b8:	55                   	push   %rbp
  8033b9:	48 89 e5             	mov    %rsp,%rbp
  8033bc:	48 83 ec 18          	sub    $0x18,%rsp
  8033c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8033cc:	eb 0f                	jmp    8033dd <strncmp+0x25>
		n--, p++, q++;
  8033ce:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8033d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033d8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8033dd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033e2:	74 1d                	je     803401 <strncmp+0x49>
  8033e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e8:	0f b6 00             	movzbl (%rax),%eax
  8033eb:	84 c0                	test   %al,%al
  8033ed:	74 12                	je     803401 <strncmp+0x49>
  8033ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f3:	0f b6 10             	movzbl (%rax),%edx
  8033f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033fa:	0f b6 00             	movzbl (%rax),%eax
  8033fd:	38 c2                	cmp    %al,%dl
  8033ff:	74 cd                	je     8033ce <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  803401:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803406:	75 07                	jne    80340f <strncmp+0x57>
		return 0;
  803408:	b8 00 00 00 00       	mov    $0x0,%eax
  80340d:	eb 1a                	jmp    803429 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80340f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803413:	0f b6 00             	movzbl (%rax),%eax
  803416:	0f b6 d0             	movzbl %al,%edx
  803419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341d:	0f b6 00             	movzbl (%rax),%eax
  803420:	0f b6 c0             	movzbl %al,%eax
  803423:	89 d1                	mov    %edx,%ecx
  803425:	29 c1                	sub    %eax,%ecx
  803427:	89 c8                	mov    %ecx,%eax
}
  803429:	c9                   	leaveq 
  80342a:	c3                   	retq   

000000000080342b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80342b:	55                   	push   %rbp
  80342c:	48 89 e5             	mov    %rsp,%rbp
  80342f:	48 83 ec 10          	sub    $0x10,%rsp
  803433:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803437:	89 f0                	mov    %esi,%eax
  803439:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80343c:	eb 17                	jmp    803455 <strchr+0x2a>
		if (*s == c)
  80343e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803442:	0f b6 00             	movzbl (%rax),%eax
  803445:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803448:	75 06                	jne    803450 <strchr+0x25>
			return (char *) s;
  80344a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80344e:	eb 15                	jmp    803465 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  803450:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803459:	0f b6 00             	movzbl (%rax),%eax
  80345c:	84 c0                	test   %al,%al
  80345e:	75 de                	jne    80343e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803460:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803465:	c9                   	leaveq 
  803466:	c3                   	retq   

0000000000803467 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  803467:	55                   	push   %rbp
  803468:	48 89 e5             	mov    %rsp,%rbp
  80346b:	48 83 ec 10          	sub    $0x10,%rsp
  80346f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803473:	89 f0                	mov    %esi,%eax
  803475:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  803478:	eb 11                	jmp    80348b <strfind+0x24>
		if (*s == c)
  80347a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80347e:	0f b6 00             	movzbl (%rax),%eax
  803481:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803484:	74 12                	je     803498 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  803486:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80348b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80348f:	0f b6 00             	movzbl (%rax),%eax
  803492:	84 c0                	test   %al,%al
  803494:	75 e4                	jne    80347a <strfind+0x13>
  803496:	eb 01                	jmp    803499 <strfind+0x32>
		if (*s == c)
			break;
  803498:	90                   	nop
	return (char *) s;
  803499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80349d:	c9                   	leaveq 
  80349e:	c3                   	retq   

000000000080349f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80349f:	55                   	push   %rbp
  8034a0:	48 89 e5             	mov    %rsp,%rbp
  8034a3:	48 83 ec 18          	sub    $0x18,%rsp
  8034a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034ab:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8034ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8034b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034b7:	75 06                	jne    8034bf <memset+0x20>
		return v;
  8034b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bd:	eb 69                	jmp    803528 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8034bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c3:	83 e0 03             	and    $0x3,%eax
  8034c6:	48 85 c0             	test   %rax,%rax
  8034c9:	75 48                	jne    803513 <memset+0x74>
  8034cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034cf:	83 e0 03             	and    $0x3,%eax
  8034d2:	48 85 c0             	test   %rax,%rax
  8034d5:	75 3c                	jne    803513 <memset+0x74>
		c &= 0xFF;
  8034d7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8034de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034e1:	89 c2                	mov    %eax,%edx
  8034e3:	c1 e2 18             	shl    $0x18,%edx
  8034e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034e9:	c1 e0 10             	shl    $0x10,%eax
  8034ec:	09 c2                	or     %eax,%edx
  8034ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034f1:	c1 e0 08             	shl    $0x8,%eax
  8034f4:	09 d0                	or     %edx,%eax
  8034f6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8034f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034fd:	48 89 c1             	mov    %rax,%rcx
  803500:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  803504:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803508:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80350b:	48 89 d7             	mov    %rdx,%rdi
  80350e:	fc                   	cld    
  80350f:	f3 ab                	rep stos %eax,%es:(%rdi)
  803511:	eb 11                	jmp    803524 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  803513:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803517:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80351a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80351e:	48 89 d7             	mov    %rdx,%rdi
  803521:	fc                   	cld    
  803522:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  803524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803528:	c9                   	leaveq 
  803529:	c3                   	retq   

000000000080352a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80352a:	55                   	push   %rbp
  80352b:	48 89 e5             	mov    %rsp,%rbp
  80352e:	48 83 ec 28          	sub    $0x28,%rsp
  803532:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803536:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80353a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80353e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803542:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  803546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80354e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803552:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803556:	0f 83 88 00 00 00    	jae    8035e4 <memmove+0xba>
  80355c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803560:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803564:	48 01 d0             	add    %rdx,%rax
  803567:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80356b:	76 77                	jbe    8035e4 <memmove+0xba>
		s += n;
  80356d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803571:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  803575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803579:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80357d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803581:	83 e0 03             	and    $0x3,%eax
  803584:	48 85 c0             	test   %rax,%rax
  803587:	75 3b                	jne    8035c4 <memmove+0x9a>
  803589:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358d:	83 e0 03             	and    $0x3,%eax
  803590:	48 85 c0             	test   %rax,%rax
  803593:	75 2f                	jne    8035c4 <memmove+0x9a>
  803595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803599:	83 e0 03             	and    $0x3,%eax
  80359c:	48 85 c0             	test   %rax,%rax
  80359f:	75 23                	jne    8035c4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8035a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a5:	48 83 e8 04          	sub    $0x4,%rax
  8035a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035ad:	48 83 ea 04          	sub    $0x4,%rdx
  8035b1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8035b5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8035b9:	48 89 c7             	mov    %rax,%rdi
  8035bc:	48 89 d6             	mov    %rdx,%rsi
  8035bf:	fd                   	std    
  8035c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8035c2:	eb 1d                	jmp    8035e1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8035c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8035cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8035d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d8:	48 89 d7             	mov    %rdx,%rdi
  8035db:	48 89 c1             	mov    %rax,%rcx
  8035de:	fd                   	std    
  8035df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8035e1:	fc                   	cld    
  8035e2:	eb 57                	jmp    80363b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8035e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e8:	83 e0 03             	and    $0x3,%eax
  8035eb:	48 85 c0             	test   %rax,%rax
  8035ee:	75 36                	jne    803626 <memmove+0xfc>
  8035f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f4:	83 e0 03             	and    $0x3,%eax
  8035f7:	48 85 c0             	test   %rax,%rax
  8035fa:	75 2a                	jne    803626 <memmove+0xfc>
  8035fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803600:	83 e0 03             	and    $0x3,%eax
  803603:	48 85 c0             	test   %rax,%rax
  803606:	75 1e                	jne    803626 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360c:	48 89 c1             	mov    %rax,%rcx
  80360f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803617:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80361b:	48 89 c7             	mov    %rax,%rdi
  80361e:	48 89 d6             	mov    %rdx,%rsi
  803621:	fc                   	cld    
  803622:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803624:	eb 15                	jmp    80363b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80362e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803632:	48 89 c7             	mov    %rax,%rdi
  803635:	48 89 d6             	mov    %rdx,%rsi
  803638:	fc                   	cld    
  803639:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80363b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80363f:	c9                   	leaveq 
  803640:	c3                   	retq   

0000000000803641 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803641:	55                   	push   %rbp
  803642:	48 89 e5             	mov    %rsp,%rbp
  803645:	48 83 ec 18          	sub    $0x18,%rsp
  803649:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80364d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803651:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803655:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803659:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80365d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803661:	48 89 ce             	mov    %rcx,%rsi
  803664:	48 89 c7             	mov    %rax,%rdi
  803667:	48 b8 2a 35 80 00 00 	movabs $0x80352a,%rax
  80366e:	00 00 00 
  803671:	ff d0                	callq  *%rax
}
  803673:	c9                   	leaveq 
  803674:	c3                   	retq   

0000000000803675 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803675:	55                   	push   %rbp
  803676:	48 89 e5             	mov    %rsp,%rbp
  803679:	48 83 ec 28          	sub    $0x28,%rsp
  80367d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803681:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803685:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80368d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803691:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803695:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803699:	eb 38                	jmp    8036d3 <memcmp+0x5e>
		if (*s1 != *s2)
  80369b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80369f:	0f b6 10             	movzbl (%rax),%edx
  8036a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a6:	0f b6 00             	movzbl (%rax),%eax
  8036a9:	38 c2                	cmp    %al,%dl
  8036ab:	74 1c                	je     8036c9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8036ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b1:	0f b6 00             	movzbl (%rax),%eax
  8036b4:	0f b6 d0             	movzbl %al,%edx
  8036b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bb:	0f b6 00             	movzbl (%rax),%eax
  8036be:	0f b6 c0             	movzbl %al,%eax
  8036c1:	89 d1                	mov    %edx,%ecx
  8036c3:	29 c1                	sub    %eax,%ecx
  8036c5:	89 c8                	mov    %ecx,%eax
  8036c7:	eb 20                	jmp    8036e9 <memcmp+0x74>
		s1++, s2++;
  8036c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8036d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8036d8:	0f 95 c0             	setne  %al
  8036db:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8036e0:	84 c0                	test   %al,%al
  8036e2:	75 b7                	jne    80369b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8036e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036e9:	c9                   	leaveq 
  8036ea:	c3                   	retq   

00000000008036eb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8036eb:	55                   	push   %rbp
  8036ec:	48 89 e5             	mov    %rsp,%rbp
  8036ef:	48 83 ec 28          	sub    $0x28,%rsp
  8036f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036f7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8036fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8036fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803702:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803706:	48 01 d0             	add    %rdx,%rax
  803709:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80370d:	eb 13                	jmp    803722 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80370f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803713:	0f b6 10             	movzbl (%rax),%edx
  803716:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803719:	38 c2                	cmp    %al,%dl
  80371b:	74 11                	je     80372e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80371d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803726:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80372a:	72 e3                	jb     80370f <memfind+0x24>
  80372c:	eb 01                	jmp    80372f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80372e:	90                   	nop
	return (void *) s;
  80372f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803733:	c9                   	leaveq 
  803734:	c3                   	retq   

0000000000803735 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803735:	55                   	push   %rbp
  803736:	48 89 e5             	mov    %rsp,%rbp
  803739:	48 83 ec 38          	sub    $0x38,%rsp
  80373d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803741:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803745:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803748:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80374f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803756:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803757:	eb 05                	jmp    80375e <strtol+0x29>
		s++;
  803759:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80375e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803762:	0f b6 00             	movzbl (%rax),%eax
  803765:	3c 20                	cmp    $0x20,%al
  803767:	74 f0                	je     803759 <strtol+0x24>
  803769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376d:	0f b6 00             	movzbl (%rax),%eax
  803770:	3c 09                	cmp    $0x9,%al
  803772:	74 e5                	je     803759 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803778:	0f b6 00             	movzbl (%rax),%eax
  80377b:	3c 2b                	cmp    $0x2b,%al
  80377d:	75 07                	jne    803786 <strtol+0x51>
		s++;
  80377f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803784:	eb 17                	jmp    80379d <strtol+0x68>
	else if (*s == '-')
  803786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80378a:	0f b6 00             	movzbl (%rax),%eax
  80378d:	3c 2d                	cmp    $0x2d,%al
  80378f:	75 0c                	jne    80379d <strtol+0x68>
		s++, neg = 1;
  803791:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803796:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80379d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8037a1:	74 06                	je     8037a9 <strtol+0x74>
  8037a3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8037a7:	75 28                	jne    8037d1 <strtol+0x9c>
  8037a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ad:	0f b6 00             	movzbl (%rax),%eax
  8037b0:	3c 30                	cmp    $0x30,%al
  8037b2:	75 1d                	jne    8037d1 <strtol+0x9c>
  8037b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037b8:	48 83 c0 01          	add    $0x1,%rax
  8037bc:	0f b6 00             	movzbl (%rax),%eax
  8037bf:	3c 78                	cmp    $0x78,%al
  8037c1:	75 0e                	jne    8037d1 <strtol+0x9c>
		s += 2, base = 16;
  8037c3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8037c8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8037cf:	eb 2c                	jmp    8037fd <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8037d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8037d5:	75 19                	jne    8037f0 <strtol+0xbb>
  8037d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037db:	0f b6 00             	movzbl (%rax),%eax
  8037de:	3c 30                	cmp    $0x30,%al
  8037e0:	75 0e                	jne    8037f0 <strtol+0xbb>
		s++, base = 8;
  8037e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8037e7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8037ee:	eb 0d                	jmp    8037fd <strtol+0xc8>
	else if (base == 0)
  8037f0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8037f4:	75 07                	jne    8037fd <strtol+0xc8>
		base = 10;
  8037f6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8037fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803801:	0f b6 00             	movzbl (%rax),%eax
  803804:	3c 2f                	cmp    $0x2f,%al
  803806:	7e 1d                	jle    803825 <strtol+0xf0>
  803808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380c:	0f b6 00             	movzbl (%rax),%eax
  80380f:	3c 39                	cmp    $0x39,%al
  803811:	7f 12                	jg     803825 <strtol+0xf0>
			dig = *s - '0';
  803813:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803817:	0f b6 00             	movzbl (%rax),%eax
  80381a:	0f be c0             	movsbl %al,%eax
  80381d:	83 e8 30             	sub    $0x30,%eax
  803820:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803823:	eb 4e                	jmp    803873 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803825:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803829:	0f b6 00             	movzbl (%rax),%eax
  80382c:	3c 60                	cmp    $0x60,%al
  80382e:	7e 1d                	jle    80384d <strtol+0x118>
  803830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803834:	0f b6 00             	movzbl (%rax),%eax
  803837:	3c 7a                	cmp    $0x7a,%al
  803839:	7f 12                	jg     80384d <strtol+0x118>
			dig = *s - 'a' + 10;
  80383b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383f:	0f b6 00             	movzbl (%rax),%eax
  803842:	0f be c0             	movsbl %al,%eax
  803845:	83 e8 57             	sub    $0x57,%eax
  803848:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80384b:	eb 26                	jmp    803873 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80384d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803851:	0f b6 00             	movzbl (%rax),%eax
  803854:	3c 40                	cmp    $0x40,%al
  803856:	7e 47                	jle    80389f <strtol+0x16a>
  803858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385c:	0f b6 00             	movzbl (%rax),%eax
  80385f:	3c 5a                	cmp    $0x5a,%al
  803861:	7f 3c                	jg     80389f <strtol+0x16a>
			dig = *s - 'A' + 10;
  803863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803867:	0f b6 00             	movzbl (%rax),%eax
  80386a:	0f be c0             	movsbl %al,%eax
  80386d:	83 e8 37             	sub    $0x37,%eax
  803870:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803873:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803876:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803879:	7d 23                	jge    80389e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80387b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803880:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803883:	48 98                	cltq   
  803885:	48 89 c2             	mov    %rax,%rdx
  803888:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80388d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803890:	48 98                	cltq   
  803892:	48 01 d0             	add    %rdx,%rax
  803895:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803899:	e9 5f ff ff ff       	jmpq   8037fd <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80389e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80389f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8038a4:	74 0b                	je     8038b1 <strtol+0x17c>
		*endptr = (char *) s;
  8038a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038ae:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8038b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b5:	74 09                	je     8038c0 <strtol+0x18b>
  8038b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bb:	48 f7 d8             	neg    %rax
  8038be:	eb 04                	jmp    8038c4 <strtol+0x18f>
  8038c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8038c4:	c9                   	leaveq 
  8038c5:	c3                   	retq   

00000000008038c6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8038c6:	55                   	push   %rbp
  8038c7:	48 89 e5             	mov    %rsp,%rbp
  8038ca:	48 83 ec 30          	sub    $0x30,%rsp
  8038ce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8038d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038da:	0f b6 00             	movzbl (%rax),%eax
  8038dd:	88 45 ff             	mov    %al,-0x1(%rbp)
  8038e0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8038e5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8038e9:	75 06                	jne    8038f1 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8038eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ef:	eb 68                	jmp    803959 <strstr+0x93>

    len = strlen(str);
  8038f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f5:	48 89 c7             	mov    %rax,%rdi
  8038f8:	48 b8 9c 31 80 00 00 	movabs $0x80319c,%rax
  8038ff:	00 00 00 
  803902:	ff d0                	callq  *%rax
  803904:	48 98                	cltq   
  803906:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80390a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390e:	0f b6 00             	movzbl (%rax),%eax
  803911:	88 45 ef             	mov    %al,-0x11(%rbp)
  803914:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  803919:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80391d:	75 07                	jne    803926 <strstr+0x60>
                return (char *) 0;
  80391f:	b8 00 00 00 00       	mov    $0x0,%eax
  803924:	eb 33                	jmp    803959 <strstr+0x93>
        } while (sc != c);
  803926:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80392a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80392d:	75 db                	jne    80390a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80392f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803933:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80393b:	48 89 ce             	mov    %rcx,%rsi
  80393e:	48 89 c7             	mov    %rax,%rdi
  803941:	48 b8 b8 33 80 00 00 	movabs $0x8033b8,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
  80394d:	85 c0                	test   %eax,%eax
  80394f:	75 b9                	jne    80390a <strstr+0x44>

    return (char *) (in - 1);
  803951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803955:	48 83 e8 01          	sub    $0x1,%rax
}
  803959:	c9                   	leaveq 
  80395a:	c3                   	retq   
	...

000000000080395c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80395c:	55                   	push   %rbp
  80395d:	48 89 e5             	mov    %rsp,%rbp
  803960:	48 83 ec 30          	sub    $0x30,%rsp
  803964:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803968:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80396c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803970:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803975:	74 18                	je     80398f <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803977:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397b:	48 89 c7             	mov    %rax,%rdi
  80397e:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  803985:	00 00 00 
  803988:	ff d0                	callq  *%rax
  80398a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80398d:	eb 19                	jmp    8039a8 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80398f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803996:	00 00 00 
  803999:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
  8039a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8039a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ac:	79 19                	jns    8039c7 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8039ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8039b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039bc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8039c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c5:	eb 53                	jmp    803a1a <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8039c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039cc:	74 19                	je     8039e7 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8039ce:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8039d5:	00 00 00 
  8039d8:	48 8b 00             	mov    (%rax),%rax
  8039db:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8039e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e5:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8039e7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039ec:	74 19                	je     803a07 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8039ee:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8039f5:	00 00 00 
  8039f8:	48 8b 00             	mov    (%rax),%rax
  8039fb:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a05:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803a07:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803a0e:	00 00 00 
  803a11:	48 8b 00             	mov    (%rax),%rax
  803a14:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803a1a:	c9                   	leaveq 
  803a1b:	c3                   	retq   

0000000000803a1c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a1c:	55                   	push   %rbp
  803a1d:	48 89 e5             	mov    %rsp,%rbp
  803a20:	48 83 ec 30          	sub    $0x30,%rsp
  803a24:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a27:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a2a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a2e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803a31:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803a38:	e9 96 00 00 00       	jmpq   803ad3 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803a3d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a42:	74 20                	je     803a64 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803a44:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a47:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803a4a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803a4e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a51:	89 c7                	mov    %eax,%edi
  803a53:	48 b8 14 05 80 00 00 	movabs $0x800514,%rax
  803a5a:	00 00 00 
  803a5d:	ff d0                	callq  *%rax
  803a5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a62:	eb 2d                	jmp    803a91 <ipc_send+0x75>
		else if(pg==NULL)
  803a64:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a69:	75 26                	jne    803a91 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803a6b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a71:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a76:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a7d:	00 00 00 
  803a80:	89 c7                	mov    %eax,%edi
  803a82:	48 b8 14 05 80 00 00 	movabs $0x800514,%rax
  803a89:	00 00 00 
  803a8c:	ff d0                	callq  *%rax
  803a8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803a91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a95:	79 30                	jns    803ac7 <ipc_send+0xab>
  803a97:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803a9b:	74 2a                	je     803ac7 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803a9d:	48 ba 00 42 80 00 00 	movabs $0x804200,%rdx
  803aa4:	00 00 00 
  803aa7:	be 40 00 00 00       	mov    $0x40,%esi
  803aac:	48 bf 18 42 80 00 00 	movabs $0x804218,%rdi
  803ab3:	00 00 00 
  803ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  803abb:	48 b9 10 24 80 00 00 	movabs $0x802410,%rcx
  803ac2:	00 00 00 
  803ac5:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803ac7:	48 b8 02 03 80 00 00 	movabs $0x800302,%rax
  803ace:	00 00 00 
  803ad1:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803ad3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad7:	0f 85 60 ff ff ff    	jne    803a3d <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803add:	c9                   	leaveq 
  803ade:	c3                   	retq   

0000000000803adf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803adf:	55                   	push   %rbp
  803ae0:	48 89 e5             	mov    %rsp,%rbp
  803ae3:	48 83 ec 18          	sub    $0x18,%rsp
  803ae7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803aea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803af1:	eb 5e                	jmp    803b51 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803af3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803afa:	00 00 00 
  803afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b00:	48 63 d0             	movslq %eax,%rdx
  803b03:	48 89 d0             	mov    %rdx,%rax
  803b06:	48 c1 e0 03          	shl    $0x3,%rax
  803b0a:	48 01 d0             	add    %rdx,%rax
  803b0d:	48 c1 e0 05          	shl    $0x5,%rax
  803b11:	48 01 c8             	add    %rcx,%rax
  803b14:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b1a:	8b 00                	mov    (%rax),%eax
  803b1c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b1f:	75 2c                	jne    803b4d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b21:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b28:	00 00 00 
  803b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2e:	48 63 d0             	movslq %eax,%rdx
  803b31:	48 89 d0             	mov    %rdx,%rax
  803b34:	48 c1 e0 03          	shl    $0x3,%rax
  803b38:	48 01 d0             	add    %rdx,%rax
  803b3b:	48 c1 e0 05          	shl    $0x5,%rax
  803b3f:	48 01 c8             	add    %rcx,%rax
  803b42:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b48:	8b 40 08             	mov    0x8(%rax),%eax
  803b4b:	eb 12                	jmp    803b5f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803b4d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b51:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b58:	7e 99                	jle    803af3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803b5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b5f:	c9                   	leaveq 
  803b60:	c3                   	retq   
  803b61:	00 00                	add    %al,(%rax)
	...

0000000000803b64 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b64:	55                   	push   %rbp
  803b65:	48 89 e5             	mov    %rsp,%rbp
  803b68:	48 83 ec 18          	sub    $0x18,%rsp
  803b6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b74:	48 89 c2             	mov    %rax,%rdx
  803b77:	48 c1 ea 15          	shr    $0x15,%rdx
  803b7b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b82:	01 00 00 
  803b85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b89:	83 e0 01             	and    $0x1,%eax
  803b8c:	48 85 c0             	test   %rax,%rax
  803b8f:	75 07                	jne    803b98 <pageref+0x34>
		return 0;
  803b91:	b8 00 00 00 00       	mov    $0x0,%eax
  803b96:	eb 53                	jmp    803beb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b9c:	48 89 c2             	mov    %rax,%rdx
  803b9f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803ba3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803baa:	01 00 00 
  803bad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bb1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb9:	83 e0 01             	and    $0x1,%eax
  803bbc:	48 85 c0             	test   %rax,%rax
  803bbf:	75 07                	jne    803bc8 <pageref+0x64>
		return 0;
  803bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc6:	eb 23                	jmp    803beb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bcc:	48 89 c2             	mov    %rax,%rdx
  803bcf:	48 c1 ea 0c          	shr    $0xc,%rdx
  803bd3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803bda:	00 00 00 
  803bdd:	48 c1 e2 04          	shl    $0x4,%rdx
  803be1:	48 01 d0             	add    %rdx,%rax
  803be4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803be8:	0f b7 c0             	movzwl %ax,%eax
}
  803beb:	c9                   	leaveq 
  803bec:	c3                   	retq   
