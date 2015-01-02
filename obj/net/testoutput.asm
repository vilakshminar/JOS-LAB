
obj/net/testoutput:     file format elf64-x86-64


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
  80003c:	e8 23 05 00 00       	callq  800564 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	53                   	push   %rbx
  800049:	48 83 ec 28          	sub    $0x28,%rsp
  80004d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800050:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t ns_envid = sys_getenvid();
  800054:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  80005b:	00 00 00 
  80005e:	ff d0                	callq  *%rax
  800060:	89 45 e8             	mov    %eax,-0x18(%rbp)
	int i, r;

	binaryname = "testoutput";
  800063:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80006a:	00 00 00 
  80006d:	48 ba e0 48 80 00 00 	movabs $0x8048e0,%rdx
  800074:	00 00 00 
  800077:	48 89 10             	mov    %rdx,(%rax)

	output_envid = fork();
  80007a:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  800081:	00 00 00 
  800084:	ff d0                	callq  *%rax
  800086:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  80008d:	00 00 00 
  800090:	89 02                	mov    %eax,(%rdx)
	if (output_envid < 0)
  800092:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  800099:	00 00 00 
  80009c:	8b 00                	mov    (%rax),%eax
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	79 2a                	jns    8000cc <umain+0x88>
		panic("error forking");
  8000a2:	48 ba eb 48 80 00 00 	movabs $0x8048eb,%rdx
  8000a9:	00 00 00 
  8000ac:	be 16 00 00 00       	mov    $0x16,%esi
  8000b1:	48 bf f9 48 80 00 00 	movabs $0x8048f9,%rdi
  8000b8:	00 00 00 
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	48 b9 2c 06 80 00 00 	movabs $0x80062c,%rcx
  8000c7:	00 00 00 
  8000ca:	ff d1                	callq  *%rcx
	else if (output_envid == 0) {
  8000cc:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8000d3:	00 00 00 
  8000d6:	8b 00                	mov    (%rax),%eax
  8000d8:	85 c0                	test   %eax,%eax
  8000da:	75 16                	jne    8000f2 <umain+0xae>
		output(ns_envid);
  8000dc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8000df:	89 c7                	mov    %eax,%edi
  8000e1:	48 b8 7c 04 80 00 00 	movabs $0x80047c,%rax
  8000e8:	00 00 00 
  8000eb:	ff d0                	callq  *%rax
		return;
  8000ed:	e9 50 01 00 00       	jmpq   800242 <umain+0x1fe>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8000f9:	e9 1b 01 00 00       	jmpq   800219 <umain+0x1d5>
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000fe:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800105:	00 00 00 
  800108:	48 8b 00             	mov    (%rax),%rax
  80010b:	ba 07 00 00 00       	mov    $0x7,%edx
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 00       	mov    $0x0,%edi
  800118:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
  800124:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800127:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80012b:	79 30                	jns    80015d <umain+0x119>
			panic("sys_page_alloc: %e", r);
  80012d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800130:	89 c1                	mov    %eax,%ecx
  800132:	48 ba 0a 49 80 00 00 	movabs $0x80490a,%rdx
  800139:	00 00 00 
  80013c:	be 1e 00 00 00       	mov    $0x1e,%esi
  800141:	48 bf f9 48 80 00 00 	movabs $0x8048f9,%rdi
  800148:	00 00 00 
  80014b:	b8 00 00 00 00       	mov    $0x0,%eax
  800150:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  800157:	00 00 00 
  80015a:	41 ff d0             	callq  *%r8
		pkt->jp_len = snprintf(pkt->jp_data,
  80015d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800164:	00 00 00 
  800167:	48 8b 18             	mov    (%rax),%rbx
  80016a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800171:	00 00 00 
  800174:	48 8b 00             	mov    (%rax),%rax
  800177:	48 8d 78 04          	lea    0x4(%rax),%rdi
  80017b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80017e:	89 c1                	mov    %eax,%ecx
  800180:	48 ba 1d 49 80 00 00 	movabs $0x80491d,%rdx
  800187:	00 00 00 
  80018a:	be fc 0f 00 00       	mov    $0xffc,%esi
  80018f:	b8 00 00 00 00       	mov    $0x0,%eax
  800194:	49 b8 d6 12 80 00 00 	movabs $0x8012d6,%r8
  80019b:	00 00 00 
  80019e:	41 ff d0             	callq  *%r8
  8001a1:	89 03                	mov    %eax,(%rbx)
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8001a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001a6:	89 c6                	mov    %eax,%esi
  8001a8:	48 bf 29 49 80 00 00 	movabs $0x804929,%rdi
  8001af:	00 00 00 
  8001b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b7:	48 ba 67 08 80 00 00 	movabs $0x800867,%rdx
  8001be:	00 00 00 
  8001c1:	ff d2                	callq  *%rdx
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001c3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001ca:	00 00 00 
  8001cd:	48 8b 10             	mov    (%rax),%rdx
  8001d0:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8001d7:	00 00 00 
  8001da:	8b 00                	mov    (%rax),%eax
  8001dc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001e1:	be 0b 00 00 00       	mov    $0xb,%esi
  8001e6:	89 c7                	mov    %eax,%edi
  8001e8:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	callq  *%rax
		sys_page_unmap(0, pkt);
  8001f4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001fb:	00 00 00 
  8001fe:	48 8b 00             	mov    (%rax),%rax
  800201:	48 89 c6             	mov    %rax,%rsi
  800204:	bf 00 00 00 00       	mov    $0x0,%edi
  800209:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  800210:	00 00 00 
  800213:	ff d0                	callq  *%rax
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800215:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800219:	83 7d ec 09          	cmpl   $0x9,-0x14(%rbp)
  80021d:	0f 8e db fe ff ff    	jle    8000fe <umain+0xba>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800223:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80022a:	eb 10                	jmp    80023c <umain+0x1f8>
		sys_yield();
  80022c:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  800233:	00 00 00 
  800236:	ff d0                	callq  *%rax
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800238:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80023c:	83 7d ec 13          	cmpl   $0x13,-0x14(%rbp)
  800240:	7e ea                	jle    80022c <umain+0x1e8>
		sys_yield();
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   
  800249:	00 00                	add    %al,(%rax)
	...

000000000080024c <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  80024c:	55                   	push   %rbp
  80024d:	48 89 e5             	mov    %rsp,%rbp
  800250:	48 83 ec 20          	sub    $0x20,%rsp
  800254:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800257:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80025a:	48 b8 c9 1f 80 00 00 	movabs $0x801fc9,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
  800266:	03 45 e8             	add    -0x18(%rbp),%eax
  800269:	89 45 fc             	mov    %eax,-0x4(%rbp)

	binaryname = "ns_timer";
  80026c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800273:	00 00 00 
  800276:	48 ba 48 49 80 00 00 	movabs $0x804948,%rdx
  80027d:	00 00 00 
  800280:	48 89 10             	mov    %rdx,(%rax)

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  800283:	eb 0c                	jmp    800291 <timer+0x45>
			sys_yield();
  800285:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  80028c:	00 00 00 
  80028f:	ff d0                	callq  *%rax
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  800291:	48 b8 c9 1f 80 00 00 	movabs $0x801fc9,%rax
  800298:	00 00 00 
  80029b:	ff d0                	callq  *%rax
  80029d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002a3:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8002a6:	73 06                	jae    8002ae <timer+0x62>
  8002a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ac:	79 d7                	jns    800285 <timer+0x39>
			sys_yield();
		}
		if (r < 0)
  8002ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002b2:	79 30                	jns    8002e4 <timer+0x98>
			panic("sys_time_msec: %e", r);
  8002b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002b7:	89 c1                	mov    %eax,%ecx
  8002b9:	48 ba 51 49 80 00 00 	movabs $0x804951,%rdx
  8002c0:	00 00 00 
  8002c3:	be 0f 00 00 00       	mov    $0xf,%esi
  8002c8:	48 bf 63 49 80 00 00 	movabs $0x804963,%rdi
  8002cf:	00 00 00 
  8002d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d7:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  8002de:	00 00 00 
  8002e1:	41 ff d0             	callq  *%r8

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8002e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f1:	be 0c 00 00 00       	mov    $0xc,%esi
  8002f6:	89 c7                	mov    %eax,%edi
  8002f8:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  8002ff:	00 00 00 
  800302:	ff d0                	callq  *%rax

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800304:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800308:	ba 00 00 00 00       	mov    $0x0,%edx
  80030d:	be 00 00 00 00       	mov    $0x0,%esi
  800312:	48 89 c7             	mov    %rax,%rdi
  800315:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  80031c:	00 00 00 
  80031f:	ff d0                	callq  *%rax
  800321:	89 45 f4             	mov    %eax,-0xc(%rbp)

			if (whom != ns_envid) {
  800324:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800327:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032a:	39 c2                	cmp    %eax,%edx
  80032c:	74 22                	je     800350 <timer+0x104>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  80032e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf 70 49 80 00 00 	movabs $0x804970,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 ba 67 08 80 00 00 	movabs $0x800867,%rdx
  800349:	00 00 00 
  80034c:	ff d2                	callq  *%rdx
				continue;
			}

			stop = sys_time_msec() + to;
			break;
		}
  80034e:	eb b4                	jmp    800304 <timer+0xb8>
			if (whom != ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800350:	48 b8 c9 1f 80 00 00 	movabs $0x801fc9,%rax
  800357:	00 00 00 
  80035a:	ff d0                	callq  *%rax
  80035c:	03 45 f4             	add    -0xc(%rbp),%eax
  80035f:	89 45 fc             	mov    %eax,-0x4(%rbp)
			break;
  800362:	90                   	nop
		}
	}
  800363:	90                   	nop
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  800364:	e9 28 ff ff ff       	jmpq   800291 <timer+0x45>
  800369:	00 00                	add    %al,(%rax)
	...

000000000080036c <input>:
extern union Nsipc nsipcbuf;


void
input(envid_t ns_envid)
{
  80036c:	55                   	push   %rbp
  80036d:	48 89 e5             	mov    %rsp,%rbp
  800370:	48 83 ec 40          	sub    $0x40,%rsp
  800374:	89 7d cc             	mov    %edi,-0x34(%rbp)
	binaryname = "ns_input";
  800377:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80037e:	00 00 00 
  800381:	48 ba b0 49 80 00 00 	movabs $0x8049b0,%rdx
  800388:	00 00 00 
  80038b:	48 89 10             	mov    %rdx,(%rax)
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
	struct jif_pkt *packet;
	uintptr_t addr;
	size_t len;
	uint32_t reqType = NSREQ_INPUT;
  80038e:	c7 45 fc 0a 00 00 00 	movl   $0xa,-0x4(%rbp)
	int r, recvBuffLen=0;
  800395:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	packet = (struct jif_pkt *)&(nsipcbuf);
  80039c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8003a3:	00 00 00 
  8003a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//Allocate a page for receiving the packet data
        if ((r = sys_page_alloc(0,(void *)((uintptr_t)packet), PTE_P|PTE_U|PTE_W)) < 0)
  8003aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ae:	ba 07 00 00 00       	mov    $0x7,%edx
  8003b3:	48 89 c6             	mov    %rax,%rsi
  8003b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8003bb:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax
  8003c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003ce:	79 30                	jns    800400 <input+0x94>
        	panic("panic in input environment:sys_page_alloc: %e\n", r);
  8003d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003d3:	89 c1                	mov    %eax,%ecx
  8003d5:	48 ba c0 49 80 00 00 	movabs $0x8049c0,%rdx
  8003dc:	00 00 00 
  8003df:	be 19 00 00 00       	mov    $0x19,%esi
  8003e4:	48 bf ef 49 80 00 00 	movabs $0x8049ef,%rdi
  8003eb:	00 00 00 
  8003ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f3:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  8003fa:	00 00 00 
  8003fd:	41 ff d0             	callq  *%r8
        while(1)
        {
		//Receive the packet from the device driver into the page allocated
		addr = (uintptr_t)packet + sizeof(packet->jp_len);
  800400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800404:	48 83 c0 04          	add    $0x4,%rax
  800408:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		len = (size_t)(PGSIZE - sizeof(packet->jp_len));
  80040c:	48 c7 45 d8 fc 0f 00 	movq   $0xffc,-0x28(%rbp)
  800413:	00 
		while((recvBuffLen = sys_receive_packet((void *)addr,len)) < 0)
  800414:	eb 0c                	jmp    800422 <input+0xb6>
                	sys_yield();
  800416:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  80041d:	00 00 00 
  800420:	ff d0                	callq  *%rax
        while(1)
        {
		//Receive the packet from the device driver into the page allocated
		addr = (uintptr_t)packet + sizeof(packet->jp_len);
		len = (size_t)(PGSIZE - sizeof(packet->jp_len));
		while((recvBuffLen = sys_receive_packet((void *)addr,len)) < 0)
  800422:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800426:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80042a:	48 89 d6             	mov    %rdx,%rsi
  80042d:	48 89 c7             	mov    %rax,%rdi
  800430:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  800437:	00 00 00 
  80043a:	ff d0                	callq  *%rax
  80043c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80043f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800443:	78 d1                	js     800416 <input+0xaa>
                	sys_yield();
                packet->jp_len = recvBuffLen;
  800445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800449:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80044c:	89 10                	mov    %edx,(%rax)
		//Send the NSREQ_INPUT IPC message to ns with packet in page
                ipc_send(ns_envid, reqType, packet, PTE_P|PTE_U);
  80044e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800452:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800455:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800458:	b9 05 00 00 00       	mov    $0x5,%ecx
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
                sys_yield();
  80046b:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  800472:	00 00 00 
  800475:	ff d0                	callq  *%rax
        }
  800477:	eb 87                	jmp    800400 <input+0x94>
  800479:	00 00                	add    %al,(%rax)
	...

000000000080047c <output>:
#include "ns.h"
extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  80047c:	55                   	push   %rbp
  80047d:	48 89 e5             	mov    %rsp,%rbp
  800480:	48 83 ec 20          	sub    $0x20,%rsp
  800484:	89 7d ec             	mov    %edi,-0x14(%rbp)
	binaryname = "ns_output";
  800487:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80048e:	00 00 00 
  800491:	48 ba 00 4a 80 00 00 	movabs $0x804a00,%rdx
  800498:	00 00 00 
  80049b:	48 89 10             	mov    %rdx,(%rax)
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
	while(1)
	{
		perm = 0;
  80049e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
		//Read a packet from ns
		reqType = ipc_recv(&envid_sender, &nsipcbuf, &perm);
  8004a5:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
  8004a9:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  8004ad:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8004b4:	00 00 00 
  8004b7:	48 89 c7             	mov    %rax,%rdi
  8004ba:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
  8004c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		//Check if ipc_recv has received correctly
		if(!(perm & PTE_P))
  8004c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004cc:	83 e0 01             	and    $0x1,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	75 22                	jne    8004f5 <output+0x79>
		{
			cprintf("Invalid request from network server[%08x]:no page",envid_sender);
  8004d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004d6:	89 c6                	mov    %eax,%esi
  8004d8:	48 bf 10 4a 80 00 00 	movabs $0x804a10,%rdi
  8004df:	00 00 00 
  8004e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e7:	48 ba 67 08 80 00 00 	movabs $0x800867,%rdx
  8004ee:	00 00 00 
  8004f1:	ff d2                	callq  *%rdx
			continue; 
  8004f3:	eb 67                	jmp    80055c <output+0xe0>
		}
		if(reqType != NSREQ_OUTPUT)
  8004f5:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
  8004f9:	74 30                	je     80052b <output+0xaf>
		{
			cprintf("Invalid request from network server[%08x]:not a NSREQ_OUTPUT message",envid_sender);
  8004fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004fe:	89 c6                	mov    %eax,%esi
  800500:	48 bf 48 4a 80 00 00 	movabs $0x804a48,%rdi
  800507:	00 00 00 
  80050a:	b8 00 00 00 00       	mov    $0x0,%eax
  80050f:	48 ba 67 08 80 00 00 	movabs $0x800867,%rdx
  800516:	00 00 00 
  800519:	ff d2                	callq  *%rdx
			continue;
  80051b:	eb 3f                	jmp    80055c <output+0xe0>
		}
		//Send packet to device driver.If packet send fails, give up CPU
		while(sys_send_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len) < 0)
			sys_yield();
  80051d:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  800524:	00 00 00 
  800527:	ff d0                	callq  *%rax
  800529:	eb 01                	jmp    80052c <output+0xb0>
		{
			cprintf("Invalid request from network server[%08x]:not a NSREQ_OUTPUT message",envid_sender);
			continue;
		}
		//Send packet to device driver.If packet send fails, give up CPU
		while(sys_send_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len) < 0)
  80052b:	90                   	nop
  80052c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  800533:	00 00 00 
  800536:	8b 00                	mov    (%rax),%eax
  800538:	48 98                	cltq   
  80053a:	48 89 c6             	mov    %rax,%rsi
  80053d:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  800544:	00 00 00 
  800547:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  80054e:	00 00 00 
  800551:	ff d0                	callq  *%rax
  800553:	85 c0                	test   %eax,%eax
  800555:	78 c6                	js     80051d <output+0xa1>
			sys_yield();
	}
  800557:	e9 42 ff ff ff       	jmpq   80049e <output+0x22>
  80055c:	e9 3d ff ff ff       	jmpq   80049e <output+0x22>
  800561:	00 00                	add    %al,(%rax)
	...

0000000000800564 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800564:	55                   	push   %rbp
  800565:	48 89 e5             	mov    %rsp,%rbp
  800568:	48 83 ec 10          	sub    $0x10,%rsp
  80056c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80056f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800573:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  80057a:	00 00 00 
  80057d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800584:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  80058b:	00 00 00 
  80058e:	ff d0                	callq  *%rax
  800590:	48 98                	cltq   
  800592:	48 89 c2             	mov    %rax,%rdx
  800595:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80059b:	48 89 d0             	mov    %rdx,%rax
  80059e:	48 c1 e0 03          	shl    $0x3,%rax
  8005a2:	48 01 d0             	add    %rdx,%rax
  8005a5:	48 c1 e0 05          	shl    $0x5,%rax
  8005a9:	48 89 c2             	mov    %rax,%rdx
  8005ac:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8005b3:	00 00 00 
  8005b6:	48 01 c2             	add    %rax,%rdx
  8005b9:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8005c0:	00 00 00 
  8005c3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005ca:	7e 14                	jle    8005e0 <libmain+0x7c>
		binaryname = argv[0];
  8005cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005d0:	48 8b 10             	mov    (%rax),%rdx
  8005d3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8005da:	00 00 00 
  8005dd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e7:	48 89 d6             	mov    %rdx,%rsi
  8005ea:	89 c7                	mov    %eax,%edi
  8005ec:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8005f3:	00 00 00 
  8005f6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8005f8:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  8005ff:	00 00 00 
  800602:	ff d0                	callq  *%rax
}
  800604:	c9                   	leaveq 
  800605:	c3                   	retq   
	...

0000000000800608 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800608:	55                   	push   %rbp
  800609:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80060c:	48 b8 a9 2c 80 00 00 	movabs $0x802ca9,%rax
  800613:	00 00 00 
  800616:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800618:	bf 00 00 00 00       	mov    $0x0,%edi
  80061d:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  800624:	00 00 00 
  800627:	ff d0                	callq  *%rax
}
  800629:	5d                   	pop    %rbp
  80062a:	c3                   	retq   
	...

000000000080062c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80062c:	55                   	push   %rbp
  80062d:	48 89 e5             	mov    %rsp,%rbp
  800630:	53                   	push   %rbx
  800631:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800638:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80063f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800645:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80064c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800653:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80065a:	84 c0                	test   %al,%al
  80065c:	74 23                	je     800681 <_panic+0x55>
  80065e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800665:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800669:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80066d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800671:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800675:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800679:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80067d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800681:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800688:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80068f:	00 00 00 
  800692:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800699:	00 00 00 
  80069c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006a0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8006a7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8006ae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8006bc:	00 00 00 
  8006bf:	48 8b 18             	mov    (%rax),%rbx
  8006c2:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  8006c9:	00 00 00 
  8006cc:	ff d0                	callq  *%rax
  8006ce:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8006d4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8006db:	41 89 c8             	mov    %ecx,%r8d
  8006de:	48 89 d1             	mov    %rdx,%rcx
  8006e1:	48 89 da             	mov    %rbx,%rdx
  8006e4:	89 c6                	mov    %eax,%esi
  8006e6:	48 bf 98 4a 80 00 00 	movabs $0x804a98,%rdi
  8006ed:	00 00 00 
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	49 b9 67 08 80 00 00 	movabs $0x800867,%r9
  8006fc:	00 00 00 
  8006ff:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800702:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800709:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800710:	48 89 d6             	mov    %rdx,%rsi
  800713:	48 89 c7             	mov    %rax,%rdi
  800716:	48 b8 bb 07 80 00 00 	movabs $0x8007bb,%rax
  80071d:	00 00 00 
  800720:	ff d0                	callq  *%rax
	cprintf("\n");
  800722:	48 bf bb 4a 80 00 00 	movabs $0x804abb,%rdi
  800729:	00 00 00 
  80072c:	b8 00 00 00 00       	mov    $0x0,%eax
  800731:	48 ba 67 08 80 00 00 	movabs $0x800867,%rdx
  800738:	00 00 00 
  80073b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80073d:	cc                   	int3   
  80073e:	eb fd                	jmp    80073d <_panic+0x111>

0000000000800740 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800740:	55                   	push   %rbp
  800741:	48 89 e5             	mov    %rsp,%rbp
  800744:	48 83 ec 10          	sub    $0x10,%rsp
  800748:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80074b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80074f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800753:	8b 00                	mov    (%rax),%eax
  800755:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800758:	89 d6                	mov    %edx,%esi
  80075a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80075e:	48 63 d0             	movslq %eax,%rdx
  800761:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800766:	8d 50 01             	lea    0x1(%rax),%edx
  800769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80076d:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80076f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800773:	8b 00                	mov    (%rax),%eax
  800775:	3d ff 00 00 00       	cmp    $0xff,%eax
  80077a:	75 2c                	jne    8007a8 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  80077c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800780:	8b 00                	mov    (%rax),%eax
  800782:	48 98                	cltq   
  800784:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800788:	48 83 c2 08          	add    $0x8,%rdx
  80078c:	48 89 c6             	mov    %rax,%rsi
  80078f:	48 89 d7             	mov    %rdx,%rdi
  800792:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  800799:	00 00 00 
  80079c:	ff d0                	callq  *%rax
		b->idx = 0;
  80079e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8007a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007ac:	8b 40 04             	mov    0x4(%rax),%eax
  8007af:	8d 50 01             	lea    0x1(%rax),%edx
  8007b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007b6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8007b9:	c9                   	leaveq 
  8007ba:	c3                   	retq   

00000000008007bb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8007bb:	55                   	push   %rbp
  8007bc:	48 89 e5             	mov    %rsp,%rbp
  8007bf:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8007c6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8007cd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8007d4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8007db:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007e2:	48 8b 0a             	mov    (%rdx),%rcx
  8007e5:	48 89 08             	mov    %rcx,(%rax)
  8007e8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ec:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007f0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8007f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007ff:	00 00 00 
	b.cnt = 0;
  800802:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800809:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80080c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800813:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80081a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800821:	48 89 c6             	mov    %rax,%rsi
  800824:	48 bf 40 07 80 00 00 	movabs $0x800740,%rdi
  80082b:	00 00 00 
  80082e:	48 b8 18 0c 80 00 00 	movabs $0x800c18,%rax
  800835:	00 00 00 
  800838:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80083a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800840:	48 98                	cltq   
  800842:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800849:	48 83 c2 08          	add    $0x8,%rdx
  80084d:	48 89 c6             	mov    %rax,%rsi
  800850:	48 89 d7             	mov    %rdx,%rdi
  800853:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  80085a:	00 00 00 
  80085d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80085f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800865:	c9                   	leaveq 
  800866:	c3                   	retq   

0000000000800867 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800867:	55                   	push   %rbp
  800868:	48 89 e5             	mov    %rsp,%rbp
  80086b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800872:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800879:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800880:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800887:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80088e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800895:	84 c0                	test   %al,%al
  800897:	74 20                	je     8008b9 <cprintf+0x52>
  800899:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80089d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8008a1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8008a5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8008a9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8008ad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8008b1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8008b5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8008b9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8008c0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8008c7:	00 00 00 
  8008ca:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8008d1:	00 00 00 
  8008d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8008d8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8008df:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8008e6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8008ed:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008f4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008fb:	48 8b 0a             	mov    (%rdx),%rcx
  8008fe:	48 89 08             	mov    %rcx,(%rax)
  800901:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800905:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800909:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80090d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800911:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800918:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80091f:	48 89 d6             	mov    %rdx,%rsi
  800922:	48 89 c7             	mov    %rax,%rdi
  800925:	48 b8 bb 07 80 00 00 	movabs $0x8007bb,%rax
  80092c:	00 00 00 
  80092f:	ff d0                	callq  *%rax
  800931:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800937:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80093d:	c9                   	leaveq 
  80093e:	c3                   	retq   
	...

0000000000800940 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800940:	55                   	push   %rbp
  800941:	48 89 e5             	mov    %rsp,%rbp
  800944:	48 83 ec 30          	sub    $0x30,%rsp
  800948:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80094c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800950:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800954:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800957:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80095b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80095f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800962:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800966:	77 52                	ja     8009ba <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800968:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80096b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80096f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800972:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800976:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097a:	ba 00 00 00 00       	mov    $0x0,%edx
  80097f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800983:	48 89 c2             	mov    %rax,%rdx
  800986:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800989:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80098c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800994:	41 89 f9             	mov    %edi,%r9d
  800997:	48 89 c7             	mov    %rax,%rdi
  80099a:	48 b8 40 09 80 00 00 	movabs $0x800940,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	eb 1c                	jmp    8009c4 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009af:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8009b3:	48 89 d6             	mov    %rdx,%rsi
  8009b6:	89 c7                	mov    %eax,%edi
  8009b8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009ba:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8009be:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8009c2:	7f e4                	jg     8009a8 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009c4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8009c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d0:	48 f7 f1             	div    %rcx
  8009d3:	48 89 d0             	mov    %rdx,%rax
  8009d6:	48 ba 88 4c 80 00 00 	movabs $0x804c88,%rdx
  8009dd:	00 00 00 
  8009e0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8009e4:	0f be c0             	movsbl %al,%eax
  8009e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009eb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8009ef:	48 89 d6             	mov    %rdx,%rsi
  8009f2:	89 c7                	mov    %eax,%edi
  8009f4:	ff d1                	callq  *%rcx
}
  8009f6:	c9                   	leaveq 
  8009f7:	c3                   	retq   

00000000008009f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009f8:	55                   	push   %rbp
  8009f9:	48 89 e5             	mov    %rsp,%rbp
  8009fc:	48 83 ec 20          	sub    $0x20,%rsp
  800a00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a04:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800a07:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a0b:	7e 52                	jle    800a5f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	8b 00                	mov    (%rax),%eax
  800a13:	83 f8 30             	cmp    $0x30,%eax
  800a16:	73 24                	jae    800a3c <getuint+0x44>
  800a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a24:	8b 00                	mov    (%rax),%eax
  800a26:	89 c0                	mov    %eax,%eax
  800a28:	48 01 d0             	add    %rdx,%rax
  800a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2f:	8b 12                	mov    (%rdx),%edx
  800a31:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a38:	89 0a                	mov    %ecx,(%rdx)
  800a3a:	eb 17                	jmp    800a53 <getuint+0x5b>
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a44:	48 89 d0             	mov    %rdx,%rax
  800a47:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a53:	48 8b 00             	mov    (%rax),%rax
  800a56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5a:	e9 a3 00 00 00       	jmpq   800b02 <getuint+0x10a>
	else if (lflag)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a63:	74 4f                	je     800ab4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a69:	8b 00                	mov    (%rax),%eax
  800a6b:	83 f8 30             	cmp    $0x30,%eax
  800a6e:	73 24                	jae    800a94 <getuint+0x9c>
  800a70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a74:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	8b 00                	mov    (%rax),%eax
  800a7e:	89 c0                	mov    %eax,%eax
  800a80:	48 01 d0             	add    %rdx,%rax
  800a83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a87:	8b 12                	mov    (%rdx),%edx
  800a89:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a90:	89 0a                	mov    %ecx,(%rdx)
  800a92:	eb 17                	jmp    800aab <getuint+0xb3>
  800a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a98:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a9c:	48 89 d0             	mov    %rdx,%rax
  800a9f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aab:	48 8b 00             	mov    (%rax),%rax
  800aae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ab2:	eb 4e                	jmp    800b02 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	8b 00                	mov    (%rax),%eax
  800aba:	83 f8 30             	cmp    $0x30,%eax
  800abd:	73 24                	jae    800ae3 <getuint+0xeb>
  800abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acb:	8b 00                	mov    (%rax),%eax
  800acd:	89 c0                	mov    %eax,%eax
  800acf:	48 01 d0             	add    %rdx,%rax
  800ad2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad6:	8b 12                	mov    (%rdx),%edx
  800ad8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adf:	89 0a                	mov    %ecx,(%rdx)
  800ae1:	eb 17                	jmp    800afa <getuint+0x102>
  800ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aeb:	48 89 d0             	mov    %rdx,%rax
  800aee:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800afa:	8b 00                	mov    (%rax),%eax
  800afc:	89 c0                	mov    %eax,%eax
  800afe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b06:	c9                   	leaveq 
  800b07:	c3                   	retq   

0000000000800b08 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b08:	55                   	push   %rbp
  800b09:	48 89 e5             	mov    %rsp,%rbp
  800b0c:	48 83 ec 20          	sub    $0x20,%rsp
  800b10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b14:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800b17:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b1b:	7e 52                	jle    800b6f <getint+0x67>
		x=va_arg(*ap, long long);
  800b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b21:	8b 00                	mov    (%rax),%eax
  800b23:	83 f8 30             	cmp    $0x30,%eax
  800b26:	73 24                	jae    800b4c <getint+0x44>
  800b28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b34:	8b 00                	mov    (%rax),%eax
  800b36:	89 c0                	mov    %eax,%eax
  800b38:	48 01 d0             	add    %rdx,%rax
  800b3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3f:	8b 12                	mov    (%rdx),%edx
  800b41:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b48:	89 0a                	mov    %ecx,(%rdx)
  800b4a:	eb 17                	jmp    800b63 <getint+0x5b>
  800b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b50:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b54:	48 89 d0             	mov    %rdx,%rax
  800b57:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b63:	48 8b 00             	mov    (%rax),%rax
  800b66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b6a:	e9 a3 00 00 00       	jmpq   800c12 <getint+0x10a>
	else if (lflag)
  800b6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b73:	74 4f                	je     800bc4 <getint+0xbc>
		x=va_arg(*ap, long);
  800b75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b79:	8b 00                	mov    (%rax),%eax
  800b7b:	83 f8 30             	cmp    $0x30,%eax
  800b7e:	73 24                	jae    800ba4 <getint+0x9c>
  800b80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b84:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8c:	8b 00                	mov    (%rax),%eax
  800b8e:	89 c0                	mov    %eax,%eax
  800b90:	48 01 d0             	add    %rdx,%rax
  800b93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b97:	8b 12                	mov    (%rdx),%edx
  800b99:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba0:	89 0a                	mov    %ecx,(%rdx)
  800ba2:	eb 17                	jmp    800bbb <getint+0xb3>
  800ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bac:	48 89 d0             	mov    %rdx,%rax
  800baf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bb3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bbb:	48 8b 00             	mov    (%rax),%rax
  800bbe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bc2:	eb 4e                	jmp    800c12 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc8:	8b 00                	mov    (%rax),%eax
  800bca:	83 f8 30             	cmp    $0x30,%eax
  800bcd:	73 24                	jae    800bf3 <getint+0xeb>
  800bcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdb:	8b 00                	mov    (%rax),%eax
  800bdd:	89 c0                	mov    %eax,%eax
  800bdf:	48 01 d0             	add    %rdx,%rax
  800be2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800be6:	8b 12                	mov    (%rdx),%edx
  800be8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800beb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bef:	89 0a                	mov    %ecx,(%rdx)
  800bf1:	eb 17                	jmp    800c0a <getint+0x102>
  800bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bfb:	48 89 d0             	mov    %rdx,%rax
  800bfe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c06:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c0a:	8b 00                	mov    (%rax),%eax
  800c0c:	48 98                	cltq   
  800c0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c16:	c9                   	leaveq 
  800c17:	c3                   	retq   

0000000000800c18 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c18:	55                   	push   %rbp
  800c19:	48 89 e5             	mov    %rsp,%rbp
  800c1c:	41 54                	push   %r12
  800c1e:	53                   	push   %rbx
  800c1f:	48 83 ec 60          	sub    $0x60,%rsp
  800c23:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800c27:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800c2b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c2f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800c33:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c37:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c3b:	48 8b 0a             	mov    (%rdx),%rcx
  800c3e:	48 89 08             	mov    %rcx,(%rax)
  800c41:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c45:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c49:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c4d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c51:	eb 17                	jmp    800c6a <vprintfmt+0x52>
			if (ch == '\0')
  800c53:	85 db                	test   %ebx,%ebx
  800c55:	0f 84 d7 04 00 00    	je     801132 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800c5b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c5f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c63:	48 89 c6             	mov    %rax,%rsi
  800c66:	89 df                	mov    %ebx,%edi
  800c68:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c6e:	0f b6 00             	movzbl (%rax),%eax
  800c71:	0f b6 d8             	movzbl %al,%ebx
  800c74:	83 fb 25             	cmp    $0x25,%ebx
  800c77:	0f 95 c0             	setne  %al
  800c7a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c7f:	84 c0                	test   %al,%al
  800c81:	75 d0                	jne    800c53 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c83:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c87:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c8e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c9c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800ca3:	eb 04                	jmp    800ca9 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800ca5:	90                   	nop
  800ca6:	eb 01                	jmp    800ca9 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800ca8:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ca9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cad:	0f b6 00             	movzbl (%rax),%eax
  800cb0:	0f b6 d8             	movzbl %al,%ebx
  800cb3:	89 d8                	mov    %ebx,%eax
  800cb5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800cba:	83 e8 23             	sub    $0x23,%eax
  800cbd:	83 f8 55             	cmp    $0x55,%eax
  800cc0:	0f 87 38 04 00 00    	ja     8010fe <vprintfmt+0x4e6>
  800cc6:	89 c0                	mov    %eax,%eax
  800cc8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ccf:	00 
  800cd0:	48 b8 b0 4c 80 00 00 	movabs $0x804cb0,%rax
  800cd7:	00 00 00 
  800cda:	48 01 d0             	add    %rdx,%rax
  800cdd:	48 8b 00             	mov    (%rax),%rax
  800ce0:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ce2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ce6:	eb c1                	jmp    800ca9 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ce8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800cec:	eb bb                	jmp    800ca9 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cee:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cf5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cf8:	89 d0                	mov    %edx,%eax
  800cfa:	c1 e0 02             	shl    $0x2,%eax
  800cfd:	01 d0                	add    %edx,%eax
  800cff:	01 c0                	add    %eax,%eax
  800d01:	01 d8                	add    %ebx,%eax
  800d03:	83 e8 30             	sub    $0x30,%eax
  800d06:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800d09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d0d:	0f b6 00             	movzbl (%rax),%eax
  800d10:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d13:	83 fb 2f             	cmp    $0x2f,%ebx
  800d16:	7e 63                	jle    800d7b <vprintfmt+0x163>
  800d18:	83 fb 39             	cmp    $0x39,%ebx
  800d1b:	7f 5e                	jg     800d7b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d1d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d22:	eb d1                	jmp    800cf5 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800d24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d27:	83 f8 30             	cmp    $0x30,%eax
  800d2a:	73 17                	jae    800d43 <vprintfmt+0x12b>
  800d2c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d33:	89 c0                	mov    %eax,%eax
  800d35:	48 01 d0             	add    %rdx,%rax
  800d38:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d3b:	83 c2 08             	add    $0x8,%edx
  800d3e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d41:	eb 0f                	jmp    800d52 <vprintfmt+0x13a>
  800d43:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d47:	48 89 d0             	mov    %rdx,%rax
  800d4a:	48 83 c2 08          	add    $0x8,%rdx
  800d4e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d52:	8b 00                	mov    (%rax),%eax
  800d54:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d57:	eb 23                	jmp    800d7c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800d59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d5d:	0f 89 42 ff ff ff    	jns    800ca5 <vprintfmt+0x8d>
				width = 0;
  800d63:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d6a:	e9 36 ff ff ff       	jmpq   800ca5 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800d6f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d76:	e9 2e ff ff ff       	jmpq   800ca9 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d7b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d80:	0f 89 22 ff ff ff    	jns    800ca8 <vprintfmt+0x90>
				width = precision, precision = -1;
  800d86:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d89:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d8c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d93:	e9 10 ff ff ff       	jmpq   800ca8 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d98:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d9c:	e9 08 ff ff ff       	jmpq   800ca9 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800da1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da4:	83 f8 30             	cmp    $0x30,%eax
  800da7:	73 17                	jae    800dc0 <vprintfmt+0x1a8>
  800da9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db0:	89 c0                	mov    %eax,%eax
  800db2:	48 01 d0             	add    %rdx,%rax
  800db5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800db8:	83 c2 08             	add    $0x8,%edx
  800dbb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dbe:	eb 0f                	jmp    800dcf <vprintfmt+0x1b7>
  800dc0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc4:	48 89 d0             	mov    %rdx,%rax
  800dc7:	48 83 c2 08          	add    $0x8,%rdx
  800dcb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dcf:	8b 00                	mov    (%rax),%eax
  800dd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd5:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800dd9:	48 89 d6             	mov    %rdx,%rsi
  800ddc:	89 c7                	mov    %eax,%edi
  800dde:	ff d1                	callq  *%rcx
			break;
  800de0:	e9 47 03 00 00       	jmpq   80112c <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800de5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800de8:	83 f8 30             	cmp    $0x30,%eax
  800deb:	73 17                	jae    800e04 <vprintfmt+0x1ec>
  800ded:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800df1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800df4:	89 c0                	mov    %eax,%eax
  800df6:	48 01 d0             	add    %rdx,%rax
  800df9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dfc:	83 c2 08             	add    $0x8,%edx
  800dff:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e02:	eb 0f                	jmp    800e13 <vprintfmt+0x1fb>
  800e04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e08:	48 89 d0             	mov    %rdx,%rax
  800e0b:	48 83 c2 08          	add    $0x8,%rdx
  800e0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e13:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800e15:	85 db                	test   %ebx,%ebx
  800e17:	79 02                	jns    800e1b <vprintfmt+0x203>
				err = -err;
  800e19:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e1b:	83 fb 10             	cmp    $0x10,%ebx
  800e1e:	7f 16                	jg     800e36 <vprintfmt+0x21e>
  800e20:	48 b8 00 4c 80 00 00 	movabs $0x804c00,%rax
  800e27:	00 00 00 
  800e2a:	48 63 d3             	movslq %ebx,%rdx
  800e2d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e31:	4d 85 e4             	test   %r12,%r12
  800e34:	75 2e                	jne    800e64 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800e36:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3e:	89 d9                	mov    %ebx,%ecx
  800e40:	48 ba 99 4c 80 00 00 	movabs $0x804c99,%rdx
  800e47:	00 00 00 
  800e4a:	48 89 c7             	mov    %rax,%rdi
  800e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e52:	49 b8 3c 11 80 00 00 	movabs $0x80113c,%r8
  800e59:	00 00 00 
  800e5c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e5f:	e9 c8 02 00 00       	jmpq   80112c <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e64:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6c:	4c 89 e1             	mov    %r12,%rcx
  800e6f:	48 ba a2 4c 80 00 00 	movabs $0x804ca2,%rdx
  800e76:	00 00 00 
  800e79:	48 89 c7             	mov    %rax,%rdi
  800e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e81:	49 b8 3c 11 80 00 00 	movabs $0x80113c,%r8
  800e88:	00 00 00 
  800e8b:	41 ff d0             	callq  *%r8
			break;
  800e8e:	e9 99 02 00 00       	jmpq   80112c <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e96:	83 f8 30             	cmp    $0x30,%eax
  800e99:	73 17                	jae    800eb2 <vprintfmt+0x29a>
  800e9b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ea2:	89 c0                	mov    %eax,%eax
  800ea4:	48 01 d0             	add    %rdx,%rax
  800ea7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eaa:	83 c2 08             	add    $0x8,%edx
  800ead:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800eb0:	eb 0f                	jmp    800ec1 <vprintfmt+0x2a9>
  800eb2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800eb6:	48 89 d0             	mov    %rdx,%rax
  800eb9:	48 83 c2 08          	add    $0x8,%rdx
  800ebd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ec1:	4c 8b 20             	mov    (%rax),%r12
  800ec4:	4d 85 e4             	test   %r12,%r12
  800ec7:	75 0a                	jne    800ed3 <vprintfmt+0x2bb>
				p = "(null)";
  800ec9:	49 bc a5 4c 80 00 00 	movabs $0x804ca5,%r12
  800ed0:	00 00 00 
			if (width > 0 && padc != '-')
  800ed3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ed7:	7e 7a                	jle    800f53 <vprintfmt+0x33b>
  800ed9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800edd:	74 74                	je     800f53 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ee2:	48 98                	cltq   
  800ee4:	48 89 c6             	mov    %rax,%rsi
  800ee7:	4c 89 e7             	mov    %r12,%rdi
  800eea:	48 b8 e6 13 80 00 00 	movabs $0x8013e6,%rax
  800ef1:	00 00 00 
  800ef4:	ff d0                	callq  *%rax
  800ef6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ef9:	eb 17                	jmp    800f12 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800efb:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800eff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f03:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800f07:	48 89 d6             	mov    %rdx,%rsi
  800f0a:	89 c7                	mov    %eax,%edi
  800f0c:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f0e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f12:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f16:	7f e3                	jg     800efb <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f18:	eb 39                	jmp    800f53 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800f1a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800f1e:	74 1e                	je     800f3e <vprintfmt+0x326>
  800f20:	83 fb 1f             	cmp    $0x1f,%ebx
  800f23:	7e 05                	jle    800f2a <vprintfmt+0x312>
  800f25:	83 fb 7e             	cmp    $0x7e,%ebx
  800f28:	7e 14                	jle    800f3e <vprintfmt+0x326>
					putch('?', putdat);
  800f2a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f2e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f32:	48 89 c6             	mov    %rax,%rsi
  800f35:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f3a:	ff d2                	callq  *%rdx
  800f3c:	eb 0f                	jmp    800f4d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800f3e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f42:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f46:	48 89 c6             	mov    %rax,%rsi
  800f49:	89 df                	mov    %ebx,%edi
  800f4b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f51:	eb 01                	jmp    800f54 <vprintfmt+0x33c>
  800f53:	90                   	nop
  800f54:	41 0f b6 04 24       	movzbl (%r12),%eax
  800f59:	0f be d8             	movsbl %al,%ebx
  800f5c:	85 db                	test   %ebx,%ebx
  800f5e:	0f 95 c0             	setne  %al
  800f61:	49 83 c4 01          	add    $0x1,%r12
  800f65:	84 c0                	test   %al,%al
  800f67:	74 28                	je     800f91 <vprintfmt+0x379>
  800f69:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f6d:	78 ab                	js     800f1a <vprintfmt+0x302>
  800f6f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f73:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f77:	79 a1                	jns    800f1a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f79:	eb 16                	jmp    800f91 <vprintfmt+0x379>
				putch(' ', putdat);
  800f7b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f7f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f83:	48 89 c6             	mov    %rax,%rsi
  800f86:	bf 20 00 00 00       	mov    $0x20,%edi
  800f8b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f8d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f91:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f95:	7f e4                	jg     800f7b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800f97:	e9 90 01 00 00       	jmpq   80112c <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f9c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fa0:	be 03 00 00 00       	mov    $0x3,%esi
  800fa5:	48 89 c7             	mov    %rax,%rdi
  800fa8:	48 b8 08 0b 80 00 00 	movabs $0x800b08,%rax
  800faf:	00 00 00 
  800fb2:	ff d0                	callq  *%rax
  800fb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fbc:	48 85 c0             	test   %rax,%rax
  800fbf:	79 1d                	jns    800fde <vprintfmt+0x3c6>
				putch('-', putdat);
  800fc1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fc5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fc9:	48 89 c6             	mov    %rax,%rsi
  800fcc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fd1:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd7:	48 f7 d8             	neg    %rax
  800fda:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800fde:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fe5:	e9 d5 00 00 00       	jmpq   8010bf <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fea:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fee:	be 03 00 00 00       	mov    $0x3,%esi
  800ff3:	48 89 c7             	mov    %rax,%rdi
  800ff6:	48 b8 f8 09 80 00 00 	movabs $0x8009f8,%rax
  800ffd:	00 00 00 
  801000:	ff d0                	callq  *%rax
  801002:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801006:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80100d:	e9 ad 00 00 00       	jmpq   8010bf <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  801012:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801016:	be 03 00 00 00       	mov    $0x3,%esi
  80101b:	48 89 c7             	mov    %rax,%rdi
  80101e:	48 b8 f8 09 80 00 00 	movabs $0x8009f8,%rax
  801025:	00 00 00 
  801028:	ff d0                	callq  *%rax
  80102a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  80102e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801035:	e9 85 00 00 00       	jmpq   8010bf <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  80103a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80103e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801042:	48 89 c6             	mov    %rax,%rsi
  801045:	bf 30 00 00 00       	mov    $0x30,%edi
  80104a:	ff d2                	callq  *%rdx
			putch('x', putdat);
  80104c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801050:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801054:	48 89 c6             	mov    %rax,%rsi
  801057:	bf 78 00 00 00       	mov    $0x78,%edi
  80105c:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80105e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801061:	83 f8 30             	cmp    $0x30,%eax
  801064:	73 17                	jae    80107d <vprintfmt+0x465>
  801066:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80106a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80106d:	89 c0                	mov    %eax,%eax
  80106f:	48 01 d0             	add    %rdx,%rax
  801072:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801075:	83 c2 08             	add    $0x8,%edx
  801078:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80107b:	eb 0f                	jmp    80108c <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  80107d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801081:	48 89 d0             	mov    %rdx,%rax
  801084:	48 83 c2 08          	add    $0x8,%rdx
  801088:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80108c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80108f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801093:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80109a:	eb 23                	jmp    8010bf <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80109c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010a0:	be 03 00 00 00       	mov    $0x3,%esi
  8010a5:	48 89 c7             	mov    %rax,%rdi
  8010a8:	48 b8 f8 09 80 00 00 	movabs $0x8009f8,%rax
  8010af:	00 00 00 
  8010b2:	ff d0                	callq  *%rax
  8010b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8010b8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010bf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8010c4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010c7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ce:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d6:	45 89 c1             	mov    %r8d,%r9d
  8010d9:	41 89 f8             	mov    %edi,%r8d
  8010dc:	48 89 c7             	mov    %rax,%rdi
  8010df:	48 b8 40 09 80 00 00 	movabs $0x800940,%rax
  8010e6:	00 00 00 
  8010e9:	ff d0                	callq  *%rax
			break;
  8010eb:	eb 3f                	jmp    80112c <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ed:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010f1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010f5:	48 89 c6             	mov    %rax,%rsi
  8010f8:	89 df                	mov    %ebx,%edi
  8010fa:	ff d2                	callq  *%rdx
			break;
  8010fc:	eb 2e                	jmp    80112c <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801102:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801106:	48 89 c6             	mov    %rax,%rsi
  801109:	bf 25 00 00 00       	mov    $0x25,%edi
  80110e:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801110:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801115:	eb 05                	jmp    80111c <vprintfmt+0x504>
  801117:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80111c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801120:	48 83 e8 01          	sub    $0x1,%rax
  801124:	0f b6 00             	movzbl (%rax),%eax
  801127:	3c 25                	cmp    $0x25,%al
  801129:	75 ec                	jne    801117 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  80112b:	90                   	nop
		}
	}
  80112c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80112d:	e9 38 fb ff ff       	jmpq   800c6a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801132:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  801133:	48 83 c4 60          	add    $0x60,%rsp
  801137:	5b                   	pop    %rbx
  801138:	41 5c                	pop    %r12
  80113a:	5d                   	pop    %rbp
  80113b:	c3                   	retq   

000000000080113c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80113c:	55                   	push   %rbp
  80113d:	48 89 e5             	mov    %rsp,%rbp
  801140:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801147:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80114e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801155:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80115c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801163:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80116a:	84 c0                	test   %al,%al
  80116c:	74 20                	je     80118e <printfmt+0x52>
  80116e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801172:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801176:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80117a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80117e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801182:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801186:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80118a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80118e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801195:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80119c:	00 00 00 
  80119f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8011a6:	00 00 00 
  8011a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011ad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8011b4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011bb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011c2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011c9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011d0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011d7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011de:	48 89 c7             	mov    %rax,%rdi
  8011e1:	48 b8 18 0c 80 00 00 	movabs $0x800c18,%rax
  8011e8:	00 00 00 
  8011eb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011ed:	c9                   	leaveq 
  8011ee:	c3                   	retq   

00000000008011ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011ef:	55                   	push   %rbp
  8011f0:	48 89 e5             	mov    %rsp,%rbp
  8011f3:	48 83 ec 10          	sub    $0x10,%rsp
  8011f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801202:	8b 40 10             	mov    0x10(%rax),%eax
  801205:	8d 50 01             	lea    0x1(%rax),%edx
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80120f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801213:	48 8b 10             	mov    (%rax),%rdx
  801216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80121e:	48 39 c2             	cmp    %rax,%rdx
  801221:	73 17                	jae    80123a <sprintputch+0x4b>
		*b->buf++ = ch;
  801223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801227:	48 8b 00             	mov    (%rax),%rax
  80122a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80122d:	88 10                	mov    %dl,(%rax)
  80122f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801237:	48 89 10             	mov    %rdx,(%rax)
}
  80123a:	c9                   	leaveq 
  80123b:	c3                   	retq   

000000000080123c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80123c:	55                   	push   %rbp
  80123d:	48 89 e5             	mov    %rsp,%rbp
  801240:	48 83 ec 50          	sub    $0x50,%rsp
  801244:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801248:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80124b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80124f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801253:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801257:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80125b:	48 8b 0a             	mov    (%rdx),%rcx
  80125e:	48 89 08             	mov    %rcx,(%rax)
  801261:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801265:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801269:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80126d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801271:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801275:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801279:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80127c:	48 98                	cltq   
  80127e:	48 83 e8 01          	sub    $0x1,%rax
  801282:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801286:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80128a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801291:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801296:	74 06                	je     80129e <vsnprintf+0x62>
  801298:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80129c:	7f 07                	jg     8012a5 <vsnprintf+0x69>
		return -E_INVAL;
  80129e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a3:	eb 2f                	jmp    8012d4 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8012a5:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8012a9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8012ad:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8012b1:	48 89 c6             	mov    %rax,%rsi
  8012b4:	48 bf ef 11 80 00 00 	movabs $0x8011ef,%rdi
  8012bb:	00 00 00 
  8012be:	48 b8 18 0c 80 00 00 	movabs $0x800c18,%rax
  8012c5:	00 00 00 
  8012c8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012ce:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012d1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012d4:	c9                   	leaveq 
  8012d5:	c3                   	retq   

00000000008012d6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012d6:	55                   	push   %rbp
  8012d7:	48 89 e5             	mov    %rsp,%rbp
  8012da:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012e1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012e8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012ee:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012f5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012fc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801303:	84 c0                	test   %al,%al
  801305:	74 20                	je     801327 <snprintf+0x51>
  801307:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80130b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80130f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801313:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801317:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80131b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80131f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801323:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801327:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80132e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801335:	00 00 00 
  801338:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80133f:	00 00 00 
  801342:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801346:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80134d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801354:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80135b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801362:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801369:	48 8b 0a             	mov    (%rdx),%rcx
  80136c:	48 89 08             	mov    %rcx,(%rax)
  80136f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801373:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801377:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80137b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80137f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801386:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80138d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801393:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80139a:	48 89 c7             	mov    %rax,%rdi
  80139d:	48 b8 3c 12 80 00 00 	movabs $0x80123c,%rax
  8013a4:	00 00 00 
  8013a7:	ff d0                	callq  *%rax
  8013a9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8013af:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8013b5:	c9                   	leaveq 
  8013b6:	c3                   	retq   
	...

00000000008013b8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013b8:	55                   	push   %rbp
  8013b9:	48 89 e5             	mov    %rsp,%rbp
  8013bc:	48 83 ec 18          	sub    $0x18,%rsp
  8013c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013cb:	eb 09                	jmp    8013d6 <strlen+0x1e>
		n++;
  8013cd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013da:	0f b6 00             	movzbl (%rax),%eax
  8013dd:	84 c0                	test   %al,%al
  8013df:	75 ec                	jne    8013cd <strlen+0x15>
		n++;
	return n;
  8013e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013e4:	c9                   	leaveq 
  8013e5:	c3                   	retq   

00000000008013e6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013e6:	55                   	push   %rbp
  8013e7:	48 89 e5             	mov    %rsp,%rbp
  8013ea:	48 83 ec 20          	sub    $0x20,%rsp
  8013ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013fd:	eb 0e                	jmp    80140d <strnlen+0x27>
		n++;
  8013ff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801403:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801408:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80140d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801412:	74 0b                	je     80141f <strnlen+0x39>
  801414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801418:	0f b6 00             	movzbl (%rax),%eax
  80141b:	84 c0                	test   %al,%al
  80141d:	75 e0                	jne    8013ff <strnlen+0x19>
		n++;
	return n;
  80141f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801422:	c9                   	leaveq 
  801423:	c3                   	retq   

0000000000801424 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801424:	55                   	push   %rbp
  801425:	48 89 e5             	mov    %rsp,%rbp
  801428:	48 83 ec 20          	sub    $0x20,%rsp
  80142c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801430:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801438:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80143c:	90                   	nop
  80143d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801441:	0f b6 10             	movzbl (%rax),%edx
  801444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801448:	88 10                	mov    %dl,(%rax)
  80144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	84 c0                	test   %al,%al
  801453:	0f 95 c0             	setne  %al
  801456:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80145b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801460:	84 c0                	test   %al,%al
  801462:	75 d9                	jne    80143d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801468:	c9                   	leaveq 
  801469:	c3                   	retq   

000000000080146a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80146a:	55                   	push   %rbp
  80146b:	48 89 e5             	mov    %rsp,%rbp
  80146e:	48 83 ec 20          	sub    $0x20,%rsp
  801472:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801476:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	48 89 c7             	mov    %rax,%rdi
  801481:	48 b8 b8 13 80 00 00 	movabs $0x8013b8,%rax
  801488:	00 00 00 
  80148b:	ff d0                	callq  *%rax
  80148d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801493:	48 98                	cltq   
  801495:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801499:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80149d:	48 89 d6             	mov    %rdx,%rsi
  8014a0:	48 89 c7             	mov    %rax,%rdi
  8014a3:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  8014aa:	00 00 00 
  8014ad:	ff d0                	callq  *%rax
	return dst;
  8014af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b3:	c9                   	leaveq 
  8014b4:	c3                   	retq   

00000000008014b5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014b5:	55                   	push   %rbp
  8014b6:	48 89 e5             	mov    %rsp,%rbp
  8014b9:	48 83 ec 28          	sub    $0x28,%rsp
  8014bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014d1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014d8:	00 
  8014d9:	eb 27                	jmp    801502 <strncpy+0x4d>
		*dst++ = *src;
  8014db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014df:	0f b6 10             	movzbl (%rax),%edx
  8014e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e6:	88 10                	mov    %dl,(%rax)
  8014e8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	84 c0                	test   %al,%al
  8014f6:	74 05                	je     8014fd <strncpy+0x48>
			src++;
  8014f8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801506:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80150a:	72 cf                	jb     8014db <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80150c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801510:	c9                   	leaveq 
  801511:	c3                   	retq   

0000000000801512 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801512:	55                   	push   %rbp
  801513:	48 89 e5             	mov    %rsp,%rbp
  801516:	48 83 ec 28          	sub    $0x28,%rsp
  80151a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801522:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80152e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801533:	74 37                	je     80156c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801535:	eb 17                	jmp    80154e <strlcpy+0x3c>
			*dst++ = *src++;
  801537:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80153b:	0f b6 10             	movzbl (%rax),%edx
  80153e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801542:	88 10                	mov    %dl,(%rax)
  801544:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801549:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80154e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801553:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801558:	74 0b                	je     801565 <strlcpy+0x53>
  80155a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80155e:	0f b6 00             	movzbl (%rax),%eax
  801561:	84 c0                	test   %al,%al
  801563:	75 d2                	jne    801537 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801569:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80156c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801574:	48 89 d1             	mov    %rdx,%rcx
  801577:	48 29 c1             	sub    %rax,%rcx
  80157a:	48 89 c8             	mov    %rcx,%rax
}
  80157d:	c9                   	leaveq 
  80157e:	c3                   	retq   

000000000080157f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80157f:	55                   	push   %rbp
  801580:	48 89 e5             	mov    %rsp,%rbp
  801583:	48 83 ec 10          	sub    $0x10,%rsp
  801587:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80158b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80158f:	eb 0a                	jmp    80159b <strcmp+0x1c>
		p++, q++;
  801591:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801596:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80159b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	84 c0                	test   %al,%al
  8015a4:	74 12                	je     8015b8 <strcmp+0x39>
  8015a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015aa:	0f b6 10             	movzbl (%rax),%edx
  8015ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b1:	0f b6 00             	movzbl (%rax),%eax
  8015b4:	38 c2                	cmp    %al,%dl
  8015b6:	74 d9                	je     801591 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bc:	0f b6 00             	movzbl (%rax),%eax
  8015bf:	0f b6 d0             	movzbl %al,%edx
  8015c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	0f b6 c0             	movzbl %al,%eax
  8015cc:	89 d1                	mov    %edx,%ecx
  8015ce:	29 c1                	sub    %eax,%ecx
  8015d0:	89 c8                	mov    %ecx,%eax
}
  8015d2:	c9                   	leaveq 
  8015d3:	c3                   	retq   

00000000008015d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015d4:	55                   	push   %rbp
  8015d5:	48 89 e5             	mov    %rsp,%rbp
  8015d8:	48 83 ec 18          	sub    $0x18,%rsp
  8015dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015e8:	eb 0f                	jmp    8015f9 <strncmp+0x25>
		n--, p++, q++;
  8015ea:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015fe:	74 1d                	je     80161d <strncmp+0x49>
  801600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801604:	0f b6 00             	movzbl (%rax),%eax
  801607:	84 c0                	test   %al,%al
  801609:	74 12                	je     80161d <strncmp+0x49>
  80160b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160f:	0f b6 10             	movzbl (%rax),%edx
  801612:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801616:	0f b6 00             	movzbl (%rax),%eax
  801619:	38 c2                	cmp    %al,%dl
  80161b:	74 cd                	je     8015ea <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80161d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801622:	75 07                	jne    80162b <strncmp+0x57>
		return 0;
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
  801629:	eb 1a                	jmp    801645 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80162b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162f:	0f b6 00             	movzbl (%rax),%eax
  801632:	0f b6 d0             	movzbl %al,%edx
  801635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801639:	0f b6 00             	movzbl (%rax),%eax
  80163c:	0f b6 c0             	movzbl %al,%eax
  80163f:	89 d1                	mov    %edx,%ecx
  801641:	29 c1                	sub    %eax,%ecx
  801643:	89 c8                	mov    %ecx,%eax
}
  801645:	c9                   	leaveq 
  801646:	c3                   	retq   

0000000000801647 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801647:	55                   	push   %rbp
  801648:	48 89 e5             	mov    %rsp,%rbp
  80164b:	48 83 ec 10          	sub    $0x10,%rsp
  80164f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801653:	89 f0                	mov    %esi,%eax
  801655:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801658:	eb 17                	jmp    801671 <strchr+0x2a>
		if (*s == c)
  80165a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165e:	0f b6 00             	movzbl (%rax),%eax
  801661:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801664:	75 06                	jne    80166c <strchr+0x25>
			return (char *) s;
  801666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166a:	eb 15                	jmp    801681 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80166c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801675:	0f b6 00             	movzbl (%rax),%eax
  801678:	84 c0                	test   %al,%al
  80167a:	75 de                	jne    80165a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801681:	c9                   	leaveq 
  801682:	c3                   	retq   

0000000000801683 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801683:	55                   	push   %rbp
  801684:	48 89 e5             	mov    %rsp,%rbp
  801687:	48 83 ec 10          	sub    $0x10,%rsp
  80168b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80168f:	89 f0                	mov    %esi,%eax
  801691:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801694:	eb 11                	jmp    8016a7 <strfind+0x24>
		if (*s == c)
  801696:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016a0:	74 12                	je     8016b4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ab:	0f b6 00             	movzbl (%rax),%eax
  8016ae:	84 c0                	test   %al,%al
  8016b0:	75 e4                	jne    801696 <strfind+0x13>
  8016b2:	eb 01                	jmp    8016b5 <strfind+0x32>
		if (*s == c)
			break;
  8016b4:	90                   	nop
	return (char *) s;
  8016b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016b9:	c9                   	leaveq 
  8016ba:	c3                   	retq   

00000000008016bb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016bb:	55                   	push   %rbp
  8016bc:	48 89 e5             	mov    %rsp,%rbp
  8016bf:	48 83 ec 18          	sub    $0x18,%rsp
  8016c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016d3:	75 06                	jne    8016db <memset+0x20>
		return v;
  8016d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d9:	eb 69                	jmp    801744 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016df:	83 e0 03             	and    $0x3,%eax
  8016e2:	48 85 c0             	test   %rax,%rax
  8016e5:	75 48                	jne    80172f <memset+0x74>
  8016e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016eb:	83 e0 03             	and    $0x3,%eax
  8016ee:	48 85 c0             	test   %rax,%rax
  8016f1:	75 3c                	jne    80172f <memset+0x74>
		c &= 0xFF;
  8016f3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016fd:	89 c2                	mov    %eax,%edx
  8016ff:	c1 e2 18             	shl    $0x18,%edx
  801702:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801705:	c1 e0 10             	shl    $0x10,%eax
  801708:	09 c2                	or     %eax,%edx
  80170a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80170d:	c1 e0 08             	shl    $0x8,%eax
  801710:	09 d0                	or     %edx,%eax
  801712:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801719:	48 89 c1             	mov    %rax,%rcx
  80171c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801720:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801724:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801727:	48 89 d7             	mov    %rdx,%rdi
  80172a:	fc                   	cld    
  80172b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80172d:	eb 11                	jmp    801740 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80172f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801733:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801736:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80173a:	48 89 d7             	mov    %rdx,%rdi
  80173d:	fc                   	cld    
  80173e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801740:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801744:	c9                   	leaveq 
  801745:	c3                   	retq   

0000000000801746 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801746:	55                   	push   %rbp
  801747:	48 89 e5             	mov    %rsp,%rbp
  80174a:	48 83 ec 28          	sub    $0x28,%rsp
  80174e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801752:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801756:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80175a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80175e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801766:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80176a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801772:	0f 83 88 00 00 00    	jae    801800 <memmove+0xba>
  801778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801780:	48 01 d0             	add    %rdx,%rax
  801783:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801787:	76 77                	jbe    801800 <memmove+0xba>
		s += n;
  801789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801795:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179d:	83 e0 03             	and    $0x3,%eax
  8017a0:	48 85 c0             	test   %rax,%rax
  8017a3:	75 3b                	jne    8017e0 <memmove+0x9a>
  8017a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a9:	83 e0 03             	and    $0x3,%eax
  8017ac:	48 85 c0             	test   %rax,%rax
  8017af:	75 2f                	jne    8017e0 <memmove+0x9a>
  8017b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b5:	83 e0 03             	and    $0x3,%eax
  8017b8:	48 85 c0             	test   %rax,%rax
  8017bb:	75 23                	jne    8017e0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c1:	48 83 e8 04          	sub    $0x4,%rax
  8017c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017c9:	48 83 ea 04          	sub    $0x4,%rdx
  8017cd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017d1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 89 d6             	mov    %rdx,%rsi
  8017db:	fd                   	std    
  8017dc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017de:	eb 1d                	jmp    8017fd <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ec:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f4:	48 89 d7             	mov    %rdx,%rdi
  8017f7:	48 89 c1             	mov    %rax,%rcx
  8017fa:	fd                   	std    
  8017fb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017fd:	fc                   	cld    
  8017fe:	eb 57                	jmp    801857 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801800:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801804:	83 e0 03             	and    $0x3,%eax
  801807:	48 85 c0             	test   %rax,%rax
  80180a:	75 36                	jne    801842 <memmove+0xfc>
  80180c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801810:	83 e0 03             	and    $0x3,%eax
  801813:	48 85 c0             	test   %rax,%rax
  801816:	75 2a                	jne    801842 <memmove+0xfc>
  801818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181c:	83 e0 03             	and    $0x3,%eax
  80181f:	48 85 c0             	test   %rax,%rax
  801822:	75 1e                	jne    801842 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801828:	48 89 c1             	mov    %rax,%rcx
  80182b:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80182f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801833:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801837:	48 89 c7             	mov    %rax,%rdi
  80183a:	48 89 d6             	mov    %rdx,%rsi
  80183d:	fc                   	cld    
  80183e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801840:	eb 15                	jmp    801857 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801842:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801846:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80184a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80184e:	48 89 c7             	mov    %rax,%rdi
  801851:	48 89 d6             	mov    %rdx,%rsi
  801854:	fc                   	cld    
  801855:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80185b:	c9                   	leaveq 
  80185c:	c3                   	retq   

000000000080185d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80185d:	55                   	push   %rbp
  80185e:	48 89 e5             	mov    %rsp,%rbp
  801861:	48 83 ec 18          	sub    $0x18,%rsp
  801865:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801869:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80186d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801871:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801875:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801879:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187d:	48 89 ce             	mov    %rcx,%rsi
  801880:	48 89 c7             	mov    %rax,%rdi
  801883:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  80188a:	00 00 00 
  80188d:	ff d0                	callq  *%rax
}
  80188f:	c9                   	leaveq 
  801890:	c3                   	retq   

0000000000801891 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801891:	55                   	push   %rbp
  801892:	48 89 e5             	mov    %rsp,%rbp
  801895:	48 83 ec 28          	sub    $0x28,%rsp
  801899:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80189d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018b5:	eb 38                	jmp    8018ef <memcmp+0x5e>
		if (*s1 != *s2)
  8018b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018bb:	0f b6 10             	movzbl (%rax),%edx
  8018be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c2:	0f b6 00             	movzbl (%rax),%eax
  8018c5:	38 c2                	cmp    %al,%dl
  8018c7:	74 1c                	je     8018e5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8018c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018cd:	0f b6 00             	movzbl (%rax),%eax
  8018d0:	0f b6 d0             	movzbl %al,%edx
  8018d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d7:	0f b6 00             	movzbl (%rax),%eax
  8018da:	0f b6 c0             	movzbl %al,%eax
  8018dd:	89 d1                	mov    %edx,%ecx
  8018df:	29 c1                	sub    %eax,%ecx
  8018e1:	89 c8                	mov    %ecx,%eax
  8018e3:	eb 20                	jmp    801905 <memcmp+0x74>
		s1++, s2++;
  8018e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018ea:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018ef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018f4:	0f 95 c0             	setne  %al
  8018f7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8018fc:	84 c0                	test   %al,%al
  8018fe:	75 b7                	jne    8018b7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801905:	c9                   	leaveq 
  801906:	c3                   	retq   

0000000000801907 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801907:	55                   	push   %rbp
  801908:	48 89 e5             	mov    %rsp,%rbp
  80190b:	48 83 ec 28          	sub    $0x28,%rsp
  80190f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801913:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801916:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80191a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801922:	48 01 d0             	add    %rdx,%rax
  801925:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801929:	eb 13                	jmp    80193e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80192b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80192f:	0f b6 10             	movzbl (%rax),%edx
  801932:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801935:	38 c2                	cmp    %al,%dl
  801937:	74 11                	je     80194a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801939:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80193e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801942:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801946:	72 e3                	jb     80192b <memfind+0x24>
  801948:	eb 01                	jmp    80194b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80194a:	90                   	nop
	return (void *) s;
  80194b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80194f:	c9                   	leaveq 
  801950:	c3                   	retq   

0000000000801951 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801951:	55                   	push   %rbp
  801952:	48 89 e5             	mov    %rsp,%rbp
  801955:	48 83 ec 38          	sub    $0x38,%rsp
  801959:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80195d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801961:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801964:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80196b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801972:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801973:	eb 05                	jmp    80197a <strtol+0x29>
		s++;
  801975:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80197a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197e:	0f b6 00             	movzbl (%rax),%eax
  801981:	3c 20                	cmp    $0x20,%al
  801983:	74 f0                	je     801975 <strtol+0x24>
  801985:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801989:	0f b6 00             	movzbl (%rax),%eax
  80198c:	3c 09                	cmp    $0x9,%al
  80198e:	74 e5                	je     801975 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801994:	0f b6 00             	movzbl (%rax),%eax
  801997:	3c 2b                	cmp    $0x2b,%al
  801999:	75 07                	jne    8019a2 <strtol+0x51>
		s++;
  80199b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019a0:	eb 17                	jmp    8019b9 <strtol+0x68>
	else if (*s == '-')
  8019a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a6:	0f b6 00             	movzbl (%rax),%eax
  8019a9:	3c 2d                	cmp    $0x2d,%al
  8019ab:	75 0c                	jne    8019b9 <strtol+0x68>
		s++, neg = 1;
  8019ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019b9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019bd:	74 06                	je     8019c5 <strtol+0x74>
  8019bf:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019c3:	75 28                	jne    8019ed <strtol+0x9c>
  8019c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c9:	0f b6 00             	movzbl (%rax),%eax
  8019cc:	3c 30                	cmp    $0x30,%al
  8019ce:	75 1d                	jne    8019ed <strtol+0x9c>
  8019d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d4:	48 83 c0 01          	add    $0x1,%rax
  8019d8:	0f b6 00             	movzbl (%rax),%eax
  8019db:	3c 78                	cmp    $0x78,%al
  8019dd:	75 0e                	jne    8019ed <strtol+0x9c>
		s += 2, base = 16;
  8019df:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019e4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019eb:	eb 2c                	jmp    801a19 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019f1:	75 19                	jne    801a0c <strtol+0xbb>
  8019f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f7:	0f b6 00             	movzbl (%rax),%eax
  8019fa:	3c 30                	cmp    $0x30,%al
  8019fc:	75 0e                	jne    801a0c <strtol+0xbb>
		s++, base = 8;
  8019fe:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a03:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a0a:	eb 0d                	jmp    801a19 <strtol+0xc8>
	else if (base == 0)
  801a0c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a10:	75 07                	jne    801a19 <strtol+0xc8>
		base = 10;
  801a12:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1d:	0f b6 00             	movzbl (%rax),%eax
  801a20:	3c 2f                	cmp    $0x2f,%al
  801a22:	7e 1d                	jle    801a41 <strtol+0xf0>
  801a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a28:	0f b6 00             	movzbl (%rax),%eax
  801a2b:	3c 39                	cmp    $0x39,%al
  801a2d:	7f 12                	jg     801a41 <strtol+0xf0>
			dig = *s - '0';
  801a2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a33:	0f b6 00             	movzbl (%rax),%eax
  801a36:	0f be c0             	movsbl %al,%eax
  801a39:	83 e8 30             	sub    $0x30,%eax
  801a3c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a3f:	eb 4e                	jmp    801a8f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	0f b6 00             	movzbl (%rax),%eax
  801a48:	3c 60                	cmp    $0x60,%al
  801a4a:	7e 1d                	jle    801a69 <strtol+0x118>
  801a4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a50:	0f b6 00             	movzbl (%rax),%eax
  801a53:	3c 7a                	cmp    $0x7a,%al
  801a55:	7f 12                	jg     801a69 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5b:	0f b6 00             	movzbl (%rax),%eax
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	83 e8 57             	sub    $0x57,%eax
  801a64:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a67:	eb 26                	jmp    801a8f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6d:	0f b6 00             	movzbl (%rax),%eax
  801a70:	3c 40                	cmp    $0x40,%al
  801a72:	7e 47                	jle    801abb <strtol+0x16a>
  801a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a78:	0f b6 00             	movzbl (%rax),%eax
  801a7b:	3c 5a                	cmp    $0x5a,%al
  801a7d:	7f 3c                	jg     801abb <strtol+0x16a>
			dig = *s - 'A' + 10;
  801a7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a83:	0f b6 00             	movzbl (%rax),%eax
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	83 e8 37             	sub    $0x37,%eax
  801a8c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a92:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a95:	7d 23                	jge    801aba <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801a97:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a9c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a9f:	48 98                	cltq   
  801aa1:	48 89 c2             	mov    %rax,%rdx
  801aa4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801aa9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aac:	48 98                	cltq   
  801aae:	48 01 d0             	add    %rdx,%rax
  801ab1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ab5:	e9 5f ff ff ff       	jmpq   801a19 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801aba:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801abb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801ac0:	74 0b                	je     801acd <strtol+0x17c>
		*endptr = (char *) s;
  801ac2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801aca:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801acd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ad1:	74 09                	je     801adc <strtol+0x18b>
  801ad3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad7:	48 f7 d8             	neg    %rax
  801ada:	eb 04                	jmp    801ae0 <strtol+0x18f>
  801adc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ae0:	c9                   	leaveq 
  801ae1:	c3                   	retq   

0000000000801ae2 <strstr>:

char * strstr(const char *in, const char *str)
{
  801ae2:	55                   	push   %rbp
  801ae3:	48 89 e5             	mov    %rsp,%rbp
  801ae6:	48 83 ec 30          	sub    $0x30,%rsp
  801aea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801aee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801af2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801af6:	0f b6 00             	movzbl (%rax),%eax
  801af9:	88 45 ff             	mov    %al,-0x1(%rbp)
  801afc:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801b01:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b05:	75 06                	jne    801b0d <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801b07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0b:	eb 68                	jmp    801b75 <strstr+0x93>

    len = strlen(str);
  801b0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b11:	48 89 c7             	mov    %rax,%rdi
  801b14:	48 b8 b8 13 80 00 00 	movabs $0x8013b8,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	callq  *%rax
  801b20:	48 98                	cltq   
  801b22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801b26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2a:	0f b6 00             	movzbl (%rax),%eax
  801b2d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801b30:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801b35:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b39:	75 07                	jne    801b42 <strstr+0x60>
                return (char *) 0;
  801b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b40:	eb 33                	jmp    801b75 <strstr+0x93>
        } while (sc != c);
  801b42:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b46:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b49:	75 db                	jne    801b26 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801b4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b57:	48 89 ce             	mov    %rcx,%rsi
  801b5a:	48 89 c7             	mov    %rax,%rdi
  801b5d:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  801b64:	00 00 00 
  801b67:	ff d0                	callq  *%rax
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	75 b9                	jne    801b26 <strstr+0x44>

    return (char *) (in - 1);
  801b6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b71:	48 83 e8 01          	sub    $0x1,%rax
}
  801b75:	c9                   	leaveq 
  801b76:	c3                   	retq   
	...

0000000000801b78 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	53                   	push   %rbx
  801b7d:	48 83 ec 58          	sub    $0x58,%rsp
  801b81:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b84:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b87:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b8b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b8f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b93:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b97:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b9a:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801b9d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ba1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ba5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ba9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bad:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bb1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801bb4:	4c 89 c3             	mov    %r8,%rbx
  801bb7:	cd 30                	int    $0x30
  801bb9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801bbd:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801bc1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801bc5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bc9:	74 3e                	je     801c09 <syscall+0x91>
  801bcb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bd0:	7e 37                	jle    801c09 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bd6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bd9:	49 89 d0             	mov    %rdx,%r8
  801bdc:	89 c1                	mov    %eax,%ecx
  801bde:	48 ba 60 4f 80 00 00 	movabs $0x804f60,%rdx
  801be5:	00 00 00 
  801be8:	be 23 00 00 00       	mov    $0x23,%esi
  801bed:	48 bf 7d 4f 80 00 00 	movabs $0x804f7d,%rdi
  801bf4:	00 00 00 
  801bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfc:	49 b9 2c 06 80 00 00 	movabs $0x80062c,%r9
  801c03:	00 00 00 
  801c06:	41 ff d1             	callq  *%r9

	return ret;
  801c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c0d:	48 83 c4 58          	add    $0x58,%rsp
  801c11:	5b                   	pop    %rbx
  801c12:	5d                   	pop    %rbp
  801c13:	c3                   	retq   

0000000000801c14 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c14:	55                   	push   %rbp
  801c15:	48 89 e5             	mov    %rsp,%rbp
  801c18:	48 83 ec 20          	sub    $0x20,%rsp
  801c1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c20:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c33:	00 
  801c34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c40:	48 89 d1             	mov    %rdx,%rcx
  801c43:	48 89 c2             	mov    %rax,%rdx
  801c46:	be 00 00 00 00       	mov    $0x0,%esi
  801c4b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c50:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801c57:	00 00 00 
  801c5a:	ff d0                	callq  *%rax
}
  801c5c:	c9                   	leaveq 
  801c5d:	c3                   	retq   

0000000000801c5e <sys_cgetc>:

int
sys_cgetc(void)
{
  801c5e:	55                   	push   %rbp
  801c5f:	48 89 e5             	mov    %rsp,%rbp
  801c62:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6d:	00 
  801c6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c84:	be 00 00 00 00       	mov    $0x0,%esi
  801c89:	bf 01 00 00 00       	mov    $0x1,%edi
  801c8e:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
}
  801c9a:	c9                   	leaveq 
  801c9b:	c3                   	retq   

0000000000801c9c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c9c:	55                   	push   %rbp
  801c9d:	48 89 e5             	mov    %rsp,%rbp
  801ca0:	48 83 ec 20          	sub    $0x20,%rsp
  801ca4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ca7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801caa:	48 98                	cltq   
  801cac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb3:	00 
  801cb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc5:	48 89 c2             	mov    %rax,%rdx
  801cc8:	be 01 00 00 00       	mov    $0x1,%esi
  801ccd:	bf 03 00 00 00       	mov    $0x3,%edi
  801cd2:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
}
  801cde:	c9                   	leaveq 
  801cdf:	c3                   	retq   

0000000000801ce0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ce8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cef:	00 
  801cf0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d01:	ba 00 00 00 00       	mov    $0x0,%edx
  801d06:	be 00 00 00 00       	mov    $0x0,%esi
  801d0b:	bf 02 00 00 00       	mov    $0x2,%edi
  801d10:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801d17:	00 00 00 
  801d1a:	ff d0                	callq  *%rax
}
  801d1c:	c9                   	leaveq 
  801d1d:	c3                   	retq   

0000000000801d1e <sys_yield>:

void
sys_yield(void)
{
  801d1e:	55                   	push   %rbp
  801d1f:	48 89 e5             	mov    %rsp,%rbp
  801d22:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2d:	00 
  801d2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d44:	be 00 00 00 00       	mov    $0x0,%esi
  801d49:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d4e:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801d55:	00 00 00 
  801d58:	ff d0                	callq  *%rax
}
  801d5a:	c9                   	leaveq 
  801d5b:	c3                   	retq   

0000000000801d5c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d5c:	55                   	push   %rbp
  801d5d:	48 89 e5             	mov    %rsp,%rbp
  801d60:	48 83 ec 20          	sub    $0x20,%rsp
  801d64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d6b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d71:	48 63 c8             	movslq %eax,%rcx
  801d74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7b:	48 98                	cltq   
  801d7d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d84:	00 
  801d85:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8b:	49 89 c8             	mov    %rcx,%r8
  801d8e:	48 89 d1             	mov    %rdx,%rcx
  801d91:	48 89 c2             	mov    %rax,%rdx
  801d94:	be 01 00 00 00       	mov    $0x1,%esi
  801d99:	bf 04 00 00 00       	mov    $0x4,%edi
  801d9e:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801da5:	00 00 00 
  801da8:	ff d0                	callq  *%rax
}
  801daa:	c9                   	leaveq 
  801dab:	c3                   	retq   

0000000000801dac <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801dac:	55                   	push   %rbp
  801dad:	48 89 e5             	mov    %rsp,%rbp
  801db0:	48 83 ec 30          	sub    $0x30,%rsp
  801db4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dbb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dbe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dc2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dc6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dc9:	48 63 c8             	movslq %eax,%rcx
  801dcc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd3:	48 63 f0             	movslq %eax,%rsi
  801dd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ddd:	48 98                	cltq   
  801ddf:	48 89 0c 24          	mov    %rcx,(%rsp)
  801de3:	49 89 f9             	mov    %rdi,%r9
  801de6:	49 89 f0             	mov    %rsi,%r8
  801de9:	48 89 d1             	mov    %rdx,%rcx
  801dec:	48 89 c2             	mov    %rax,%rdx
  801def:	be 01 00 00 00       	mov    $0x1,%esi
  801df4:	bf 05 00 00 00       	mov    $0x5,%edi
  801df9:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801e00:	00 00 00 
  801e03:	ff d0                	callq  *%rax
}
  801e05:	c9                   	leaveq 
  801e06:	c3                   	retq   

0000000000801e07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e07:	55                   	push   %rbp
  801e08:	48 89 e5             	mov    %rsp,%rbp
  801e0b:	48 83 ec 20          	sub    $0x20,%rsp
  801e0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1d:	48 98                	cltq   
  801e1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e26:	00 
  801e27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e33:	48 89 d1             	mov    %rdx,%rcx
  801e36:	48 89 c2             	mov    %rax,%rdx
  801e39:	be 01 00 00 00       	mov    $0x1,%esi
  801e3e:	bf 06 00 00 00       	mov    $0x6,%edi
  801e43:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801e4a:	00 00 00 
  801e4d:	ff d0                	callq  *%rax
}
  801e4f:	c9                   	leaveq 
  801e50:	c3                   	retq   

0000000000801e51 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e51:	55                   	push   %rbp
  801e52:	48 89 e5             	mov    %rsp,%rbp
  801e55:	48 83 ec 20          	sub    $0x20,%rsp
  801e59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e5c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e62:	48 63 d0             	movslq %eax,%rdx
  801e65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e68:	48 98                	cltq   
  801e6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e71:	00 
  801e72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7e:	48 89 d1             	mov    %rdx,%rcx
  801e81:	48 89 c2             	mov    %rax,%rdx
  801e84:	be 01 00 00 00       	mov    $0x1,%esi
  801e89:	bf 08 00 00 00       	mov    $0x8,%edi
  801e8e:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	callq  *%rax
}
  801e9a:	c9                   	leaveq 
  801e9b:	c3                   	retq   

0000000000801e9c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e9c:	55                   	push   %rbp
  801e9d:	48 89 e5             	mov    %rsp,%rbp
  801ea0:	48 83 ec 20          	sub    $0x20,%rsp
  801ea4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ea7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801eab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb2:	48 98                	cltq   
  801eb4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ebb:	00 
  801ebc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec8:	48 89 d1             	mov    %rdx,%rcx
  801ecb:	48 89 c2             	mov    %rax,%rdx
  801ece:	be 01 00 00 00       	mov    $0x1,%esi
  801ed3:	bf 09 00 00 00       	mov    $0x9,%edi
  801ed8:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801edf:	00 00 00 
  801ee2:	ff d0                	callq  *%rax
}
  801ee4:	c9                   	leaveq 
  801ee5:	c3                   	retq   

0000000000801ee6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ee6:	55                   	push   %rbp
  801ee7:	48 89 e5             	mov    %rsp,%rbp
  801eea:	48 83 ec 20          	sub    $0x20,%rsp
  801eee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ef1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ef5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efc:	48 98                	cltq   
  801efe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f05:	00 
  801f06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f12:	48 89 d1             	mov    %rdx,%rcx
  801f15:	48 89 c2             	mov    %rax,%rdx
  801f18:	be 01 00 00 00       	mov    $0x1,%esi
  801f1d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f22:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801f29:	00 00 00 
  801f2c:	ff d0                	callq  *%rax
}
  801f2e:	c9                   	leaveq 
  801f2f:	c3                   	retq   

0000000000801f30 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f30:	55                   	push   %rbp
  801f31:	48 89 e5             	mov    %rsp,%rbp
  801f34:	48 83 ec 30          	sub    $0x30,%rsp
  801f38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f3f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f43:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f49:	48 63 f0             	movslq %eax,%rsi
  801f4c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f53:	48 98                	cltq   
  801f55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f60:	00 
  801f61:	49 89 f1             	mov    %rsi,%r9
  801f64:	49 89 c8             	mov    %rcx,%r8
  801f67:	48 89 d1             	mov    %rdx,%rcx
  801f6a:	48 89 c2             	mov    %rax,%rdx
  801f6d:	be 00 00 00 00       	mov    $0x0,%esi
  801f72:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f77:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	callq  *%rax
}
  801f83:	c9                   	leaveq 
  801f84:	c3                   	retq   

0000000000801f85 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f85:	55                   	push   %rbp
  801f86:	48 89 e5             	mov    %rsp,%rbp
  801f89:	48 83 ec 20          	sub    $0x20,%rsp
  801f8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f95:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f9c:	00 
  801f9d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fa3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fae:	48 89 c2             	mov    %rax,%rdx
  801fb1:	be 01 00 00 00       	mov    $0x1,%esi
  801fb6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fbb:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801fc2:	00 00 00 
  801fc5:	ff d0                	callq  *%rax
}
  801fc7:	c9                   	leaveq 
  801fc8:	c3                   	retq   

0000000000801fc9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801fc9:	55                   	push   %rbp
  801fca:	48 89 e5             	mov    %rsp,%rbp
  801fcd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fd1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd8:	00 
  801fd9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fdf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fea:	ba 00 00 00 00       	mov    $0x0,%edx
  801fef:	be 00 00 00 00       	mov    $0x0,%esi
  801ff4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ff9:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
}
  802005:	c9                   	leaveq 
  802006:	c3                   	retq   

0000000000802007 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  802007:	55                   	push   %rbp
  802008:	48 89 e5             	mov    %rsp,%rbp
  80200b:	48 83 ec 20          	sub    $0x20,%rsp
  80200f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802013:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802017:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80201b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802026:	00 
  802027:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80202d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802033:	48 89 d1             	mov    %rdx,%rcx
  802036:	48 89 c2             	mov    %rax,%rdx
  802039:	be 00 00 00 00       	mov    $0x0,%esi
  80203e:	bf 0f 00 00 00       	mov    $0xf,%edi
  802043:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
}
  80204f:	c9                   	leaveq 
  802050:	c3                   	retq   

0000000000802051 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802051:	55                   	push   %rbp
  802052:	48 89 e5             	mov    %rsp,%rbp
  802055:	48 83 ec 20          	sub    $0x20,%rsp
  802059:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80205d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802065:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802069:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802070:	00 
  802071:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802077:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80207d:	48 89 d1             	mov    %rdx,%rcx
  802080:	48 89 c2             	mov    %rax,%rdx
  802083:	be 00 00 00 00       	mov    $0x0,%esi
  802088:	bf 10 00 00 00       	mov    $0x10,%edi
  80208d:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802094:	00 00 00 
  802097:	ff d0                	callq  *%rax
}
  802099:	c9                   	leaveq 
  80209a:	c3                   	retq   
	...

000000000080209c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80209c:	55                   	push   %rbp
  80209d:	48 89 e5             	mov    %rsp,%rbp
  8020a0:	48 83 ec 30          	sub    $0x30,%rsp
  8020a4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8020a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ac:	48 8b 00             	mov    (%rax),%rax
  8020af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  8020b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020bb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  8020be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020c1:	83 e0 02             	and    $0x2,%eax
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	74 23                	je     8020eb <pgfault+0x4f>
  8020c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cc:	48 89 c2             	mov    %rax,%rdx
  8020cf:	48 c1 ea 0c          	shr    $0xc,%rdx
  8020d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020da:	01 00 00 
  8020dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e1:	25 00 08 00 00       	and    $0x800,%eax
  8020e6:	48 85 c0             	test   %rax,%rax
  8020e9:	75 2a                	jne    802115 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  8020eb:	48 ba 90 4f 80 00 00 	movabs $0x804f90,%rdx
  8020f2:	00 00 00 
  8020f5:	be 1c 00 00 00       	mov    $0x1c,%esi
  8020fa:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  802101:	00 00 00 
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	48 b9 2c 06 80 00 00 	movabs $0x80062c,%rcx
  802110:	00 00 00 
  802113:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  802115:	ba 07 00 00 00       	mov    $0x7,%edx
  80211a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80211f:	bf 00 00 00 00       	mov    $0x0,%edi
  802124:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	callq  *%rax
  802130:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802133:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802137:	79 30                	jns    802169 <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  802139:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80213c:	89 c1                	mov    %eax,%ecx
  80213e:	48 ba d0 4f 80 00 00 	movabs $0x804fd0,%rdx
  802145:	00 00 00 
  802148:	be 26 00 00 00       	mov    $0x26,%esi
  80214d:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  802154:	00 00 00 
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
  80215c:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  802163:	00 00 00 
  802166:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  802169:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802175:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80217b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802180:	48 89 c6             	mov    %rax,%rsi
  802183:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802188:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  80218f:	00 00 00 
  802192:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  802194:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802198:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80219c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021a0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8021a6:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8021ac:	48 89 c1             	mov    %rax,%rcx
  8021af:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021be:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  8021c5:	00 00 00 
  8021c8:	ff d0                	callq  *%rax
  8021ca:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8021cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8021d1:	79 30                	jns    802203 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  8021d3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8021d6:	89 c1                	mov    %eax,%ecx
  8021d8:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  8021df:	00 00 00 
  8021e2:	be 2b 00 00 00       	mov    $0x2b,%esi
  8021e7:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  8021ee:	00 00 00 
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f6:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  8021fd:	00 00 00 
  802200:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  802203:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802208:	bf 00 00 00 00       	mov    $0x0,%edi
  80220d:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax
  802219:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80221c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802220:	79 30                	jns    802252 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  802222:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802225:	89 c1                	mov    %eax,%ecx
  802227:	48 ba 20 50 80 00 00 	movabs $0x805020,%rdx
  80222e:	00 00 00 
  802231:	be 2e 00 00 00       	mov    $0x2e,%esi
  802236:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  80223d:	00 00 00 
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
  802245:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  80224c:	00 00 00 
  80224f:	41 ff d0             	callq  *%r8
	
}
  802252:	c9                   	leaveq 
  802253:	c3                   	retq   

0000000000802254 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802254:	55                   	push   %rbp
  802255:	48 89 e5             	mov    %rsp,%rbp
  802258:	48 83 ec 30          	sub    $0x30,%rsp
  80225c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80225f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  802262:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802269:	01 00 00 
  80226c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80226f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802273:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  802277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80227b:	25 07 0e 00 00       	and    $0xe07,%eax
  802280:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  802283:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802286:	48 c1 e0 0c          	shl    $0xc,%rax
  80228a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  80228e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802291:	25 00 04 00 00       	and    $0x400,%eax
  802296:	85 c0                	test   %eax,%eax
  802298:	74 5c                	je     8022f6 <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  80229a:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80229d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022a1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a8:	41 89 f0             	mov    %esi,%r8d
  8022ab:	48 89 c6             	mov    %rax,%rsi
  8022ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b3:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax
  8022bf:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  8022c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022c6:	0f 89 60 01 00 00    	jns    80242c <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  8022cc:	48 ba 48 50 80 00 00 	movabs $0x805048,%rdx
  8022d3:	00 00 00 
  8022d6:	be 4d 00 00 00       	mov    $0x4d,%esi
  8022db:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  8022e2:	00 00 00 
  8022e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ea:	48 b9 2c 06 80 00 00 	movabs $0x80062c,%rcx
  8022f1:	00 00 00 
  8022f4:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  8022f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022f9:	83 e0 02             	and    $0x2,%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	75 10                	jne    802310 <duppage+0xbc>
  802300:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802303:	25 00 08 00 00       	and    $0x800,%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	0f 84 c4 00 00 00    	je     8023d4 <duppage+0x180>
	{
		perm |= PTE_COW;
  802310:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  802317:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  80231b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80231e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802322:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802329:	41 89 f0             	mov    %esi,%r8d
  80232c:	48 89 c6             	mov    %rax,%rsi
  80232f:	bf 00 00 00 00       	mov    $0x0,%edi
  802334:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	callq  *%rax
  802340:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  802343:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802347:	79 2a                	jns    802373 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  802349:	48 ba 78 50 80 00 00 	movabs $0x805078,%rdx
  802350:	00 00 00 
  802353:	be 56 00 00 00       	mov    $0x56,%esi
  802358:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  80235f:	00 00 00 
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
  802367:	48 b9 2c 06 80 00 00 	movabs $0x80062c,%rcx
  80236e:	00 00 00 
  802371:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  802373:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  802376:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80237a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237e:	41 89 c8             	mov    %ecx,%r8d
  802381:	48 89 d1             	mov    %rdx,%rcx
  802384:	ba 00 00 00 00       	mov    $0x0,%edx
  802389:	48 89 c6             	mov    %rax,%rsi
  80238c:	bf 00 00 00 00       	mov    $0x0,%edi
  802391:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  802398:	00 00 00 
  80239b:	ff d0                	callq  *%rax
  80239d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8023a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023a4:	0f 89 82 00 00 00    	jns    80242c <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  8023aa:	48 ba 78 50 80 00 00 	movabs $0x805078,%rdx
  8023b1:	00 00 00 
  8023b4:	be 59 00 00 00       	mov    $0x59,%esi
  8023b9:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  8023c0:	00 00 00 
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	48 b9 2c 06 80 00 00 	movabs $0x80062c,%rcx
  8023cf:	00 00 00 
  8023d2:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  8023d4:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8023d7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023db:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e2:	41 89 f0             	mov    %esi,%r8d
  8023e5:	48 89 c6             	mov    %rax,%rsi
  8023e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ed:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
  8023f9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8023fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802400:	79 2a                	jns    80242c <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  802402:	48 ba b0 50 80 00 00 	movabs $0x8050b0,%rdx
  802409:	00 00 00 
  80240c:	be 60 00 00 00       	mov    $0x60,%esi
  802411:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  802418:	00 00 00 
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	48 b9 2c 06 80 00 00 	movabs $0x80062c,%rcx
  802427:	00 00 00 
  80242a:	ff d1                	callq  *%rcx
	}
	return 0;
  80242c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802431:	c9                   	leaveq 
  802432:	c3                   	retq   

0000000000802433 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802433:	55                   	push   %rbp
  802434:	48 89 e5             	mov    %rsp,%rbp
  802437:	53                   	push   %rbx
  802438:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80243c:	48 bf 9c 20 80 00 00 	movabs $0x80209c,%rdi
  802443:	00 00 00 
  802446:	48 b8 f8 46 80 00 00 	movabs $0x8046f8,%rax
  80244d:	00 00 00 
  802450:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802452:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  802459:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80245c:	cd 30                	int    $0x30
  80245e:	89 c3                	mov    %eax,%ebx
  802460:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802463:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  802466:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  802469:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80246d:	79 30                	jns    80249f <fork+0x6c>
                panic("sys_exofork: %e", envid);
  80246f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802472:	89 c1                	mov    %eax,%ecx
  802474:	48 ba d4 50 80 00 00 	movabs $0x8050d4,%rdx
  80247b:	00 00 00 
  80247e:	be 7f 00 00 00       	mov    $0x7f,%esi
  802483:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  80248a:	00 00 00 
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  802499:	00 00 00 
  80249c:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  80249f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8024a3:	75 4c                	jne    8024f1 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  8024a5:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	48 98                	cltq   
  8024b3:	48 89 c2             	mov    %rax,%rdx
  8024b6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8024bc:	48 89 d0             	mov    %rdx,%rax
  8024bf:	48 c1 e0 03          	shl    $0x3,%rax
  8024c3:	48 01 d0             	add    %rdx,%rax
  8024c6:	48 c1 e0 05          	shl    $0x5,%rax
  8024ca:	48 89 c2             	mov    %rax,%rdx
  8024cd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024d4:	00 00 00 
  8024d7:	48 01 c2             	add    %rax,%rdx
  8024da:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8024e1:	00 00 00 
  8024e4:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ec:	e9 38 02 00 00       	jmpq   802729 <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  8024f1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8024f4:	ba 07 00 00 00       	mov    $0x7,%edx
  8024f9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024fe:	89 c7                	mov    %eax,%edi
  802500:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  802507:	00 00 00 
  80250a:	ff d0                	callq  *%rax
  80250c:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  80250f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802513:	79 30                	jns    802545 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  802515:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802518:	89 c1                	mov    %eax,%ecx
  80251a:	48 ba e8 50 80 00 00 	movabs $0x8050e8,%rdx
  802521:	00 00 00 
  802524:	be 8b 00 00 00       	mov    $0x8b,%esi
  802529:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  802530:	00 00 00 
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  80253f:	00 00 00 
  802542:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802545:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  80254c:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802553:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  80255a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802561:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802568:	e9 0a 01 00 00       	jmpq   802677 <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  80256d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802574:	01 00 00 
  802577:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80257a:	48 63 d2             	movslq %edx,%rdx
  80257d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802581:	83 e0 01             	and    $0x1,%eax
  802584:	84 c0                	test   %al,%al
  802586:	0f 84 e7 00 00 00    	je     802673 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  80258c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802593:	e9 cf 00 00 00       	jmpq   802667 <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  802598:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80259f:	01 00 00 
  8025a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025a5:	48 63 d2             	movslq %edx,%rdx
  8025a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ac:	83 e0 01             	and    $0x1,%eax
  8025af:	84 c0                	test   %al,%al
  8025b1:	0f 84 a0 00 00 00    	je     802657 <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8025b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  8025be:	e9 85 00 00 00       	jmpq   802648 <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  8025c3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025ca:	01 00 00 
  8025cd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025d0:	48 63 d2             	movslq %edx,%rdx
  8025d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d7:	83 e0 01             	and    $0x1,%eax
  8025da:	84 c0                	test   %al,%al
  8025dc:	74 56                	je     802634 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8025de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  8025e5:	eb 42                	jmp    802629 <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  8025e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ee:	01 00 00 
  8025f1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025f4:	48 63 d2             	movslq %edx,%rdx
  8025f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fb:	83 e0 01             	and    $0x1,%eax
  8025fe:	84 c0                	test   %al,%al
  802600:	74 1f                	je     802621 <fork+0x1ee>
  802602:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  802609:	74 16                	je     802621 <fork+0x1ee>
									 duppage(envid,d1);
  80260b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80260e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802611:	89 d6                	mov    %edx,%esi
  802613:	89 c7                	mov    %eax,%edi
  802615:	48 b8 54 22 80 00 00 	movabs $0x802254,%rax
  80261c:	00 00 00 
  80261f:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802621:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  802625:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  802629:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802630:	7e b5                	jle    8025e7 <fork+0x1b4>
  802632:	eb 0c                	jmp    802640 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802634:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802637:	83 c0 01             	add    $0x1,%eax
  80263a:	c1 e0 09             	shl    $0x9,%eax
  80263d:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802640:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802644:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  802648:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  80264f:	0f 8e 6e ff ff ff    	jle    8025c3 <fork+0x190>
  802655:	eb 0c                	jmp    802663 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  802657:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80265a:	83 c0 01             	add    $0x1,%eax
  80265d:	c1 e0 09             	shl    $0x9,%eax
  802660:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802663:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  802667:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80266a:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  80266d:	0f 8c 25 ff ff ff    	jl     802598 <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802673:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802677:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80267a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80267d:	0f 8c ea fe ff ff    	jl     80256d <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802683:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802686:	48 be bc 47 80 00 00 	movabs $0x8047bc,%rsi
  80268d:	00 00 00 
  802690:	89 c7                	mov    %eax,%edi
  802692:	48 b8 e6 1e 80 00 00 	movabs $0x801ee6,%rax
  802699:	00 00 00 
  80269c:	ff d0                	callq  *%rax
  80269e:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8026a1:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8026a5:	79 30                	jns    8026d7 <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  8026a7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8026aa:	89 c1                	mov    %eax,%ecx
  8026ac:	48 ba 08 51 80 00 00 	movabs $0x805108,%rdx
  8026b3:	00 00 00 
  8026b6:	be ad 00 00 00       	mov    $0xad,%esi
  8026bb:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  8026c2:	00 00 00 
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ca:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  8026d1:	00 00 00 
  8026d4:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  8026d7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8026da:	be 02 00 00 00       	mov    $0x2,%esi
  8026df:	89 c7                	mov    %eax,%edi
  8026e1:	48 b8 51 1e 80 00 00 	movabs $0x801e51,%rax
  8026e8:	00 00 00 
  8026eb:	ff d0                	callq  *%rax
  8026ed:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8026f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8026f4:	79 30                	jns    802726 <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  8026f6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8026f9:	89 c1                	mov    %eax,%ecx
  8026fb:	48 ba 38 51 80 00 00 	movabs $0x805138,%rdx
  802702:	00 00 00 
  802705:	be b0 00 00 00       	mov    $0xb0,%esi
  80270a:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  802711:	00 00 00 
  802714:	b8 00 00 00 00       	mov    $0x0,%eax
  802719:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  802720:	00 00 00 
  802723:	41 ff d0             	callq  *%r8
	return envid;
  802726:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  802729:	48 83 c4 48          	add    $0x48,%rsp
  80272d:	5b                   	pop    %rbx
  80272e:	5d                   	pop    %rbp
  80272f:	c3                   	retq   

0000000000802730 <sfork>:

// Challenge!
int
sfork(void)
{
  802730:	55                   	push   %rbp
  802731:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802734:	48 ba 5c 51 80 00 00 	movabs $0x80515c,%rdx
  80273b:	00 00 00 
  80273e:	be b8 00 00 00       	mov    $0xb8,%esi
  802743:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  80274a:	00 00 00 
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
  802752:	48 b9 2c 06 80 00 00 	movabs $0x80062c,%rcx
  802759:	00 00 00 
  80275c:	ff d1                	callq  *%rcx
	...

0000000000802760 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802760:	55                   	push   %rbp
  802761:	48 89 e5             	mov    %rsp,%rbp
  802764:	48 83 ec 30          	sub    $0x30,%rsp
  802768:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80276c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802770:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  802774:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802779:	74 18                	je     802793 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80277b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80277f:	48 89 c7             	mov    %rax,%rdi
  802782:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
  80278e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802791:	eb 19                	jmp    8027ac <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  802793:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80279a:	00 00 00 
  80279d:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  8027a4:	00 00 00 
  8027a7:	ff d0                	callq  *%rax
  8027a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8027ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b0:	79 19                	jns    8027cb <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8027b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8027bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8027c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c9:	eb 53                	jmp    80281e <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8027cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8027d0:	74 19                	je     8027eb <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8027d2:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8027d9:	00 00 00 
  8027dc:	48 8b 00             	mov    (%rax),%rax
  8027df:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8027e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e9:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8027eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027f0:	74 19                	je     80280b <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8027f2:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8027f9:	00 00 00 
  8027fc:	48 8b 00             	mov    (%rax),%rax
  8027ff:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802809:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80280b:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  802812:	00 00 00 
  802815:	48 8b 00             	mov    (%rax),%rax
  802818:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80281e:	c9                   	leaveq 
  80281f:	c3                   	retq   

0000000000802820 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	48 83 ec 30          	sub    $0x30,%rsp
  802828:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80282b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80282e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802832:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  802835:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  80283c:	e9 96 00 00 00       	jmpq   8028d7 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  802841:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802846:	74 20                	je     802868 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  802848:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80284b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80284e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802852:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802855:	89 c7                	mov    %eax,%edi
  802857:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
  802863:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802866:	eb 2d                	jmp    802895 <ipc_send+0x75>
		else if(pg==NULL)
  802868:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80286d:	75 26                	jne    802895 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80286f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802872:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802875:	b9 00 00 00 00       	mov    $0x0,%ecx
  80287a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802881:	00 00 00 
  802884:	89 c7                	mov    %eax,%edi
  802886:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  80288d:	00 00 00 
  802890:	ff d0                	callq  *%rax
  802892:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  802895:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802899:	79 30                	jns    8028cb <ipc_send+0xab>
  80289b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80289f:	74 2a                	je     8028cb <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8028a1:	48 ba 72 51 80 00 00 	movabs $0x805172,%rdx
  8028a8:	00 00 00 
  8028ab:	be 40 00 00 00       	mov    $0x40,%esi
  8028b0:	48 bf 8a 51 80 00 00 	movabs $0x80518a,%rdi
  8028b7:	00 00 00 
  8028ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bf:	48 b9 2c 06 80 00 00 	movabs $0x80062c,%rcx
  8028c6:	00 00 00 
  8028c9:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8028cb:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8028d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028db:	0f 85 60 ff ff ff    	jne    802841 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8028e1:	c9                   	leaveq 
  8028e2:	c3                   	retq   

00000000008028e3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028e3:	55                   	push   %rbp
  8028e4:	48 89 e5             	mov    %rsp,%rbp
  8028e7:	48 83 ec 18          	sub    $0x18,%rsp
  8028eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8028ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028f5:	eb 5e                	jmp    802955 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8028f7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8028fe:	00 00 00 
  802901:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802904:	48 63 d0             	movslq %eax,%rdx
  802907:	48 89 d0             	mov    %rdx,%rax
  80290a:	48 c1 e0 03          	shl    $0x3,%rax
  80290e:	48 01 d0             	add    %rdx,%rax
  802911:	48 c1 e0 05          	shl    $0x5,%rax
  802915:	48 01 c8             	add    %rcx,%rax
  802918:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80291e:	8b 00                	mov    (%rax),%eax
  802920:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802923:	75 2c                	jne    802951 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802925:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80292c:	00 00 00 
  80292f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802932:	48 63 d0             	movslq %eax,%rdx
  802935:	48 89 d0             	mov    %rdx,%rax
  802938:	48 c1 e0 03          	shl    $0x3,%rax
  80293c:	48 01 d0             	add    %rdx,%rax
  80293f:	48 c1 e0 05          	shl    $0x5,%rax
  802943:	48 01 c8             	add    %rcx,%rax
  802946:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80294c:	8b 40 08             	mov    0x8(%rax),%eax
  80294f:	eb 12                	jmp    802963 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802951:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802955:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80295c:	7e 99                	jle    8028f7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80295e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802963:	c9                   	leaveq 
  802964:	c3                   	retq   
  802965:	00 00                	add    %al,(%rax)
	...

0000000000802968 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802968:	55                   	push   %rbp
  802969:	48 89 e5             	mov    %rsp,%rbp
  80296c:	48 83 ec 08          	sub    $0x8,%rsp
  802970:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802974:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802978:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80297f:	ff ff ff 
  802982:	48 01 d0             	add    %rdx,%rax
  802985:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802989:	c9                   	leaveq 
  80298a:	c3                   	retq   

000000000080298b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80298b:	55                   	push   %rbp
  80298c:	48 89 e5             	mov    %rsp,%rbp
  80298f:	48 83 ec 08          	sub    $0x8,%rsp
  802993:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802997:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80299b:	48 89 c7             	mov    %rax,%rdi
  80299e:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  8029a5:	00 00 00 
  8029a8:	ff d0                	callq  *%rax
  8029aa:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8029b0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8029b4:	c9                   	leaveq 
  8029b5:	c3                   	retq   

00000000008029b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8029b6:	55                   	push   %rbp
  8029b7:	48 89 e5             	mov    %rsp,%rbp
  8029ba:	48 83 ec 18          	sub    $0x18,%rsp
  8029be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8029c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029c9:	eb 6b                	jmp    802a36 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8029cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ce:	48 98                	cltq   
  8029d0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029d6:	48 c1 e0 0c          	shl    $0xc,%rax
  8029da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8029de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e2:	48 89 c2             	mov    %rax,%rdx
  8029e5:	48 c1 ea 15          	shr    $0x15,%rdx
  8029e9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029f0:	01 00 00 
  8029f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f7:	83 e0 01             	and    $0x1,%eax
  8029fa:	48 85 c0             	test   %rax,%rax
  8029fd:	74 21                	je     802a20 <fd_alloc+0x6a>
  8029ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a03:	48 89 c2             	mov    %rax,%rdx
  802a06:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a11:	01 00 00 
  802a14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a18:	83 e0 01             	and    $0x1,%eax
  802a1b:	48 85 c0             	test   %rax,%rax
  802a1e:	75 12                	jne    802a32 <fd_alloc+0x7c>
			*fd_store = fd;
  802a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a28:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a30:	eb 1a                	jmp    802a4c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a32:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a36:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a3a:	7e 8f                	jle    8029cb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a40:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802a47:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802a4c:	c9                   	leaveq 
  802a4d:	c3                   	retq   

0000000000802a4e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802a4e:	55                   	push   %rbp
  802a4f:	48 89 e5             	mov    %rsp,%rbp
  802a52:	48 83 ec 20          	sub    $0x20,%rsp
  802a56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802a5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a61:	78 06                	js     802a69 <fd_lookup+0x1b>
  802a63:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802a67:	7e 07                	jle    802a70 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a6e:	eb 6c                	jmp    802adc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802a70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a73:	48 98                	cltq   
  802a75:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a7b:	48 c1 e0 0c          	shl    $0xc,%rax
  802a7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802a83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a87:	48 89 c2             	mov    %rax,%rdx
  802a8a:	48 c1 ea 15          	shr    $0x15,%rdx
  802a8e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a95:	01 00 00 
  802a98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9c:	83 e0 01             	and    $0x1,%eax
  802a9f:	48 85 c0             	test   %rax,%rax
  802aa2:	74 21                	je     802ac5 <fd_lookup+0x77>
  802aa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa8:	48 89 c2             	mov    %rax,%rdx
  802aab:	48 c1 ea 0c          	shr    $0xc,%rdx
  802aaf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ab6:	01 00 00 
  802ab9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802abd:	83 e0 01             	and    $0x1,%eax
  802ac0:	48 85 c0             	test   %rax,%rax
  802ac3:	75 07                	jne    802acc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ac5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aca:	eb 10                	jmp    802adc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802acc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ad4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802ad7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802adc:	c9                   	leaveq 
  802add:	c3                   	retq   

0000000000802ade <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802ade:	55                   	push   %rbp
  802adf:	48 89 e5             	mov    %rsp,%rbp
  802ae2:	48 83 ec 30          	sub    $0x30,%rsp
  802ae6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802aea:	89 f0                	mov    %esi,%eax
  802aec:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802aef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802af3:	48 89 c7             	mov    %rax,%rdi
  802af6:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	callq  *%rax
  802b02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b06:	48 89 d6             	mov    %rdx,%rsi
  802b09:	89 c7                	mov    %eax,%edi
  802b0b:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
  802b17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1e:	78 0a                	js     802b2a <fd_close+0x4c>
	    || fd != fd2)
  802b20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b24:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b28:	74 12                	je     802b3c <fd_close+0x5e>
		return (must_exist ? r : 0);
  802b2a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802b2e:	74 05                	je     802b35 <fd_close+0x57>
  802b30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b33:	eb 05                	jmp    802b3a <fd_close+0x5c>
  802b35:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3a:	eb 69                	jmp    802ba5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802b3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b40:	8b 00                	mov    (%rax),%eax
  802b42:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b46:	48 89 d6             	mov    %rdx,%rsi
  802b49:	89 c7                	mov    %eax,%edi
  802b4b:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  802b52:	00 00 00 
  802b55:	ff d0                	callq  *%rax
  802b57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5e:	78 2a                	js     802b8a <fd_close+0xac>
		if (dev->dev_close)
  802b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b64:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b68:	48 85 c0             	test   %rax,%rax
  802b6b:	74 16                	je     802b83 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802b6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b71:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802b75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b79:	48 89 c7             	mov    %rax,%rdi
  802b7c:	ff d2                	callq  *%rdx
  802b7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b81:	eb 07                	jmp    802b8a <fd_close+0xac>
		else
			r = 0;
  802b83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802b8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b8e:	48 89 c6             	mov    %rax,%rsi
  802b91:	bf 00 00 00 00       	mov    $0x0,%edi
  802b96:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	callq  *%rax
	return r;
  802ba2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ba5:	c9                   	leaveq 
  802ba6:	c3                   	retq   

0000000000802ba7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ba7:	55                   	push   %rbp
  802ba8:	48 89 e5             	mov    %rsp,%rbp
  802bab:	48 83 ec 20          	sub    $0x20,%rsp
  802baf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802bb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bbd:	eb 41                	jmp    802c00 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802bbf:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802bc6:	00 00 00 
  802bc9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802bcc:	48 63 d2             	movslq %edx,%rdx
  802bcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bd3:	8b 00                	mov    (%rax),%eax
  802bd5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802bd8:	75 22                	jne    802bfc <dev_lookup+0x55>
			*dev = devtab[i];
  802bda:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802be1:	00 00 00 
  802be4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802be7:	48 63 d2             	movslq %edx,%rdx
  802bea:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802bee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfa:	eb 60                	jmp    802c5c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802bfc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c00:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c07:	00 00 00 
  802c0a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c0d:	48 63 d2             	movslq %edx,%rdx
  802c10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c14:	48 85 c0             	test   %rax,%rax
  802c17:	75 a6                	jne    802bbf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c19:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  802c20:	00 00 00 
  802c23:	48 8b 00             	mov    (%rax),%rax
  802c26:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c2c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c2f:	89 c6                	mov    %eax,%esi
  802c31:	48 bf 98 51 80 00 00 	movabs $0x805198,%rdi
  802c38:	00 00 00 
  802c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c40:	48 b9 67 08 80 00 00 	movabs $0x800867,%rcx
  802c47:	00 00 00 
  802c4a:	ff d1                	callq  *%rcx
	*dev = 0;
  802c4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c50:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802c57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802c5c:	c9                   	leaveq 
  802c5d:	c3                   	retq   

0000000000802c5e <close>:

int
close(int fdnum)
{
  802c5e:	55                   	push   %rbp
  802c5f:	48 89 e5             	mov    %rsp,%rbp
  802c62:	48 83 ec 20          	sub    $0x20,%rsp
  802c66:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c69:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c70:	48 89 d6             	mov    %rdx,%rsi
  802c73:	89 c7                	mov    %eax,%edi
  802c75:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  802c7c:	00 00 00 
  802c7f:	ff d0                	callq  *%rax
  802c81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c88:	79 05                	jns    802c8f <close+0x31>
		return r;
  802c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8d:	eb 18                	jmp    802ca7 <close+0x49>
	else
		return fd_close(fd, 1);
  802c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c93:	be 01 00 00 00       	mov    $0x1,%esi
  802c98:	48 89 c7             	mov    %rax,%rdi
  802c9b:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  802ca2:	00 00 00 
  802ca5:	ff d0                	callq  *%rax
}
  802ca7:	c9                   	leaveq 
  802ca8:	c3                   	retq   

0000000000802ca9 <close_all>:

void
close_all(void)
{
  802ca9:	55                   	push   %rbp
  802caa:	48 89 e5             	mov    %rsp,%rbp
  802cad:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802cb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cb8:	eb 15                	jmp    802ccf <close_all+0x26>
		close(i);
  802cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbd:	89 c7                	mov    %eax,%edi
  802cbf:	48 b8 5e 2c 80 00 00 	movabs $0x802c5e,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802ccb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ccf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802cd3:	7e e5                	jle    802cba <close_all+0x11>
		close(i);
}
  802cd5:	c9                   	leaveq 
  802cd6:	c3                   	retq   

0000000000802cd7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802cd7:	55                   	push   %rbp
  802cd8:	48 89 e5             	mov    %rsp,%rbp
  802cdb:	48 83 ec 40          	sub    $0x40,%rsp
  802cdf:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802ce2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802ce5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802ce9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802cec:	48 89 d6             	mov    %rdx,%rsi
  802cef:	89 c7                	mov    %eax,%edi
  802cf1:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d04:	79 08                	jns    802d0e <dup+0x37>
		return r;
  802d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d09:	e9 70 01 00 00       	jmpq   802e7e <dup+0x1a7>
	close(newfdnum);
  802d0e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	48 b8 5e 2c 80 00 00 	movabs $0x802c5e,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802d1f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d22:	48 98                	cltq   
  802d24:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d2a:	48 c1 e0 0c          	shl    $0xc,%rax
  802d2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802d32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d36:	48 89 c7             	mov    %rax,%rdi
  802d39:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  802d40:	00 00 00 
  802d43:	ff d0                	callq  *%rax
  802d45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4d:	48 89 c7             	mov    %rax,%rdi
  802d50:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  802d57:	00 00 00 
  802d5a:	ff d0                	callq  *%rax
  802d5c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d64:	48 89 c2             	mov    %rax,%rdx
  802d67:	48 c1 ea 15          	shr    $0x15,%rdx
  802d6b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802d72:	01 00 00 
  802d75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d79:	83 e0 01             	and    $0x1,%eax
  802d7c:	84 c0                	test   %al,%al
  802d7e:	74 71                	je     802df1 <dup+0x11a>
  802d80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d84:	48 89 c2             	mov    %rax,%rdx
  802d87:	48 c1 ea 0c          	shr    $0xc,%rdx
  802d8b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d92:	01 00 00 
  802d95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d99:	83 e0 01             	and    $0x1,%eax
  802d9c:	84 c0                	test   %al,%al
  802d9e:	74 51                	je     802df1 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802da0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da4:	48 89 c2             	mov    %rax,%rdx
  802da7:	48 c1 ea 0c          	shr    $0xc,%rdx
  802dab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802db2:	01 00 00 
  802db5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802db9:	89 c1                	mov    %eax,%ecx
  802dbb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802dc1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc9:	41 89 c8             	mov    %ecx,%r8d
  802dcc:	48 89 d1             	mov    %rdx,%rcx
  802dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd4:	48 89 c6             	mov    %rax,%rsi
  802dd7:	bf 00 00 00 00       	mov    $0x0,%edi
  802ddc:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  802de3:	00 00 00 
  802de6:	ff d0                	callq  *%rax
  802de8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802deb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802def:	78 56                	js     802e47 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802df1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df5:	48 89 c2             	mov    %rax,%rdx
  802df8:	48 c1 ea 0c          	shr    $0xc,%rdx
  802dfc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e03:	01 00 00 
  802e06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e0a:	89 c1                	mov    %eax,%ecx
  802e0c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802e12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e1a:	41 89 c8             	mov    %ecx,%r8d
  802e1d:	48 89 d1             	mov    %rdx,%rcx
  802e20:	ba 00 00 00 00       	mov    $0x0,%edx
  802e25:	48 89 c6             	mov    %rax,%rsi
  802e28:	bf 00 00 00 00       	mov    $0x0,%edi
  802e2d:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  802e34:	00 00 00 
  802e37:	ff d0                	callq  *%rax
  802e39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e40:	78 08                	js     802e4a <dup+0x173>
		goto err;

	return newfdnum;
  802e42:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e45:	eb 37                	jmp    802e7e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802e47:	90                   	nop
  802e48:	eb 01                	jmp    802e4b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802e4a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4f:	48 89 c6             	mov    %rax,%rsi
  802e52:	bf 00 00 00 00       	mov    $0x0,%edi
  802e57:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  802e5e:	00 00 00 
  802e61:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802e63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e67:	48 89 c6             	mov    %rax,%rsi
  802e6a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e6f:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
	return r;
  802e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e7e:	c9                   	leaveq 
  802e7f:	c3                   	retq   

0000000000802e80 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802e80:	55                   	push   %rbp
  802e81:	48 89 e5             	mov    %rsp,%rbp
  802e84:	48 83 ec 40          	sub    $0x40,%rsp
  802e88:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e8b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e8f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e93:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e97:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e9a:	48 89 d6             	mov    %rdx,%rsi
  802e9d:	89 c7                	mov    %eax,%edi
  802e9f:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	callq  *%rax
  802eab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb2:	78 24                	js     802ed8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb8:	8b 00                	mov    (%rax),%eax
  802eba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ebe:	48 89 d6             	mov    %rdx,%rsi
  802ec1:	89 c7                	mov    %eax,%edi
  802ec3:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  802eca:	00 00 00 
  802ecd:	ff d0                	callq  *%rax
  802ecf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed6:	79 05                	jns    802edd <read+0x5d>
		return r;
  802ed8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edb:	eb 7a                	jmp    802f57 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee1:	8b 40 08             	mov    0x8(%rax),%eax
  802ee4:	83 e0 03             	and    $0x3,%eax
  802ee7:	83 f8 01             	cmp    $0x1,%eax
  802eea:	75 3a                	jne    802f26 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802eec:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  802ef3:	00 00 00 
  802ef6:	48 8b 00             	mov    (%rax),%rax
  802ef9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802eff:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f02:	89 c6                	mov    %eax,%esi
  802f04:	48 bf b7 51 80 00 00 	movabs $0x8051b7,%rdi
  802f0b:	00 00 00 
  802f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f13:	48 b9 67 08 80 00 00 	movabs $0x800867,%rcx
  802f1a:	00 00 00 
  802f1d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f24:	eb 31                	jmp    802f57 <read+0xd7>
	}
	if (!dev->dev_read)
  802f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2a:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f2e:	48 85 c0             	test   %rax,%rax
  802f31:	75 07                	jne    802f3a <read+0xba>
		return -E_NOT_SUPP;
  802f33:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f38:	eb 1d                	jmp    802f57 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f46:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f4a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f4e:	48 89 ce             	mov    %rcx,%rsi
  802f51:	48 89 c7             	mov    %rax,%rdi
  802f54:	41 ff d0             	callq  *%r8
}
  802f57:	c9                   	leaveq 
  802f58:	c3                   	retq   

0000000000802f59 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802f59:	55                   	push   %rbp
  802f5a:	48 89 e5             	mov    %rsp,%rbp
  802f5d:	48 83 ec 30          	sub    $0x30,%rsp
  802f61:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f68:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f73:	eb 46                	jmp    802fbb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f78:	48 98                	cltq   
  802f7a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f7e:	48 29 c2             	sub    %rax,%rdx
  802f81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f84:	48 98                	cltq   
  802f86:	48 89 c1             	mov    %rax,%rcx
  802f89:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802f8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f90:	48 89 ce             	mov    %rcx,%rsi
  802f93:	89 c7                	mov    %eax,%edi
  802f95:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	callq  *%rax
  802fa1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802fa4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fa8:	79 05                	jns    802faf <readn+0x56>
			return m;
  802faa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fad:	eb 1d                	jmp    802fcc <readn+0x73>
		if (m == 0)
  802faf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fb3:	74 13                	je     802fc8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802fb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fb8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802fbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbe:	48 98                	cltq   
  802fc0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802fc4:	72 af                	jb     802f75 <readn+0x1c>
  802fc6:	eb 01                	jmp    802fc9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802fc8:	90                   	nop
	}
	return tot;
  802fc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fcc:	c9                   	leaveq 
  802fcd:	c3                   	retq   

0000000000802fce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802fce:	55                   	push   %rbp
  802fcf:	48 89 e5             	mov    %rsp,%rbp
  802fd2:	48 83 ec 40          	sub    $0x40,%rsp
  802fd6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fd9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fdd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fe1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fe5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fe8:	48 89 d6             	mov    %rdx,%rsi
  802feb:	89 c7                	mov    %eax,%edi
  802fed:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  802ff4:	00 00 00 
  802ff7:	ff d0                	callq  *%rax
  802ff9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803000:	78 24                	js     803026 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803006:	8b 00                	mov    (%rax),%eax
  803008:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80300c:	48 89 d6             	mov    %rdx,%rsi
  80300f:	89 c7                	mov    %eax,%edi
  803011:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  803018:	00 00 00 
  80301b:	ff d0                	callq  *%rax
  80301d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803020:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803024:	79 05                	jns    80302b <write+0x5d>
		return r;
  803026:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803029:	eb 79                	jmp    8030a4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80302b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302f:	8b 40 08             	mov    0x8(%rax),%eax
  803032:	83 e0 03             	and    $0x3,%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	75 3a                	jne    803073 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803039:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  803040:	00 00 00 
  803043:	48 8b 00             	mov    (%rax),%rax
  803046:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80304c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80304f:	89 c6                	mov    %eax,%esi
  803051:	48 bf d3 51 80 00 00 	movabs $0x8051d3,%rdi
  803058:	00 00 00 
  80305b:	b8 00 00 00 00       	mov    $0x0,%eax
  803060:	48 b9 67 08 80 00 00 	movabs $0x800867,%rcx
  803067:	00 00 00 
  80306a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80306c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803071:	eb 31                	jmp    8030a4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803077:	48 8b 40 18          	mov    0x18(%rax),%rax
  80307b:	48 85 c0             	test   %rax,%rax
  80307e:	75 07                	jne    803087 <write+0xb9>
		return -E_NOT_SUPP;
  803080:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803085:	eb 1d                	jmp    8030a4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  803087:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80308f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803093:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803097:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80309b:	48 89 ce             	mov    %rcx,%rsi
  80309e:	48 89 c7             	mov    %rax,%rdi
  8030a1:	41 ff d0             	callq  *%r8
}
  8030a4:	c9                   	leaveq 
  8030a5:	c3                   	retq   

00000000008030a6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8030a6:	55                   	push   %rbp
  8030a7:	48 89 e5             	mov    %rsp,%rbp
  8030aa:	48 83 ec 18          	sub    $0x18,%rsp
  8030ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030b4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030bb:	48 89 d6             	mov    %rdx,%rsi
  8030be:	89 c7                	mov    %eax,%edi
  8030c0:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
  8030cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d3:	79 05                	jns    8030da <seek+0x34>
		return r;
  8030d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d8:	eb 0f                	jmp    8030e9 <seek+0x43>
	fd->fd_offset = offset;
  8030da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030de:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030e1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8030e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e9:	c9                   	leaveq 
  8030ea:	c3                   	retq   

00000000008030eb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8030eb:	55                   	push   %rbp
  8030ec:	48 89 e5             	mov    %rsp,%rbp
  8030ef:	48 83 ec 30          	sub    $0x30,%rsp
  8030f3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030f6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030f9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030fd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803100:	48 89 d6             	mov    %rdx,%rsi
  803103:	89 c7                	mov    %eax,%edi
  803105:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
  803111:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803114:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803118:	78 24                	js     80313e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80311a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311e:	8b 00                	mov    (%rax),%eax
  803120:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803124:	48 89 d6             	mov    %rdx,%rsi
  803127:	89 c7                	mov    %eax,%edi
  803129:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  803130:	00 00 00 
  803133:	ff d0                	callq  *%rax
  803135:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803138:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313c:	79 05                	jns    803143 <ftruncate+0x58>
		return r;
  80313e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803141:	eb 72                	jmp    8031b5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803147:	8b 40 08             	mov    0x8(%rax),%eax
  80314a:	83 e0 03             	and    $0x3,%eax
  80314d:	85 c0                	test   %eax,%eax
  80314f:	75 3a                	jne    80318b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803151:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  803158:	00 00 00 
  80315b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80315e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803164:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803167:	89 c6                	mov    %eax,%esi
  803169:	48 bf f0 51 80 00 00 	movabs $0x8051f0,%rdi
  803170:	00 00 00 
  803173:	b8 00 00 00 00       	mov    $0x0,%eax
  803178:	48 b9 67 08 80 00 00 	movabs $0x800867,%rcx
  80317f:	00 00 00 
  803182:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803184:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803189:	eb 2a                	jmp    8031b5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80318b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803193:	48 85 c0             	test   %rax,%rax
  803196:	75 07                	jne    80319f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803198:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80319d:	eb 16                	jmp    8031b5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80319f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8031a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ab:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8031ae:	89 d6                	mov    %edx,%esi
  8031b0:	48 89 c7             	mov    %rax,%rdi
  8031b3:	ff d1                	callq  *%rcx
}
  8031b5:	c9                   	leaveq 
  8031b6:	c3                   	retq   

00000000008031b7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8031b7:	55                   	push   %rbp
  8031b8:	48 89 e5             	mov    %rsp,%rbp
  8031bb:	48 83 ec 30          	sub    $0x30,%rsp
  8031bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031cd:	48 89 d6             	mov    %rdx,%rsi
  8031d0:	89 c7                	mov    %eax,%edi
  8031d2:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
  8031de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e5:	78 24                	js     80320b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031eb:	8b 00                	mov    (%rax),%eax
  8031ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031f1:	48 89 d6             	mov    %rdx,%rsi
  8031f4:	89 c7                	mov    %eax,%edi
  8031f6:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  8031fd:	00 00 00 
  803200:	ff d0                	callq  *%rax
  803202:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803205:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803209:	79 05                	jns    803210 <fstat+0x59>
		return r;
  80320b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320e:	eb 5e                	jmp    80326e <fstat+0xb7>
	if (!dev->dev_stat)
  803210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803214:	48 8b 40 28          	mov    0x28(%rax),%rax
  803218:	48 85 c0             	test   %rax,%rax
  80321b:	75 07                	jne    803224 <fstat+0x6d>
		return -E_NOT_SUPP;
  80321d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803222:	eb 4a                	jmp    80326e <fstat+0xb7>
	stat->st_name[0] = 0;
  803224:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803228:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80322b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80322f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803236:	00 00 00 
	stat->st_isdir = 0;
  803239:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80323d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803244:	00 00 00 
	stat->st_dev = dev;
  803247:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80324b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80324f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80325e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803262:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803266:	48 89 d6             	mov    %rdx,%rsi
  803269:	48 89 c7             	mov    %rax,%rdi
  80326c:	ff d1                	callq  *%rcx
}
  80326e:	c9                   	leaveq 
  80326f:	c3                   	retq   

0000000000803270 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803270:	55                   	push   %rbp
  803271:	48 89 e5             	mov    %rsp,%rbp
  803274:	48 83 ec 20          	sub    $0x20,%rsp
  803278:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80327c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803284:	be 00 00 00 00       	mov    $0x0,%esi
  803289:	48 89 c7             	mov    %rax,%rdi
  80328c:	48 b8 5f 33 80 00 00 	movabs $0x80335f,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80329b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80329f:	79 05                	jns    8032a6 <stat+0x36>
		return fd;
  8032a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a4:	eb 2f                	jmp    8032d5 <stat+0x65>
	r = fstat(fd, stat);
  8032a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ad:	48 89 d6             	mov    %rdx,%rsi
  8032b0:	89 c7                	mov    %eax,%edi
  8032b2:	48 b8 b7 31 80 00 00 	movabs $0x8031b7,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8032c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c4:	89 c7                	mov    %eax,%edi
  8032c6:	48 b8 5e 2c 80 00 00 	movabs $0x802c5e,%rax
  8032cd:	00 00 00 
  8032d0:	ff d0                	callq  *%rax
	return r;
  8032d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8032d5:	c9                   	leaveq 
  8032d6:	c3                   	retq   
	...

00000000008032d8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8032d8:	55                   	push   %rbp
  8032d9:	48 89 e5             	mov    %rsp,%rbp
  8032dc:	48 83 ec 10          	sub    $0x10,%rsp
  8032e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8032e7:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  8032ee:	00 00 00 
  8032f1:	8b 00                	mov    (%rax),%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	75 1d                	jne    803314 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8032f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8032fc:	48 b8 e3 28 80 00 00 	movabs $0x8028e3,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
  803308:	48 ba 38 80 80 00 00 	movabs $0x808038,%rdx
  80330f:	00 00 00 
  803312:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803314:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  80331b:	00 00 00 
  80331e:	8b 00                	mov    (%rax),%eax
  803320:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803323:	b9 07 00 00 00       	mov    $0x7,%ecx
  803328:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80332f:	00 00 00 
  803332:	89 c7                	mov    %eax,%edi
  803334:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  80333b:	00 00 00 
  80333e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803344:	ba 00 00 00 00       	mov    $0x0,%edx
  803349:	48 89 c6             	mov    %rax,%rsi
  80334c:	bf 00 00 00 00       	mov    $0x0,%edi
  803351:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
}
  80335d:	c9                   	leaveq 
  80335e:	c3                   	retq   

000000000080335f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80335f:	55                   	push   %rbp
  803360:	48 89 e5             	mov    %rsp,%rbp
  803363:	48 83 ec 20          	sub    $0x20,%rsp
  803367:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80336b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80336e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803372:	48 89 c7             	mov    %rax,%rdi
  803375:	48 b8 b8 13 80 00 00 	movabs $0x8013b8,%rax
  80337c:	00 00 00 
  80337f:	ff d0                	callq  *%rax
  803381:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803386:	7e 0a                	jle    803392 <open+0x33>
                return -E_BAD_PATH;
  803388:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80338d:	e9 a5 00 00 00       	jmpq   803437 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  803392:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803396:	48 89 c7             	mov    %rax,%rdi
  803399:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  8033a0:	00 00 00 
  8033a3:	ff d0                	callq  *%rax
  8033a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ac:	79 08                	jns    8033b6 <open+0x57>
		return r;
  8033ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b1:	e9 81 00 00 00       	jmpq   803437 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8033b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ba:	48 89 c6             	mov    %rax,%rsi
  8033bd:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8033c4:	00 00 00 
  8033c7:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  8033ce:	00 00 00 
  8033d1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8033d3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033da:	00 00 00 
  8033dd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8033e0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8033e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ea:	48 89 c6             	mov    %rax,%rsi
  8033ed:	bf 01 00 00 00       	mov    $0x1,%edi
  8033f2:	48 b8 d8 32 80 00 00 	movabs $0x8032d8,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
  8033fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  803401:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803405:	79 1d                	jns    803424 <open+0xc5>
	{
		fd_close(fd,0);
  803407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340b:	be 00 00 00 00       	mov    $0x0,%esi
  803410:	48 89 c7             	mov    %rax,%rdi
  803413:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  80341a:	00 00 00 
  80341d:	ff d0                	callq  *%rax
		return r;
  80341f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803422:	eb 13                	jmp    803437 <open+0xd8>
	}
	return fd2num(fd);
  803424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803428:	48 89 c7             	mov    %rax,%rdi
  80342b:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
	


}
  803437:	c9                   	leaveq 
  803438:	c3                   	retq   

0000000000803439 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803439:	55                   	push   %rbp
  80343a:	48 89 e5             	mov    %rsp,%rbp
  80343d:	48 83 ec 10          	sub    $0x10,%rsp
  803441:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803449:	8b 50 0c             	mov    0xc(%rax),%edx
  80344c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803453:	00 00 00 
  803456:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803458:	be 00 00 00 00       	mov    $0x0,%esi
  80345d:	bf 06 00 00 00       	mov    $0x6,%edi
  803462:	48 b8 d8 32 80 00 00 	movabs $0x8032d8,%rax
  803469:	00 00 00 
  80346c:	ff d0                	callq  *%rax
}
  80346e:	c9                   	leaveq 
  80346f:	c3                   	retq   

0000000000803470 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803470:	55                   	push   %rbp
  803471:	48 89 e5             	mov    %rsp,%rbp
  803474:	48 83 ec 30          	sub    $0x30,%rsp
  803478:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80347c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803480:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803488:	8b 50 0c             	mov    0xc(%rax),%edx
  80348b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803492:	00 00 00 
  803495:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803497:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80349e:	00 00 00 
  8034a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034a5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8034a9:	be 00 00 00 00       	mov    $0x0,%esi
  8034ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8034b3:	48 b8 d8 32 80 00 00 	movabs $0x8032d8,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
  8034bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c6:	79 05                	jns    8034cd <devfile_read+0x5d>
	{
		return r;
  8034c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cb:	eb 2c                	jmp    8034f9 <devfile_read+0x89>
	}
	if(r > 0)
  8034cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d1:	7e 23                	jle    8034f6 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8034d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d6:	48 63 d0             	movslq %eax,%rdx
  8034d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034dd:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8034e4:	00 00 00 
  8034e7:	48 89 c7             	mov    %rax,%rdi
  8034ea:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
	return r;
  8034f6:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8034f9:	c9                   	leaveq 
  8034fa:	c3                   	retq   

00000000008034fb <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8034fb:	55                   	push   %rbp
  8034fc:	48 89 e5             	mov    %rsp,%rbp
  8034ff:	48 83 ec 30          	sub    $0x30,%rsp
  803503:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803507:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80350b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80350f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803513:	8b 50 0c             	mov    0xc(%rax),%edx
  803516:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80351d:	00 00 00 
  803520:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  803522:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803529:	00 
  80352a:	76 08                	jbe    803534 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  80352c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803533:	00 
	fsipcbuf.write.req_n=n;
  803534:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80353b:	00 00 00 
  80353e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803542:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803546:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80354a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80354e:	48 89 c6             	mov    %rax,%rsi
  803551:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803558:	00 00 00 
  80355b:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  803567:	be 00 00 00 00       	mov    $0x0,%esi
  80356c:	bf 04 00 00 00       	mov    $0x4,%edi
  803571:	48 b8 d8 32 80 00 00 	movabs $0x8032d8,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
  80357d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  803580:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803583:	c9                   	leaveq 
  803584:	c3                   	retq   

0000000000803585 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803585:	55                   	push   %rbp
  803586:	48 89 e5             	mov    %rsp,%rbp
  803589:	48 83 ec 10          	sub    $0x10,%rsp
  80358d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803591:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803598:	8b 50 0c             	mov    0xc(%rax),%edx
  80359b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035a2:	00 00 00 
  8035a5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8035a7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035ae:	00 00 00 
  8035b1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035b4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8035b7:	be 00 00 00 00       	mov    $0x0,%esi
  8035bc:	bf 02 00 00 00       	mov    $0x2,%edi
  8035c1:	48 b8 d8 32 80 00 00 	movabs $0x8032d8,%rax
  8035c8:	00 00 00 
  8035cb:	ff d0                	callq  *%rax
}
  8035cd:	c9                   	leaveq 
  8035ce:	c3                   	retq   

00000000008035cf <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8035cf:	55                   	push   %rbp
  8035d0:	48 89 e5             	mov    %rsp,%rbp
  8035d3:	48 83 ec 20          	sub    $0x20,%rsp
  8035d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8035df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8035e6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035ed:	00 00 00 
  8035f0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8035f2:	be 00 00 00 00       	mov    $0x0,%esi
  8035f7:	bf 05 00 00 00       	mov    $0x5,%edi
  8035fc:	48 b8 d8 32 80 00 00 	movabs $0x8032d8,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
  803608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80360b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80360f:	79 05                	jns    803616 <devfile_stat+0x47>
		return r;
  803611:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803614:	eb 56                	jmp    80366c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80361a:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803621:	00 00 00 
  803624:	48 89 c7             	mov    %rax,%rdi
  803627:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  80362e:	00 00 00 
  803631:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803633:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80363a:	00 00 00 
  80363d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803643:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803647:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80364d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803654:	00 00 00 
  803657:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80365d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803661:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80366c:	c9                   	leaveq 
  80366d:	c3                   	retq   
	...

0000000000803670 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803670:	55                   	push   %rbp
  803671:	48 89 e5             	mov    %rsp,%rbp
  803674:	48 83 ec 20          	sub    $0x20,%rsp
  803678:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80367b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80367f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803682:	48 89 d6             	mov    %rdx,%rsi
  803685:	89 c7                	mov    %eax,%edi
  803687:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  80368e:	00 00 00 
  803691:	ff d0                	callq  *%rax
  803693:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803696:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369a:	79 05                	jns    8036a1 <fd2sockid+0x31>
		return r;
  80369c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369f:	eb 24                	jmp    8036c5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8036a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a5:	8b 10                	mov    (%rax),%edx
  8036a7:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8036ae:	00 00 00 
  8036b1:	8b 00                	mov    (%rax),%eax
  8036b3:	39 c2                	cmp    %eax,%edx
  8036b5:	74 07                	je     8036be <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8036b7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8036bc:	eb 07                	jmp    8036c5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8036be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8036c5:	c9                   	leaveq 
  8036c6:	c3                   	retq   

00000000008036c7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8036c7:	55                   	push   %rbp
  8036c8:	48 89 e5             	mov    %rsp,%rbp
  8036cb:	48 83 ec 20          	sub    $0x20,%rsp
  8036cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8036d2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036d6:	48 89 c7             	mov    %rax,%rdi
  8036d9:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  8036e0:	00 00 00 
  8036e3:	ff d0                	callq  *%rax
  8036e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ec:	78 26                	js     803714 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8036ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f2:	ba 07 04 00 00       	mov    $0x407,%edx
  8036f7:	48 89 c6             	mov    %rax,%rsi
  8036fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ff:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  803706:	00 00 00 
  803709:	ff d0                	callq  *%rax
  80370b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80370e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803712:	79 16                	jns    80372a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803714:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803717:	89 c7                	mov    %eax,%edi
  803719:	48 b8 d4 3b 80 00 00 	movabs $0x803bd4,%rax
  803720:	00 00 00 
  803723:	ff d0                	callq  *%rax
		return r;
  803725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803728:	eb 3a                	jmp    803764 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80372a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372e:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803735:	00 00 00 
  803738:	8b 12                	mov    (%rdx),%edx
  80373a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80373c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803740:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80374e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803755:	48 89 c7             	mov    %rax,%rdi
  803758:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  80375f:	00 00 00 
  803762:	ff d0                	callq  *%rax
}
  803764:	c9                   	leaveq 
  803765:	c3                   	retq   

0000000000803766 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803766:	55                   	push   %rbp
  803767:	48 89 e5             	mov    %rsp,%rbp
  80376a:	48 83 ec 30          	sub    $0x30,%rsp
  80376e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803771:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803775:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803779:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377c:	89 c7                	mov    %eax,%edi
  80377e:	48 b8 70 36 80 00 00 	movabs $0x803670,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
  80378a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80378d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803791:	79 05                	jns    803798 <accept+0x32>
		return r;
  803793:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803796:	eb 3b                	jmp    8037d3 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803798:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80379c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a3:	48 89 ce             	mov    %rcx,%rsi
  8037a6:	89 c7                	mov    %eax,%edi
  8037a8:	48 b8 b1 3a 80 00 00 	movabs $0x803ab1,%rax
  8037af:	00 00 00 
  8037b2:	ff d0                	callq  *%rax
  8037b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037bb:	79 05                	jns    8037c2 <accept+0x5c>
		return r;
  8037bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c0:	eb 11                	jmp    8037d3 <accept+0x6d>
	return alloc_sockfd(r);
  8037c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c5:	89 c7                	mov    %eax,%edi
  8037c7:	48 b8 c7 36 80 00 00 	movabs $0x8036c7,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
}
  8037d3:	c9                   	leaveq 
  8037d4:	c3                   	retq   

00000000008037d5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037d5:	55                   	push   %rbp
  8037d6:	48 89 e5             	mov    %rsp,%rbp
  8037d9:	48 83 ec 20          	sub    $0x20,%rsp
  8037dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037e4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ea:	89 c7                	mov    %eax,%edi
  8037ec:	48 b8 70 36 80 00 00 	movabs $0x803670,%rax
  8037f3:	00 00 00 
  8037f6:	ff d0                	callq  *%rax
  8037f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ff:	79 05                	jns    803806 <bind+0x31>
		return r;
  803801:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803804:	eb 1b                	jmp    803821 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803806:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803809:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80380d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803810:	48 89 ce             	mov    %rcx,%rsi
  803813:	89 c7                	mov    %eax,%edi
  803815:	48 b8 30 3b 80 00 00 	movabs $0x803b30,%rax
  80381c:	00 00 00 
  80381f:	ff d0                	callq  *%rax
}
  803821:	c9                   	leaveq 
  803822:	c3                   	retq   

0000000000803823 <shutdown>:

int
shutdown(int s, int how)
{
  803823:	55                   	push   %rbp
  803824:	48 89 e5             	mov    %rsp,%rbp
  803827:	48 83 ec 20          	sub    $0x20,%rsp
  80382b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80382e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803831:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803834:	89 c7                	mov    %eax,%edi
  803836:	48 b8 70 36 80 00 00 	movabs $0x803670,%rax
  80383d:	00 00 00 
  803840:	ff d0                	callq  *%rax
  803842:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803845:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803849:	79 05                	jns    803850 <shutdown+0x2d>
		return r;
  80384b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384e:	eb 16                	jmp    803866 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803850:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803856:	89 d6                	mov    %edx,%esi
  803858:	89 c7                	mov    %eax,%edi
  80385a:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
}
  803866:	c9                   	leaveq 
  803867:	c3                   	retq   

0000000000803868 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803868:	55                   	push   %rbp
  803869:	48 89 e5             	mov    %rsp,%rbp
  80386c:	48 83 ec 10          	sub    $0x10,%rsp
  803870:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803878:	48 89 c7             	mov    %rax,%rdi
  80387b:	48 b8 48 48 80 00 00 	movabs $0x804848,%rax
  803882:	00 00 00 
  803885:	ff d0                	callq  *%rax
  803887:	83 f8 01             	cmp    $0x1,%eax
  80388a:	75 17                	jne    8038a3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80388c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803890:	8b 40 0c             	mov    0xc(%rax),%eax
  803893:	89 c7                	mov    %eax,%edi
  803895:	48 b8 d4 3b 80 00 00 	movabs $0x803bd4,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
  8038a1:	eb 05                	jmp    8038a8 <devsock_close+0x40>
	else
		return 0;
  8038a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038a8:	c9                   	leaveq 
  8038a9:	c3                   	retq   

00000000008038aa <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038aa:	55                   	push   %rbp
  8038ab:	48 89 e5             	mov    %rsp,%rbp
  8038ae:	48 83 ec 20          	sub    $0x20,%rsp
  8038b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038b9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038bf:	89 c7                	mov    %eax,%edi
  8038c1:	48 b8 70 36 80 00 00 	movabs $0x803670,%rax
  8038c8:	00 00 00 
  8038cb:	ff d0                	callq  *%rax
  8038cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d4:	79 05                	jns    8038db <connect+0x31>
		return r;
  8038d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d9:	eb 1b                	jmp    8038f6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8038db:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038de:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e5:	48 89 ce             	mov    %rcx,%rsi
  8038e8:	89 c7                	mov    %eax,%edi
  8038ea:	48 b8 01 3c 80 00 00 	movabs $0x803c01,%rax
  8038f1:	00 00 00 
  8038f4:	ff d0                	callq  *%rax
}
  8038f6:	c9                   	leaveq 
  8038f7:	c3                   	retq   

00000000008038f8 <listen>:

int
listen(int s, int backlog)
{
  8038f8:	55                   	push   %rbp
  8038f9:	48 89 e5             	mov    %rsp,%rbp
  8038fc:	48 83 ec 20          	sub    $0x20,%rsp
  803900:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803903:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803906:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803909:	89 c7                	mov    %eax,%edi
  80390b:	48 b8 70 36 80 00 00 	movabs $0x803670,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
  803917:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80391a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391e:	79 05                	jns    803925 <listen+0x2d>
		return r;
  803920:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803923:	eb 16                	jmp    80393b <listen+0x43>
	return nsipc_listen(r, backlog);
  803925:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392b:	89 d6                	mov    %edx,%esi
  80392d:	89 c7                	mov    %eax,%edi
  80392f:	48 b8 65 3c 80 00 00 	movabs $0x803c65,%rax
  803936:	00 00 00 
  803939:	ff d0                	callq  *%rax
}
  80393b:	c9                   	leaveq 
  80393c:	c3                   	retq   

000000000080393d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80393d:	55                   	push   %rbp
  80393e:	48 89 e5             	mov    %rsp,%rbp
  803941:	48 83 ec 20          	sub    $0x20,%rsp
  803945:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803949:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80394d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803955:	89 c2                	mov    %eax,%edx
  803957:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395b:	8b 40 0c             	mov    0xc(%rax),%eax
  80395e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803962:	b9 00 00 00 00       	mov    $0x0,%ecx
  803967:	89 c7                	mov    %eax,%edi
  803969:	48 b8 a5 3c 80 00 00 	movabs $0x803ca5,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
}
  803975:	c9                   	leaveq 
  803976:	c3                   	retq   

0000000000803977 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803977:	55                   	push   %rbp
  803978:	48 89 e5             	mov    %rsp,%rbp
  80397b:	48 83 ec 20          	sub    $0x20,%rsp
  80397f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803983:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803987:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80398b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80398f:	89 c2                	mov    %eax,%edx
  803991:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803995:	8b 40 0c             	mov    0xc(%rax),%eax
  803998:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80399c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039a1:	89 c7                	mov    %eax,%edi
  8039a3:	48 b8 71 3d 80 00 00 	movabs $0x803d71,%rax
  8039aa:	00 00 00 
  8039ad:	ff d0                	callq  *%rax
}
  8039af:	c9                   	leaveq 
  8039b0:	c3                   	retq   

00000000008039b1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8039b1:	55                   	push   %rbp
  8039b2:	48 89 e5             	mov    %rsp,%rbp
  8039b5:	48 83 ec 10          	sub    $0x10,%rsp
  8039b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8039c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c5:	48 be 1b 52 80 00 00 	movabs $0x80521b,%rsi
  8039cc:	00 00 00 
  8039cf:	48 89 c7             	mov    %rax,%rdi
  8039d2:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  8039d9:	00 00 00 
  8039dc:	ff d0                	callq  *%rax
	return 0;
  8039de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039e3:	c9                   	leaveq 
  8039e4:	c3                   	retq   

00000000008039e5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8039e5:	55                   	push   %rbp
  8039e6:	48 89 e5             	mov    %rsp,%rbp
  8039e9:	48 83 ec 20          	sub    $0x20,%rsp
  8039ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039f0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8039f3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8039f6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8039f9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039ff:	89 ce                	mov    %ecx,%esi
  803a01:	89 c7                	mov    %eax,%edi
  803a03:	48 b8 29 3e 80 00 00 	movabs $0x803e29,%rax
  803a0a:	00 00 00 
  803a0d:	ff d0                	callq  *%rax
  803a0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a16:	79 05                	jns    803a1d <socket+0x38>
		return r;
  803a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a1b:	eb 11                	jmp    803a2e <socket+0x49>
	return alloc_sockfd(r);
  803a1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a20:	89 c7                	mov    %eax,%edi
  803a22:	48 b8 c7 36 80 00 00 	movabs $0x8036c7,%rax
  803a29:	00 00 00 
  803a2c:	ff d0                	callq  *%rax
}
  803a2e:	c9                   	leaveq 
  803a2f:	c3                   	retq   

0000000000803a30 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a30:	55                   	push   %rbp
  803a31:	48 89 e5             	mov    %rsp,%rbp
  803a34:	48 83 ec 10          	sub    $0x10,%rsp
  803a38:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803a3b:	48 b8 44 80 80 00 00 	movabs $0x808044,%rax
  803a42:	00 00 00 
  803a45:	8b 00                	mov    (%rax),%eax
  803a47:	85 c0                	test   %eax,%eax
  803a49:	75 1d                	jne    803a68 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a4b:	bf 02 00 00 00       	mov    $0x2,%edi
  803a50:	48 b8 e3 28 80 00 00 	movabs $0x8028e3,%rax
  803a57:	00 00 00 
  803a5a:	ff d0                	callq  *%rax
  803a5c:	48 ba 44 80 80 00 00 	movabs $0x808044,%rdx
  803a63:	00 00 00 
  803a66:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a68:	48 b8 44 80 80 00 00 	movabs $0x808044,%rax
  803a6f:	00 00 00 
  803a72:	8b 00                	mov    (%rax),%eax
  803a74:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a77:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a7c:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a83:	00 00 00 
  803a86:	89 c7                	mov    %eax,%edi
  803a88:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  803a8f:	00 00 00 
  803a92:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803a94:	ba 00 00 00 00       	mov    $0x0,%edx
  803a99:	be 00 00 00 00       	mov    $0x0,%esi
  803a9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa3:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
}
  803aaf:	c9                   	leaveq 
  803ab0:	c3                   	retq   

0000000000803ab1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ab1:	55                   	push   %rbp
  803ab2:	48 89 e5             	mov    %rsp,%rbp
  803ab5:	48 83 ec 30          	sub    $0x30,%rsp
  803ab9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803abc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ac0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803ac4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803acb:	00 00 00 
  803ace:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ad1:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803ad3:	bf 01 00 00 00       	mov    $0x1,%edi
  803ad8:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803adf:	00 00 00 
  803ae2:	ff d0                	callq  *%rax
  803ae4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aeb:	78 3e                	js     803b2b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803aed:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803af4:	00 00 00 
  803af7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aff:	8b 40 10             	mov    0x10(%rax),%eax
  803b02:	89 c2                	mov    %eax,%edx
  803b04:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0c:	48 89 ce             	mov    %rcx,%rsi
  803b0f:	48 89 c7             	mov    %rax,%rdi
  803b12:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803b19:	00 00 00 
  803b1c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b22:	8b 50 10             	mov    0x10(%rax),%edx
  803b25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b29:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b2e:	c9                   	leaveq 
  803b2f:	c3                   	retq   

0000000000803b30 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b30:	55                   	push   %rbp
  803b31:	48 89 e5             	mov    %rsp,%rbp
  803b34:	48 83 ec 10          	sub    $0x10,%rsp
  803b38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b3f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803b42:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b49:	00 00 00 
  803b4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b4f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b51:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b58:	48 89 c6             	mov    %rax,%rsi
  803b5b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b62:	00 00 00 
  803b65:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803b6c:	00 00 00 
  803b6f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b71:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b78:	00 00 00 
  803b7b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b7e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b81:	bf 02 00 00 00       	mov    $0x2,%edi
  803b86:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
}
  803b92:	c9                   	leaveq 
  803b93:	c3                   	retq   

0000000000803b94 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b94:	55                   	push   %rbp
  803b95:	48 89 e5             	mov    %rsp,%rbp
  803b98:	48 83 ec 10          	sub    $0x10,%rsp
  803b9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b9f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803ba2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ba9:	00 00 00 
  803bac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803baf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803bb1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb8:	00 00 00 
  803bbb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bbe:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803bc1:	bf 03 00 00 00       	mov    $0x3,%edi
  803bc6:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803bcd:	00 00 00 
  803bd0:	ff d0                	callq  *%rax
}
  803bd2:	c9                   	leaveq 
  803bd3:	c3                   	retq   

0000000000803bd4 <nsipc_close>:

int
nsipc_close(int s)
{
  803bd4:	55                   	push   %rbp
  803bd5:	48 89 e5             	mov    %rsp,%rbp
  803bd8:	48 83 ec 10          	sub    $0x10,%rsp
  803bdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803bdf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be6:	00 00 00 
  803be9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bec:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803bee:	bf 04 00 00 00       	mov    $0x4,%edi
  803bf3:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803bfa:	00 00 00 
  803bfd:	ff d0                	callq  *%rax
}
  803bff:	c9                   	leaveq 
  803c00:	c3                   	retq   

0000000000803c01 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c01:	55                   	push   %rbp
  803c02:	48 89 e5             	mov    %rsp,%rbp
  803c05:	48 83 ec 10          	sub    $0x10,%rsp
  803c09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c10:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c13:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c1a:	00 00 00 
  803c1d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c20:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c22:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c29:	48 89 c6             	mov    %rax,%rsi
  803c2c:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c33:	00 00 00 
  803c36:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803c3d:	00 00 00 
  803c40:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803c42:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c49:	00 00 00 
  803c4c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c4f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803c52:	bf 05 00 00 00       	mov    $0x5,%edi
  803c57:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803c5e:	00 00 00 
  803c61:	ff d0                	callq  *%rax
}
  803c63:	c9                   	leaveq 
  803c64:	c3                   	retq   

0000000000803c65 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c65:	55                   	push   %rbp
  803c66:	48 89 e5             	mov    %rsp,%rbp
  803c69:	48 83 ec 10          	sub    $0x10,%rsp
  803c6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c70:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c73:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7a:	00 00 00 
  803c7d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c80:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c89:	00 00 00 
  803c8c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c8f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c92:	bf 06 00 00 00       	mov    $0x6,%edi
  803c97:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
}
  803ca3:	c9                   	leaveq 
  803ca4:	c3                   	retq   

0000000000803ca5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803ca5:	55                   	push   %rbp
  803ca6:	48 89 e5             	mov    %rsp,%rbp
  803ca9:	48 83 ec 30          	sub    $0x30,%rsp
  803cad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cb4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803cb7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803cba:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cc1:	00 00 00 
  803cc4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cc7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803cc9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cd0:	00 00 00 
  803cd3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cd6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803cd9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce0:	00 00 00 
  803ce3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ce6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ce9:	bf 07 00 00 00       	mov    $0x7,%edi
  803cee:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
  803cfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d01:	78 69                	js     803d6c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d03:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d0a:	7f 08                	jg     803d14 <nsipc_recv+0x6f>
  803d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d0f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d12:	7e 35                	jle    803d49 <nsipc_recv+0xa4>
  803d14:	48 b9 22 52 80 00 00 	movabs $0x805222,%rcx
  803d1b:	00 00 00 
  803d1e:	48 ba 37 52 80 00 00 	movabs $0x805237,%rdx
  803d25:	00 00 00 
  803d28:	be 61 00 00 00       	mov    $0x61,%esi
  803d2d:	48 bf 4c 52 80 00 00 	movabs $0x80524c,%rdi
  803d34:	00 00 00 
  803d37:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3c:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  803d43:	00 00 00 
  803d46:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4c:	48 63 d0             	movslq %eax,%rdx
  803d4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d53:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803d5a:	00 00 00 
  803d5d:	48 89 c7             	mov    %rax,%rdi
  803d60:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803d67:	00 00 00 
  803d6a:	ff d0                	callq  *%rax
	}

	return r;
  803d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d6f:	c9                   	leaveq 
  803d70:	c3                   	retq   

0000000000803d71 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d71:	55                   	push   %rbp
  803d72:	48 89 e5             	mov    %rsp,%rbp
  803d75:	48 83 ec 20          	sub    $0x20,%rsp
  803d79:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d80:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d83:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d8d:	00 00 00 
  803d90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d93:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803d95:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803d9c:	7e 35                	jle    803dd3 <nsipc_send+0x62>
  803d9e:	48 b9 58 52 80 00 00 	movabs $0x805258,%rcx
  803da5:	00 00 00 
  803da8:	48 ba 37 52 80 00 00 	movabs $0x805237,%rdx
  803daf:	00 00 00 
  803db2:	be 6c 00 00 00       	mov    $0x6c,%esi
  803db7:	48 bf 4c 52 80 00 00 	movabs $0x80524c,%rdi
  803dbe:	00 00 00 
  803dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc6:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  803dcd:	00 00 00 
  803dd0:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803dd3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dd6:	48 63 d0             	movslq %eax,%rdx
  803dd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ddd:	48 89 c6             	mov    %rax,%rsi
  803de0:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803de7:	00 00 00 
  803dea:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803df6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dfd:	00 00 00 
  803e00:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e03:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e0d:	00 00 00 
  803e10:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e13:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e16:	bf 08 00 00 00       	mov    $0x8,%edi
  803e1b:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803e22:	00 00 00 
  803e25:	ff d0                	callq  *%rax
}
  803e27:	c9                   	leaveq 
  803e28:	c3                   	retq   

0000000000803e29 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e29:	55                   	push   %rbp
  803e2a:	48 89 e5             	mov    %rsp,%rbp
  803e2d:	48 83 ec 10          	sub    $0x10,%rsp
  803e31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e34:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803e37:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803e3a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e41:	00 00 00 
  803e44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e47:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803e49:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e50:	00 00 00 
  803e53:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e56:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803e59:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e60:	00 00 00 
  803e63:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e66:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e69:	bf 09 00 00 00       	mov    $0x9,%edi
  803e6e:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803e75:	00 00 00 
  803e78:	ff d0                	callq  *%rax
}
  803e7a:	c9                   	leaveq 
  803e7b:	c3                   	retq   

0000000000803e7c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e7c:	55                   	push   %rbp
  803e7d:	48 89 e5             	mov    %rsp,%rbp
  803e80:	53                   	push   %rbx
  803e81:	48 83 ec 38          	sub    $0x38,%rsp
  803e85:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e89:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e8d:	48 89 c7             	mov    %rax,%rdi
  803e90:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  803e97:	00 00 00 
  803e9a:	ff d0                	callq  *%rax
  803e9c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ea3:	0f 88 bf 01 00 00    	js     804068 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ea9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ead:	ba 07 04 00 00       	mov    $0x407,%edx
  803eb2:	48 89 c6             	mov    %rax,%rsi
  803eb5:	bf 00 00 00 00       	mov    $0x0,%edi
  803eba:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  803ec1:	00 00 00 
  803ec4:	ff d0                	callq  *%rax
  803ec6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ec9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ecd:	0f 88 95 01 00 00    	js     804068 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803ed3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ed7:	48 89 c7             	mov    %rax,%rdi
  803eda:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  803ee1:	00 00 00 
  803ee4:	ff d0                	callq  *%rax
  803ee6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ee9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eed:	0f 88 5d 01 00 00    	js     804050 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ef3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ef7:	ba 07 04 00 00       	mov    $0x407,%edx
  803efc:	48 89 c6             	mov    %rax,%rsi
  803eff:	bf 00 00 00 00       	mov    $0x0,%edi
  803f04:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  803f0b:	00 00 00 
  803f0e:	ff d0                	callq  *%rax
  803f10:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f13:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f17:	0f 88 33 01 00 00    	js     804050 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f21:	48 89 c7             	mov    %rax,%rdi
  803f24:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  803f2b:	00 00 00 
  803f2e:	ff d0                	callq  *%rax
  803f30:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f38:	ba 07 04 00 00       	mov    $0x407,%edx
  803f3d:	48 89 c6             	mov    %rax,%rsi
  803f40:	bf 00 00 00 00       	mov    $0x0,%edi
  803f45:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
  803f51:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f54:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f58:	0f 88 d9 00 00 00    	js     804037 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f62:	48 89 c7             	mov    %rax,%rdi
  803f65:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  803f6c:	00 00 00 
  803f6f:	ff d0                	callq  *%rax
  803f71:	48 89 c2             	mov    %rax,%rdx
  803f74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f78:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f7e:	48 89 d1             	mov    %rdx,%rcx
  803f81:	ba 00 00 00 00       	mov    $0x0,%edx
  803f86:	48 89 c6             	mov    %rax,%rsi
  803f89:	bf 00 00 00 00       	mov    $0x0,%edi
  803f8e:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  803f95:	00 00 00 
  803f98:	ff d0                	callq  *%rax
  803f9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fa1:	78 79                	js     80401c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803fa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa7:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fae:	00 00 00 
  803fb1:	8b 12                	mov    (%rdx),%edx
  803fb3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803fb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803fc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fc4:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fcb:	00 00 00 
  803fce:	8b 12                	mov    (%rdx),%edx
  803fd0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803fd2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803fdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe1:	48 89 c7             	mov    %rax,%rdi
  803fe4:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  803feb:	00 00 00 
  803fee:	ff d0                	callq  *%rax
  803ff0:	89 c2                	mov    %eax,%edx
  803ff2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ff6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803ff8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ffc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804000:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804004:	48 89 c7             	mov    %rax,%rdi
  804007:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  80400e:	00 00 00 
  804011:	ff d0                	callq  *%rax
  804013:	89 03                	mov    %eax,(%rbx)
	return 0;
  804015:	b8 00 00 00 00       	mov    $0x0,%eax
  80401a:	eb 4f                	jmp    80406b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80401c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80401d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804021:	48 89 c6             	mov    %rax,%rsi
  804024:	bf 00 00 00 00       	mov    $0x0,%edi
  804029:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  804030:	00 00 00 
  804033:	ff d0                	callq  *%rax
  804035:	eb 01                	jmp    804038 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804037:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  804038:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80403c:	48 89 c6             	mov    %rax,%rsi
  80403f:	bf 00 00 00 00       	mov    $0x0,%edi
  804044:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  80404b:	00 00 00 
  80404e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  804050:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804054:	48 89 c6             	mov    %rax,%rsi
  804057:	bf 00 00 00 00       	mov    $0x0,%edi
  80405c:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  804063:	00 00 00 
  804066:	ff d0                	callq  *%rax
    err:
	return r;
  804068:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80406b:	48 83 c4 38          	add    $0x38,%rsp
  80406f:	5b                   	pop    %rbx
  804070:	5d                   	pop    %rbp
  804071:	c3                   	retq   

0000000000804072 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804072:	55                   	push   %rbp
  804073:	48 89 e5             	mov    %rsp,%rbp
  804076:	53                   	push   %rbx
  804077:	48 83 ec 28          	sub    $0x28,%rsp
  80407b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80407f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804083:	eb 01                	jmp    804086 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  804085:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804086:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  80408d:	00 00 00 
  804090:	48 8b 00             	mov    (%rax),%rax
  804093:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804099:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80409c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a0:	48 89 c7             	mov    %rax,%rdi
  8040a3:	48 b8 48 48 80 00 00 	movabs $0x804848,%rax
  8040aa:	00 00 00 
  8040ad:	ff d0                	callq  *%rax
  8040af:	89 c3                	mov    %eax,%ebx
  8040b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040b5:	48 89 c7             	mov    %rax,%rdi
  8040b8:	48 b8 48 48 80 00 00 	movabs $0x804848,%rax
  8040bf:	00 00 00 
  8040c2:	ff d0                	callq  *%rax
  8040c4:	39 c3                	cmp    %eax,%ebx
  8040c6:	0f 94 c0             	sete   %al
  8040c9:	0f b6 c0             	movzbl %al,%eax
  8040cc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8040cf:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8040d6:	00 00 00 
  8040d9:	48 8b 00             	mov    (%rax),%rax
  8040dc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8040e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040e8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040eb:	75 0a                	jne    8040f7 <_pipeisclosed+0x85>
			return ret;
  8040ed:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8040f0:	48 83 c4 28          	add    $0x28,%rsp
  8040f4:	5b                   	pop    %rbx
  8040f5:	5d                   	pop    %rbp
  8040f6:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8040f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040fa:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040fd:	74 86                	je     804085 <_pipeisclosed+0x13>
  8040ff:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804103:	75 80                	jne    804085 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804105:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  80410c:	00 00 00 
  80410f:	48 8b 00             	mov    (%rax),%rax
  804112:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804118:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80411b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80411e:	89 c6                	mov    %eax,%esi
  804120:	48 bf 69 52 80 00 00 	movabs $0x805269,%rdi
  804127:	00 00 00 
  80412a:	b8 00 00 00 00       	mov    $0x0,%eax
  80412f:	49 b8 67 08 80 00 00 	movabs $0x800867,%r8
  804136:	00 00 00 
  804139:	41 ff d0             	callq  *%r8
	}
  80413c:	e9 44 ff ff ff       	jmpq   804085 <_pipeisclosed+0x13>

0000000000804141 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804141:	55                   	push   %rbp
  804142:	48 89 e5             	mov    %rsp,%rbp
  804145:	48 83 ec 30          	sub    $0x30,%rsp
  804149:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80414c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804150:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804153:	48 89 d6             	mov    %rdx,%rsi
  804156:	89 c7                	mov    %eax,%edi
  804158:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  80415f:	00 00 00 
  804162:	ff d0                	callq  *%rax
  804164:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804167:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80416b:	79 05                	jns    804172 <pipeisclosed+0x31>
		return r;
  80416d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804170:	eb 31                	jmp    8041a3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804176:	48 89 c7             	mov    %rax,%rdi
  804179:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  804180:	00 00 00 
  804183:	ff d0                	callq  *%rax
  804185:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80418d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804191:	48 89 d6             	mov    %rdx,%rsi
  804194:	48 89 c7             	mov    %rax,%rdi
  804197:	48 b8 72 40 80 00 00 	movabs $0x804072,%rax
  80419e:	00 00 00 
  8041a1:	ff d0                	callq  *%rax
}
  8041a3:	c9                   	leaveq 
  8041a4:	c3                   	retq   

00000000008041a5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041a5:	55                   	push   %rbp
  8041a6:	48 89 e5             	mov    %rsp,%rbp
  8041a9:	48 83 ec 40          	sub    $0x40,%rsp
  8041ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8041b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041bd:	48 89 c7             	mov    %rax,%rdi
  8041c0:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  8041c7:	00 00 00 
  8041ca:	ff d0                	callq  *%rax
  8041cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041d8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041df:	00 
  8041e0:	e9 97 00 00 00       	jmpq   80427c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8041e5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8041ea:	74 09                	je     8041f5 <devpipe_read+0x50>
				return i;
  8041ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041f0:	e9 95 00 00 00       	jmpq   80428a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8041f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041fd:	48 89 d6             	mov    %rdx,%rsi
  804200:	48 89 c7             	mov    %rax,%rdi
  804203:	48 b8 72 40 80 00 00 	movabs $0x804072,%rax
  80420a:	00 00 00 
  80420d:	ff d0                	callq  *%rax
  80420f:	85 c0                	test   %eax,%eax
  804211:	74 07                	je     80421a <devpipe_read+0x75>
				return 0;
  804213:	b8 00 00 00 00       	mov    $0x0,%eax
  804218:	eb 70                	jmp    80428a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80421a:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  804221:	00 00 00 
  804224:	ff d0                	callq  *%rax
  804226:	eb 01                	jmp    804229 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804228:	90                   	nop
  804229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80422d:	8b 10                	mov    (%rax),%edx
  80422f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804233:	8b 40 04             	mov    0x4(%rax),%eax
  804236:	39 c2                	cmp    %eax,%edx
  804238:	74 ab                	je     8041e5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80423a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80423e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804242:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424a:	8b 00                	mov    (%rax),%eax
  80424c:	89 c2                	mov    %eax,%edx
  80424e:	c1 fa 1f             	sar    $0x1f,%edx
  804251:	c1 ea 1b             	shr    $0x1b,%edx
  804254:	01 d0                	add    %edx,%eax
  804256:	83 e0 1f             	and    $0x1f,%eax
  804259:	29 d0                	sub    %edx,%eax
  80425b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80425f:	48 98                	cltq   
  804261:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804266:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80426c:	8b 00                	mov    (%rax),%eax
  80426e:	8d 50 01             	lea    0x1(%rax),%edx
  804271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804275:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804277:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80427c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804280:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804284:	72 a2                	jb     804228 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80428a:	c9                   	leaveq 
  80428b:	c3                   	retq   

000000000080428c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80428c:	55                   	push   %rbp
  80428d:	48 89 e5             	mov    %rsp,%rbp
  804290:	48 83 ec 40          	sub    $0x40,%rsp
  804294:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804298:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80429c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8042a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042a4:	48 89 c7             	mov    %rax,%rdi
  8042a7:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  8042ae:	00 00 00 
  8042b1:	ff d0                	callq  *%rax
  8042b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042c6:	00 
  8042c7:	e9 93 00 00 00       	jmpq   80435f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8042cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d4:	48 89 d6             	mov    %rdx,%rsi
  8042d7:	48 89 c7             	mov    %rax,%rdi
  8042da:	48 b8 72 40 80 00 00 	movabs $0x804072,%rax
  8042e1:	00 00 00 
  8042e4:	ff d0                	callq  *%rax
  8042e6:	85 c0                	test   %eax,%eax
  8042e8:	74 07                	je     8042f1 <devpipe_write+0x65>
				return 0;
  8042ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ef:	eb 7c                	jmp    80436d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8042f1:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  8042f8:	00 00 00 
  8042fb:	ff d0                	callq  *%rax
  8042fd:	eb 01                	jmp    804300 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8042ff:	90                   	nop
  804300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804304:	8b 40 04             	mov    0x4(%rax),%eax
  804307:	48 63 d0             	movslq %eax,%rdx
  80430a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80430e:	8b 00                	mov    (%rax),%eax
  804310:	48 98                	cltq   
  804312:	48 83 c0 20          	add    $0x20,%rax
  804316:	48 39 c2             	cmp    %rax,%rdx
  804319:	73 b1                	jae    8042cc <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80431b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431f:	8b 40 04             	mov    0x4(%rax),%eax
  804322:	89 c2                	mov    %eax,%edx
  804324:	c1 fa 1f             	sar    $0x1f,%edx
  804327:	c1 ea 1b             	shr    $0x1b,%edx
  80432a:	01 d0                	add    %edx,%eax
  80432c:	83 e0 1f             	and    $0x1f,%eax
  80432f:	29 d0                	sub    %edx,%eax
  804331:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804335:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804339:	48 01 ca             	add    %rcx,%rdx
  80433c:	0f b6 0a             	movzbl (%rdx),%ecx
  80433f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804343:	48 98                	cltq   
  804345:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804349:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80434d:	8b 40 04             	mov    0x4(%rax),%eax
  804350:	8d 50 01             	lea    0x1(%rax),%edx
  804353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804357:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80435a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80435f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804363:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804367:	72 96                	jb     8042ff <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80436d:	c9                   	leaveq 
  80436e:	c3                   	retq   

000000000080436f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80436f:	55                   	push   %rbp
  804370:	48 89 e5             	mov    %rsp,%rbp
  804373:	48 83 ec 20          	sub    $0x20,%rsp
  804377:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80437b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80437f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804383:	48 89 c7             	mov    %rax,%rdi
  804386:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  80438d:	00 00 00 
  804390:	ff d0                	callq  *%rax
  804392:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80439a:	48 be 7c 52 80 00 00 	movabs $0x80527c,%rsi
  8043a1:	00 00 00 
  8043a4:	48 89 c7             	mov    %rax,%rdi
  8043a7:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  8043ae:	00 00 00 
  8043b1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8043b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b7:	8b 50 04             	mov    0x4(%rax),%edx
  8043ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043be:	8b 00                	mov    (%rax),%eax
  8043c0:	29 c2                	sub    %eax,%edx
  8043c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043c6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8043cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8043d7:	00 00 00 
	stat->st_dev = &devpipe;
  8043da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043de:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8043e5:	00 00 00 
  8043e8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8043ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043f4:	c9                   	leaveq 
  8043f5:	c3                   	retq   

00000000008043f6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8043f6:	55                   	push   %rbp
  8043f7:	48 89 e5             	mov    %rsp,%rbp
  8043fa:	48 83 ec 10          	sub    $0x10,%rsp
  8043fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804406:	48 89 c6             	mov    %rax,%rsi
  804409:	bf 00 00 00 00       	mov    $0x0,%edi
  80440e:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  804415:	00 00 00 
  804418:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80441a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80441e:	48 89 c7             	mov    %rax,%rdi
  804421:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  804428:	00 00 00 
  80442b:	ff d0                	callq  *%rax
  80442d:	48 89 c6             	mov    %rax,%rsi
  804430:	bf 00 00 00 00       	mov    $0x0,%edi
  804435:	48 b8 07 1e 80 00 00 	movabs $0x801e07,%rax
  80443c:	00 00 00 
  80443f:	ff d0                	callq  *%rax
}
  804441:	c9                   	leaveq 
  804442:	c3                   	retq   
	...

0000000000804444 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804444:	55                   	push   %rbp
  804445:	48 89 e5             	mov    %rsp,%rbp
  804448:	48 83 ec 20          	sub    $0x20,%rsp
  80444c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80444f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804452:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804455:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804459:	be 01 00 00 00       	mov    $0x1,%esi
  80445e:	48 89 c7             	mov    %rax,%rdi
  804461:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  804468:	00 00 00 
  80446b:	ff d0                	callq  *%rax
}
  80446d:	c9                   	leaveq 
  80446e:	c3                   	retq   

000000000080446f <getchar>:

int
getchar(void)
{
  80446f:	55                   	push   %rbp
  804470:	48 89 e5             	mov    %rsp,%rbp
  804473:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804477:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80447b:	ba 01 00 00 00       	mov    $0x1,%edx
  804480:	48 89 c6             	mov    %rax,%rsi
  804483:	bf 00 00 00 00       	mov    $0x0,%edi
  804488:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  80448f:	00 00 00 
  804492:	ff d0                	callq  *%rax
  804494:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804497:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80449b:	79 05                	jns    8044a2 <getchar+0x33>
		return r;
  80449d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044a0:	eb 14                	jmp    8044b6 <getchar+0x47>
	if (r < 1)
  8044a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044a6:	7f 07                	jg     8044af <getchar+0x40>
		return -E_EOF;
  8044a8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8044ad:	eb 07                	jmp    8044b6 <getchar+0x47>
	return c;
  8044af:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8044b3:	0f b6 c0             	movzbl %al,%eax
}
  8044b6:	c9                   	leaveq 
  8044b7:	c3                   	retq   

00000000008044b8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8044b8:	55                   	push   %rbp
  8044b9:	48 89 e5             	mov    %rsp,%rbp
  8044bc:	48 83 ec 20          	sub    $0x20,%rsp
  8044c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8044c3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8044c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044ca:	48 89 d6             	mov    %rdx,%rsi
  8044cd:	89 c7                	mov    %eax,%edi
  8044cf:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  8044d6:	00 00 00 
  8044d9:	ff d0                	callq  *%rax
  8044db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044e2:	79 05                	jns    8044e9 <iscons+0x31>
		return r;
  8044e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e7:	eb 1a                	jmp    804503 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8044e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ed:	8b 10                	mov    (%rax),%edx
  8044ef:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8044f6:	00 00 00 
  8044f9:	8b 00                	mov    (%rax),%eax
  8044fb:	39 c2                	cmp    %eax,%edx
  8044fd:	0f 94 c0             	sete   %al
  804500:	0f b6 c0             	movzbl %al,%eax
}
  804503:	c9                   	leaveq 
  804504:	c3                   	retq   

0000000000804505 <opencons>:

int
opencons(void)
{
  804505:	55                   	push   %rbp
  804506:	48 89 e5             	mov    %rsp,%rbp
  804509:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80450d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804511:	48 89 c7             	mov    %rax,%rdi
  804514:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  80451b:	00 00 00 
  80451e:	ff d0                	callq  *%rax
  804520:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804523:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804527:	79 05                	jns    80452e <opencons+0x29>
		return r;
  804529:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80452c:	eb 5b                	jmp    804589 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80452e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804532:	ba 07 04 00 00       	mov    $0x407,%edx
  804537:	48 89 c6             	mov    %rax,%rsi
  80453a:	bf 00 00 00 00       	mov    $0x0,%edi
  80453f:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  804546:	00 00 00 
  804549:	ff d0                	callq  *%rax
  80454b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80454e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804552:	79 05                	jns    804559 <opencons+0x54>
		return r;
  804554:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804557:	eb 30                	jmp    804589 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80455d:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804564:	00 00 00 
  804567:	8b 12                	mov    (%rdx),%edx
  804569:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80456b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80456f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804576:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80457a:	48 89 c7             	mov    %rax,%rdi
  80457d:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  804584:	00 00 00 
  804587:	ff d0                	callq  *%rax
}
  804589:	c9                   	leaveq 
  80458a:	c3                   	retq   

000000000080458b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80458b:	55                   	push   %rbp
  80458c:	48 89 e5             	mov    %rsp,%rbp
  80458f:	48 83 ec 30          	sub    $0x30,%rsp
  804593:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804597:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80459b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80459f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045a4:	75 13                	jne    8045b9 <devcons_read+0x2e>
		return 0;
  8045a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ab:	eb 49                	jmp    8045f6 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8045ad:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  8045b4:	00 00 00 
  8045b7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8045b9:	48 b8 5e 1c 80 00 00 	movabs $0x801c5e,%rax
  8045c0:	00 00 00 
  8045c3:	ff d0                	callq  *%rax
  8045c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045cc:	74 df                	je     8045ad <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8045ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045d2:	79 05                	jns    8045d9 <devcons_read+0x4e>
		return c;
  8045d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d7:	eb 1d                	jmp    8045f6 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8045d9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8045dd:	75 07                	jne    8045e6 <devcons_read+0x5b>
		return 0;
  8045df:	b8 00 00 00 00       	mov    $0x0,%eax
  8045e4:	eb 10                	jmp    8045f6 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8045e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e9:	89 c2                	mov    %eax,%edx
  8045eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045ef:	88 10                	mov    %dl,(%rax)
	return 1;
  8045f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8045f6:	c9                   	leaveq 
  8045f7:	c3                   	retq   

00000000008045f8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045f8:	55                   	push   %rbp
  8045f9:	48 89 e5             	mov    %rsp,%rbp
  8045fc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804603:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80460a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804611:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804618:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80461f:	eb 77                	jmp    804698 <devcons_write+0xa0>
		m = n - tot;
  804621:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804628:	89 c2                	mov    %eax,%edx
  80462a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80462d:	89 d1                	mov    %edx,%ecx
  80462f:	29 c1                	sub    %eax,%ecx
  804631:	89 c8                	mov    %ecx,%eax
  804633:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804636:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804639:	83 f8 7f             	cmp    $0x7f,%eax
  80463c:	76 07                	jbe    804645 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80463e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804645:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804648:	48 63 d0             	movslq %eax,%rdx
  80464b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80464e:	48 98                	cltq   
  804650:	48 89 c1             	mov    %rax,%rcx
  804653:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80465a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804661:	48 89 ce             	mov    %rcx,%rsi
  804664:	48 89 c7             	mov    %rax,%rdi
  804667:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  80466e:	00 00 00 
  804671:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804673:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804676:	48 63 d0             	movslq %eax,%rdx
  804679:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804680:	48 89 d6             	mov    %rdx,%rsi
  804683:	48 89 c7             	mov    %rax,%rdi
  804686:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  80468d:	00 00 00 
  804690:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804692:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804695:	01 45 fc             	add    %eax,-0x4(%rbp)
  804698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80469b:	48 98                	cltq   
  80469d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8046a4:	0f 82 77 ff ff ff    	jb     804621 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8046aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8046ad:	c9                   	leaveq 
  8046ae:	c3                   	retq   

00000000008046af <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8046af:	55                   	push   %rbp
  8046b0:	48 89 e5             	mov    %rsp,%rbp
  8046b3:	48 83 ec 08          	sub    $0x8,%rsp
  8046b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8046bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046c0:	c9                   	leaveq 
  8046c1:	c3                   	retq   

00000000008046c2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8046c2:	55                   	push   %rbp
  8046c3:	48 89 e5             	mov    %rsp,%rbp
  8046c6:	48 83 ec 10          	sub    $0x10,%rsp
  8046ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8046d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d6:	48 be 88 52 80 00 00 	movabs $0x805288,%rsi
  8046dd:	00 00 00 
  8046e0:	48 89 c7             	mov    %rax,%rdi
  8046e3:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  8046ea:	00 00 00 
  8046ed:	ff d0                	callq  *%rax
	return 0;
  8046ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046f4:	c9                   	leaveq 
  8046f5:	c3                   	retq   
	...

00000000008046f8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8046f8:	55                   	push   %rbp
  8046f9:	48 89 e5             	mov    %rsp,%rbp
  8046fc:	48 83 ec 20          	sub    $0x20,%rsp
  804700:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  804704:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80470b:	00 00 00 
  80470e:	48 8b 00             	mov    (%rax),%rax
  804711:	48 85 c0             	test   %rax,%rax
  804714:	0f 85 8e 00 00 00    	jne    8047a8 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  80471a:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804721:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  804728:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  80472f:	00 00 00 
  804732:	ff d0                	callq  *%rax
  804734:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  804737:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80473b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80473e:	ba 07 00 00 00       	mov    $0x7,%edx
  804743:	48 89 ce             	mov    %rcx,%rsi
  804746:	89 c7                	mov    %eax,%edi
  804748:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  80474f:	00 00 00 
  804752:	ff d0                	callq  *%rax
  804754:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  804757:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80475b:	74 30                	je     80478d <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  80475d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804760:	89 c1                	mov    %eax,%ecx
  804762:	48 ba 90 52 80 00 00 	movabs $0x805290,%rdx
  804769:	00 00 00 
  80476c:	be 24 00 00 00       	mov    $0x24,%esi
  804771:	48 bf c7 52 80 00 00 	movabs $0x8052c7,%rdi
  804778:	00 00 00 
  80477b:	b8 00 00 00 00       	mov    $0x0,%eax
  804780:	49 b8 2c 06 80 00 00 	movabs $0x80062c,%r8
  804787:	00 00 00 
  80478a:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80478d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804790:	48 be bc 47 80 00 00 	movabs $0x8047bc,%rsi
  804797:	00 00 00 
  80479a:	89 c7                	mov    %eax,%edi
  80479c:	48 b8 e6 1e 80 00 00 	movabs $0x801ee6,%rax
  8047a3:	00 00 00 
  8047a6:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8047a8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047af:	00 00 00 
  8047b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8047b6:	48 89 10             	mov    %rdx,(%rax)
}
  8047b9:	c9                   	leaveq 
  8047ba:	c3                   	retq   
	...

00000000008047bc <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8047bc:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8047bf:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8047c6:	00 00 00 
	call *%rax
  8047c9:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  8047cb:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  8047cf:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  8047d3:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  8047d6:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8047dd:	00 
		movq 120(%rsp), %rcx				// trap time rip
  8047de:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  8047e3:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  8047e6:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  8047e7:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  8047ea:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8047f1:	00 08 
		POPA_						// copy the register contents to the registers
  8047f3:	4c 8b 3c 24          	mov    (%rsp),%r15
  8047f7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8047fc:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804801:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804806:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80480b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804810:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804815:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80481a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80481f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804824:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804829:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80482e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804833:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804838:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80483d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804841:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  804845:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  804846:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  804847:	c3                   	retq   

0000000000804848 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804848:	55                   	push   %rbp
  804849:	48 89 e5             	mov    %rsp,%rbp
  80484c:	48 83 ec 18          	sub    $0x18,%rsp
  804850:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804858:	48 89 c2             	mov    %rax,%rdx
  80485b:	48 c1 ea 15          	shr    $0x15,%rdx
  80485f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804866:	01 00 00 
  804869:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80486d:	83 e0 01             	and    $0x1,%eax
  804870:	48 85 c0             	test   %rax,%rax
  804873:	75 07                	jne    80487c <pageref+0x34>
		return 0;
  804875:	b8 00 00 00 00       	mov    $0x0,%eax
  80487a:	eb 53                	jmp    8048cf <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80487c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804880:	48 89 c2             	mov    %rax,%rdx
  804883:	48 c1 ea 0c          	shr    $0xc,%rdx
  804887:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80488e:	01 00 00 
  804891:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804895:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804899:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80489d:	83 e0 01             	and    $0x1,%eax
  8048a0:	48 85 c0             	test   %rax,%rax
  8048a3:	75 07                	jne    8048ac <pageref+0x64>
		return 0;
  8048a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8048aa:	eb 23                	jmp    8048cf <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048b0:	48 89 c2             	mov    %rax,%rdx
  8048b3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8048b7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8048be:	00 00 00 
  8048c1:	48 c1 e2 04          	shl    $0x4,%rdx
  8048c5:	48 01 d0             	add    %rdx,%rax
  8048c8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8048cc:	0f b7 c0             	movzwl %ax,%eax
}
  8048cf:	c9                   	leaveq 
  8048d0:	c3                   	retq   
