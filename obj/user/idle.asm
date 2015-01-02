
obj/user/idle.debug:     file format elf64-x86-64


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
  80003c:	e8 37 00 00 00       	callq  800078 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800053:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005a:	00 00 00 
  80005d:	48 ba e0 3b 80 00 00 	movabs $0x803be0,%rdx
  800064:	00 00 00 
  800067:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  80006a:	48 b8 e6 02 80 00 00 	movabs $0x8002e6,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
	}
  800076:	eb f2                	jmp    80006a <umain+0x26>

0000000000800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %rbp
  800079:	48 89 e5             	mov    %rsp,%rbp
  80007c:	48 83 ec 10          	sub    $0x10,%rsp
  800080:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800083:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800087:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80008e:	00 00 00 
  800091:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800098:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  80009f:	00 00 00 
  8000a2:	ff d0                	callq  *%rax
  8000a4:	48 98                	cltq   
  8000a6:	48 89 c2             	mov    %rax,%rdx
  8000a9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8000af:	48 89 d0             	mov    %rdx,%rax
  8000b2:	48 c1 e0 03          	shl    $0x3,%rax
  8000b6:	48 01 d0             	add    %rdx,%rax
  8000b9:	48 c1 e0 05          	shl    $0x5,%rax
  8000bd:	48 89 c2             	mov    %rax,%rdx
  8000c0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c7:	00 00 00 
  8000ca:	48 01 c2             	add    %rax,%rdx
  8000cd:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8000d4:	00 00 00 
  8000d7:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000de:	7e 14                	jle    8000f4 <libmain+0x7c>
		binaryname = argv[0];
  8000e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000e4:	48 8b 10             	mov    (%rax),%rdx
  8000e7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000ee:	00 00 00 
  8000f1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000fb:	48 89 d6             	mov    %rdx,%rsi
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80010c:	48 b8 1c 01 80 00 00 	movabs $0x80011c,%rax
  800113:	00 00 00 
  800116:	ff d0                	callq  *%rax
}
  800118:	c9                   	leaveq 
  800119:	c3                   	retq   
	...

000000000080011c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011c:	55                   	push   %rbp
  80011d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800120:	48 b8 a5 09 80 00 00 	movabs $0x8009a5,%rax
  800127:	00 00 00 
  80012a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80012c:	bf 00 00 00 00       	mov    $0x0,%edi
  800131:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  800138:	00 00 00 
  80013b:	ff d0                	callq  *%rax
}
  80013d:	5d                   	pop    %rbp
  80013e:	c3                   	retq   
	...

0000000000800140 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800140:	55                   	push   %rbp
  800141:	48 89 e5             	mov    %rsp,%rbp
  800144:	53                   	push   %rbx
  800145:	48 83 ec 58          	sub    $0x58,%rsp
  800149:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80014c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80014f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800153:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800157:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80015b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80015f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800162:	89 45 ac             	mov    %eax,-0x54(%rbp)
  800165:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800169:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80016d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800171:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800175:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800179:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80017c:	4c 89 c3             	mov    %r8,%rbx
  80017f:	cd 30                	int    $0x30
  800181:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  800185:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800189:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80018d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800191:	74 3e                	je     8001d1 <syscall+0x91>
  800193:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800198:	7e 37                	jle    8001d1 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80019a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80019e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001a1:	49 89 d0             	mov    %rdx,%r8
  8001a4:	89 c1                	mov    %eax,%ecx
  8001a6:	48 ba ef 3b 80 00 00 	movabs $0x803bef,%rdx
  8001ad:	00 00 00 
  8001b0:	be 23 00 00 00       	mov    $0x23,%esi
  8001b5:	48 bf 0c 3c 80 00 00 	movabs $0x803c0c,%rdi
  8001bc:	00 00 00 
  8001bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c4:	49 b9 f4 23 80 00 00 	movabs $0x8023f4,%r9
  8001cb:	00 00 00 
  8001ce:	41 ff d1             	callq  *%r9

	return ret;
  8001d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001d5:	48 83 c4 58          	add    $0x58,%rsp
  8001d9:	5b                   	pop    %rbx
  8001da:	5d                   	pop    %rbp
  8001db:	c3                   	retq   

00000000008001dc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001dc:	55                   	push   %rbp
  8001dd:	48 89 e5             	mov    %rsp,%rbp
  8001e0:	48 83 ec 20          	sub    $0x20,%rsp
  8001e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001fb:	00 
  8001fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800202:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800208:	48 89 d1             	mov    %rdx,%rcx
  80020b:	48 89 c2             	mov    %rax,%rdx
  80020e:	be 00 00 00 00       	mov    $0x0,%esi
  800213:	bf 00 00 00 00       	mov    $0x0,%edi
  800218:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  80021f:	00 00 00 
  800222:	ff d0                	callq  *%rax
}
  800224:	c9                   	leaveq 
  800225:	c3                   	retq   

0000000000800226 <sys_cgetc>:

int
sys_cgetc(void)
{
  800226:	55                   	push   %rbp
  800227:	48 89 e5             	mov    %rsp,%rbp
  80022a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80022e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800235:	00 
  800236:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80023c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	ba 00 00 00 00       	mov    $0x0,%edx
  80024c:	be 00 00 00 00       	mov    $0x0,%esi
  800251:	bf 01 00 00 00       	mov    $0x1,%edi
  800256:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
}
  800262:	c9                   	leaveq 
  800263:	c3                   	retq   

0000000000800264 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800264:	55                   	push   %rbp
  800265:	48 89 e5             	mov    %rsp,%rbp
  800268:	48 83 ec 20          	sub    $0x20,%rsp
  80026c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80026f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800272:	48 98                	cltq   
  800274:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80027b:	00 
  80027c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800282:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800288:	b9 00 00 00 00       	mov    $0x0,%ecx
  80028d:	48 89 c2             	mov    %rax,%rdx
  800290:	be 01 00 00 00       	mov    $0x1,%esi
  800295:	bf 03 00 00 00       	mov    $0x3,%edi
  80029a:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	c9                   	leaveq 
  8002a7:	c3                   	retq   

00000000008002a8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002b7:	00 
  8002b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ce:	be 00 00 00 00       	mov    $0x0,%esi
  8002d3:	bf 02 00 00 00       	mov    $0x2,%edi
  8002d8:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  8002df:	00 00 00 
  8002e2:	ff d0                	callq  *%rax
}
  8002e4:	c9                   	leaveq 
  8002e5:	c3                   	retq   

00000000008002e6 <sys_yield>:

void
sys_yield(void)
{
  8002e6:	55                   	push   %rbp
  8002e7:	48 89 e5             	mov    %rsp,%rbp
  8002ea:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002f5:	00 
  8002f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800302:	b9 00 00 00 00       	mov    $0x0,%ecx
  800307:	ba 00 00 00 00       	mov    $0x0,%edx
  80030c:	be 00 00 00 00       	mov    $0x0,%esi
  800311:	bf 0b 00 00 00       	mov    $0xb,%edi
  800316:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  80031d:	00 00 00 
  800320:	ff d0                	callq  *%rax
}
  800322:	c9                   	leaveq 
  800323:	c3                   	retq   

0000000000800324 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800324:	55                   	push   %rbp
  800325:	48 89 e5             	mov    %rsp,%rbp
  800328:	48 83 ec 20          	sub    $0x20,%rsp
  80032c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800333:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800336:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800339:	48 63 c8             	movslq %eax,%rcx
  80033c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800343:	48 98                	cltq   
  800345:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80034c:	00 
  80034d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800353:	49 89 c8             	mov    %rcx,%r8
  800356:	48 89 d1             	mov    %rdx,%rcx
  800359:	48 89 c2             	mov    %rax,%rdx
  80035c:	be 01 00 00 00       	mov    $0x1,%esi
  800361:	bf 04 00 00 00       	mov    $0x4,%edi
  800366:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  80036d:	00 00 00 
  800370:	ff d0                	callq  *%rax
}
  800372:	c9                   	leaveq 
  800373:	c3                   	retq   

0000000000800374 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800374:	55                   	push   %rbp
  800375:	48 89 e5             	mov    %rsp,%rbp
  800378:	48 83 ec 30          	sub    $0x30,%rsp
  80037c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80037f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800383:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800386:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80038a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80038e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800391:	48 63 c8             	movslq %eax,%rcx
  800394:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800398:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80039b:	48 63 f0             	movslq %eax,%rsi
  80039e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a5:	48 98                	cltq   
  8003a7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8003ab:	49 89 f9             	mov    %rdi,%r9
  8003ae:	49 89 f0             	mov    %rsi,%r8
  8003b1:	48 89 d1             	mov    %rdx,%rcx
  8003b4:	48 89 c2             	mov    %rax,%rdx
  8003b7:	be 01 00 00 00       	mov    $0x1,%esi
  8003bc:	bf 05 00 00 00       	mov    $0x5,%edi
  8003c1:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  8003c8:	00 00 00 
  8003cb:	ff d0                	callq  *%rax
}
  8003cd:	c9                   	leaveq 
  8003ce:	c3                   	retq   

00000000008003cf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003cf:	55                   	push   %rbp
  8003d0:	48 89 e5             	mov    %rsp,%rbp
  8003d3:	48 83 ec 20          	sub    $0x20,%rsp
  8003d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e5:	48 98                	cltq   
  8003e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003ee:	00 
  8003ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003fb:	48 89 d1             	mov    %rdx,%rcx
  8003fe:	48 89 c2             	mov    %rax,%rdx
  800401:	be 01 00 00 00       	mov    $0x1,%esi
  800406:	bf 06 00 00 00       	mov    $0x6,%edi
  80040b:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  800412:	00 00 00 
  800415:	ff d0                	callq  *%rax
}
  800417:	c9                   	leaveq 
  800418:	c3                   	retq   

0000000000800419 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800419:	55                   	push   %rbp
  80041a:	48 89 e5             	mov    %rsp,%rbp
  80041d:	48 83 ec 20          	sub    $0x20,%rsp
  800421:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800424:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800427:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80042a:	48 63 d0             	movslq %eax,%rdx
  80042d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800430:	48 98                	cltq   
  800432:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800439:	00 
  80043a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800440:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800446:	48 89 d1             	mov    %rdx,%rcx
  800449:	48 89 c2             	mov    %rax,%rdx
  80044c:	be 01 00 00 00       	mov    $0x1,%esi
  800451:	bf 08 00 00 00       	mov    $0x8,%edi
  800456:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  80045d:	00 00 00 
  800460:	ff d0                	callq  *%rax
}
  800462:	c9                   	leaveq 
  800463:	c3                   	retq   

0000000000800464 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800464:	55                   	push   %rbp
  800465:	48 89 e5             	mov    %rsp,%rbp
  800468:	48 83 ec 20          	sub    $0x20,%rsp
  80046c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80046f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800473:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800477:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80047a:	48 98                	cltq   
  80047c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800483:	00 
  800484:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80048a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800490:	48 89 d1             	mov    %rdx,%rcx
  800493:	48 89 c2             	mov    %rax,%rdx
  800496:	be 01 00 00 00       	mov    $0x1,%esi
  80049b:	bf 09 00 00 00       	mov    $0x9,%edi
  8004a0:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  8004a7:	00 00 00 
  8004aa:	ff d0                	callq  *%rax
}
  8004ac:	c9                   	leaveq 
  8004ad:	c3                   	retq   

00000000008004ae <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8004ae:	55                   	push   %rbp
  8004af:	48 89 e5             	mov    %rsp,%rbp
  8004b2:	48 83 ec 20          	sub    $0x20,%rsp
  8004b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004c4:	48 98                	cltq   
  8004c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004cd:	00 
  8004ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004da:	48 89 d1             	mov    %rdx,%rcx
  8004dd:	48 89 c2             	mov    %rax,%rdx
  8004e0:	be 01 00 00 00       	mov    $0x1,%esi
  8004e5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004ea:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  8004f1:	00 00 00 
  8004f4:	ff d0                	callq  *%rax
}
  8004f6:	c9                   	leaveq 
  8004f7:	c3                   	retq   

00000000008004f8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004f8:	55                   	push   %rbp
  8004f9:	48 89 e5             	mov    %rsp,%rbp
  8004fc:	48 83 ec 30          	sub    $0x30,%rsp
  800500:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800503:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800507:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80050b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80050e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800511:	48 63 f0             	movslq %eax,%rsi
  800514:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 98                	cltq   
  80051d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800521:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800528:	00 
  800529:	49 89 f1             	mov    %rsi,%r9
  80052c:	49 89 c8             	mov    %rcx,%r8
  80052f:	48 89 d1             	mov    %rdx,%rcx
  800532:	48 89 c2             	mov    %rax,%rdx
  800535:	be 00 00 00 00       	mov    $0x0,%esi
  80053a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80053f:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  800546:	00 00 00 
  800549:	ff d0                	callq  *%rax
}
  80054b:	c9                   	leaveq 
  80054c:	c3                   	retq   

000000000080054d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80054d:	55                   	push   %rbp
  80054e:	48 89 e5             	mov    %rsp,%rbp
  800551:	48 83 ec 20          	sub    $0x20,%rsp
  800555:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80055d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800564:	00 
  800565:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80056b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800571:	b9 00 00 00 00       	mov    $0x0,%ecx
  800576:	48 89 c2             	mov    %rax,%rdx
  800579:	be 01 00 00 00       	mov    $0x1,%esi
  80057e:	bf 0d 00 00 00       	mov    $0xd,%edi
  800583:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  80058a:	00 00 00 
  80058d:	ff d0                	callq  *%rax
}
  80058f:	c9                   	leaveq 
  800590:	c3                   	retq   

0000000000800591 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800591:	55                   	push   %rbp
  800592:	48 89 e5             	mov    %rsp,%rbp
  800595:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800599:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005a0:	00 
  8005a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	be 00 00 00 00       	mov    $0x0,%esi
  8005bc:	bf 0e 00 00 00       	mov    $0xe,%edi
  8005c1:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  8005c8:	00 00 00 
  8005cb:	ff d0                	callq  *%rax
}
  8005cd:	c9                   	leaveq 
  8005ce:	c3                   	retq   

00000000008005cf <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  8005cf:	55                   	push   %rbp
  8005d0:	48 89 e5             	mov    %rsp,%rbp
  8005d3:	48 83 ec 20          	sub    $0x20,%rsp
  8005d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8005df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005ee:	00 
  8005ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005fb:	48 89 d1             	mov    %rdx,%rcx
  8005fe:	48 89 c2             	mov    %rax,%rdx
  800601:	be 00 00 00 00       	mov    $0x0,%esi
  800606:	bf 0f 00 00 00       	mov    $0xf,%edi
  80060b:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  800612:	00 00 00 
  800615:	ff d0                	callq  *%rax
}
  800617:	c9                   	leaveq 
  800618:	c3                   	retq   

0000000000800619 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  800619:	55                   	push   %rbp
  80061a:	48 89 e5             	mov    %rsp,%rbp
  80061d:	48 83 ec 20          	sub    $0x20,%rsp
  800621:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800625:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  800629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800631:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800638:	00 
  800639:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80063f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800645:	48 89 d1             	mov    %rdx,%rcx
  800648:	48 89 c2             	mov    %rax,%rdx
  80064b:	be 00 00 00 00       	mov    $0x0,%esi
  800650:	bf 10 00 00 00       	mov    $0x10,%edi
  800655:	48 b8 40 01 80 00 00 	movabs $0x800140,%rax
  80065c:	00 00 00 
  80065f:	ff d0                	callq  *%rax
}
  800661:	c9                   	leaveq 
  800662:	c3                   	retq   
	...

0000000000800664 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	48 83 ec 08          	sub    $0x8,%rsp
  80066c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800670:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800674:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80067b:	ff ff ff 
  80067e:	48 01 d0             	add    %rdx,%rax
  800681:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800685:	c9                   	leaveq 
  800686:	c3                   	retq   

0000000000800687 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800687:	55                   	push   %rbp
  800688:	48 89 e5             	mov    %rsp,%rbp
  80068b:	48 83 ec 08          	sub    $0x8,%rsp
  80068f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800693:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800697:	48 89 c7             	mov    %rax,%rdi
  80069a:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  8006a1:	00 00 00 
  8006a4:	ff d0                	callq  *%rax
  8006a6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006ac:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006b0:	c9                   	leaveq 
  8006b1:	c3                   	retq   

00000000008006b2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8006b2:	55                   	push   %rbp
  8006b3:	48 89 e5             	mov    %rsp,%rbp
  8006b6:	48 83 ec 18          	sub    $0x18,%rsp
  8006ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8006c5:	eb 6b                	jmp    800732 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8006c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006ca:	48 98                	cltq   
  8006cc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006d2:	48 c1 e0 0c          	shl    $0xc,%rax
  8006d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006de:	48 89 c2             	mov    %rax,%rdx
  8006e1:	48 c1 ea 15          	shr    $0x15,%rdx
  8006e5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006ec:	01 00 00 
  8006ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006f3:	83 e0 01             	and    $0x1,%eax
  8006f6:	48 85 c0             	test   %rax,%rax
  8006f9:	74 21                	je     80071c <fd_alloc+0x6a>
  8006fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ff:	48 89 c2             	mov    %rax,%rdx
  800702:	48 c1 ea 0c          	shr    $0xc,%rdx
  800706:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80070d:	01 00 00 
  800710:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800714:	83 e0 01             	and    $0x1,%eax
  800717:	48 85 c0             	test   %rax,%rax
  80071a:	75 12                	jne    80072e <fd_alloc+0x7c>
			*fd_store = fd;
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800724:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800727:	b8 00 00 00 00       	mov    $0x0,%eax
  80072c:	eb 1a                	jmp    800748 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80072e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800732:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800736:	7e 8f                	jle    8006c7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800743:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800748:	c9                   	leaveq 
  800749:	c3                   	retq   

000000000080074a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80074a:	55                   	push   %rbp
  80074b:	48 89 e5             	mov    %rsp,%rbp
  80074e:	48 83 ec 20          	sub    $0x20,%rsp
  800752:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800755:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800759:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80075d:	78 06                	js     800765 <fd_lookup+0x1b>
  80075f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800763:	7e 07                	jle    80076c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800765:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80076a:	eb 6c                	jmp    8007d8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80076c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80076f:	48 98                	cltq   
  800771:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800777:	48 c1 e0 0c          	shl    $0xc,%rax
  80077b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80077f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800783:	48 89 c2             	mov    %rax,%rdx
  800786:	48 c1 ea 15          	shr    $0x15,%rdx
  80078a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800791:	01 00 00 
  800794:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800798:	83 e0 01             	and    $0x1,%eax
  80079b:	48 85 c0             	test   %rax,%rax
  80079e:	74 21                	je     8007c1 <fd_lookup+0x77>
  8007a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a4:	48 89 c2             	mov    %rax,%rdx
  8007a7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8007ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007b2:	01 00 00 
  8007b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007b9:	83 e0 01             	and    $0x1,%eax
  8007bc:	48 85 c0             	test   %rax,%rax
  8007bf:	75 07                	jne    8007c8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c6:	eb 10                	jmp    8007d8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8007c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007d0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d8:	c9                   	leaveq 
  8007d9:	c3                   	retq   

00000000008007da <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007da:	55                   	push   %rbp
  8007db:	48 89 e5             	mov    %rsp,%rbp
  8007de:	48 83 ec 30          	sub    $0x30,%rsp
  8007e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007e6:	89 f0                	mov    %esi,%eax
  8007e8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8007eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ef:	48 89 c7             	mov    %rax,%rdi
  8007f2:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  8007f9:	00 00 00 
  8007fc:	ff d0                	callq  *%rax
  8007fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800802:	48 89 d6             	mov    %rdx,%rsi
  800805:	89 c7                	mov    %eax,%edi
  800807:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  80080e:	00 00 00 
  800811:	ff d0                	callq  *%rax
  800813:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800816:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80081a:	78 0a                	js     800826 <fd_close+0x4c>
	    || fd != fd2)
  80081c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800820:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800824:	74 12                	je     800838 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800826:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80082a:	74 05                	je     800831 <fd_close+0x57>
  80082c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80082f:	eb 05                	jmp    800836 <fd_close+0x5c>
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	eb 69                	jmp    8008a1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800838:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80083c:	8b 00                	mov    (%rax),%eax
  80083e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800842:	48 89 d6             	mov    %rdx,%rsi
  800845:	89 c7                	mov    %eax,%edi
  800847:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  80084e:	00 00 00 
  800851:	ff d0                	callq  *%rax
  800853:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800856:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80085a:	78 2a                	js     800886 <fd_close+0xac>
		if (dev->dev_close)
  80085c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800860:	48 8b 40 20          	mov    0x20(%rax),%rax
  800864:	48 85 c0             	test   %rax,%rax
  800867:	74 16                	je     80087f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800875:	48 89 c7             	mov    %rax,%rdi
  800878:	ff d2                	callq  *%rdx
  80087a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80087d:	eb 07                	jmp    800886 <fd_close+0xac>
		else
			r = 0;
  80087f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088a:	48 89 c6             	mov    %rax,%rsi
  80088d:	bf 00 00 00 00       	mov    $0x0,%edi
  800892:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  800899:	00 00 00 
  80089c:	ff d0                	callq  *%rax
	return r;
  80089e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8008a1:	c9                   	leaveq 
  8008a2:	c3                   	retq   

00000000008008a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008a3:	55                   	push   %rbp
  8008a4:	48 89 e5             	mov    %rsp,%rbp
  8008a7:	48 83 ec 20          	sub    $0x20,%rsp
  8008ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8008ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8008b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008b9:	eb 41                	jmp    8008fc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8008bb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008c2:	00 00 00 
  8008c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008c8:	48 63 d2             	movslq %edx,%rdx
  8008cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008cf:	8b 00                	mov    (%rax),%eax
  8008d1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008d4:	75 22                	jne    8008f8 <dev_lookup+0x55>
			*dev = devtab[i];
  8008d6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008dd:	00 00 00 
  8008e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008e3:	48 63 d2             	movslq %edx,%rdx
  8008e6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8008ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008ee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f6:	eb 60                	jmp    800958 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8008f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008fc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800903:	00 00 00 
  800906:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800909:	48 63 d2             	movslq %edx,%rdx
  80090c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800910:	48 85 c0             	test   %rax,%rax
  800913:	75 a6                	jne    8008bb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800915:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80091c:	00 00 00 
  80091f:	48 8b 00             	mov    (%rax),%rax
  800922:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800928:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80092b:	89 c6                	mov    %eax,%esi
  80092d:	48 bf 20 3c 80 00 00 	movabs $0x803c20,%rdi
  800934:	00 00 00 
  800937:	b8 00 00 00 00       	mov    $0x0,%eax
  80093c:	48 b9 2f 26 80 00 00 	movabs $0x80262f,%rcx
  800943:	00 00 00 
  800946:	ff d1                	callq  *%rcx
	*dev = 0;
  800948:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80094c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800953:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800958:	c9                   	leaveq 
  800959:	c3                   	retq   

000000000080095a <close>:

int
close(int fdnum)
{
  80095a:	55                   	push   %rbp
  80095b:	48 89 e5             	mov    %rsp,%rbp
  80095e:	48 83 ec 20          	sub    $0x20,%rsp
  800962:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800965:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800969:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80096c:	48 89 d6             	mov    %rdx,%rsi
  80096f:	89 c7                	mov    %eax,%edi
  800971:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800978:	00 00 00 
  80097b:	ff d0                	callq  *%rax
  80097d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800980:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800984:	79 05                	jns    80098b <close+0x31>
		return r;
  800986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800989:	eb 18                	jmp    8009a3 <close+0x49>
	else
		return fd_close(fd, 1);
  80098b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80098f:	be 01 00 00 00       	mov    $0x1,%esi
  800994:	48 89 c7             	mov    %rax,%rdi
  800997:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  80099e:	00 00 00 
  8009a1:	ff d0                	callq  *%rax
}
  8009a3:	c9                   	leaveq 
  8009a4:	c3                   	retq   

00000000008009a5 <close_all>:

void
close_all(void)
{
  8009a5:	55                   	push   %rbp
  8009a6:	48 89 e5             	mov    %rsp,%rbp
  8009a9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8009ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8009b4:	eb 15                	jmp    8009cb <close_all+0x26>
		close(i);
  8009b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009b9:	89 c7                	mov    %eax,%edi
  8009bb:	48 b8 5a 09 80 00 00 	movabs $0x80095a,%rax
  8009c2:	00 00 00 
  8009c5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8009c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8009cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8009cf:	7e e5                	jle    8009b6 <close_all+0x11>
		close(i);
}
  8009d1:	c9                   	leaveq 
  8009d2:	c3                   	retq   

00000000008009d3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009d3:	55                   	push   %rbp
  8009d4:	48 89 e5             	mov    %rsp,%rbp
  8009d7:	48 83 ec 40          	sub    $0x40,%rsp
  8009db:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009de:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009e1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8009e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8009e8:	48 89 d6             	mov    %rdx,%rsi
  8009eb:	89 c7                	mov    %eax,%edi
  8009ed:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  8009f4:	00 00 00 
  8009f7:	ff d0                	callq  *%rax
  8009f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a00:	79 08                	jns    800a0a <dup+0x37>
		return r;
  800a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a05:	e9 70 01 00 00       	jmpq   800b7a <dup+0x1a7>
	close(newfdnum);
  800a0a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a0d:	89 c7                	mov    %eax,%edi
  800a0f:	48 b8 5a 09 80 00 00 	movabs $0x80095a,%rax
  800a16:	00 00 00 
  800a19:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800a1b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a1e:	48 98                	cltq   
  800a20:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a26:	48 c1 e0 0c          	shl    $0xc,%rax
  800a2a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a32:	48 89 c7             	mov    %rax,%rdi
  800a35:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  800a3c:	00 00 00 
  800a3f:	ff d0                	callq  *%rax
  800a41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a49:	48 89 c7             	mov    %rax,%rdi
  800a4c:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  800a53:	00 00 00 
  800a56:	ff d0                	callq  *%rax
  800a58:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	48 89 c2             	mov    %rax,%rdx
  800a63:	48 c1 ea 15          	shr    $0x15,%rdx
  800a67:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a6e:	01 00 00 
  800a71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a75:	83 e0 01             	and    $0x1,%eax
  800a78:	84 c0                	test   %al,%al
  800a7a:	74 71                	je     800aed <dup+0x11a>
  800a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a80:	48 89 c2             	mov    %rax,%rdx
  800a83:	48 c1 ea 0c          	shr    $0xc,%rdx
  800a87:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a8e:	01 00 00 
  800a91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a95:	83 e0 01             	and    $0x1,%eax
  800a98:	84 c0                	test   %al,%al
  800a9a:	74 51                	je     800aed <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa0:	48 89 c2             	mov    %rax,%rdx
  800aa3:	48 c1 ea 0c          	shr    $0xc,%rdx
  800aa7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800aae:	01 00 00 
  800ab1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ab5:	89 c1                	mov    %eax,%ecx
  800ab7:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800abd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	41 89 c8             	mov    %ecx,%r8d
  800ac8:	48 89 d1             	mov    %rdx,%rcx
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad0:	48 89 c6             	mov    %rax,%rsi
  800ad3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad8:	48 b8 74 03 80 00 00 	movabs $0x800374,%rax
  800adf:	00 00 00 
  800ae2:	ff d0                	callq  *%rax
  800ae4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ae7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aeb:	78 56                	js     800b43 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800aed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800af1:	48 89 c2             	mov    %rax,%rdx
  800af4:	48 c1 ea 0c          	shr    $0xc,%rdx
  800af8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800aff:	01 00 00 
  800b02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b06:	89 c1                	mov    %eax,%ecx
  800b08:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800b0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b16:	41 89 c8             	mov    %ecx,%r8d
  800b19:	48 89 d1             	mov    %rdx,%rcx
  800b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b21:	48 89 c6             	mov    %rax,%rsi
  800b24:	bf 00 00 00 00       	mov    $0x0,%edi
  800b29:	48 b8 74 03 80 00 00 	movabs $0x800374,%rax
  800b30:	00 00 00 
  800b33:	ff d0                	callq  *%rax
  800b35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b3c:	78 08                	js     800b46 <dup+0x173>
		goto err;

	return newfdnum;
  800b3e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b41:	eb 37                	jmp    800b7a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  800b43:	90                   	nop
  800b44:	eb 01                	jmp    800b47 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  800b46:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800b47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b4b:	48 89 c6             	mov    %rax,%rsi
  800b4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b53:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b63:	48 89 c6             	mov    %rax,%rsi
  800b66:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6b:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  800b72:	00 00 00 
  800b75:	ff d0                	callq  *%rax
	return r;
  800b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b7a:	c9                   	leaveq 
  800b7b:	c3                   	retq   

0000000000800b7c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b7c:	55                   	push   %rbp
  800b7d:	48 89 e5             	mov    %rsp,%rbp
  800b80:	48 83 ec 40          	sub    $0x40,%rsp
  800b84:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b87:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b8b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b8f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b93:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b96:	48 89 d6             	mov    %rdx,%rsi
  800b99:	89 c7                	mov    %eax,%edi
  800b9b:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800ba2:	00 00 00 
  800ba5:	ff d0                	callq  *%rax
  800ba7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800baa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bae:	78 24                	js     800bd4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb4:	8b 00                	mov    (%rax),%eax
  800bb6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800bba:	48 89 d6             	mov    %rdx,%rsi
  800bbd:	89 c7                	mov    %eax,%edi
  800bbf:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  800bc6:	00 00 00 
  800bc9:	ff d0                	callq  *%rax
  800bcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bd2:	79 05                	jns    800bd9 <read+0x5d>
		return r;
  800bd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bd7:	eb 7a                	jmp    800c53 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800bd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdd:	8b 40 08             	mov    0x8(%rax),%eax
  800be0:	83 e0 03             	and    $0x3,%eax
  800be3:	83 f8 01             	cmp    $0x1,%eax
  800be6:	75 3a                	jne    800c22 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800be8:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800bef:	00 00 00 
  800bf2:	48 8b 00             	mov    (%rax),%rax
  800bf5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800bfb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800bfe:	89 c6                	mov    %eax,%esi
  800c00:	48 bf 3f 3c 80 00 00 	movabs $0x803c3f,%rdi
  800c07:	00 00 00 
  800c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0f:	48 b9 2f 26 80 00 00 	movabs $0x80262f,%rcx
  800c16:	00 00 00 
  800c19:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c20:	eb 31                	jmp    800c53 <read+0xd7>
	}
	if (!dev->dev_read)
  800c22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c26:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c2a:	48 85 c0             	test   %rax,%rax
  800c2d:	75 07                	jne    800c36 <read+0xba>
		return -E_NOT_SUPP;
  800c2f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c34:	eb 1d                	jmp    800c53 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  800c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  800c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c46:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800c4a:	48 89 ce             	mov    %rcx,%rsi
  800c4d:	48 89 c7             	mov    %rax,%rdi
  800c50:	41 ff d0             	callq  *%r8
}
  800c53:	c9                   	leaveq 
  800c54:	c3                   	retq   

0000000000800c55 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c55:	55                   	push   %rbp
  800c56:	48 89 e5             	mov    %rsp,%rbp
  800c59:	48 83 ec 30          	sub    $0x30,%rsp
  800c5d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c64:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c6f:	eb 46                	jmp    800cb7 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c74:	48 98                	cltq   
  800c76:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c7a:	48 29 c2             	sub    %rax,%rdx
  800c7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c80:	48 98                	cltq   
  800c82:	48 89 c1             	mov    %rax,%rcx
  800c85:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  800c89:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c8c:	48 89 ce             	mov    %rcx,%rsi
  800c8f:	89 c7                	mov    %eax,%edi
  800c91:	48 b8 7c 0b 80 00 00 	movabs $0x800b7c,%rax
  800c98:	00 00 00 
  800c9b:	ff d0                	callq  *%rax
  800c9d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800ca0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ca4:	79 05                	jns    800cab <readn+0x56>
			return m;
  800ca6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ca9:	eb 1d                	jmp    800cc8 <readn+0x73>
		if (m == 0)
  800cab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800caf:	74 13                	je     800cc4 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cb4:	01 45 fc             	add    %eax,-0x4(%rbp)
  800cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cba:	48 98                	cltq   
  800cbc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800cc0:	72 af                	jb     800c71 <readn+0x1c>
  800cc2:	eb 01                	jmp    800cc5 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  800cc4:	90                   	nop
	}
	return tot;
  800cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800cc8:	c9                   	leaveq 
  800cc9:	c3                   	retq   

0000000000800cca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800cca:	55                   	push   %rbp
  800ccb:	48 89 e5             	mov    %rsp,%rbp
  800cce:	48 83 ec 40          	sub    $0x40,%rsp
  800cd2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cd5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800cd9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cdd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ce1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ce4:	48 89 d6             	mov    %rdx,%rsi
  800ce7:	89 c7                	mov    %eax,%edi
  800ce9:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	callq  *%rax
  800cf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cfc:	78 24                	js     800d22 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d02:	8b 00                	mov    (%rax),%eax
  800d04:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d08:	48 89 d6             	mov    %rdx,%rsi
  800d0b:	89 c7                	mov    %eax,%edi
  800d0d:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  800d14:	00 00 00 
  800d17:	ff d0                	callq  *%rax
  800d19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d20:	79 05                	jns    800d27 <write+0x5d>
		return r;
  800d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d25:	eb 79                	jmp    800da0 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2b:	8b 40 08             	mov    0x8(%rax),%eax
  800d2e:	83 e0 03             	and    $0x3,%eax
  800d31:	85 c0                	test   %eax,%eax
  800d33:	75 3a                	jne    800d6f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d35:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800d3c:	00 00 00 
  800d3f:	48 8b 00             	mov    (%rax),%rax
  800d42:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d48:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d4b:	89 c6                	mov    %eax,%esi
  800d4d:	48 bf 5b 3c 80 00 00 	movabs $0x803c5b,%rdi
  800d54:	00 00 00 
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5c:	48 b9 2f 26 80 00 00 	movabs $0x80262f,%rcx
  800d63:	00 00 00 
  800d66:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d6d:	eb 31                	jmp    800da0 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d73:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d77:	48 85 c0             	test   %rax,%rax
  800d7a:	75 07                	jne    800d83 <write+0xb9>
		return -E_NOT_SUPP;
  800d7c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d81:	eb 1d                	jmp    800da0 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  800d83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d87:	4c 8b 40 18          	mov    0x18(%rax),%r8
  800d8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d93:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800d97:	48 89 ce             	mov    %rcx,%rsi
  800d9a:	48 89 c7             	mov    %rax,%rdi
  800d9d:	41 ff d0             	callq  *%r8
}
  800da0:	c9                   	leaveq 
  800da1:	c3                   	retq   

0000000000800da2 <seek>:

int
seek(int fdnum, off_t offset)
{
  800da2:	55                   	push   %rbp
  800da3:	48 89 e5             	mov    %rsp,%rbp
  800da6:	48 83 ec 18          	sub    $0x18,%rsp
  800daa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800dad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800db0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800db4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800db7:	48 89 d6             	mov    %rdx,%rsi
  800dba:	89 c7                	mov    %eax,%edi
  800dbc:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800dc3:	00 00 00 
  800dc6:	ff d0                	callq  *%rax
  800dc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dcf:	79 05                	jns    800dd6 <seek+0x34>
		return r;
  800dd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dd4:	eb 0f                	jmp    800de5 <seek+0x43>
	fd->fd_offset = offset;
  800dd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dda:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800ddd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de5:	c9                   	leaveq 
  800de6:	c3                   	retq   

0000000000800de7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800de7:	55                   	push   %rbp
  800de8:	48 89 e5             	mov    %rsp,%rbp
  800deb:	48 83 ec 30          	sub    $0x30,%rsp
  800def:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800df2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800df5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800df9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dfc:	48 89 d6             	mov    %rdx,%rsi
  800dff:	89 c7                	mov    %eax,%edi
  800e01:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800e08:	00 00 00 
  800e0b:	ff d0                	callq  *%rax
  800e0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e14:	78 24                	js     800e3a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1a:	8b 00                	mov    (%rax),%eax
  800e1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e20:	48 89 d6             	mov    %rdx,%rsi
  800e23:	89 c7                	mov    %eax,%edi
  800e25:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  800e2c:	00 00 00 
  800e2f:	ff d0                	callq  *%rax
  800e31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e38:	79 05                	jns    800e3f <ftruncate+0x58>
		return r;
  800e3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e3d:	eb 72                	jmp    800eb1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e43:	8b 40 08             	mov    0x8(%rax),%eax
  800e46:	83 e0 03             	and    $0x3,%eax
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	75 3a                	jne    800e87 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e4d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800e54:	00 00 00 
  800e57:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e60:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e63:	89 c6                	mov    %eax,%esi
  800e65:	48 bf 78 3c 80 00 00 	movabs $0x803c78,%rdi
  800e6c:	00 00 00 
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e74:	48 b9 2f 26 80 00 00 	movabs $0x80262f,%rcx
  800e7b:	00 00 00 
  800e7e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e85:	eb 2a                	jmp    800eb1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e8f:	48 85 c0             	test   %rax,%rax
  800e92:	75 07                	jne    800e9b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e94:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e99:	eb 16                	jmp    800eb1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800eaa:	89 d6                	mov    %edx,%esi
  800eac:	48 89 c7             	mov    %rax,%rdi
  800eaf:	ff d1                	callq  *%rcx
}
  800eb1:	c9                   	leaveq 
  800eb2:	c3                   	retq   

0000000000800eb3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800eb3:	55                   	push   %rbp
  800eb4:	48 89 e5             	mov    %rsp,%rbp
  800eb7:	48 83 ec 30          	sub    $0x30,%rsp
  800ebb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ebe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ec2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ec6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ec9:	48 89 d6             	mov    %rdx,%rsi
  800ecc:	89 c7                	mov    %eax,%edi
  800ece:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800ed5:	00 00 00 
  800ed8:	ff d0                	callq  *%rax
  800eda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800edd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ee1:	78 24                	js     800f07 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee7:	8b 00                	mov    (%rax),%eax
  800ee9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800eed:	48 89 d6             	mov    %rdx,%rsi
  800ef0:	89 c7                	mov    %eax,%edi
  800ef2:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  800ef9:	00 00 00 
  800efc:	ff d0                	callq  *%rax
  800efe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f05:	79 05                	jns    800f0c <fstat+0x59>
		return r;
  800f07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f0a:	eb 5e                	jmp    800f6a <fstat+0xb7>
	if (!dev->dev_stat)
  800f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f10:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f14:	48 85 c0             	test   %rax,%rax
  800f17:	75 07                	jne    800f20 <fstat+0x6d>
		return -E_NOT_SUPP;
  800f19:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f1e:	eb 4a                	jmp    800f6a <fstat+0xb7>
	stat->st_name[0] = 0;
  800f20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f24:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800f27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800f32:	00 00 00 
	stat->st_isdir = 0;
  800f35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f39:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f40:	00 00 00 
	stat->st_dev = dev;
  800f43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f4b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f56:	48 8b 48 28          	mov    0x28(%rax),%rcx
  800f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800f62:	48 89 d6             	mov    %rdx,%rsi
  800f65:	48 89 c7             	mov    %rax,%rdi
  800f68:	ff d1                	callq  *%rcx
}
  800f6a:	c9                   	leaveq 
  800f6b:	c3                   	retq   

0000000000800f6c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f6c:	55                   	push   %rbp
  800f6d:	48 89 e5             	mov    %rsp,%rbp
  800f70:	48 83 ec 20          	sub    $0x20,%rsp
  800f74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	be 00 00 00 00       	mov    $0x0,%esi
  800f85:	48 89 c7             	mov    %rax,%rdi
  800f88:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  800f8f:	00 00 00 
  800f92:	ff d0                	callq  *%rax
  800f94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f9b:	79 05                	jns    800fa2 <stat+0x36>
		return fd;
  800f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa0:	eb 2f                	jmp    800fd1 <stat+0x65>
	r = fstat(fd, stat);
  800fa2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa9:	48 89 d6             	mov    %rdx,%rsi
  800fac:	89 c7                	mov    %eax,%edi
  800fae:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  800fb5:	00 00 00 
  800fb8:	ff d0                	callq  *%rax
  800fba:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fc0:	89 c7                	mov    %eax,%edi
  800fc2:	48 b8 5a 09 80 00 00 	movabs $0x80095a,%rax
  800fc9:	00 00 00 
  800fcc:	ff d0                	callq  *%rax
	return r;
  800fce:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800fd1:	c9                   	leaveq 
  800fd2:	c3                   	retq   
	...

0000000000800fd4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800fd4:	55                   	push   %rbp
  800fd5:	48 89 e5             	mov    %rsp,%rbp
  800fd8:	48 83 ec 10          	sub    $0x10,%rsp
  800fdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800fe3:	48 b8 18 70 80 00 00 	movabs $0x807018,%rax
  800fea:	00 00 00 
  800fed:	8b 00                	mov    (%rax),%eax
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	75 1d                	jne    801010 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ff3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ff8:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  800fff:	00 00 00 
  801002:	ff d0                	callq  *%rax
  801004:	48 ba 18 70 80 00 00 	movabs $0x807018,%rdx
  80100b:	00 00 00 
  80100e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801010:	48 b8 18 70 80 00 00 	movabs $0x807018,%rax
  801017:	00 00 00 
  80101a:	8b 00                	mov    (%rax),%eax
  80101c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80101f:	b9 07 00 00 00       	mov    $0x7,%ecx
  801024:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80102b:	00 00 00 
  80102e:	89 c7                	mov    %eax,%edi
  801030:	48 b8 00 3a 80 00 00 	movabs $0x803a00,%rax
  801037:	00 00 00 
  80103a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80103c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801040:	ba 00 00 00 00       	mov    $0x0,%edx
  801045:	48 89 c6             	mov    %rax,%rsi
  801048:	bf 00 00 00 00       	mov    $0x0,%edi
  80104d:	48 b8 40 39 80 00 00 	movabs $0x803940,%rax
  801054:	00 00 00 
  801057:	ff d0                	callq  *%rax
}
  801059:	c9                   	leaveq 
  80105a:	c3                   	retq   

000000000080105b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80105b:	55                   	push   %rbp
  80105c:	48 89 e5             	mov    %rsp,%rbp
  80105f:	48 83 ec 20          	sub    $0x20,%rsp
  801063:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801067:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106e:	48 89 c7             	mov    %rax,%rdi
  801071:	48 b8 80 31 80 00 00 	movabs $0x803180,%rax
  801078:	00 00 00 
  80107b:	ff d0                	callq  *%rax
  80107d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801082:	7e 0a                	jle    80108e <open+0x33>
                return -E_BAD_PATH;
  801084:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801089:	e9 a5 00 00 00       	jmpq   801133 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80108e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801092:	48 89 c7             	mov    %rax,%rdi
  801095:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  80109c:	00 00 00 
  80109f:	ff d0                	callq  *%rax
  8010a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010a8:	79 08                	jns    8010b2 <open+0x57>
		return r;
  8010aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ad:	e9 81 00 00 00       	jmpq   801133 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8010b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b6:	48 89 c6             	mov    %rax,%rsi
  8010b9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8010c0:	00 00 00 
  8010c3:	48 b8 ec 31 80 00 00 	movabs $0x8031ec,%rax
  8010ca:	00 00 00 
  8010cd:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8010cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8010d6:	00 00 00 
  8010d9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8010dc:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8010e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e6:	48 89 c6             	mov    %rax,%rsi
  8010e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8010ee:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  8010f5:	00 00 00 
  8010f8:	ff d0                	callq  *%rax
  8010fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801101:	79 1d                	jns    801120 <open+0xc5>
	{
		fd_close(fd,0);
  801103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801107:	be 00 00 00 00       	mov    $0x0,%esi
  80110c:	48 89 c7             	mov    %rax,%rdi
  80110f:	48 b8 da 07 80 00 00 	movabs $0x8007da,%rax
  801116:	00 00 00 
  801119:	ff d0                	callq  *%rax
		return r;
  80111b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111e:	eb 13                	jmp    801133 <open+0xd8>
	}
	return fd2num(fd);
  801120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801124:	48 89 c7             	mov    %rax,%rdi
  801127:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  80112e:	00 00 00 
  801131:	ff d0                	callq  *%rax
	


}
  801133:	c9                   	leaveq 
  801134:	c3                   	retq   

0000000000801135 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801135:	55                   	push   %rbp
  801136:	48 89 e5             	mov    %rsp,%rbp
  801139:	48 83 ec 10          	sub    $0x10,%rsp
  80113d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801145:	8b 50 0c             	mov    0xc(%rax),%edx
  801148:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80114f:	00 00 00 
  801152:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801154:	be 00 00 00 00       	mov    $0x0,%esi
  801159:	bf 06 00 00 00       	mov    $0x6,%edi
  80115e:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  801165:	00 00 00 
  801168:	ff d0                	callq  *%rax
}
  80116a:	c9                   	leaveq 
  80116b:	c3                   	retq   

000000000080116c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80116c:	55                   	push   %rbp
  80116d:	48 89 e5             	mov    %rsp,%rbp
  801170:	48 83 ec 30          	sub    $0x30,%rsp
  801174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801184:	8b 50 0c             	mov    0xc(%rax),%edx
  801187:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80118e:	00 00 00 
  801191:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801193:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80119a:	00 00 00 
  80119d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011a1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8011a5:	be 00 00 00 00       	mov    $0x0,%esi
  8011aa:	bf 03 00 00 00       	mov    $0x3,%edi
  8011af:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  8011b6:	00 00 00 
  8011b9:	ff d0                	callq  *%rax
  8011bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011c2:	79 05                	jns    8011c9 <devfile_read+0x5d>
	{
		return r;
  8011c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011c7:	eb 2c                	jmp    8011f5 <devfile_read+0x89>
	}
	if(r > 0)
  8011c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011cd:	7e 23                	jle    8011f2 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8011cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011d2:	48 63 d0             	movslq %eax,%rdx
  8011d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8011e0:	00 00 00 
  8011e3:	48 89 c7             	mov    %rax,%rdi
  8011e6:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  8011ed:	00 00 00 
  8011f0:	ff d0                	callq  *%rax
	return r;
  8011f2:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8011f5:	c9                   	leaveq 
  8011f6:	c3                   	retq   

00000000008011f7 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8011f7:	55                   	push   %rbp
  8011f8:	48 89 e5             	mov    %rsp,%rbp
  8011fb:	48 83 ec 30          	sub    $0x30,%rsp
  8011ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801203:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801207:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80120b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120f:	8b 50 0c             	mov    0xc(%rax),%edx
  801212:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801219:	00 00 00 
  80121c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80121e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801225:	00 
  801226:	76 08                	jbe    801230 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  801228:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80122f:	00 
	fsipcbuf.write.req_n=n;
  801230:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801237:	00 00 00 
  80123a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80123e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  801242:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801246:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80124a:	48 89 c6             	mov    %rax,%rsi
  80124d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801254:	00 00 00 
  801257:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  801263:	be 00 00 00 00       	mov    $0x0,%esi
  801268:	bf 04 00 00 00       	mov    $0x4,%edi
  80126d:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  801274:	00 00 00 
  801277:	ff d0                	callq  *%rax
  801279:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  80127c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80127f:	c9                   	leaveq 
  801280:	c3                   	retq   

0000000000801281 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  801281:	55                   	push   %rbp
  801282:	48 89 e5             	mov    %rsp,%rbp
  801285:	48 83 ec 10          	sub    $0x10,%rsp
  801289:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	8b 50 0c             	mov    0xc(%rax),%edx
  801297:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80129e:	00 00 00 
  8012a1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8012a3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012aa:	00 00 00 
  8012ad:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8012b0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012b3:	be 00 00 00 00       	mov    $0x0,%esi
  8012b8:	bf 02 00 00 00       	mov    $0x2,%edi
  8012bd:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  8012c4:	00 00 00 
  8012c7:	ff d0                	callq  *%rax
}
  8012c9:	c9                   	leaveq 
  8012ca:	c3                   	retq   

00000000008012cb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012cb:	55                   	push   %rbp
  8012cc:	48 89 e5             	mov    %rsp,%rbp
  8012cf:	48 83 ec 20          	sub    $0x20,%rsp
  8012d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012df:	8b 50 0c             	mov    0xc(%rax),%edx
  8012e2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012e9:	00 00 00 
  8012ec:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012ee:	be 00 00 00 00       	mov    $0x0,%esi
  8012f3:	bf 05 00 00 00       	mov    $0x5,%edi
  8012f8:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  8012ff:	00 00 00 
  801302:	ff d0                	callq  *%rax
  801304:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801307:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80130b:	79 05                	jns    801312 <devfile_stat+0x47>
		return r;
  80130d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801310:	eb 56                	jmp    801368 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801312:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801316:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80131d:	00 00 00 
  801320:	48 89 c7             	mov    %rax,%rdi
  801323:	48 b8 ec 31 80 00 00 	movabs $0x8031ec,%rax
  80132a:	00 00 00 
  80132d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80132f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801336:	00 00 00 
  801339:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80133f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801343:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801349:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801350:	00 00 00 
  801353:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801368:	c9                   	leaveq 
  801369:	c3                   	retq   
	...

000000000080136c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80136c:	55                   	push   %rbp
  80136d:	48 89 e5             	mov    %rsp,%rbp
  801370:	48 83 ec 20          	sub    $0x20,%rsp
  801374:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801377:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80137b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80137e:	48 89 d6             	mov    %rdx,%rsi
  801381:	89 c7                	mov    %eax,%edi
  801383:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  80138a:	00 00 00 
  80138d:	ff d0                	callq  *%rax
  80138f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801392:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801396:	79 05                	jns    80139d <fd2sockid+0x31>
		return r;
  801398:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80139b:	eb 24                	jmp    8013c1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80139d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a1:	8b 10                	mov    (%rax),%edx
  8013a3:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8013aa:	00 00 00 
  8013ad:	8b 00                	mov    (%rax),%eax
  8013af:	39 c2                	cmp    %eax,%edx
  8013b1:	74 07                	je     8013ba <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8013b3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8013b8:	eb 07                	jmp    8013c1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8013ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013be:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8013c1:	c9                   	leaveq 
  8013c2:	c3                   	retq   

00000000008013c3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8013c3:	55                   	push   %rbp
  8013c4:	48 89 e5             	mov    %rsp,%rbp
  8013c7:	48 83 ec 20          	sub    $0x20,%rsp
  8013cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8013ce:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8013d2:	48 89 c7             	mov    %rax,%rdi
  8013d5:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  8013dc:	00 00 00 
  8013df:	ff d0                	callq  *%rax
  8013e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013e8:	78 26                	js     801410 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8013ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ee:	ba 07 04 00 00       	mov    $0x407,%edx
  8013f3:	48 89 c6             	mov    %rax,%rsi
  8013f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8013fb:	48 b8 24 03 80 00 00 	movabs $0x800324,%rax
  801402:	00 00 00 
  801405:	ff d0                	callq  *%rax
  801407:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80140a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80140e:	79 16                	jns    801426 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801410:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801413:	89 c7                	mov    %eax,%edi
  801415:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  80141c:	00 00 00 
  80141f:	ff d0                	callq  *%rax
		return r;
  801421:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801424:	eb 3a                	jmp    801460 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801426:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801431:	00 00 00 
  801434:	8b 12                	mov    (%rdx),%edx
  801436:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801447:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80144a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80144d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801451:	48 89 c7             	mov    %rax,%rdi
  801454:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  80145b:	00 00 00 
  80145e:	ff d0                	callq  *%rax
}
  801460:	c9                   	leaveq 
  801461:	c3                   	retq   

0000000000801462 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801462:	55                   	push   %rbp
  801463:	48 89 e5             	mov    %rsp,%rbp
  801466:	48 83 ec 30          	sub    $0x30,%rsp
  80146a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80146d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801475:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801478:	89 c7                	mov    %eax,%edi
  80147a:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  801481:	00 00 00 
  801484:	ff d0                	callq  *%rax
  801486:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801489:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80148d:	79 05                	jns    801494 <accept+0x32>
		return r;
  80148f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801492:	eb 3b                	jmp    8014cf <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801494:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801498:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80149c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80149f:	48 89 ce             	mov    %rcx,%rsi
  8014a2:	89 c7                	mov    %eax,%edi
  8014a4:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  8014ab:	00 00 00 
  8014ae:	ff d0                	callq  *%rax
  8014b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014b7:	79 05                	jns    8014be <accept+0x5c>
		return r;
  8014b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014bc:	eb 11                	jmp    8014cf <accept+0x6d>
	return alloc_sockfd(r);
  8014be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014c1:	89 c7                	mov    %eax,%edi
  8014c3:	48 b8 c3 13 80 00 00 	movabs $0x8013c3,%rax
  8014ca:	00 00 00 
  8014cd:	ff d0                	callq  *%rax
}
  8014cf:	c9                   	leaveq 
  8014d0:	c3                   	retq   

00000000008014d1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8014d1:	55                   	push   %rbp
  8014d2:	48 89 e5             	mov    %rsp,%rbp
  8014d5:	48 83 ec 20          	sub    $0x20,%rsp
  8014d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8014e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014e6:	89 c7                	mov    %eax,%edi
  8014e8:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  8014ef:	00 00 00 
  8014f2:	ff d0                	callq  *%rax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014fb:	79 05                	jns    801502 <bind+0x31>
		return r;
  8014fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801500:	eb 1b                	jmp    80151d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801502:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801505:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80150c:	48 89 ce             	mov    %rcx,%rsi
  80150f:	89 c7                	mov    %eax,%edi
  801511:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801518:	00 00 00 
  80151b:	ff d0                	callq  *%rax
}
  80151d:	c9                   	leaveq 
  80151e:	c3                   	retq   

000000000080151f <shutdown>:

int
shutdown(int s, int how)
{
  80151f:	55                   	push   %rbp
  801520:	48 89 e5             	mov    %rsp,%rbp
  801523:	48 83 ec 20          	sub    $0x20,%rsp
  801527:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80152a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80152d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801530:	89 c7                	mov    %eax,%edi
  801532:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  801539:	00 00 00 
  80153c:	ff d0                	callq  *%rax
  80153e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801541:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801545:	79 05                	jns    80154c <shutdown+0x2d>
		return r;
  801547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80154a:	eb 16                	jmp    801562 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80154c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80154f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801552:	89 d6                	mov    %edx,%esi
  801554:	89 c7                	mov    %eax,%edi
  801556:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  80155d:	00 00 00 
  801560:	ff d0                	callq  *%rax
}
  801562:	c9                   	leaveq 
  801563:	c3                   	retq   

0000000000801564 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801564:	55                   	push   %rbp
  801565:	48 89 e5             	mov    %rsp,%rbp
  801568:	48 83 ec 10          	sub    $0x10,%rsp
  80156c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801574:	48 89 c7             	mov    %rax,%rdi
  801577:	48 b8 48 3b 80 00 00 	movabs $0x803b48,%rax
  80157e:	00 00 00 
  801581:	ff d0                	callq  *%rax
  801583:	83 f8 01             	cmp    $0x1,%eax
  801586:	75 17                	jne    80159f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158c:	8b 40 0c             	mov    0xc(%rax),%eax
  80158f:	89 c7                	mov    %eax,%edi
  801591:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801598:	00 00 00 
  80159b:	ff d0                	callq  *%rax
  80159d:	eb 05                	jmp    8015a4 <devsock_close+0x40>
	else
		return 0;
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a4:	c9                   	leaveq 
  8015a5:	c3                   	retq   

00000000008015a6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8015a6:	55                   	push   %rbp
  8015a7:	48 89 e5             	mov    %rsp,%rbp
  8015aa:	48 83 ec 20          	sub    $0x20,%rsp
  8015ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8015b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015b5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8015b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015bb:	89 c7                	mov    %eax,%edi
  8015bd:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  8015c4:	00 00 00 
  8015c7:	ff d0                	callq  *%rax
  8015c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015d0:	79 05                	jns    8015d7 <connect+0x31>
		return r;
  8015d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015d5:	eb 1b                	jmp    8015f2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8015d7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8015da:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015e1:	48 89 ce             	mov    %rcx,%rsi
  8015e4:	89 c7                	mov    %eax,%edi
  8015e6:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  8015ed:	00 00 00 
  8015f0:	ff d0                	callq  *%rax
}
  8015f2:	c9                   	leaveq 
  8015f3:	c3                   	retq   

00000000008015f4 <listen>:

int
listen(int s, int backlog)
{
  8015f4:	55                   	push   %rbp
  8015f5:	48 89 e5             	mov    %rsp,%rbp
  8015f8:	48 83 ec 20          	sub    $0x20,%rsp
  8015fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8015ff:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801602:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801605:	89 c7                	mov    %eax,%edi
  801607:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  80160e:	00 00 00 
  801611:	ff d0                	callq  *%rax
  801613:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80161a:	79 05                	jns    801621 <listen+0x2d>
		return r;
  80161c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80161f:	eb 16                	jmp    801637 <listen+0x43>
	return nsipc_listen(r, backlog);
  801621:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801627:	89 d6                	mov    %edx,%esi
  801629:	89 c7                	mov    %eax,%edi
  80162b:	48 b8 61 19 80 00 00 	movabs $0x801961,%rax
  801632:	00 00 00 
  801635:	ff d0                	callq  *%rax
}
  801637:	c9                   	leaveq 
  801638:	c3                   	retq   

0000000000801639 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801639:	55                   	push   %rbp
  80163a:	48 89 e5             	mov    %rsp,%rbp
  80163d:	48 83 ec 20          	sub    $0x20,%rsp
  801641:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801645:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801649:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80164d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801651:	89 c2                	mov    %eax,%edx
  801653:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801657:	8b 40 0c             	mov    0xc(%rax),%eax
  80165a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80165e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801663:	89 c7                	mov    %eax,%edi
  801665:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  80166c:	00 00 00 
  80166f:	ff d0                	callq  *%rax
}
  801671:	c9                   	leaveq 
  801672:	c3                   	retq   

0000000000801673 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801673:	55                   	push   %rbp
  801674:	48 89 e5             	mov    %rsp,%rbp
  801677:	48 83 ec 20          	sub    $0x20,%rsp
  80167b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80167f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801683:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801691:	8b 40 0c             	mov    0xc(%rax),%eax
  801694:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801698:	b9 00 00 00 00       	mov    $0x0,%ecx
  80169d:	89 c7                	mov    %eax,%edi
  80169f:	48 b8 6d 1a 80 00 00 	movabs $0x801a6d,%rax
  8016a6:	00 00 00 
  8016a9:	ff d0                	callq  *%rax
}
  8016ab:	c9                   	leaveq 
  8016ac:	c3                   	retq   

00000000008016ad <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016ad:	55                   	push   %rbp
  8016ae:	48 89 e5             	mov    %rsp,%rbp
  8016b1:	48 83 ec 10          	sub    $0x10,%rsp
  8016b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8016bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c1:	48 be a3 3c 80 00 00 	movabs $0x803ca3,%rsi
  8016c8:	00 00 00 
  8016cb:	48 89 c7             	mov    %rax,%rdi
  8016ce:	48 b8 ec 31 80 00 00 	movabs $0x8031ec,%rax
  8016d5:	00 00 00 
  8016d8:	ff d0                	callq  *%rax
	return 0;
  8016da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016df:	c9                   	leaveq 
  8016e0:	c3                   	retq   

00000000008016e1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8016e1:	55                   	push   %rbp
  8016e2:	48 89 e5             	mov    %rsp,%rbp
  8016e5:	48 83 ec 20          	sub    $0x20,%rsp
  8016e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8016ec:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8016ef:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8016f2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8016f5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8016f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016fb:	89 ce                	mov    %ecx,%esi
  8016fd:	89 c7                	mov    %eax,%edi
  8016ff:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  801706:	00 00 00 
  801709:	ff d0                	callq  *%rax
  80170b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80170e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801712:	79 05                	jns    801719 <socket+0x38>
		return r;
  801714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801717:	eb 11                	jmp    80172a <socket+0x49>
	return alloc_sockfd(r);
  801719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80171c:	89 c7                	mov    %eax,%edi
  80171e:	48 b8 c3 13 80 00 00 	movabs $0x8013c3,%rax
  801725:	00 00 00 
  801728:	ff d0                	callq  *%rax
}
  80172a:	c9                   	leaveq 
  80172b:	c3                   	retq   

000000000080172c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80172c:	55                   	push   %rbp
  80172d:	48 89 e5             	mov    %rsp,%rbp
  801730:	48 83 ec 10          	sub    $0x10,%rsp
  801734:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801737:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  80173e:	00 00 00 
  801741:	8b 00                	mov    (%rax),%eax
  801743:	85 c0                	test   %eax,%eax
  801745:	75 1d                	jne    801764 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801747:	bf 02 00 00 00       	mov    $0x2,%edi
  80174c:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  801753:	00 00 00 
  801756:	ff d0                	callq  *%rax
  801758:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  80175f:	00 00 00 
  801762:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801764:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  80176b:	00 00 00 
  80176e:	8b 00                	mov    (%rax),%eax
  801770:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801773:	b9 07 00 00 00       	mov    $0x7,%ecx
  801778:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80177f:	00 00 00 
  801782:	89 c7                	mov    %eax,%edi
  801784:	48 b8 00 3a 80 00 00 	movabs $0x803a00,%rax
  80178b:	00 00 00 
  80178e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801790:	ba 00 00 00 00       	mov    $0x0,%edx
  801795:	be 00 00 00 00       	mov    $0x0,%esi
  80179a:	bf 00 00 00 00       	mov    $0x0,%edi
  80179f:	48 b8 40 39 80 00 00 	movabs $0x803940,%rax
  8017a6:	00 00 00 
  8017a9:	ff d0                	callq  *%rax
}
  8017ab:	c9                   	leaveq 
  8017ac:	c3                   	retq   

00000000008017ad <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017ad:	55                   	push   %rbp
  8017ae:	48 89 e5             	mov    %rsp,%rbp
  8017b1:	48 83 ec 30          	sub    $0x30,%rsp
  8017b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8017c0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8017c7:	00 00 00 
  8017ca:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8017cd:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8017cf:	bf 01 00 00 00       	mov    $0x1,%edi
  8017d4:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8017db:	00 00 00 
  8017de:	ff d0                	callq  *%rax
  8017e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e7:	78 3e                	js     801827 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8017e9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8017f0:	00 00 00 
  8017f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8017f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017fb:	8b 40 10             	mov    0x10(%rax),%eax
  8017fe:	89 c2                	mov    %eax,%edx
  801800:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801804:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801808:	48 89 ce             	mov    %rcx,%rsi
  80180b:	48 89 c7             	mov    %rax,%rdi
  80180e:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  801815:	00 00 00 
  801818:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80181a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181e:	8b 50 10             	mov    0x10(%rax),%edx
  801821:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801825:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801827:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80182a:	c9                   	leaveq 
  80182b:	c3                   	retq   

000000000080182c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80182c:	55                   	push   %rbp
  80182d:	48 89 e5             	mov    %rsp,%rbp
  801830:	48 83 ec 10          	sub    $0x10,%rsp
  801834:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801837:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80183b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80183e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801845:	00 00 00 
  801848:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80184b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80184d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801850:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801854:	48 89 c6             	mov    %rax,%rsi
  801857:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80185e:	00 00 00 
  801861:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  801868:	00 00 00 
  80186b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80186d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801874:	00 00 00 
  801877:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80187a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80187d:	bf 02 00 00 00       	mov    $0x2,%edi
  801882:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  801889:	00 00 00 
  80188c:	ff d0                	callq  *%rax
}
  80188e:	c9                   	leaveq 
  80188f:	c3                   	retq   

0000000000801890 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	48 83 ec 10          	sub    $0x10,%rsp
  801898:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80189b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80189e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018a5:	00 00 00 
  8018a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018ab:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8018ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018b4:	00 00 00 
  8018b7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8018ba:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8018bd:	bf 03 00 00 00       	mov    $0x3,%edi
  8018c2:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	callq  *%rax
}
  8018ce:	c9                   	leaveq 
  8018cf:	c3                   	retq   

00000000008018d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8018d0:	55                   	push   %rbp
  8018d1:	48 89 e5             	mov    %rsp,%rbp
  8018d4:	48 83 ec 10          	sub    $0x10,%rsp
  8018d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8018db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018e2:	00 00 00 
  8018e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018e8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8018ea:	bf 04 00 00 00       	mov    $0x4,%edi
  8018ef:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	callq  *%rax
}
  8018fb:	c9                   	leaveq 
  8018fc:	c3                   	retq   

00000000008018fd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	48 83 ec 10          	sub    $0x10,%rsp
  801905:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801908:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80190c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80190f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801916:	00 00 00 
  801919:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80191c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80191e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801925:	48 89 c6             	mov    %rax,%rsi
  801928:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80192f:	00 00 00 
  801932:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  801939:	00 00 00 
  80193c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80193e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801945:	00 00 00 
  801948:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80194b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80194e:	bf 05 00 00 00       	mov    $0x5,%edi
  801953:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  80195a:	00 00 00 
  80195d:	ff d0                	callq  *%rax
}
  80195f:	c9                   	leaveq 
  801960:	c3                   	retq   

0000000000801961 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801961:	55                   	push   %rbp
  801962:	48 89 e5             	mov    %rsp,%rbp
  801965:	48 83 ec 10          	sub    $0x10,%rsp
  801969:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80196f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801976:	00 00 00 
  801979:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80197c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80197e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801985:	00 00 00 
  801988:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80198b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80198e:	bf 06 00 00 00       	mov    $0x6,%edi
  801993:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  80199a:	00 00 00 
  80199d:	ff d0                	callq  *%rax
}
  80199f:	c9                   	leaveq 
  8019a0:	c3                   	retq   

00000000008019a1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8019a1:	55                   	push   %rbp
  8019a2:	48 89 e5             	mov    %rsp,%rbp
  8019a5:	48 83 ec 30          	sub    $0x30,%rsp
  8019a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8019ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019b0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8019b3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8019b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019bd:	00 00 00 
  8019c0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8019c3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8019c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019cc:	00 00 00 
  8019cf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8019d2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8019d5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019dc:	00 00 00 
  8019df:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8019e2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8019e5:	bf 07 00 00 00       	mov    $0x7,%edi
  8019ea:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
  8019f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019fd:	78 69                	js     801a68 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8019ff:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801a06:	7f 08                	jg     801a10 <nsipc_recv+0x6f>
  801a08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801a0e:	7e 35                	jle    801a45 <nsipc_recv+0xa4>
  801a10:	48 b9 aa 3c 80 00 00 	movabs $0x803caa,%rcx
  801a17:	00 00 00 
  801a1a:	48 ba bf 3c 80 00 00 	movabs $0x803cbf,%rdx
  801a21:	00 00 00 
  801a24:	be 61 00 00 00       	mov    $0x61,%esi
  801a29:	48 bf d4 3c 80 00 00 	movabs $0x803cd4,%rdi
  801a30:	00 00 00 
  801a33:	b8 00 00 00 00       	mov    $0x0,%eax
  801a38:	49 b8 f4 23 80 00 00 	movabs $0x8023f4,%r8
  801a3f:	00 00 00 
  801a42:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a48:	48 63 d0             	movslq %eax,%rdx
  801a4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a4f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801a56:	00 00 00 
  801a59:	48 89 c7             	mov    %rax,%rdi
  801a5c:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  801a63:	00 00 00 
  801a66:	ff d0                	callq  *%rax
	}

	return r;
  801a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801a6b:	c9                   	leaveq 
  801a6c:	c3                   	retq   

0000000000801a6d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a6d:	55                   	push   %rbp
  801a6e:	48 89 e5             	mov    %rsp,%rbp
  801a71:	48 83 ec 20          	sub    $0x20,%rsp
  801a75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a7c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a7f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801a82:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a89:	00 00 00 
  801a8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801a8f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801a91:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801a98:	7e 35                	jle    801acf <nsipc_send+0x62>
  801a9a:	48 b9 e0 3c 80 00 00 	movabs $0x803ce0,%rcx
  801aa1:	00 00 00 
  801aa4:	48 ba bf 3c 80 00 00 	movabs $0x803cbf,%rdx
  801aab:	00 00 00 
  801aae:	be 6c 00 00 00       	mov    $0x6c,%esi
  801ab3:	48 bf d4 3c 80 00 00 	movabs $0x803cd4,%rdi
  801aba:	00 00 00 
  801abd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac2:	49 b8 f4 23 80 00 00 	movabs $0x8023f4,%r8
  801ac9:	00 00 00 
  801acc:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801acf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad2:	48 63 d0             	movslq %eax,%rdx
  801ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad9:	48 89 c6             	mov    %rax,%rsi
  801adc:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801ae3:	00 00 00 
  801ae6:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  801aed:	00 00 00 
  801af0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801af2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801af9:	00 00 00 
  801afc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801aff:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801b02:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b09:	00 00 00 
  801b0c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801b0f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801b12:	bf 08 00 00 00       	mov    $0x8,%edi
  801b17:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  801b1e:	00 00 00 
  801b21:	ff d0                	callq  *%rax
}
  801b23:	c9                   	leaveq 
  801b24:	c3                   	retq   

0000000000801b25 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b25:	55                   	push   %rbp
  801b26:	48 89 e5             	mov    %rsp,%rbp
  801b29:	48 83 ec 10          	sub    $0x10,%rsp
  801b2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b30:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801b33:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801b36:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b3d:	00 00 00 
  801b40:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b43:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801b45:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b4c:	00 00 00 
  801b4f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b52:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801b55:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b5c:	00 00 00 
  801b5f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801b62:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801b65:	bf 09 00 00 00       	mov    $0x9,%edi
  801b6a:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	53                   	push   %rbx
  801b7d:	48 83 ec 38          	sub    $0x38,%rsp
  801b81:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b85:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801b89:	48 89 c7             	mov    %rax,%rdi
  801b8c:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  801b93:	00 00 00 
  801b96:	ff d0                	callq  *%rax
  801b98:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b9f:	0f 88 bf 01 00 00    	js     801d64 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ba5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba9:	ba 07 04 00 00       	mov    $0x407,%edx
  801bae:	48 89 c6             	mov    %rax,%rsi
  801bb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb6:	48 b8 24 03 80 00 00 	movabs $0x800324,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
  801bc2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801bc9:	0f 88 95 01 00 00    	js     801d64 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801bcf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801bd3:	48 89 c7             	mov    %rax,%rdi
  801bd6:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  801bdd:	00 00 00 
  801be0:	ff d0                	callq  *%rax
  801be2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801be5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801be9:	0f 88 5d 01 00 00    	js     801d4c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf3:	ba 07 04 00 00       	mov    $0x407,%edx
  801bf8:	48 89 c6             	mov    %rax,%rsi
  801bfb:	bf 00 00 00 00       	mov    $0x0,%edi
  801c00:	48 b8 24 03 80 00 00 	movabs $0x800324,%rax
  801c07:	00 00 00 
  801c0a:	ff d0                	callq  *%rax
  801c0c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c13:	0f 88 33 01 00 00    	js     801d4c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801c19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c1d:	48 89 c7             	mov    %rax,%rdi
  801c20:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	callq  *%rax
  801c2c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c34:	ba 07 04 00 00       	mov    $0x407,%edx
  801c39:	48 89 c6             	mov    %rax,%rsi
  801c3c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c41:	48 b8 24 03 80 00 00 	movabs $0x800324,%rax
  801c48:	00 00 00 
  801c4b:	ff d0                	callq  *%rax
  801c4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c50:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c54:	0f 88 d9 00 00 00    	js     801d33 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c5e:	48 89 c7             	mov    %rax,%rdi
  801c61:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  801c68:	00 00 00 
  801c6b:	ff d0                	callq  *%rax
  801c6d:	48 89 c2             	mov    %rax,%rdx
  801c70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c74:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801c7a:	48 89 d1             	mov    %rdx,%rcx
  801c7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c82:	48 89 c6             	mov    %rax,%rsi
  801c85:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8a:	48 b8 74 03 80 00 00 	movabs $0x800374,%rax
  801c91:	00 00 00 
  801c94:	ff d0                	callq  *%rax
  801c96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c9d:	78 79                	js     801d18 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801c9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca3:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801caa:	00 00 00 
  801cad:	8b 12                	mov    (%rdx),%edx
  801caf:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801cb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801cbc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cc0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801cc7:	00 00 00 
  801cca:	8b 12                	mov    (%rdx),%edx
  801ccc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801cce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cd2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801cd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cdd:	48 89 c7             	mov    %rax,%rdi
  801ce0:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  801ce7:	00 00 00 
  801cea:	ff d0                	callq  *%rax
  801cec:	89 c2                	mov    %eax,%edx
  801cee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801cf2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801cf4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801cf8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801cfc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d00:	48 89 c7             	mov    %rax,%rdi
  801d03:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  801d0a:	00 00 00 
  801d0d:	ff d0                	callq  *%rax
  801d0f:	89 03                	mov    %eax,(%rbx)
	return 0;
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
  801d16:	eb 4f                	jmp    801d67 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  801d18:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  801d19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d1d:	48 89 c6             	mov    %rax,%rsi
  801d20:	bf 00 00 00 00       	mov    $0x0,%edi
  801d25:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  801d2c:	00 00 00 
  801d2f:	ff d0                	callq  *%rax
  801d31:	eb 01                	jmp    801d34 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  801d33:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  801d34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d38:	48 89 c6             	mov    %rax,%rsi
  801d3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d40:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  801d4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d50:	48 89 c6             	mov    %rax,%rsi
  801d53:	bf 00 00 00 00       	mov    $0x0,%edi
  801d58:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  801d5f:	00 00 00 
  801d62:	ff d0                	callq  *%rax
    err:
	return r;
  801d64:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801d67:	48 83 c4 38          	add    $0x38,%rsp
  801d6b:	5b                   	pop    %rbx
  801d6c:	5d                   	pop    %rbp
  801d6d:	c3                   	retq   

0000000000801d6e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d6e:	55                   	push   %rbp
  801d6f:	48 89 e5             	mov    %rsp,%rbp
  801d72:	53                   	push   %rbx
  801d73:	48 83 ec 28          	sub    $0x28,%rsp
  801d77:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d7b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801d7f:	eb 01                	jmp    801d82 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  801d81:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d82:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801d89:	00 00 00 
  801d8c:	48 8b 00             	mov    (%rax),%rax
  801d8f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801d95:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801d98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d9c:	48 89 c7             	mov    %rax,%rdi
  801d9f:	48 b8 48 3b 80 00 00 	movabs $0x803b48,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	callq  *%rax
  801dab:	89 c3                	mov    %eax,%ebx
  801dad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801db1:	48 89 c7             	mov    %rax,%rdi
  801db4:	48 b8 48 3b 80 00 00 	movabs $0x803b48,%rax
  801dbb:	00 00 00 
  801dbe:	ff d0                	callq  *%rax
  801dc0:	39 c3                	cmp    %eax,%ebx
  801dc2:	0f 94 c0             	sete   %al
  801dc5:	0f b6 c0             	movzbl %al,%eax
  801dc8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801dcb:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801dd2:	00 00 00 
  801dd5:	48 8b 00             	mov    (%rax),%rax
  801dd8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801dde:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801de1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801de4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801de7:	75 0a                	jne    801df3 <_pipeisclosed+0x85>
			return ret;
  801de9:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801dec:	48 83 c4 28          	add    $0x28,%rsp
  801df0:	5b                   	pop    %rbx
  801df1:	5d                   	pop    %rbp
  801df2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801df3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801df6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801df9:	74 86                	je     801d81 <_pipeisclosed+0x13>
  801dfb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801dff:	75 80                	jne    801d81 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e01:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801e08:	00 00 00 
  801e0b:	48 8b 00             	mov    (%rax),%rax
  801e0e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801e14:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801e17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e1a:	89 c6                	mov    %eax,%esi
  801e1c:	48 bf f1 3c 80 00 00 	movabs $0x803cf1,%rdi
  801e23:	00 00 00 
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2b:	49 b8 2f 26 80 00 00 	movabs $0x80262f,%r8
  801e32:	00 00 00 
  801e35:	41 ff d0             	callq  *%r8
	}
  801e38:	e9 44 ff ff ff       	jmpq   801d81 <_pipeisclosed+0x13>

0000000000801e3d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  801e3d:	55                   	push   %rbp
  801e3e:	48 89 e5             	mov    %rsp,%rbp
  801e41:	48 83 ec 30          	sub    $0x30,%rsp
  801e45:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e48:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e4c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e4f:	48 89 d6             	mov    %rdx,%rsi
  801e52:	89 c7                	mov    %eax,%edi
  801e54:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  801e5b:	00 00 00 
  801e5e:	ff d0                	callq  *%rax
  801e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e67:	79 05                	jns    801e6e <pipeisclosed+0x31>
		return r;
  801e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e6c:	eb 31                	jmp    801e9f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801e6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e72:	48 89 c7             	mov    %rax,%rdi
  801e75:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	callq  *%rax
  801e81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8d:	48 89 d6             	mov    %rdx,%rsi
  801e90:	48 89 c7             	mov    %rax,%rdi
  801e93:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  801e9a:	00 00 00 
  801e9d:	ff d0                	callq  *%rax
}
  801e9f:	c9                   	leaveq 
  801ea0:	c3                   	retq   

0000000000801ea1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ea1:	55                   	push   %rbp
  801ea2:	48 89 e5             	mov    %rsp,%rbp
  801ea5:	48 83 ec 40          	sub    $0x40,%rsp
  801ea9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ead:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801eb1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb9:	48 89 c7             	mov    %rax,%rdi
  801ebc:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
  801ec8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801ecc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ed0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801ed4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801edb:	00 
  801edc:	e9 97 00 00 00       	jmpq   801f78 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ee1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801ee6:	74 09                	je     801ef1 <devpipe_read+0x50>
				return i;
  801ee8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eec:	e9 95 00 00 00       	jmpq   801f86 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ef1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef9:	48 89 d6             	mov    %rdx,%rsi
  801efc:	48 89 c7             	mov    %rax,%rdi
  801eff:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 07                	je     801f16 <devpipe_read+0x75>
				return 0;
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	eb 70                	jmp    801f86 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f16:	48 b8 e6 02 80 00 00 	movabs $0x8002e6,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	callq  *%rax
  801f22:	eb 01                	jmp    801f25 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f24:	90                   	nop
  801f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f29:	8b 10                	mov    (%rax),%edx
  801f2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2f:	8b 40 04             	mov    0x4(%rax),%eax
  801f32:	39 c2                	cmp    %eax,%edx
  801f34:	74 ab                	je     801ee1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f3e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801f42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f46:	8b 00                	mov    (%rax),%eax
  801f48:	89 c2                	mov    %eax,%edx
  801f4a:	c1 fa 1f             	sar    $0x1f,%edx
  801f4d:	c1 ea 1b             	shr    $0x1b,%edx
  801f50:	01 d0                	add    %edx,%eax
  801f52:	83 e0 1f             	and    $0x1f,%eax
  801f55:	29 d0                	sub    %edx,%eax
  801f57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f5b:	48 98                	cltq   
  801f5d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801f62:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f68:	8b 00                	mov    (%rax),%eax
  801f6a:	8d 50 01             	lea    0x1(%rax),%edx
  801f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f71:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f73:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801f80:	72 a2                	jb     801f24 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801f86:	c9                   	leaveq 
  801f87:	c3                   	retq   

0000000000801f88 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f88:	55                   	push   %rbp
  801f89:	48 89 e5             	mov    %rsp,%rbp
  801f8c:	48 83 ec 40          	sub    $0x40,%rsp
  801f90:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f94:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f98:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa0:	48 89 c7             	mov    %rax,%rdi
  801fa3:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  801faa:	00 00 00 
  801fad:	ff d0                	callq  *%rax
  801faf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801fb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fb7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801fbb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801fc2:	00 
  801fc3:	e9 93 00 00 00       	jmpq   80205b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd0:	48 89 d6             	mov    %rdx,%rsi
  801fd3:	48 89 c7             	mov    %rax,%rdi
  801fd6:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  801fdd:	00 00 00 
  801fe0:	ff d0                	callq  *%rax
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	74 07                	je     801fed <devpipe_write+0x65>
				return 0;
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	eb 7c                	jmp    802069 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801fed:	48 b8 e6 02 80 00 00 	movabs $0x8002e6,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	callq  *%rax
  801ff9:	eb 01                	jmp    801ffc <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ffb:	90                   	nop
  801ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802000:	8b 40 04             	mov    0x4(%rax),%eax
  802003:	48 63 d0             	movslq %eax,%rdx
  802006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200a:	8b 00                	mov    (%rax),%eax
  80200c:	48 98                	cltq   
  80200e:	48 83 c0 20          	add    $0x20,%rax
  802012:	48 39 c2             	cmp    %rax,%rdx
  802015:	73 b1                	jae    801fc8 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201b:	8b 40 04             	mov    0x4(%rax),%eax
  80201e:	89 c2                	mov    %eax,%edx
  802020:	c1 fa 1f             	sar    $0x1f,%edx
  802023:	c1 ea 1b             	shr    $0x1b,%edx
  802026:	01 d0                	add    %edx,%eax
  802028:	83 e0 1f             	and    $0x1f,%eax
  80202b:	29 d0                	sub    %edx,%eax
  80202d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802031:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802035:	48 01 ca             	add    %rcx,%rdx
  802038:	0f b6 0a             	movzbl (%rdx),%ecx
  80203b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80203f:	48 98                	cltq   
  802041:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802045:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802049:	8b 40 04             	mov    0x4(%rax),%eax
  80204c:	8d 50 01             	lea    0x1(%rax),%edx
  80204f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802053:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802056:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80205b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80205f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802063:	72 96                	jb     801ffb <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802065:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802069:	c9                   	leaveq 
  80206a:	c3                   	retq   

000000000080206b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80206b:	55                   	push   %rbp
  80206c:	48 89 e5             	mov    %rsp,%rbp
  80206f:	48 83 ec 20          	sub    $0x20,%rsp
  802073:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802077:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80207b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207f:	48 89 c7             	mov    %rax,%rdi
  802082:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
  80208e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802096:	48 be 04 3d 80 00 00 	movabs $0x803d04,%rsi
  80209d:	00 00 00 
  8020a0:	48 89 c7             	mov    %rax,%rdi
  8020a3:	48 b8 ec 31 80 00 00 	movabs $0x8031ec,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8020af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b3:	8b 50 04             	mov    0x4(%rax),%edx
  8020b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ba:	8b 00                	mov    (%rax),%eax
  8020bc:	29 c2                	sub    %eax,%edx
  8020be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020c2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8020c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020cc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8020d3:	00 00 00 
	stat->st_dev = &devpipe;
  8020d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020da:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8020e1:	00 00 00 
  8020e4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f0:	c9                   	leaveq 
  8020f1:	c3                   	retq   

00000000008020f2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020f2:	55                   	push   %rbp
  8020f3:	48 89 e5             	mov    %rsp,%rbp
  8020f6:	48 83 ec 10          	sub    $0x10,%rsp
  8020fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8020fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802102:	48 89 c6             	mov    %rax,%rsi
  802105:	bf 00 00 00 00       	mov    $0x0,%edi
  80210a:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  802111:	00 00 00 
  802114:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211a:	48 89 c7             	mov    %rax,%rdi
  80211d:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
  802129:	48 89 c6             	mov    %rax,%rsi
  80212c:	bf 00 00 00 00       	mov    $0x0,%edi
  802131:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  802138:	00 00 00 
  80213b:	ff d0                	callq  *%rax
}
  80213d:	c9                   	leaveq 
  80213e:	c3                   	retq   
	...

0000000000802140 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802140:	55                   	push   %rbp
  802141:	48 89 e5             	mov    %rsp,%rbp
  802144:	48 83 ec 20          	sub    $0x20,%rsp
  802148:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80214b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80214e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802151:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802155:	be 01 00 00 00       	mov    $0x1,%esi
  80215a:	48 89 c7             	mov    %rax,%rdi
  80215d:	48 b8 dc 01 80 00 00 	movabs $0x8001dc,%rax
  802164:	00 00 00 
  802167:	ff d0                	callq  *%rax
}
  802169:	c9                   	leaveq 
  80216a:	c3                   	retq   

000000000080216b <getchar>:

int
getchar(void)
{
  80216b:	55                   	push   %rbp
  80216c:	48 89 e5             	mov    %rsp,%rbp
  80216f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802173:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802177:	ba 01 00 00 00       	mov    $0x1,%edx
  80217c:	48 89 c6             	mov    %rax,%rsi
  80217f:	bf 00 00 00 00       	mov    $0x0,%edi
  802184:	48 b8 7c 0b 80 00 00 	movabs $0x800b7c,%rax
  80218b:	00 00 00 
  80218e:	ff d0                	callq  *%rax
  802190:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802197:	79 05                	jns    80219e <getchar+0x33>
		return r;
  802199:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219c:	eb 14                	jmp    8021b2 <getchar+0x47>
	if (r < 1)
  80219e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021a2:	7f 07                	jg     8021ab <getchar+0x40>
		return -E_EOF;
  8021a4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8021a9:	eb 07                	jmp    8021b2 <getchar+0x47>
	return c;
  8021ab:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8021af:	0f b6 c0             	movzbl %al,%eax
}
  8021b2:	c9                   	leaveq 
  8021b3:	c3                   	retq   

00000000008021b4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021b4:	55                   	push   %rbp
  8021b5:	48 89 e5             	mov    %rsp,%rbp
  8021b8:	48 83 ec 20          	sub    $0x20,%rsp
  8021bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021c6:	48 89 d6             	mov    %rdx,%rsi
  8021c9:	89 c7                	mov    %eax,%edi
  8021cb:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  8021d2:	00 00 00 
  8021d5:	ff d0                	callq  *%rax
  8021d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021de:	79 05                	jns    8021e5 <iscons+0x31>
		return r;
  8021e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e3:	eb 1a                	jmp    8021ff <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8021e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e9:	8b 10                	mov    (%rax),%edx
  8021eb:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8021f2:	00 00 00 
  8021f5:	8b 00                	mov    (%rax),%eax
  8021f7:	39 c2                	cmp    %eax,%edx
  8021f9:	0f 94 c0             	sete   %al
  8021fc:	0f b6 c0             	movzbl %al,%eax
}
  8021ff:	c9                   	leaveq 
  802200:	c3                   	retq   

0000000000802201 <opencons>:

int
opencons(void)
{
  802201:	55                   	push   %rbp
  802202:	48 89 e5             	mov    %rsp,%rbp
  802205:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802209:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80220d:	48 89 c7             	mov    %rax,%rdi
  802210:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  802217:	00 00 00 
  80221a:	ff d0                	callq  *%rax
  80221c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802223:	79 05                	jns    80222a <opencons+0x29>
		return r;
  802225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802228:	eb 5b                	jmp    802285 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80222a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222e:	ba 07 04 00 00       	mov    $0x407,%edx
  802233:	48 89 c6             	mov    %rax,%rsi
  802236:	bf 00 00 00 00       	mov    $0x0,%edi
  80223b:	48 b8 24 03 80 00 00 	movabs $0x800324,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
  802247:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224e:	79 05                	jns    802255 <opencons+0x54>
		return r;
  802250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802253:	eb 30                	jmp    802285 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802259:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802260:	00 00 00 
  802263:	8b 12                	mov    (%rdx),%edx
  802265:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802276:	48 89 c7             	mov    %rax,%rdi
  802279:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  802280:	00 00 00 
  802283:	ff d0                	callq  *%rax
}
  802285:	c9                   	leaveq 
  802286:	c3                   	retq   

0000000000802287 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802287:	55                   	push   %rbp
  802288:	48 89 e5             	mov    %rsp,%rbp
  80228b:	48 83 ec 30          	sub    $0x30,%rsp
  80228f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802293:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802297:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80229b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022a0:	75 13                	jne    8022b5 <devcons_read+0x2e>
		return 0;
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a7:	eb 49                	jmp    8022f2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8022a9:	48 b8 e6 02 80 00 00 	movabs $0x8002e6,%rax
  8022b0:	00 00 00 
  8022b3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8022b5:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	callq  *%rax
  8022c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c8:	74 df                	je     8022a9 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8022ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ce:	79 05                	jns    8022d5 <devcons_read+0x4e>
		return c;
  8022d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d3:	eb 1d                	jmp    8022f2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8022d5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8022d9:	75 07                	jne    8022e2 <devcons_read+0x5b>
		return 0;
  8022db:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e0:	eb 10                	jmp    8022f2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8022e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e5:	89 c2                	mov    %eax,%edx
  8022e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022eb:	88 10                	mov    %dl,(%rax)
	return 1;
  8022ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022f2:	c9                   	leaveq 
  8022f3:	c3                   	retq   

00000000008022f4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022f4:	55                   	push   %rbp
  8022f5:	48 89 e5             	mov    %rsp,%rbp
  8022f8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8022ff:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802306:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80230d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231b:	eb 77                	jmp    802394 <devcons_write+0xa0>
		m = n - tot;
  80231d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802324:	89 c2                	mov    %eax,%edx
  802326:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802329:	89 d1                	mov    %edx,%ecx
  80232b:	29 c1                	sub    %eax,%ecx
  80232d:	89 c8                	mov    %ecx,%eax
  80232f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802332:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802335:	83 f8 7f             	cmp    $0x7f,%eax
  802338:	76 07                	jbe    802341 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80233a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802341:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802344:	48 63 d0             	movslq %eax,%rdx
  802347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234a:	48 98                	cltq   
  80234c:	48 89 c1             	mov    %rax,%rcx
  80234f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  802356:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80235d:	48 89 ce             	mov    %rcx,%rsi
  802360:	48 89 c7             	mov    %rax,%rdi
  802363:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  80236a:	00 00 00 
  80236d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80236f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802372:	48 63 d0             	movslq %eax,%rdx
  802375:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80237c:	48 89 d6             	mov    %rdx,%rsi
  80237f:	48 89 c7             	mov    %rax,%rdi
  802382:	48 b8 dc 01 80 00 00 	movabs $0x8001dc,%rax
  802389:	00 00 00 
  80238c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80238e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802391:	01 45 fc             	add    %eax,-0x4(%rbp)
  802394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802397:	48 98                	cltq   
  802399:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8023a0:	0f 82 77 ff ff ff    	jb     80231d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8023a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a9:	c9                   	leaveq 
  8023aa:	c3                   	retq   

00000000008023ab <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8023ab:	55                   	push   %rbp
  8023ac:	48 89 e5             	mov    %rsp,%rbp
  8023af:	48 83 ec 08          	sub    $0x8,%rsp
  8023b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023bc:	c9                   	leaveq 
  8023bd:	c3                   	retq   

00000000008023be <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023be:	55                   	push   %rbp
  8023bf:	48 89 e5             	mov    %rsp,%rbp
  8023c2:	48 83 ec 10          	sub    $0x10,%rsp
  8023c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8023ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d2:	48 be 10 3d 80 00 00 	movabs $0x803d10,%rsi
  8023d9:	00 00 00 
  8023dc:	48 89 c7             	mov    %rax,%rdi
  8023df:	48 b8 ec 31 80 00 00 	movabs $0x8031ec,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
	return 0;
  8023eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f0:	c9                   	leaveq 
  8023f1:	c3                   	retq   
	...

00000000008023f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023f4:	55                   	push   %rbp
  8023f5:	48 89 e5             	mov    %rsp,%rbp
  8023f8:	53                   	push   %rbx
  8023f9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802400:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802407:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80240d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802414:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80241b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802422:	84 c0                	test   %al,%al
  802424:	74 23                	je     802449 <_panic+0x55>
  802426:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80242d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802431:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802435:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802439:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80243d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802441:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802445:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802449:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802450:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802457:	00 00 00 
  80245a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802461:	00 00 00 
  802464:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802468:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80246f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802476:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80247d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802484:	00 00 00 
  802487:	48 8b 18             	mov    (%rax),%rbx
  80248a:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  802491:	00 00 00 
  802494:	ff d0                	callq  *%rax
  802496:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80249c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8024a3:	41 89 c8             	mov    %ecx,%r8d
  8024a6:	48 89 d1             	mov    %rdx,%rcx
  8024a9:	48 89 da             	mov    %rbx,%rdx
  8024ac:	89 c6                	mov    %eax,%esi
  8024ae:	48 bf 18 3d 80 00 00 	movabs $0x803d18,%rdi
  8024b5:	00 00 00 
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bd:	49 b9 2f 26 80 00 00 	movabs $0x80262f,%r9
  8024c4:	00 00 00 
  8024c7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024ca:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8024d1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8024d8:	48 89 d6             	mov    %rdx,%rsi
  8024db:	48 89 c7             	mov    %rax,%rdi
  8024de:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  8024e5:	00 00 00 
  8024e8:	ff d0                	callq  *%rax
	cprintf("\n");
  8024ea:	48 bf 3b 3d 80 00 00 	movabs $0x803d3b,%rdi
  8024f1:	00 00 00 
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f9:	48 ba 2f 26 80 00 00 	movabs $0x80262f,%rdx
  802500:	00 00 00 
  802503:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802505:	cc                   	int3   
  802506:	eb fd                	jmp    802505 <_panic+0x111>

0000000000802508 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  802508:	55                   	push   %rbp
  802509:	48 89 e5             	mov    %rsp,%rbp
  80250c:	48 83 ec 10          	sub    $0x10,%rsp
  802510:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802513:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  802517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251b:	8b 00                	mov    (%rax),%eax
  80251d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802520:	89 d6                	mov    %edx,%esi
  802522:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802526:	48 63 d0             	movslq %eax,%rdx
  802529:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80252e:	8d 50 01             	lea    0x1(%rax),%edx
  802531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802535:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  802537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253b:	8b 00                	mov    (%rax),%eax
  80253d:	3d ff 00 00 00       	cmp    $0xff,%eax
  802542:	75 2c                	jne    802570 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  802544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802548:	8b 00                	mov    (%rax),%eax
  80254a:	48 98                	cltq   
  80254c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802550:	48 83 c2 08          	add    $0x8,%rdx
  802554:	48 89 c6             	mov    %rax,%rsi
  802557:	48 89 d7             	mov    %rdx,%rdi
  80255a:	48 b8 dc 01 80 00 00 	movabs $0x8001dc,%rax
  802561:	00 00 00 
  802564:	ff d0                	callq  *%rax
		b->idx = 0;
  802566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  802570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802574:	8b 40 04             	mov    0x4(%rax),%eax
  802577:	8d 50 01             	lea    0x1(%rax),%edx
  80257a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257e:	89 50 04             	mov    %edx,0x4(%rax)
}
  802581:	c9                   	leaveq 
  802582:	c3                   	retq   

0000000000802583 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  802583:	55                   	push   %rbp
  802584:	48 89 e5             	mov    %rsp,%rbp
  802587:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80258e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802595:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80259c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8025a3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8025aa:	48 8b 0a             	mov    (%rdx),%rcx
  8025ad:	48 89 08             	mov    %rcx,(%rax)
  8025b0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8025b4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8025b8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8025bc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8025c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8025c7:	00 00 00 
	b.cnt = 0;
  8025ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8025d1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8025d4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8025db:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8025e2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8025e9:	48 89 c6             	mov    %rax,%rsi
  8025ec:	48 bf 08 25 80 00 00 	movabs $0x802508,%rdi
  8025f3:	00 00 00 
  8025f6:	48 b8 e0 29 80 00 00 	movabs $0x8029e0,%rax
  8025fd:	00 00 00 
  802600:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  802602:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802608:	48 98                	cltq   
  80260a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802611:	48 83 c2 08          	add    $0x8,%rdx
  802615:	48 89 c6             	mov    %rax,%rsi
  802618:	48 89 d7             	mov    %rdx,%rdi
  80261b:	48 b8 dc 01 80 00 00 	movabs $0x8001dc,%rax
  802622:	00 00 00 
  802625:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  802627:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80262d:	c9                   	leaveq 
  80262e:	c3                   	retq   

000000000080262f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80262f:	55                   	push   %rbp
  802630:	48 89 e5             	mov    %rsp,%rbp
  802633:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80263a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802641:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802648:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80264f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802656:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80265d:	84 c0                	test   %al,%al
  80265f:	74 20                	je     802681 <cprintf+0x52>
  802661:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802665:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802669:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80266d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802671:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802675:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802679:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80267d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802681:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  802688:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80268f:	00 00 00 
  802692:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802699:	00 00 00 
  80269c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8026a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8026a7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8026ae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8026b5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8026bc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8026c3:	48 8b 0a             	mov    (%rdx),%rcx
  8026c6:	48 89 08             	mov    %rcx,(%rax)
  8026c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8026cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8026d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8026d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8026d9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8026e0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8026e7:	48 89 d6             	mov    %rdx,%rsi
  8026ea:	48 89 c7             	mov    %rax,%rdi
  8026ed:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	callq  *%rax
  8026f9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8026ff:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802705:	c9                   	leaveq 
  802706:	c3                   	retq   
	...

0000000000802708 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802708:	55                   	push   %rbp
  802709:	48 89 e5             	mov    %rsp,%rbp
  80270c:	48 83 ec 30          	sub    $0x30,%rsp
  802710:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802714:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802718:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80271c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80271f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  802723:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802727:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80272a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80272e:	77 52                	ja     802782 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802730:	8b 45 e0             	mov    -0x20(%rbp),%eax
  802733:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802737:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80273a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80273e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802742:	ba 00 00 00 00       	mov    $0x0,%edx
  802747:	48 f7 75 d0          	divq   -0x30(%rbp)
  80274b:	48 89 c2             	mov    %rax,%rdx
  80274e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802751:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802754:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80275c:	41 89 f9             	mov    %edi,%r9d
  80275f:	48 89 c7             	mov    %rax,%rdi
  802762:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  802769:	00 00 00 
  80276c:	ff d0                	callq  *%rax
  80276e:	eb 1c                	jmp    80278c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802770:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802774:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802777:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80277b:	48 89 d6             	mov    %rdx,%rsi
  80277e:	89 c7                	mov    %eax,%edi
  802780:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802782:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  802786:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80278a:	7f e4                	jg     802770 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80278c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80278f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802793:	ba 00 00 00 00       	mov    $0x0,%edx
  802798:	48 f7 f1             	div    %rcx
  80279b:	48 89 d0             	mov    %rdx,%rax
  80279e:	48 ba 08 3f 80 00 00 	movabs $0x803f08,%rdx
  8027a5:	00 00 00 
  8027a8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8027ac:	0f be c0             	movsbl %al,%eax
  8027af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027b3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8027b7:	48 89 d6             	mov    %rdx,%rsi
  8027ba:	89 c7                	mov    %eax,%edi
  8027bc:	ff d1                	callq  *%rcx
}
  8027be:	c9                   	leaveq 
  8027bf:	c3                   	retq   

00000000008027c0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8027c0:	55                   	push   %rbp
  8027c1:	48 89 e5             	mov    %rsp,%rbp
  8027c4:	48 83 ec 20          	sub    $0x20,%rsp
  8027c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8027cf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8027d3:	7e 52                	jle    802827 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8027d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d9:	8b 00                	mov    (%rax),%eax
  8027db:	83 f8 30             	cmp    $0x30,%eax
  8027de:	73 24                	jae    802804 <getuint+0x44>
  8027e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8027e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ec:	8b 00                	mov    (%rax),%eax
  8027ee:	89 c0                	mov    %eax,%eax
  8027f0:	48 01 d0             	add    %rdx,%rax
  8027f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027f7:	8b 12                	mov    (%rdx),%edx
  8027f9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8027fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802800:	89 0a                	mov    %ecx,(%rdx)
  802802:	eb 17                	jmp    80281b <getuint+0x5b>
  802804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802808:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80280c:	48 89 d0             	mov    %rdx,%rax
  80280f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802813:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802817:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80281b:	48 8b 00             	mov    (%rax),%rax
  80281e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802822:	e9 a3 00 00 00       	jmpq   8028ca <getuint+0x10a>
	else if (lflag)
  802827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80282b:	74 4f                	je     80287c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80282d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802831:	8b 00                	mov    (%rax),%eax
  802833:	83 f8 30             	cmp    $0x30,%eax
  802836:	73 24                	jae    80285c <getuint+0x9c>
  802838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802844:	8b 00                	mov    (%rax),%eax
  802846:	89 c0                	mov    %eax,%eax
  802848:	48 01 d0             	add    %rdx,%rax
  80284b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80284f:	8b 12                	mov    (%rdx),%edx
  802851:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802854:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802858:	89 0a                	mov    %ecx,(%rdx)
  80285a:	eb 17                	jmp    802873 <getuint+0xb3>
  80285c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802860:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802864:	48 89 d0             	mov    %rdx,%rax
  802867:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80286b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80286f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802873:	48 8b 00             	mov    (%rax),%rax
  802876:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80287a:	eb 4e                	jmp    8028ca <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80287c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802880:	8b 00                	mov    (%rax),%eax
  802882:	83 f8 30             	cmp    $0x30,%eax
  802885:	73 24                	jae    8028ab <getuint+0xeb>
  802887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80288f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802893:	8b 00                	mov    (%rax),%eax
  802895:	89 c0                	mov    %eax,%eax
  802897:	48 01 d0             	add    %rdx,%rax
  80289a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80289e:	8b 12                	mov    (%rdx),%edx
  8028a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8028a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028a7:	89 0a                	mov    %ecx,(%rdx)
  8028a9:	eb 17                	jmp    8028c2 <getuint+0x102>
  8028ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8028b3:	48 89 d0             	mov    %rdx,%rax
  8028b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8028ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8028c2:	8b 00                	mov    (%rax),%eax
  8028c4:	89 c0                	mov    %eax,%eax
  8028c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8028ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8028ce:	c9                   	leaveq 
  8028cf:	c3                   	retq   

00000000008028d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8028d0:	55                   	push   %rbp
  8028d1:	48 89 e5             	mov    %rsp,%rbp
  8028d4:	48 83 ec 20          	sub    $0x20,%rsp
  8028d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8028df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8028e3:	7e 52                	jle    802937 <getint+0x67>
		x=va_arg(*ap, long long);
  8028e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e9:	8b 00                	mov    (%rax),%eax
  8028eb:	83 f8 30             	cmp    $0x30,%eax
  8028ee:	73 24                	jae    802914 <getint+0x44>
  8028f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8028f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fc:	8b 00                	mov    (%rax),%eax
  8028fe:	89 c0                	mov    %eax,%eax
  802900:	48 01 d0             	add    %rdx,%rax
  802903:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802907:	8b 12                	mov    (%rdx),%edx
  802909:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80290c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802910:	89 0a                	mov    %ecx,(%rdx)
  802912:	eb 17                	jmp    80292b <getint+0x5b>
  802914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802918:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80291c:	48 89 d0             	mov    %rdx,%rax
  80291f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802923:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802927:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80292b:	48 8b 00             	mov    (%rax),%rax
  80292e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802932:	e9 a3 00 00 00       	jmpq   8029da <getint+0x10a>
	else if (lflag)
  802937:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80293b:	74 4f                	je     80298c <getint+0xbc>
		x=va_arg(*ap, long);
  80293d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802941:	8b 00                	mov    (%rax),%eax
  802943:	83 f8 30             	cmp    $0x30,%eax
  802946:	73 24                	jae    80296c <getint+0x9c>
  802948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802954:	8b 00                	mov    (%rax),%eax
  802956:	89 c0                	mov    %eax,%eax
  802958:	48 01 d0             	add    %rdx,%rax
  80295b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80295f:	8b 12                	mov    (%rdx),%edx
  802961:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802964:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802968:	89 0a                	mov    %ecx,(%rdx)
  80296a:	eb 17                	jmp    802983 <getint+0xb3>
  80296c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802970:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802974:	48 89 d0             	mov    %rdx,%rax
  802977:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80297b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80297f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802983:	48 8b 00             	mov    (%rax),%rax
  802986:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80298a:	eb 4e                	jmp    8029da <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80298c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802990:	8b 00                	mov    (%rax),%eax
  802992:	83 f8 30             	cmp    $0x30,%eax
  802995:	73 24                	jae    8029bb <getint+0xeb>
  802997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80299f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a3:	8b 00                	mov    (%rax),%eax
  8029a5:	89 c0                	mov    %eax,%eax
  8029a7:	48 01 d0             	add    %rdx,%rax
  8029aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ae:	8b 12                	mov    (%rdx),%edx
  8029b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8029b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029b7:	89 0a                	mov    %ecx,(%rdx)
  8029b9:	eb 17                	jmp    8029d2 <getint+0x102>
  8029bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8029c3:	48 89 d0             	mov    %rdx,%rax
  8029c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8029ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8029d2:	8b 00                	mov    (%rax),%eax
  8029d4:	48 98                	cltq   
  8029d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8029da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8029de:	c9                   	leaveq 
  8029df:	c3                   	retq   

00000000008029e0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8029e0:	55                   	push   %rbp
  8029e1:	48 89 e5             	mov    %rsp,%rbp
  8029e4:	41 54                	push   %r12
  8029e6:	53                   	push   %rbx
  8029e7:	48 83 ec 60          	sub    $0x60,%rsp
  8029eb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8029ef:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8029f3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8029f7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8029fb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8029ff:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802a03:	48 8b 0a             	mov    (%rdx),%rcx
  802a06:	48 89 08             	mov    %rcx,(%rax)
  802a09:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a0d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a11:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a15:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802a19:	eb 17                	jmp    802a32 <vprintfmt+0x52>
			if (ch == '\0')
  802a1b:	85 db                	test   %ebx,%ebx
  802a1d:	0f 84 d7 04 00 00    	je     802efa <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  802a23:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802a27:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802a2b:	48 89 c6             	mov    %rax,%rsi
  802a2e:	89 df                	mov    %ebx,%edi
  802a30:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802a32:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802a36:	0f b6 00             	movzbl (%rax),%eax
  802a39:	0f b6 d8             	movzbl %al,%ebx
  802a3c:	83 fb 25             	cmp    $0x25,%ebx
  802a3f:	0f 95 c0             	setne  %al
  802a42:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802a47:	84 c0                	test   %al,%al
  802a49:	75 d0                	jne    802a1b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802a4b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802a4f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802a56:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802a5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802a64:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  802a6b:	eb 04                	jmp    802a71 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  802a6d:	90                   	nop
  802a6e:	eb 01                	jmp    802a71 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  802a70:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802a71:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802a75:	0f b6 00             	movzbl (%rax),%eax
  802a78:	0f b6 d8             	movzbl %al,%ebx
  802a7b:	89 d8                	mov    %ebx,%eax
  802a7d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802a82:	83 e8 23             	sub    $0x23,%eax
  802a85:	83 f8 55             	cmp    $0x55,%eax
  802a88:	0f 87 38 04 00 00    	ja     802ec6 <vprintfmt+0x4e6>
  802a8e:	89 c0                	mov    %eax,%eax
  802a90:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802a97:	00 
  802a98:	48 b8 30 3f 80 00 00 	movabs $0x803f30,%rax
  802a9f:	00 00 00 
  802aa2:	48 01 d0             	add    %rdx,%rax
  802aa5:	48 8b 00             	mov    (%rax),%rax
  802aa8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  802aaa:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802aae:	eb c1                	jmp    802a71 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802ab0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802ab4:	eb bb                	jmp    802a71 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802ab6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802abd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802ac0:	89 d0                	mov    %edx,%eax
  802ac2:	c1 e0 02             	shl    $0x2,%eax
  802ac5:	01 d0                	add    %edx,%eax
  802ac7:	01 c0                	add    %eax,%eax
  802ac9:	01 d8                	add    %ebx,%eax
  802acb:	83 e8 30             	sub    $0x30,%eax
  802ace:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802ad1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802ad5:	0f b6 00             	movzbl (%rax),%eax
  802ad8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802adb:	83 fb 2f             	cmp    $0x2f,%ebx
  802ade:	7e 63                	jle    802b43 <vprintfmt+0x163>
  802ae0:	83 fb 39             	cmp    $0x39,%ebx
  802ae3:	7f 5e                	jg     802b43 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802ae5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802aea:	eb d1                	jmp    802abd <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  802aec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802aef:	83 f8 30             	cmp    $0x30,%eax
  802af2:	73 17                	jae    802b0b <vprintfmt+0x12b>
  802af4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802af8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802afb:	89 c0                	mov    %eax,%eax
  802afd:	48 01 d0             	add    %rdx,%rax
  802b00:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802b03:	83 c2 08             	add    $0x8,%edx
  802b06:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802b09:	eb 0f                	jmp    802b1a <vprintfmt+0x13a>
  802b0b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b0f:	48 89 d0             	mov    %rdx,%rax
  802b12:	48 83 c2 08          	add    $0x8,%rdx
  802b16:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802b1a:	8b 00                	mov    (%rax),%eax
  802b1c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802b1f:	eb 23                	jmp    802b44 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  802b21:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802b25:	0f 89 42 ff ff ff    	jns    802a6d <vprintfmt+0x8d>
				width = 0;
  802b2b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802b32:	e9 36 ff ff ff       	jmpq   802a6d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  802b37:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802b3e:	e9 2e ff ff ff       	jmpq   802a71 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  802b43:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  802b44:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802b48:	0f 89 22 ff ff ff    	jns    802a70 <vprintfmt+0x90>
				width = precision, precision = -1;
  802b4e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802b51:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802b54:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802b5b:	e9 10 ff ff ff       	jmpq   802a70 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802b60:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802b64:	e9 08 ff ff ff       	jmpq   802a71 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802b69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b6c:	83 f8 30             	cmp    $0x30,%eax
  802b6f:	73 17                	jae    802b88 <vprintfmt+0x1a8>
  802b71:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b78:	89 c0                	mov    %eax,%eax
  802b7a:	48 01 d0             	add    %rdx,%rax
  802b7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802b80:	83 c2 08             	add    $0x8,%edx
  802b83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802b86:	eb 0f                	jmp    802b97 <vprintfmt+0x1b7>
  802b88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b8c:	48 89 d0             	mov    %rdx,%rax
  802b8f:	48 83 c2 08          	add    $0x8,%rdx
  802b93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802b97:	8b 00                	mov    (%rax),%eax
  802b99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802b9d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  802ba1:	48 89 d6             	mov    %rdx,%rsi
  802ba4:	89 c7                	mov    %eax,%edi
  802ba6:	ff d1                	callq  *%rcx
			break;
  802ba8:	e9 47 03 00 00       	jmpq   802ef4 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  802bad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802bb0:	83 f8 30             	cmp    $0x30,%eax
  802bb3:	73 17                	jae    802bcc <vprintfmt+0x1ec>
  802bb5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802bbc:	89 c0                	mov    %eax,%eax
  802bbe:	48 01 d0             	add    %rdx,%rax
  802bc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802bc4:	83 c2 08             	add    $0x8,%edx
  802bc7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802bca:	eb 0f                	jmp    802bdb <vprintfmt+0x1fb>
  802bcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802bd0:	48 89 d0             	mov    %rdx,%rax
  802bd3:	48 83 c2 08          	add    $0x8,%rdx
  802bd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802bdb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802bdd:	85 db                	test   %ebx,%ebx
  802bdf:	79 02                	jns    802be3 <vprintfmt+0x203>
				err = -err;
  802be1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802be3:	83 fb 10             	cmp    $0x10,%ebx
  802be6:	7f 16                	jg     802bfe <vprintfmt+0x21e>
  802be8:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  802bef:	00 00 00 
  802bf2:	48 63 d3             	movslq %ebx,%rdx
  802bf5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802bf9:	4d 85 e4             	test   %r12,%r12
  802bfc:	75 2e                	jne    802c2c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  802bfe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802c02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c06:	89 d9                	mov    %ebx,%ecx
  802c08:	48 ba 19 3f 80 00 00 	movabs $0x803f19,%rdx
  802c0f:	00 00 00 
  802c12:	48 89 c7             	mov    %rax,%rdi
  802c15:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1a:	49 b8 04 2f 80 00 00 	movabs $0x802f04,%r8
  802c21:	00 00 00 
  802c24:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802c27:	e9 c8 02 00 00       	jmpq   802ef4 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802c2c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802c30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c34:	4c 89 e1             	mov    %r12,%rcx
  802c37:	48 ba 22 3f 80 00 00 	movabs $0x803f22,%rdx
  802c3e:	00 00 00 
  802c41:	48 89 c7             	mov    %rax,%rdi
  802c44:	b8 00 00 00 00       	mov    $0x0,%eax
  802c49:	49 b8 04 2f 80 00 00 	movabs $0x802f04,%r8
  802c50:	00 00 00 
  802c53:	41 ff d0             	callq  *%r8
			break;
  802c56:	e9 99 02 00 00       	jmpq   802ef4 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802c5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c5e:	83 f8 30             	cmp    $0x30,%eax
  802c61:	73 17                	jae    802c7a <vprintfmt+0x29a>
  802c63:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c6a:	89 c0                	mov    %eax,%eax
  802c6c:	48 01 d0             	add    %rdx,%rax
  802c6f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c72:	83 c2 08             	add    $0x8,%edx
  802c75:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c78:	eb 0f                	jmp    802c89 <vprintfmt+0x2a9>
  802c7a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c7e:	48 89 d0             	mov    %rdx,%rax
  802c81:	48 83 c2 08          	add    $0x8,%rdx
  802c85:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c89:	4c 8b 20             	mov    (%rax),%r12
  802c8c:	4d 85 e4             	test   %r12,%r12
  802c8f:	75 0a                	jne    802c9b <vprintfmt+0x2bb>
				p = "(null)";
  802c91:	49 bc 25 3f 80 00 00 	movabs $0x803f25,%r12
  802c98:	00 00 00 
			if (width > 0 && padc != '-')
  802c9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802c9f:	7e 7a                	jle    802d1b <vprintfmt+0x33b>
  802ca1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802ca5:	74 74                	je     802d1b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  802ca7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802caa:	48 98                	cltq   
  802cac:	48 89 c6             	mov    %rax,%rsi
  802caf:	4c 89 e7             	mov    %r12,%rdi
  802cb2:	48 b8 ae 31 80 00 00 	movabs $0x8031ae,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
  802cbe:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802cc1:	eb 17                	jmp    802cda <vprintfmt+0x2fa>
					putch(padc, putdat);
  802cc3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  802cc7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ccb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  802ccf:	48 89 d6             	mov    %rdx,%rsi
  802cd2:	89 c7                	mov    %eax,%edi
  802cd4:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802cd6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802cda:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802cde:	7f e3                	jg     802cc3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802ce0:	eb 39                	jmp    802d1b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  802ce2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802ce6:	74 1e                	je     802d06 <vprintfmt+0x326>
  802ce8:	83 fb 1f             	cmp    $0x1f,%ebx
  802ceb:	7e 05                	jle    802cf2 <vprintfmt+0x312>
  802ced:	83 fb 7e             	cmp    $0x7e,%ebx
  802cf0:	7e 14                	jle    802d06 <vprintfmt+0x326>
					putch('?', putdat);
  802cf2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802cf6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802cfa:	48 89 c6             	mov    %rax,%rsi
  802cfd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802d02:	ff d2                	callq  *%rdx
  802d04:	eb 0f                	jmp    802d15 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  802d06:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d0a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d0e:	48 89 c6             	mov    %rax,%rsi
  802d11:	89 df                	mov    %ebx,%edi
  802d13:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802d15:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802d19:	eb 01                	jmp    802d1c <vprintfmt+0x33c>
  802d1b:	90                   	nop
  802d1c:	41 0f b6 04 24       	movzbl (%r12),%eax
  802d21:	0f be d8             	movsbl %al,%ebx
  802d24:	85 db                	test   %ebx,%ebx
  802d26:	0f 95 c0             	setne  %al
  802d29:	49 83 c4 01          	add    $0x1,%r12
  802d2d:	84 c0                	test   %al,%al
  802d2f:	74 28                	je     802d59 <vprintfmt+0x379>
  802d31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802d35:	78 ab                	js     802ce2 <vprintfmt+0x302>
  802d37:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802d3b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802d3f:	79 a1                	jns    802ce2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802d41:	eb 16                	jmp    802d59 <vprintfmt+0x379>
				putch(' ', putdat);
  802d43:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d47:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d4b:	48 89 c6             	mov    %rax,%rsi
  802d4e:	bf 20 00 00 00       	mov    $0x20,%edi
  802d53:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802d55:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802d59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d5d:	7f e4                	jg     802d43 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  802d5f:	e9 90 01 00 00       	jmpq   802ef4 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802d64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802d68:	be 03 00 00 00       	mov    $0x3,%esi
  802d6d:	48 89 c7             	mov    %rax,%rdi
  802d70:	48 b8 d0 28 80 00 00 	movabs $0x8028d0,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
  802d7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802d80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d84:	48 85 c0             	test   %rax,%rax
  802d87:	79 1d                	jns    802da6 <vprintfmt+0x3c6>
				putch('-', putdat);
  802d89:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d8d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d91:	48 89 c6             	mov    %rax,%rsi
  802d94:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802d99:	ff d2                	callq  *%rdx
				num = -(long long) num;
  802d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9f:	48 f7 d8             	neg    %rax
  802da2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802da6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802dad:	e9 d5 00 00 00       	jmpq   802e87 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802db2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802db6:	be 03 00 00 00       	mov    $0x3,%esi
  802dbb:	48 89 c7             	mov    %rax,%rdi
  802dbe:	48 b8 c0 27 80 00 00 	movabs $0x8027c0,%rax
  802dc5:	00 00 00 
  802dc8:	ff d0                	callq  *%rax
  802dca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802dce:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802dd5:	e9 ad 00 00 00       	jmpq   802e87 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  802dda:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802dde:	be 03 00 00 00       	mov    $0x3,%esi
  802de3:	48 89 c7             	mov    %rax,%rdi
  802de6:	48 b8 c0 27 80 00 00 	movabs $0x8027c0,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
  802df2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  802df6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  802dfd:	e9 85 00 00 00       	jmpq   802e87 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  802e02:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802e06:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802e0a:	48 89 c6             	mov    %rax,%rsi
  802e0d:	bf 30 00 00 00       	mov    $0x30,%edi
  802e12:	ff d2                	callq  *%rdx
			putch('x', putdat);
  802e14:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802e18:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802e1c:	48 89 c6             	mov    %rax,%rsi
  802e1f:	bf 78 00 00 00       	mov    $0x78,%edi
  802e24:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802e26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e29:	83 f8 30             	cmp    $0x30,%eax
  802e2c:	73 17                	jae    802e45 <vprintfmt+0x465>
  802e2e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e35:	89 c0                	mov    %eax,%eax
  802e37:	48 01 d0             	add    %rdx,%rax
  802e3a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e3d:	83 c2 08             	add    $0x8,%edx
  802e40:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802e43:	eb 0f                	jmp    802e54 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  802e45:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e49:	48 89 d0             	mov    %rdx,%rax
  802e4c:	48 83 c2 08          	add    $0x8,%rdx
  802e50:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e54:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802e57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802e5b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802e62:	eb 23                	jmp    802e87 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802e64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e68:	be 03 00 00 00       	mov    $0x3,%esi
  802e6d:	48 89 c7             	mov    %rax,%rdi
  802e70:	48 b8 c0 27 80 00 00 	movabs $0x8027c0,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
  802e7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802e80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802e87:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802e8c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802e8f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802e92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e96:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802e9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e9e:	45 89 c1             	mov    %r8d,%r9d
  802ea1:	41 89 f8             	mov    %edi,%r8d
  802ea4:	48 89 c7             	mov    %rax,%rdi
  802ea7:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
			break;
  802eb3:	eb 3f                	jmp    802ef4 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802eb5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802eb9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802ebd:	48 89 c6             	mov    %rax,%rsi
  802ec0:	89 df                	mov    %ebx,%edi
  802ec2:	ff d2                	callq  *%rdx
			break;
  802ec4:	eb 2e                	jmp    802ef4 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802ec6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802eca:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802ece:	48 89 c6             	mov    %rax,%rsi
  802ed1:	bf 25 00 00 00       	mov    $0x25,%edi
  802ed6:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  802ed8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802edd:	eb 05                	jmp    802ee4 <vprintfmt+0x504>
  802edf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802ee4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802ee8:	48 83 e8 01          	sub    $0x1,%rax
  802eec:	0f b6 00             	movzbl (%rax),%eax
  802eef:	3c 25                	cmp    $0x25,%al
  802ef1:	75 ec                	jne    802edf <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  802ef3:	90                   	nop
		}
	}
  802ef4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802ef5:	e9 38 fb ff ff       	jmpq   802a32 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  802efa:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  802efb:	48 83 c4 60          	add    $0x60,%rsp
  802eff:	5b                   	pop    %rbx
  802f00:	41 5c                	pop    %r12
  802f02:	5d                   	pop    %rbp
  802f03:	c3                   	retq   

0000000000802f04 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802f04:	55                   	push   %rbp
  802f05:	48 89 e5             	mov    %rsp,%rbp
  802f08:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802f0f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802f16:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802f1d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f24:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f2b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f32:	84 c0                	test   %al,%al
  802f34:	74 20                	je     802f56 <printfmt+0x52>
  802f36:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f3a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f3e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f42:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f46:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f4a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f4e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f52:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f56:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802f5d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802f64:	00 00 00 
  802f67:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802f6e:	00 00 00 
  802f71:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f75:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802f7c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f83:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802f8a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802f91:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802f98:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802f9f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802fa6:	48 89 c7             	mov    %rax,%rdi
  802fa9:	48 b8 e0 29 80 00 00 	movabs $0x8029e0,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
	va_end(ap);
}
  802fb5:	c9                   	leaveq 
  802fb6:	c3                   	retq   

0000000000802fb7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802fb7:	55                   	push   %rbp
  802fb8:	48 89 e5             	mov    %rsp,%rbp
  802fbb:	48 83 ec 10          	sub    $0x10,%rsp
  802fbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fca:	8b 40 10             	mov    0x10(%rax),%eax
  802fcd:	8d 50 01             	lea    0x1(%rax),%edx
  802fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802fd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdb:	48 8b 10             	mov    (%rax),%rdx
  802fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe2:	48 8b 40 08          	mov    0x8(%rax),%rax
  802fe6:	48 39 c2             	cmp    %rax,%rdx
  802fe9:	73 17                	jae    803002 <sprintputch+0x4b>
		*b->buf++ = ch;
  802feb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fef:	48 8b 00             	mov    (%rax),%rax
  802ff2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ff5:	88 10                	mov    %dl,(%rax)
  802ff7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fff:	48 89 10             	mov    %rdx,(%rax)
}
  803002:	c9                   	leaveq 
  803003:	c3                   	retq   

0000000000803004 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803004:	55                   	push   %rbp
  803005:	48 89 e5             	mov    %rsp,%rbp
  803008:	48 83 ec 50          	sub    $0x50,%rsp
  80300c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803010:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803013:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803017:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80301b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80301f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803023:	48 8b 0a             	mov    (%rdx),%rcx
  803026:	48 89 08             	mov    %rcx,(%rax)
  803029:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80302d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803031:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803035:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803039:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80303d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803041:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803044:	48 98                	cltq   
  803046:	48 83 e8 01          	sub    $0x1,%rax
  80304a:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80304e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803052:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803059:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80305e:	74 06                	je     803066 <vsnprintf+0x62>
  803060:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803064:	7f 07                	jg     80306d <vsnprintf+0x69>
		return -E_INVAL;
  803066:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80306b:	eb 2f                	jmp    80309c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80306d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803071:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803075:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803079:	48 89 c6             	mov    %rax,%rsi
  80307c:	48 bf b7 2f 80 00 00 	movabs $0x802fb7,%rdi
  803083:	00 00 00 
  803086:	48 b8 e0 29 80 00 00 	movabs $0x8029e0,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803092:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803096:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803099:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80309c:	c9                   	leaveq 
  80309d:	c3                   	retq   

000000000080309e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80309e:	55                   	push   %rbp
  80309f:	48 89 e5             	mov    %rsp,%rbp
  8030a2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8030a9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8030b0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8030b6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8030bd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8030c4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8030cb:	84 c0                	test   %al,%al
  8030cd:	74 20                	je     8030ef <snprintf+0x51>
  8030cf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030d3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030d7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030db:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030df:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030e3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030e7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030eb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030ef:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8030f6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8030fd:	00 00 00 
  803100:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803107:	00 00 00 
  80310a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80310e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803115:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80311c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803123:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80312a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803131:	48 8b 0a             	mov    (%rdx),%rcx
  803134:	48 89 08             	mov    %rcx,(%rax)
  803137:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80313b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80313f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803143:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803147:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80314e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803155:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80315b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803162:	48 89 c7             	mov    %rax,%rdi
  803165:	48 b8 04 30 80 00 00 	movabs $0x803004,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
  803171:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803177:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80317d:	c9                   	leaveq 
  80317e:	c3                   	retq   
	...

0000000000803180 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803180:	55                   	push   %rbp
  803181:	48 89 e5             	mov    %rsp,%rbp
  803184:	48 83 ec 18          	sub    $0x18,%rsp
  803188:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80318c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803193:	eb 09                	jmp    80319e <strlen+0x1e>
		n++;
  803195:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803199:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80319e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a2:	0f b6 00             	movzbl (%rax),%eax
  8031a5:	84 c0                	test   %al,%al
  8031a7:	75 ec                	jne    803195 <strlen+0x15>
		n++;
	return n;
  8031a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031ac:	c9                   	leaveq 
  8031ad:	c3                   	retq   

00000000008031ae <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8031ae:	55                   	push   %rbp
  8031af:	48 89 e5             	mov    %rsp,%rbp
  8031b2:	48 83 ec 20          	sub    $0x20,%rsp
  8031b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8031be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031c5:	eb 0e                	jmp    8031d5 <strnlen+0x27>
		n++;
  8031c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8031cb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8031d0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8031d5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031da:	74 0b                	je     8031e7 <strnlen+0x39>
  8031dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e0:	0f b6 00             	movzbl (%rax),%eax
  8031e3:	84 c0                	test   %al,%al
  8031e5:	75 e0                	jne    8031c7 <strnlen+0x19>
		n++;
	return n;
  8031e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031ea:	c9                   	leaveq 
  8031eb:	c3                   	retq   

00000000008031ec <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8031ec:	55                   	push   %rbp
  8031ed:	48 89 e5             	mov    %rsp,%rbp
  8031f0:	48 83 ec 20          	sub    $0x20,%rsp
  8031f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8031fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803200:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803204:	90                   	nop
  803205:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803209:	0f b6 10             	movzbl (%rax),%edx
  80320c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803210:	88 10                	mov    %dl,(%rax)
  803212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803216:	0f b6 00             	movzbl (%rax),%eax
  803219:	84 c0                	test   %al,%al
  80321b:	0f 95 c0             	setne  %al
  80321e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803223:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803228:	84 c0                	test   %al,%al
  80322a:	75 d9                	jne    803205 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80322c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803230:	c9                   	leaveq 
  803231:	c3                   	retq   

0000000000803232 <strcat>:

char *
strcat(char *dst, const char *src)
{
  803232:	55                   	push   %rbp
  803233:	48 89 e5             	mov    %rsp,%rbp
  803236:	48 83 ec 20          	sub    $0x20,%rsp
  80323a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80323e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  803242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803246:	48 89 c7             	mov    %rax,%rdi
  803249:	48 b8 80 31 80 00 00 	movabs $0x803180,%rax
  803250:	00 00 00 
  803253:	ff d0                	callq  *%rax
  803255:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  803258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325b:	48 98                	cltq   
  80325d:	48 03 45 e8          	add    -0x18(%rbp),%rax
  803261:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803265:	48 89 d6             	mov    %rdx,%rsi
  803268:	48 89 c7             	mov    %rax,%rdi
  80326b:	48 b8 ec 31 80 00 00 	movabs $0x8031ec,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
	return dst;
  803277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80327b:	c9                   	leaveq 
  80327c:	c3                   	retq   

000000000080327d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80327d:	55                   	push   %rbp
  80327e:	48 89 e5             	mov    %rsp,%rbp
  803281:	48 83 ec 28          	sub    $0x28,%rsp
  803285:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803289:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80328d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  803291:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803295:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  803299:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032a0:	00 
  8032a1:	eb 27                	jmp    8032ca <strncpy+0x4d>
		*dst++ = *src;
  8032a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032a7:	0f b6 10             	movzbl (%rax),%edx
  8032aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ae:	88 10                	mov    %dl,(%rax)
  8032b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8032b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032b9:	0f b6 00             	movzbl (%rax),%eax
  8032bc:	84 c0                	test   %al,%al
  8032be:	74 05                	je     8032c5 <strncpy+0x48>
			src++;
  8032c0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8032c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8032d2:	72 cf                	jb     8032a3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8032d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032d8:	c9                   	leaveq 
  8032d9:	c3                   	retq   

00000000008032da <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8032da:	55                   	push   %rbp
  8032db:	48 89 e5             	mov    %rsp,%rbp
  8032de:	48 83 ec 28          	sub    $0x28,%rsp
  8032e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8032ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8032f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8032fb:	74 37                	je     803334 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8032fd:	eb 17                	jmp    803316 <strlcpy+0x3c>
			*dst++ = *src++;
  8032ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803303:	0f b6 10             	movzbl (%rax),%edx
  803306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80330a:	88 10                	mov    %dl,(%rax)
  80330c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803311:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  803316:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80331b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803320:	74 0b                	je     80332d <strlcpy+0x53>
  803322:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803326:	0f b6 00             	movzbl (%rax),%eax
  803329:	84 c0                	test   %al,%al
  80332b:	75 d2                	jne    8032ff <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80332d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803331:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  803334:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80333c:	48 89 d1             	mov    %rdx,%rcx
  80333f:	48 29 c1             	sub    %rax,%rcx
  803342:	48 89 c8             	mov    %rcx,%rax
}
  803345:	c9                   	leaveq 
  803346:	c3                   	retq   

0000000000803347 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803347:	55                   	push   %rbp
  803348:	48 89 e5             	mov    %rsp,%rbp
  80334b:	48 83 ec 10          	sub    $0x10,%rsp
  80334f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803353:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  803357:	eb 0a                	jmp    803363 <strcmp+0x1c>
		p++, q++;
  803359:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80335e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  803363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803367:	0f b6 00             	movzbl (%rax),%eax
  80336a:	84 c0                	test   %al,%al
  80336c:	74 12                	je     803380 <strcmp+0x39>
  80336e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803372:	0f b6 10             	movzbl (%rax),%edx
  803375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803379:	0f b6 00             	movzbl (%rax),%eax
  80337c:	38 c2                	cmp    %al,%dl
  80337e:	74 d9                	je     803359 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  803380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803384:	0f b6 00             	movzbl (%rax),%eax
  803387:	0f b6 d0             	movzbl %al,%edx
  80338a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338e:	0f b6 00             	movzbl (%rax),%eax
  803391:	0f b6 c0             	movzbl %al,%eax
  803394:	89 d1                	mov    %edx,%ecx
  803396:	29 c1                	sub    %eax,%ecx
  803398:	89 c8                	mov    %ecx,%eax
}
  80339a:	c9                   	leaveq 
  80339b:	c3                   	retq   

000000000080339c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80339c:	55                   	push   %rbp
  80339d:	48 89 e5             	mov    %rsp,%rbp
  8033a0:	48 83 ec 18          	sub    $0x18,%rsp
  8033a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8033b0:	eb 0f                	jmp    8033c1 <strncmp+0x25>
		n--, p++, q++;
  8033b2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8033b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033bc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8033c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033c6:	74 1d                	je     8033e5 <strncmp+0x49>
  8033c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cc:	0f b6 00             	movzbl (%rax),%eax
  8033cf:	84 c0                	test   %al,%al
  8033d1:	74 12                	je     8033e5 <strncmp+0x49>
  8033d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033d7:	0f b6 10             	movzbl (%rax),%edx
  8033da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033de:	0f b6 00             	movzbl (%rax),%eax
  8033e1:	38 c2                	cmp    %al,%dl
  8033e3:	74 cd                	je     8033b2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8033e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033ea:	75 07                	jne    8033f3 <strncmp+0x57>
		return 0;
  8033ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f1:	eb 1a                	jmp    80340d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8033f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f7:	0f b6 00             	movzbl (%rax),%eax
  8033fa:	0f b6 d0             	movzbl %al,%edx
  8033fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803401:	0f b6 00             	movzbl (%rax),%eax
  803404:	0f b6 c0             	movzbl %al,%eax
  803407:	89 d1                	mov    %edx,%ecx
  803409:	29 c1                	sub    %eax,%ecx
  80340b:	89 c8                	mov    %ecx,%eax
}
  80340d:	c9                   	leaveq 
  80340e:	c3                   	retq   

000000000080340f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80340f:	55                   	push   %rbp
  803410:	48 89 e5             	mov    %rsp,%rbp
  803413:	48 83 ec 10          	sub    $0x10,%rsp
  803417:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80341b:	89 f0                	mov    %esi,%eax
  80341d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  803420:	eb 17                	jmp    803439 <strchr+0x2a>
		if (*s == c)
  803422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803426:	0f b6 00             	movzbl (%rax),%eax
  803429:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80342c:	75 06                	jne    803434 <strchr+0x25>
			return (char *) s;
  80342e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803432:	eb 15                	jmp    803449 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  803434:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803439:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343d:	0f b6 00             	movzbl (%rax),%eax
  803440:	84 c0                	test   %al,%al
  803442:	75 de                	jne    803422 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803444:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803449:	c9                   	leaveq 
  80344a:	c3                   	retq   

000000000080344b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80344b:	55                   	push   %rbp
  80344c:	48 89 e5             	mov    %rsp,%rbp
  80344f:	48 83 ec 10          	sub    $0x10,%rsp
  803453:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803457:	89 f0                	mov    %esi,%eax
  803459:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80345c:	eb 11                	jmp    80346f <strfind+0x24>
		if (*s == c)
  80345e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803462:	0f b6 00             	movzbl (%rax),%eax
  803465:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803468:	74 12                	je     80347c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80346a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80346f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803473:	0f b6 00             	movzbl (%rax),%eax
  803476:	84 c0                	test   %al,%al
  803478:	75 e4                	jne    80345e <strfind+0x13>
  80347a:	eb 01                	jmp    80347d <strfind+0x32>
		if (*s == c)
			break;
  80347c:	90                   	nop
	return (char *) s;
  80347d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803481:	c9                   	leaveq 
  803482:	c3                   	retq   

0000000000803483 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  803483:	55                   	push   %rbp
  803484:	48 89 e5             	mov    %rsp,%rbp
  803487:	48 83 ec 18          	sub    $0x18,%rsp
  80348b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80348f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  803492:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  803496:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80349b:	75 06                	jne    8034a3 <memset+0x20>
		return v;
  80349d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a1:	eb 69                	jmp    80350c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8034a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a7:	83 e0 03             	and    $0x3,%eax
  8034aa:	48 85 c0             	test   %rax,%rax
  8034ad:	75 48                	jne    8034f7 <memset+0x74>
  8034af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b3:	83 e0 03             	and    $0x3,%eax
  8034b6:	48 85 c0             	test   %rax,%rax
  8034b9:	75 3c                	jne    8034f7 <memset+0x74>
		c &= 0xFF;
  8034bb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8034c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034c5:	89 c2                	mov    %eax,%edx
  8034c7:	c1 e2 18             	shl    $0x18,%edx
  8034ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034cd:	c1 e0 10             	shl    $0x10,%eax
  8034d0:	09 c2                	or     %eax,%edx
  8034d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034d5:	c1 e0 08             	shl    $0x8,%eax
  8034d8:	09 d0                	or     %edx,%eax
  8034da:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8034dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e1:	48 89 c1             	mov    %rax,%rcx
  8034e4:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8034e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034ef:	48 89 d7             	mov    %rdx,%rdi
  8034f2:	fc                   	cld    
  8034f3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8034f5:	eb 11                	jmp    803508 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8034f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034fe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803502:	48 89 d7             	mov    %rdx,%rdi
  803505:	fc                   	cld    
  803506:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  803508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80350c:	c9                   	leaveq 
  80350d:	c3                   	retq   

000000000080350e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80350e:	55                   	push   %rbp
  80350f:	48 89 e5             	mov    %rsp,%rbp
  803512:	48 83 ec 28          	sub    $0x28,%rsp
  803516:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80351a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80351e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  803522:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803526:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80352a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  803532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803536:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80353a:	0f 83 88 00 00 00    	jae    8035c8 <memmove+0xba>
  803540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803544:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803548:	48 01 d0             	add    %rdx,%rax
  80354b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80354f:	76 77                	jbe    8035c8 <memmove+0xba>
		s += n;
  803551:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803555:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  803559:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80355d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803565:	83 e0 03             	and    $0x3,%eax
  803568:	48 85 c0             	test   %rax,%rax
  80356b:	75 3b                	jne    8035a8 <memmove+0x9a>
  80356d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803571:	83 e0 03             	and    $0x3,%eax
  803574:	48 85 c0             	test   %rax,%rax
  803577:	75 2f                	jne    8035a8 <memmove+0x9a>
  803579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80357d:	83 e0 03             	and    $0x3,%eax
  803580:	48 85 c0             	test   %rax,%rax
  803583:	75 23                	jne    8035a8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803589:	48 83 e8 04          	sub    $0x4,%rax
  80358d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803591:	48 83 ea 04          	sub    $0x4,%rdx
  803595:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803599:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80359d:	48 89 c7             	mov    %rax,%rdi
  8035a0:	48 89 d6             	mov    %rdx,%rsi
  8035a3:	fd                   	std    
  8035a4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8035a6:	eb 1d                	jmp    8035c5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8035a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8035b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8035b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bc:	48 89 d7             	mov    %rdx,%rdi
  8035bf:	48 89 c1             	mov    %rax,%rcx
  8035c2:	fd                   	std    
  8035c3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8035c5:	fc                   	cld    
  8035c6:	eb 57                	jmp    80361f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8035c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cc:	83 e0 03             	and    $0x3,%eax
  8035cf:	48 85 c0             	test   %rax,%rax
  8035d2:	75 36                	jne    80360a <memmove+0xfc>
  8035d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d8:	83 e0 03             	and    $0x3,%eax
  8035db:	48 85 c0             	test   %rax,%rax
  8035de:	75 2a                	jne    80360a <memmove+0xfc>
  8035e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e4:	83 e0 03             	and    $0x3,%eax
  8035e7:	48 85 c0             	test   %rax,%rax
  8035ea:	75 1e                	jne    80360a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8035ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f0:	48 89 c1             	mov    %rax,%rcx
  8035f3:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8035f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035ff:	48 89 c7             	mov    %rax,%rdi
  803602:	48 89 d6             	mov    %rdx,%rsi
  803605:	fc                   	cld    
  803606:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803608:	eb 15                	jmp    80361f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80360a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803612:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803616:	48 89 c7             	mov    %rax,%rdi
  803619:	48 89 d6             	mov    %rdx,%rsi
  80361c:	fc                   	cld    
  80361d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80361f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803623:	c9                   	leaveq 
  803624:	c3                   	retq   

0000000000803625 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803625:	55                   	push   %rbp
  803626:	48 89 e5             	mov    %rsp,%rbp
  803629:	48 83 ec 18          	sub    $0x18,%rsp
  80362d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803631:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803635:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803639:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80363d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803645:	48 89 ce             	mov    %rcx,%rsi
  803648:	48 89 c7             	mov    %rax,%rdi
  80364b:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  803652:	00 00 00 
  803655:	ff d0                	callq  *%rax
}
  803657:	c9                   	leaveq 
  803658:	c3                   	retq   

0000000000803659 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803659:	55                   	push   %rbp
  80365a:	48 89 e5             	mov    %rsp,%rbp
  80365d:	48 83 ec 28          	sub    $0x28,%rsp
  803661:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803665:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803669:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80366d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803671:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803675:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803679:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80367d:	eb 38                	jmp    8036b7 <memcmp+0x5e>
		if (*s1 != *s2)
  80367f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803683:	0f b6 10             	movzbl (%rax),%edx
  803686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368a:	0f b6 00             	movzbl (%rax),%eax
  80368d:	38 c2                	cmp    %al,%dl
  80368f:	74 1c                	je     8036ad <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  803691:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803695:	0f b6 00             	movzbl (%rax),%eax
  803698:	0f b6 d0             	movzbl %al,%edx
  80369b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369f:	0f b6 00             	movzbl (%rax),%eax
  8036a2:	0f b6 c0             	movzbl %al,%eax
  8036a5:	89 d1                	mov    %edx,%ecx
  8036a7:	29 c1                	sub    %eax,%ecx
  8036a9:	89 c8                	mov    %ecx,%eax
  8036ab:	eb 20                	jmp    8036cd <memcmp+0x74>
		s1++, s2++;
  8036ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036b2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8036b7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8036bc:	0f 95 c0             	setne  %al
  8036bf:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8036c4:	84 c0                	test   %al,%al
  8036c6:	75 b7                	jne    80367f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8036c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036cd:	c9                   	leaveq 
  8036ce:	c3                   	retq   

00000000008036cf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8036cf:	55                   	push   %rbp
  8036d0:	48 89 e5             	mov    %rsp,%rbp
  8036d3:	48 83 ec 28          	sub    $0x28,%rsp
  8036d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036db:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8036de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8036e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036ea:	48 01 d0             	add    %rdx,%rax
  8036ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8036f1:	eb 13                	jmp    803706 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8036f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f7:	0f b6 10             	movzbl (%rax),%edx
  8036fa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8036fd:	38 c2                	cmp    %al,%dl
  8036ff:	74 11                	je     803712 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803701:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80370a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80370e:	72 e3                	jb     8036f3 <memfind+0x24>
  803710:	eb 01                	jmp    803713 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  803712:	90                   	nop
	return (void *) s;
  803713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803717:	c9                   	leaveq 
  803718:	c3                   	retq   

0000000000803719 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803719:	55                   	push   %rbp
  80371a:	48 89 e5             	mov    %rsp,%rbp
  80371d:	48 83 ec 38          	sub    $0x38,%rsp
  803721:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803725:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803729:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80372c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803733:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80373a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80373b:	eb 05                	jmp    803742 <strtol+0x29>
		s++;
  80373d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803746:	0f b6 00             	movzbl (%rax),%eax
  803749:	3c 20                	cmp    $0x20,%al
  80374b:	74 f0                	je     80373d <strtol+0x24>
  80374d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803751:	0f b6 00             	movzbl (%rax),%eax
  803754:	3c 09                	cmp    $0x9,%al
  803756:	74 e5                	je     80373d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80375c:	0f b6 00             	movzbl (%rax),%eax
  80375f:	3c 2b                	cmp    $0x2b,%al
  803761:	75 07                	jne    80376a <strtol+0x51>
		s++;
  803763:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803768:	eb 17                	jmp    803781 <strtol+0x68>
	else if (*s == '-')
  80376a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376e:	0f b6 00             	movzbl (%rax),%eax
  803771:	3c 2d                	cmp    $0x2d,%al
  803773:	75 0c                	jne    803781 <strtol+0x68>
		s++, neg = 1;
  803775:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80377a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803781:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803785:	74 06                	je     80378d <strtol+0x74>
  803787:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80378b:	75 28                	jne    8037b5 <strtol+0x9c>
  80378d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803791:	0f b6 00             	movzbl (%rax),%eax
  803794:	3c 30                	cmp    $0x30,%al
  803796:	75 1d                	jne    8037b5 <strtol+0x9c>
  803798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80379c:	48 83 c0 01          	add    $0x1,%rax
  8037a0:	0f b6 00             	movzbl (%rax),%eax
  8037a3:	3c 78                	cmp    $0x78,%al
  8037a5:	75 0e                	jne    8037b5 <strtol+0x9c>
		s += 2, base = 16;
  8037a7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8037ac:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8037b3:	eb 2c                	jmp    8037e1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8037b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8037b9:	75 19                	jne    8037d4 <strtol+0xbb>
  8037bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037bf:	0f b6 00             	movzbl (%rax),%eax
  8037c2:	3c 30                	cmp    $0x30,%al
  8037c4:	75 0e                	jne    8037d4 <strtol+0xbb>
		s++, base = 8;
  8037c6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8037cb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8037d2:	eb 0d                	jmp    8037e1 <strtol+0xc8>
	else if (base == 0)
  8037d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8037d8:	75 07                	jne    8037e1 <strtol+0xc8>
		base = 10;
  8037da:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8037e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e5:	0f b6 00             	movzbl (%rax),%eax
  8037e8:	3c 2f                	cmp    $0x2f,%al
  8037ea:	7e 1d                	jle    803809 <strtol+0xf0>
  8037ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f0:	0f b6 00             	movzbl (%rax),%eax
  8037f3:	3c 39                	cmp    $0x39,%al
  8037f5:	7f 12                	jg     803809 <strtol+0xf0>
			dig = *s - '0';
  8037f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037fb:	0f b6 00             	movzbl (%rax),%eax
  8037fe:	0f be c0             	movsbl %al,%eax
  803801:	83 e8 30             	sub    $0x30,%eax
  803804:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803807:	eb 4e                	jmp    803857 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380d:	0f b6 00             	movzbl (%rax),%eax
  803810:	3c 60                	cmp    $0x60,%al
  803812:	7e 1d                	jle    803831 <strtol+0x118>
  803814:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803818:	0f b6 00             	movzbl (%rax),%eax
  80381b:	3c 7a                	cmp    $0x7a,%al
  80381d:	7f 12                	jg     803831 <strtol+0x118>
			dig = *s - 'a' + 10;
  80381f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803823:	0f b6 00             	movzbl (%rax),%eax
  803826:	0f be c0             	movsbl %al,%eax
  803829:	83 e8 57             	sub    $0x57,%eax
  80382c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80382f:	eb 26                	jmp    803857 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803835:	0f b6 00             	movzbl (%rax),%eax
  803838:	3c 40                	cmp    $0x40,%al
  80383a:	7e 47                	jle    803883 <strtol+0x16a>
  80383c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803840:	0f b6 00             	movzbl (%rax),%eax
  803843:	3c 5a                	cmp    $0x5a,%al
  803845:	7f 3c                	jg     803883 <strtol+0x16a>
			dig = *s - 'A' + 10;
  803847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384b:	0f b6 00             	movzbl (%rax),%eax
  80384e:	0f be c0             	movsbl %al,%eax
  803851:	83 e8 37             	sub    $0x37,%eax
  803854:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803857:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80385a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80385d:	7d 23                	jge    803882 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80385f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803864:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803867:	48 98                	cltq   
  803869:	48 89 c2             	mov    %rax,%rdx
  80386c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  803871:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803874:	48 98                	cltq   
  803876:	48 01 d0             	add    %rdx,%rax
  803879:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80387d:	e9 5f ff ff ff       	jmpq   8037e1 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  803882:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  803883:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803888:	74 0b                	je     803895 <strtol+0x17c>
		*endptr = (char *) s;
  80388a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80388e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803892:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803895:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803899:	74 09                	je     8038a4 <strtol+0x18b>
  80389b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389f:	48 f7 d8             	neg    %rax
  8038a2:	eb 04                	jmp    8038a8 <strtol+0x18f>
  8038a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8038a8:	c9                   	leaveq 
  8038a9:	c3                   	retq   

00000000008038aa <strstr>:

char * strstr(const char *in, const char *str)
{
  8038aa:	55                   	push   %rbp
  8038ab:	48 89 e5             	mov    %rsp,%rbp
  8038ae:	48 83 ec 30          	sub    $0x30,%rsp
  8038b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8038ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038be:	0f b6 00             	movzbl (%rax),%eax
  8038c1:	88 45 ff             	mov    %al,-0x1(%rbp)
  8038c4:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8038c9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8038cd:	75 06                	jne    8038d5 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8038cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d3:	eb 68                	jmp    80393d <strstr+0x93>

    len = strlen(str);
  8038d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d9:	48 89 c7             	mov    %rax,%rdi
  8038dc:	48 b8 80 31 80 00 00 	movabs $0x803180,%rax
  8038e3:	00 00 00 
  8038e6:	ff d0                	callq  *%rax
  8038e8:	48 98                	cltq   
  8038ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8038ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f2:	0f b6 00             	movzbl (%rax),%eax
  8038f5:	88 45 ef             	mov    %al,-0x11(%rbp)
  8038f8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8038fd:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803901:	75 07                	jne    80390a <strstr+0x60>
                return (char *) 0;
  803903:	b8 00 00 00 00       	mov    $0x0,%eax
  803908:	eb 33                	jmp    80393d <strstr+0x93>
        } while (sc != c);
  80390a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80390e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803911:	75 db                	jne    8038ee <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  803913:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803917:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80391b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80391f:	48 89 ce             	mov    %rcx,%rsi
  803922:	48 89 c7             	mov    %rax,%rdi
  803925:	48 b8 9c 33 80 00 00 	movabs $0x80339c,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
  803931:	85 c0                	test   %eax,%eax
  803933:	75 b9                	jne    8038ee <strstr+0x44>

    return (char *) (in - 1);
  803935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803939:	48 83 e8 01          	sub    $0x1,%rax
}
  80393d:	c9                   	leaveq 
  80393e:	c3                   	retq   
	...

0000000000803940 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803940:	55                   	push   %rbp
  803941:	48 89 e5             	mov    %rsp,%rbp
  803944:	48 83 ec 30          	sub    $0x30,%rsp
  803948:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80394c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803950:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803954:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803959:	74 18                	je     803973 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80395b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80395f:	48 89 c7             	mov    %rax,%rdi
  803962:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  803969:	00 00 00 
  80396c:	ff d0                	callq  *%rax
  80396e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803971:	eb 19                	jmp    80398c <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803973:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80397a:	00 00 00 
  80397d:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
  803989:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  80398c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803990:	79 19                	jns    8039ab <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803996:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  80399c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039a0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8039a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a9:	eb 53                	jmp    8039fe <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8039ab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039b0:	74 19                	je     8039cb <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8039b2:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8039b9:	00 00 00 
  8039bc:	48 8b 00             	mov    (%rax),%rax
  8039bf:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8039c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c9:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8039cb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039d0:	74 19                	je     8039eb <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8039d2:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8039d9:	00 00 00 
  8039dc:	48 8b 00             	mov    (%rax),%rax
  8039df:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8039e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e9:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8039eb:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8039f2:	00 00 00 
  8039f5:	48 8b 00             	mov    (%rax),%rax
  8039f8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8039fe:	c9                   	leaveq 
  8039ff:	c3                   	retq   

0000000000803a00 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a00:	55                   	push   %rbp
  803a01:	48 89 e5             	mov    %rsp,%rbp
  803a04:	48 83 ec 30          	sub    $0x30,%rsp
  803a08:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a0b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a0e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a12:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803a15:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803a1c:	e9 96 00 00 00       	jmpq   803ab7 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803a21:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a26:	74 20                	je     803a48 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803a28:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a2b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803a2e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803a32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a35:	89 c7                	mov    %eax,%edi
  803a37:	48 b8 f8 04 80 00 00 	movabs $0x8004f8,%rax
  803a3e:	00 00 00 
  803a41:	ff d0                	callq  *%rax
  803a43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a46:	eb 2d                	jmp    803a75 <ipc_send+0x75>
		else if(pg==NULL)
  803a48:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a4d:	75 26                	jne    803a75 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803a4f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a55:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a5a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a61:	00 00 00 
  803a64:	89 c7                	mov    %eax,%edi
  803a66:	48 b8 f8 04 80 00 00 	movabs $0x8004f8,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
  803a72:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803a75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a79:	79 30                	jns    803aab <ipc_send+0xab>
  803a7b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803a7f:	74 2a                	je     803aab <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803a81:	48 ba e0 41 80 00 00 	movabs $0x8041e0,%rdx
  803a88:	00 00 00 
  803a8b:	be 40 00 00 00       	mov    $0x40,%esi
  803a90:	48 bf f8 41 80 00 00 	movabs $0x8041f8,%rdi
  803a97:	00 00 00 
  803a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9f:	48 b9 f4 23 80 00 00 	movabs $0x8023f4,%rcx
  803aa6:	00 00 00 
  803aa9:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803aab:	48 b8 e6 02 80 00 00 	movabs $0x8002e6,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803ab7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abb:	0f 85 60 ff ff ff    	jne    803a21 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803ac1:	c9                   	leaveq 
  803ac2:	c3                   	retq   

0000000000803ac3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ac3:	55                   	push   %rbp
  803ac4:	48 89 e5             	mov    %rsp,%rbp
  803ac7:	48 83 ec 18          	sub    $0x18,%rsp
  803acb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803ace:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ad5:	eb 5e                	jmp    803b35 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ad7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ade:	00 00 00 
  803ae1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae4:	48 63 d0             	movslq %eax,%rdx
  803ae7:	48 89 d0             	mov    %rdx,%rax
  803aea:	48 c1 e0 03          	shl    $0x3,%rax
  803aee:	48 01 d0             	add    %rdx,%rax
  803af1:	48 c1 e0 05          	shl    $0x5,%rax
  803af5:	48 01 c8             	add    %rcx,%rax
  803af8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803afe:	8b 00                	mov    (%rax),%eax
  803b00:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b03:	75 2c                	jne    803b31 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b05:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b0c:	00 00 00 
  803b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b12:	48 63 d0             	movslq %eax,%rdx
  803b15:	48 89 d0             	mov    %rdx,%rax
  803b18:	48 c1 e0 03          	shl    $0x3,%rax
  803b1c:	48 01 d0             	add    %rdx,%rax
  803b1f:	48 c1 e0 05          	shl    $0x5,%rax
  803b23:	48 01 c8             	add    %rcx,%rax
  803b26:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b2c:	8b 40 08             	mov    0x8(%rax),%eax
  803b2f:	eb 12                	jmp    803b43 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803b31:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b35:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b3c:	7e 99                	jle    803ad7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803b3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b43:	c9                   	leaveq 
  803b44:	c3                   	retq   
  803b45:	00 00                	add    %al,(%rax)
	...

0000000000803b48 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b48:	55                   	push   %rbp
  803b49:	48 89 e5             	mov    %rsp,%rbp
  803b4c:	48 83 ec 18          	sub    $0x18,%rsp
  803b50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b58:	48 89 c2             	mov    %rax,%rdx
  803b5b:	48 c1 ea 15          	shr    $0x15,%rdx
  803b5f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b66:	01 00 00 
  803b69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b6d:	83 e0 01             	and    $0x1,%eax
  803b70:	48 85 c0             	test   %rax,%rax
  803b73:	75 07                	jne    803b7c <pageref+0x34>
		return 0;
  803b75:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7a:	eb 53                	jmp    803bcf <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b80:	48 89 c2             	mov    %rax,%rdx
  803b83:	48 c1 ea 0c          	shr    $0xc,%rdx
  803b87:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b8e:	01 00 00 
  803b91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b95:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803b99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b9d:	83 e0 01             	and    $0x1,%eax
  803ba0:	48 85 c0             	test   %rax,%rax
  803ba3:	75 07                	jne    803bac <pageref+0x64>
		return 0;
  803ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  803baa:	eb 23                	jmp    803bcf <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb0:	48 89 c2             	mov    %rax,%rdx
  803bb3:	48 c1 ea 0c          	shr    $0xc,%rdx
  803bb7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803bbe:	00 00 00 
  803bc1:	48 c1 e2 04          	shl    $0x4,%rdx
  803bc5:	48 01 d0             	add    %rdx,%rax
  803bc8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803bcc:	0f b7 c0             	movzwl %ax,%eax
}
  803bcf:	c9                   	leaveq 
  803bd0:	c3                   	retq   
