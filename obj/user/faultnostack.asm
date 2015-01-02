
obj/user/faultnostack.debug:     file format elf64-x86-64


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
  80003c:	e8 3b 00 00 00       	callq  80007c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800053:	48 be 68 06 80 00 00 	movabs $0x800668,%rsi
  80005a:	00 00 00 
  80005d:	bf 00 00 00 00       	mov    $0x0,%edi
  800062:	48 b8 b2 04 80 00 00 	movabs $0x8004b2,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  80006e:	b8 00 00 00 00       	mov    $0x0,%eax
  800073:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800079:	c9                   	leaveq 
  80007a:	c3                   	retq   
	...

000000000080007c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007c:	55                   	push   %rbp
  80007d:	48 89 e5             	mov    %rsp,%rbp
  800080:	48 83 ec 10          	sub    $0x10,%rsp
  800084:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800087:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80008b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800092:	00 00 00 
  800095:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80009c:	48 b8 ac 02 80 00 00 	movabs $0x8002ac,%rax
  8000a3:	00 00 00 
  8000a6:	ff d0                	callq  *%rax
  8000a8:	48 98                	cltq   
  8000aa:	48 89 c2             	mov    %rax,%rdx
  8000ad:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8000b3:	48 89 d0             	mov    %rdx,%rax
  8000b6:	48 c1 e0 03          	shl    $0x3,%rax
  8000ba:	48 01 d0             	add    %rdx,%rax
  8000bd:	48 c1 e0 05          	shl    $0x5,%rax
  8000c1:	48 89 c2             	mov    %rax,%rdx
  8000c4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000cb:	00 00 00 
  8000ce:	48 01 c2             	add    %rax,%rdx
  8000d1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8000d8:	00 00 00 
  8000db:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e2:	7e 14                	jle    8000f8 <libmain+0x7c>
		binaryname = argv[0];
  8000e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000e8:	48 8b 10             	mov    (%rax),%rdx
  8000eb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000f2:	00 00 00 
  8000f5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ff:	48 89 d6             	mov    %rdx,%rsi
  800102:	89 c7                	mov    %eax,%edi
  800104:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80010b:	00 00 00 
  80010e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800110:	48 b8 20 01 80 00 00 	movabs $0x800120,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
}
  80011c:	c9                   	leaveq 
  80011d:	c3                   	retq   
	...

0000000000800120 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800120:	55                   	push   %rbp
  800121:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800124:	48 b8 35 0a 80 00 00 	movabs $0x800a35,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800130:	bf 00 00 00 00       	mov    $0x0,%edi
  800135:	48 b8 68 02 80 00 00 	movabs $0x800268,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
}
  800141:	5d                   	pop    %rbp
  800142:	c3                   	retq   
	...

0000000000800144 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800144:	55                   	push   %rbp
  800145:	48 89 e5             	mov    %rsp,%rbp
  800148:	53                   	push   %rbx
  800149:	48 83 ec 58          	sub    $0x58,%rsp
  80014d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800150:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800153:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800157:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80015b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80015f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800163:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%rbp)
  800169:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80016d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800171:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800175:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800179:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80017d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800180:	4c 89 c3             	mov    %r8,%rbx
  800183:	cd 30                	int    $0x30
  800185:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  800189:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80018d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800191:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800195:	74 3e                	je     8001d5 <syscall+0x91>
  800197:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80019c:	7e 37                	jle    8001d5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80019e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8001a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001a5:	49 89 d0             	mov    %rdx,%r8
  8001a8:	89 c1                	mov    %eax,%ecx
  8001aa:	48 ba 4a 3d 80 00 00 	movabs $0x803d4a,%rdx
  8001b1:	00 00 00 
  8001b4:	be 23 00 00 00       	mov    $0x23,%esi
  8001b9:	48 bf 67 3d 80 00 00 	movabs $0x803d67,%rdi
  8001c0:	00 00 00 
  8001c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c8:	49 b9 84 24 80 00 00 	movabs $0x802484,%r9
  8001cf:	00 00 00 
  8001d2:	41 ff d1             	callq  *%r9

	return ret;
  8001d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001d9:	48 83 c4 58          	add    $0x58,%rsp
  8001dd:	5b                   	pop    %rbx
  8001de:	5d                   	pop    %rbp
  8001df:	c3                   	retq   

00000000008001e0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001e0:	55                   	push   %rbp
  8001e1:	48 89 e5             	mov    %rsp,%rbp
  8001e4:	48 83 ec 20          	sub    $0x20,%rsp
  8001e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001ff:	00 
  800200:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800206:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020c:	48 89 d1             	mov    %rdx,%rcx
  80020f:	48 89 c2             	mov    %rax,%rdx
  800212:	be 00 00 00 00       	mov    $0x0,%esi
  800217:	bf 00 00 00 00       	mov    $0x0,%edi
  80021c:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800223:	00 00 00 
  800226:	ff d0                	callq  *%rax
}
  800228:	c9                   	leaveq 
  800229:	c3                   	retq   

000000000080022a <sys_cgetc>:

int
sys_cgetc(void)
{
  80022a:	55                   	push   %rbp
  80022b:	48 89 e5             	mov    %rsp,%rbp
  80022e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800232:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800239:	00 
  80023a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800240:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800246:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024b:	ba 00 00 00 00       	mov    $0x0,%edx
  800250:	be 00 00 00 00       	mov    $0x0,%esi
  800255:	bf 01 00 00 00       	mov    $0x1,%edi
  80025a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
}
  800266:	c9                   	leaveq 
  800267:	c3                   	retq   

0000000000800268 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800268:	55                   	push   %rbp
  800269:	48 89 e5             	mov    %rsp,%rbp
  80026c:	48 83 ec 20          	sub    $0x20,%rsp
  800270:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800273:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800276:	48 98                	cltq   
  800278:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80027f:	00 
  800280:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800286:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80028c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800291:	48 89 c2             	mov    %rax,%rdx
  800294:	be 01 00 00 00       	mov    $0x1,%esi
  800299:	bf 03 00 00 00       	mov    $0x3,%edi
  80029e:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8002a5:	00 00 00 
  8002a8:	ff d0                	callq  *%rax
}
  8002aa:	c9                   	leaveq 
  8002ab:	c3                   	retq   

00000000008002ac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8002ac:	55                   	push   %rbp
  8002ad:	48 89 e5             	mov    %rsp,%rbp
  8002b0:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002bb:	00 
  8002bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d2:	be 00 00 00 00       	mov    $0x0,%esi
  8002d7:	bf 02 00 00 00       	mov    $0x2,%edi
  8002dc:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8002e3:	00 00 00 
  8002e6:	ff d0                	callq  *%rax
}
  8002e8:	c9                   	leaveq 
  8002e9:	c3                   	retq   

00000000008002ea <sys_yield>:

void
sys_yield(void)
{
  8002ea:	55                   	push   %rbp
  8002eb:	48 89 e5             	mov    %rsp,%rbp
  8002ee:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002f9:	00 
  8002fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800300:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800306:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030b:	ba 00 00 00 00       	mov    $0x0,%edx
  800310:	be 00 00 00 00       	mov    $0x0,%esi
  800315:	bf 0b 00 00 00       	mov    $0xb,%edi
  80031a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800321:	00 00 00 
  800324:	ff d0                	callq  *%rax
}
  800326:	c9                   	leaveq 
  800327:	c3                   	retq   

0000000000800328 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800328:	55                   	push   %rbp
  800329:	48 89 e5             	mov    %rsp,%rbp
  80032c:	48 83 ec 20          	sub    $0x20,%rsp
  800330:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800333:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800337:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80033a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80033d:	48 63 c8             	movslq %eax,%rcx
  800340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800344:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800347:	48 98                	cltq   
  800349:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800350:	00 
  800351:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800357:	49 89 c8             	mov    %rcx,%r8
  80035a:	48 89 d1             	mov    %rdx,%rcx
  80035d:	48 89 c2             	mov    %rax,%rdx
  800360:	be 01 00 00 00       	mov    $0x1,%esi
  800365:	bf 04 00 00 00       	mov    $0x4,%edi
  80036a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800371:	00 00 00 
  800374:	ff d0                	callq  *%rax
}
  800376:	c9                   	leaveq 
  800377:	c3                   	retq   

0000000000800378 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800378:	55                   	push   %rbp
  800379:	48 89 e5             	mov    %rsp,%rbp
  80037c:	48 83 ec 30          	sub    $0x30,%rsp
  800380:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800383:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800387:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80038a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80038e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800392:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800395:	48 63 c8             	movslq %eax,%rcx
  800398:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80039c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80039f:	48 63 f0             	movslq %eax,%rsi
  8003a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a9:	48 98                	cltq   
  8003ab:	48 89 0c 24          	mov    %rcx,(%rsp)
  8003af:	49 89 f9             	mov    %rdi,%r9
  8003b2:	49 89 f0             	mov    %rsi,%r8
  8003b5:	48 89 d1             	mov    %rdx,%rcx
  8003b8:	48 89 c2             	mov    %rax,%rdx
  8003bb:	be 01 00 00 00       	mov    $0x1,%esi
  8003c0:	bf 05 00 00 00       	mov    $0x5,%edi
  8003c5:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8003cc:	00 00 00 
  8003cf:	ff d0                	callq  *%rax
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 83 ec 20          	sub    $0x20,%rsp
  8003db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e9:	48 98                	cltq   
  8003eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003f2:	00 
  8003f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003ff:	48 89 d1             	mov    %rdx,%rcx
  800402:	48 89 c2             	mov    %rax,%rdx
  800405:	be 01 00 00 00       	mov    $0x1,%esi
  80040a:	bf 06 00 00 00       	mov    $0x6,%edi
  80040f:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
}
  80041b:	c9                   	leaveq 
  80041c:	c3                   	retq   

000000000080041d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80041d:	55                   	push   %rbp
  80041e:	48 89 e5             	mov    %rsp,%rbp
  800421:	48 83 ec 20          	sub    $0x20,%rsp
  800425:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800428:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80042b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80042e:	48 63 d0             	movslq %eax,%rdx
  800431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800434:	48 98                	cltq   
  800436:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80043d:	00 
  80043e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800444:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80044a:	48 89 d1             	mov    %rdx,%rcx
  80044d:	48 89 c2             	mov    %rax,%rdx
  800450:	be 01 00 00 00       	mov    $0x1,%esi
  800455:	bf 08 00 00 00       	mov    $0x8,%edi
  80045a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800461:	00 00 00 
  800464:	ff d0                	callq  *%rax
}
  800466:	c9                   	leaveq 
  800467:	c3                   	retq   

0000000000800468 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800468:	55                   	push   %rbp
  800469:	48 89 e5             	mov    %rsp,%rbp
  80046c:	48 83 ec 20          	sub    $0x20,%rsp
  800470:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800473:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800477:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80047e:	48 98                	cltq   
  800480:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800487:	00 
  800488:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80048e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800494:	48 89 d1             	mov    %rdx,%rcx
  800497:	48 89 c2             	mov    %rax,%rdx
  80049a:	be 01 00 00 00       	mov    $0x1,%esi
  80049f:	bf 09 00 00 00       	mov    $0x9,%edi
  8004a4:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
}
  8004b0:	c9                   	leaveq 
  8004b1:	c3                   	retq   

00000000008004b2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8004b2:	55                   	push   %rbp
  8004b3:	48 89 e5             	mov    %rsp,%rbp
  8004b6:	48 83 ec 20          	sub    $0x20,%rsp
  8004ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004c8:	48 98                	cltq   
  8004ca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004d1:	00 
  8004d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004de:	48 89 d1             	mov    %rdx,%rcx
  8004e1:	48 89 c2             	mov    %rax,%rdx
  8004e4:	be 01 00 00 00       	mov    $0x1,%esi
  8004e9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004ee:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	callq  *%rax
}
  8004fa:	c9                   	leaveq 
  8004fb:	c3                   	retq   

00000000008004fc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004fc:	55                   	push   %rbp
  8004fd:	48 89 e5             	mov    %rsp,%rbp
  800500:	48 83 ec 30          	sub    $0x30,%rsp
  800504:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800507:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80050b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80050f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800512:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800515:	48 63 f0             	movslq %eax,%rsi
  800518:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80051c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051f:	48 98                	cltq   
  800521:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800525:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80052c:	00 
  80052d:	49 89 f1             	mov    %rsi,%r9
  800530:	49 89 c8             	mov    %rcx,%r8
  800533:	48 89 d1             	mov    %rdx,%rcx
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	be 00 00 00 00       	mov    $0x0,%esi
  80053e:	bf 0c 00 00 00       	mov    $0xc,%edi
  800543:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  80054a:	00 00 00 
  80054d:	ff d0                	callq  *%rax
}
  80054f:	c9                   	leaveq 
  800550:	c3                   	retq   

0000000000800551 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800551:	55                   	push   %rbp
  800552:	48 89 e5             	mov    %rsp,%rbp
  800555:	48 83 ec 20          	sub    $0x20,%rsp
  800559:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80055d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800561:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800568:	00 
  800569:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80056f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800575:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057a:	48 89 c2             	mov    %rax,%rdx
  80057d:	be 01 00 00 00       	mov    $0x1,%esi
  800582:	bf 0d 00 00 00       	mov    $0xd,%edi
  800587:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  80058e:	00 00 00 
  800591:	ff d0                	callq  *%rax
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80059d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005a4:	00 
  8005a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bb:	be 00 00 00 00       	mov    $0x0,%esi
  8005c0:	bf 0e 00 00 00       	mov    $0xe,%edi
  8005c5:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8005cc:	00 00 00 
  8005cf:	ff d0                	callq  *%rax
}
  8005d1:	c9                   	leaveq 
  8005d2:	c3                   	retq   

00000000008005d3 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  8005d3:	55                   	push   %rbp
  8005d4:	48 89 e5             	mov    %rsp,%rbp
  8005d7:	48 83 ec 20          	sub    $0x20,%rsp
  8005db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8005e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005f2:	00 
  8005f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005ff:	48 89 d1             	mov    %rdx,%rcx
  800602:	48 89 c2             	mov    %rax,%rdx
  800605:	be 00 00 00 00       	mov    $0x0,%esi
  80060a:	bf 0f 00 00 00       	mov    $0xf,%edi
  80060f:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800616:	00 00 00 
  800619:	ff d0                	callq  *%rax
}
  80061b:	c9                   	leaveq 
  80061c:	c3                   	retq   

000000000080061d <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  80061d:	55                   	push   %rbp
  80061e:	48 89 e5             	mov    %rsp,%rbp
  800621:	48 83 ec 20          	sub    $0x20,%rsp
  800625:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800629:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  80062d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800631:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800635:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80063c:	00 
  80063d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800643:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800649:	48 89 d1             	mov    %rdx,%rcx
  80064c:	48 89 c2             	mov    %rax,%rdx
  80064f:	be 00 00 00 00       	mov    $0x0,%esi
  800654:	bf 10 00 00 00       	mov    $0x10,%edi
  800659:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800660:	00 00 00 
  800663:	ff d0                	callq  *%rax
}
  800665:	c9                   	leaveq 
  800666:	c3                   	retq   
	...

0000000000800668 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  800668:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80066b:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  800672:	00 00 00 
	call *%rax
  800675:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  800677:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  80067b:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  80067f:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  800682:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  800689:	00 
		movq 120(%rsp), %rcx				// trap time rip
  80068a:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  80068f:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  800692:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  800693:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  800696:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  80069d:	00 08 
		POPA_						// copy the register contents to the registers
  80069f:	4c 8b 3c 24          	mov    (%rsp),%r15
  8006a3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8006a8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8006ad:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8006b2:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8006b7:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8006bc:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8006c1:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8006c6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8006cb:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8006d0:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8006d5:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8006da:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8006df:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8006e4:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8006e9:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  8006ed:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  8006f1:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  8006f2:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  8006f3:	c3                   	retq   

00000000008006f4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8006f4:	55                   	push   %rbp
  8006f5:	48 89 e5             	mov    %rsp,%rbp
  8006f8:	48 83 ec 08          	sub    $0x8,%rsp
  8006fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800700:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800704:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80070b:	ff ff ff 
  80070e:	48 01 d0             	add    %rdx,%rax
  800711:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800715:	c9                   	leaveq 
  800716:	c3                   	retq   

0000000000800717 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800717:	55                   	push   %rbp
  800718:	48 89 e5             	mov    %rsp,%rbp
  80071b:	48 83 ec 08          	sub    $0x8,%rsp
  80071f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800723:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800727:	48 89 c7             	mov    %rax,%rdi
  80072a:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  800731:	00 00 00 
  800734:	ff d0                	callq  *%rax
  800736:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80073c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800740:	c9                   	leaveq 
  800741:	c3                   	retq   

0000000000800742 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800742:	55                   	push   %rbp
  800743:	48 89 e5             	mov    %rsp,%rbp
  800746:	48 83 ec 18          	sub    $0x18,%rsp
  80074a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80074e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800755:	eb 6b                	jmp    8007c2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800757:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80075a:	48 98                	cltq   
  80075c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800762:	48 c1 e0 0c          	shl    $0xc,%rax
  800766:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80076a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80076e:	48 89 c2             	mov    %rax,%rdx
  800771:	48 c1 ea 15          	shr    $0x15,%rdx
  800775:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80077c:	01 00 00 
  80077f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800783:	83 e0 01             	and    $0x1,%eax
  800786:	48 85 c0             	test   %rax,%rax
  800789:	74 21                	je     8007ac <fd_alloc+0x6a>
  80078b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80078f:	48 89 c2             	mov    %rax,%rdx
  800792:	48 c1 ea 0c          	shr    $0xc,%rdx
  800796:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80079d:	01 00 00 
  8007a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007a4:	83 e0 01             	and    $0x1,%eax
  8007a7:	48 85 c0             	test   %rax,%rax
  8007aa:	75 12                	jne    8007be <fd_alloc+0x7c>
			*fd_store = fd;
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007b4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bc:	eb 1a                	jmp    8007d8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8007be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8007c2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8007c6:	7e 8f                	jle    800757 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8007c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8007d3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8007d8:	c9                   	leaveq 
  8007d9:	c3                   	retq   

00000000008007da <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007da:	55                   	push   %rbp
  8007db:	48 89 e5             	mov    %rsp,%rbp
  8007de:	48 83 ec 20          	sub    $0x20,%rsp
  8007e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8007e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8007ed:	78 06                	js     8007f5 <fd_lookup+0x1b>
  8007ef:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8007f3:	7e 07                	jle    8007fc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007fa:	eb 6c                	jmp    800868 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8007fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8007ff:	48 98                	cltq   
  800801:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800807:	48 c1 e0 0c          	shl    $0xc,%rax
  80080b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80080f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800813:	48 89 c2             	mov    %rax,%rdx
  800816:	48 c1 ea 15          	shr    $0x15,%rdx
  80081a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800821:	01 00 00 
  800824:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800828:	83 e0 01             	and    $0x1,%eax
  80082b:	48 85 c0             	test   %rax,%rax
  80082e:	74 21                	je     800851 <fd_lookup+0x77>
  800830:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800834:	48 89 c2             	mov    %rax,%rdx
  800837:	48 c1 ea 0c          	shr    $0xc,%rdx
  80083b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800842:	01 00 00 
  800845:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800849:	83 e0 01             	and    $0x1,%eax
  80084c:	48 85 c0             	test   %rax,%rax
  80084f:	75 07                	jne    800858 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800851:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800856:	eb 10                	jmp    800868 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800858:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800860:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800868:	c9                   	leaveq 
  800869:	c3                   	retq   

000000000080086a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80086a:	55                   	push   %rbp
  80086b:	48 89 e5             	mov    %rsp,%rbp
  80086e:	48 83 ec 30          	sub    $0x30,%rsp
  800872:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800876:	89 f0                	mov    %esi,%eax
  800878:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80087b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80087f:	48 89 c7             	mov    %rax,%rdi
  800882:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  800889:	00 00 00 
  80088c:	ff d0                	callq  *%rax
  80088e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800892:	48 89 d6             	mov    %rdx,%rsi
  800895:	89 c7                	mov    %eax,%edi
  800897:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  80089e:	00 00 00 
  8008a1:	ff d0                	callq  *%rax
  8008a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008aa:	78 0a                	js     8008b6 <fd_close+0x4c>
	    || fd != fd2)
  8008ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8008b4:	74 12                	je     8008c8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8008b6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8008ba:	74 05                	je     8008c1 <fd_close+0x57>
  8008bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008bf:	eb 05                	jmp    8008c6 <fd_close+0x5c>
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	eb 69                	jmp    800931 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8008c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008cc:	8b 00                	mov    (%rax),%eax
  8008ce:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8008d2:	48 89 d6             	mov    %rdx,%rsi
  8008d5:	89 c7                	mov    %eax,%edi
  8008d7:	48 b8 33 09 80 00 00 	movabs $0x800933,%rax
  8008de:	00 00 00 
  8008e1:	ff d0                	callq  *%rax
  8008e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008ea:	78 2a                	js     800916 <fd_close+0xac>
		if (dev->dev_close)
  8008ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8008f4:	48 85 c0             	test   %rax,%rax
  8008f7:	74 16                	je     80090f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800905:	48 89 c7             	mov    %rax,%rdi
  800908:	ff d2                	callq  *%rdx
  80090a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80090d:	eb 07                	jmp    800916 <fd_close+0xac>
		else
			r = 0;
  80090f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80091a:	48 89 c6             	mov    %rax,%rsi
  80091d:	bf 00 00 00 00       	mov    $0x0,%edi
  800922:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  800929:	00 00 00 
  80092c:	ff d0                	callq  *%rax
	return r;
  80092e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800931:	c9                   	leaveq 
  800932:	c3                   	retq   

0000000000800933 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800933:	55                   	push   %rbp
  800934:	48 89 e5             	mov    %rsp,%rbp
  800937:	48 83 ec 20          	sub    $0x20,%rsp
  80093b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80093e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800942:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800949:	eb 41                	jmp    80098c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80094b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800952:	00 00 00 
  800955:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800958:	48 63 d2             	movslq %edx,%rdx
  80095b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80095f:	8b 00                	mov    (%rax),%eax
  800961:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800964:	75 22                	jne    800988 <dev_lookup+0x55>
			*dev = devtab[i];
  800966:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80096d:	00 00 00 
  800970:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800973:	48 63 d2             	movslq %edx,%rdx
  800976:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80097a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80097e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800981:	b8 00 00 00 00       	mov    $0x0,%eax
  800986:	eb 60                	jmp    8009e8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800988:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80098c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800993:	00 00 00 
  800996:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800999:	48 63 d2             	movslq %edx,%rdx
  80099c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009a0:	48 85 c0             	test   %rax,%rax
  8009a3:	75 a6                	jne    80094b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8009a5:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8009ac:	00 00 00 
  8009af:	48 8b 00             	mov    (%rax),%rax
  8009b2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8009b8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8009bb:	89 c6                	mov    %eax,%esi
  8009bd:	48 bf 78 3d 80 00 00 	movabs $0x803d78,%rdi
  8009c4:	00 00 00 
  8009c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cc:	48 b9 bf 26 80 00 00 	movabs $0x8026bf,%rcx
  8009d3:	00 00 00 
  8009d6:	ff d1                	callq  *%rcx
	*dev = 0;
  8009d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009dc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8009e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8009e8:	c9                   	leaveq 
  8009e9:	c3                   	retq   

00000000008009ea <close>:

int
close(int fdnum)
{
  8009ea:	55                   	push   %rbp
  8009eb:	48 89 e5             	mov    %rsp,%rbp
  8009ee:	48 83 ec 20          	sub    $0x20,%rsp
  8009f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8009f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009fc:	48 89 d6             	mov    %rdx,%rsi
  8009ff:	89 c7                	mov    %eax,%edi
  800a01:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  800a08:	00 00 00 
  800a0b:	ff d0                	callq  *%rax
  800a0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a14:	79 05                	jns    800a1b <close+0x31>
		return r;
  800a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a19:	eb 18                	jmp    800a33 <close+0x49>
	else
		return fd_close(fd, 1);
  800a1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a1f:	be 01 00 00 00       	mov    $0x1,%esi
  800a24:	48 89 c7             	mov    %rax,%rdi
  800a27:	48 b8 6a 08 80 00 00 	movabs $0x80086a,%rax
  800a2e:	00 00 00 
  800a31:	ff d0                	callq  *%rax
}
  800a33:	c9                   	leaveq 
  800a34:	c3                   	retq   

0000000000800a35 <close_all>:

void
close_all(void)
{
  800a35:	55                   	push   %rbp
  800a36:	48 89 e5             	mov    %rsp,%rbp
  800a39:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800a3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800a44:	eb 15                	jmp    800a5b <close_all+0x26>
		close(i);
  800a46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a49:	89 c7                	mov    %eax,%edi
  800a4b:	48 b8 ea 09 80 00 00 	movabs $0x8009ea,%rax
  800a52:	00 00 00 
  800a55:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800a57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800a5b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800a5f:	7e e5                	jle    800a46 <close_all+0x11>
		close(i);
}
  800a61:	c9                   	leaveq 
  800a62:	c3                   	retq   

0000000000800a63 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800a63:	55                   	push   %rbp
  800a64:	48 89 e5             	mov    %rsp,%rbp
  800a67:	48 83 ec 40          	sub    $0x40,%rsp
  800a6b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800a6e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800a71:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800a75:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800a78:	48 89 d6             	mov    %rdx,%rsi
  800a7b:	89 c7                	mov    %eax,%edi
  800a7d:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  800a84:	00 00 00 
  800a87:	ff d0                	callq  *%rax
  800a89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a90:	79 08                	jns    800a9a <dup+0x37>
		return r;
  800a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a95:	e9 70 01 00 00       	jmpq   800c0a <dup+0x1a7>
	close(newfdnum);
  800a9a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a9d:	89 c7                	mov    %eax,%edi
  800a9f:	48 b8 ea 09 80 00 00 	movabs $0x8009ea,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800aab:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800aae:	48 98                	cltq   
  800ab0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800ab6:	48 c1 e0 0c          	shl    $0xc,%rax
  800aba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ac2:	48 89 c7             	mov    %rax,%rdi
  800ac5:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  800acc:	00 00 00 
  800acf:	ff d0                	callq  *%rax
  800ad1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad9:	48 89 c7             	mov    %rax,%rdi
  800adc:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  800ae3:	00 00 00 
  800ae6:	ff d0                	callq  *%rax
  800ae8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af0:	48 89 c2             	mov    %rax,%rdx
  800af3:	48 c1 ea 15          	shr    $0x15,%rdx
  800af7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800afe:	01 00 00 
  800b01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b05:	83 e0 01             	and    $0x1,%eax
  800b08:	84 c0                	test   %al,%al
  800b0a:	74 71                	je     800b7d <dup+0x11a>
  800b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b10:	48 89 c2             	mov    %rax,%rdx
  800b13:	48 c1 ea 0c          	shr    $0xc,%rdx
  800b17:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b1e:	01 00 00 
  800b21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b25:	83 e0 01             	and    $0x1,%eax
  800b28:	84 c0                	test   %al,%al
  800b2a:	74 51                	je     800b7d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b30:	48 89 c2             	mov    %rax,%rdx
  800b33:	48 c1 ea 0c          	shr    $0xc,%rdx
  800b37:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b3e:	01 00 00 
  800b41:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b45:	89 c1                	mov    %eax,%ecx
  800b47:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800b4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b55:	41 89 c8             	mov    %ecx,%r8d
  800b58:	48 89 d1             	mov    %rdx,%rcx
  800b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b60:	48 89 c6             	mov    %rax,%rsi
  800b63:	bf 00 00 00 00       	mov    $0x0,%edi
  800b68:	48 b8 78 03 80 00 00 	movabs $0x800378,%rax
  800b6f:	00 00 00 
  800b72:	ff d0                	callq  *%rax
  800b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b7b:	78 56                	js     800bd3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800b7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b81:	48 89 c2             	mov    %rax,%rdx
  800b84:	48 c1 ea 0c          	shr    $0xc,%rdx
  800b88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b8f:	01 00 00 
  800b92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b96:	89 c1                	mov    %eax,%ecx
  800b98:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800b9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ba2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ba6:	41 89 c8             	mov    %ecx,%r8d
  800ba9:	48 89 d1             	mov    %rdx,%rcx
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	48 89 c6             	mov    %rax,%rsi
  800bb4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb9:	48 b8 78 03 80 00 00 	movabs $0x800378,%rax
  800bc0:	00 00 00 
  800bc3:	ff d0                	callq  *%rax
  800bc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bcc:	78 08                	js     800bd6 <dup+0x173>
		goto err;

	return newfdnum;
  800bce:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800bd1:	eb 37                	jmp    800c0a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  800bd3:	90                   	nop
  800bd4:	eb 01                	jmp    800bd7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  800bd6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bdb:	48 89 c6             	mov    %rax,%rsi
  800bde:	bf 00 00 00 00       	mov    $0x0,%edi
  800be3:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  800bea:	00 00 00 
  800bed:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800bef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bf3:	48 89 c6             	mov    %rax,%rsi
  800bf6:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfb:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  800c02:	00 00 00 
  800c05:	ff d0                	callq  *%rax
	return r;
  800c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c0a:	c9                   	leaveq 
  800c0b:	c3                   	retq   

0000000000800c0c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800c0c:	55                   	push   %rbp
  800c0d:	48 89 e5             	mov    %rsp,%rbp
  800c10:	48 83 ec 40          	sub    $0x40,%rsp
  800c14:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800c17:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800c1b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c1f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800c23:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c26:	48 89 d6             	mov    %rdx,%rsi
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  800c32:	00 00 00 
  800c35:	ff d0                	callq  *%rax
  800c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c3e:	78 24                	js     800c64 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c44:	8b 00                	mov    (%rax),%eax
  800c46:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c4a:	48 89 d6             	mov    %rdx,%rsi
  800c4d:	89 c7                	mov    %eax,%edi
  800c4f:	48 b8 33 09 80 00 00 	movabs $0x800933,%rax
  800c56:	00 00 00 
  800c59:	ff d0                	callq  *%rax
  800c5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c62:	79 05                	jns    800c69 <read+0x5d>
		return r;
  800c64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c67:	eb 7a                	jmp    800ce3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800c69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6d:	8b 40 08             	mov    0x8(%rax),%eax
  800c70:	83 e0 03             	and    $0x3,%eax
  800c73:	83 f8 01             	cmp    $0x1,%eax
  800c76:	75 3a                	jne    800cb2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c78:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800c7f:	00 00 00 
  800c82:	48 8b 00             	mov    (%rax),%rax
  800c85:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c8b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c8e:	89 c6                	mov    %eax,%esi
  800c90:	48 bf 97 3d 80 00 00 	movabs $0x803d97,%rdi
  800c97:	00 00 00 
  800c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9f:	48 b9 bf 26 80 00 00 	movabs $0x8026bf,%rcx
  800ca6:	00 00 00 
  800ca9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800cab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb0:	eb 31                	jmp    800ce3 <read+0xd7>
	}
	if (!dev->dev_read)
  800cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb6:	48 8b 40 10          	mov    0x10(%rax),%rax
  800cba:	48 85 c0             	test   %rax,%rax
  800cbd:	75 07                	jne    800cc6 <read+0xba>
		return -E_NOT_SUPP;
  800cbf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800cc4:	eb 1d                	jmp    800ce3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  800cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cca:	4c 8b 40 10          	mov    0x10(%rax),%r8
  800cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800cda:	48 89 ce             	mov    %rcx,%rsi
  800cdd:	48 89 c7             	mov    %rax,%rdi
  800ce0:	41 ff d0             	callq  *%r8
}
  800ce3:	c9                   	leaveq 
  800ce4:	c3                   	retq   

0000000000800ce5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ce5:	55                   	push   %rbp
  800ce6:	48 89 e5             	mov    %rsp,%rbp
  800ce9:	48 83 ec 30          	sub    $0x30,%rsp
  800ced:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cf0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800cf4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cf8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800cff:	eb 46                	jmp    800d47 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d04:	48 98                	cltq   
  800d06:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800d0a:	48 29 c2             	sub    %rax,%rdx
  800d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d10:	48 98                	cltq   
  800d12:	48 89 c1             	mov    %rax,%rcx
  800d15:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  800d19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d1c:	48 89 ce             	mov    %rcx,%rsi
  800d1f:	89 c7                	mov    %eax,%edi
  800d21:	48 b8 0c 0c 80 00 00 	movabs $0x800c0c,%rax
  800d28:	00 00 00 
  800d2b:	ff d0                	callq  *%rax
  800d2d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800d30:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d34:	79 05                	jns    800d3b <readn+0x56>
			return m;
  800d36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d39:	eb 1d                	jmp    800d58 <readn+0x73>
		if (m == 0)
  800d3b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d3f:	74 13                	je     800d54 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d44:	01 45 fc             	add    %eax,-0x4(%rbp)
  800d47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d4a:	48 98                	cltq   
  800d4c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800d50:	72 af                	jb     800d01 <readn+0x1c>
  800d52:	eb 01                	jmp    800d55 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  800d54:	90                   	nop
	}
	return tot;
  800d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800d58:	c9                   	leaveq 
  800d59:	c3                   	retq   

0000000000800d5a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800d5a:	55                   	push   %rbp
  800d5b:	48 89 e5             	mov    %rsp,%rbp
  800d5e:	48 83 ec 40          	sub    $0x40,%rsp
  800d62:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d65:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800d69:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d71:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d74:	48 89 d6             	mov    %rdx,%rsi
  800d77:	89 c7                	mov    %eax,%edi
  800d79:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  800d80:	00 00 00 
  800d83:	ff d0                	callq  *%rax
  800d85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d8c:	78 24                	js     800db2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d92:	8b 00                	mov    (%rax),%eax
  800d94:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d98:	48 89 d6             	mov    %rdx,%rsi
  800d9b:	89 c7                	mov    %eax,%edi
  800d9d:	48 b8 33 09 80 00 00 	movabs $0x800933,%rax
  800da4:	00 00 00 
  800da7:	ff d0                	callq  *%rax
  800da9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800db0:	79 05                	jns    800db7 <write+0x5d>
		return r;
  800db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800db5:	eb 79                	jmp    800e30 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dbb:	8b 40 08             	mov    0x8(%rax),%eax
  800dbe:	83 e0 03             	and    $0x3,%eax
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	75 3a                	jne    800dff <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800dc5:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800dcc:	00 00 00 
  800dcf:	48 8b 00             	mov    (%rax),%rax
  800dd2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800dd8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800ddb:	89 c6                	mov    %eax,%esi
  800ddd:	48 bf b3 3d 80 00 00 	movabs $0x803db3,%rdi
  800de4:	00 00 00 
  800de7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dec:	48 b9 bf 26 80 00 00 	movabs $0x8026bf,%rcx
  800df3:	00 00 00 
  800df6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800df8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dfd:	eb 31                	jmp    800e30 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e03:	48 8b 40 18          	mov    0x18(%rax),%rax
  800e07:	48 85 c0             	test   %rax,%rax
  800e0a:	75 07                	jne    800e13 <write+0xb9>
		return -E_NOT_SUPP;
  800e0c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e11:	eb 1d                	jmp    800e30 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  800e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e17:	4c 8b 40 18          	mov    0x18(%rax),%r8
  800e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e23:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e27:	48 89 ce             	mov    %rcx,%rsi
  800e2a:	48 89 c7             	mov    %rax,%rdi
  800e2d:	41 ff d0             	callq  *%r8
}
  800e30:	c9                   	leaveq 
  800e31:	c3                   	retq   

0000000000800e32 <seek>:

int
seek(int fdnum, off_t offset)
{
  800e32:	55                   	push   %rbp
  800e33:	48 89 e5             	mov    %rsp,%rbp
  800e36:	48 83 ec 18          	sub    $0x18,%rsp
  800e3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800e3d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800e47:	48 89 d6             	mov    %rdx,%rsi
  800e4a:	89 c7                	mov    %eax,%edi
  800e4c:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  800e53:	00 00 00 
  800e56:	ff d0                	callq  *%rax
  800e58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e5f:	79 05                	jns    800e66 <seek+0x34>
		return r;
  800e61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e64:	eb 0f                	jmp    800e75 <seek+0x43>
	fd->fd_offset = offset;
  800e66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800e6d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e75:	c9                   	leaveq 
  800e76:	c3                   	retq   

0000000000800e77 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e77:	55                   	push   %rbp
  800e78:	48 89 e5             	mov    %rsp,%rbp
  800e7b:	48 83 ec 30          	sub    $0x30,%rsp
  800e7f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e82:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e85:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e89:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e8c:	48 89 d6             	mov    %rdx,%rsi
  800e8f:	89 c7                	mov    %eax,%edi
  800e91:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  800e98:	00 00 00 
  800e9b:	ff d0                	callq  *%rax
  800e9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ea0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ea4:	78 24                	js     800eca <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eaa:	8b 00                	mov    (%rax),%eax
  800eac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800eb0:	48 89 d6             	mov    %rdx,%rsi
  800eb3:	89 c7                	mov    %eax,%edi
  800eb5:	48 b8 33 09 80 00 00 	movabs $0x800933,%rax
  800ebc:	00 00 00 
  800ebf:	ff d0                	callq  *%rax
  800ec1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ec4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ec8:	79 05                	jns    800ecf <ftruncate+0x58>
		return r;
  800eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ecd:	eb 72                	jmp    800f41 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed3:	8b 40 08             	mov    0x8(%rax),%eax
  800ed6:	83 e0 03             	and    $0x3,%eax
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	75 3a                	jne    800f17 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800edd:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800ee4:	00 00 00 
  800ee7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800eea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800ef0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800ef3:	89 c6                	mov    %eax,%esi
  800ef5:	48 bf d0 3d 80 00 00 	movabs $0x803dd0,%rdi
  800efc:	00 00 00 
  800eff:	b8 00 00 00 00       	mov    $0x0,%eax
  800f04:	48 b9 bf 26 80 00 00 	movabs $0x8026bf,%rcx
  800f0b:	00 00 00 
  800f0e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800f10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f15:	eb 2a                	jmp    800f41 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800f17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800f1f:	48 85 c0             	test   %rax,%rax
  800f22:	75 07                	jne    800f2b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800f24:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f29:	eb 16                	jmp    800f41 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800f2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  800f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f37:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800f3a:	89 d6                	mov    %edx,%esi
  800f3c:	48 89 c7             	mov    %rax,%rdi
  800f3f:	ff d1                	callq  *%rcx
}
  800f41:	c9                   	leaveq 
  800f42:	c3                   	retq   

0000000000800f43 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800f43:	55                   	push   %rbp
  800f44:	48 89 e5             	mov    %rsp,%rbp
  800f47:	48 83 ec 30          	sub    $0x30,%rsp
  800f4b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800f4e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f52:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800f56:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800f59:	48 89 d6             	mov    %rdx,%rsi
  800f5c:	89 c7                	mov    %eax,%edi
  800f5e:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  800f65:	00 00 00 
  800f68:	ff d0                	callq  *%rax
  800f6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f71:	78 24                	js     800f97 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f77:	8b 00                	mov    (%rax),%eax
  800f79:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f7d:	48 89 d6             	mov    %rdx,%rsi
  800f80:	89 c7                	mov    %eax,%edi
  800f82:	48 b8 33 09 80 00 00 	movabs $0x800933,%rax
  800f89:	00 00 00 
  800f8c:	ff d0                	callq  *%rax
  800f8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f95:	79 05                	jns    800f9c <fstat+0x59>
		return r;
  800f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f9a:	eb 5e                	jmp    800ffa <fstat+0xb7>
	if (!dev->dev_stat)
  800f9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa0:	48 8b 40 28          	mov    0x28(%rax),%rax
  800fa4:	48 85 c0             	test   %rax,%rax
  800fa7:	75 07                	jne    800fb0 <fstat+0x6d>
		return -E_NOT_SUPP;
  800fa9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800fae:	eb 4a                	jmp    800ffa <fstat+0xb7>
	stat->st_name[0] = 0;
  800fb0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fb4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800fb7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800fc2:	00 00 00 
	stat->st_isdir = 0;
  800fc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fc9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800fd0:	00 00 00 
	stat->st_dev = dev;
  800fd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fdb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  800fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fee:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800ff2:	48 89 d6             	mov    %rdx,%rsi
  800ff5:	48 89 c7             	mov    %rax,%rdi
  800ff8:	ff d1                	callq  *%rcx
}
  800ffa:	c9                   	leaveq 
  800ffb:	c3                   	retq   

0000000000800ffc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800ffc:	55                   	push   %rbp
  800ffd:	48 89 e5             	mov    %rsp,%rbp
  801000:	48 83 ec 20          	sub    $0x20,%rsp
  801004:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801008:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80100c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801010:	be 00 00 00 00       	mov    $0x0,%esi
  801015:	48 89 c7             	mov    %rax,%rdi
  801018:	48 b8 eb 10 80 00 00 	movabs $0x8010eb,%rax
  80101f:	00 00 00 
  801022:	ff d0                	callq  *%rax
  801024:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801027:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80102b:	79 05                	jns    801032 <stat+0x36>
		return fd;
  80102d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801030:	eb 2f                	jmp    801061 <stat+0x65>
	r = fstat(fd, stat);
  801032:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801039:	48 89 d6             	mov    %rdx,%rsi
  80103c:	89 c7                	mov    %eax,%edi
  80103e:	48 b8 43 0f 80 00 00 	movabs $0x800f43,%rax
  801045:	00 00 00 
  801048:	ff d0                	callq  *%rax
  80104a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80104d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801050:	89 c7                	mov    %eax,%edi
  801052:	48 b8 ea 09 80 00 00 	movabs $0x8009ea,%rax
  801059:	00 00 00 
  80105c:	ff d0                	callq  *%rax
	return r;
  80105e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801061:	c9                   	leaveq 
  801062:	c3                   	retq   
	...

0000000000801064 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801064:	55                   	push   %rbp
  801065:	48 89 e5             	mov    %rsp,%rbp
  801068:	48 83 ec 10          	sub    $0x10,%rsp
  80106c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80106f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801073:	48 b8 18 70 80 00 00 	movabs $0x807018,%rax
  80107a:	00 00 00 
  80107d:	8b 00                	mov    (%rax),%eax
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 1d                	jne    8010a0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801083:	bf 01 00 00 00       	mov    $0x1,%edi
  801088:	48 b8 17 3c 80 00 00 	movabs $0x803c17,%rax
  80108f:	00 00 00 
  801092:	ff d0                	callq  *%rax
  801094:	48 ba 18 70 80 00 00 	movabs $0x807018,%rdx
  80109b:	00 00 00 
  80109e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8010a0:	48 b8 18 70 80 00 00 	movabs $0x807018,%rax
  8010a7:	00 00 00 
  8010aa:	8b 00                	mov    (%rax),%eax
  8010ac:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8010af:	b9 07 00 00 00       	mov    $0x7,%ecx
  8010b4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8010bb:	00 00 00 
  8010be:	89 c7                	mov    %eax,%edi
  8010c0:	48 b8 54 3b 80 00 00 	movabs $0x803b54,%rax
  8010c7:	00 00 00 
  8010ca:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8010cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d5:	48 89 c6             	mov    %rax,%rsi
  8010d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8010dd:	48 b8 94 3a 80 00 00 	movabs $0x803a94,%rax
  8010e4:	00 00 00 
  8010e7:	ff d0                	callq  *%rax
}
  8010e9:	c9                   	leaveq 
  8010ea:	c3                   	retq   

00000000008010eb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8010eb:	55                   	push   %rbp
  8010ec:	48 89 e5             	mov    %rsp,%rbp
  8010ef:	48 83 ec 20          	sub    $0x20,%rsp
  8010f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8010fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fe:	48 89 c7             	mov    %rax,%rdi
  801101:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  801108:	00 00 00 
  80110b:	ff d0                	callq  *%rax
  80110d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801112:	7e 0a                	jle    80111e <open+0x33>
                return -E_BAD_PATH;
  801114:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801119:	e9 a5 00 00 00       	jmpq   8011c3 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80111e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801122:	48 89 c7             	mov    %rax,%rdi
  801125:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  80112c:	00 00 00 
  80112f:	ff d0                	callq  *%rax
  801131:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801134:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801138:	79 08                	jns    801142 <open+0x57>
		return r;
  80113a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80113d:	e9 81 00 00 00       	jmpq   8011c3 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  801142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801146:	48 89 c6             	mov    %rax,%rsi
  801149:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801150:	00 00 00 
  801153:	48 b8 7c 32 80 00 00 	movabs $0x80327c,%rax
  80115a:	00 00 00 
  80115d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80115f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801166:	00 00 00 
  801169:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80116c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  801172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801176:	48 89 c6             	mov    %rax,%rsi
  801179:	bf 01 00 00 00       	mov    $0x1,%edi
  80117e:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  801185:	00 00 00 
  801188:	ff d0                	callq  *%rax
  80118a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  80118d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801191:	79 1d                	jns    8011b0 <open+0xc5>
	{
		fd_close(fd,0);
  801193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801197:	be 00 00 00 00       	mov    $0x0,%esi
  80119c:	48 89 c7             	mov    %rax,%rdi
  80119f:	48 b8 6a 08 80 00 00 	movabs $0x80086a,%rax
  8011a6:	00 00 00 
  8011a9:	ff d0                	callq  *%rax
		return r;
  8011ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ae:	eb 13                	jmp    8011c3 <open+0xd8>
	}
	return fd2num(fd);
  8011b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b4:	48 89 c7             	mov    %rax,%rdi
  8011b7:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  8011be:	00 00 00 
  8011c1:	ff d0                	callq  *%rax
	


}
  8011c3:	c9                   	leaveq 
  8011c4:	c3                   	retq   

00000000008011c5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8011c5:	55                   	push   %rbp
  8011c6:	48 89 e5             	mov    %rsp,%rbp
  8011c9:	48 83 ec 10          	sub    $0x10,%rsp
  8011cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	8b 50 0c             	mov    0xc(%rax),%edx
  8011d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011df:	00 00 00 
  8011e2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8011e4:	be 00 00 00 00       	mov    $0x0,%esi
  8011e9:	bf 06 00 00 00       	mov    $0x6,%edi
  8011ee:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  8011f5:	00 00 00 
  8011f8:	ff d0                	callq  *%rax
}
  8011fa:	c9                   	leaveq 
  8011fb:	c3                   	retq   

00000000008011fc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8011fc:	55                   	push   %rbp
  8011fd:	48 89 e5             	mov    %rsp,%rbp
  801200:	48 83 ec 30          	sub    $0x30,%rsp
  801204:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801208:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80120c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801214:	8b 50 0c             	mov    0xc(%rax),%edx
  801217:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80121e:	00 00 00 
  801221:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801223:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80122a:	00 00 00 
  80122d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801231:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801235:	be 00 00 00 00       	mov    $0x0,%esi
  80123a:	bf 03 00 00 00       	mov    $0x3,%edi
  80123f:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  801246:	00 00 00 
  801249:	ff d0                	callq  *%rax
  80124b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80124e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801252:	79 05                	jns    801259 <devfile_read+0x5d>
	{
		return r;
  801254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801257:	eb 2c                	jmp    801285 <devfile_read+0x89>
	}
	if(r > 0)
  801259:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80125d:	7e 23                	jle    801282 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80125f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801262:	48 63 d0             	movslq %eax,%rdx
  801265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801269:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801270:	00 00 00 
  801273:	48 89 c7             	mov    %rax,%rdi
  801276:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  80127d:	00 00 00 
  801280:	ff d0                	callq  *%rax
	return r;
  801282:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  801285:	c9                   	leaveq 
  801286:	c3                   	retq   

0000000000801287 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801287:	55                   	push   %rbp
  801288:	48 89 e5             	mov    %rsp,%rbp
  80128b:	48 83 ec 30          	sub    $0x30,%rsp
  80128f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801293:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801297:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80129b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129f:	8b 50 0c             	mov    0xc(%rax),%edx
  8012a2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012a9:	00 00 00 
  8012ac:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8012ae:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8012b5:	00 
  8012b6:	76 08                	jbe    8012c0 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8012b8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8012bf:	00 
	fsipcbuf.write.req_n=n;
  8012c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012c7:	00 00 00 
  8012ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8012ce:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8012d2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8012d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012da:	48 89 c6             	mov    %rax,%rsi
  8012dd:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8012e4:	00 00 00 
  8012e7:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  8012ee:	00 00 00 
  8012f1:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8012f3:	be 00 00 00 00       	mov    $0x0,%esi
  8012f8:	bf 04 00 00 00       	mov    $0x4,%edi
  8012fd:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  801304:	00 00 00 
  801307:	ff d0                	callq  *%rax
  801309:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  80130c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80130f:	c9                   	leaveq 
  801310:	c3                   	retq   

0000000000801311 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	48 83 ec 10          	sub    $0x10,%rsp
  801319:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801324:	8b 50 0c             	mov    0xc(%rax),%edx
  801327:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80132e:	00 00 00 
  801331:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  801333:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80133a:	00 00 00 
  80133d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801340:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801343:	be 00 00 00 00       	mov    $0x0,%esi
  801348:	bf 02 00 00 00       	mov    $0x2,%edi
  80134d:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  801354:	00 00 00 
  801357:	ff d0                	callq  *%rax
}
  801359:	c9                   	leaveq 
  80135a:	c3                   	retq   

000000000080135b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80135b:	55                   	push   %rbp
  80135c:	48 89 e5             	mov    %rsp,%rbp
  80135f:	48 83 ec 20          	sub    $0x20,%rsp
  801363:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801367:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80136b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136f:	8b 50 0c             	mov    0xc(%rax),%edx
  801372:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801379:	00 00 00 
  80137c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80137e:	be 00 00 00 00       	mov    $0x0,%esi
  801383:	bf 05 00 00 00       	mov    $0x5,%edi
  801388:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  80138f:	00 00 00 
  801392:	ff d0                	callq  *%rax
  801394:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801397:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80139b:	79 05                	jns    8013a2 <devfile_stat+0x47>
		return r;
  80139d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013a0:	eb 56                	jmp    8013f8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8013ad:	00 00 00 
  8013b0:	48 89 c7             	mov    %rax,%rdi
  8013b3:	48 b8 7c 32 80 00 00 	movabs $0x80327c,%rax
  8013ba:	00 00 00 
  8013bd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8013bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013c6:	00 00 00 
  8013c9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8013cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013d9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013e0:	00 00 00 
  8013e3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8013e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ed:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8013f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f8:	c9                   	leaveq 
  8013f9:	c3                   	retq   
	...

00000000008013fc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8013fc:	55                   	push   %rbp
  8013fd:	48 89 e5             	mov    %rsp,%rbp
  801400:	48 83 ec 20          	sub    $0x20,%rsp
  801404:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801407:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80140b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80140e:	48 89 d6             	mov    %rdx,%rsi
  801411:	89 c7                	mov    %eax,%edi
  801413:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  80141a:	00 00 00 
  80141d:	ff d0                	callq  *%rax
  80141f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801422:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801426:	79 05                	jns    80142d <fd2sockid+0x31>
		return r;
  801428:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80142b:	eb 24                	jmp    801451 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80142d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801431:	8b 10                	mov    (%rax),%edx
  801433:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80143a:	00 00 00 
  80143d:	8b 00                	mov    (%rax),%eax
  80143f:	39 c2                	cmp    %eax,%edx
  801441:	74 07                	je     80144a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801443:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801448:	eb 07                	jmp    801451 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80144a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801451:	c9                   	leaveq 
  801452:	c3                   	retq   

0000000000801453 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801453:	55                   	push   %rbp
  801454:	48 89 e5             	mov    %rsp,%rbp
  801457:	48 83 ec 20          	sub    $0x20,%rsp
  80145b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80145e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801462:	48 89 c7             	mov    %rax,%rdi
  801465:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  80146c:	00 00 00 
  80146f:	ff d0                	callq  *%rax
  801471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801478:	78 26                	js     8014a0 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80147a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147e:	ba 07 04 00 00       	mov    $0x407,%edx
  801483:	48 89 c6             	mov    %rax,%rsi
  801486:	bf 00 00 00 00       	mov    $0x0,%edi
  80148b:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  801492:	00 00 00 
  801495:	ff d0                	callq  *%rax
  801497:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80149a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80149e:	79 16                	jns    8014b6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8014a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014a3:	89 c7                	mov    %eax,%edi
  8014a5:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8014ac:	00 00 00 
  8014af:	ff d0                	callq  *%rax
		return r;
  8014b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014b4:	eb 3a                	jmp    8014f0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8014b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ba:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8014c1:	00 00 00 
  8014c4:	8b 12                	mov    (%rdx),%edx
  8014c6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8014c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8014d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8014da:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8014dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e1:	48 89 c7             	mov    %rax,%rdi
  8014e4:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  8014eb:	00 00 00 
  8014ee:	ff d0                	callq  *%rax
}
  8014f0:	c9                   	leaveq 
  8014f1:	c3                   	retq   

00000000008014f2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8014f2:	55                   	push   %rbp
  8014f3:	48 89 e5             	mov    %rsp,%rbp
  8014f6:	48 83 ec 30          	sub    $0x30,%rsp
  8014fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801501:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801505:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801508:	89 c7                	mov    %eax,%edi
  80150a:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  801511:	00 00 00 
  801514:	ff d0                	callq  *%rax
  801516:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801519:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80151d:	79 05                	jns    801524 <accept+0x32>
		return r;
  80151f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801522:	eb 3b                	jmp    80155f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801524:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801528:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80152c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80152f:	48 89 ce             	mov    %rcx,%rsi
  801532:	89 c7                	mov    %eax,%edi
  801534:	48 b8 3d 18 80 00 00 	movabs $0x80183d,%rax
  80153b:	00 00 00 
  80153e:	ff d0                	callq  *%rax
  801540:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801543:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801547:	79 05                	jns    80154e <accept+0x5c>
		return r;
  801549:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80154c:	eb 11                	jmp    80155f <accept+0x6d>
	return alloc_sockfd(r);
  80154e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801551:	89 c7                	mov    %eax,%edi
  801553:	48 b8 53 14 80 00 00 	movabs $0x801453,%rax
  80155a:	00 00 00 
  80155d:	ff d0                	callq  *%rax
}
  80155f:	c9                   	leaveq 
  801560:	c3                   	retq   

0000000000801561 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801561:	55                   	push   %rbp
  801562:	48 89 e5             	mov    %rsp,%rbp
  801565:	48 83 ec 20          	sub    $0x20,%rsp
  801569:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80156c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801570:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801573:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801576:	89 c7                	mov    %eax,%edi
  801578:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  80157f:	00 00 00 
  801582:	ff d0                	callq  *%rax
  801584:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80158b:	79 05                	jns    801592 <bind+0x31>
		return r;
  80158d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801590:	eb 1b                	jmp    8015ad <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801592:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801595:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80159c:	48 89 ce             	mov    %rcx,%rsi
  80159f:	89 c7                	mov    %eax,%edi
  8015a1:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  8015a8:	00 00 00 
  8015ab:	ff d0                	callq  *%rax
}
  8015ad:	c9                   	leaveq 
  8015ae:	c3                   	retq   

00000000008015af <shutdown>:

int
shutdown(int s, int how)
{
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	48 83 ec 20          	sub    $0x20,%rsp
  8015b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8015ba:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8015bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015c0:	89 c7                	mov    %eax,%edi
  8015c2:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  8015c9:	00 00 00 
  8015cc:	ff d0                	callq  *%rax
  8015ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015d5:	79 05                	jns    8015dc <shutdown+0x2d>
		return r;
  8015d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015da:	eb 16                	jmp    8015f2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8015dc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8015df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015e2:	89 d6                	mov    %edx,%esi
  8015e4:	89 c7                	mov    %eax,%edi
  8015e6:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8015ed:	00 00 00 
  8015f0:	ff d0                	callq  *%rax
}
  8015f2:	c9                   	leaveq 
  8015f3:	c3                   	retq   

00000000008015f4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8015f4:	55                   	push   %rbp
  8015f5:	48 89 e5             	mov    %rsp,%rbp
  8015f8:	48 83 ec 10          	sub    $0x10,%rsp
  8015fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801604:	48 89 c7             	mov    %rax,%rdi
  801607:	48 b8 9c 3c 80 00 00 	movabs $0x803c9c,%rax
  80160e:	00 00 00 
  801611:	ff d0                	callq  *%rax
  801613:	83 f8 01             	cmp    $0x1,%eax
  801616:	75 17                	jne    80162f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161c:	8b 40 0c             	mov    0xc(%rax),%eax
  80161f:	89 c7                	mov    %eax,%edi
  801621:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  801628:	00 00 00 
  80162b:	ff d0                	callq  *%rax
  80162d:	eb 05                	jmp    801634 <devsock_close+0x40>
	else
		return 0;
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801634:	c9                   	leaveq 
  801635:	c3                   	retq   

0000000000801636 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	48 83 ec 20          	sub    $0x20,%rsp
  80163e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801641:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801645:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801648:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80164b:	89 c7                	mov    %eax,%edi
  80164d:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  801654:	00 00 00 
  801657:	ff d0                	callq  *%rax
  801659:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80165c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801660:	79 05                	jns    801667 <connect+0x31>
		return r;
  801662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801665:	eb 1b                	jmp    801682 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  801667:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80166a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80166e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801671:	48 89 ce             	mov    %rcx,%rsi
  801674:	89 c7                	mov    %eax,%edi
  801676:	48 b8 8d 19 80 00 00 	movabs $0x80198d,%rax
  80167d:	00 00 00 
  801680:	ff d0                	callq  *%rax
}
  801682:	c9                   	leaveq 
  801683:	c3                   	retq   

0000000000801684 <listen>:

int
listen(int s, int backlog)
{
  801684:	55                   	push   %rbp
  801685:	48 89 e5             	mov    %rsp,%rbp
  801688:	48 83 ec 20          	sub    $0x20,%rsp
  80168c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80168f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801692:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801695:	89 c7                	mov    %eax,%edi
  801697:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  80169e:	00 00 00 
  8016a1:	ff d0                	callq  *%rax
  8016a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016aa:	79 05                	jns    8016b1 <listen+0x2d>
		return r;
  8016ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016af:	eb 16                	jmp    8016c7 <listen+0x43>
	return nsipc_listen(r, backlog);
  8016b1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8016b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016b7:	89 d6                	mov    %edx,%esi
  8016b9:	89 c7                	mov    %eax,%edi
  8016bb:	48 b8 f1 19 80 00 00 	movabs $0x8019f1,%rax
  8016c2:	00 00 00 
  8016c5:	ff d0                	callq  *%rax
}
  8016c7:	c9                   	leaveq 
  8016c8:	c3                   	retq   

00000000008016c9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8016c9:	55                   	push   %rbp
  8016ca:	48 89 e5             	mov    %rsp,%rbp
  8016cd:	48 83 ec 20          	sub    $0x20,%rsp
  8016d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8016dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e1:	89 c2                	mov    %eax,%edx
  8016e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e7:	8b 40 0c             	mov    0xc(%rax),%eax
  8016ea:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8016ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f3:	89 c7                	mov    %eax,%edi
  8016f5:	48 b8 31 1a 80 00 00 	movabs $0x801a31,%rax
  8016fc:	00 00 00 
  8016ff:	ff d0                	callq  *%rax
}
  801701:	c9                   	leaveq 
  801702:	c3                   	retq   

0000000000801703 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801703:	55                   	push   %rbp
  801704:	48 89 e5             	mov    %rsp,%rbp
  801707:	48 83 ec 20          	sub    $0x20,%rsp
  80170b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80170f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801713:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171b:	89 c2                	mov    %eax,%edx
  80171d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801721:	8b 40 0c             	mov    0xc(%rax),%eax
  801724:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172d:	89 c7                	mov    %eax,%edi
  80172f:	48 b8 fd 1a 80 00 00 	movabs $0x801afd,%rax
  801736:	00 00 00 
  801739:	ff d0                	callq  *%rax
}
  80173b:	c9                   	leaveq 
  80173c:	c3                   	retq   

000000000080173d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80173d:	55                   	push   %rbp
  80173e:	48 89 e5             	mov    %rsp,%rbp
  801741:	48 83 ec 10          	sub    $0x10,%rsp
  801745:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801749:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80174d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801751:	48 be fb 3d 80 00 00 	movabs $0x803dfb,%rsi
  801758:	00 00 00 
  80175b:	48 89 c7             	mov    %rax,%rdi
  80175e:	48 b8 7c 32 80 00 00 	movabs $0x80327c,%rax
  801765:	00 00 00 
  801768:	ff d0                	callq  *%rax
	return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176f:	c9                   	leaveq 
  801770:	c3                   	retq   

0000000000801771 <socket>:

int
socket(int domain, int type, int protocol)
{
  801771:	55                   	push   %rbp
  801772:	48 89 e5             	mov    %rsp,%rbp
  801775:	48 83 ec 20          	sub    $0x20,%rsp
  801779:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80177c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80177f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801782:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801785:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801788:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80178b:	89 ce                	mov    %ecx,%esi
  80178d:	89 c7                	mov    %eax,%edi
  80178f:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  801796:	00 00 00 
  801799:	ff d0                	callq  *%rax
  80179b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80179e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017a2:	79 05                	jns    8017a9 <socket+0x38>
		return r;
  8017a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a7:	eb 11                	jmp    8017ba <socket+0x49>
	return alloc_sockfd(r);
  8017a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ac:	89 c7                	mov    %eax,%edi
  8017ae:	48 b8 53 14 80 00 00 	movabs $0x801453,%rax
  8017b5:	00 00 00 
  8017b8:	ff d0                	callq  *%rax
}
  8017ba:	c9                   	leaveq 
  8017bb:	c3                   	retq   

00000000008017bc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8017bc:	55                   	push   %rbp
  8017bd:	48 89 e5             	mov    %rsp,%rbp
  8017c0:	48 83 ec 10          	sub    $0x10,%rsp
  8017c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8017c7:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  8017ce:	00 00 00 
  8017d1:	8b 00                	mov    (%rax),%eax
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	75 1d                	jne    8017f4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8017d7:	bf 02 00 00 00       	mov    $0x2,%edi
  8017dc:	48 b8 17 3c 80 00 00 	movabs $0x803c17,%rax
  8017e3:	00 00 00 
  8017e6:	ff d0                	callq  *%rax
  8017e8:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  8017ef:	00 00 00 
  8017f2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8017f4:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  8017fb:	00 00 00 
  8017fe:	8b 00                	mov    (%rax),%eax
  801800:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801803:	b9 07 00 00 00       	mov    $0x7,%ecx
  801808:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80180f:	00 00 00 
  801812:	89 c7                	mov    %eax,%edi
  801814:	48 b8 54 3b 80 00 00 	movabs $0x803b54,%rax
  80181b:	00 00 00 
  80181e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801820:	ba 00 00 00 00       	mov    $0x0,%edx
  801825:	be 00 00 00 00       	mov    $0x0,%esi
  80182a:	bf 00 00 00 00       	mov    $0x0,%edi
  80182f:	48 b8 94 3a 80 00 00 	movabs $0x803a94,%rax
  801836:	00 00 00 
  801839:	ff d0                	callq  *%rax
}
  80183b:	c9                   	leaveq 
  80183c:	c3                   	retq   

000000000080183d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
  801841:	48 83 ec 30          	sub    $0x30,%rsp
  801845:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801848:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80184c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801850:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801857:	00 00 00 
  80185a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80185d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80185f:	bf 01 00 00 00       	mov    $0x1,%edi
  801864:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  80186b:	00 00 00 
  80186e:	ff d0                	callq  *%rax
  801870:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801873:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801877:	78 3e                	js     8018b7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801879:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801880:	00 00 00 
  801883:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188b:	8b 40 10             	mov    0x10(%rax),%eax
  80188e:	89 c2                	mov    %eax,%edx
  801890:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801894:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801898:	48 89 ce             	mov    %rcx,%rsi
  80189b:	48 89 c7             	mov    %rax,%rdi
  80189e:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  8018a5:	00 00 00 
  8018a8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8018aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ae:	8b 50 10             	mov    0x10(%rax),%edx
  8018b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8018b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018ba:	c9                   	leaveq 
  8018bb:	c3                   	retq   

00000000008018bc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8018bc:	55                   	push   %rbp
  8018bd:	48 89 e5             	mov    %rsp,%rbp
  8018c0:	48 83 ec 10          	sub    $0x10,%rsp
  8018c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018cb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8018ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018d5:	00 00 00 
  8018d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018db:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8018dd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8018e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e4:	48 89 c6             	mov    %rax,%rsi
  8018e7:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8018ee:	00 00 00 
  8018f1:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  8018f8:	00 00 00 
  8018fb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8018fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801904:	00 00 00 
  801907:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80190a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80190d:	bf 02 00 00 00       	mov    $0x2,%edi
  801912:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  801919:	00 00 00 
  80191c:	ff d0                	callq  *%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	48 83 ec 10          	sub    $0x10,%rsp
  801928:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80192e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801935:	00 00 00 
  801938:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80193b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80193d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801944:	00 00 00 
  801947:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80194a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80194d:	bf 03 00 00 00       	mov    $0x3,%edi
  801952:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
}
  80195e:	c9                   	leaveq 
  80195f:	c3                   	retq   

0000000000801960 <nsipc_close>:

int
nsipc_close(int s)
{
  801960:	55                   	push   %rbp
  801961:	48 89 e5             	mov    %rsp,%rbp
  801964:	48 83 ec 10          	sub    $0x10,%rsp
  801968:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80196b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801972:	00 00 00 
  801975:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801978:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80197a:	bf 04 00 00 00       	mov    $0x4,%edi
  80197f:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  801986:	00 00 00 
  801989:	ff d0                	callq  *%rax
}
  80198b:	c9                   	leaveq 
  80198c:	c3                   	retq   

000000000080198d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80198d:	55                   	push   %rbp
  80198e:	48 89 e5             	mov    %rsp,%rbp
  801991:	48 83 ec 10          	sub    $0x10,%rsp
  801995:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801998:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80199c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80199f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019a6:	00 00 00 
  8019a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8019ac:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019ae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8019b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b5:	48 89 c6             	mov    %rax,%rsi
  8019b8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8019bf:	00 00 00 
  8019c2:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  8019c9:	00 00 00 
  8019cc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8019ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019d5:	00 00 00 
  8019d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8019db:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8019de:	bf 05 00 00 00       	mov    $0x5,%edi
  8019e3:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  8019ea:	00 00 00 
  8019ed:	ff d0                	callq  *%rax
}
  8019ef:	c9                   	leaveq 
  8019f0:	c3                   	retq   

00000000008019f1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019f1:	55                   	push   %rbp
  8019f2:	48 89 e5             	mov    %rsp,%rbp
  8019f5:	48 83 ec 10          	sub    $0x10,%rsp
  8019f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8019ff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a06:	00 00 00 
  801a09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801a0c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801a0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a15:	00 00 00 
  801a18:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801a1b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801a1e:	bf 06 00 00 00       	mov    $0x6,%edi
  801a23:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  801a2a:	00 00 00 
  801a2d:	ff d0                	callq  *%rax
}
  801a2f:	c9                   	leaveq 
  801a30:	c3                   	retq   

0000000000801a31 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a31:	55                   	push   %rbp
  801a32:	48 89 e5             	mov    %rsp,%rbp
  801a35:	48 83 ec 30          	sub    $0x30,%rsp
  801a39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a40:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801a43:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801a46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a4d:	00 00 00 
  801a50:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801a53:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801a55:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a5c:	00 00 00 
  801a5f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801a62:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801a65:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a6c:	00 00 00 
  801a6f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801a72:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a75:	bf 07 00 00 00       	mov    $0x7,%edi
  801a7a:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
  801a86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a8d:	78 69                	js     801af8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801a8f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801a96:	7f 08                	jg     801aa0 <nsipc_recv+0x6f>
  801a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801a9e:	7e 35                	jle    801ad5 <nsipc_recv+0xa4>
  801aa0:	48 b9 02 3e 80 00 00 	movabs $0x803e02,%rcx
  801aa7:	00 00 00 
  801aaa:	48 ba 17 3e 80 00 00 	movabs $0x803e17,%rdx
  801ab1:	00 00 00 
  801ab4:	be 61 00 00 00       	mov    $0x61,%esi
  801ab9:	48 bf 2c 3e 80 00 00 	movabs $0x803e2c,%rdi
  801ac0:	00 00 00 
  801ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac8:	49 b8 84 24 80 00 00 	movabs $0x802484,%r8
  801acf:	00 00 00 
  801ad2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ad5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad8:	48 63 d0             	movslq %eax,%rdx
  801adb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801adf:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801ae6:	00 00 00 
  801ae9:	48 89 c7             	mov    %rax,%rdi
  801aec:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
	}

	return r;
  801af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801afb:	c9                   	leaveq 
  801afc:	c3                   	retq   

0000000000801afd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801afd:	55                   	push   %rbp
  801afe:	48 89 e5             	mov    %rsp,%rbp
  801b01:	48 83 ec 20          	sub    $0x20,%rsp
  801b05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b0c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b0f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801b12:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b19:	00 00 00 
  801b1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b1f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801b21:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801b28:	7e 35                	jle    801b5f <nsipc_send+0x62>
  801b2a:	48 b9 38 3e 80 00 00 	movabs $0x803e38,%rcx
  801b31:	00 00 00 
  801b34:	48 ba 17 3e 80 00 00 	movabs $0x803e17,%rdx
  801b3b:	00 00 00 
  801b3e:	be 6c 00 00 00       	mov    $0x6c,%esi
  801b43:	48 bf 2c 3e 80 00 00 	movabs $0x803e2c,%rdi
  801b4a:	00 00 00 
  801b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b52:	49 b8 84 24 80 00 00 	movabs $0x802484,%r8
  801b59:	00 00 00 
  801b5c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b62:	48 63 d0             	movslq %eax,%rdx
  801b65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b69:	48 89 c6             	mov    %rax,%rsi
  801b6c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801b73:	00 00 00 
  801b76:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  801b7d:	00 00 00 
  801b80:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801b82:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b89:	00 00 00 
  801b8c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b8f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801b92:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b99:	00 00 00 
  801b9c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801b9f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801ba2:	bf 08 00 00 00       	mov    $0x8,%edi
  801ba7:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  801bae:	00 00 00 
  801bb1:	ff d0                	callq  *%rax
}
  801bb3:	c9                   	leaveq 
  801bb4:	c3                   	retq   

0000000000801bb5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	48 83 ec 10          	sub    $0x10,%rsp
  801bbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801bc3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801bc6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bcd:	00 00 00 
  801bd0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801bd3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801bd5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bdc:	00 00 00 
  801bdf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801be2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801be5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bec:	00 00 00 
  801bef:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801bf2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801bf5:	bf 09 00 00 00       	mov    $0x9,%edi
  801bfa:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  801c01:	00 00 00 
  801c04:	ff d0                	callq  *%rax
}
  801c06:	c9                   	leaveq 
  801c07:	c3                   	retq   

0000000000801c08 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c08:	55                   	push   %rbp
  801c09:	48 89 e5             	mov    %rsp,%rbp
  801c0c:	53                   	push   %rbx
  801c0d:	48 83 ec 38          	sub    $0x38,%rsp
  801c11:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c15:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801c19:	48 89 c7             	mov    %rax,%rdi
  801c1c:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  801c23:	00 00 00 
  801c26:	ff d0                	callq  *%rax
  801c28:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c2f:	0f 88 bf 01 00 00    	js     801df4 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c39:	ba 07 04 00 00       	mov    $0x407,%edx
  801c3e:	48 89 c6             	mov    %rax,%rsi
  801c41:	bf 00 00 00 00       	mov    $0x0,%edi
  801c46:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  801c4d:	00 00 00 
  801c50:	ff d0                	callq  *%rax
  801c52:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c55:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c59:	0f 88 95 01 00 00    	js     801df4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c5f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801c63:	48 89 c7             	mov    %rax,%rdi
  801c66:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  801c6d:	00 00 00 
  801c70:	ff d0                	callq  *%rax
  801c72:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c75:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c79:	0f 88 5d 01 00 00    	js     801ddc <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c83:	ba 07 04 00 00       	mov    $0x407,%edx
  801c88:	48 89 c6             	mov    %rax,%rsi
  801c8b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c90:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  801c97:	00 00 00 
  801c9a:	ff d0                	callq  *%rax
  801c9c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ca3:	0f 88 33 01 00 00    	js     801ddc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cad:	48 89 c7             	mov    %rax,%rdi
  801cb0:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  801cb7:	00 00 00 
  801cba:	ff d0                	callq  *%rax
  801cbc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cc4:	ba 07 04 00 00       	mov    $0x407,%edx
  801cc9:	48 89 c6             	mov    %rax,%rsi
  801ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd1:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	callq  *%rax
  801cdd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ce0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ce4:	0f 88 d9 00 00 00    	js     801dc3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cee:	48 89 c7             	mov    %rax,%rdi
  801cf1:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	callq  *%rax
  801cfd:	48 89 c2             	mov    %rax,%rdx
  801d00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d04:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801d0a:	48 89 d1             	mov    %rdx,%rcx
  801d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d12:	48 89 c6             	mov    %rax,%rsi
  801d15:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1a:	48 b8 78 03 80 00 00 	movabs $0x800378,%rax
  801d21:	00 00 00 
  801d24:	ff d0                	callq  *%rax
  801d26:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d29:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d2d:	78 79                	js     801da8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d33:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801d3a:	00 00 00 
  801d3d:	8b 12                	mov    (%rdx),%edx
  801d3f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801d41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d50:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801d57:	00 00 00 
  801d5a:	8b 12                	mov    (%rdx),%edx
  801d5c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801d5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d62:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d6d:	48 89 c7             	mov    %rax,%rdi
  801d70:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  801d77:	00 00 00 
  801d7a:	ff d0                	callq  *%rax
  801d7c:	89 c2                	mov    %eax,%edx
  801d7e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d82:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801d84:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d88:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801d8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d90:	48 89 c7             	mov    %rax,%rdi
  801d93:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  801d9a:	00 00 00 
  801d9d:	ff d0                	callq  *%rax
  801d9f:	89 03                	mov    %eax,(%rbx)
	return 0;
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
  801da6:	eb 4f                	jmp    801df7 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  801da8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  801da9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dad:	48 89 c6             	mov    %rax,%rsi
  801db0:	bf 00 00 00 00       	mov    $0x0,%edi
  801db5:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  801dbc:	00 00 00 
  801dbf:	ff d0                	callq  *%rax
  801dc1:	eb 01                	jmp    801dc4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  801dc3:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  801dc4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc8:	48 89 c6             	mov    %rax,%rsi
  801dcb:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd0:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  801ddc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de0:	48 89 c6             	mov    %rax,%rsi
  801de3:	bf 00 00 00 00       	mov    $0x0,%edi
  801de8:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
    err:
	return r;
  801df4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801df7:	48 83 c4 38          	add    $0x38,%rsp
  801dfb:	5b                   	pop    %rbx
  801dfc:	5d                   	pop    %rbp
  801dfd:	c3                   	retq   

0000000000801dfe <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
  801e02:	53                   	push   %rbx
  801e03:	48 83 ec 28          	sub    $0x28,%rsp
  801e07:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e0b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e0f:	eb 01                	jmp    801e12 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  801e11:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e12:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  801e19:	00 00 00 
  801e1c:	48 8b 00             	mov    (%rax),%rax
  801e1f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801e25:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801e28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2c:	48 89 c7             	mov    %rax,%rdi
  801e2f:	48 b8 9c 3c 80 00 00 	movabs $0x803c9c,%rax
  801e36:	00 00 00 
  801e39:	ff d0                	callq  *%rax
  801e3b:	89 c3                	mov    %eax,%ebx
  801e3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e41:	48 89 c7             	mov    %rax,%rdi
  801e44:	48 b8 9c 3c 80 00 00 	movabs $0x803c9c,%rax
  801e4b:	00 00 00 
  801e4e:	ff d0                	callq  *%rax
  801e50:	39 c3                	cmp    %eax,%ebx
  801e52:	0f 94 c0             	sete   %al
  801e55:	0f b6 c0             	movzbl %al,%eax
  801e58:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801e5b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  801e62:	00 00 00 
  801e65:	48 8b 00             	mov    (%rax),%rax
  801e68:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801e6e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801e71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e74:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801e77:	75 0a                	jne    801e83 <_pipeisclosed+0x85>
			return ret;
  801e79:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801e7c:	48 83 c4 28          	add    $0x28,%rsp
  801e80:	5b                   	pop    %rbx
  801e81:	5d                   	pop    %rbp
  801e82:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801e83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e86:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801e89:	74 86                	je     801e11 <_pipeisclosed+0x13>
  801e8b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801e8f:	75 80                	jne    801e11 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e91:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  801e98:	00 00 00 
  801e9b:	48 8b 00             	mov    (%rax),%rax
  801e9e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801ea4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801ea7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eaa:	89 c6                	mov    %eax,%esi
  801eac:	48 bf 49 3e 80 00 00 	movabs $0x803e49,%rdi
  801eb3:	00 00 00 
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebb:	49 b8 bf 26 80 00 00 	movabs $0x8026bf,%r8
  801ec2:	00 00 00 
  801ec5:	41 ff d0             	callq  *%r8
	}
  801ec8:	e9 44 ff ff ff       	jmpq   801e11 <_pipeisclosed+0x13>

0000000000801ecd <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  801ecd:	55                   	push   %rbp
  801ece:	48 89 e5             	mov    %rsp,%rbp
  801ed1:	48 83 ec 30          	sub    $0x30,%rsp
  801ed5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ed8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801edc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801edf:	48 89 d6             	mov    %rdx,%rsi
  801ee2:	89 c7                	mov    %eax,%edi
  801ee4:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  801eeb:	00 00 00 
  801eee:	ff d0                	callq  *%rax
  801ef0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ef3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ef7:	79 05                	jns    801efe <pipeisclosed+0x31>
		return r;
  801ef9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efc:	eb 31                	jmp    801f2f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f02:	48 89 c7             	mov    %rax,%rdi
  801f05:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  801f0c:	00 00 00 
  801f0f:	ff d0                	callq  *%rax
  801f11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801f15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1d:	48 89 d6             	mov    %rdx,%rsi
  801f20:	48 89 c7             	mov    %rax,%rdi
  801f23:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  801f2a:	00 00 00 
  801f2d:	ff d0                	callq  *%rax
}
  801f2f:	c9                   	leaveq 
  801f30:	c3                   	retq   

0000000000801f31 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f31:	55                   	push   %rbp
  801f32:	48 89 e5             	mov    %rsp,%rbp
  801f35:	48 83 ec 40          	sub    $0x40,%rsp
  801f39:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f3d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f41:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f49:	48 89 c7             	mov    %rax,%rdi
  801f4c:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  801f53:	00 00 00 
  801f56:	ff d0                	callq  *%rax
  801f58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801f5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801f64:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801f6b:	00 
  801f6c:	e9 97 00 00 00       	jmpq   802008 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f71:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801f76:	74 09                	je     801f81 <devpipe_read+0x50>
				return i;
  801f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7c:	e9 95 00 00 00       	jmpq   802016 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f89:	48 89 d6             	mov    %rdx,%rsi
  801f8c:	48 89 c7             	mov    %rax,%rdi
  801f8f:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	74 07                	je     801fa6 <devpipe_read+0x75>
				return 0;
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa4:	eb 70                	jmp    802016 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801fa6:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax
  801fb2:	eb 01                	jmp    801fb5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801fb4:	90                   	nop
  801fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb9:	8b 10                	mov    (%rax),%edx
  801fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbf:	8b 40 04             	mov    0x4(%rax),%eax
  801fc2:	39 c2                	cmp    %eax,%edx
  801fc4:	74 ab                	je     801f71 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fce:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801fd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd6:	8b 00                	mov    (%rax),%eax
  801fd8:	89 c2                	mov    %eax,%edx
  801fda:	c1 fa 1f             	sar    $0x1f,%edx
  801fdd:	c1 ea 1b             	shr    $0x1b,%edx
  801fe0:	01 d0                	add    %edx,%eax
  801fe2:	83 e0 1f             	and    $0x1f,%eax
  801fe5:	29 d0                	sub    %edx,%eax
  801fe7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801feb:	48 98                	cltq   
  801fed:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801ff2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ff8:	8b 00                	mov    (%rax),%eax
  801ffa:	8d 50 01             	lea    0x1(%rax),%edx
  801ffd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802001:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802003:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802008:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802010:	72 a2                	jb     801fb4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802012:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802016:	c9                   	leaveq 
  802017:	c3                   	retq   

0000000000802018 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802018:	55                   	push   %rbp
  802019:	48 89 e5             	mov    %rsp,%rbp
  80201c:	48 83 ec 40          	sub    $0x40,%rsp
  802020:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802024:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802028:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80202c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802030:	48 89 c7             	mov    %rax,%rdi
  802033:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
  80203f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802043:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802047:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80204b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802052:	00 
  802053:	e9 93 00 00 00       	jmpq   8020eb <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802058:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802060:	48 89 d6             	mov    %rdx,%rsi
  802063:	48 89 c7             	mov    %rax,%rdi
  802066:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  80206d:	00 00 00 
  802070:	ff d0                	callq  *%rax
  802072:	85 c0                	test   %eax,%eax
  802074:	74 07                	je     80207d <devpipe_write+0x65>
				return 0;
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	eb 7c                	jmp    8020f9 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80207d:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
  802089:	eb 01                	jmp    80208c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80208b:	90                   	nop
  80208c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802090:	8b 40 04             	mov    0x4(%rax),%eax
  802093:	48 63 d0             	movslq %eax,%rdx
  802096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80209a:	8b 00                	mov    (%rax),%eax
  80209c:	48 98                	cltq   
  80209e:	48 83 c0 20          	add    $0x20,%rax
  8020a2:	48 39 c2             	cmp    %rax,%rdx
  8020a5:	73 b1                	jae    802058 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ab:	8b 40 04             	mov    0x4(%rax),%eax
  8020ae:	89 c2                	mov    %eax,%edx
  8020b0:	c1 fa 1f             	sar    $0x1f,%edx
  8020b3:	c1 ea 1b             	shr    $0x1b,%edx
  8020b6:	01 d0                	add    %edx,%eax
  8020b8:	83 e0 1f             	and    $0x1f,%eax
  8020bb:	29 d0                	sub    %edx,%eax
  8020bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020c1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020c5:	48 01 ca             	add    %rcx,%rdx
  8020c8:	0f b6 0a             	movzbl (%rdx),%ecx
  8020cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020cf:	48 98                	cltq   
  8020d1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8020d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d9:	8b 40 04             	mov    0x4(%rax),%eax
  8020dc:	8d 50 01             	lea    0x1(%rax),%edx
  8020df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020e6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8020eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ef:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8020f3:	72 96                	jb     80208b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8020f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8020f9:	c9                   	leaveq 
  8020fa:	c3                   	retq   

00000000008020fb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020fb:	55                   	push   %rbp
  8020fc:	48 89 e5             	mov    %rsp,%rbp
  8020ff:	48 83 ec 20          	sub    $0x20,%rsp
  802103:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802107:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80210b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210f:	48 89 c7             	mov    %rax,%rdi
  802112:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  802119:	00 00 00 
  80211c:	ff d0                	callq  *%rax
  80211e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802122:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802126:	48 be 5c 3e 80 00 00 	movabs $0x803e5c,%rsi
  80212d:	00 00 00 
  802130:	48 89 c7             	mov    %rax,%rdi
  802133:	48 b8 7c 32 80 00 00 	movabs $0x80327c,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80213f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802143:	8b 50 04             	mov    0x4(%rax),%edx
  802146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80214a:	8b 00                	mov    (%rax),%eax
  80214c:	29 c2                	sub    %eax,%edx
  80214e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802152:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802158:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80215c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802163:	00 00 00 
	stat->st_dev = &devpipe;
  802166:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80216a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802171:	00 00 00 
  802174:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802180:	c9                   	leaveq 
  802181:	c3                   	retq   

0000000000802182 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802182:	55                   	push   %rbp
  802183:	48 89 e5             	mov    %rsp,%rbp
  802186:	48 83 ec 10          	sub    $0x10,%rsp
  80218a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80218e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802192:	48 89 c6             	mov    %rax,%rsi
  802195:	bf 00 00 00 00       	mov    $0x0,%edi
  80219a:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8021a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021aa:	48 89 c7             	mov    %rax,%rdi
  8021ad:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	callq  *%rax
  8021b9:	48 89 c6             	mov    %rax,%rsi
  8021bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c1:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  8021c8:	00 00 00 
  8021cb:	ff d0                	callq  *%rax
}
  8021cd:	c9                   	leaveq 
  8021ce:	c3                   	retq   
	...

00000000008021d0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021d0:	55                   	push   %rbp
  8021d1:	48 89 e5             	mov    %rsp,%rbp
  8021d4:	48 83 ec 20          	sub    $0x20,%rsp
  8021d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8021db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021de:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021e1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8021e5:	be 01 00 00 00       	mov    $0x1,%esi
  8021ea:	48 89 c7             	mov    %rax,%rdi
  8021ed:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  8021f4:	00 00 00 
  8021f7:	ff d0                	callq  *%rax
}
  8021f9:	c9                   	leaveq 
  8021fa:	c3                   	retq   

00000000008021fb <getchar>:

int
getchar(void)
{
  8021fb:	55                   	push   %rbp
  8021fc:	48 89 e5             	mov    %rsp,%rbp
  8021ff:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802203:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802207:	ba 01 00 00 00       	mov    $0x1,%edx
  80220c:	48 89 c6             	mov    %rax,%rsi
  80220f:	bf 00 00 00 00       	mov    $0x0,%edi
  802214:	48 b8 0c 0c 80 00 00 	movabs $0x800c0c,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
  802220:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802223:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802227:	79 05                	jns    80222e <getchar+0x33>
		return r;
  802229:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222c:	eb 14                	jmp    802242 <getchar+0x47>
	if (r < 1)
  80222e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802232:	7f 07                	jg     80223b <getchar+0x40>
		return -E_EOF;
  802234:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802239:	eb 07                	jmp    802242 <getchar+0x47>
	return c;
  80223b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80223f:	0f b6 c0             	movzbl %al,%eax
}
  802242:	c9                   	leaveq 
  802243:	c3                   	retq   

0000000000802244 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802244:	55                   	push   %rbp
  802245:	48 89 e5             	mov    %rsp,%rbp
  802248:	48 83 ec 20          	sub    $0x20,%rsp
  80224c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80224f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802253:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802256:	48 89 d6             	mov    %rdx,%rsi
  802259:	89 c7                	mov    %eax,%edi
  80225b:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  802262:	00 00 00 
  802265:	ff d0                	callq  *%rax
  802267:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80226a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80226e:	79 05                	jns    802275 <iscons+0x31>
		return r;
  802270:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802273:	eb 1a                	jmp    80228f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802279:	8b 10                	mov    (%rax),%edx
  80227b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802282:	00 00 00 
  802285:	8b 00                	mov    (%rax),%eax
  802287:	39 c2                	cmp    %eax,%edx
  802289:	0f 94 c0             	sete   %al
  80228c:	0f b6 c0             	movzbl %al,%eax
}
  80228f:	c9                   	leaveq 
  802290:	c3                   	retq   

0000000000802291 <opencons>:

int
opencons(void)
{
  802291:	55                   	push   %rbp
  802292:	48 89 e5             	mov    %rsp,%rbp
  802295:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802299:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80229d:	48 89 c7             	mov    %rax,%rdi
  8022a0:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  8022a7:	00 00 00 
  8022aa:	ff d0                	callq  *%rax
  8022ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b3:	79 05                	jns    8022ba <opencons+0x29>
		return r;
  8022b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b8:	eb 5b                	jmp    802315 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022be:	ba 07 04 00 00       	mov    $0x407,%edx
  8022c3:	48 89 c6             	mov    %rax,%rsi
  8022c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8022cb:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  8022d2:	00 00 00 
  8022d5:	ff d0                	callq  *%rax
  8022d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022de:	79 05                	jns    8022e5 <opencons+0x54>
		return r;
  8022e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e3:	eb 30                	jmp    802315 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8022e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8022f0:	00 00 00 
  8022f3:	8b 12                	mov    (%rdx),%edx
  8022f5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8022f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022fb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802306:	48 89 c7             	mov    %rax,%rdi
  802309:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
}
  802315:	c9                   	leaveq 
  802316:	c3                   	retq   

0000000000802317 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802317:	55                   	push   %rbp
  802318:	48 89 e5             	mov    %rsp,%rbp
  80231b:	48 83 ec 30          	sub    $0x30,%rsp
  80231f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802323:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802327:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80232b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802330:	75 13                	jne    802345 <devcons_read+0x2e>
		return 0;
  802332:	b8 00 00 00 00       	mov    $0x0,%eax
  802337:	eb 49                	jmp    802382 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802339:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802345:	48 b8 2a 02 80 00 00 	movabs $0x80022a,%rax
  80234c:	00 00 00 
  80234f:	ff d0                	callq  *%rax
  802351:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802354:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802358:	74 df                	je     802339 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80235a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80235e:	79 05                	jns    802365 <devcons_read+0x4e>
		return c;
  802360:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802363:	eb 1d                	jmp    802382 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  802365:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802369:	75 07                	jne    802372 <devcons_read+0x5b>
		return 0;
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
  802370:	eb 10                	jmp    802382 <devcons_read+0x6b>
	*(char*)vbuf = c;
  802372:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802375:	89 c2                	mov    %eax,%edx
  802377:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80237b:	88 10                	mov    %dl,(%rax)
	return 1;
  80237d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802382:	c9                   	leaveq 
  802383:	c3                   	retq   

0000000000802384 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802384:	55                   	push   %rbp
  802385:	48 89 e5             	mov    %rsp,%rbp
  802388:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80238f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802396:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80239d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023ab:	eb 77                	jmp    802424 <devcons_write+0xa0>
		m = n - tot;
  8023ad:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8023b4:	89 c2                	mov    %eax,%edx
  8023b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b9:	89 d1                	mov    %edx,%ecx
  8023bb:	29 c1                	sub    %eax,%ecx
  8023bd:	89 c8                	mov    %ecx,%eax
  8023bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8023c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023c5:	83 f8 7f             	cmp    $0x7f,%eax
  8023c8:	76 07                	jbe    8023d1 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8023ca:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8023d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023d4:	48 63 d0             	movslq %eax,%rdx
  8023d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023da:	48 98                	cltq   
  8023dc:	48 89 c1             	mov    %rax,%rcx
  8023df:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8023e6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8023ed:	48 89 ce             	mov    %rcx,%rsi
  8023f0:	48 89 c7             	mov    %rax,%rdi
  8023f3:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8023ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802402:	48 63 d0             	movslq %eax,%rdx
  802405:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80240c:	48 89 d6             	mov    %rdx,%rsi
  80240f:	48 89 c7             	mov    %rax,%rdi
  802412:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  802419:	00 00 00 
  80241c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80241e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802421:	01 45 fc             	add    %eax,-0x4(%rbp)
  802424:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802427:	48 98                	cltq   
  802429:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802430:	0f 82 77 ff ff ff    	jb     8023ad <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802436:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802439:	c9                   	leaveq 
  80243a:	c3                   	retq   

000000000080243b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80243b:	55                   	push   %rbp
  80243c:	48 89 e5             	mov    %rsp,%rbp
  80243f:	48 83 ec 08          	sub    $0x8,%rsp
  802443:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244c:	c9                   	leaveq 
  80244d:	c3                   	retq   

000000000080244e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80244e:	55                   	push   %rbp
  80244f:	48 89 e5             	mov    %rsp,%rbp
  802452:	48 83 ec 10          	sub    $0x10,%rsp
  802456:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80245a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80245e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802462:	48 be 68 3e 80 00 00 	movabs $0x803e68,%rsi
  802469:	00 00 00 
  80246c:	48 89 c7             	mov    %rax,%rdi
  80246f:	48 b8 7c 32 80 00 00 	movabs $0x80327c,%rax
  802476:	00 00 00 
  802479:	ff d0                	callq  *%rax
	return 0;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802480:	c9                   	leaveq 
  802481:	c3                   	retq   
	...

0000000000802484 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802484:	55                   	push   %rbp
  802485:	48 89 e5             	mov    %rsp,%rbp
  802488:	53                   	push   %rbx
  802489:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802490:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802497:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80249d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8024a4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8024ab:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8024b2:	84 c0                	test   %al,%al
  8024b4:	74 23                	je     8024d9 <_panic+0x55>
  8024b6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8024bd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8024c1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8024c5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8024c9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8024cd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8024d1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8024d5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8024d9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8024e0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8024e7:	00 00 00 
  8024ea:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8024f1:	00 00 00 
  8024f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8024f8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8024ff:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802506:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80250d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802514:	00 00 00 
  802517:	48 8b 18             	mov    (%rax),%rbx
  80251a:	48 b8 ac 02 80 00 00 	movabs $0x8002ac,%rax
  802521:	00 00 00 
  802524:	ff d0                	callq  *%rax
  802526:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80252c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802533:	41 89 c8             	mov    %ecx,%r8d
  802536:	48 89 d1             	mov    %rdx,%rcx
  802539:	48 89 da             	mov    %rbx,%rdx
  80253c:	89 c6                	mov    %eax,%esi
  80253e:	48 bf 70 3e 80 00 00 	movabs $0x803e70,%rdi
  802545:	00 00 00 
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
  80254d:	49 b9 bf 26 80 00 00 	movabs $0x8026bf,%r9
  802554:	00 00 00 
  802557:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80255a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802561:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802568:	48 89 d6             	mov    %rdx,%rsi
  80256b:	48 89 c7             	mov    %rax,%rdi
  80256e:	48 b8 13 26 80 00 00 	movabs $0x802613,%rax
  802575:	00 00 00 
  802578:	ff d0                	callq  *%rax
	cprintf("\n");
  80257a:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  802581:	00 00 00 
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
  802589:	48 ba bf 26 80 00 00 	movabs $0x8026bf,%rdx
  802590:	00 00 00 
  802593:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802595:	cc                   	int3   
  802596:	eb fd                	jmp    802595 <_panic+0x111>

0000000000802598 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  802598:	55                   	push   %rbp
  802599:	48 89 e5             	mov    %rsp,%rbp
  80259c:	48 83 ec 10          	sub    $0x10,%rsp
  8025a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8025a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ab:	8b 00                	mov    (%rax),%eax
  8025ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025b0:	89 d6                	mov    %edx,%esi
  8025b2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025b6:	48 63 d0             	movslq %eax,%rdx
  8025b9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8025be:	8d 50 01             	lea    0x1(%rax),%edx
  8025c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c5:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8025c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cb:	8b 00                	mov    (%rax),%eax
  8025cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8025d2:	75 2c                	jne    802600 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8025d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d8:	8b 00                	mov    (%rax),%eax
  8025da:	48 98                	cltq   
  8025dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e0:	48 83 c2 08          	add    $0x8,%rdx
  8025e4:	48 89 c6             	mov    %rax,%rsi
  8025e7:	48 89 d7             	mov    %rdx,%rdi
  8025ea:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  8025f1:	00 00 00 
  8025f4:	ff d0                	callq  *%rax
		b->idx = 0;
  8025f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  802600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802604:	8b 40 04             	mov    0x4(%rax),%eax
  802607:	8d 50 01             	lea    0x1(%rax),%edx
  80260a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260e:	89 50 04             	mov    %edx,0x4(%rax)
}
  802611:	c9                   	leaveq 
  802612:	c3                   	retq   

0000000000802613 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  802613:	55                   	push   %rbp
  802614:	48 89 e5             	mov    %rsp,%rbp
  802617:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80261e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802625:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80262c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802633:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80263a:	48 8b 0a             	mov    (%rdx),%rcx
  80263d:	48 89 08             	mov    %rcx,(%rax)
  802640:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802644:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802648:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80264c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  802650:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802657:	00 00 00 
	b.cnt = 0;
  80265a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802661:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  802664:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80266b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802672:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802679:	48 89 c6             	mov    %rax,%rsi
  80267c:	48 bf 98 25 80 00 00 	movabs $0x802598,%rdi
  802683:	00 00 00 
  802686:	48 b8 70 2a 80 00 00 	movabs $0x802a70,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  802692:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802698:	48 98                	cltq   
  80269a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8026a1:	48 83 c2 08          	add    $0x8,%rdx
  8026a5:	48 89 c6             	mov    %rax,%rsi
  8026a8:	48 89 d7             	mov    %rdx,%rdi
  8026ab:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8026b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8026bd:	c9                   	leaveq 
  8026be:	c3                   	retq   

00000000008026bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8026bf:	55                   	push   %rbp
  8026c0:	48 89 e5             	mov    %rsp,%rbp
  8026c3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8026ca:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8026d1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8026d8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8026df:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8026e6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8026ed:	84 c0                	test   %al,%al
  8026ef:	74 20                	je     802711 <cprintf+0x52>
  8026f1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8026f5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8026f9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8026fd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802701:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802705:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802709:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80270d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802711:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  802718:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80271f:	00 00 00 
  802722:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802729:	00 00 00 
  80272c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802730:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802737:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80273e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802745:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80274c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802753:	48 8b 0a             	mov    (%rdx),%rcx
  802756:	48 89 08             	mov    %rcx,(%rax)
  802759:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80275d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802761:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802765:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  802769:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802770:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802777:	48 89 d6             	mov    %rdx,%rsi
  80277a:	48 89 c7             	mov    %rax,%rdi
  80277d:	48 b8 13 26 80 00 00 	movabs $0x802613,%rax
  802784:	00 00 00 
  802787:	ff d0                	callq  *%rax
  802789:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80278f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802795:	c9                   	leaveq 
  802796:	c3                   	retq   
	...

0000000000802798 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802798:	55                   	push   %rbp
  802799:	48 89 e5             	mov    %rsp,%rbp
  80279c:	48 83 ec 30          	sub    $0x30,%rsp
  8027a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8027ac:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8027af:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8027b3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8027b7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8027ba:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8027be:	77 52                	ja     802812 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8027c0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8027c3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8027c7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027ca:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8027ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d7:	48 f7 75 d0          	divq   -0x30(%rbp)
  8027db:	48 89 c2             	mov    %rax,%rdx
  8027de:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8027e1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8027e4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8027e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ec:	41 89 f9             	mov    %edi,%r9d
  8027ef:	48 89 c7             	mov    %rax,%rdi
  8027f2:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
  8027fe:	eb 1c                	jmp    80281c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802800:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802804:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802807:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80280b:	48 89 d6             	mov    %rdx,%rsi
  80280e:	89 c7                	mov    %eax,%edi
  802810:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802812:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  802816:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80281a:	7f e4                	jg     802800 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80281c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80281f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802823:	ba 00 00 00 00       	mov    $0x0,%edx
  802828:	48 f7 f1             	div    %rcx
  80282b:	48 89 d0             	mov    %rdx,%rax
  80282e:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  802835:	00 00 00 
  802838:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80283c:	0f be c0             	movsbl %al,%eax
  80283f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802843:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802847:	48 89 d6             	mov    %rdx,%rsi
  80284a:	89 c7                	mov    %eax,%edi
  80284c:	ff d1                	callq  *%rcx
}
  80284e:	c9                   	leaveq 
  80284f:	c3                   	retq   

0000000000802850 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802850:	55                   	push   %rbp
  802851:	48 89 e5             	mov    %rsp,%rbp
  802854:	48 83 ec 20          	sub    $0x20,%rsp
  802858:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80285c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80285f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802863:	7e 52                	jle    8028b7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802869:	8b 00                	mov    (%rax),%eax
  80286b:	83 f8 30             	cmp    $0x30,%eax
  80286e:	73 24                	jae    802894 <getuint+0x44>
  802870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802874:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287c:	8b 00                	mov    (%rax),%eax
  80287e:	89 c0                	mov    %eax,%eax
  802880:	48 01 d0             	add    %rdx,%rax
  802883:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802887:	8b 12                	mov    (%rdx),%edx
  802889:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80288c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802890:	89 0a                	mov    %ecx,(%rdx)
  802892:	eb 17                	jmp    8028ab <getuint+0x5b>
  802894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802898:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80289c:	48 89 d0             	mov    %rdx,%rax
  80289f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8028a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8028ab:	48 8b 00             	mov    (%rax),%rax
  8028ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8028b2:	e9 a3 00 00 00       	jmpq   80295a <getuint+0x10a>
	else if (lflag)
  8028b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8028bb:	74 4f                	je     80290c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8028bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c1:	8b 00                	mov    (%rax),%eax
  8028c3:	83 f8 30             	cmp    $0x30,%eax
  8028c6:	73 24                	jae    8028ec <getuint+0x9c>
  8028c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8028d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d4:	8b 00                	mov    (%rax),%eax
  8028d6:	89 c0                	mov    %eax,%eax
  8028d8:	48 01 d0             	add    %rdx,%rax
  8028db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028df:	8b 12                	mov    (%rdx),%edx
  8028e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8028e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028e8:	89 0a                	mov    %ecx,(%rdx)
  8028ea:	eb 17                	jmp    802903 <getuint+0xb3>
  8028ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8028f4:	48 89 d0             	mov    %rdx,%rax
  8028f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8028fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802903:	48 8b 00             	mov    (%rax),%rax
  802906:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80290a:	eb 4e                	jmp    80295a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80290c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802910:	8b 00                	mov    (%rax),%eax
  802912:	83 f8 30             	cmp    $0x30,%eax
  802915:	73 24                	jae    80293b <getuint+0xeb>
  802917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80291f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802923:	8b 00                	mov    (%rax),%eax
  802925:	89 c0                	mov    %eax,%eax
  802927:	48 01 d0             	add    %rdx,%rax
  80292a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80292e:	8b 12                	mov    (%rdx),%edx
  802930:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802933:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802937:	89 0a                	mov    %ecx,(%rdx)
  802939:	eb 17                	jmp    802952 <getuint+0x102>
  80293b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802943:	48 89 d0             	mov    %rdx,%rax
  802946:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80294a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80294e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802952:	8b 00                	mov    (%rax),%eax
  802954:	89 c0                	mov    %eax,%eax
  802956:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80295a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80295e:	c9                   	leaveq 
  80295f:	c3                   	retq   

0000000000802960 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802960:	55                   	push   %rbp
  802961:	48 89 e5             	mov    %rsp,%rbp
  802964:	48 83 ec 20          	sub    $0x20,%rsp
  802968:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80296c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80296f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802973:	7e 52                	jle    8029c7 <getint+0x67>
		x=va_arg(*ap, long long);
  802975:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802979:	8b 00                	mov    (%rax),%eax
  80297b:	83 f8 30             	cmp    $0x30,%eax
  80297e:	73 24                	jae    8029a4 <getint+0x44>
  802980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802984:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298c:	8b 00                	mov    (%rax),%eax
  80298e:	89 c0                	mov    %eax,%eax
  802990:	48 01 d0             	add    %rdx,%rax
  802993:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802997:	8b 12                	mov    (%rdx),%edx
  802999:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80299c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029a0:	89 0a                	mov    %ecx,(%rdx)
  8029a2:	eb 17                	jmp    8029bb <getint+0x5b>
  8029a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8029ac:	48 89 d0             	mov    %rdx,%rax
  8029af:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8029b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8029bb:	48 8b 00             	mov    (%rax),%rax
  8029be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8029c2:	e9 a3 00 00 00       	jmpq   802a6a <getint+0x10a>
	else if (lflag)
  8029c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8029cb:	74 4f                	je     802a1c <getint+0xbc>
		x=va_arg(*ap, long);
  8029cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d1:	8b 00                	mov    (%rax),%eax
  8029d3:	83 f8 30             	cmp    $0x30,%eax
  8029d6:	73 24                	jae    8029fc <getint+0x9c>
  8029d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029dc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8029e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e4:	8b 00                	mov    (%rax),%eax
  8029e6:	89 c0                	mov    %eax,%eax
  8029e8:	48 01 d0             	add    %rdx,%rax
  8029eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ef:	8b 12                	mov    (%rdx),%edx
  8029f1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8029f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029f8:	89 0a                	mov    %ecx,(%rdx)
  8029fa:	eb 17                	jmp    802a13 <getint+0xb3>
  8029fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a00:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802a04:	48 89 d0             	mov    %rdx,%rax
  802a07:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802a0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a0f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802a13:	48 8b 00             	mov    (%rax),%rax
  802a16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a1a:	eb 4e                	jmp    802a6a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a20:	8b 00                	mov    (%rax),%eax
  802a22:	83 f8 30             	cmp    $0x30,%eax
  802a25:	73 24                	jae    802a4b <getint+0xeb>
  802a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a2b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a33:	8b 00                	mov    (%rax),%eax
  802a35:	89 c0                	mov    %eax,%eax
  802a37:	48 01 d0             	add    %rdx,%rax
  802a3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a3e:	8b 12                	mov    (%rdx),%edx
  802a40:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802a43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a47:	89 0a                	mov    %ecx,(%rdx)
  802a49:	eb 17                	jmp    802a62 <getint+0x102>
  802a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802a53:	48 89 d0             	mov    %rdx,%rax
  802a56:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802a5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a5e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802a62:	8b 00                	mov    (%rax),%eax
  802a64:	48 98                	cltq   
  802a66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802a6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802a6e:	c9                   	leaveq 
  802a6f:	c3                   	retq   

0000000000802a70 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802a70:	55                   	push   %rbp
  802a71:	48 89 e5             	mov    %rsp,%rbp
  802a74:	41 54                	push   %r12
  802a76:	53                   	push   %rbx
  802a77:	48 83 ec 60          	sub    $0x60,%rsp
  802a7b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802a7f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802a83:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802a87:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802a8b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802a8f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802a93:	48 8b 0a             	mov    (%rdx),%rcx
  802a96:	48 89 08             	mov    %rcx,(%rax)
  802a99:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a9d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802aa1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802aa5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802aa9:	eb 17                	jmp    802ac2 <vprintfmt+0x52>
			if (ch == '\0')
  802aab:	85 db                	test   %ebx,%ebx
  802aad:	0f 84 d7 04 00 00    	je     802f8a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  802ab3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802ab7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802abb:	48 89 c6             	mov    %rax,%rsi
  802abe:	89 df                	mov    %ebx,%edi
  802ac0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802ac2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802ac6:	0f b6 00             	movzbl (%rax),%eax
  802ac9:	0f b6 d8             	movzbl %al,%ebx
  802acc:	83 fb 25             	cmp    $0x25,%ebx
  802acf:	0f 95 c0             	setne  %al
  802ad2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802ad7:	84 c0                	test   %al,%al
  802ad9:	75 d0                	jne    802aab <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802adb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802adf:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802ae6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802aed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802af4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  802afb:	eb 04                	jmp    802b01 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  802afd:	90                   	nop
  802afe:	eb 01                	jmp    802b01 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  802b00:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802b01:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802b05:	0f b6 00             	movzbl (%rax),%eax
  802b08:	0f b6 d8             	movzbl %al,%ebx
  802b0b:	89 d8                	mov    %ebx,%eax
  802b0d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802b12:	83 e8 23             	sub    $0x23,%eax
  802b15:	83 f8 55             	cmp    $0x55,%eax
  802b18:	0f 87 38 04 00 00    	ja     802f56 <vprintfmt+0x4e6>
  802b1e:	89 c0                	mov    %eax,%eax
  802b20:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802b27:	00 
  802b28:	48 b8 90 40 80 00 00 	movabs $0x804090,%rax
  802b2f:	00 00 00 
  802b32:	48 01 d0             	add    %rdx,%rax
  802b35:	48 8b 00             	mov    (%rax),%rax
  802b38:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  802b3a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802b3e:	eb c1                	jmp    802b01 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802b40:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802b44:	eb bb                	jmp    802b01 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802b46:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802b4d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802b50:	89 d0                	mov    %edx,%eax
  802b52:	c1 e0 02             	shl    $0x2,%eax
  802b55:	01 d0                	add    %edx,%eax
  802b57:	01 c0                	add    %eax,%eax
  802b59:	01 d8                	add    %ebx,%eax
  802b5b:	83 e8 30             	sub    $0x30,%eax
  802b5e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802b61:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802b65:	0f b6 00             	movzbl (%rax),%eax
  802b68:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802b6b:	83 fb 2f             	cmp    $0x2f,%ebx
  802b6e:	7e 63                	jle    802bd3 <vprintfmt+0x163>
  802b70:	83 fb 39             	cmp    $0x39,%ebx
  802b73:	7f 5e                	jg     802bd3 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802b75:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802b7a:	eb d1                	jmp    802b4d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  802b7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b7f:	83 f8 30             	cmp    $0x30,%eax
  802b82:	73 17                	jae    802b9b <vprintfmt+0x12b>
  802b84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b8b:	89 c0                	mov    %eax,%eax
  802b8d:	48 01 d0             	add    %rdx,%rax
  802b90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802b93:	83 c2 08             	add    $0x8,%edx
  802b96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802b99:	eb 0f                	jmp    802baa <vprintfmt+0x13a>
  802b9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b9f:	48 89 d0             	mov    %rdx,%rax
  802ba2:	48 83 c2 08          	add    $0x8,%rdx
  802ba6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802baa:	8b 00                	mov    (%rax),%eax
  802bac:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802baf:	eb 23                	jmp    802bd4 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  802bb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802bb5:	0f 89 42 ff ff ff    	jns    802afd <vprintfmt+0x8d>
				width = 0;
  802bbb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802bc2:	e9 36 ff ff ff       	jmpq   802afd <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  802bc7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802bce:	e9 2e ff ff ff       	jmpq   802b01 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  802bd3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  802bd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802bd8:	0f 89 22 ff ff ff    	jns    802b00 <vprintfmt+0x90>
				width = precision, precision = -1;
  802bde:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802be1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802be4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802beb:	e9 10 ff ff ff       	jmpq   802b00 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802bf0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802bf4:	e9 08 ff ff ff       	jmpq   802b01 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802bf9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802bfc:	83 f8 30             	cmp    $0x30,%eax
  802bff:	73 17                	jae    802c18 <vprintfmt+0x1a8>
  802c01:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c08:	89 c0                	mov    %eax,%eax
  802c0a:	48 01 d0             	add    %rdx,%rax
  802c0d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c10:	83 c2 08             	add    $0x8,%edx
  802c13:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c16:	eb 0f                	jmp    802c27 <vprintfmt+0x1b7>
  802c18:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c1c:	48 89 d0             	mov    %rdx,%rax
  802c1f:	48 83 c2 08          	add    $0x8,%rdx
  802c23:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c27:	8b 00                	mov    (%rax),%eax
  802c29:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802c2d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  802c31:	48 89 d6             	mov    %rdx,%rsi
  802c34:	89 c7                	mov    %eax,%edi
  802c36:	ff d1                	callq  *%rcx
			break;
  802c38:	e9 47 03 00 00       	jmpq   802f84 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  802c3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c40:	83 f8 30             	cmp    $0x30,%eax
  802c43:	73 17                	jae    802c5c <vprintfmt+0x1ec>
  802c45:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c4c:	89 c0                	mov    %eax,%eax
  802c4e:	48 01 d0             	add    %rdx,%rax
  802c51:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c54:	83 c2 08             	add    $0x8,%edx
  802c57:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c5a:	eb 0f                	jmp    802c6b <vprintfmt+0x1fb>
  802c5c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c60:	48 89 d0             	mov    %rdx,%rax
  802c63:	48 83 c2 08          	add    $0x8,%rdx
  802c67:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c6b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802c6d:	85 db                	test   %ebx,%ebx
  802c6f:	79 02                	jns    802c73 <vprintfmt+0x203>
				err = -err;
  802c71:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802c73:	83 fb 10             	cmp    $0x10,%ebx
  802c76:	7f 16                	jg     802c8e <vprintfmt+0x21e>
  802c78:	48 b8 e0 3f 80 00 00 	movabs $0x803fe0,%rax
  802c7f:	00 00 00 
  802c82:	48 63 d3             	movslq %ebx,%rdx
  802c85:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802c89:	4d 85 e4             	test   %r12,%r12
  802c8c:	75 2e                	jne    802cbc <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  802c8e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802c92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c96:	89 d9                	mov    %ebx,%ecx
  802c98:	48 ba 79 40 80 00 00 	movabs $0x804079,%rdx
  802c9f:	00 00 00 
  802ca2:	48 89 c7             	mov    %rax,%rdi
  802ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  802caa:	49 b8 94 2f 80 00 00 	movabs $0x802f94,%r8
  802cb1:	00 00 00 
  802cb4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802cb7:	e9 c8 02 00 00       	jmpq   802f84 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802cbc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802cc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802cc4:	4c 89 e1             	mov    %r12,%rcx
  802cc7:	48 ba 82 40 80 00 00 	movabs $0x804082,%rdx
  802cce:	00 00 00 
  802cd1:	48 89 c7             	mov    %rax,%rdi
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd9:	49 b8 94 2f 80 00 00 	movabs $0x802f94,%r8
  802ce0:	00 00 00 
  802ce3:	41 ff d0             	callq  *%r8
			break;
  802ce6:	e9 99 02 00 00       	jmpq   802f84 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802ceb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802cee:	83 f8 30             	cmp    $0x30,%eax
  802cf1:	73 17                	jae    802d0a <vprintfmt+0x29a>
  802cf3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cf7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802cfa:	89 c0                	mov    %eax,%eax
  802cfc:	48 01 d0             	add    %rdx,%rax
  802cff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802d02:	83 c2 08             	add    $0x8,%edx
  802d05:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802d08:	eb 0f                	jmp    802d19 <vprintfmt+0x2a9>
  802d0a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802d0e:	48 89 d0             	mov    %rdx,%rax
  802d11:	48 83 c2 08          	add    $0x8,%rdx
  802d15:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802d19:	4c 8b 20             	mov    (%rax),%r12
  802d1c:	4d 85 e4             	test   %r12,%r12
  802d1f:	75 0a                	jne    802d2b <vprintfmt+0x2bb>
				p = "(null)";
  802d21:	49 bc 85 40 80 00 00 	movabs $0x804085,%r12
  802d28:	00 00 00 
			if (width > 0 && padc != '-')
  802d2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d2f:	7e 7a                	jle    802dab <vprintfmt+0x33b>
  802d31:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802d35:	74 74                	je     802dab <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  802d37:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802d3a:	48 98                	cltq   
  802d3c:	48 89 c6             	mov    %rax,%rsi
  802d3f:	4c 89 e7             	mov    %r12,%rdi
  802d42:	48 b8 3e 32 80 00 00 	movabs $0x80323e,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
  802d4e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802d51:	eb 17                	jmp    802d6a <vprintfmt+0x2fa>
					putch(padc, putdat);
  802d53:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  802d57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802d5b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  802d5f:	48 89 d6             	mov    %rdx,%rsi
  802d62:	89 c7                	mov    %eax,%edi
  802d64:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802d66:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802d6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d6e:	7f e3                	jg     802d53 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802d70:	eb 39                	jmp    802dab <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  802d72:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802d76:	74 1e                	je     802d96 <vprintfmt+0x326>
  802d78:	83 fb 1f             	cmp    $0x1f,%ebx
  802d7b:	7e 05                	jle    802d82 <vprintfmt+0x312>
  802d7d:	83 fb 7e             	cmp    $0x7e,%ebx
  802d80:	7e 14                	jle    802d96 <vprintfmt+0x326>
					putch('?', putdat);
  802d82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d8a:	48 89 c6             	mov    %rax,%rsi
  802d8d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802d92:	ff d2                	callq  *%rdx
  802d94:	eb 0f                	jmp    802da5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  802d96:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d9a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d9e:	48 89 c6             	mov    %rax,%rsi
  802da1:	89 df                	mov    %ebx,%edi
  802da3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802da5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802da9:	eb 01                	jmp    802dac <vprintfmt+0x33c>
  802dab:	90                   	nop
  802dac:	41 0f b6 04 24       	movzbl (%r12),%eax
  802db1:	0f be d8             	movsbl %al,%ebx
  802db4:	85 db                	test   %ebx,%ebx
  802db6:	0f 95 c0             	setne  %al
  802db9:	49 83 c4 01          	add    $0x1,%r12
  802dbd:	84 c0                	test   %al,%al
  802dbf:	74 28                	je     802de9 <vprintfmt+0x379>
  802dc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802dc5:	78 ab                	js     802d72 <vprintfmt+0x302>
  802dc7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802dcb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802dcf:	79 a1                	jns    802d72 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802dd1:	eb 16                	jmp    802de9 <vprintfmt+0x379>
				putch(' ', putdat);
  802dd3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802dd7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802ddb:	48 89 c6             	mov    %rax,%rsi
  802dde:	bf 20 00 00 00       	mov    $0x20,%edi
  802de3:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802de5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802de9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802ded:	7f e4                	jg     802dd3 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  802def:	e9 90 01 00 00       	jmpq   802f84 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802df4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802df8:	be 03 00 00 00       	mov    $0x3,%esi
  802dfd:	48 89 c7             	mov    %rax,%rdi
  802e00:	48 b8 60 29 80 00 00 	movabs $0x802960,%rax
  802e07:	00 00 00 
  802e0a:	ff d0                	callq  *%rax
  802e0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802e10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e14:	48 85 c0             	test   %rax,%rax
  802e17:	79 1d                	jns    802e36 <vprintfmt+0x3c6>
				putch('-', putdat);
  802e19:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802e1d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802e21:	48 89 c6             	mov    %rax,%rsi
  802e24:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802e29:	ff d2                	callq  *%rdx
				num = -(long long) num;
  802e2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2f:	48 f7 d8             	neg    %rax
  802e32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802e36:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802e3d:	e9 d5 00 00 00       	jmpq   802f17 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802e42:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e46:	be 03 00 00 00       	mov    $0x3,%esi
  802e4b:	48 89 c7             	mov    %rax,%rdi
  802e4e:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802e55:	00 00 00 
  802e58:	ff d0                	callq  *%rax
  802e5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802e5e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802e65:	e9 ad 00 00 00       	jmpq   802f17 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  802e6a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e6e:	be 03 00 00 00       	mov    $0x3,%esi
  802e73:	48 89 c7             	mov    %rax,%rdi
  802e76:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
  802e82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  802e86:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  802e8d:	e9 85 00 00 00       	jmpq   802f17 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  802e92:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802e96:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802e9a:	48 89 c6             	mov    %rax,%rsi
  802e9d:	bf 30 00 00 00       	mov    $0x30,%edi
  802ea2:	ff d2                	callq  *%rdx
			putch('x', putdat);
  802ea4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802ea8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802eac:	48 89 c6             	mov    %rax,%rsi
  802eaf:	bf 78 00 00 00       	mov    $0x78,%edi
  802eb4:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802eb6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802eb9:	83 f8 30             	cmp    $0x30,%eax
  802ebc:	73 17                	jae    802ed5 <vprintfmt+0x465>
  802ebe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ec2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ec5:	89 c0                	mov    %eax,%eax
  802ec7:	48 01 d0             	add    %rdx,%rax
  802eca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ecd:	83 c2 08             	add    $0x8,%edx
  802ed0:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802ed3:	eb 0f                	jmp    802ee4 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  802ed5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ed9:	48 89 d0             	mov    %rdx,%rax
  802edc:	48 83 c2 08          	add    $0x8,%rdx
  802ee0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ee4:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802ee7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802eeb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802ef2:	eb 23                	jmp    802f17 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802ef4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802ef8:	be 03 00 00 00       	mov    $0x3,%esi
  802efd:	48 89 c7             	mov    %rax,%rdi
  802f00:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
  802f0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802f10:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802f17:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802f1c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f1f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802f22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f26:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f2e:	45 89 c1             	mov    %r8d,%r9d
  802f31:	41 89 f8             	mov    %edi,%r8d
  802f34:	48 89 c7             	mov    %rax,%rdi
  802f37:	48 b8 98 27 80 00 00 	movabs $0x802798,%rax
  802f3e:	00 00 00 
  802f41:	ff d0                	callq  *%rax
			break;
  802f43:	eb 3f                	jmp    802f84 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802f45:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802f49:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802f4d:	48 89 c6             	mov    %rax,%rsi
  802f50:	89 df                	mov    %ebx,%edi
  802f52:	ff d2                	callq  *%rdx
			break;
  802f54:	eb 2e                	jmp    802f84 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802f56:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802f5a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802f5e:	48 89 c6             	mov    %rax,%rsi
  802f61:	bf 25 00 00 00       	mov    $0x25,%edi
  802f66:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  802f68:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802f6d:	eb 05                	jmp    802f74 <vprintfmt+0x504>
  802f6f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802f74:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802f78:	48 83 e8 01          	sub    $0x1,%rax
  802f7c:	0f b6 00             	movzbl (%rax),%eax
  802f7f:	3c 25                	cmp    $0x25,%al
  802f81:	75 ec                	jne    802f6f <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  802f83:	90                   	nop
		}
	}
  802f84:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802f85:	e9 38 fb ff ff       	jmpq   802ac2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  802f8a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  802f8b:	48 83 c4 60          	add    $0x60,%rsp
  802f8f:	5b                   	pop    %rbx
  802f90:	41 5c                	pop    %r12
  802f92:	5d                   	pop    %rbp
  802f93:	c3                   	retq   

0000000000802f94 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802f94:	55                   	push   %rbp
  802f95:	48 89 e5             	mov    %rsp,%rbp
  802f98:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802f9f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802fa6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802fad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fb4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fbb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fc2:	84 c0                	test   %al,%al
  802fc4:	74 20                	je     802fe6 <printfmt+0x52>
  802fc6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fd2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fd6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fda:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fde:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fe2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802fe6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802fed:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802ff4:	00 00 00 
  802ff7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802ffe:	00 00 00 
  803001:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803005:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80300c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803013:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80301a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803021:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803028:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80302f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803036:	48 89 c7             	mov    %rax,%rdi
  803039:	48 b8 70 2a 80 00 00 	movabs $0x802a70,%rax
  803040:	00 00 00 
  803043:	ff d0                	callq  *%rax
	va_end(ap);
}
  803045:	c9                   	leaveq 
  803046:	c3                   	retq   

0000000000803047 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803047:	55                   	push   %rbp
  803048:	48 89 e5             	mov    %rsp,%rbp
  80304b:	48 83 ec 10          	sub    $0x10,%rsp
  80304f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803052:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305a:	8b 40 10             	mov    0x10(%rax),%eax
  80305d:	8d 50 01             	lea    0x1(%rax),%edx
  803060:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803064:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306b:	48 8b 10             	mov    (%rax),%rdx
  80306e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803072:	48 8b 40 08          	mov    0x8(%rax),%rax
  803076:	48 39 c2             	cmp    %rax,%rdx
  803079:	73 17                	jae    803092 <sprintputch+0x4b>
		*b->buf++ = ch;
  80307b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307f:	48 8b 00             	mov    (%rax),%rax
  803082:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803085:	88 10                	mov    %dl,(%rax)
  803087:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80308b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308f:	48 89 10             	mov    %rdx,(%rax)
}
  803092:	c9                   	leaveq 
  803093:	c3                   	retq   

0000000000803094 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803094:	55                   	push   %rbp
  803095:	48 89 e5             	mov    %rsp,%rbp
  803098:	48 83 ec 50          	sub    $0x50,%rsp
  80309c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8030a0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8030a3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8030a7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8030ab:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8030af:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8030b3:	48 8b 0a             	mov    (%rdx),%rcx
  8030b6:	48 89 08             	mov    %rcx,(%rax)
  8030b9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8030bd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8030c1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8030c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8030c9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030cd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8030d1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8030d4:	48 98                	cltq   
  8030d6:	48 83 e8 01          	sub    $0x1,%rax
  8030da:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8030de:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8030e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8030e9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8030ee:	74 06                	je     8030f6 <vsnprintf+0x62>
  8030f0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8030f4:	7f 07                	jg     8030fd <vsnprintf+0x69>
		return -E_INVAL;
  8030f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030fb:	eb 2f                	jmp    80312c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8030fd:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803101:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803105:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803109:	48 89 c6             	mov    %rax,%rsi
  80310c:	48 bf 47 30 80 00 00 	movabs $0x803047,%rdi
  803113:	00 00 00 
  803116:	48 b8 70 2a 80 00 00 	movabs $0x802a70,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803122:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803126:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803129:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80312c:	c9                   	leaveq 
  80312d:	c3                   	retq   

000000000080312e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80312e:	55                   	push   %rbp
  80312f:	48 89 e5             	mov    %rsp,%rbp
  803132:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803139:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803140:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803146:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80314d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803154:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80315b:	84 c0                	test   %al,%al
  80315d:	74 20                	je     80317f <snprintf+0x51>
  80315f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803163:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803167:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80316b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80316f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803173:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803177:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80317b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80317f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803186:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80318d:	00 00 00 
  803190:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803197:	00 00 00 
  80319a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80319e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8031a5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8031ac:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8031b3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8031ba:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8031c1:	48 8b 0a             	mov    (%rdx),%rcx
  8031c4:	48 89 08             	mov    %rcx,(%rax)
  8031c7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8031cb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8031cf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8031d3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8031d7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8031de:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8031e5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8031eb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8031f2:	48 89 c7             	mov    %rax,%rdi
  8031f5:	48 b8 94 30 80 00 00 	movabs $0x803094,%rax
  8031fc:	00 00 00 
  8031ff:	ff d0                	callq  *%rax
  803201:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803207:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80320d:	c9                   	leaveq 
  80320e:	c3                   	retq   
	...

0000000000803210 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803210:	55                   	push   %rbp
  803211:	48 89 e5             	mov    %rsp,%rbp
  803214:	48 83 ec 18          	sub    $0x18,%rsp
  803218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80321c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803223:	eb 09                	jmp    80322e <strlen+0x1e>
		n++;
  803225:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803229:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80322e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803232:	0f b6 00             	movzbl (%rax),%eax
  803235:	84 c0                	test   %al,%al
  803237:	75 ec                	jne    803225 <strlen+0x15>
		n++;
	return n;
  803239:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80323c:	c9                   	leaveq 
  80323d:	c3                   	retq   

000000000080323e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80323e:	55                   	push   %rbp
  80323f:	48 89 e5             	mov    %rsp,%rbp
  803242:	48 83 ec 20          	sub    $0x20,%rsp
  803246:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80324a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80324e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803255:	eb 0e                	jmp    803265 <strnlen+0x27>
		n++;
  803257:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80325b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803260:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803265:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80326a:	74 0b                	je     803277 <strnlen+0x39>
  80326c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803270:	0f b6 00             	movzbl (%rax),%eax
  803273:	84 c0                	test   %al,%al
  803275:	75 e0                	jne    803257 <strnlen+0x19>
		n++;
	return n;
  803277:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80327a:	c9                   	leaveq 
  80327b:	c3                   	retq   

000000000080327c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80327c:	55                   	push   %rbp
  80327d:	48 89 e5             	mov    %rsp,%rbp
  803280:	48 83 ec 20          	sub    $0x20,%rsp
  803284:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803288:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80328c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803290:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803294:	90                   	nop
  803295:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803299:	0f b6 10             	movzbl (%rax),%edx
  80329c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a0:	88 10                	mov    %dl,(%rax)
  8032a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a6:	0f b6 00             	movzbl (%rax),%eax
  8032a9:	84 c0                	test   %al,%al
  8032ab:	0f 95 c0             	setne  %al
  8032ae:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8032b3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8032b8:	84 c0                	test   %al,%al
  8032ba:	75 d9                	jne    803295 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8032bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8032c0:	c9                   	leaveq 
  8032c1:	c3                   	retq   

00000000008032c2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8032c2:	55                   	push   %rbp
  8032c3:	48 89 e5             	mov    %rsp,%rbp
  8032c6:	48 83 ec 20          	sub    $0x20,%rsp
  8032ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8032d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d6:	48 89 c7             	mov    %rax,%rdi
  8032d9:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  8032e0:	00 00 00 
  8032e3:	ff d0                	callq  *%rax
  8032e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8032e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032eb:	48 98                	cltq   
  8032ed:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8032f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032f5:	48 89 d6             	mov    %rdx,%rsi
  8032f8:	48 89 c7             	mov    %rax,%rdi
  8032fb:	48 b8 7c 32 80 00 00 	movabs $0x80327c,%rax
  803302:	00 00 00 
  803305:	ff d0                	callq  *%rax
	return dst;
  803307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80330b:	c9                   	leaveq 
  80330c:	c3                   	retq   

000000000080330d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80330d:	55                   	push   %rbp
  80330e:	48 89 e5             	mov    %rsp,%rbp
  803311:	48 83 ec 28          	sub    $0x28,%rsp
  803315:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803319:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80331d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  803321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803325:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  803329:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803330:	00 
  803331:	eb 27                	jmp    80335a <strncpy+0x4d>
		*dst++ = *src;
  803333:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803337:	0f b6 10             	movzbl (%rax),%edx
  80333a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333e:	88 10                	mov    %dl,(%rax)
  803340:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803345:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803349:	0f b6 00             	movzbl (%rax),%eax
  80334c:	84 c0                	test   %al,%al
  80334e:	74 05                	je     803355 <strncpy+0x48>
			src++;
  803350:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  803355:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80335a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80335e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803362:	72 cf                	jb     803333 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  803364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803368:	c9                   	leaveq 
  803369:	c3                   	retq   

000000000080336a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80336a:	55                   	push   %rbp
  80336b:	48 89 e5             	mov    %rsp,%rbp
  80336e:	48 83 ec 28          	sub    $0x28,%rsp
  803372:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803376:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80337a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80337e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803382:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  803386:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80338b:	74 37                	je     8033c4 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80338d:	eb 17                	jmp    8033a6 <strlcpy+0x3c>
			*dst++ = *src++;
  80338f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803393:	0f b6 10             	movzbl (%rax),%edx
  803396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339a:	88 10                	mov    %dl,(%rax)
  80339c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8033a1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8033a6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8033ab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033b0:	74 0b                	je     8033bd <strlcpy+0x53>
  8033b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b6:	0f b6 00             	movzbl (%rax),%eax
  8033b9:	84 c0                	test   %al,%al
  8033bb:	75 d2                	jne    80338f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8033bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8033c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cc:	48 89 d1             	mov    %rdx,%rcx
  8033cf:	48 29 c1             	sub    %rax,%rcx
  8033d2:	48 89 c8             	mov    %rcx,%rax
}
  8033d5:	c9                   	leaveq 
  8033d6:	c3                   	retq   

00000000008033d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8033d7:	55                   	push   %rbp
  8033d8:	48 89 e5             	mov    %rsp,%rbp
  8033db:	48 83 ec 10          	sub    $0x10,%rsp
  8033df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8033e7:	eb 0a                	jmp    8033f3 <strcmp+0x1c>
		p++, q++;
  8033e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033ee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8033f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f7:	0f b6 00             	movzbl (%rax),%eax
  8033fa:	84 c0                	test   %al,%al
  8033fc:	74 12                	je     803410 <strcmp+0x39>
  8033fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803402:	0f b6 10             	movzbl (%rax),%edx
  803405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803409:	0f b6 00             	movzbl (%rax),%eax
  80340c:	38 c2                	cmp    %al,%dl
  80340e:	74 d9                	je     8033e9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  803410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803414:	0f b6 00             	movzbl (%rax),%eax
  803417:	0f b6 d0             	movzbl %al,%edx
  80341a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341e:	0f b6 00             	movzbl (%rax),%eax
  803421:	0f b6 c0             	movzbl %al,%eax
  803424:	89 d1                	mov    %edx,%ecx
  803426:	29 c1                	sub    %eax,%ecx
  803428:	89 c8                	mov    %ecx,%eax
}
  80342a:	c9                   	leaveq 
  80342b:	c3                   	retq   

000000000080342c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80342c:	55                   	push   %rbp
  80342d:	48 89 e5             	mov    %rsp,%rbp
  803430:	48 83 ec 18          	sub    $0x18,%rsp
  803434:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803438:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80343c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  803440:	eb 0f                	jmp    803451 <strncmp+0x25>
		n--, p++, q++;
  803442:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  803447:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80344c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  803451:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803456:	74 1d                	je     803475 <strncmp+0x49>
  803458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80345c:	0f b6 00             	movzbl (%rax),%eax
  80345f:	84 c0                	test   %al,%al
  803461:	74 12                	je     803475 <strncmp+0x49>
  803463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803467:	0f b6 10             	movzbl (%rax),%edx
  80346a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80346e:	0f b6 00             	movzbl (%rax),%eax
  803471:	38 c2                	cmp    %al,%dl
  803473:	74 cd                	je     803442 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  803475:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80347a:	75 07                	jne    803483 <strncmp+0x57>
		return 0;
  80347c:	b8 00 00 00 00       	mov    $0x0,%eax
  803481:	eb 1a                	jmp    80349d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  803483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803487:	0f b6 00             	movzbl (%rax),%eax
  80348a:	0f b6 d0             	movzbl %al,%edx
  80348d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803491:	0f b6 00             	movzbl (%rax),%eax
  803494:	0f b6 c0             	movzbl %al,%eax
  803497:	89 d1                	mov    %edx,%ecx
  803499:	29 c1                	sub    %eax,%ecx
  80349b:	89 c8                	mov    %ecx,%eax
}
  80349d:	c9                   	leaveq 
  80349e:	c3                   	retq   

000000000080349f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80349f:	55                   	push   %rbp
  8034a0:	48 89 e5             	mov    %rsp,%rbp
  8034a3:	48 83 ec 10          	sub    $0x10,%rsp
  8034a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034ab:	89 f0                	mov    %esi,%eax
  8034ad:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8034b0:	eb 17                	jmp    8034c9 <strchr+0x2a>
		if (*s == c)
  8034b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b6:	0f b6 00             	movzbl (%rax),%eax
  8034b9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8034bc:	75 06                	jne    8034c4 <strchr+0x25>
			return (char *) s;
  8034be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c2:	eb 15                	jmp    8034d9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8034c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034cd:	0f b6 00             	movzbl (%rax),%eax
  8034d0:	84 c0                	test   %al,%al
  8034d2:	75 de                	jne    8034b2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8034d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034d9:	c9                   	leaveq 
  8034da:	c3                   	retq   

00000000008034db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8034db:	55                   	push   %rbp
  8034dc:	48 89 e5             	mov    %rsp,%rbp
  8034df:	48 83 ec 10          	sub    $0x10,%rsp
  8034e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e7:	89 f0                	mov    %esi,%eax
  8034e9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8034ec:	eb 11                	jmp    8034ff <strfind+0x24>
		if (*s == c)
  8034ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f2:	0f b6 00             	movzbl (%rax),%eax
  8034f5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8034f8:	74 12                	je     80350c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8034fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803503:	0f b6 00             	movzbl (%rax),%eax
  803506:	84 c0                	test   %al,%al
  803508:	75 e4                	jne    8034ee <strfind+0x13>
  80350a:	eb 01                	jmp    80350d <strfind+0x32>
		if (*s == c)
			break;
  80350c:	90                   	nop
	return (char *) s;
  80350d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803511:	c9                   	leaveq 
  803512:	c3                   	retq   

0000000000803513 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  803513:	55                   	push   %rbp
  803514:	48 89 e5             	mov    %rsp,%rbp
  803517:	48 83 ec 18          	sub    $0x18,%rsp
  80351b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80351f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  803522:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  803526:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80352b:	75 06                	jne    803533 <memset+0x20>
		return v;
  80352d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803531:	eb 69                	jmp    80359c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  803533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803537:	83 e0 03             	and    $0x3,%eax
  80353a:	48 85 c0             	test   %rax,%rax
  80353d:	75 48                	jne    803587 <memset+0x74>
  80353f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803543:	83 e0 03             	and    $0x3,%eax
  803546:	48 85 c0             	test   %rax,%rax
  803549:	75 3c                	jne    803587 <memset+0x74>
		c &= 0xFF;
  80354b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  803552:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803555:	89 c2                	mov    %eax,%edx
  803557:	c1 e2 18             	shl    $0x18,%edx
  80355a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80355d:	c1 e0 10             	shl    $0x10,%eax
  803560:	09 c2                	or     %eax,%edx
  803562:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803565:	c1 e0 08             	shl    $0x8,%eax
  803568:	09 d0                	or     %edx,%eax
  80356a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80356d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803571:	48 89 c1             	mov    %rax,%rcx
  803574:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  803578:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80357c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80357f:	48 89 d7             	mov    %rdx,%rdi
  803582:	fc                   	cld    
  803583:	f3 ab                	rep stos %eax,%es:(%rdi)
  803585:	eb 11                	jmp    803598 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  803587:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80358b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80358e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803592:	48 89 d7             	mov    %rdx,%rdi
  803595:	fc                   	cld    
  803596:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  803598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80359c:	c9                   	leaveq 
  80359d:	c3                   	retq   

000000000080359e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80359e:	55                   	push   %rbp
  80359f:	48 89 e5             	mov    %rsp,%rbp
  8035a2:	48 83 ec 28          	sub    $0x28,%rsp
  8035a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8035b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8035ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8035c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8035ca:	0f 83 88 00 00 00    	jae    803658 <memmove+0xba>
  8035d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035d8:	48 01 d0             	add    %rdx,%rax
  8035db:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8035df:	76 77                	jbe    803658 <memmove+0xba>
		s += n;
  8035e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8035e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ed:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8035f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f5:	83 e0 03             	and    $0x3,%eax
  8035f8:	48 85 c0             	test   %rax,%rax
  8035fb:	75 3b                	jne    803638 <memmove+0x9a>
  8035fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803601:	83 e0 03             	and    $0x3,%eax
  803604:	48 85 c0             	test   %rax,%rax
  803607:	75 2f                	jne    803638 <memmove+0x9a>
  803609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360d:	83 e0 03             	and    $0x3,%eax
  803610:	48 85 c0             	test   %rax,%rax
  803613:	75 23                	jne    803638 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803619:	48 83 e8 04          	sub    $0x4,%rax
  80361d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803621:	48 83 ea 04          	sub    $0x4,%rdx
  803625:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803629:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80362d:	48 89 c7             	mov    %rax,%rdi
  803630:	48 89 d6             	mov    %rdx,%rsi
  803633:	fd                   	std    
  803634:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803636:	eb 1d                	jmp    803655 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  803638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803644:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364c:	48 89 d7             	mov    %rdx,%rdi
  80364f:	48 89 c1             	mov    %rax,%rcx
  803652:	fd                   	std    
  803653:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803655:	fc                   	cld    
  803656:	eb 57                	jmp    8036af <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365c:	83 e0 03             	and    $0x3,%eax
  80365f:	48 85 c0             	test   %rax,%rax
  803662:	75 36                	jne    80369a <memmove+0xfc>
  803664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803668:	83 e0 03             	and    $0x3,%eax
  80366b:	48 85 c0             	test   %rax,%rax
  80366e:	75 2a                	jne    80369a <memmove+0xfc>
  803670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803674:	83 e0 03             	and    $0x3,%eax
  803677:	48 85 c0             	test   %rax,%rax
  80367a:	75 1e                	jne    80369a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80367c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803680:	48 89 c1             	mov    %rax,%rcx
  803683:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80368f:	48 89 c7             	mov    %rax,%rdi
  803692:	48 89 d6             	mov    %rdx,%rsi
  803695:	fc                   	cld    
  803696:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803698:	eb 15                	jmp    8036af <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80369a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036a2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8036a6:	48 89 c7             	mov    %rax,%rdi
  8036a9:	48 89 d6             	mov    %rdx,%rsi
  8036ac:	fc                   	cld    
  8036ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8036af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8036b3:	c9                   	leaveq 
  8036b4:	c3                   	retq   

00000000008036b5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8036b5:	55                   	push   %rbp
  8036b6:	48 89 e5             	mov    %rsp,%rbp
  8036b9:	48 83 ec 18          	sub    $0x18,%rsp
  8036bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8036c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036cd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8036d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d5:	48 89 ce             	mov    %rcx,%rsi
  8036d8:	48 89 c7             	mov    %rax,%rdi
  8036db:	48 b8 9e 35 80 00 00 	movabs $0x80359e,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
}
  8036e7:	c9                   	leaveq 
  8036e8:	c3                   	retq   

00000000008036e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8036e9:	55                   	push   %rbp
  8036ea:	48 89 e5             	mov    %rsp,%rbp
  8036ed:	48 83 ec 28          	sub    $0x28,%rsp
  8036f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8036fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803701:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803705:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803709:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80370d:	eb 38                	jmp    803747 <memcmp+0x5e>
		if (*s1 != *s2)
  80370f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803713:	0f b6 10             	movzbl (%rax),%edx
  803716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371a:	0f b6 00             	movzbl (%rax),%eax
  80371d:	38 c2                	cmp    %al,%dl
  80371f:	74 1c                	je     80373d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  803721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803725:	0f b6 00             	movzbl (%rax),%eax
  803728:	0f b6 d0             	movzbl %al,%edx
  80372b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372f:	0f b6 00             	movzbl (%rax),%eax
  803732:	0f b6 c0             	movzbl %al,%eax
  803735:	89 d1                	mov    %edx,%ecx
  803737:	29 c1                	sub    %eax,%ecx
  803739:	89 c8                	mov    %ecx,%eax
  80373b:	eb 20                	jmp    80375d <memcmp+0x74>
		s1++, s2++;
  80373d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803742:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803747:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80374c:	0f 95 c0             	setne  %al
  80374f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  803754:	84 c0                	test   %al,%al
  803756:	75 b7                	jne    80370f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80375d:	c9                   	leaveq 
  80375e:	c3                   	retq   

000000000080375f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80375f:	55                   	push   %rbp
  803760:	48 89 e5             	mov    %rsp,%rbp
  803763:	48 83 ec 28          	sub    $0x28,%rsp
  803767:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80376b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80376e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803772:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803776:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80377a:	48 01 d0             	add    %rdx,%rax
  80377d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803781:	eb 13                	jmp    803796 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  803783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803787:	0f b6 10             	movzbl (%rax),%edx
  80378a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80378d:	38 c2                	cmp    %al,%dl
  80378f:	74 11                	je     8037a2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803791:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80379a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80379e:	72 e3                	jb     803783 <memfind+0x24>
  8037a0:	eb 01                	jmp    8037a3 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8037a2:	90                   	nop
	return (void *) s;
  8037a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8037a7:	c9                   	leaveq 
  8037a8:	c3                   	retq   

00000000008037a9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8037a9:	55                   	push   %rbp
  8037aa:	48 89 e5             	mov    %rsp,%rbp
  8037ad:	48 83 ec 38          	sub    $0x38,%rsp
  8037b1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037b9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8037bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8037c3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8037ca:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8037cb:	eb 05                	jmp    8037d2 <strtol+0x29>
		s++;
  8037cd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8037d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d6:	0f b6 00             	movzbl (%rax),%eax
  8037d9:	3c 20                	cmp    $0x20,%al
  8037db:	74 f0                	je     8037cd <strtol+0x24>
  8037dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e1:	0f b6 00             	movzbl (%rax),%eax
  8037e4:	3c 09                	cmp    $0x9,%al
  8037e6:	74 e5                	je     8037cd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8037e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ec:	0f b6 00             	movzbl (%rax),%eax
  8037ef:	3c 2b                	cmp    $0x2b,%al
  8037f1:	75 07                	jne    8037fa <strtol+0x51>
		s++;
  8037f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8037f8:	eb 17                	jmp    803811 <strtol+0x68>
	else if (*s == '-')
  8037fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037fe:	0f b6 00             	movzbl (%rax),%eax
  803801:	3c 2d                	cmp    $0x2d,%al
  803803:	75 0c                	jne    803811 <strtol+0x68>
		s++, neg = 1;
  803805:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80380a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803811:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803815:	74 06                	je     80381d <strtol+0x74>
  803817:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80381b:	75 28                	jne    803845 <strtol+0x9c>
  80381d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803821:	0f b6 00             	movzbl (%rax),%eax
  803824:	3c 30                	cmp    $0x30,%al
  803826:	75 1d                	jne    803845 <strtol+0x9c>
  803828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80382c:	48 83 c0 01          	add    $0x1,%rax
  803830:	0f b6 00             	movzbl (%rax),%eax
  803833:	3c 78                	cmp    $0x78,%al
  803835:	75 0e                	jne    803845 <strtol+0x9c>
		s += 2, base = 16;
  803837:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80383c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803843:	eb 2c                	jmp    803871 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803845:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803849:	75 19                	jne    803864 <strtol+0xbb>
  80384b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384f:	0f b6 00             	movzbl (%rax),%eax
  803852:	3c 30                	cmp    $0x30,%al
  803854:	75 0e                	jne    803864 <strtol+0xbb>
		s++, base = 8;
  803856:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80385b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803862:	eb 0d                	jmp    803871 <strtol+0xc8>
	else if (base == 0)
  803864:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803868:	75 07                	jne    803871 <strtol+0xc8>
		base = 10;
  80386a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803875:	0f b6 00             	movzbl (%rax),%eax
  803878:	3c 2f                	cmp    $0x2f,%al
  80387a:	7e 1d                	jle    803899 <strtol+0xf0>
  80387c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803880:	0f b6 00             	movzbl (%rax),%eax
  803883:	3c 39                	cmp    $0x39,%al
  803885:	7f 12                	jg     803899 <strtol+0xf0>
			dig = *s - '0';
  803887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388b:	0f b6 00             	movzbl (%rax),%eax
  80388e:	0f be c0             	movsbl %al,%eax
  803891:	83 e8 30             	sub    $0x30,%eax
  803894:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803897:	eb 4e                	jmp    8038e7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80389d:	0f b6 00             	movzbl (%rax),%eax
  8038a0:	3c 60                	cmp    $0x60,%al
  8038a2:	7e 1d                	jle    8038c1 <strtol+0x118>
  8038a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a8:	0f b6 00             	movzbl (%rax),%eax
  8038ab:	3c 7a                	cmp    $0x7a,%al
  8038ad:	7f 12                	jg     8038c1 <strtol+0x118>
			dig = *s - 'a' + 10;
  8038af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b3:	0f b6 00             	movzbl (%rax),%eax
  8038b6:	0f be c0             	movsbl %al,%eax
  8038b9:	83 e8 57             	sub    $0x57,%eax
  8038bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038bf:	eb 26                	jmp    8038e7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8038c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c5:	0f b6 00             	movzbl (%rax),%eax
  8038c8:	3c 40                	cmp    $0x40,%al
  8038ca:	7e 47                	jle    803913 <strtol+0x16a>
  8038cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d0:	0f b6 00             	movzbl (%rax),%eax
  8038d3:	3c 5a                	cmp    $0x5a,%al
  8038d5:	7f 3c                	jg     803913 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8038d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038db:	0f b6 00             	movzbl (%rax),%eax
  8038de:	0f be c0             	movsbl %al,%eax
  8038e1:	83 e8 37             	sub    $0x37,%eax
  8038e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8038e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ea:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8038ed:	7d 23                	jge    803912 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8038ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8038f4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8038f7:	48 98                	cltq   
  8038f9:	48 89 c2             	mov    %rax,%rdx
  8038fc:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  803901:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803904:	48 98                	cltq   
  803906:	48 01 d0             	add    %rdx,%rax
  803909:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80390d:	e9 5f ff ff ff       	jmpq   803871 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  803912:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  803913:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803918:	74 0b                	je     803925 <strtol+0x17c>
		*endptr = (char *) s;
  80391a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80391e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803922:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803925:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803929:	74 09                	je     803934 <strtol+0x18b>
  80392b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392f:	48 f7 d8             	neg    %rax
  803932:	eb 04                	jmp    803938 <strtol+0x18f>
  803934:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803938:	c9                   	leaveq 
  803939:	c3                   	retq   

000000000080393a <strstr>:

char * strstr(const char *in, const char *str)
{
  80393a:	55                   	push   %rbp
  80393b:	48 89 e5             	mov    %rsp,%rbp
  80393e:	48 83 ec 30          	sub    $0x30,%rsp
  803942:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803946:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80394a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80394e:	0f b6 00             	movzbl (%rax),%eax
  803951:	88 45 ff             	mov    %al,-0x1(%rbp)
  803954:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  803959:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80395d:	75 06                	jne    803965 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80395f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803963:	eb 68                	jmp    8039cd <strstr+0x93>

    len = strlen(str);
  803965:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803969:	48 89 c7             	mov    %rax,%rdi
  80396c:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  803973:	00 00 00 
  803976:	ff d0                	callq  *%rax
  803978:	48 98                	cltq   
  80397a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80397e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803982:	0f b6 00             	movzbl (%rax),%eax
  803985:	88 45 ef             	mov    %al,-0x11(%rbp)
  803988:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80398d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803991:	75 07                	jne    80399a <strstr+0x60>
                return (char *) 0;
  803993:	b8 00 00 00 00       	mov    $0x0,%eax
  803998:	eb 33                	jmp    8039cd <strstr+0x93>
        } while (sc != c);
  80399a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80399e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8039a1:	75 db                	jne    80397e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8039a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039a7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8039ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039af:	48 89 ce             	mov    %rcx,%rsi
  8039b2:	48 89 c7             	mov    %rax,%rdi
  8039b5:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
  8039c1:	85 c0                	test   %eax,%eax
  8039c3:	75 b9                	jne    80397e <strstr+0x44>

    return (char *) (in - 1);
  8039c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c9:	48 83 e8 01          	sub    $0x1,%rax
}
  8039cd:	c9                   	leaveq 
  8039ce:	c3                   	retq   
	...

00000000008039d0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8039d0:	55                   	push   %rbp
  8039d1:	48 89 e5             	mov    %rsp,%rbp
  8039d4:	48 83 ec 20          	sub    $0x20,%rsp
  8039d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  8039dc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039e3:	00 00 00 
  8039e6:	48 8b 00             	mov    (%rax),%rax
  8039e9:	48 85 c0             	test   %rax,%rax
  8039ec:	0f 85 8e 00 00 00    	jne    803a80 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  8039f2:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  8039f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  803a00:	48 b8 ac 02 80 00 00 	movabs $0x8002ac,%rax
  803a07:	00 00 00 
  803a0a:	ff d0                	callq  *%rax
  803a0c:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  803a0f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803a13:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a16:	ba 07 00 00 00       	mov    $0x7,%edx
  803a1b:	48 89 ce             	mov    %rcx,%rsi
  803a1e:	89 c7                	mov    %eax,%edi
  803a20:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  803a27:	00 00 00 
  803a2a:	ff d0                	callq  *%rax
  803a2c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  803a2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803a33:	74 30                	je     803a65 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  803a35:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a38:	89 c1                	mov    %eax,%ecx
  803a3a:	48 ba 40 43 80 00 00 	movabs $0x804340,%rdx
  803a41:	00 00 00 
  803a44:	be 24 00 00 00       	mov    $0x24,%esi
  803a49:	48 bf 77 43 80 00 00 	movabs $0x804377,%rdi
  803a50:	00 00 00 
  803a53:	b8 00 00 00 00       	mov    $0x0,%eax
  803a58:	49 b8 84 24 80 00 00 	movabs $0x802484,%r8
  803a5f:	00 00 00 
  803a62:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  803a65:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a68:	48 be 68 06 80 00 00 	movabs $0x800668,%rsi
  803a6f:	00 00 00 
  803a72:	89 c7                	mov    %eax,%edi
  803a74:	48 b8 b2 04 80 00 00 	movabs $0x8004b2,%rax
  803a7b:	00 00 00 
  803a7e:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803a80:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a87:	00 00 00 
  803a8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a8e:	48 89 10             	mov    %rdx,(%rax)
}
  803a91:	c9                   	leaveq 
  803a92:	c3                   	retq   
	...

0000000000803a94 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a94:	55                   	push   %rbp
  803a95:	48 89 e5             	mov    %rsp,%rbp
  803a98:	48 83 ec 30          	sub    $0x30,%rsp
  803a9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803aa0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803aa4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803aa8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803aad:	74 18                	je     803ac7 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803aaf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab3:	48 89 c7             	mov    %rax,%rdi
  803ab6:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
  803ac2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ac5:	eb 19                	jmp    803ae0 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803ac7:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803ace:	00 00 00 
  803ad1:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  803ad8:	00 00 00 
  803adb:	ff d0                	callq  *%rax
  803add:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803ae0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae4:	79 19                	jns    803aff <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803ae6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803af0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803afa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803afd:	eb 53                	jmp    803b52 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803aff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803b04:	74 19                	je     803b1f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803b06:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803b0d:	00 00 00 
  803b10:	48 8b 00             	mov    (%rax),%rax
  803b13:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b1d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803b1f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b24:	74 19                	je     803b3f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803b26:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803b2d:	00 00 00 
  803b30:	48 8b 00             	mov    (%rax),%rax
  803b33:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803b39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b3d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803b3f:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803b46:	00 00 00 
  803b49:	48 8b 00             	mov    (%rax),%rax
  803b4c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803b52:	c9                   	leaveq 
  803b53:	c3                   	retq   

0000000000803b54 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b54:	55                   	push   %rbp
  803b55:	48 89 e5             	mov    %rsp,%rbp
  803b58:	48 83 ec 30          	sub    $0x30,%rsp
  803b5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b5f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b62:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b66:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803b69:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803b70:	e9 96 00 00 00       	jmpq   803c0b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803b75:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b7a:	74 20                	je     803b9c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803b7c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b7f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b82:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b89:	89 c7                	mov    %eax,%edi
  803b8b:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  803b92:	00 00 00 
  803b95:	ff d0                	callq  *%rax
  803b97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b9a:	eb 2d                	jmp    803bc9 <ipc_send+0x75>
		else if(pg==NULL)
  803b9c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ba1:	75 26                	jne    803bc9 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803ba3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ba6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba9:	b9 00 00 00 00       	mov    $0x0,%ecx
  803bae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803bb5:	00 00 00 
  803bb8:	89 c7                	mov    %eax,%edi
  803bba:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  803bc1:	00 00 00 
  803bc4:	ff d0                	callq  *%rax
  803bc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803bc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bcd:	79 30                	jns    803bff <ipc_send+0xab>
  803bcf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803bd3:	74 2a                	je     803bff <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803bd5:	48 ba 85 43 80 00 00 	movabs $0x804385,%rdx
  803bdc:	00 00 00 
  803bdf:	be 40 00 00 00       	mov    $0x40,%esi
  803be4:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  803beb:	00 00 00 
  803bee:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf3:	48 b9 84 24 80 00 00 	movabs $0x802484,%rcx
  803bfa:	00 00 00 
  803bfd:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803bff:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  803c06:	00 00 00 
  803c09:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803c0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0f:	0f 85 60 ff ff ff    	jne    803b75 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803c15:	c9                   	leaveq 
  803c16:	c3                   	retq   

0000000000803c17 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803c17:	55                   	push   %rbp
  803c18:	48 89 e5             	mov    %rsp,%rbp
  803c1b:	48 83 ec 18          	sub    $0x18,%rsp
  803c1f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803c22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c29:	eb 5e                	jmp    803c89 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803c2b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803c32:	00 00 00 
  803c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c38:	48 63 d0             	movslq %eax,%rdx
  803c3b:	48 89 d0             	mov    %rdx,%rax
  803c3e:	48 c1 e0 03          	shl    $0x3,%rax
  803c42:	48 01 d0             	add    %rdx,%rax
  803c45:	48 c1 e0 05          	shl    $0x5,%rax
  803c49:	48 01 c8             	add    %rcx,%rax
  803c4c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803c52:	8b 00                	mov    (%rax),%eax
  803c54:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803c57:	75 2c                	jne    803c85 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803c59:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803c60:	00 00 00 
  803c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c66:	48 63 d0             	movslq %eax,%rdx
  803c69:	48 89 d0             	mov    %rdx,%rax
  803c6c:	48 c1 e0 03          	shl    $0x3,%rax
  803c70:	48 01 d0             	add    %rdx,%rax
  803c73:	48 c1 e0 05          	shl    $0x5,%rax
  803c77:	48 01 c8             	add    %rcx,%rax
  803c7a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803c80:	8b 40 08             	mov    0x8(%rax),%eax
  803c83:	eb 12                	jmp    803c97 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803c85:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c89:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c90:	7e 99                	jle    803c2b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c97:	c9                   	leaveq 
  803c98:	c3                   	retq   
  803c99:	00 00                	add    %al,(%rax)
	...

0000000000803c9c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c9c:	55                   	push   %rbp
  803c9d:	48 89 e5             	mov    %rsp,%rbp
  803ca0:	48 83 ec 18          	sub    $0x18,%rsp
  803ca4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ca8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cac:	48 89 c2             	mov    %rax,%rdx
  803caf:	48 c1 ea 15          	shr    $0x15,%rdx
  803cb3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803cba:	01 00 00 
  803cbd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cc1:	83 e0 01             	and    $0x1,%eax
  803cc4:	48 85 c0             	test   %rax,%rax
  803cc7:	75 07                	jne    803cd0 <pageref+0x34>
		return 0;
  803cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cce:	eb 53                	jmp    803d23 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd4:	48 89 c2             	mov    %rax,%rdx
  803cd7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803cdb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ce2:	01 00 00 
  803ce5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ce9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf1:	83 e0 01             	and    $0x1,%eax
  803cf4:	48 85 c0             	test   %rax,%rax
  803cf7:	75 07                	jne    803d00 <pageref+0x64>
		return 0;
  803cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfe:	eb 23                	jmp    803d23 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803d00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d04:	48 89 c2             	mov    %rax,%rdx
  803d07:	48 c1 ea 0c          	shr    $0xc,%rdx
  803d0b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803d12:	00 00 00 
  803d15:	48 c1 e2 04          	shl    $0x4,%rdx
  803d19:	48 01 d0             	add    %rdx,%rax
  803d1c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803d20:	0f b7 c0             	movzwl %ax,%eax
}
  803d23:	c9                   	leaveq 
  803d24:	c3                   	retq   
